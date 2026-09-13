# XiaoMi-UPDATE-Disable

不让 HyperOS 自动更新。一个模块，版本号随便改。

## 包里有什么

| 文件 | 说明 |
|---|---|
| `MIUI_Updater_Ban_v1.0_original.zip` | 后宫学长的原版模块，本项目起点。改 3 个版本号属性 + 一个卸载开关 |
| `Love_sakura_v1.3.zip` | 实验版：把版本号改成 `Love.🌸` 的固定值 |
| `XiaoMi-UPDATE-Disable_v2.0.zip` | **主推**。模块自带 WebUI，版本号随手改，不用再打包 |

图省事直接刷第三个，装完在 KernelSU 管理器里点模块的 WebUI 按钮就行。

## 原理

系统更新第一步：拿当前版本号问小米服务器有没有新的。服务器看不懂 `Love.🌸`，答不上来，后面下载安装自然全停。

顺带解释一个老问题："明明关了自动更新还是被升"。因为服务端下发的策略能越过手机上的开关，改开关不可靠，让服务器认不出你的版本才可靠。


## 完全版 v2.1

`XiaoMi-UPDATE-Disable_v2.1_full.zip`，和 v2.0 的区别：

- 三时机应用：`post-fs-data.sh`（常规 root 开机早期）/ `late-load.sh`（late-load exploit 触发时）/ `service.sh`（boot 完成兜底），哪条路都能生效
- 没有配置文件也能跑：内置默认 `Love.🌸`，装上重启就有
- WebUI、还原基准、配置文件路径都与 v2.0 相同


## 完全版 v2.3

行为模型（重要）：

- **启用期间**：版本号持久化落盘，重启后即使没跑 exploit 也继续防更新 —— 落盘是特性不是 bug
- **卸载时**：uninstall.sh 自动还原真值（优先用安装时快照，快照不可用则从 fingerprint 提取），无需手动清理
- **手动逃生**：WebUI「🧠 智能还原」随时可从 fingerprint 一键写回真值
- 历史版本（v1.x/v2.0/v2.1/v2.2）卸载后若有残留，装一次 v2.3 再卸载即可清除

## 用之前

- KernelSU / Magisk / APatch 任一（只在 KernelSU late-load 模式下实测过）
- 如果你的 root 来自 exploit 链，注意有的链会校验版本串，版本号改了它可能罢工
- 全程只改运行时属性，卸载重启即还原


## v2.0 的用法

装好模块，KernelSU 管理器 → 模块 → WebUI：

- 两个输入框：大版本、XMS 小版本（后面那串 `D00` 之类就是它）
- ⚡ 立即应用：root 在的话秒生效
- 📈 保格式防推预设：`OS99.99.99.99.XPNCNXM`，不想赌服务器对乱码版本号的态度就用这个
- ↩️ 还原真实：一键回到原版本号

配置在 `/data/adb/love_spoof.conf`，安装时自动记下你的真实版本号，还原按钮用。

## late-load 用户

KSU late-load 模式下 `post-fs-data.sh` 不执行，原版的 `system.prop` 等于摆设。v2.0 的生效逻辑在 `late-load.sh`，exploit 一跑完就应用。常规 root 用户有 `service.sh` 开机兜底。

## 原版的坑

- `system.prop` 在 late-load 下时序不对
- `action.sh` 用 `pm uninstall`，HyperOS 4 上系统应用卸不干净，会被装回来
- 版本号键漏了三处：`ro.mi.os.version.name` / `code` / `ro.mi.xms.version.incremental`

## 版本号后面那串 D00 是什么

`ro.mi.xms.version.incremental`，XMS 小版本通道的标记（不发整包、静默替换单个系统 APK 那条轨道）。显示时拼在大版本号后面，所以有 `love.D00` 这种组合。v2.0 把它一起改了。

## 最后

改自己设备，风险自担。小米服务端怎么解析不认识的版本号没有公开文档，乱码版好玩，`OS99.99.99.99.XPNCNXM` 稳妥，自己选。

Author: Lolipop
