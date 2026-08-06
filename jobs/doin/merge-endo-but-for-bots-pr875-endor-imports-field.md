---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Merge endojs/endo-but-for-bots PR #875 (endor package imports field)

Finalize and merge PR #875
(https://github.com/endojs/endo-but-for-bots/pull/875) — "feat(endor):
package imports field (#-prefixed specifiers) for the npm-via-CAS registry
proxy".

Context: the PR carries a current APPROVAL from @kriskowal
(review 4871669598). Its branch `feat/endor-npm-imports-field` was just
rebased onto live `llm`, retconned to a clean per-package history
(one `feat(endor)` rust/endo commit + one `test(compartment-mapper)`
fixture commit; net diff byte-identical to the approved tree), and
force-pushed. New head: e3d43900a.

Conductor duties:
- Base is `llm` (a live trunk, NOT a frozen-base snapshot, NOT master) —
  merge target is `llm`. NEVER merge into `master` on this repo (master is
  upstream endo's; ferry-only).
- PR is already NOT a draft. If GitHub shows it draft, un-draft first.
- Rebase onto current `llm` if it has moved; block on CI to terminal and
  confirm all checks green on the live head before merging (do not
  force-merge a red/pending PR).
- Confirm the maintainer approval is still present on the head you merge.
- You own the merge method.

Once merged, this unblocks the parked follow-up design job
`endo-endor-registry-proxy-worker-refactor`.

<!-- garden-reaped: 0 -->

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-06T06:43:23Z
