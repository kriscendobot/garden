---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# finish Ironhorse iterator metadata across the hardened262 scenario matrix

Continue endojs/endo-but-for-bots draft PR #1299 (`fix/ironhorse-iterator-intrinsic-metadata`) and own every remaining requirement from predecessor `ironhorse-iterator-intrinsic-metadata`.

The predecessor re-derived current `llm` and landed commit `07af274dfbe`: `%IteratorPrototype%` already passes the two supported bare Ironhorse script scenarios, and the commit names `%AsyncIteratorPrototype%[Symbol.asyncIterator]`, adds an XS-differential regression, and moves the async probe to passed in those same two scenarios. A full baseline regeneration leaves 44 Iterator/AsyncIterator failure entries because the harness deliberately classifies all Ironhorse module/compartment cells as `structural:scenario-not-supported`, both lockdown script cells fail on `ironhorse-missing-global:lockdown`, and every SES-Ironhorse script cell fails in the SES prelude. `packages/hardened262/README.md` documents the module-parity gates, and current `baseline/sesIronhorse/*/passed.txt` files contain zero tests.

Do not paper over structural gaps by relabeling unsupported scenarios. Either implement the real module/compartment/lockdown and SES-Ironhorse execution needed for these probes to pass, or obtain and durably record a maintainer correction narrowing the stale 48-entry acceptance criterion. Update PR #1299 rather than opening a duplicate, regenerate the complete baseline, remove all Iterator/AsyncIterator failures that genuinely pass, and run `yarn workspace @endo/hardened262 test:xs`. The job is complete only when the predecessor's original Done section is genuinely met or the maintainer explicitly revises it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T01:09:34Z
