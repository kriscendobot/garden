---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement Option B of designs/opus55-tier.md (resolved 2026-09-23 by
mentat-opus55-tier-open-questions-20260923): register Opus 5.5 at mentor and
raise the anthropic automatic ceiling to it. Follow the design's "Exact changes"
section:

1. Add `anthropic\tclaude-opus-5-5\tmentor` to scripts/jobs/model-tier-inventory.tsv,
   ordered BEFORE claude-opus-5 (first-match makes it the anthropic mentor default).
2. Add claude-opus-5-5 to the anthropic patterns in scripts/jobs/model-routing-defaults.tsv
   and the inline anthropic fallback in scripts/jobs/common.sh. Optionally add an
   `opus55` short alias for hand pins.
3. Option B: remove the anthropic mentor downshift from scripts/jobs/handlers/monk-claude.sh
   (the serve_tier=minion block) and its matching ceiling-suppression case from
   scripts/jobs/reaper.sh. Automatic effort is `medium` = Opus 5.5's default, so add
   NO effort flag/plumbing to the handler.
4. Extend scripts/jobs/test/gardener-claude-tier-serving-test.sh and the inventory
   tests; under Option B update scripts/jobs/test/reroute-role-floor-test.sh too.
5. Update designs/provider-model-catalog.md and skills/model-selection/SKILL.md
   (retire the "anthropic automatic-work cost ceiling" downshift language; new ceiling
   is claude-opus-5-5).

Pricing confirmed current 2026-09-23 (Opus 5.5 $4/$20, cache read $0.20). Keep
Opus 5 selectable (do not remove its rows). Run all tier/inventory/reroute tests
before completing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T17:48:29Z
