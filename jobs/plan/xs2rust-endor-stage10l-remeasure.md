---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10l
priority: normal
posted_by: producer
posted_at: 2026-07-20T03:03:57Z
---

---
model: opus
---
# Stage-10l child 2: outage-hardened 52-file daemon sweep re-measure (PR #600, endojs/endo-but-for-bots, branch `xs2rust-endor`)

**Measurement-only. No commits, no pushes, no PR comments. PR #600 stays DRAFT and untouched.**

You are the stage-10l measurement child. Re-measure the bounded-serial 52-file daemon sweep on the
Rust engine at the REAL remote tip after children 0 (reflection fixer) and 1 (live round trip) have
landed. Read the latest `xs2rust-endor-press-*` tadas and the stage-10l child tadas
(`journal/jobs/tada/xs2rust-endor-stage10l-*.md`) FIRST — the press can rebase/advance the branch.
You may SKIP (tada honestly, citing the sha) ONLY if the tip regressed to an already-measured sha.

## Environment

Proven envs: `/home/kris/garden/tmp/s9r` (endolin-garden) or `/home/kris/garden2/tmp/s10e`
(endolin-garden2, the s10k remeasure's adaptation). Short AF_UNIX/TMPDIR path; `mkdir $HOME/tmp`
first. Guard all three environment-artifact classes: AF_UNIX sun_path overflow, uniform
provisioning-race asserts, stale seeded `target/` (fully resync `rust/` from the tip — verify the
range has no deletions before tar-overwrite, else rsync/rm first). Fresh
`cargo build --release -p endo --bin endor`, BUILD_EXIT by exit code. Regenerate the 3 XS bundles
(byte-compare vs prior). Daemon-boot smoke `context.test.js` 10/10 before the sweep.

## Sweep

52 files, `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`), **default reporter**
(TAP crashes in `dumpError` on timeouts), `--concurrency=1 --timeout=25s`, **detached setsid nohup**
with a **resumable TSV** (one row per file; on requeue, resume from the TSV — never restart a
completed file). Artifacts to `$HOME/tmp/s10l-results/`: MEASURED-TIP.txt, build logs, sweep.sh,
sweep-rust.tsv, per-file logs, SUMMARY.md, and a SWEEP-COMPLETE sentinel last.

## Required answers (the tada must contain all four)

1. **Did the error-trace 6-pending pin MOVE?** Name EVERY error-trace test that flipped vs the
   s10i/s10k anchor (fail=15/skip=20/pending=6; TSV byte-identical across s10h/s10i/s10j/s10k) —
   the pin is THE question, especially after child 1's live round trip.
2. **Any NEW daemon failure class?** Every fail must be ledgered (content-store-gc 9, git 3,
   git-remote 2, error-trace 1+6) or named as new with its first error lines quoted.
3. **Any class changed?** If yes, re-run the C-XS same-harness 52-file baseline in the same env and
   report the fresh table; if no, cite the standing anchor 530/19/20/0.
4. **The decomposition table** (pass/fail/skip/pending per class) vs the anchor.

Report via your tada completion report ONLY — never inbox-send the parked supervisor. Sized to one
2400s window; the detached sweep + TSV resume is your outage protection (proven across reaper
requeues since stage-10f).
