---
ts: 2026-06-12T05:27:52Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/439
refs:
  - entries/2026/06/12/051935Z-dispatch-designer-cc9a57.md
  - entries/2026/06/12/051354Z-dispatch-researcher-01b231.md
  - entries/2026/06/12/051636Z-result-researcher-01b231.md
---

# result: designer chat-value-modal-formula-view DRAFT PR #439

Opened [DRAFT PR #439](https://github.com/endojs/endo-but-for-bots/pull/439) on branch `design/chat-value-modal-formula-view` off `llm`, adding `designs/chat-value-modal-formula-view.md`. Project README updated: row in Summary table, row in M9 milestone table, row in Per-Design Estimates, node + edges in the Chat-UX dependency-graph subgraph, M9 item count 12 to 13, Total remaining 55 to 56.

## Resolution of formula-inspector.md overlap

**Cite as precedent; do not supersede.** The two designs split as complementary surfaces sharing the same per-type metadata catalog (already implemented by `makePetStoreInspector` at `packages/daemon/src/daemon.js` lines 5704-5829 and reachable via `InspectorHubInterface.lookup()`):

- This design carves out the in-modal flip moment (a card-flip back face on the existing Value modal, reachable from the four entry points listed in `chat-components.md`).
- `formula-inspector.md` keeps the dedicated inspector panel (opened from a wrench/gear icon on the inventory row), plus the edit toggle, the retention-path reveal, and the `endo inspect` CLI verb.
- When the panel from `formula-inspector.md` lands, both surfaces share the `formula-view-registry.js` defined here; the panel adds edit and retention-paths on top.

Rationale: the modal flip is a different UX moment from the inspector panel (everyday-inspection vs power-tool); collapsing them would lose the everyday moment.

## Navigation-model choice

**Stack** (Back returns to prior). The modal grows a back-button (`Backspace` keyboard, `←` glyph manual) that pops the most recent frame off a session stack. Closing the modal clears the stack. The landed state after clicking a reference button is indistinguishable from clicking that value's token chip via the four existing entry points; the stack semantics live inside the modal session.

Rationale: a user inspecting an `eval` and clicking its `worker` reference expects to come back to the eval. Without a stack, the user has no way to rewind except to re-find the entry point. The alternative (replace) is simpler but loses entry-point context; surfaced as an open question.

Cycle handling: A → B → A is `[A, B, A]` (no coalescing); Backspace pops one frame at a time. Surfaced as an open question (de-dupe vs leave-as-is).

## API-extension choice

**Reuse existing surfaces.** No new daemon method. Two existing surfaces compose:

1. `followNameChanges()` `type` field extension from `inventory-grouping-by-type.md` (additive shape; old consumers unaffected). The Chat client caches the type per pet name as it streams; no extra round-trip on flip.
2. `InspectorHub.lookup(petName)` for per-type properties, called lazily on first flip-to-back per modal session, with per-session caching.

Fallback: for values that did not arrive via `followNameChanges` (ephemeral, message-attachment), the client falls back to a single `InspectorHub.lookup` on first flip; the response carries both type and properties.

Rejected: a new `inspectFormula(formulaId)` method. Reason: the daemon already returns this shape; adding a new method when an existing surface suffices is the wrong direction per the project's API-minimalism norm.

## Required design contents present

1. Card-flip affordance: F key on both faces; 200 ms 3D rotateY default; `prefers-reduced-motion: reduce` falls back to 100 ms opacity cross-fade; `aria-live="polite"` announce; focus moves to back-face title on flip and to front-face value container on flip-back.
2. Layout taxonomy: explicit row for all 33 formula types currently in `packages/daemon/src/formula-type.js` (the researcher's brief referenced the historical 26-type set from `daemon-256-bit-identifiers.md`; this design surfaces and uses the live count, citing `daemon-mount.md`, `daemon-git-capability.md`, `daemon-make-archive.md`, `daemon-message-streaming.md` for the additions).
3. Literal-vs-reference classifier with a mermaid flowchart; reference-button label is the property name, never the target's pet name; lists-of-references handled.
4. Back-to-value navigation: stack model picked; replace surfaced as open question.
5. Daemon-and-Chat data flow named with a mermaid sequence diagram.
6. Cross-design coordination resolved explicitly.
7. Six open questions surfaced (the five from the researcher plus an Enter-Profile-keyboard-parity gap retire proposal).
8. Five Considerations sections: Security, Scaling, Test Plan, Compatibility, Upgrade.
9. Options Considered table with preferred + rejected for each axis.

## Open questions surfaced

1. Supersede vs specialize `formula-inspector.md` (this design picks specialize-and-cite).
2. Navigation stack vs replace (this design picks stack).
3. Card-flip animation precedent (novel affordance; first-instance decision).
4. Reference-to-promise status-aware rendering for `promise` / `resolver`.
5. Cycle handling in the back-stack (de-duplicate vs leave-as-is).
6. Enter-Profile keyboard parity gap (`Shift+P` proposed to retire the gap simultaneously, while modeline is already being touched).

## PR pipeline

Design PR; remains DRAFT per the project's split-PR norm. Implementation is a separate builder dispatch later, master-base, per `roles/designer/AGENT.md` § Operating norms ("design PRs land on `llm`; implementations of those designs are separate builder dispatches that land master-base PRs").

Self-improvement: nothing this time.
