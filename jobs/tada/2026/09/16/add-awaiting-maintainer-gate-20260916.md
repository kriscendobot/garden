Implemented and pushed to `main2` at `ad6e178476`.

- Added first-class `awaiting-maintainer` gate with mandatory question and issue/PR/comment URL.
- Wired posting, atomic re-gating, explicit `promote-plan.sh --maintainer` release, bulletin rendering, documentation, and foreman exclusion.
- Audited the referenced 125-job deferred snapshot: found 3 maintainer-gated jobs. Moved 2 to `awaiting-maintainer`; withdrew the obsolete SIWE remainder because PR #80 superseded it.
- Regression coverage: `awaiting-maintainer-gate-test.sh` passed 7/7, including survival of a real foreman tick unclaimed. Full `run-test.sh` passed 386/386.
- Follow-up: normal rolling deployment must advance hosts before the new command surfaces are available from deployed checkouts.

Self-improvement: updated `skills/job-board/SKILL.md` with the new gate and promotion procedure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/add-awaiting-maintainer-gate-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1242s

<!-- garden-usage-end -->
