## Panel round 2 on kriscendobot/minion.town#119: must-fix

I ran one panel round in single-round mode and posted the verdict on the PR. `panel.sh` exited 0 with disposition `must-fix`. The panel reviewed head `d9b3111` against base `561472a` (branch `main-561472a`) using an isolated checkout of `kriscendobot/minion.town@feat/claude-agent-credential-reauth`.

- **Seats:** 33 in total. 9 requested changes, 8 were comment-only and 16 approved.
- **Seats requesting changes:** assessor, migrator, locksmith, saboteur, breaker, purist, wire-watcher, duality-auditor and scribe.
- **Review:** https://github.com/kriscendobot/minion.town/pull/119#pullrequestreview-5324919007. It went up as a comment (state COMMENTED) because GitHub does not allow a request-changes review on your own PR; round 1 was posted the same way. It has the same shape as round 1: a must-fix header, the request-changes and comment-only seat texts in full, and the approving seats' texts left out to stay under GitHub's size limit. The full run is in the journal at `panel-runs/kriscendobot-minion.town-119/0735651995c6.md`.
- **Posting fix:** the `gh` wrapper refused the first post because the aggregate used bare `#N` references. I rewrote `#1015` as `endojs/endo-but-for-bots#1015` and `#119` as `kriscendobot/minion.town#119`, and put `#474` in backticks because it isn't clear which repo it refers to.

Main must-fix points for the next fix stage:
- **Unguarded `revoke()`:** in `agents.ts`, `recordOutcome` calls `credentials.revoke()` without catching errors. If that call fails, `infer()` rejects instead of returning the promised needs-auth result.
- **Missing end-to-end test:** no test drives the `recordOutcome` / credential-epoch path through `infer()`.
- **Stale-epoch check covers only one case:** `usage-exhausted` and `unclassified` outcomes are not checked against the credential epoch, so a stale outcome can be misreported after a reconnect.
- **`reauthFor` gives too much access:** `wiring.ts` returns the full mutating tracker rather than a read-only view.
- **Other seats:** further findings from breaker, purist, wire-watcher, duality-auditor and scribe are in the review.

I did no fixing and did not take the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1065063 cached reads)
- Output: 5957 tokens
- Cost: $0.8907525999999999
- Wall-clock: 610s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
