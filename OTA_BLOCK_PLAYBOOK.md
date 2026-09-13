# HyperOS 防（自动）更新 Playbook — lhasa 实测定稿

> 适用：HyperOS 4 · CN 固件 · BL 锁定 · KernelSU late-load（非持久 root）
> 原理依据：updater v9.7.1 全量反编译 + 上机实测（详见 xiaomiversion.md）

## 核心事实

- 更新链是串联管线：**检查 → 下载 → 安装**，掐死任一环即全断；掐"检查"是上游断路（服务端强制策略搭在检查响应上，检查断则策略到不了手机）
- 用户开关（`auto_download=0` 等）**不是权威**：服务端 policy（`updateS=1`、`download=2+level>1`）可越过；`ota_disable_automatic_update` 是死键（updater 不读）
- 静默安装硬编码窗口：**凌晨 1:00–6:00**，电量门槛 20%/30%（forceUpdate 只降电量门）
- 自我保活：updater 自身无保活代码；"复活"来自系统侧（framework/SecurityCenter，未定位到具体组件）
- 检查主接口：`update.miui.com/updates/miotaV3.php`（账号/商店不依赖此域）

## 三层防线（按可靠性排序）

### 第 0 层：DNS 黑洞（网络侧，零依赖、绝对持久）

路由器/AdGuard Home 屏蔽：`update.miui.com`、`hugeota.d.miui.com`、`bigota.d.miui.com`、`file.update.miui.com`
（现成清单：FreeFromMi hosts / AWAvenue 规则）

- 复活了也连不上；任何网络环境常驻
- 副作用：系统更新页报网络错误（本就是目的）

### 第 1 层：一次 root 窗口写入、系统代为执行（重启存活）

| 手段 | 命令/操作 | 说明 |
|---|---|---|
| 版本号毒化 | 本仓库模块（resetprop 落盘）或 WebUI 设值 | 服务器认不出你的版本；**每次开机 exploit 后由 late-load.sh 自动重放** |
| IFW 规则 | `/data/system/ifw/` 写 XML（Block-OTA-Update 项目可参考） | system_server 常驻执行，重启存活；HyperOS 4 未实测 |
| 占位文件 | `mkdir /data/media/0/Download/downloaded_rom && chattr +i …` | 挡下载落地目录；`+i` 连 root 都删不掉（需 CAP_LINUX_IMMUTABLE + SELinux 双关） |

### 第 2 层：包管理冻结（root 活着时打，每次开机后可能需重打）

```bash
pm suspend com.android.updater        # HyperOS 4 主推；disable-user 有被系统拉活的报告
# 恢复：pm suspend --user 0 -r … / pm disable 相关命令见 LSPosed 管理器
```

- **禁止** `pm uninstall --user 0`：OS4 卸不干净（预装目录会装回），且有系统组件崩溃先例
- **禁止** 动 `com.android.providers.downloads`：全系统共享下载引擎（商店/浏览器/DocumentsUI 同用）
- KSU 模块的 `late-load.sh` 在 exploit 触发时自动重打（`post-fs-data.sh` 在 late-load 模式不执行，别放那）

## 推荐组合（本机定稿）

1. ** AdGuard Home 黑洞** update.miui.com 系（一次配置永久）
2. ** 本仓库毒化模块**（每次 exploit 自动重放）+ WebUI 需要时改值
3. 可选：IFW / immutable 占位（一次写入长期兜底）

## 已知副作用与坑

| 坑 | 说明 |
|---|---|
| 超级小爱输入法提示"需要 HyperOS 4.0" | 版本键回显非数字串导致其门禁 `toIntOrNull` 判死 → 用保格式预设，或给该 App 单独喂真值（XSharedPreferences/作用域精准回显） |
| resetprop 对 ro. 键默认落盘 | 卸载模块**不会**自动还原；清除需 resetprop 写回真值（模块卸载钩子已实现自动还原） |
| "关了自动更新还是被升" | 服务端 policy 越权（见上），只关开关不可靠 |
| 演示机（`_demo` 后缀） | 存在无视一切开关的强制升级分支，消费机不受影响但说明厂商保留了强制通道 |
