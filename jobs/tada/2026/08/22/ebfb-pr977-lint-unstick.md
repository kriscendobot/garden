Done. Maintainer notified and successor job posted.

## Completion report

**Job `ebfb-pr977-lint-unstick` — its lint deliverable was already complete; a separate defect surfaced and was routed.**

### What I found
This job was flagged SUPERSEDED (do-not-promote) but was force-promoted by a deadline-overrun clearance. On investigation the PR had moved well past its premise:

- **The lint fix is done.** `lint` on `endojs/endo-but-for-bots#977` is **SUCCESS**, and the `ebfb-pr977-gauntlet-rerun` report confirms all 23 CI checks were green at head `cc282686` (the lint-fixed head). The PR is **no longer draft** (`isDraft: false`, OPEN). The job's own deliverable (formatting fix + un-draft) is genuinely complete — nothing to redo, and re-running the formatter against a stale head would have been wrong.
- **A distinct new defect exists.** The current head `dc39fef1` (a *later* gauntlet's panel-1 fix commit) expanded the guest host-only surface test and now fails deterministically on all four `test` legs (node 22.x/24.x × ubuntu/macos): a guest method-name list deepEqual at `packages/daemon/test/endo.test.js:6429` where the expected snapshot still lists `provideSubMount`, absent from the actual daemon guest surface. This reads as **benign rebase drift** of the expected snapshot against `llm` (a `provide*` method renamed/removed upstream), **not** a host-only-method leak.

### Why I did not fix the test failure here
It is out of this job's "formatting only" mandate and touches the security-regression coverage the file exists for — exactly the "stop and report rather than accept a behavior-altering change" boundary the job set. Fixing it requires a weave/rebase and reconciling a security-sensitive surface list, not formatting.

### What I did
- Verified state end-to-end (lint green, un-drafted, current test failures reproduced from CI logs, related gauntlet jobs all in `tada/`, the maintainer's "weave, shepherd, conduct" directive job `...pr977-64413faf` **doomed/parked**).
- Posted a scoped successor fixer: **`ebfb-pr977-surface-drift-fix-20260822`** — weave onto `llm`, reconcile the drifted expected guest surface list while keeping the full host-only-absence / `@host`-rejection coverage intact, stop-and-report if the drift is a real leak, then shepherd/conduct to green. Kept incident specifics out.
- Notified the maintainer via the liaison with the same summary.

### Follow-ups
- `ebfb-pr977-surface-drift-fix-20260822` owns getting the PR green/merge-ready.
- No garden repo changes were made (this was a project-PR investigation); nothing to commit/push to `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr977-lint-unstick.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 19 tokens (542018 cached reads)
- Output: 15848 tokens
- Cost: $1.1969679999999998 (1 engagement(s) unpriced)
- Wall-clock: 2660s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
