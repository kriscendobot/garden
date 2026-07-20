---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T06:40:29Z -->

---
model: opus
---
# stage-10n child 1: outage-hardened 52-file daemon sweep re-measure at the stage-10m/10n tip

**This is a re-cut of stage-10m child 3 (`xs2rust-endor-stage10m-remeasure`), swept unrun when the
stage-10m orchestration halted on an opus API outage. Same shape.**

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT), branch `xs2rust-endor`.
**Measurement-only: zero commits, zero pushes, zero PR comments.** You run AFTER the stage-10n
diagnosis child — read its tada, the stage-10m children's tadas (`xs2rust-endor-stage10m-set-property-at`
landed `8b9c050825`, `xs2rust-endor-stage10m-native-fn-reflection` landed `d268092d7b`), and the latest
`xs2rust-endor-press-*` tadas FIRST (the hourly press can advance or REBASE the branch; if a press is
live, message it to defer), then fetch the REAL remote tip. The tip has ADVANCED past the last measured
sha (`1481757f7f`, the s10l remeasure), so a SKIP is NOT available unless the branch somehow regressed
to an already-measured sha — if it did, say which.

**Env:** `/home/kris/garden2/tmp/s10e` (endolin-garden2). Re-sync rust/ to the tip (the proven recipe:
verify the `git diff <content-base>..tip` is rust/-only with 0 deletions, then git-archive tar-overwrite
or `git reset --hard` in the env's checkout; moddable pin `23b4d6b0a65f…`), rebuild
`cargo build --release -p endo --bin endor` (**verify BUILD_EXIT=0 by exit code, capture to a file**),
regenerate the 3 XS bundles and md5-compare against the priors, smoke `context.test.js` (expect 10/10,
ec=0). Guard the three env-artifact classes (short AF_UNIX path; no provisioning-race asserts; no stale
seeded `target/`). If the diagnosis child delivered an s10e remediation, APPLY it and say so — the
error-trace answer below changes meaning depending on whether the env can observe the flip.

**Sweep:** 52 files, default ava reporter (TAP crashes in `dumpError` on timeouts),
`--concurrency=1 --timeout=25s`, detached setsid nohup, resumable checkpointed TSV (the proven
`/home/kris/garden2/tmp/s10l-results/sweep.sh` shape — outer timeout 240s, channel.test.js 900s, reap
orphaned endor procs after every file, settle on load). Artifacts to `$HOME/tmp/s10n-results/` (mkdir
first). Prior anchors: s10i/s10k/s10l **pass=760 / fail=15 / skip=20 / pending=6**, TSV byte-identical
across them; C-XS same-harness anchor **530/19/20/0**.

**Required answers (all four, explicitly):**
1. **The error-trace pin, named per test:** which of the 6 pinned tests pass/fail/pend in THIS sweep,
   and does the answer differ from the s10l anchor? If the diagnosis child's remediation landed, this is
   the first sweep that can observe the flip — say so either way. Name every error-trace test that
   flipped vs the anchor.
2. **Any NEW daemon failure class vs the ledger** (content-store-gc 9, git 3, git-remote 2, error-trace
   1+6)? Confirm each class by its first failing assertion.
3. **Any class changed?** If yes, re-run the C-XS baseline same-harness for the changed files; if no,
   the standing anchor stands — say which.
4. **The decomposition table** (per-class pass/fail/skip/pending summing to the totals), plus the tip
   sha measured and the rust-only-diff verification vs the prior content base.

HARD STOP: size to one 2400s invocation; the detached sweep + TSV resume is proven across reaper
requeues — if requeued, RESUME from the TSV, do not restart. Report via your tada completion report ONLY.

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-20T06:53:08Z
