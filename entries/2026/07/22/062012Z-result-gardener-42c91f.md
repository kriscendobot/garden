---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-22T06:20:14Z
---
---
job: audit-conductor-approval-gate-792
role: fixer
---

Confirmed root cause for endojs/endo-but-for-bots #792: the restored merge job recorded only CI-green plus mergeable and then squash-merged. The gauntlet had parked that merge job as ready after green CI. The downstream ready-to-land probe checked OPEN, MERGEABLE, and green checks only; ci-wait-merge independently rejected CHANGES_REQUESTED but had no affirmative maintainer-approval check. Thus a repo without branch protection requiring reviews could merge with zero reviews.

Landed main2 gate changes in the current worktree: pr-maintainer-approval-gh.sh reads journal2 maintainers/allowlist (fallback bootstrap owners kriskowal and erights only if empty), requires reviewDecision=APPROVED, and requires a maintainer APPROVED review for the current head commit. pr-mergeable-gh.sh applies it before posting a conduct job and ci-wait-merge.sh applies it immediately before either direct or auto merge. Missing, dismissed, stale, or non-maintainer approval exits with merge blocked: no maintainer approval. Conductor and botanist norms now require the spine. The Dependabot botanist lane was identified and is approval-required, not exempted.

Tests passed: pr-maintainer-approval-gh-test.sh (5/0: no review, dismissed, stale, maintainer, non-maintainer); ci-wait-merge-test.sh (29/0); comment-watcher-test.sh; run-test.sh; shellcheck for changed scripts. Activation requires the next deliberate leader-supervised deployment of main2 to each root.
