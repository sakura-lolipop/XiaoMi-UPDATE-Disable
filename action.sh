#!/system/bin/sh
echo "== 当前版本属性 =="
echo " 大版本: $(getprop ro.mi.os.version.incremental)"
echo " XMS:    $(getprop ro.mi.xms.version.incremental)"
echo " build:  $(getprop ro.build.version.incremental)"
CONF=/data/adb/love_spoof.conf
if [ -f "$CONF" ]; then
  echo " 配置文件: $CONF (存在)"
  . "$CONF"
  echo " 配置值: 大版本=$OS_INC XMS=$XMS_INC"
else
  echo " 配置文件未创建 (重装模块或用 WebUI 保存一次)"
fi
