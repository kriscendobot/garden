---
title: Reactive update + security + phases + decisions + open questions
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "follow-family release pattern" — subscription-release-by-dropping-far-reference, no explicit `unsubscribe` — is the canonical Endo subscription discipline. The `pet:<name>` label-prefix decision is principled (keeps `RetentionPathSegment` flat; unambiguous because pet names can't start with `:`); contrast with adding a separate field. The locator-as-API-key choice (not pet-name) is the canonical identifier-discipline pattern — pet names are ambiguous (same name in multiple stores), locators are unique.
kind: index
section_count: 4
---

> Abstract: **Reactive update**: `followRetentionPaths(locator)` must coalesce updates in a microtask window so a `provideGuest` (which incarnates ~7 dependent formulas) yields *one* delta, not seven; use the `retention-accumulator.js` pattern. First delta arrives promptly (it's the snapshot). Producer holds no strong reference to consumer — dropping the far reference lets the iterator generator return on the next poll. **Security**: guests learning host structure mitigated by host-only methods (not on CapTP-exposed gateway). Cross-peer revelation: retention edges from peers expose peer's agent ID (already host-known via `known-peers-store`); peer's pet names never exposed — only local node's edges. Disincarnating critical formulas: UI suppresses button for `endo`, `host-agent`, user's own agent, deny-list maintained by host. Pet-name removal cascades: confirmation modal lists every name on the path before commit. **Affected packages**: `packages/daemon` (new methods + topic + microtask-coalesced wrapper + RetentionPath types export); `packages/cli` (`endo paths`); `packages/chat` (paths affordance + panel + integration with inventory/inbox/value-modal/formula-inspector). **Six phases**: (1) snapshot API + types export + label normalization + unit + two-daemon integration; (2) subscription API + formulaGraphChangeTopic + microtask coalescing + release test; (3) CLI; (4) chat panel read-only; (5) chat panel write affordances (delete-pet-name, disincarnate/reincarnate); (6) inspector + workers-panel integration. **Six design decisions**: host-only (surface elevation; guest knowing host names is a leak); `pet:<name>` label prefix (keeps segment flat; unambiguous); subscription-release-by-dropped-far-reference (no explicit unsubscribe); microtask-coalesced deltas; disincarnate/reincarnate are existing operations (not new lifecycle verbs); locator (not pet-name) as API key (locators are unique). **Five open questions** — formulaChangeTopic extension vs sibling topic; path-equality stable-key vs hash; union-group rendering; disincarnation deny-list spec; cycle-break integration test.

### Reactive update surface

The paths panel is the most demanding consumer because a single formulation can shift many paths at once. The shipping requirements:

- `followRetentionPaths(locator)` must coalesce updates in a microtask window so a `provideGuest` (which incarnates a chain of ~7 dependent formulas) yields *one* delta, not seven. Use the same accumulator pattern as `retention-accumulator.js`.
- The first delta must arrive promptly even if there are no changes yet (it's the snapshot).
- The producer holds no strong reference to the consumer; dropping the far reference lets the iterator generator return on the next poll.

### Security

| Concern | Mitigation |
|---|---|
| Guests learning host structure | Methods are on host/mail interfaces only; not in CapTP-exposed gateway. |
| Cross-peer revelation | Retention edges from peers expose the peer's *agent ID*, which is already a host-known fact (it's in `known-peers-store`). The peer's *pet names* are never exposed — only the local node's edges, of which the peer's edge is one. |
| Disincarnating critical formulas | The UI suppresses the button for `endo`, `host-agent`, the user's own agent, and any other formula on a deny-list maintained by the host. |
| Pet-name removal cascades | Confirmation modal lists every name on the path before commit. |

Sections:

- [Affected Packages](endo-but-for-bots--llm-designs-drp--phases-and-decisions--affected-packages.md)
- [Phased Implementation](endo-but-for-bots--llm-designs-drp--phases-and-decisions--phased-implementation.md)
- [Design Decisions](endo-but-for-bots--llm-designs-drp--phases-and-decisions--design-decisions.md)
- [Known Gaps and TODOs](endo-but-for-bots--llm-designs-drp--phases-and-decisions--known-gaps-and-todos.md)

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
