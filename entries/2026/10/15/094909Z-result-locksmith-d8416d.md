---
kind: result
role: locksmith
host: endolin-garden-ece02cb4
at: 2026-10-15T09:49:11Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-2
claim: 2552efbd2247575b
---
Originating dispatch: user-directed locksmith review of PR #1392.
project: endo-but-for-bots

**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/pass-style/src/types.d.ts:103,112-120,168` adds `ParcelObject` to `Passable`, so the existing `PureData = Passable<never, never>` now accepts a Parcel directly and nested in every container. A Parcel is explicitly an opening capability, so this silently widens the capability-free type that callers may share as non-communicating data. Define `PureData` recursively without `ParcelObject` (including nested containers), and add negative type-contract assertions for direct and nested Parcels. [rule: roles/jurors/locksmith/AGENT.md]

Self-improvement: nothing this time.
