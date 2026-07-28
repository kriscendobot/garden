Working tree clean, both commits pushed.

## Completion report

**Job:** dckc's review comment on endojs/endo-but-for-bots#881 — *"setTimeout? so this module is expected to be unconfined? why?"* (`packages/exo-google-sheets/src/facets.js:2`).

**Scope enumerated.** Review 4800101592 is `COMMENTED` with an **empty body** and exactly **one** inline comment (the one above). No other asks tied to it. Preflight exited 0 (no peer resolution) — proceeded.

**What I did** (2 commits, pushed to `origin/build-exo-google-sheets-facets`, head `0980d9f7ce`):

1. `58705a160c` — **took the timer as a power.** `facets.js` claimed to take "power objects and nothing else" and then reached for an ambient `setTimeout`. `makeReadPowers` now takes a `delay` and exposes `pollDelay()`; `follow()` awaits that. `facets.js` names no global at all. Two properties fell out and are tested: the poll interval stays with the *policy*, so `control.setPollIntervalMs()` still applies to a follow already in flight; and `{ setTimeout: null }` grants a reader that reads but cannot poll, failing loudly instead of reaching past its powers. Fixed the same defect one module over — `makePolicy`'s token bucket refilled on ambient `Date.now`, now a required `now` parameter — so `a1.js`/`powers.js`/`facets.js` name no globals between them and `exo-google-sheets.js` (already entitled to a live network client) is the sole unconfined module. README states the invariant.

2. `0980d9f7ce` — **a pre-existing bug my first test found.** `follow()` was throwing on *every* call, before and independent of this change: its return guard was `M.any()`, but an exo result checked as Passable must be Passable, and the follower carries `Symbol.asyncIterator` — exactly what a remotable may not have. Now `M.raw()`. Flagged in the reply that this leaves the follower local-only, and offered to make it a remotable `next`/`return` pair in this PR if dckc prefers.

Replied on the thread: https://github.com/endojs/endo-but-for-bots/pull/881#discussion_r3669393881

**Verification.** `ava` 8/8 pass (2 new), `tsc` clean, `eslint` clean, prettier clean. Repo-wide `local-verify` steps `format`/`lint`/`build`/`codegen`/`docs` pass.

**Peer coordination.** A peer (`...pr881-review-b8bb5665`, working dckc's sibling "why the separate powers layer?" comment) messaged mid-job that it planned to edit `powers.js` and `README.md`. I pushed first and sent it my exact footprint in both files plus a request to rebase onto `0980d9f7ce`.

**Follow-ups left open:**
- Posted job `local-verify-parity-endo-but-for-bots-warm-cache` for two verification-parity divergences I hit: (a) on a warm-cache hit, `ensure-project-worktree.sh` leaves yarn believing the project is uninstalled, so **all six** local-verify steps fail on one message for this repo — a confirmed 4.8s `yarn install --immutable` fixes it; (b) `@endo/agentry`'s `conflict-rebase` eval test fails locally but is green on CI, and it aborts the whole monorepo `test` step, masking every package downstream. Neither is related to my change.
- The `test` step failure above is why I verified the package directly rather than through the gate; I state that plainly rather than claiming a green gate.
- My GitHub reply carries no provenance footer: the deployed root predates `e8bf3345fd`, so the deployed `gh` wrapper does not inject one yet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr881-review-d23c8dbf.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 190 tokens (9347444 cached reads)
- Output: 49054 tokens
- Cost: $7.185206999999999
- Wall-clock: 1116s

<!-- garden-usage-end -->
