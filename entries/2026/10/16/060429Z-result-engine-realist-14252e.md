---
kind: result
role: engine-realist
host: endolin-garden-ece02cb4
at: 2026-10-16T06:04:31Z
job: kriscendobot-minion.town-pr180-gauntlet-panel-13
claim: 51f6415b989fa43e
---
Dispatch: engine-realist review of kriscendobot/minion.town PR #180 against c7bdf2018897930f413a2caf21191f2b26b4b514...HEAD.
project: minion-town

**Verdict:** request-changes

**Findings:**
- must-fix: `src/endo/guest-control.ts:460-508` serializes `create` only against another bind, while the exposed `remove` path at `src/endo/guest-control.ts:403-405` does not share that lock. A concurrent `remove(petName)` can run after `open(...)` has stored the formula but before `infoOf(petName)` reads it. The create call then fails, the retention key exists only in the discarded evaluation path, and the durable partition remains quota-counted and unrecoverable until operator intervention. Serialize all mutations of the target pet name, including removal, or make binding and inspection atomic; add a controlled interleaving regression test. [proposed-rule: A guest-directory deletion that can race a multi-step durable capability bind must share the bind's per-pet-name serialization, preventing quota-consuming unreachable allocations.]

Self-improvement: nothing this time.
