I ran one panel round on PR #183 and the result is **must-fix**. The verdict is posted on the PR.

- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` ran in an isolated checkout of `kriscendobot/minion.town` `build/inference-phase3-secrets` at head `80f48534`, against base `main-bc11010`. It exited 0 with disposition `must-fix`. All 33 seats returned; three requested changes (migrator, saboteur, breaker).
- **Verdict posted:** the review is the "Panel verdict — round 2: must-fix" on https://github.com/kriscendobot/minion.town/pull/183. GitHub won't let the bot request changes on its own PR, so it went up as a plain comment, the same as round 1.
- **Edits to fit GitHub:** the panel's full report was 87 KB, over GitHub's 65,536-character limit for a review. I kept the summary and the three request-changes reviews in full, cut the comment-only seats to about 2.3 KB each, and listed the approve-verdict seats by name only. The posting tool also refused two bare links (`#1403`, `#1412`) that pointed at another repo, so I spelled them out in full as `endojs/endo-but-for-bots#1403` and `#1412`.
- **Round 1:** the round-1 must-fix items look fixed: the secret name is now derived from the subject, the wiring has tests, migration is serialized and tested, and the breaking change is documented.
- **Must-fix items for the fix loop:**
  1. The new `auth-failed` result from the bundled Claude harness isn't handled in `toMinionOutcome`, so a rejected credential is recorded as unclassified instead of triggering re-auth.
  2. A gate refusal (`needs-containment`) is counted as an unclassified provider failure, and only after the inference slot has been taken. A guest can use this to trigger false alerts and briefly hold the slot.
  3. `status()`, `planModels()` and `storedAt()` can throw when the daemon is unreachable, because migrating an old credential record calls `putSecret` while reading.
  4. The empty `catch {}` in `readSecret` treats any lookup failure as "absent", so a transient fault looks like a missing credential.
  5. The per-subject vault queue has no timeout, so one hung daemon call blocks every later operation for that subject, including `revoke`.

Follow-up: the gauntlet driver's next stage is the fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1212483 cached reads)
- Output: 6775 tokens
- Cost: $0.9246846
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
