#!/system/bin/sh
# 兜底层：boot 完成后应用配置；无配置文件时用内置默认 (Love/🌸)
CONF=/data/adb/love_spoof.conf
RP=""
for p in /data/adb/ksu/bin/resetprop /data/adb/magisk/resetprop /data/adb/ap/bin/resetprop; do
  [ -x "$p" ] && RP="$p" && break
done
[ -z "$RP" ] && RP=$(command -v resetprop 2>/dev/null)
[ -z "$RP" ] && exit 0
if [ -f "$CONF" ]; then
  . "$CONF"
else
  OS_INC=Love; OS_NAME=Love; OS_CODE=Love; BUILD_INC=Love; SYS_INC=Love; XMS_INC=🌸
fi
(
  while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done
  sleep 3
  [ -n "$OS_INC" ] && "$RP" -n ro.mi.os.version.incremental "$OS_INC"
  [ -n "$OS_NAME" ] && "$RP" -n ro.mi.os.version.name "$OS_NAME"
  [ -n "$OS_CODE" ] && "$RP" -n ro.mi.os.version.code "$OS_CODE"
  [ -n "$BUILD_INC" ] && "$RP" -n ro.build.version.incremental "$BUILD_INC"
  [ -n "$SYS_INC" ] && "$RP" -n ro.system.build.version.incremental "$SYS_INC"
  [ -n "$XMS_INC" ] && "$RP" -n ro.mi.xms.version.incremental "$XMS_INC"
  sleep 10
  [ -n "$OS_INC" ] && "$RP" -n ro.mi.os.version.incremental "$OS_INC"
  [ -n "$OS_NAME" ] && "$RP" -n ro.mi.os.version.name "$OS_NAME"
  [ -n "$OS_CODE" ] && "$RP" -n ro.mi.os.version.code "$OS_CODE"
  [ -n "$BUILD_INC" ] && "$RP" -n ro.build.version.incremental "$BUILD_INC"
  [ -n "$SYS_INC" ] && "$RP" -n ro.system.build.version.incremental "$SYS_INC"
  [ -n "$XMS_INC" ] && "$RP" -n ro.mi.xms.version.incremental "$XMS_INC"
) &
exit 0
