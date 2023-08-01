MODDIR=${0%/*}

# Menulis data ke dalam berkas (file) jika berkas ada dan izin menulis sudah ada atau belum ada, 
# memberikan izin menulis jika belum ada, dan kemudian data ditulis ke dalam berkas tersebut.

# perbaikan dari commit @RiProG
# memeriksa apakah file yang dituju ada (-f "$path") Jika file ada maka kode akan memeriksa izin tulis file (! -w "$path") dan mengubahnya menjadi writable jika diperlukan (chmod +w "$path" 2> /dev/null) Setelah itu, kode akan menulis nilai baru ke dalam file (echo "$data" > "$path" 2> /dev/null) Jika ada kesalahan dalam menulis nilai baru ke dalam file, maka kode akan mencetak pesan "Failed: $path → $data" dan mengembalikan nilai 1
write() {
    local path="$1"
    local data="$2"

    if [ -f "$path" ]; then
        if [ ! -w "$path" ]; then
            chmod +w "$path" 2> /dev/null
        fi

        if ! echo "$data" > "$path" 2> /dev/null; then
            echo "Failed: $path → $data"
            return 1
        fi
    fi
}

write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpufreq/policy0/scaling_governor performance
write /sys/devices/system/cpu/cpufreq/policy4/scaling_governor performance
write /sys/devices/system/cpu/cpufreq/performance/above_hispeed_delay 0
write /sys/devices/system/cpu/cpufreq/performance/boost 1
write /sys/devices/system/cpu/cpufreq/performance/go_hispeed_load 75
write /sys/devices/system/cpu/cpufreq/performance/max_freq_hysteresis 1
write /sys/devices/system/cpu/cpufreq/performance/align_windows 1
write /sys/kernel/gpu/gpu_governor performance
write /sys/module/adreno_idler/parameters/adreno_idler_active 0
write /sys/module/lazyplug/parameters/nr_possible_cores 8
write /sys/module/msm_performance/parameters/touchboost 1
write /dev/cpuset/foreground/boost/cpus 4-7
write /dev/cpuset/foreground/cpus 0-3,4-7
write /dev/cpuset/top-app/cpus 0-7

# mengoptimalkan penggunaan memori pada sistem
# mengatur swap, ukuran disk dan batas memori, mengatur parameter VM, mengaktifkan oom_reaper
# mengatur minfree untuk lowmemorykiller


swapoff /dev/block/zram0
echo "1" > /sys/block/zram0/reset
echo "4294967296" > /sys/block/zram0/disksize
echo "4096M" > /sys/block/zram0/mem_limit
echo "8" > /sys/block/zram0/max_comp_streams
mkswap /dev/block/zram0
swapon /dev/block/zram0
echo "100" > /proc/sys/vm/swappiness
echo "10" > /proc/sys/vm/dirty_background_ratio
echo "100" > /proc/sys/vm/vfs_cache_pressure
echo "1" > /proc/sys/vm/overcommit_memory
echo "500" > /proc/sys/vm/dirty_writeback_centisecs
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "0" > /proc/sys/vm/block_dump
echo "1" > /sys/module/lowmemorykiller/parameters/oom_reaper
chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree
echo "14535,29070,43605,58112,72675,87210" > /sys/module/lowmemorykiller/parameters/minfree
chmod 444 /sys/module/lowmemorykiller/parameters/minfree

sleep 40

# mengatur swap_ratio, dirty_expire_centisecs, laptop_mode, page-cluster, stat_interval, watermark_scale_factor, min_free_kbytes, extra_free_kbytes, extfrag_threshold, dirty_ratio, enable_adaptive_lmk, enable_lmk, debug_level, dan menghapus file default_values
# singkatnya ini untuk mensetting vm (virtual memory)

echo "100" > /proc/sys/vm/swap_ratio
echo "0" > /proc/sys/vm/swap_ratio_enable
echo "3000" > /proc/sys/vm/dirty_expire_centisecs
echo "0" > /proc/sys/vm/laptop_mode
echo "0" > /proc/sys/vm/page-cluster
echo "10" > /proc/sys/vm/stat_interval
echo "32" > /proc/sys/vm/watermark_scale_factor
echo "11007" > /proc/sys/vm/min_free_kbytes
echo "29615" > /proc/sys/vm/extra_free_kbytes
echo "750" > /proc/sys/vm/extfrag_threshold
echo "30" > /proc/sys/vm/dirty_ratio
echo "0" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "0" > /sys/module/lowmemorykiller/parameters/enable_lmk
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
rm /data/system/perfd/default_values

# penerapan OOM (out of memory)
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "0" > /proc/sys/vm/panic_on_oom
echo "0" > /proc/sys/vm/reap_mem_on_sigkill

# commit RAM
echo "50" > /proc/sys/vm/overcommit_ratio
echo "0" > /proc/sys/vm/compact_unevictable_allowed
echo "1" > /proc/sys/vm/compact_memory

# Pengoptimalan Activity Manager
if [ $(getprop ro.build.version.sdk) -gt 28 ]; then
  device_config set_sync_disabled_for_tests persistent
  device_config put activity_manager max_phantom_processes 2147483647
  device_config put activity_manager max_cached_processes 256
  device_config put activity_manager max_empty_time_millis 43200000
  settings put global settings_enable_monitor_phantom_procs false
else
  settings put global activity_manager_constants max_cached_processes=256
fi

# Pengoptimalan IO memberikan ram terbaik
for scheduler in /sys/block/*/queue; do
    write $scheduler/scheduler "deadline"
    write $scheduler/iostats "0"
    write $scheduler/add_random "0"
    write $scheduler/nomerges "0"
    write $scheduler/rq_affinity "2"
    write $scheduler/rotational "0"
    write $scheduler/read_ahead_kb "128"
    write $scheduler/nr_requests "128"
done

for iosched in /sys/block/*/iosched; do
    write $iosched/slice_idle "0"
    write $iosched/slice_idle_us "0"
    write $iosched/group_idle "8"
    write $iosched/group_idle_us "8000"
    write $iosched/low_latency "1"
done

# mengatur prioritas dan alokasi sumber daya I/O blok antara grup utama dan grup latar belakang
if [ -d /dev/blkio ]; then
  echo "1000" > /dev/blkio/blkio.weight
  echo "200" > /dev/blkio/background/blkio.weight
  echo "2000" > /dev/blkio/blkio.group_idle
  echo "0" > /dev/blkio/background/blkio.group_idle
fi

# Entropy : Uji stabilitas dan apakah menghasilkan konsistensi
echo "64" > /proc/sys/kernel/random/read_wakeup_threshold
echo "512" > /proc/sys/kernel/random/write_wakeup_threshold

# Zram Read
echo "0" > /sys/fs/f2fs_dev/mmcblk0p79/iostat_enable
echo "512" > /sys/block/zram0/queue/read_ahead_kb

# Mematikan rendering RAM
echo "0" > /sys/module/subsystem_restart/parameters/enable_ramdumps
echo "0" > /sys/module/subsystem_restart/parameters/enable_mini_ramdumps

sleep 20

# Menghapus RAM
sync
echo "3" > /proc/sys/vm/drop_caches
am kill-all

exit 0