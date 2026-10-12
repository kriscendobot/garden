Panel round 5 for kriscendobot/minion.town PR #181 came back **must-fix**, and the verdict is posted on the PR.

**What I did**
- Made an isolated checkout of `kriscendobot/minion.town@git-remote-served-clip` at head `a95f956`. Its merge base is the frozen base `main-c7bdf20` (`c7bdf201`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 181 origin/main-c7bdf20`. It exited 0 with disposition `must-fix`, and the run was recorded at `panel-runs/kriscendobot-minion.town-181/d8263cec6e74.md`.
- 39 seats ran. Two requested changes:
  - **decomplector (must-fix):** rounds 2 to 4 each patched the same write-side served-clip machinery without asking whether it is needed. That machinery is the queue, intent markers, marker and full sweeps, tombstones, purge requests and `withdrawWithoutProjection`. The PR should say why updating on push, plus one reconcile at startup, can't do the job, or else cut the extra machinery.
  - **archivist:** the Status line in `designs/git-remote-served-clip.md` says "spec only, no live change", but the same doc names this PR as the build.
- Both reviewers also raised should-fix points. Prover: the deploy-skew test only checks a copy of the old validator, and the spawn-failure test depends on timing. Curator: `PARSE5_VERSION` drifts from the declared dependency range, and two separate type declarations describe the partition served-state record. Assessor: an early return on a missing clip id re-queues forever with no backoff.
- Posted the aggregate as review 5491013609 on https://github.com/kriscendobot/minion.town/pull/181. It is a COMMENT review, as in rounds 2 to 4, because GitHub doesn't allow request-changes on your own PR. It starts with "Panel verdict (gauntlet panel round 5): **must-fix**".
- The full aggregate is about 93 KB, which is over GitHub's review size limit. The posted review therefore includes the must-fix summary and as many full seat reports as fit, starting with the two that requested changes. The 16 seats left out are named in the review, which points to the panel-runs record for the full text.

**Follow-up:** the fix-loop stage is next. The decomplector's finding is a scope question about the design, not a code bug. A fixer may need to answer it in the PR body or pass it to the maintainer rather than patch the machinery a fifth time.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (695626 cached reads)
- Output: 4754 tokens
- Cost: $0.7601732
- Wall-clock: 254s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
