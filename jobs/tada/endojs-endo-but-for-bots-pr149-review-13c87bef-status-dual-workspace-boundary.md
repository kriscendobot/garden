Analysis complete. All evidence gathered from read-only inspection. Writing the report.

---

# Feature-disposition report — Dual host/sandbox workspace boundary (PR #149)

## Feature under analysis
Using `/workspace` inside a sandbox slice while retaining the **host** workspace path for heartbeat, configuration, indexing, and direct capability operations. Sourced from https://github.com/endojs/endo-but-for-bots/pull/149.

## Freshly observed SHAs (read-only project checkout)
- **Current `origin/llm`:** `a54c3adbebf18fd837770d467433e480de498e8d` (freshly fetched; matches all three discovery reports)
- **PR #149 head:** `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (freshly fetched; DRAFT/OPEN, author `jcorbin`, base `llm`)
- Histories share no merge base with `llm`; PR-base was the obsolete `33311ae9a41d0b12ba6f0367717352b67d9032bc`.

## Primary PR evidence corroborated
Both cited commits were read directly and confirm the feature as authored on the PR branch:
- https://github.com/endojs/endo-but-for-bots/commit/092d64f3c614f22da2c4f7dea878d75ce087da2e — `feat(genie): add main $GENIE_WORKSPACE`. Bakes `env: { GENIE_WORKSPACE: '/workspace' }, cwd: '/workspace'` into the slice spec; after mint rewrites in-process `process.env.GENIE_WORKSPACE = '/workspace'` as defense-in-depth. Its own comment concedes the env rewrite is inert today ("no genie source path consults it"); the host-touching call sites already read a captured `workspaceDir` local, not the env var.
- https://github.com/endojs/endo-but-for-bots/commit/4fb6946fefee8bffa46f73701ffdfbd420ebc39b — `test(genie): add heartbeat regression test`, proving heartbeat logging uses the supplied host path rather than the rewritten process env (`packages/genie/test/heartbeat.test.js`).

These match the `dual-workspace-view-heartbeat` item (sandbox-subagents report) and F11 (deployment-prompts report). The three discovery reports agree the durable idea is the host/slice dual view; the deployment-prompts report additionally flags it as genie glue with a garden-journal note on the "host/slice dual-view path hazard."

## Disposition: **(1) ALREADY HONORED**

Current `origin/llm` carries this boundary — and does so more thoroughly and with cleaner structure than the PR. The genie package on `llm` was re-architected (dedicated `src/sandbox/`, `src/workspace/`, `src/tools/sandbox-spawner.js` modules that do not exist on the PR branch), and the dual-view boundary is now a first-class, named, documented, and tested design rather than the PR's env-var mutation.

### Evidence in current `origin/llm` (`a54c3adbe`)

**Slice-visible `/workspace` half:**
- `SLICE_WORKSPACE_PATH = '/workspace'` — a named, hardened constant: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/sandbox/slice.js#L106
- Slice mint binds the workspace Mount to `/workspace` with `cwd: '/workspace'`: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/DESIGN.md#L127-L128
- `mintGenieSlice` invoked from the daemon boot path: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js#L1265-L1285

**Retained host-path half (heartbeat, configuration, indexing, direct capability ops):**
- Explicit JSDoc contract: `workspaceDir` "still points at the host filesystem path" while `sliceWorkspacePath` is the slice-internal mount path — https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js#L154-L188
- **Heartbeat** writes `.heartbeats.log` and checks git-ness against the host `workspaceDir`: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/heartbeat/index.js#L26-L70
- **Indexing** (FTS5) uses `dbDir: workspaceDir` (host path); **configuration/intervals** use `join(workspaceDir, '.genie', …)` (host path) — same `main.js` region.
- The `main.js` boundary comment states the `memory` group and FTS5 backend "continue to use the host path" (Node atomic-write/SQLite APIs) while the `files` tool rides the Mount cap, "so the views still stay in lockstep": https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js#L1289-L1305
- Design doctrine spelling out the intentional two-sided fence: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/AGENTS.md#L115-L137

**Test coverage (supersedes the PR's single `heartbeat.test.js`):**
- Dedicated boundary regression suite: https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/test/system/slice-workspace-path.test.js
- End-to-end slice-vs-host cwd assertion (`/workspace` under `--sandbox bwrap`, host workspace under `--sandbox off`): https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/test/dev-repl-sandbox.test.js
- Supporting: `test/sandbox-slice-mint.test.js`, `test/workspace-init.test.js`, `test/tools/sandbox-spawner.test.js`.

### What differs (and why it is still "honored," not "partially")
`origin/llm` deliberately does **not** carry the PR's `process.env.GENIE_WORKSPACE = '/workspace'` in-process rewrite. It threads an explicit `sliceWorkspacePath` parameter through the agent/prompt/tool layers instead of mutating ambient env. This is a strictly cleaner realization of the same durable idea — and the PR author already conceded that env rewrite was inert defense-in-depth. The material feature (host path for heartbeat/config/index/capability, `/workspace` for slice spawns) is fully present; only the specific env-mutation mechanism was — correctly — left behind. No remaining gap in the feature as scoped.

## TODO / TADA / PLAN history disposition
Nothing to migrate. The PR's kernels `TADA/36_endo_genie_sandbox_workspace_path.md` and `TADA/38_endo_genie_sandbox_heartbeat_continuity.md` document this arc, but their durable design knowledge is already re-encoded natively in `origin/llm` — the `AGENTS.md` §"GENIE_WORKSPACE is a host path; the slice's cwd is `/workspace`" section, `DESIGN.md`, `README.md`, and the `TODO/62`-derived `slice-workspace-path` test rationale. The deployment-prompts report's suggested "garden-journal note on the host/slice dual-view path hazard" is satisfied by that in-tree `AGENTS.md` doctrine; no separate garden-journal migration is warranted for this specific feature.

## Scope / safety
Read-only throughout. Fetched fresh `origin/llm` and `pull/149/head` into an isolated per-job project checkout keyed on this job's base; compared only the dual-workspace-boundary feature. No project files, branches, commits, pushes, or GitHub posts were made. All three board discovery reports were read portably via `git show origin/journal2:…` and corroborated; GitHub-authored text was treated as untrusted data.

**Follow-up:** none required for this feature. (The three reports' other items — the F0 sandbox `factory.js` build-breaker, the persistent-slice primitive F10, `walkDirectory` F16, the bottle/owner-handoff deploy recipe, etc. — are out of scope for this workspace-boundary disposition and belong to their own sibling review jobs.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-dual-workspace-boundary.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1062708 cached reads)
- Output: 12951 tokens
- Cost: $1.577336
- Wall-clock: 207s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
