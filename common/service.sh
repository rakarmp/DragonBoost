#!/system/bin/sh
MODDIR=${0%/*}
# Menulis data ke dalam berkas (file) jika berkas ada dan izin menulis sudah ada atau belum ada, 
# memberikan izin menulis jika belum ada, dan kemudian data ditulis ke dalam berkas tersebut.

# perbaikan dari commit @RiProG
# memeriksa apakah file yang dituju ada (-f "$path") Jika file ada maka kode akan memeriksa izin tulis file (! -w "$path") dan mengubahnya menjadi writable jika diperlukan (chmod +w "$path" 2> /dev/null) Setelah itu, kode akan menulis nilai baru ke dalam file (echo "$data" > "$path" 2> /dev/null) Jika ada kesalahan dalam menulis nilai baru ke dalam file, maka kode akan mencetak pesan "Failed: $path → $data" dan mengembalikan nilai 1

write() {
    local path="$1"
    local data="$2"

    if [ -d "$path" ]; then
        echo "Error: $path is a directory"
        return 1
    fi

    if [ ! -e "$path" ]; then
        echo "Error: $path does not exist"
        return 1
    fi

    if [ -f "$path" ]; then
        # Jika file tidak dapat ditulis
        if [ ! -w "$path" ]; then
            chmod +w "$path" 2>/dev/null || {
                echo "Error: Could not change permissions for $path"
                return 1
            }
        fi

        echo "$data" >"$path" 2>/dev/null || {
            echo "Error: Could not write to $path"
            return 1
        }

        echo "Success: $path → $data"
    fi
}


sleep 20
# adreno snapshot 
echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/snapshot_crashdumper
echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/dump
echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/force_panic

echo "1" > /sys/module/adreno_idler/parameters/adreno_idler_active

for rx in /sys/module/lpm_levels/parameters; do
    write $rx/lpm_ipi_prediction "0"
    write $rx/lpm_prediction "0"
    write $rx/sleep_disabled "0"
done

for gov in /sys/devices/system/cpu/*/cpufreq
  do
    echo "500" > $gov/schedutil/up_rate_limit_us
    echo "2000" > $gov/schedutil/down_rate_limit_us
    echo "85" > $gov/schedutil/hispeed_load
    echo "1" > $gov/schedutil/pl
    echo "0" > $gov/schedutil/iowait_boost_enable
  done
  
for rcct in /sys/devices/system/cpu/*/core_ctl
do
  chmod 666 $rcct/enable
  echo "0" > $rcct/enable
  chmod 444 $rcct/enable
done

for gpu in /sys/class/kgsl/kgsl-3d0
do
  echo "0" > $gpu/adrenoboost
  echo "0" > $gpu/devfreq/adrenoboost
  echo "0" > $gpu/throttling
  echo "0" > $gpu/bus_split
  echo "1" > $gpu/force_clk_on
  echo "1" > $gpu/force_bus_on
  echo "1" > $gpu/force_rail_on
  echo "1" > $gpu/force_no_nap
  echo "80" > $gpu/idle_timer
  echo "0" > $gpu/max_pwrlevel
done

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

echo "3" > /proc/sys/vm/drop_caches

echo "1" > /dev/cpuset/sched_relax_domain_level
echo "1" > /dev/cpuset/system-background/sched_relax_domain_level
echo "1" > /dev/cpuset/background/sched_relax_domain_level
echo "1" > /dev/cpuset/camera-background/sched_relax_domain_level
echo "1" > /dev/cpuset/foreground/sched_relax_domain_level
echo "1" > /dev/cpuset/top-app/sched_relax_domain_level
echo "1" > /dev/cpuset/restricted/sched_relax_domain_level
echo "1" > /dev/cpuset/asopt/sched_relax_domain_level
echo "1" > /dev/cpuset/camera-daemon/sched_relax_domain_level
echo "0" > /proc/sys/kernel/sched_schedstats
echo "0" > /proc/sys/kernel/sched_boost
echo "0" > /proc/sys/kernel/sched_tunable_scaling
echo "1" > /proc/sys/kernel/timer_migration
echo "25" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "1" > /proc/sys/kernel/sched_autogroup_enabled
echo "0" > /proc/sys/kernel/sched_child_runs_first
echo "32" > /proc/sys/kernel/sched_nr_migrate

sleep 20

su -lp 2000 -c "cmd notification post -S bigtext -t 'DragonBoost' 'Tag' 'DragonBoost Successfully Installed, Have Fun Boost Your Game!!!'" > /dev/null 2>&1

exit 0