# Performance and hardware

## Start here

```bash
thermo pulse --json      # verdict, culprit, busiest programs, load, memory, swap, thermal,
                         # hottest/CPU/GPU °C, fans, power, battery
```

`verdict`: `hot` (throttling) · `overloaded` (load ≥ 2× cores) · `memory` · `busy` · `ok`;
`summary` and `culprit` are sentences for the user. Each of `programs[]` folds an app's helpers
together: `name`, `cpu` (% of one core), `memoryKB` (as Activity Monitor counts it), `pids`,
`app`, and for command-line programs `project` (where it runs) and `owner` (the agent, terminal
or editor that started it), plus `quittable`.

Reading memory numbers: always say which metric a number is. `memoryMetric` names it
(`footprint` = what Activity Monitor shows, including compressed and swapped-out memory;
`resident` = what is in RAM now, `residentKB`). Never compare a footprint with an RSS from `ps`.
A program entry is one app, or one command-line program in one folder, with every process of it
there (`processCount`, `pids`); `elsewhere` sums the same program in other folders, and `units` /
`selection` in the JSON say what each number and row covers. For every copy of one program across
folders — per-process footprint and RSS, CPU, uptime, `ppid`, `owner`, and how many outlived
their parent (`orphaned`) — run `thermo pulse inspect NAME --json` instead of `ps`. Thermo before
1.1.26 counted only a row's bigger processes and had no `elsewhere`/`inspect`; check
`thermo --version` (and that `command -v thermo` points into Thermo.app — a copied binary does not
update with the app) before trusting a total. Many
idle copies of a tool, or copies running for days, are a hint to check, not proof of a leak.

## Machine

```bash
thermo --json                     # every sensor group at once
thermo temps --json               # temperatures
thermo fans --json                # fan readings
thermo power --json               # power
thermo battery --json             # battery
thermo watch -n 10 --json         # 10 samples, one JSON object per line
thermo pulse quit NAME_OR_PID --yes  # stop a program pulse lists (apps quit like ⌘Q; others SIGTERM)
thermo pulse restart NAME --yes   # quit and reopen an app, when pulse advises it
thermo pulse history --since 6h --json   # what slowed the Mac down earlier (1h|6h|24h), and who
thermo pulse inspect NAME_OR_PID --json     # every copy of one program in every folder, per process
thermo pulse chrome --json             # tabs and duplicates, no page debugger
thermo pulse chrome --watch 60 --json  # only for requested page-memory measurement
thermo pulse chrome close URL --yes      # close one tab showing URL (--title to pick among copies)
```

Big apps carry `parts` (gpu, renderer, extension, network, utility…, each with memory and uptime)
and sometimes `advice` (e.g. Chrome up 31 h with ~2000 pages: restarting frees ~19 GB); `swapNote`
explains swap in plain words. History is recorded by Thermo.app in the background (once a minute,
24 h kept); `history` ranks programs by minutes at the top while the Mac struggled. Restart only
when the user agrees. `advice.windows` says what happens to the windows: `restoresItself` (checked
in the browser's settings), `thermoReopensTabs` (Thermo saves the tabs and reopens them; typed
input is lost) or `unknown` (tell the user to save first).

`pulse chrome` alone lists tabs and duplicates without touching the pages (`mode: tabs`).
`--watch 60` (or `--measure` for one sample) measures memory per page; it attaches a debugger to
each page, so Chrome shows "is being debugged" for a moment: only when the user asks (needs
chrome-use). `leaking[]` carries
`leak` (`listeners`: a certain page bug; `heap` / `nodes`: growing) and `advice`; `stale` counts
dead chrome-use relay records (not pages, no memory; reloading/updating the chrome-use extension
clears them), `hidden` real pages in no window; `gap` says where the
rest of the browser's memory is. It reads metrics, titles and addresses only. Close a page only
when the user picks it. `--app "Microsoft Edge"` for other Chromium browsers.

`pulse quit` refuses system processes, AI agent sessions and Thermo itself, and fails with a list
when a name matches several programs (then use the pid).

## Fans

```bash
thermo fan status                 # policy per fan, helper state
thermo fan set all max            # or an rpm; `thermo fan auto` hands back to macOS
thermo fan curve all 50:min,70:3000,85:max --sensor cpu
```

Needs Thermo's helper. If it is missing, ask the user to open Thermo → Fans → Allow (one password
prompt); don't install it yourself. A fan set to max stays at max even when the Mac is very hot;
other settings pause while it is too hot and resume when it cools.

## Lid closed, still awake

```bash
thermo awake status              # on/off and the rules that turn it off
thermo awake on                  # keep running with the lid closed (needs Thermo's helper; acts at once)
thermo awake on --no-heat-guard  # keep only the battery rule
thermo awake off
```

It turns itself off when the Mac gets too hot (the limit follows the CPU: 100 °C on Apple Silicon),
at 20% battery on battery power, or when temperatures cannot be read; `--no-heat-guard` drops the
heat rule only. Each auto-off is recorded in `thermo history`. Only on request — a closed laptop
in a bag gets hot.

