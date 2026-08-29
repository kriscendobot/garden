---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Merge endojs/endo-but-for-bots PR #896

PR: https://github.com/endojs/endo-but-for-bots/pull/896
Head: kriscendobot/endo-but-for-bots branch design/cbor-encode-decode (bot-pushable)

Approved design PR (`design(cbor): split @endo/cbor into encode and decode entry points`).
The review directive's asks are resolved: the sibling-framing read/write factoring
follow-up was posted as a PR comment
(https://github.com/endojs/endo-but-for-bots/pull/896#issuecomment-5460617496).
The PR has been rebased onto current llm (head 37186ceb8df6b45ab5eff51a3657c9eaede3ac74),
conflicts resolved, and un-drafted; mergeable=true. Its predecessor endojs/endo-but-for-bots#885
is already merged, so the "lands after #885" note is satisfied.

Carry the merge to completion: block-watch CI to terminal via ci-wait-merge.sh and
`gh pr merge --merge` on green. kriskowal (maintainers allowlist) has an APPROVED review;
if the approval gate reads stale after the rebase, stall for re-approval per the conductor
brief — do not force. Bot repo (endojs/endo-but-for-bots llm trunk); never merge into master.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-29T05:42:54Z
