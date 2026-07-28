Premise verified and the orchestration is already running. Report:

## What I did

**1. Verified the premise (the job's first act).**
- endojs/endo-but-for-bots#755 is **MERGED** (not merely closed): merged 2026-07-28T21:04:42Z, merge commit `3b2129924644c67afb80fd2d41b6822498f74168`, base `llm`.
- `packages/cbor/` is present on live `llm` (`index.js`, `package.json`, `test/`, README/CHANGELOG/tsconfigs). I read the landed `index.js` export list and `designs/cbor-codec.md` on `llm` so the child bodies name the real API, not the design's draft sketch.
- endojs/endo-but-for-bots#124 is still **OPEN + DRAFT** (branch `slot-machine`) — so phase 3 is correctly not an orchestration child.

**2. Scouted the three call sites** (`packages/ocapn/src/cbor/{encode,decode}.js`, `packages/daemon/src/envelope.js`) rather than paraphrasing the design, and folded three concrete hazards into the child bodies that the design does not spell out:
- **State-shape impedance:** ocapn's `CborWriter`/`CborReader` are built over syrup's `BufferWriter`/`BufferReader`; `@endo/cbor` owns its own `{buffer,length}` / `{bytes,index,name}` records (Design Decision 6 deliberately declined to extract syrup's classes). Child 1 must choose and justify the bridge. (I confirmed structure lengths are written up-front, not patched back — so no seek-back capability is needed. That was the one thing that could have made phase 2 infeasible.)
- **Number domain:** bigint heads vs number counts; ocapn holds tag constants as bigints (`TAG_SYMBOL = 280n`) and **re-exports them** to the codec layer, so converting them is a cross-module contract change. Daemon's `handle`/`nonce` cross the same line.
- **Strict readers are an acceptance change, not a pure refactor:** `@endo/cbor` rejects non-minimal heads where both existing decoders tolerate them. The design's Open Question 2 leaves "is rejecting non-canonical traffic from tolerant peers acceptable" as a **maintainer call** — both bodies instruct the builder to `message-user.sh` rather than delete an assertion or ship silent tightening onto the live Rust bus.

**3. Posted the board state.** Three basenames for the maintainer to track:

| basename | gate | state now |
|---|---|---|
| **`endo-cbor-adopt-ocapn`** | orchestrated child 1 (builder) | promoted, **already claimed and in `doin/`** |
| **`endo-cbor-adopt-daemon-envelope`** | orchestrated child 2 (builder) | parked in `plan/`, awaits child 1 |
| **`endo-cbor-adopt-slots`** | `blocked_on` endojs/endo-but-for-bots#124 (builder) | parked in `plan/` |

Orchestration `jobs/orch/endo-cbor-adopt-primitives.md` recorded `order: serial`, `on-child-failure: halt`, `state: running`. Serial is load-bearing here: child 2 inherits child 1's bridging precedent instead of re-litigating it. Each child body carries the per-child norms (one package per PR, `.changeset/` entry, frozen base `llm-<short-sha>` at or after `3b21299`, byte-identity-by-diff as the evidence rather than a green suite, no separate gauntlet job).

Verified on `origin/journal2`, not just locally — `/home/kris/garden2/journal` is a stale liaison worktree and does not reflect these posts.

## Follow-up worth knowing

- **Name collision:** this job's base and the orchestration base are the same string (as the spec directed). `orchestrate.sh`'s `finish_orch` does `cp` onto `tada/<base>.md`, so when both children finish it will **overwrite this job's completion report** with the orchestration outcome summary. Harmless to fleet correctness (the orchestration summary is the more useful terminal record, and this report survives in git history), and I did not rename — the running children already carry `orchestrated-by: endo-cbor-adopt-primitives`. If the garden wants to prevent the class of collision, the fix is a guard in `post-orchestration.sh` refusing an `<orch-base>` that is a live job basename.
- No garden-library changes were needed, so this worktree has no commits; the job's entire product is board state on `journal2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-cbor-adopt-primitives.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 43 tokens (1504798 cached reads)
- Output: 18410 tokens
- Cost: $1.93351
- Wall-clock: 290s

<!-- garden-usage-end -->
