#!/system/bin/sh
# KSU late-load: exploit 触发瞬间读取配置应用
CONF=/data/adb/love_spoof.conf
RP=""
for p in /data/adb/ksu/bin/resetprop /data/adb/magisk/resetprop /data/adb/ap/bin/resetprop; do
  [ -x "$p" ] && RP="$p" && break
done
[ -z "$RP" ] && RP=$(command -v resetprop 2>/dev/null)
if [ -z "$RP" ] || [ ! -f "$CONF" ]; then exit 0; fi
. "$CONF"
[ -n "$OS_INC" ] && "$RP" -n ro.mi.os.version.incremental "$OS_INC" 2>/dev/null
[ -n "$OS_NAME" ] && "$RP" -n ro.mi.os.version.name "$OS_NAME" 2>/dev/null
[ -n "$OS_CODE" ] && "$RP" -n ro.mi.os.version.code "$OS_CODE" 2>/dev/null
[ -n "$BUILD_INC" ] && "$RP" -n ro.build.version.incremental "$BUILD_INC" 2>/dev/null
[ -n "$SYS_INC" ] && "$RP" -n ro.system.build.version.incremental "$SYS_INC" 2>/dev/null
[ -n "$XMS_INC" ] && "$RP" -n ro.mi.xms.version.incremental "$XMS_INC" 2>/dev/null
exit 0
