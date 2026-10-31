---
posted_at: 2026-10-31T14:44:03Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Pre-push probes report false positives on pure identifier renames (garden repo, main2:
`scripts/jobs/gardening/pre-push-gates/probes/` and `skills/build-vs-buy/detect.cjs`).

Seen on the endojs/endo-but-for-bots daemon->manager rename (job
`build-daemon-rename-to-manager`, head `daemon-rename-to-manager-llm-9a14ddf`):
- `prefer-endo-primitives` flags "adds bare Far" in 11 test files where the only change on the
  line was the property key (`workerDaemonFacet: Far('Worker', {` became
  `workerManagerFacet: Far('Worker', {`). The idiom pass treats every added diff line as new
  even when the paired removed line carried the same idiom.
- `no-plain-reexport` flags `export { WorkerFacetForManagerInterface } from
  './worker-facet-interface.js'` in packages/daemon/src/interfaces.js as a "new" re-export.
  It is the same pre-existing re-export with a renamed binding (same source module, same
  position).

Make both probes rename-aware: an idiom or re-export that is present on the paired removed
line (or at the same source module and position in the base) is not newly introduced. Add
regression cases to `scripts/jobs/test/review-convention-probes-test.sh`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-31T15:09:18Z
