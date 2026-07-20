---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10o
priority: normal
posted_by: producer
posted_at: 2026-07-20T07:52:28Z
---

---
model: opus
---
# stage-10o child 2: outage-hardened 52-file daemon sweep re-measure at the stage-10o tip

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT), branch `xs2rust-endor`.
**Measurement-only: zero commits, zero pushes, zero PR comments.** You run AFTER stage-10o children 0
(reflection/namespace-ownkeys completion) and 1 (live-env diagnosis). Read their tadas, the stage-10m
children's tadas (`8b9c050825`, `d268092d7b`), and the latest `xs2rust-endor-press-*` tadas FIRST (the
hourly press can advance or REBASE; if a press is live, message it to defer), then fetch the REAL remote
tip.

## PRECONDITION — HOST GATE

This sweep runs in `/home/kris/garden2/tmp/s10e`, which exists ONLY on `endolin-garden2`. If it is absent
on the host that claimed you, you are MISROUTED (as the 10n diagnosis was) — do NOT run; complete with a
one-line tada "MISROUTED to <host>; s10e absent; re-post owed" and, if you can, re-post
(`post-job.sh xs2rust-endor-stage10o-remeasure-retry <pointer>`). Cap one re-post.

## Tip / skip rule

The tip has ADVANCED past the last measured sha (`1481757f7f`, the s10l/10n anchor — 10n measured
`d268092d7b` TSV-IDENTICAL to it) AND stage-10o child 0 likely pushed reflection/namespace commits on top.
A SKIP is available ONLY if the branch regressed to an already-measured sha (say which). Otherwise MEASURE
the new tip. If child 0 changed enumeration (gOPN over namespaces, native-fn reflection), the engine
`cargo test` count grows — that is expected; the 52-file DAEMON sweep counts are what this child anchors.

## Env re-sync + preconditions

Re-sync `rust/` to the tip (verify `git diff <content-base>..tip` is rust/-only, 0 deletions; git-archive
tar-overwrite or `git reset --hard`; moddable pin `23b4d6b0a65f…`), rebuild `cargo build --release -p endo
--bin endor` (**BUILD_EXIT=0 by exit code, capture to a file**), regenerate the 3 XS bundles and
md5-compare against priors, smoke `context.test.js` (expect 10/10, ec=0). Guard the three env-artifact
classes (short AF_UNIX path; no provisioning-race asserts; no stale seeded `target/`). **If the stage-10o
diagnosis child delivered an s10e remediation, APPLY it and say so** — the error-trace answer changes
meaning depending on whether the env can now observe the pin flip.

## Sweep

52 files, default ava reporter (TAP crashes in `dumpError` on timeouts), `--concurrency=1 --timeout=25s`,
detached setsid nohup, resumable checkpointed TSV (the proven `/home/kris/garden2/tmp/s10l-results/sweep.sh`
shape — outer timeout 240s, channel.test.js 900s, reap orphaned endor procs after every file, settle on
load). Artifacts to `$HOME/tmp/s10o-results/` (mkdir first). Prior anchors: s10i/s10k/s10l/s10n
**pass=760 / fail=15 / skip=20 / pending=6**, TSV byte-identical across them; C-XS same-harness anchor
**530/19/20/0**.

## Required answers (in your tada)

1. **Error-trace pin — did it MOVE?** Name each of the 7 `error-trace.test.js` tests and its pass/fail/
   pending vs the s10i/s10k/s10l/10n anchor (1 pass / 1 fail / 6 pending on s10e). State whether the pin
   flipped — and if not, whether that is because the s10e remediation did/did not land (the pin is proven
   7/7 on s9r; on s10e it is host-gated until the diagnosis remediation lands).
2. **Any NEW daemon failure class** beyond the ledgered {content-store-gc 9, git 3, git-remote 2,
   error-trace 1 fail + 6 pending}? Confirm each fail by its first failing assertion.
3. **Any class changed?** If yes, re-run the C-XS same-harness baseline for that class; else the 530/19/20/0
   anchor stands.
4. **Decomposition table** by class (pass/fail/skip/pending) at the measured tip, with the tip sha and the
   `git diff <content-base>..tip` shape (rust/-only? deletions?).

HARD STOP: size to one 2400s invocation; the sweep runs detached and survives reaper requeues (resume from
the checkpointed TSV, do not restart). Report via your tada completion report ONLY (never inbox-send the
parked supervisor).
