# thermo-use

How this Mac is doing, for AI agents: why it is slow (load, memory pressure, swap, thermal
throttling, the programs behind it), temperatures, fans, power, battery, and the disk space held
by AI tools — through the `thermo` CLI of [Thermo](https://app.leeguoo.com/thermo). Part of the
`*-use` family ([leeguooooo/plugins](https://github.com/leeguooooo/plugins)).

```sh
curl -fsSL https://raw.githubusercontent.com/leeguooooo/thermo-use/main/install.sh | sh
thermo pulse --json
```

The installer links the CLI that ships inside Thermo.app into `~/.local/bin` (as `thermo` and
`thermo-use`). If Thermo is not installed it downloads the signed, notarized app from
app.leeguoo.com and refuses anything not signed by the developer's team. The CLI updates with the
app. macOS 13+, Apple Silicon and Intel.

The agent skill is [SKILL.md](SKILL.md): reading is free; cleaning disk space, fan control and
quitting programs only happen when the user asks.

---

Thermo 的命令行给 AI agent 用：一条 `thermo pulse --json` 就能知道电脑为什么卡（负载、内存压力、
交换空间、是否降频、是哪个程序）、温度、风扇、功耗、电池，以及 AI 工具占了多少磁盘。安装脚本把
Thermo.app 里自带的命令行链接到 `~/.local/bin`；没装 Thermo 时会从 app.leeguoo.com 下载并校验签名。


Browser tabs: `thermo tabs list --json`, `thermo tabs group NAME --ids ID,ID --yes`,
`thermo tabs archive --dry-run`, `thermo tabs saved`, and `thermo tabs restore UUID --yes`.
App and CLI share local tab groups and verified saved batches; current, pinned, audible, private
and agent tabs are protected. Thermo grouping does not rearrange the browser's native groups.
Requires a Thermo build with the `tabs` command; compatible chrome-use metadata enables bulk closure.

浏览器标签支持按网站或自定义名称分组、保存后批量关闭和恢复。App 与 CLI 共用本机记录，
保留当前页、固定页、音频页、隐私页和 agent 使用的标签。Thermo 分组不改变浏览器原生分组。
