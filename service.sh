#!/system/bin/sh
# 常规模式兜底: boot 完成后幂等重放
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
