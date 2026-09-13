#!/system/bin/sh
# 常规 Magisk/KSU（非 late-load）模式：boot 早期应用配置
# late-load 模式下此脚本不会执行，由 late-load.sh 接管
CONF=/data/adb/love_spoof.conf
RP=""
for p in /data/adb/ksu/bin/resetprop /data/adb/magisk/resetprop /data/adb/ap/bin/resetprop; do
  [ -x "$p" ] && RP="$p" && break
done
[ -z "$RP" ] && RP=$(command -v resetprop 2>/dev/null)
if [ -z "$RP" ] || [ ! -f "$CONF" ]; then exit 0; fi
. "$CONF"
[ -n "$OS_INC" ] && "$RP" ro.mi.os.version.incremental "$OS_INC" 2>/dev/null
[ -n "$OS_NAME" ] && "$RP" ro.mi.os.version.name "$OS_NAME" 2>/dev/null
[ -n "$OS_CODE" ] && "$RP" ro.mi.os.version.code "$OS_CODE" 2>/dev/null
[ -n "$BUILD_INC" ] && "$RP" ro.build.version.incremental "$BUILD_INC" 2>/dev/null
[ -n "$SYS_INC" ] && "$RP" ro.system.build.version.incremental "$SYS_INC" 2>/dev/null
[ -n "$XMS_INC" ] && "$RP" ro.mi.xms.version.incremental "$XMS_INC" 2>/dev/null
exit 0
