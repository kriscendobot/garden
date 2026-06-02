---
ts: 2026-06-02T23:50:16Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--10f81a
short_id: 10f81a
refs:
  - designs/inventory-grouping-by-type.md
---

# dispatch: builder — implement inventory-grouping-by-type design

Implement `designs/inventory-grouping-by-type.md` (Status: Not
Started; created 2026-02-14, updated 2026-02-24). The design is
builder-ready with:

- Clear API choice (Option A: extend `followNameChanges()` with
  type metadata — preferred over Option B per the design).
- Affected packages named: `packages/daemon`,
  `packages/chat`, `packages/cli`.
- File paths cited: `packages/daemon/src/formula-type.js`
  (26 types); `packages/chat/inventory-component.js`;
  `packages/chat/src/chat.js`.
- Backward-compatibility: additive change to the
  `followNameChanges()` event shape; old consumers unaffected.
- Test plan named.

Base: `endojs/endo-but-for-bots:llm` (the Chat package only
exists on `llm`, not `master`; this implementation is
llm-base unlike master-base impls).

Open DRAFT PR per the standard builder discipline.
