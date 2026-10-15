---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-15T09:49:28Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-2
claim: 2552efbd2247575b
---
Dispatch: migrator review of endojs/endo-but-for-bots PR #1392.

**Verdict:** request-changes

**Findings:**
- **must-fix** — `.changeset/pass-style-parcel.md:2` marks `@endo/pass-style` minor while the same entry says that downstream exhaustive `switch` and `Record<PassStyle, ...>` callers stop type-checking. `packages/pass-style/src/types.d.ts:45` widens the exported discriminant, so this is a source-breaking public contract and requires a major bump (and the coordinated dependent release entries). [rule: roles/jurors/migrator/AGENT.md § Operating norms]
- **must-fix** — `packages/patterns/src/types.ts:74` and `:131` derive public `Key` and `Pattern` from the newly widened `Passable`, thereby admitting `ParcelObject` (including in nested containers), but `packages/patterns/src/keys/checkKey.js:535` and `src/patterns/patternMatchers.js:442` reject the same values. A typed downstream caller can therefore pass a Parcel as `Key`/`Pattern` and encounter rejection. Exclude Parcel from these exported recursive contracts and add type tests. [rule: roles/jurors/migrator/AGENT.md § Operating norms]
- **should-fix** — This one release-cycle change is divided among `.changeset/pass-style-parcel.md`, `patterns-parcel.md`, and `marshal-parcel-rank.md`. Consolidate the three package entries into one changeset after correcting the bump, so downstream readers receive one coherent migration note. [rule: skills/changeset-discipline/SKILL.md § What goes inside]

Self-improvement: nothing this time.
