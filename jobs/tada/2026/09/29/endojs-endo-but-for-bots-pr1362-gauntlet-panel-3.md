**Panel round 3 on endojs/endo-but-for-bots#1362: must-fix**

The round finished in the previous session. Last time I put the completion signal above the stage-result marker, so it wasn't the final line and the job wasn't recorded as done. The order is fixed below. I checked that the posted review is still there: review `5348076456` at head `e7efe199`, and no new work was needed.

- **Run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` on an isolated worktree of `endojs/endo-but-for-bots` `build/npm-dev-registry-serving` at head `e7efe19990`, against base `llm-3aa902d` (`3aa902d003`). It exited 0 with disposition `must-fix`, and all 33 seats finished with status `ok`.
- **Verdict posted:** the aggregate is about 93 KB, too big for one review, so it went out in two parts:
  - comment-review `5348076456`, headed "Disposition: MUST-FIX (request-changes)". GitHub won't accept request-changes on the bot's own PR, so it is a comment review, the same shape as rounds 1 and 2.
  - continuation issue comment `5884250349`.
- **Main must-fix findings:**
  - `readLimited` leaks the upstream connection when the size limit trips.
  - The stale-if-error fallback breaks once upstream has started sending a 200.
  - The integrator says the governing design is unlanded and the package builds a parallel CAS and registry table.
  - The stylist wants `dir`, `req` and `res` spelled out in full in the test files.
  - `SECURITY.md` is unadapted template boilerplate.
  - Three items lack tests: the `conflictReason` upstream branch, the refusals `ingestTarball` claims, and a property test for the "strongest listed algorithm" rule.
  - `isAllowlistEntry` is exported but neither re-exported nor listed as deliberately omitted.
  - The round-1 fix push got no summary comment.

No fixes, no un-draft and no garden commits. The gauntlet driver owns the next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1189926 cached reads)
- Output: 6502 tokens
- Cost: $1.6251466000000003
- Wall-clock: 451s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
