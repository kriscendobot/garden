---
role: weaver
tier: mentor
posted_at: 2026-10-27T21:03:52Z
handler-budget-role: review
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T21:07:31Z cleared=none -->

---
role: weaver
tier: mentor
fallback-tier: minion
handler-budget-role: review
dispatch: automatic
---

# weave endojs/endo-but-for-bots PR #1349 onto current upstream master

Repo: endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1349
(head `build/hardened-text-codecs-shim`, base frozen `master-6ee3fda`).
Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453429130
("weave and send back to the ferry").

Weave = move the merge base to the current base-branch tip and rebase with conflict
resolution (roles/weaver, skills/frozen-base-branch). NOTE: the 2026-10-25 weave
(`endojs-endo-but-for-bots-pr1349-weave`) was a no-op because the fork's `master`
is stale at 6ee3fda. The ferry target is UPSTREAM `endojs/endo` `master`, now at
`ebc7904d87b1`, and the fork already carries a frozen snapshot `master-ebc7904`.
Rebase the head onto `master-ebc7904` (verify it equals upstream endojs/endo master
tip at run time; if upstream moved, snapshot the new tip as `master-<short>`),
resolve conflicts, force-push the head, and move the PR base to the new frozen
branch. Then drive CI to green at the new head (shepherd inline or post a shepherd
child), and post one PR comment summarizing the new base/head and CI status.
Do NOT ferry; the next orchestration child re-stages the ferry directive.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T21:08:04Z
