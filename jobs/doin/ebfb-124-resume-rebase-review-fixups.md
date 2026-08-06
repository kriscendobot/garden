---
role: fixer
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:43:24Z cleared=none -->

fixer job (endojs/endo-but-for-bots), GATED — do NOT run until the XS sqlite
bindings land. This is the "rebase trigger" kriskowal asked for in the PR #124
review (comment https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548850250:
"move this PR to draft and add a trigger to rebase the PR when the necessary
sqlite bindings land"). PR #124 (head `slot-machine`, base `endor`) was moved to
draft and paused per the review body ("This work should be paused until the
underlying XS sqlite bindings are ready").

When promoted (maintainer/liaison promotes once the bindings are ready): rebase
`slot-machine` onto current `endor`, then apply the deferred PR #124 review code
fixes as one-concern-per-commit follow-ups (skills/review-feedback-followup-commits):

- .github/workflows/rust-endor.yml — rename the workflow file AND its inner job
  to simply `rust` (comment r3548775263); make the `on:` triggers match the other
  test workflows: all pull_request + push to the master branch (comment
  r3548779800); drive the three XS bundle builders (currently three `node
  scripts/bundle-*.mjs` steps) from a single `yarn`/`node --run` command backed by
  a package.json script, ideally with the build scripts implemented in JavaScript
  (comment r3548795579).
- packages/base64/src/decode.js line ~107 — restore type specificity: the cast
  was regressed to `/** @type {any} */`; restore the specific
  `/** @type {typeof Uint8Array.fromBase64} */` cast (comment r3548828631).
- packages/base64/src/encode.js line ~89 — restore specificity: the
  `nativeToBase64` type and the apply cast were reduced to `any`. A cast through
  `unknown` is fine but the type must be specific (comment r3548830908).
- packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs line ~34 (and the
  sibling bundle scripts) — prefer `new URL` path math over importing node
  `path`, per the Endo convention (comment r3548837460; see the standing
  garden-style job garden-style-url-not-path).
- packages/daemon/scripts/bundle-bus-worker-xs.mjs line ~57 — investigate WHY the
  `EXCLUDED_PACKAGES` filter is necessary: the bundler should GC unreferenced
  deps and only entrain the loaded module graph. Determine whether a static
  import in the daemon barrel entrains these Node-only/libp2p packages; then
  either document the reason in the comment or drop the filter if the bundler
  already collects them (comment r3548845562).
- designs/daemon-endor-pet-store-sqlite.md — replace hard-to-type code points
  (e.g. `→` arrows) per comment r3548802060 (see garden-style job
  garden-style-typist-codepoints).

Then reply on each thread citing the fix SHA and post a top-level summary
(skills/pr-review-thread-replies, pr-completion-summary-comment). Un-draft when
green.

## Triage note appended 2026-07-29 (job `endojs-endo-but-for-bots-pr124-feedback-triage`)

Two findings the doer of this job must not rediscover the hard way.

**1. Disambiguate "the sqlite bindings landed" before promoting.** The *raw* XS
SQLite host bindings are NOT the blocker and never were: `rust/endo/xsnap/src/powers/sqlite.rs`
(582 lines; `sqliteOpen`, `sqliteClose`, `sqliteExec`, `sqlitePrepare`, `sqliteStmtRun`,
`sqliteStmtGet`, `sqliteStmtAll`, `sqliteStmtColumns`, `sqliteStmtFinalize`) landed on
`endor` in `f5f0b1031` on 2026-05-02, is registered through `powers/mod.rs` and `lib.rs`,
has Rust unit tests, carries no `todo!`/`unimplemented!`, and is byte-identical on `endor`,
`llm`, and `slot-machine`. It predates kriskowal's 2026-07-09 pause review. The plausible
referent is instead the **durable-store layer** on top of those bindings, and as of
2026-07-29 every pull request in that line is still unmerged:
https://github.com/endojs/endo-but-for-bots/pull/811 (draft),
https://github.com/endojs/endo-but-for-bots/pull/819 (draft),
https://github.com/endojs/endo-but-for-bots/pull/690 (draft), and
https://github.com/endojs/endo-but-for-bots/pull/825 (not draft, but based on the frozen
`daemon-store-phase3-weak-ertp-74931b9` branch, not `llm`). Asked on the pull request:
https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3670370164

**2. The rebase is no longer mechanical, and its target is in question.** `llm` is 1390
commits ahead of `endor`, and `endor` has not moved since 2026-07-06 (`e0322c405`). In that
span `llm` grew a new daemon persistence seam (`packages/daemon/src/manager-database.js`,
`manager-persistence-powers.js`, `bus-manager-rust-xs-powers.js`) which **keeps**
`packages/daemon/src/better-sqlite3-xs.js` under that name, while this branch **renames**
that same file to `rust-xs-sqlite.js`. Reconcile the rename against the new seam, and settle
with the maintainer whether the rebase target is still `endor` or has become `llm`, before
starting.

**3. A CBOR adoption may pre-empt part of this branch.** `@endo/cbor` phase 1 merged on
`llm` (https://github.com/endojs/endo-but-for-bots/pull/755, 2026-07-28) and the parked job
`endo-cbor-adopt-slots` is gated `blocked_on` this very pull request, to delete
`packages/slots/src/cbor.js` in favour of the shared package. That job's own body offers a
sequencing escape hatch: `packages/slots` may adopt `@endo/cbor` **in flight** on this
branch instead. If you rebase onto `llm`, take the escape hatch and shed `src/cbor.js` here,
then report so `endo-cbor-adopt-slots` reduces to verification.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-06T05:43:32Z
