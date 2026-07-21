---
role: fixer
---

Fix the three red CI checks on endojs/endo-but-for-bots PR #723 (`@endo/fetch` confined-outbound-HTTP plugin, branch `build/endo-fetch-plugin`): the two `lint` failures (Typedoc/TS type errors in `packages/fetch/src/index.js`, `service.js`, and `store.js` — `policyMode`/`PolicyMode`, `.test()` argument, and `readJSON` return typing) and the failing `test` job, applying source-level type fixes rather than suppression so Typedoc's strict JSDoc mode passes. Drive all checks green so the PR can clear the gauntlet and un-draft, landing M3's confined-outbound-HTTP capability.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  worker_kind: gardener
  claimed_at: 2026-07-21T20:23:09Z
