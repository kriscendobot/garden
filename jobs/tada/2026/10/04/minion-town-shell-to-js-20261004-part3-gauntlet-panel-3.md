Round 3 of the panel on kriscendobot/minion.town PR #154 returned **must-fix**; the verdict is posted on the PR as a review.

**Run:** `panel.sh` ran in single-round mode on an isolated checkout of the PR head (`36b972c`) against base `chore/javascript-only-scripts-part-2b-2ca6c15`. It exited 0 with disposition `must-fix`.

**Seat count (34):** 5 request-changes (archivist, prover, saboteur, wire-watcher, scribe), 10 comment-only, 19 approve. The integrator's block carried no verdict in its header, but its body says approve, so it is counted with the approvals. The phase/evidence pre-pass moved from BLOCKED (round 2) to ATTENTION, and the integrator checked the ledger against both governing designs and found it accurate. Reviewers confirmed the round-2 must-fix items were fixed.

**Must-fix items:**
1. **Root shell injection (saboteur):** `deploy/aws/scripts/provision-guest-reminders.js:165` puts the raw `agent` argument into the remote script that `deprovision` runs as root. A related should-fix: `remoteStage` is also unquoted at `:177`.
2. **Duplicate manifest keys (wire-watcher):** `npm-registry-backup.js` `readManifest` lets the last duplicate `db_sha256` or `cas_inventory_sha256` line win. That defeats the hash check that guards restore; the old shell version failed closed instead.
3. **Reaper tests don't test anything (prover):** the two "exits 0" reaper tests still pass when the error handling they claim to cover is deleted.
4. **Stale variable name (archivist):** `ENDO_COMMIT` is still used in a comment and a test title in `test/endo-pin-drift.test.ts`; the code now uses `endoCommit`.
5. **Missing summary comments (scribe):** neither fix round posted the required top-level summary comment on the PR.

The review also lists the comment-only seats' should-fix items, such as the reaper accepting `pid=0` and `renderRemoteProgram` rendering an `undefined` value as the text "undefined".

**Review:** https://github.com/kriscendobot/minion.town/pull/154#pullrequestreview-5408206952 (state COMMENTED, on commit `36b972c`).
- It is a comment, not a request-changes review: GitHub rejects request-changes on your own PR, and the round-1 and round-2 verdicts were posted the same way. The body opens with `## Panel round 3 — must-fix`.
- The full aggregate was about 76K characters, over GitHub's ~65K limit for a review body. I posted a summary plus the full text of every request-changes and comment-only seat, and cut the approve seats to one line each (47.6K total).

**Follow-ups:** the next fixer round owns the five items above. One gap in the panel itself: the procurer seat couldn't resolve the fork base ref, so its build-vs-buy check didn't run. I flagged that in the review as a missing check, not a problem with the PR.

No garden repo changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1028088 cached reads)
- Output: 7383 tokens
- Cost: $0.8756696
- Wall-clock: 1560s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
