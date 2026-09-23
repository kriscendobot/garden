All work is complete, tree is clean, and my inbox is empty. Here is the completion report.

---

## Completion report: `build-endopi-stdio-jsonl-rpc-bridge`

**Delivered:** Draft PR **[endojs/endo-but-for-bots#667](https://github.com/endojs/endo-but-for-bots/pull/667)** — `feat(genie): stdio JSONL RPC bridge (endopi-stdio-rpc-bridge)`, base `llm`, head `feat/genie-stdio-jsonl-rpc-bridge`, **draft**.

### What I built
Implemented `designs/endopi-stdio-rpc-bridge.md` as a stdio JSONL RPC surface in **`@endo/genie`** (the package that owns the agent loop; there is no CLI↔genie streaming linkage today, so this is the honest home). New `packages/genie/src/rpc/`:
- **`framing.js`** — strict `\n`-only line decoder that (unlike Node `readline`) does *not* split on `\r`, `U+2028`, or `U+2029`, and reassembles multibyte UTF-8 across chunk boundaries; plus `encodeRecord`.
- **`protocol.js`** — translates the raw `pi-agent-core` event stream to the design's wire vocabulary (`message_start`/`message_update`/`message_end`, `tool_execution_start`/`tool_execution_end`, `agent_end`); reasoning deltas and acks are `endo:`-namespaced.
- **`bridge.js`** — command dispatcher (`prompt`/`steer`/`abort`/`list_models`/`set_model`/`get_status`) with `id` correlation and single-flight busy tracking; a prompt round runs concurrently with input parsing so mid-round `steer`/`abort` interleave.
- **`session.js`** / **`serve.js`** — a Session over a live `PiAgent` + pi-ai registry, and the byte-stream wiring (logs on stderr, protocol on stdout).
- **`rpc.js`** — spawnable entry (the RPC counterpart of `dev-repl.js`).
- Minimal supporting edits: exported `resolveModel` from `src/agent/index.js`, added the rpc exports to `src/index.js`, added an `rpc` script to `package.json`, a README section, and a changeset.

### Verification (real execution)
- **29/29 ses-ava tests pass** (`framing`/`bridge`/`serve`): `corepack yarn ava --config ../../ava-endo-lockdown.config.mjs 'test/rpc/**/*.test.js'` → `29 tests passed`.
- **Regression evidence:** mutating the decoder to also split on `\r` makes the strict-split test fail; reverting restores green (demonstrated).
- **Live runnable smoke test:** drove `node rpc.js` with `get_status`/`list_models`/unknown/invalid-JSON; stdout was 4 pure-JSONL records (`status, models, error, error`), logs went to stderr, `status.model=ollama/llama3.2`, `list_models` enumerated the full provider registry, error events echoed the `id`.
- **Gates:** `tsc` 0 errors across the package; eslint 0 errors/0 warnings on the new files; prettier clean; no `yarn.lock` churn (no new deps).

### Scope / phasing
Covers the design's Phase 1 (protocol skeleton) and Phase 2 (tool events) fully; `steer`/`abort` (Phase 3) and `set_model` (Phase 4) are wired through the live `PiAgent`. Documented follow-ons: the `endo agent rpc` **CLI transport** (needs a daemon streaming-session handle that does not exist yet), full **tool-suite wiring for the `rpc.js` runnable** (the protocol layer already relays tool events), and **Phase 5 multiplexing** (per-record channel id). `set_model` assigns `piAgent.state.model` best-effort (pi exposes no live setter) — worth confirming it sticks in a live round.

### Note for the maintainer/liaison
The `gh` wrapper could not resolve **endolinbot**'s token on this host and fell back to the global account, so PR #667 was *opened* as **kriscendobot** (the commit is correctly authored by endolinbot). Both are your bot identities on the shared fork — no `kriskowal`/human-identity leak — but endolinbot's `gh` credential isn't configured on `endolin-garden`, which is worth fixing so bot PR-authorship is consistent.
