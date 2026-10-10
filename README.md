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
