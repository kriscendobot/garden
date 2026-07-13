The job is complete. Here is my report.

---

## Completion report — endojs/endo-but-for-bots PR #667 review directive

**Review (kriskowal, CHANGES_REQUESTED):** *"Please refresh this but move these facilities into agentry or agent-tools."* No inline comments were tied to the review — the whole ask was the body's two items.

### Preflight
`pr-feedback-preflight.sh` returned exit 0 (no peer resolution) → proceeded.

### 1. Refresh (re-sync branch + regenerate derived artifacts)
- Rebased the branch onto `origin/llm` (was **40 commits behind**). The stale `chore: regenerate daemon-cas composite tsconfig` commit dropped out as already-applied.
- `llm` advanced again mid-work, so I re-rebased onto its new head, resolving conflicts (a parallel `@endo/agentry/edit-text` subpath, and the `@earendil-works/pi-ai/compat` migration).
- Regenerated `yarn.lock` and confirmed `yarn build:types:check` reports all composite tsconfigs up to date.

### 2. Move the facilities → `@endo/agentry`
Chose `agentry` over `agent-tools` because the RPC bridge is harness/transport infrastructure, not an entry in the agent *tool* catalog.
- Moved `framing`/`protocol`/`bridge`/`serve`/`types`/`session` (with history) from `packages/genie/src/rpc/` to `packages/agentry/src/rpc/`, converting `import harden` → ambient global + `/// <reference types="ses"/>` to match agentry.
- Added `@endo/agentry/rpc` subpath export + a barrel `index.js`.
- `makeGenieRpcSession` → `makeRpcSession`, resolving models via agentry's own harness `resolveModel`.
- `@endo/genie` keeps the spawnable `rpc.js`, now wiring its agent to the moved blocks via `@endo/agentry/rpc`; added `@endo/agentry` as a genie dep; removed the rpc re-exports from genie's `src/index.js`.
- Relocated the protocol docs to agentry's README (left a pointer in genie's); moved the 3 unit tests to `packages/agentry/test/rpc/` (bootstrap → `prepare-endo`); extended the exports test to cover `rpc`; updated the changeset to bump both packages.
- **Fixed two latent type errors** that only surfaced once the code hit agentry's `lint:types` (genie runs eslint only, never `tsc`): `withId` typed against `RpcEvent` instead of a bare generic spread, and the `steer` user message now carries the required `timestamp`.

### Verification
- `@endo/agentry` lint (tsc + eslint): **0 errors**; `@endo/genie` lint: **0 errors**.
- Tests: **37 rpc tests + exports test green** (109 agentry tests overall).
- (`better-sqlite3` native build fails in this sandbox due to noexec `/tmp` — pre-existing infra, affects only genie's runtime, not CI or my changes.)

### Pushed
Force-with-lease to `feat/genie-stdio-jsonl-rpc-bridge` (head now `a110a58`). PR is `mergeable: true` (state `blocked` = pending CI + the CHANGES_REQUESTED review awaiting kriskowal's re-approval, not a conflict). Posted a review-response comment and a re-sync addendum on the PR.

**Follow-ups:** CI/re-approval is out of scope for this job; if checks need driving, that's a `shepherd`. The `rpc.js` runnable remains tool-free (wiring genie's tool suite is the design's documented follow-on).
