Panel round 3 posted. Disposition is must-fix.

## Completion report

**What I did**
- Resolved PR #63 head: `kriscendobot/minion.town` branch `docs/reconcile-weblet-register-by-id` (design PR, base `main`, still draft).
- Checked out an isolated project worktree keyed to this job base.
- Ran the scripted jury panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree with base-ref `main` (normalized to `origin/main`). Seven seats fired: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice.
- Panel disposition: **must-fix** (recorded in `panel-runs/kriscendobot-minion.town-63/9854a472df30.md`).
- Posted the aggregate verdict as a `gh pr review` on PR #63.

**Verdict shape note**
- A `--request-changes` review was rejected by GitHub ("Can not request changes on your own pull request") because the fleet `gh` is pinned to the bot identity, which authored the PR. Consistent with rounds 1 and 2, I posted the aggregate as a **COMMENTED** review whose title/body clearly state **must-fix**, so the next-stage-owed heuristic still reads the disposition.

**Substance of the must-fix (design panel)**
Recurring load-bearing findings across seats:
- § 3.1's evaluate snippet computes `directoryPetName = "site-" + hash` before the directory exists, contradicting the doc's own later definition of `hash` (derived from `identify()`) and diverging from the landed `guestRegisterSource` — chicken-and-egg on the core identity mechanism (critic, novice).
- No stated directory-shape invariant: a caller-supplied `directoryId` is only regex-validated for string shape, not object kind, so a non-directory formula id could be served publicly; § 7 lacks a matching acceptance criterion (skeptic).
- Caller content (`frontTree`, `hash`, `backPetName`) spliced into evaluate source text rather than bound through the name-binding mechanism — a regression toward string-templated code; plus the persisted `owner` field name overclaims vs. what the write path verifies (decomplector).
- Synonym drift for the operator registry (five interchangeable names); unintroduced-jargon and one dense load-bearing sentence; citation-form inconsistencies (`§` vs `Section`, slash vs comma joins, bold run-in label punctuation) (ergonomist, copyeditor, pedant).

**Follow-ups**
- Next gauntlet stage (fix-loop) owns addressing the must-fix findings; this stage did not fix, un-draft, or loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr63-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (706704 cached reads)
- Output: 4350 tokens
- Cost: $0.9132340000000001
- Wall-clock: 443s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
