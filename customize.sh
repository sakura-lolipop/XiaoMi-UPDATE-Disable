ui_print "- XiaoMi-UPDATE-Disable v2.1 完全版"
ui_print "- 支持: 常规 Magisk/KSU 与 late-load 模式"
CONF=/data/adb/love_spoof.conf
if [ ! -f "$CONF" ]; then
  cat > "$CONF" <<EOC
OS_INC=Love
OS_NAME=Love
OS_CODE=Love
BUILD_INC=Love
SYS_INC=Love
XMS_INC=🌸
ORIG_OS_INC=$(getprop ro.mi.os.version.incremental)
ORIG_XMS_INC=$(getprop ro.mi.xms.version.incremental)
EOC
  ui_print "- 初始配置: Love.🌸 (WebUI 可改)"
else
  ui_print "- 保留已有配置"
fi
set_perm_recursive "$MODPATH" 0 0 0755 0644
