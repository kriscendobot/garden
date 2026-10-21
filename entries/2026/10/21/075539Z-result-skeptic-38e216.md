---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-21T07:55:41Z
job: endojs-endo-but-for-bots-pr1517-gauntlet-panel-4
claim: e7930fe75c2c6b6b
---
**Verdict:** request-changes

**Findings:**
- Must-fix. `Inspection and acceptance` says the guest-native design "already records" an accepted-state receipt, but that design labels the formula-store state machine an Open Question and its implementation-status table says returned status records remain unimplemented. The enclosure replay, restart, and locator-dropping contracts all depend on this absent prerequisite. Specify the required guest-native state-machine work as a prerequisite/slice with its atomic boundary, rather than treating it as an available seam. [proposed-rule: A dependent design must distinguish shipped interfaces from target-state dependencies and make its prerequisite implementation and ordering explicit.]
- Must-fix. `Creation and authority` classifies an enclosure as local only when its node is the daemon node. The graph instead treats registered guest agent keys as local too (`isLocalKey`), and guest-owned formulas deliberately use those agent-key nodes. An enclosure from another local guest would be recorded without an edge or pin, so GC can collect the supposedly retained capability. Define locality through the graph’s `isLocalId` semantics and add a cross-local-guest retention case to the test plan. [proposed-rule: Retention designs must use the formula graph’s existing locality predicate, including local agent-key nodes, and test every local identity class.]
- Must-fix. Steps 2 and 3 resolve every path and only then pin the local identifiers. A source pet name can be removed after resolution but before its later pin, allowing collection in precisely the handoff window the design claims is protected. The proposed test only asserts a concurrent removal cannot collect, but does not cover this ordering. Require an atomic resolve-and-pin operation or hold the relevant graph/store synchronization across each resolution-to-pin transition, then test removal at that boundary. [proposed-rule: A design claiming GC-safe handoff must identify an atomic or synchronized resolve-to-retain boundary and test the pre-pin interleaving.]

Self-improvement: nothing this time.
