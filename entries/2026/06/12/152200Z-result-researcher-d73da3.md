---
ts: 2026-06-12T15:22:12Z
kind: result
role: researcher
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/researcher--d73da3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: target
refs:
  - entries/2026/06/12/151500Z-dispatch-researcher-d73da3.md
  - https://github.com/endojs/endo-but-for-bots/pull/439
---

# result: researcher — references for #439 designer (consolidate formula view + drop `@info` hub)

## Summary

Brief asked for library and project references the #439 designer will inline when consolidating `designs/chat-value-modal-formula-view.md` into the existing `designs/formula-inspector.md` AND proposing removal of the `@info` name hub in favor of a Host-agent `getFormula(identifier)` method plus a new CLI/GUI verb (inspect / examine / formula).
The refinement points at the two designs to consolidate, the four `host.js` and `guest.js` call sites that wire `@info` into the special-name map, the `daemon-retention-paths.md` precedent for adding a host-only daemon method (with the explicit "why host-only" rationale that mirrors what kriskowal asked for on the inline comment), the `endo` CLI verb landscape (41 commands; no `inspect` / `examine` / `formula` verb today), and the `docs/error-tracing-design.md` `EndoHost.traces()` facet that gives the promise-formula view its subscribe-and-button surface for resolved values and rejection reasons.

## Library and project references

```markdown
## Library and project references

### Project designs to consolidate

- [`designs/chat-value-modal-formula-view.md`](../designs/chat-value-modal-formula-view.md) — the PR #439 design under review. Carves the in-modal back-face flip; cites `formula-inspector.md` as the prior art; § Formula-view layout taxonomy enumerates 33 formula types and per-type properties; § Daemon API reuses `InspectorHub.lookup` via `@info`-style addressing; § Back-to-value navigation picks *stack* (acknowledged by kriskowal on comment 3); § Open Questions #4 raises promise-status rendering, #5 raises cycle handling (the maintainer ruled on cycles in inline comment 6: "do not unwind cycles").
- [`designs/formula-inspector.md`](../designs/formula-inspector.md) — the existing design (2026-02-14, Not Started, 110 lines) that PR #439's review asks to consolidate into. Carries the separate-panel UX (wrench/gear icon on inventory row), the read-only-default with edit toggle, the `E(agent).revise(petName, patch)` API, the `endo inspect <name>` CLI verb, and the retention-path reveal. Lines 47-53 carry the `InspectorHubInterface` shape; lines 55-65 list the per-type metadata fields the inspector already returns.
- [`designs/inventory-grouping-by-type.md`](../designs/inventory-grouping-by-type.md) — sibling design that proposes extending `followNameChanges()` with a `type` field. The PR #439 design composes with it; if consolidation drops `@info` the consolidated design still depends on this `type` extension (additive to `followNameChanges`).
- [`designs/daemon-retention-paths.md`](../designs/daemon-retention-paths.md) — *the precedent shape* for the proposed `getFormula(identifier)` Host-agent method. § Daemon surface (host-only) at line 129 adds two methods to `EndoHost` (not `EndoGuest`) with the same authority rationale kriskowal voiced on the inline comment: a guest's call would "reveal the host's internal naming, peer relationships, and which other guests share common roots." The new design should mirror this shape: `listRetentionPaths(locator)` → `getFormula(identifier)`; "snapshot of paths from GC root" → "the formula record for the identifier". Status: In Progress, PR #284 open against `llm`.

### Project code locations the designer will cite

- `packages/daemon/src/host.js` lines 198-215 — the *host* `specialNames` map that wires `'@info': inspectorId` alongside `@agent`, `@self`, `@host`, `@main`, `@node`, `@endo`, `@nets`, `@pins`, `@none`, and (optionally) `@mail`. **This is the line that disappears** under the proposed redesign.
- `packages/daemon/src/guest.js` lines 88-96 — the *guest* `specialNames` map that *already* omits `@info`. Carries only `@agent`, `@self`, `@host`, optionally `@mail`, and `@nets`. The host-vs-guest method delta is already captured by the special-name asymmetry; the redesign formalizes this into a method-level Host vs Guest split via `getFormula`.
- `packages/daemon/src/daemon.js` lines 5704-5829 — `makePetStoreInspector` (the function the existing formula-view design cites; *5704-5829 in this tree, not the historical 3210-3319 that `formula-inspector.md` and the library section cite*). Returns an `EndoInspectorHub` that exposes `lookup(petName)` returning per-type metadata. The redesign can either retain `makePetStoreInspector` as the *internal* implementation of `getFormula`, or unify them into one entry point. The per-type catalog (eval / lookup / guest / make-bundle / make-unconfined / make-archive / make-from-tree / peer) is the substrate both consolidated designs already share.
- `packages/daemon/src/interfaces.js` lines 156-254 — `GuestInterface` definition; lines 256-454 — `HostInterface` definition. The natural slot for `getFormula(identifier)` is the Host interface (mirrors `listRetentionPaths`, `getFormulaGraph`, `provideGuest`, `provideHost`, etc.). Add it between `getFormulaGraph` and the closing brace; do not add it to `GuestInterface`. Lines 522-525 — `InspectorHubInterface` (`lookup`, `list`) is the existing facet whose `lookup(petName)` shape becomes the body of the new `getFormula(identifier)`; whether to retire the standalone interface or keep it for backward compatibility is an explicit choice the designer should call out.
- `packages/daemon/src/formula-type.js` lines 6-37 — the canonical sorted list of 36 formula types. The PR #439 design's § Formula-view layout taxonomy table covers all of them; the consolidated design should keep that table intact.
- `packages/daemon/test/endo.test.js` lines 2377-2510 — three regression tests that exercise the `@info` lookup path (`E(AGENT).lookup(["@info", "ten", "source"])`). The "drop `@info`" proposal must either (a) retire these tests in favor of `getFormula` tests, or (b) keep `@info` as a compatibility-redirect onto `getFormula` for one release. The consolidated design should pick one and say which.
- `packages/cli/src/endo.js` (CLI verb landscape) — 41 commands today: `run`, `make`, `inbox`, `request`, `resolve`, `reject`, `define`, `endow`, `form`, `submit`, `send`, `reply`, `send-value`, `adopt`, `dismiss`, `clear`, `list`, `remove`, `move`, `copy`, `show`, `locate`, `follow`, `cat`, `store`, `checkin`, `checkout`, `mount`, `mktmp`, `eval`, `spawn`, `archive`, `mkhost`, `mkguest`, `mkdir`, `invite`, `accept`, `cancel`, `where`, `state`, `log`, `ping`. **None of `inspect`, `examine`, or `formula` is taken.** The proposed verb can pick freely; `formula-inspector.md` already nominates `endo inspect <name>`. The redesign's "new CLI/GUI verb like `inspect` or `examine` or `formula`" wording is reconcilable: pick `endo formula <name>` (parallel to `endo locate <name>`, parallel to the *formula view* idiom) or `endo inspect <name>` (parallel to the existing inspector design and the *Pop the bonnet* metaphor).

### Promise-formula view and error-tracing integration (review comment 5)

- `docs/error-tracing-design.md` (503 lines, design proposed) § EndoHost `traces` facet at line 314 — adds `E(host).traces()` returning a `TracesInterface` with `lookup(errorId)` → `TraceReport | undefined` and `recent({workerId, limit})`. `TraceReport` carries `errorId`, `workerId`, `name`, `message`, `stack`, `annotations`, `causes: TraceReport[]`, `related: TraceReport[]`. This is the integration surface the review comment 5 names: a promise-formula view that subscribes (via the formula's `store` reference) and shows a "view the next value" button on resolve, or the rejection reason annotated with the matching `TraceReport` on reject. The trace is reached *via the rejection's `errorId`*: when the promise formula's status is rejected, the view fetches `E(host).traces().lookup(errorId)` and renders the resulting `related` + `causes` chain.
- The PR #439 design § Formula-view layout taxonomy already lists `promise` as `{ store reference, status (pending / fulfilled / rejected; see open question) }` and `resolver` as `{ store reference }`. The consolidated design needs to extend this:
  - On *pending*: a "view next value" button that subscribes to the promise (the `store` reference is where the eventual value lands) and re-renders on resolution.
  - On *fulfilled*: a reference button to the resolved value's formula (which the back face can flip into); semantics already match the existing reference-button discipline.
  - On *rejected*: render the rejection reason as a literal *and* link to the `TraceReport` via the rejection's `errorId`. Per `docs/error-tracing-design.md`, the trace is fetched on demand, not eagerly — the same shape the formula view's per-modal-session cache already uses for `lookup`.
- The error-tracing design's host-only `traces` facet is *another* precedent for "Host method, not Guest" alongside `daemon-retention-paths.md`. Both are cited as evidence that the proposed `getFormula(identifier)` belongs on `EndoHost`, not `EndoGuest`.

### Cycle handling (review comment 6)

- The PR #439 design § Back-to-value navigation lines 162-167 — accepts cycles by leaving the stack untouched (`A → B → A` is `[A, B, A]`). Open Question #5 raises de-duplication as a possible alternative. **kriskowal ruled on this on inline comment 6**: "Principle of least surprise: do not unwind cycles. The user has a mental model of how many layers they have gone down that we should not meddle with." The consolidated design should resolve Open Question #5 in favor of *do not unwind*, citing this principle by name, and remove the alternative from § Open Questions.
- No other design in `designs/` proposes a cycle-unwinding policy for formula-view navigation. The principle as stated is novel to the formula-view consolidation; phrasing it as "principle of least surprise: do not unwind cycles" gives the consolidated design a quotable rule for the table of design decisions.

### Library concepts and sections (journal)

- [`journal/library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md`](../../../library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md) — the canonical writeup of the existing formula-inspector design, including § `26 formula types with type-specific metadata`, § `formula-references-as-clickable-links discipline`, § `edit-toggle-with-revise-API discipline`, § `retention-path-reveal facility`, § `CLI-mirror command` (the `endo inspect <name>` precedent), § `security-gated-edit discipline`, § `three-affected-packages partition`. The note at the bottom that "the formula inspector surfaces the *object structure* that backs each pet-named capability" maps directly to the proposed `getFormula(identifier)` semantics.
- [`journal/library/sections/endo-but-for-bots--llm-designs-drp--daemon-surface-and-subscription.md`](../../../library/sections/endo-but-for-bots--llm-designs-drp--daemon-surface-and-subscription.md) — the canonical writeup of the host-only daemon-method pattern. *Why host-only*: "guests must not be able to enumerate paths through capabilities they do not own; a guest's `listRetentionPaths(myLocator)` would reveal the host's internal naming, peer relationships, and which other guests share common roots." This is the precedent paragraph the consolidated design should cite verbatim (substituting "enumerate paths" → "retrieve formula records") when justifying that `getFormula(identifier)` belongs on the Host and not the Guest.
- [`journal/library/concepts/formula-graph.md`](../../../library/concepts/formula-graph.md) — the durable substrate the formula view walks; § Storage substrate — two distinct layers names where formulas live on disk (JSON files at `<statePath>/formulas/<head(2)>/<tail(62)>.json`). Relevant background if the consolidated design's *Implementation notes* section calls out which on-disk substrate `getFormula` reads.
- [`journal/library/sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md`](../../../library/sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md) — the *Value modal* states table the PR #439 design extends with the back-face flip. Relevant to consolidation because both the in-modal flip *and* the wrench-icon panel discussed in `formula-inspector.md` start from the same modal/inventory-row anchor.

### Project README context (rules of engagement)

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § Rules of engagement — design PRs land on `llm`; design + implementation are separate PRs by convention. The consolidated design will land as a draft PR against `llm` (replacing or alongside PR #439); the new `endo formula` / `endo inspect` CLI verb implementation is a separate later PR against `master`.
- § Standing authorizations — the maintainer's blanket "you are generally authorized to post freely on endo-but-for-bots" covers the designer's per-action authorization to open the consolidated design PR and reply on the PR #439 inline threads.

### Open questions for the designer (terms in the brief not fully resolved in the library)

- *Naming of the new verb.* The brief offers three candidates (`inspect`, `examine`, `formula`); `formula-inspector.md` already proposes `endo inspect <name>`. The consolidated design should make the verb choice canonical, citing the parallel `endo locate <name>` shape (single-word noun-style verb), and reconcile against the prior `endo inspect` plan. No library entry pre-resolves this.
- *Compatibility window for `@info`.* No prior design proposes a deprecation discipline for special-name hub removal. The consolidated design's *Compatibility Considerations* section is the first writeup of "drop a `@`-prefix system pet name"; the prior addition of `@info`, `@node`, etc. is precedent for adding one, not removing one. The designer can either propose a single-release drop or a deprecation alias (`@info` redirects onto `getFormula` for one release); no library entry constrains the choice.
- *Whether to retire `InspectorHubInterface`.* The standalone `InspectorHubInterface` (`lookup`, `list`) at `packages/daemon/src/interfaces.js:522-525` becomes redundant if `getFormula` replaces it. The consolidated design should explicitly decide retire-or-keep; no library entry pre-resolves this.
```

## Library writeback

Added five keyword shortcuts under the `formula inspector pop the bonnet` cluster in `library/keywords.md`:

- `` `@info` special name `` → points at `library/sections/.../formula-inspector--pop-the-bonnet...md`.
- `` `@info` name hub `` → same target (the maintainer used "@info name hub" phrasing in the inline comment).
- `inspector special name host-only` → same target (captures the host-vs-guest split).
- `host-only daemon method precedent` → points at `library/sections/.../drp--daemon-surface-and-subscription.md`.
- `Host method absent on Guest` → same DRP target.

The next researcher dispatched on a `getFormula`-style or `@info`-touching subject will find these in one grep. No concept-page edits, no section pruning, no missing concept drafts (the existing formula-inspector and DRP sections already cover the substantive material).

## Open questions

None of the brief's terms turned up missing from the library or the project tree; every reference cited in the refinement is verified against the dispatch root's `journal/` HEAD and `project/` HEAD. The three *Open questions for the designer* listed in the refinement above (verb naming, `@info` compatibility window, `InspectorHubInterface` retirement) are policy choices for the designer, not library gaps.

Self-improvement: nothing this time.
