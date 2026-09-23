---
ts: 2026-06-13T06:12:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--0ddf1e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/005610Z-result-designer-41ce63.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/152200Z-result-researcher-d73da3.md
---

# dispatch: researcher — build precedence for the merged #439 formula-inspector design

User directive (2026-06-13T~06:11Z): "Please dispatch a
subagent to build the design landed at
https://github.com/endojs/endo-but-for-bots/pull/439"

PR #439 merged 2026-06-13T05:51:32Z onto `llm` as commit
`aaff6ebaa95c0802d3a5fefed07780111f9cd9c2`. The design is
at `designs/formula-inspector.md` (post-merge). Precedence
dispatch ahead of the builder per researcher-precedence
rule.

## What the merged design specifies

(High-level; designer must consult the design directly for
specifics.)

1. **Host-only `EndoHost.getFormula(identifier)` method** —
   retrieve formula for any identifier (not locator).
   Absent on `GuestInterface`.
2. **Drop `@info` name hub** from the host's special-names
   map. Three `endo.test.js` regression tests rewritten.
   No deprecation alias. Retire `InspectorHubInterface`.
3. **CLI verb `endo inspect <name>`** — replaces the
   `@info` idiom.
4. **Chat UI**: single surface (modal back face). Gear icon
   on Value modal → flip to Formula view. Button/`F` on
   back face → flip to Value. Inventory-row gear opens
   modal already flipped. Back face read-only at this
   stage of development.
5. **Promise-formula view**: status-split. Pending →
   subscribe + "View next value" button. Fulfilled →
   reference button. Rejected → reason + on-demand
   `E(host).traces().lookup(errorId)`.
6. **No cycle unwinding** principle.
7. **Card-flip animation** simple; cue from
   `kriskowal/peruacru/animation.js` if complexity grows.

## Scope of the research

The downstream **builder** needs to know:
- The current host vs guest interface code surface
  (`packages/daemon/src/host.js`, `guest.js`, types).
- The `@info` wiring sites to remove (per prior researcher:
  2-line delta at `host.js:209` + tests).
- The CLI verb scaffolding to extend
  (`packages/cli/src/endo.js` + `packages/cli/src/commands/`).
- The chat package's modal infrastructure (Value modal
  shape, formula registry hook, gear icon plumbing).
- The error-tracing `EndoHost.traces()` facet (per PR #58
  which merged earlier — its post-merge state matters).
- Test infrastructure for daemon-level + CLI-level +
  chat-level tests.
- Existing `makePetStoreInspector` (per researcher d73da3,
  at `daemon.js:5704-5829`) which the new `getFormula`
  routes through.

In your `project/` worktree at endo-but-for-bots `llm`
(`68246ad92` or current tip — fetch latest):

1. **Read the merged design** at
   `designs/formula-inspector.md` in full.
2. **Read the prior researcher d73da3's result entry**
   (`journal/entries/2026/06/12/152200Z-result-researcher-d73da3.md`)
   for the pre-build references — they remain mostly valid.
3. **Refresh any pointers that may have changed** since
   d73da3 ran:
   - Has `llm` advanced since the design merged?
   - Has the error-tracing PR #58 merged? If so, its
     post-merge state at `EndoHost.traces()` is the
     integration surface.
   - Verify the `daemon.js:5704-5829` line for
     `makePetStoreInspector`.
4. **Map the chat-side UI surface**:
   `packages/chat/src/` — find the Value modal, the
   formula-view registry mentioned in the design, the
   gear icon infrastructure, and how `Shift+P` is wired
   in (Enter Profile mode-line hint).
5. **Map the test surfaces**:
   - daemon-level: `packages/daemon/test/endo.test.js`
     (per researcher; 3 tests need rewriting).
   - CLI-level: `packages/cli/test/` if it exists.
   - chat-level: `packages/chat/test/` if it exists.
6. **Identify an implementation order** suitable for the
   builder (e.g., (1) daemon `getFormula` + `@info`
   removal, (2) CLI `inspect` verb, (3) chat back-face
   refactor, (4) promise-view error-tracing integration,
   (5) cycle handling).

## Output shape

Produce a `result` entry under
`journal/entries/2026/06/13/` with the standard
`## Library and project references` section. Surface:

- Refresh of d73da3's pointers (what changed; what's
  stable).
- The chat-side infrastructure map (Value modal, formula
  registry, gear, Shift+P).
- Test surface map.
- Recommended commit ladder for the builder.
- Open questions surfaced (e.g., `@info` test rewriting
  shape; promise-view subscription mechanism; cycle
  handling at the daemon level).

## Out of scope

- Do NOT propose the implementation.
- Do NOT touch the tree or push.

## Authorizations

Read-only.

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` with
the `## Library and project references` section ready for
inlining into the builder dispatch.

End your turn with a concise summary back to the orchestrator. The
orchestrator inlines your section into the builder dispatch and
tears down your dispatch root on return.
