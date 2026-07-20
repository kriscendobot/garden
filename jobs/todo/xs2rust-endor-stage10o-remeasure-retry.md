---
model: opus
---
# stage-10o child 2 re-measure (RETRY after MISROUTE) — 52-file daemon sweep at the xs2rust-endor tip

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT). Measurement-only: zero commits/pushes/comments.

## Why this retry exists
The original job `xs2rust-endor-stage10o-remeasure` was claimed by `endolin-garden-ece02cb4` (home `/home/kris/garden`), which FAILED the host gate: the sweep requires `/home/kris/garden2/tmp/s10e`, present ONLY on `endolin-garden2` (home `/home/kris/garden2`). That whole home is absent on the mis-claiming host, so the sweep could not run. This is the single capped re-post.

## HOST GATE (re-check before running)
Run `ls -d /home/kris/garden2/tmp/s10e`. If absent, you are MISROUTED again — do NOT run; complete with a one-line tada "MISROUTED to <host>; s10e absent; NO further re-post (cap already spent)". Do NOT re-post a third time.

## The work (unchanged from the original spec — read the original job base `xs2rust-endor-stage10o-remeasure` for full detail)
Re-sync `rust/` to the REAL remote tip (verify `git diff <content-base>..tip` rust/-only, 0 deletions; moddable pin `23b4d6b0a65f`), `cargo build --release -p endo --bin endor` (capture BUILD_EXIT by exit code), regenerate 3 XS bundles + md5-compare priors, smoke `context.test.js` (expect 10/10 ec=0), guard the 3 env-artifact classes. If the stage-10o diagnosis child delivered an s10e remediation, APPLY it and say so. Then run the 52-file daemon sweep (default ava reporter, `--concurrency=1 --timeout=25s`, detached setsid nohup, resumable checkpointed TSV per `/home/kris/garden2/tmp/s10l-results/sweep.sh`; outer 240s, channel.test.js 900s, reap orphaned endor procs per file). Artifacts to `$HOME/tmp/s10o-results/`.

Prior anchors: s10i/s10k/s10l/s10n pass=760/fail=15/skip=20/pending=6, TSV byte-identical; C-XS same-harness 530/19/20/0.

## Required answers (in tada)
1. error-trace pin — did it MOVE? Name each of 7 error-trace.test.js tests + pass/fail/pending vs the s10i/s10k/s10l/10n anchor (1 pass / 1 fail / 6 pending on s10e); state whether pin flipped and whether the s10e remediation landed.
2. Any NEW daemon failure class beyond ledgered {content-store-gc 9, git 3, git-remote 2, error-trace 1 fail + 6 pending}? Confirm each fail by first failing assertion.
3. Any class changed? If yes re-run C-XS baseline for that class; else 530/19/20/0 stands.
4. Decomposition table by class (pass/fail/skip/pending) at measured tip, with tip sha + `git diff <content-base>..tip` shape.

HARD STOP: one 2400s invocation; sweep detached, survives reaper requeue (resume from checkpointed TSV). Report via tada ONLY.
