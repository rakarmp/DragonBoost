#!/system/bin/sh

# Menulis data ke dalam berkas (file) jika berkas ada dan izin menulis sudah ada atau belum ada,
# memberikan izin menulis jika belum ada, dan kemudian data ditulis ke dalam berkas tersebut.
write() {
    local path="$1"
    local data="$2"

    if [ -f "$path" ] && [ -w "$path" ]; then
        echo "$data" >"$path"
    elif [ -f "$path" ]; then
        chmod +w "$path"
        echo "$data" >"$path"
    fi
}

# Fungsi untuk menulis pesan log ke file
write_log() {
    local log_file="/data/adb/modules/DragonBoost/log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>"$log_file"
}

# Fungsi untuk mengeksekusi perintah shell dan mencatat ke log
# execute_and_log() {
#     local cmd="$1"
#     local log_file="/data/adb/modules/DragonBoost/log.txt"
#     $cmd >>"$log_file" 2>&1
# }

# Mendapatkan ukuran RAM perangkat dalam MB
# get_ram_size() {
#     local ram_kb=$(cat /proc/meminfo | grep "MemTotal" | awk '{print $2}')
#     local ram_mb=$((ram_kb / 1024))
#     echo "$ram_mb"
# }

# Mendapatkan ukuran RAM
# ram_size=$(get_ram_size)

# Jangan merubah apapun yang ada disini!
MODDIR=${0%/*}
write /proc/sys/vm/page-cluster 0
write /sys/block/zram0/max_comp_streams 4

# Mengatur variabel heap berdasarkan ukuran RAM
# if [ "$ram_size" -ge 6144 ]; then
#     dalvik_heap_start=32
#     dalvik_heap_growth=384
#     dalvik_heap_size=2048
#     dalvik_heap_min_free=32
#     dalvik_heap_max_free=64
# elif [ "$ram_size" -ge 5120 ]; then
#     dalvik_heap_start=16
#     dalvik_heap_growth=320
#     dalvik_heap_size=1536
#     dalvik_heap_min_free=16
#     dalvik_heap_max_free=32
# elif [ "$ram_size" -ge 4096 ]; then
#     dalvik_heap_start=16
#     dalvik_heap_growth=256
#     dalvik_heap_size=1024
#     dalvik_heap_min_free=8
#     dalvik_heap_max_free=16
# elif [ "$ram_size" -ge 3072 ]; then
#     dalvik_heap_start=64
#     dalvik_heap_growth=256
#     dalvik_heap_size=512
#     dalvik_heap_min_free=4
#     dalvik_heap_max_free=8
# elif [ "$ram_size" -ge 2048 ]; then
#     dalvik_heap_start=64
#     dalvik_heap_growth=192
#     dalvik_heap_size=512
#     dalvik_heap_min_free=4
#     dalvik_heap_max_free=8
# else
#     write_log "Tidak ada eksekusi perintah untuk kondisi ini."
#     exit 0
# fi

# # Mengatur properti heap Dalvik VM sesuai dengan ukuran RAM
# execute_and_log "setprop dalvik.vm.heapstartsize ${dalvik_heap_start}m"
# execute_and_log "setprop dalvik.vm.heapgrowthlimit ${dalvik_heap_growth}m"
# execute_and_log "setprop dalvik.vm.heapsize ${dalvik_heap_size}m"
# execute_and_log "setprop dalvik.vm.heapminfree ${dalvik_heap_min_free}m"
# execute_and_log "setprop dalvik.vm.heapmaxfree ${dalvik_heap_max_free}m"

# # Menambahkan pesan log untuk menunjukkan bahwa setprop telah dijalankan
write_log "Pengaturan heap Dalvik VM telah diperbarui."

# Settingan Untuk Mempercepat GPU Ke performance
setprop debug.hwui.renderer skiagl
setprop debug.composition.type c2d
setprop debug.enabletr true
setprop debug.overlayui.enable 1
setprop debug.performance.tuning 1
setprop hw3d.force 1
setprop hwui.disable_vsync true
setprop hwui.render_dirty_regions false
setprop persist.sys.composition.type c2d
setprop persist.sys.ui.hw 1
setprop ro.config.enable.hw_accel true
setprop ro.product.gpu.driver 1
setprop ro.fb.mode 1
setprop ro.sf.compbypass.enable 0
setprop video.accelerate.hw 1
setprop debug.egl.hw 0
setprop debug.gralloc.gfx_ubwc_disable 0
setprop debug.mdpcomp.logs 0
setprop persist.vendor.color.matrix 2
setprop vendor.gralloc.disable_ubwc 0
setprop ro.vendor.qti.sys.fw.bg_apps_limit 120
setprop ro.vendor.qti.sys.fw.bservice_enable true
setprop ro.vendor.qti.core.ctl_max_cpu 4
setprop ro.vendor.qti.core.ctl_min_cpu 2

setprop persist.sys.dalvik.hyperthreading true
setprop persist.sys.dalvik.multithread true
