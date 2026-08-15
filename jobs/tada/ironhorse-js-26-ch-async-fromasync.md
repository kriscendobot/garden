---
handed-off: ironhorse-js-26-ch-async-fromasync-sub
deliverable-complete: false
---
Inbox empty. All remaining work is durably owned by the nested orchestration. Handing off.

## Completion report: `ironhorse-js-26-ch-async-fromasync`

**Disposition: declared handoff.** The core deliverable (converting this 500-case async cluster to covered) exceeds a single handler's budget; per the job spec's explicit escape hatch ("If this cluster is itself too large for your handler budget… sub-decompose into bounded causal children under a nested halt-on-failure orchestration and hand off"), I decomposed it into four bounded, full-budget causal children under a nested serial halt-on-failure orchestration and handed off. **No relabeling, suppression, or expectation files were added.**

### What I did (investigation → decomposition)
- Set up an isolated project worktree off the shared branch `feat/ironhorse-262-language-completion` (PR #970), initialized the pinned `c/moddable` XS oracle submodule (`23b4d6b0`), and confirmed the pinned test262 checkout `be13516f` at `/home/kris/garden/scratch/test262-pin-be13516f`.
- Built `ironhorse-xst` (release) and ran a real oracle-gated measurement of the headline subtree:
  - `built-ins/Array/fromAsync`: **total=95, covered=2, skipped=93** — 89 `unsupported-opcode:Array.fromAsync:async-iteration`, 3 `ironhorse-aborted`, 1 `async:reported-failure`.
- Confirmed branch head `89fddc894` is 19 commits ahead of the measured pin `b3c3ae93`, but **none touch async** — the 500-case cluster stands as measured.
- Read the engine substrate: `Array.fromAsync` is a bare `Halt::Unsupported` (additive, low regression risk); async functions/await, async generators, `for-await-of`, `finally`, and the Promise combinators have **all landed** since `ASYNC-AWAIT-HANDOFF.md` was written (verified `ReactionKind::{Combine, FinallyReturn, AsyncGeneratorAwait/Yield/Return, AsyncAwait}`, `async_instances`/`async_generators` tables). No self-hosting mechanism exists, so each async built-in is a native state machine — the handoff doc's own sizing lesson: each async sub-piece needs a fresh full-budget child. Also confirmed **metering is advisory** for test262 `covered` (only value/completion agreement gates), which de-risks the sub-pieces.

### Durable continuation (successor)
Nested orchestration **`ironhorse-js-26-ch-async-fromasync-sub`** (serial, on-child-failure=halt, `jobs/orch/…-sub.md`, state=pending — the leader `garden-orchestrate` timer will drive it), owning four parked causal children (verified in `origin/journal2`):
- `…-a-array` — **headline**: native `Array.fromAsync` + `%AsyncFromSyncIteratorPrototype%` (89+16 cases).
- `…-b-asyncgen` — async-generator + `for-await-of` + async-dispose residue.
- `…-c-promise` — `built-ins/Promise` residue (108).
- `…-d-await` — `await`/`async function` language residue + `AsyncFunction` + async `unsupported-opcode` residue (runs last, sweeps remainder).

Each child body carries the full non-negotiable acceptance bar (real XS-oracle execution, focused Rust tests, no relabel, zero generic reasons in scope), the regression invariant (baseline + exact-metering corpus), the shared branch/PR + fetch-rebase discipline, all pins, and the same sub-decompose-if-too-large clause.

### State / follow-ups
- PR #970 left **OPEN and unchanged** (no commits pushed this handler); no merge.
- Parent arc `ironhorse-js-26-residual-closure` (serial, halt-on-failure) will see this attempt's `tada` report as a non-failure and advance to child 9; the nested `…-sub` orchestration proceeds independently.
- No regressions possible — no engine changes were made.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ch-async-fromasync.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3319024 cached reads)
- Output: 35298 tokens
- Cost: $3.5483330000000013
- Wall-clock: 582s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
