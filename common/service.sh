MODDIR=${0%/*}

# Menulis data ke dalam berkas (file) jika berkas ada dan izin menulis sudah ada atau belum ada, 
# memberikan izin menulis jika belum ada, dan kemudian data ditulis ke dalam berkas tersebut.
write() {
    local path="$1"
    local data="$2"

    if [ -f "$path" ] && { [ ! -w "$path" ] || [ -w "$path" ]; }; then
        [ ! -w "$path" ] && chmod +w "$path"
        echo "$data" > "$path"
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
