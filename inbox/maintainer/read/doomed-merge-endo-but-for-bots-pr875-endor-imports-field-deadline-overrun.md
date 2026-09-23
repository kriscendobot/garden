from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-06T07:33:07Z
doom_base: merge-endo-but-for-bots-pr875-endor-imports-field
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-06T07:33:07Z
last_seen: 2026-08-06T07:33:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 early-escalation cycle(s) on endolin-garden2-5bcdff64.
The gardener stamped the deadline-overrun counter, so the reaper surfaced it after 1
cycle(s) rather than the full 5-cycle doom threshold. The effective handler budget in
force for this job is 2400s. That counter is stamped for two DISTINCT shapes; check the
gardener log for the actual elapsed to tell which applies:
  (a) GENUINE wall-clock overrun — elapsed ≈ 2400s (rc=124 at the wall). The job does not
      fit one claim: SPLIT it into claim-sized stages, or raise its handler-timeout.
  (b) FAST repeated failure — elapsed far below 2400s (e.g. a 1–2s usage-cap/API rejection)
      flagged by elapsed-constancy. The budget is NOT the problem; read the handler log
      for the real cause (quota/usage cut, swallowed error) — raising the budget will not help.
The work is preserved at jobs/plan/merge-endo-but-for-bots-pr875-endor-imports-field; it stays HELD until a human promotes it
(promote-plan.sh merge-endo-but-for-bots-pr875-endor-imports-field) or removes it.
Original job base: merge-endo-but-for-bots-pr875-endor-imports-field

--- original job body ---
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


<!-- garden-deadline-overrun: 1 -->
