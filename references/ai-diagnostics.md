# AI tool diagnostics

## AI tool size, usage and task evidence

Use this when the user asks how large MCP/Skill context is, which tools return the most,
how long calls take, or which integrations need investigation. Configuration lint alone
does not answer those questions. Use the installed CLI's help/capabilities if a command
is unavailable; do not keep guessing flags from a newer Skill.

```bash
thermo agents context --agent codex --json   # static Skill/catalog/cache and configured MCP scope
thermo agents usage --agent codex --json     # observed calls from bounded local log reading
thermo agents usage --agent codex --log-file /path/to/session.jsonl --json
thermo agents inspect-all --agent codex --dry-run --json  # preview configured MCP targets
thermo agents inspect SERVER --agent codex --timeout 10 --json
thermo agents compare /path/to/records.json --json        # import existing task evidence
```

### Choose the installed capability

For a usage ranking, check `thermo agents usage --help` first. Use the exact executable
chosen for this task throughout. An App/CLI version label, cached Skill copy or source
commit does not prove that a flag is available.

If that help lists `--sort`, the CLI supports these explicit orders; add `--encoding`
only when the installed help lists it:

```bash
thermo agents usage --agent codex --encoding cl100k_base --sort text --json
thermo agents usage --agent codex --encoding cl100k_base --sort structured --json
```

`text` ranks returned-text tokens. `structured` ranks MCP structured JSON representations;
it is not a Skill-instruction or request-cost ranking. Unknown entries and non-MCP
categories remain present after known values. The JSON `toolOrdering` declares this order.
Human output shows at most 20 rows by default; `--all` expands it. `--limit` limits log
files, not output rows. JSON retains all observed rows.

If `--sort` is not listed, use `usage --json` without it. Do not repeatedly try newer
flags or assume the `tools` array is token-ranked: older CLIs order by bytes. For an
explicit token ranking, compare only available per-row counts with the same encoding:
`referenceReturnedTextTokens` for a matching non-null `referenceEncoding`, otherwise
`returnedTextEstimatedTokens` for heuristic reports. Missing reference values or explicitly
unavailable results are unknown, not zero. Keep that fallback separate from a native
`toolOrdering` declaration.

### Read the measured scope

Label the representation being ranked. A zero returned-text count with `nonTextBlocks > 0`
is not a zero-cost call: those blocks were excluded, and an older parser can place an
unfamiliar text-block format there. Keep their full size and model delivery unknown;
do not reinterpret the omitted content as measured text or media cost.

- `context` does not connect to servers. Catalog descriptions, complete Skill bodies,
  cache copies and aliases are different views, not additive prompt or invoice totals.
  Cache presence does not establish what a running host loaded. An incomplete inventory
  is not proof that a plugin is absent: check host registration before adding a duplicate.
- `usage` reads local conversation logs and exports aggregates, not raw prompts,
  arguments or return bodies. Check `complete` and coverage before describing rankings;
  unread/clipped logs can change them. Returned-text counts are not request costs.
  Serialized-media and truncation markers mean the logged representation cannot establish
  complete return size, image/audio token cost or model delivery. Keep request/cache
  counters separate; do not allocate them to individual tools.
- In a usage report, per-row `structuredContent` is a measurement summary, not the raw
  tool payload. If absent, structured footprint was not measured. If present, rank its
  `jsonReferenceTokens` (or heuristic `jsonEstimatedTokens`) only when completed results
  exist, `inspectedResultObjects == completed`, `unobservableResults == 0` and
  `unavailableJSONResults == 0`. A checked envelope with no structured field can establish
  zero for that observed result; missing/uninspectable envelopes cannot. JSON may duplicate
  returned text or contain encoded media. Do not add both representations, decode media
  to count it, or treat serialized JSON as the exact wire/model input.
- For Skill cost, distinguish the static catalog/body/reference views from observed
  instruction loads and the Skill tool's acknowledgment. Use `skillInstructions` only
  when linked events exist and are complete (`events > 0`, `incompleteEvents == 0`),
  with the matching reference or heuristic count. Missing metadata or zero linked events
  leaves total loading unknown. A short acknowledgment does not establish a cheap Skill.
- `inspect` starts the configured stdio server or connects to HTTP, then reads handshake
  and tool definitions. It does not call business tools or log in. Preview scope before
  a broad scan; report incomplete totals as unknown. A successful list is not business
  acceptance; definition hints and explicit result errors are not overall tool quality.
- `compare` only reads evaluator records; it does not launch models, tasks or tools.
  Keep failed, timed-out and unverified runs. A tool's `isError:false` is not a task pass;
  failed/missing post-run comparison checks must not turn into savings. Record format:
  https://github.com/leeguooooo/thermo/blob/main/docs/ai-task-comparison.md

A size ranking or failed check is a reason to investigate, not authorization to disable,
uninstall or clean. Inspect the actual task evidence and use the relevant repair preview
below only for changes the user requested. Keep raw logs and private URLs local.

## AI agents (Claude Code, Codex, Cursor, Gemini)

```bash
thermo agents --json                    # findings by area; items with their actions, processes, sessions
thermo agents list [AREA]               # hooks | mcp | plugins | skills | statusline | launchd | processes
thermo agents show NAME                 # one item: problems, suggestions, numbered actions with exact steps
thermo agents fix --dry-run             # all bulk-safe automatic fixes (skips anything in use)
thermo agents fix NAME --dry-run         # one item; then the same with --yes
thermo agents uninstall NAME --dry-run   # only a requested removal
thermo agents disable NAME --dry-run     # only a requested disable
thermo agents run NAME --action N --yes # action N from `show`
```

NAME is an item name, its id or a unique prefix; narrow with `--area` and
`--agent claude|codex|cursor|gemini|shared|plugin|system`, or `--all` to apply to every match.
Config edits are backed up to ~/Library/Application Support/Thermo/Backups/, files go to the
Trash, MCP/plugin changes go through `claude` / `codex` themselves; log in
~/Library/Logs/Thermo/fix.log.

