SKIPUNZIP=0
## Variables
#
# MAGISK_VER (string): the version string of current installed Magisk (e.g. v20.0)
# MAGISK_VER_CODE (int): the version code of current installed Magisk (e.g. 20000)
# BOOTMODE (bool): true if the module is being installed in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module’s installation zip
# ARCH (string): the CPU architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device (e.g. 21 for Android 5.0)
#

## Function
# ui_print <msg>
#   print <msg> to console
#   Avoid using 'echo' as it will not display in custom recovery's console
# abort <msg>
#   print error message <msg> to console and terminate installation
#   Avoid using 'exit' as it will skip the termination cleanup steps
# set_perm <target> <owner> <group> <permission> [context]
#   if [context] is not set, the default is "u:object_r:system_file:s0"
#   this function is a shorthand for the following commands:
#      chown owner.group target
#      chmod permission target
#      chcon context target
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#   if [context] is not set, the default is "u:object_r:system_file:s0"
#   for all files in <directory>, it will call:
#      set_perm file owner group filepermission context
#   for all directories in <directory> (including itself), it will call:
#      set_perm dir owner group dirpermission context

## print word
ui_print "Universal system thermal killer | @Zyarexx Telegram"

### fix module command
bin=xbin
if [ ! -d system/xbin ]; then
    bin=bin
    mkdir $MODPATH/system/$bin
    mv $MODPATH/system/xbin/* $MODPATH/system/$bin
    rm -rf $MODPATH/system/xbin/*
    rmdir $MODPATH/system/xbin
fi
function FindThermal() {
    for systemThermal in $(ls $1 | grep $2); do
        if [[ "$systemThermal" == *"-BlankFile"* ]]; then
            ui_print "ignoring conflict file : $1/$systemThermal"
        elif [[ "$systemThermal" == *"-OriFile.bck"* ]]; then
            ui_print "ignoring conflict file : $1/$systemThermal"
        else
            ui_print "found $1/$systemThermal"
            if [ $2 == "thermal" ]; then
                if [ ! -f "$3/$systemThermal-BlankFile" ]; then
                    echo "" >"$3/$systemThermal-BlankFile"
                fi
                if [ ! -f "$3/$systemThermal-OriFile.bck" ]; then
                    cp -af "$1/$systemThermal" "$3/$systemThermal-OriFile.bck"
                fi
                cp -af "$3/$systemThermal-BlankFile" "$3/$systemThermal"
            else
                if [ ! -f "$3/$systemThermal" ]; then
                    cp -af "$1/$systemThermal" "$3/$systemThermal"
                fi
            fi
        fi
    done
}
FindThermal "/system/bin" '"-OriFile.bck"' "$MODPATH/system/bin"
FindThermal "/system/bin" 'thermal' "$MODPATH/system/bin"
FindThermal "/vendor/bin" '"-OriFile.bck"' "$MODPATH/system/vendor/bin"
FindThermal "/vendor/bin" 'thermal' "$MODPATH/system/vendor/bin"
FindThermal "/vendor/etc" '"-OriFile.bck"' "$MODPATH/system/vendor/etc"
FindThermal "/vendor/etc" 'thermal' "$MODPATH/system/vendor/etc"
echo "0" >"$MODPATH/system/vendor/etc/thermalStatus.info"

### fix folder permission
set_perm_recursive $MODPATH 0 0 0755 0777
set_perm_recursive $MODPATH/system/$bin 0 0 0755 0777
if [ $bin == "xbin" ]; then
    set_perm_recursive $MODPATH/system/bin 0 0 0755 0777
fi
set_perm_recursive $MODPATH/system/vendor/bin 0 0 0755 0777
set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0644
set_perm_recursive $MODPATH/system/etc/zyc_tk 0 0 0755 0777

echo "$NVBASE/modules" >/data/magisk_path.txt
