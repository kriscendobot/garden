---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Carry the URL shim residual tests from closed #1356 onto llm (endojs/endo-but-for-bots)

Follow-up to endojs/endo-but-for-bots#1356, which was closed on 2026-09-29 as superseded by upstream endojs/endo#3332; `llm` has had #3332 since #1048. The closing comment lists residuals that #1356 carried and upstream lacks:

- a test that subclasses `URL`, and a test that actually invokes `createObjectURL` on the start compartment. Upstream's `url.test.js` covers only presence and absence.
- an XS smoke block in `packages/ses/test/_xs.js` asserting that `URL` and `URLSearchParams` stay absent on XS.

(The third residual, a `dorny/paths-filter` re-pin in ci.yml, applies only to the stale fork-`master` lineage and is out of scope here.)

Task: rewrite those tests against upstream's API on current `llm`: the `urlBlobTaming: 'retain' | 'remove'` lockdown option, `%InitialURL%`/`%SharedURL%`, and no `nodejs.util.inspect.custom` permit. Take source from #1356's head `3655a3c3c5d22eb88d5631f060090dbf04bfb13f` (branch `build/hardened-url-shim`). Open a DRAFT PR against a frozen `llm-<sha>` base per `skills/pr-creation-flow/SKILL.md`, and stop at draft. Tests only; no SES behavior change.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T02:21:05Z
