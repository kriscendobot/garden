---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §followBreaks async iterator (Design Decision 6)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

```js
const breaks = await E(debugger).followBreaks();
for await (const event of breaks) {
  // event: { path, line, reason, frames, locals }
  renderBreakpoint(event);
}
```

§Matches-the-Endo-followMessages/followNameChanges-pattern (cycle
135 daemon-locator-reference's subscription family). §UI-
subscribes-once; each break event arrives as a yield.

§Compare-to-cycle-161-filesystem-watchers' `followNameChanges`
extension on EndoMount (cycle 166). §All-of-Endo's-subscription-
APIs use the same §async-iterator-pattern.

§Cycle-171-stream/index.js's §symmetric-stream-interface is the
substrate; §followBreaks-returns-a-Reader<BreakEvent>.
