**Gauntlet viability: kriscendobot/minion.town PR #195** ("fix(guest-web): stop echoing the bearer credential in guest state answers")

The gauntlet can start. The PR is open, unmerged and still a draft, at head `2800358ef0`. Its frozen base is `main-51ad067`.

**Deciding question:** Does `main` still return the guest's `formulaIdentifier` (its bearer credential) in the `GuestWebState` answers from `GET /api/guest` and the invitation-accept route, with no other PR or commit already removing it?

**Evidence:**
- `main` has no commits beyond the frozen base `main-51ad067`, so the base the PR was built on is still current.
- On `main`, `src/web/guest-web-service.ts` still has `formulaIdentifier: string` in `interface GuestWebState` (line 6), and the memory backend's `state()` still sets `formulaIdentifier: guest.id` (line 76). The leak the PR fixes is still there.
- I searched every open and closed PR for formulaIdentifier, bearer and guest-state work. Nothing else targets this. The nearest one, #170 ("scrub and encrypt locator fragments"), deals with locator fragments, not the guest-state answer.
- The PR was opened today, 2026-10-16. It has no reviews or comments yet, and no maintainer has pushed back on it.

The PR has not been superseded, and the problem that motivated it still exists.

I spent nothing on clean, panel, fix, CI-wait or un-draft work, and made no changes anywhere.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr195-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (116522 cached reads)
- Output: 1062 tokens
- Cost: $0.3853684
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
