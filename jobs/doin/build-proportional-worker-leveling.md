---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-09T20:01:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement the proportional worker-leveling design from
`design-proportional-worker-leveling`, as reviewed by
`review-proportional-worker-leveling-mentat`.

Read, in order:
1. `jobs/tada/design-proportional-worker-leveling.md` (the design job's
   completion report) and the `designs/*.md` doc it produced.
2. `jobs/tada/review-proportional-worker-leveling-mentat.md` (the mentat
   review's completion report). **Check its verdict before writing any code.**
   If it reports "approved" (as-is or with its own inline corrections to the
   design doc), proceed to implement the (possibly corrected) design as
   written. If it reports "blocked pending the maintainer's call," **stop and
   do not implement** — check whether the maintainer has since replied (check
   `inbox/maintainer/` for a resolution, or the design doc itself for an
   update) before doing any work; if unresolved, report that back rather than
   guessing at the maintainer's intent.

Implement the reviewed design in `scripts/jobs/budget-level.sh` (and whatever
else the design names — likely `config/budget-pools` schema additions for the
cleric-split rule's basis, and `scripts/jobs/test/live-budget-admission-test.sh`
or an equivalent new test file). Extend the existing test suite with cases for:
the proportional monk ceiling across two differently-capped hosts, the
distinct cleric-split rule, and confirmation that the existing safety
properties (provenance gate, drain skip, confirm-before-move dwell) still hold
under the new rule. Land per the garden's own conventions.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-09T20:01:14Z
