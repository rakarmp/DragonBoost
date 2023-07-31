#!/system/bin/sh

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

# Jangan merubah apapun yang ada disini!
MODDIR=${0%/*}
write /proc/sys/vm/page-cluster 0
write /sys/block/zram0/max_comp_streams 4

# Settingan Untuk Mempercepat GPU Ke performance
setprop debug.composition.type c2d
setprop debug.composition.type gpu
setprop debug.enabletr true
setprop debug.overlayui.enable 1
setprop debug.performance.tuning 1
setprop hw3d.force 1
setprop hwui.disable_vsync true
setprop hwui.render_dirty_regions false
setprop persist.sys.composition.type c2d
setprop persist.sys.composition.type gpu
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

