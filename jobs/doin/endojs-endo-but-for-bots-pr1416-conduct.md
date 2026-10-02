---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Conduct (un-draft -> merge) endojs/endo-but-for-bots PR #1416

https://github.com/endojs/endo-but-for-bots/pull/1416 is the docs-only
editorial follow-up to #1116 (`designs/guest-native-invitations.md`), head
`design/guest-native-invitations-editorial` @ 9a054a55f9, frozen base
`llm-ca1794f` (restore the live `llm` base per roles/conductor step 2).

Authorization: kriskowal's approving review on #1116 requested this editorial
pass and then said "Then, shepherd and conduct."
(https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5386747855).
#1116 merged before the pass ran, so the pass landed as #1416; that review is
the maintainer's merge authorization for it. Shepherd job
`endojs-endo-but-for-bots-pr1116-editorial-pass-open-pr` opened #1416 (draft)
and confirmed CI green (6 pass, 22 skipped) on 2026-10-02.

Un-draft if still draft, then merge. Do NOT name a merge method; the conductor
owns that (roles/conductor/AGENT.md). If you judge the cross-PR authorization
insufficient, ask the maintainer via message-user.sh rather than merging.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T21:29:31Z
