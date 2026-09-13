#!/system/bin/sh
# 卸载模块时自动还原真值（Magisk/KSU 在删除模块前以 root 执行本脚本）
CONF=/data/adb/love_spoof.conf
RP=""
for p in /data/adb/ksu/bin/resetprop /data/adb/magisk/resetprop /data/adb/ap/bin/resetprop; do
  [ -x "$p" ] && RP="$p" && break
done
[ -z "$RP" ] && RP=$(command -v resetprop 2>/dev/null)
[ -z "$RP" ] && exit 0

# 还原优先级：ORIG_* 快照 > fingerprint 提取 > 跳过
FP=$(getprop ro.build.fingerprint 2>/dev/null)
INC=$(echo "$FP" | sed 's|.*/\(OS[0-9][^:]*\):user/release-keys.*|\1|p;d')
if [ -f "$CONF" ]; then
  . "$CONF"
  T_INC="${ORIG_OS_INC:-$INC}"
  T_XMS="${ORIG_XMS_INC:-}"
elif [ -n "$INC" ]; then
  T_INC="$INC"
  T_XMS=""
else
  exit 0
fi
[ -n "$T_INC" ] || exit 0
NAME=$(echo "$T_INC" | sed 's|^\(OS[0-9]*\.[0-9]*\)\..*|\1|p;d')
CODE=$(echo "$T_INC" | sed 's|^OS\([0-9]*\)\..*|\1|p;d')
"$RP" ro.mi.os.version.incremental "$T_INC" 2>/dev/null
[ -n "$NAME" ] && "$RP" ro.mi.os.version.name "$NAME" 2>/dev/null
[ -n "$CODE" ] && "$RP" ro.mi.os.version.code "$CODE" 2>/dev/null
"$RP" ro.build.version.incremental "$T_INC" 2>/dev/null
"$RP" ro.system.build.version.incremental "$T_INC" 2>/dev/null
[ -n "$T_XMS" ] && "$RP" ro.mi.xms.version.incremental "$T_XMS" 2>/dev/null
exit 0
