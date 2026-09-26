**PR #119, gauntlet panel round 4: must-fix.**

- **Run:** I got an isolated checkout of the PR head `f993dc9` (`kriscendobot/minion.town`, branch `feat/claude-agent-credential-reauth`). I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `main-561472a`. It exited 0, ending with "code-panel single-round — must-fix".
- **Seats:** 33 in total. 6 asked for changes, 13 left comments only, and 14 approved.
- **Record:** the full panel record is in the journal at `panel-runs/kriscendobot-minion.town-119/91e6ae16a5b1.md`.
- **Review posted:** review 5325041188 on https://github.com/kriscendobot/minion.town/pull/119, pinned to commit `f993dc9`. It is posted as a comment, not a request-changes review, because GitHub refuses request-changes on a PR we authored ourselves. Rounds 1–3 were posted the same way. The body carries `<!-- garden-panel-verdict: disposition=must-fix round=4 -->`. The full aggregate was about 74 KB, over GitHub's review-size limit, so I left out the bodies of the approving seats and listed their names with a pointer to the journal record, as round 3 did. The posted body is about 54 KB.

**Main request-changes findings for the next fix round:**
- **assessor:** there is a gap in the credential-epoch guard on the fast path for an agent already marked as needing reauth (`agents.ts:107-115`). A `status()` call can read the old value between the two epoch bumps in `handleSetupToken`. `makeClaudeAgents` also has no direct tests.
- **stylist:** two new declarations use the abbreviation `sub`; they should say `subscription` (`wiring.ts:513`, `:526`).
- **saboteur:** when the usage window resets, `tick()` silently drops a usage-exhausted notice that was never delivered (`reauth.ts:596-604`).
- **breaker:** the stale-outcome guard in `recordOutcome` doesn't match what the module's own doc comment promises (`agents.ts:134-146`, `:172-175`).
- **wire-watcher:** an inference already running on a dismissed agent can park its `childFormulaId` again after `dismiss` released it.
- **integrator:** the PR description no longer matches the current head.

I made no fixes, did not un-draft, and ran no further rounds.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1006017 cached reads)
- Output: 4672 tokens
- Cost: $0.7859314000000001
- Wall-clock: 589s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
