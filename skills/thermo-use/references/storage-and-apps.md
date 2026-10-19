# Storage, apps and change history

## Disk

```bash
thermo clean ai --json            # AI sessions per project, models, AI tool caches
thermo clean --json               # everything: dev caches, Xcode, project build output, browsers…
thermo clean ai-sessions --all    # sessions one by one, with ITEM#SESSION ids
thermo clean run ID… --yes        # remove items (caches deleted; sessions/models to the Trash)
thermo clean run ITEM#SESSION --yes          # just some sessions of a project
thermo clean run ID… --dry-run    # the plan (paths, commands) without touching anything
thermo clean log                  # what earlier cleanups removed
thermo clean overview --json      # where the used space is: big places and their biggest folders
thermo space /path/to/folder --json # folder sizes
thermo space large --json         # files over 100 MB
thermo space dupes --json         # identical files
```

Developer caches (npm, pnpm, yarn, pip, uv, Homebrew, Go, Cargo…) are cleaned with the tool's own
command when the tool is installed (e.g. `npm cache clean --force`, `brew cleanup`), falling back to
removing the folder; `--dry-run` shows which.

**Undo a cleanup** ("刚才清错了 / 恢复一下"): every run that used the Trash is a batch.

```bash
thermo history --json             # find the cleanup; `undo.kind: trashBatch`, `undo.ref` = BATCH
thermo clean restore BATCH --dry-run   # what goes back where; then --yes
thermo clean empty-trash BATCH --dry-run   # only when the user wants that batch gone for good
```

`clean restore` puts the batch's Trash items back at their original paths and never overwrites
anything now at that path (those are reported, not moved). Deleted caches (`safe`) are not in the
Trash and cannot be restored; they regenerate. `empty-trash` is permanent: only on an explicit ask.

**Keep something forever** ("别再清理这个"):

```bash
thermo clean whitelist --json               # current entries (paths and globs)
thermo clean whitelist add PATH_OR_GLOB       # every cleanup skips it from now on
thermo clean whitelist remove PATH_OR_GLOB
```

Stored one per line in `~/Library/Application Support/Thermo/whitelist`; `rejected` lists entries
that were refused (e.g. too broad).

## Apps

```bash
thermo apps --json                          # installed apps, size, the files they keep in ~
thermo apps uninstall NAME --dry-run        # every path that would move; then --yes
thermo apps leftovers --json                # data of apps that are gone (untouched 30 days)
thermo apps leftovers remove ID --dry-run --json # review the chosen leftover; then --yes
thermo apps startup --json                  # user LaunchAgents and whether each starts at login
thermo apps startup disable LABEL --dry-run # then --yes; `enable` turns it back on
thermo apps updates --json                  # Homebrew app updates (--refresh-catalog to refresh)
thermo apps updates apply TOKEN --dry-run   # then --yes; verifies the installed version after
```

`uninstall` refuses running, system and protected apps, and keeps browser, chat and mail data
unless `--with-data`. Everything goes to the Trash and shows up in `thermo history`. A startup
item or update with `blocked` or an `issues` line is not safe to change: tell the user why instead
of forcing it.

## What Thermo changed

```bash
thermo history --limit 20 --json   # every change: cleanups, uninstalls, agent fixes, tabs,
                                   # archives, quits, lid-awake; newest first; `undo` says where
                                   # it is undone (kind trashBatch → `clean restore REF`)
thermo history show ID --json      # every item of one change
```

Items carry `safety`: `safe` (regenerated), `review` (user data, goes to the Trash) or `risky`
(worktrees with uncommitted work — only when the user names it). Project build output carries
`group` (the project folder) and a note saying when it was last used and by what (agent session,
editor, git). Scans take 10–60 s on a busy disk; `clean ai` is faster.

