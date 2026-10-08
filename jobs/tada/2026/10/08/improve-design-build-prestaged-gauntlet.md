I fixed `scripts/jobs/design-build-handoff.sh` so it now handles a design PR whose gauntlet was staged before the designer finished. That was the case with design PR kriscendobot/minion.town#173. The fix is pushed to main2 as `10127fc2aeb`, and the regression test passes.

**Cause.** The coverage audit (`design-pr-gauntlet-coverage-audit`) staged the #173 gauntlet at 19:45:21Z with an empty `build_job:`. When the designer job completed, `auto-gauntlet-handoff.sh` merged into that existing gauntlet instead of re-recording it, so `build_job` stayed empty. The handoff script then rejected the gauntlet (the old line 105), posted no build job, and `assert-followup-posted.sh` blocked the completion.

**Fix.** The handoff now accepts a gauntlet record for the report's PR if either:
- its `build_job` names this job, as before; or
- its `build_job` is empty and the gauntlet is still running, is not a probe, and has not finished (`done` or `halted`).

It looks for that record under the usual PR-keyed name first, then under any other name for the same PR, such as a held-draft re-stage. It parks the build job `blocked_on` the gauntlet it actually matched, so the build is released when that gauntlet finishes. It then writes the handoff marker that the follow-up gate accepts. A gauntlet whose `build_job` names a different job is still treated as belonging to someone else and ignored. The header comment documents the new case.

**Tests.** I added three cases to `scripts/jobs/test/design-build-handoff-test.sh`:
- **(i)** replays #173: the gate blocks the raw report, the handoff parks `build-pre` blocked on the pr173 gauntlet, and the gate then passes.
- **(j)** a pre-staged gauntlet under a different name is matched and the build is blocked on that name.
- **(k)** a pre-staged gauntlet that is a probe or has halted gets no build and no marker.

All existing cases still pass. Shellcheck reports only its usual informational note about not following `common.sh`.

**Follow-ups:**
- The blocked designer job for #173 needs no manual action once hosts deploy this commit. The #173 gauntlet is still running (its viability stage is in todo/), so the designer's next completion attempt will park `build-<slug>` blocked on it.
- `roles/designer/AGENT.md` describes this handoff in terms that are still accurate, so I left it unchanged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-design-build-prestaged-gauntlet.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (989627 cached reads)
- Output: 8756 tokens
- Cost: $0.8852213999999999
- Wall-clock: 341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
