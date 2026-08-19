---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reply to erights on endojs/endo-but-for-bots PR #475: humans-only-resolve is now fleet-wide policy

Repository: endojs/endo-but-for-bots. Standing PR-comment authorization applies
(journal/projects/endo-but-for-bots/README.md § Standing authorizations).

## Context

erights asked the bot to stop resolving PR review conversations on #475 and
explicitly deferred to kriskowal whether "humans-only resolve conversations"
should become general policy across all PRs:
https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5333026938

kriskowal decided: **yes, this is now fleet-wide policy.** The garden's
standing instructions are being updated accordingly
(`revise-standing-instructions-defer-to-submitter`, landing on `main2`): no
agent ever resolves a PR review conversation thread going forward — that's the
submitter's call — with a maintainer-directive override available the same
way issue-closes and PR-closes already work.

## What to do

Post a reply comment on PR #475 (top-level, or in-thread on erights' comment
if that reads better) confirming the decision in plain terms: the fleet will
no longer resolve review conversation threads on any PR; that stays the
reviewer's action going forward, with the standing maintainer-override
mechanism unchanged. Keep it short — this is a status confirmation, not a new
proposal. **Do not resolve any conversation thread while posting this** (that
would be the exact behavior being retired).

If the standing-instructions job has already landed on `main2` by the time you
claim this, you may cite the landed commit; if not, say the change is in
flight rather than waiting on it — the policy decision itself is already made
and doesn't need to wait on the doc edit landing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-19T04:33:27Z
