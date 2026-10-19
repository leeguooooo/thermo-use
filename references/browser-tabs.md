# Browser tab groups and recovery

## Browser tab groups

```bash
thermo tabs list --json                  # every tab, ID, window, Thermo group, protection reason
thermo tabs organize --dry-run --json    # preview native Chrome groups by website/custom rules
thermo tabs organize --yes --json        # create the reviewed native groups
thermo tabs auto on --yes                # opt in to grouping new tabs every minute while Thermo runs
thermo tabs rule add github.com GitHub --color purple --yes
thermo tabs organized --json             # native-grouping batches
thermo tabs undo-organize UUID --yes      # undo unchanged members of one batch
thermo tabs group Research --ids ID,ID --yes
thermo tabs group --by-site --yes        # regroup the scoped tabs by website
thermo tabs archive --group Research --dry-run --json
thermo tabs archive --group Research --yes --json
thermo tabs archive --name Later --all-windows --yes --json
thermo tabs saved --json
thermo tabs show UUID --json
thermo tabs restore UUID --yes --json
thermo tabs restore UUID --window WINDOW_ID --yes --json
```

Use current IDs from `tabs list`; default scope is the front browser window. `--window ID`,
`--ids ID,ID` and `--group NAME` narrow the scope; use `--all-windows` only when the user asked
for all windows. `--app "Microsoft Edge"` selects a different Chromium browser.

`tabs organize` creates native Chrome groups after a concrete dry-run. It preserves existing
groups and skips current, pinned, audible, private, changed and agent/debugger tabs. Groups never
cross a window or Chrome profile. Ordinary website groups need at least two background tabs;
an explicit domain rule may group one. `tabs auto on` is opt-in and runs only while Thermo.app is
running; it never closes tabs. Undo restores only unchanged members and never retries an unknown
result. Native grouping needs the chrome-use extension 0.5.48 or newer.

`tabs group` manages Thermo's local categories, separate from native browser groups: it does not
move tabs or change another agent's group. Existing browser group names are read when available.
To close a group, archive it: the CLI writes and verifies an owner-only local record before
closing, rechecks each tab, protects current/pinned/audible/private/agent tabs, and reports each
result. Protection flags require a connected compatible chrome-use relay; unavailable flags
mean quick archive is disabled. Listing and grouping never attach a page debugger. All connected Chrome profiles are read independently; each close is rechecked on the tab's own profile without changing any agent session or the default connection.

Saved URLs can contain private data. Keep records local; summarize counts/titles, and expose
URLs only when needed. Saved batches are in `~/Library/Application Support/Thermo/TabWorkspace/`.
They preserve web links and Thermo group names, not unsaved input or page state. Restoring skips
already reopened pages. Unknown close/open results are not automatically retried: inspect the
batch and current tabs; the App also offers saved links for manual recovery. If the original
browser session ended, choose the correct destination window explicitly to avoid account/profile
mix-ups. A requested bulk archive authorizes closing its eligible candidates after showing the
concrete plan; do not ask permission again for every tab. These commands require the Thermo
build that includes `tabs`; older releases will report an unknown command.

