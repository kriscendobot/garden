---
ts: 2026-06-13T06:18:02Z
kind: result
role: researcher
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/researcher--0ddf1e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: source-design
refs:
  - entries/2026/06/13/061200Z-dispatch-researcher-0ddf1e.md
  - entries/2026/06/12/152200Z-result-researcher-d73da3.md
  - https://github.com/endojs/endo-but-for-bots/pull/439
---

# result: researcher — build-precedence references for the merged #439 design (formula-inspector)

## Summary

Brief asked for library and project references the builder will inline when implementing the merged `designs/formula-inspector.md` (PR #439, merged at `aaff6ebaa` on 2026-06-13).
The merged design carries: a host-only `getFormula(identifier)` daemon method, removal of the `@info` special name from `host.js`, retirement of `InspectorHubInterface`, a CLI verb `endo inspect <name-or-identifier>`, and a Chat-side modal back face on the existing Value modal (gear icon on inventory rows and modal header; `F` key to flip; `Shift+P` retires the Enter-Profile keyboard parity gap; per-type layout registry over all 33 formula types).
The refinement reuses the prior researcher's references (d73da3, still valid: design dependencies, daemon code line citations, library-section pointers) and adds: the merged-design read of the current `formula-inspector.md`, the exact Chat-side files the builder touches, the CLI-command directory layout for adding the verb, the test-surface taxonomy (daemon AVA + CLI integration + chat-component happy-dom + e2e Playwright), and a recommended four-cut commit ladder organized so any cut can land independently and pass `yarn lint` and `yarn docs`.

## Library and project references

```markdown
## Library and project references

### The merged design (single source of truth)

- [`designs/formula-inspector.md`](../designs/formula-inspector.md) — the design merged at `aaff6ebaa` on 2026-06-13.
  Status: Not Started (build target).
  Sections to honor verbatim:
  - § Daemon surface: host-only `getFormula(identifier)` — the TypeScript signature and the `FormulaRecord` / `FormulaProperty` discriminated-union shape (literal / reference / reference-list).
  - § Removing the `@info` name hub — the test rewrite, no-deprecation-alias decision, and `InspectorHubInterface` retirement.
  - § CLI: `endo inspect` — flags (`--identifier`, `--json`), default human-readable output shape.
  - § Chat: Value modal back face — the four-row Modal Actions table, the `F`-from-both-faces rule, the gear icon on both inventory rows and the modal-header front-face affordance, `Shift+P` for Enter Profile.
  - § Layout registry — registry lives in `packages/chat/formula-view-registry.js`; renderer lives in `packages/chat/formula-view-component.js` (siblings of `value-component.js`).
  - § Formula-view layout taxonomy — the per-type table covers all 33 types from `packages/daemon/src/formula-type.js`.
  - § Literal-vs-reference resolution — the daemon returns identifier strings or plain JS or `{key→id}` records; the renderer classifies on the wire shape.
  - § Promise-formula view — pending → subscribe + "View next value", fulfilled → reference button, rejected → reason + on-demand "View trace" (host-only `traces` facet).
  - § Back-to-value navigation — stack model, Backspace pops one frame, click on reference is identical to token-chip click on the front face.
  - § Cycle handling — leave-as-is (principle of least surprise); modeline shows stack depth.
  - § Test Plan — the explicit list of test categories the builder must produce.

### Sibling project designs to read before coding

- [`designs/inventory-grouping-by-type.md`](../designs/inventory-grouping-by-type.md) — supplies the additive `type` field on `followNameChanges` change events that the Chat client caches per pet name.
  The modal back face uses the cached `type` to pick the right layout without an extra round-trip.
  Status: Not Started; the builder either depends on it landing first, or implements a single-`getFormula`-round-trip fallback when the type is not yet cached (the merged design explicitly carves out this fallback for ephemeral / message-attachment values).
- [`designs/daemon-retention-paths.md`](../designs/daemon-retention-paths.md) — the precedent for the host-only daemon-method shape.
  Cite when justifying that `getFormula` lives on `HostInterface` only (the design already cites this; the builder follows the same call-site shape).
  Status: In Progress, PR #284 against `llm`.
- [`docs/error-tracing-design.md`](../docs/error-tracing-design.md) — supplies the `EndoHost.traces()` facet that the rejected-promise "View trace" button calls.
  The trace fetch is on demand, not eager; the merged design's promise-rendering table cites this design's `TraceReport` shape (`errorId`, `workerId`, `name`, `message`, `stack`, `annotations`, `causes`, `related`).
- [`designs/daemon-message-streaming.md`](../designs/daemon-message-streaming.md) — supplies the substrate the pending-promise subscription rides on for the "View next value" affordance.
  The implementation reuses whatever streaming substrate that design ships rather than introducing a new subscription mechanism.
- [`designs/chat-command-bar.md`](../designs/chat-command-bar.md) § Value Modal / § Modal Actions — the existing modal-action vocabulary the builder extends with the fourth row (Flip).
  Status: Complete.
- [`designs/chat-invariants.md`](../designs/chat-invariants.md) § Modeline Completeness / § Escape Consistency / § Keyboard-Manual Parity — the design invariants the back face must honor (modeline hint on both faces, Escape on back face flips not closes, `F` works in both faces and the gear icon mirrors it manually).
  Status: Complete.
- [`designs/chat-components.md`](../designs/chat-components.md) § Inventory Panel / § Component Responsibilities — the structure the builder edits when adding the gear icon to inventory rows.
  Status: Complete; the listed file `inventory-component.js` is where the gear icon lands.
- [`designs/chat-playwright-smoke.md`](../designs/chat-playwright-smoke.md) — the Playwright harness the builder runs the modal back-face e2e tests under.
  Status: Complete (the harness exists; the builder adds new `.spec.ts` files alongside the existing three under `packages/chat/test/e2e/`).
- [`designs/daemon-256-bit-identifiers.md`](../designs/daemon-256-bit-identifiers.md) — supplies the `FormulaIdentifier` string shape (`{64-char number}:{64-char node}`) the design's `getFormula(identifier)` argument is in.
  Status: Complete.

### Project code locations to edit (with line anchors where stable)

#### Daemon

- `packages/daemon/src/interfaces.js`:
  - Lines 256-454: `HostInterface` definition.
    Add `getFormula(identifier)` between `getFormulaGraph` (line 453) and the closing brace.
    Use `M.call(IdShape).returns(M.promise())` as the guard shape; mirror the shape used by `lookupById` (line 272) since both take a single identifier and return a promise.
  - Lines 522-525: `InspectorHubInterface` — remove.
  - Lines 527-530: `InspectorInterface` — remove (the design retires the standalone inspector interface; `makePetStoreInspector` becomes the internal implementation of `getFormula` and no longer constructs an exo).
  - **Per the daemon CLAUDE.md § Keep exported facet `.d.ts` interfaces in sync:** the corresponding edit to `src/types.d.ts` lands in the same commit as the runtime interface change.
- `packages/daemon/src/host.js`:
  - Line 209: remove the `'@info': inspectorId,` entry from `specialNames`.
  - The `inspectorId` local is still computed (its provenance is from a `provideInspector(...)` call elsewhere in this function); the builder should trace whether `inspectorId` itself becomes unused after the special-names row is removed, and clean up the now-dead allocation chain if so.
  - Add `getFormula` as a Far facet method on `EndoHost`.
    The facet's `methods` object is constructed in the same function that builds `specialNames`; locate the `makeExo('EndoHost', HostInterface, { ... })` call and add a `getFormula` entry whose body delegates to the internal `getFormulaForId(parseId(identifier).number)`-style lookup the existing `lookupById` already uses.
- `packages/daemon/src/daemon.js`:
  - Lines 5704-5829: `makePetStoreInspector`.
    Convert from a constructor of an exo (`makeExo('EndoInspectorHub', InspectorHubInterface, { lookup, list })`) into a plain function the host facet calls when it needs per-type metadata.
    The lookup path that maps formula type → property record (lines 5745-5817) survives unchanged; the surrounding exo-construction shell is what disappears.
    The `list` method is dropped (the host's existing `list`, `listIdentifiers`, `listLocators` cover the enumeration use case per the design).
  - The lookup currently throws "PetStoreInspector.lookup(path) requires path length of 1" (line 5717) and "Unknown pet name" (line 5730).
    `getFormula(identifier)` takes a formula identifier directly, so neither check is reached on the new path; reuse only the per-type formula→properties branch.
    The pet-name resolution still happens, but on the CLI / Chat side (the CLI resolves a pet name to an identifier via `host.identify(name)` and then calls `getFormula`).
- `packages/daemon/src/formula-type.js` lines 6-40: the canonical sorted list of **33 formula types** (`channel`, `directory`, `endo`, `eval`, `git`, `git-credential`, `git-remote`, `guest`, `handle`, `host`, `invitation`, `known-peers-store`, `least-authority`, `lookup`, `loopback-network`, `mail-hub`, `mailbox-store`, `make-archive`, `make-from-tree`, `make-unconfined`, `marshal`, `message`, `mount`, `peer`, `pet-inspector`, `pet-store`, `promise`, `readable-blob`, `readable-tree`, `resolver`, `scratch-mount`, `timer`, `worker`).
  Note: the merged design says 33 formula types; the prior writeup said 26 and the source-of-truth has grown.
  **Note also that `make-bundle` (cited in the design's table and in `makePetStoreInspector`) is NOT in this canonical list as of `aaff6ebaa`.**
  The builder should treat `make-bundle` as a stale row in the design's taxonomy table and either elide it from the registry or surface the inconsistency in the build's `Notes` section.
- `packages/daemon/test/endo.test.js`:
  - Lines 2377-2510: three regression tests that exercise `E(AGENT).lookup(["@info", ...])`.
    Rewrite each to call `E(AGENT).getFormula(identifier)` after resolving the identifier via `identify`.
    The per-type expectations the tests assert (the formula type plus the per-property shape) carry over unchanged.

#### CLI

- `packages/cli/src/endo.js` (973 lines): the commander chain.
  Add a `.command('inspect <name-or-identifier>')` row alongside the existing 41 verbs (`run`, `make`, `inbox`, `request`, `resolve`, `reject`, `define`, `endow`, `form`, `submit`, `send`, `reply`, `send-value`, `adopt`, `dismiss`, `clear`, `list`, `remove`, `move`, `copy`, `show`, `locate`, `follow`, `cat`, `store`, `checkin`, `checkout`, `mount`, `mktmp`, `eval`, `spawn`, `archive`, `mkhost`, `mkguest`, `mkdir`, `invite`, `accept`, `cancel`, `where`, `state`, `log`, `ping`).
  None of `inspect`, `examine`, or `formula` collides.
  Add `--identifier` and `--json` flags.
- `packages/cli/src/commands/inspect.js` — new file, sibling to the 41 existing files under `packages/cli/src/commands/` (e.g., `show.js`, `locate.js`, `log.js`).
  Pattern: import `getEndoBootstrap` / equivalent, resolve a host facet, call `host.getFormula(identifier)`, render either as JSON (`--json`) or as the human-readable "type as header, then one row per property, references in dim style" shape.

#### Chat

- `packages/chat/value-component.js` (512 lines): the existing Value modal renderer.
  Edits:
  - Grow a flip control (gear icon in the modal header) and the back-face mount point.
  - Add an `F` key handler in `handleKey` (line 331), alongside the existing `Escape`-closes path.
  - Maintain a back-stack across reference-button clicks.
  - Re-route `Escape` on the back face to flip-to-front instead of closing (the modal closes only when the front face is showing).
  - Wire `Shift+P` to call `enterProfile(...)` when the front face is showing and the type is `profile` (the design proposes this as the parity-gap fix; the existing `#value-enter-profile` button already lives in the DOM at `chat.js` line 124).
- `packages/chat/inventory-component.js` (1267 lines): render a gear icon on each inventory row that calls the Chat client's "open Value modal already flipped to back face" path.
  The existing inventory rows already render contextual actions; add the gear button as one more.
- `packages/chat/chat.js`:
  - Lines 95-128: the `#value-frame` DOM in the chat shell HTML.
    Add the back-face mount point as a sibling div (or as a sibling of `#value-window`).
    Add the gear-icon button in the value-header (next to `#value-title` / `#value-type`).
  - Lines 442-457: the `controlsComponent` / `valueComponent` wiring.
    The `valueComponent` factory grows new options (`openOnBackFace`, the back-stack handler, the type cache feed) which the chat shell threads through; lines 1734-1750 are where `enterHost` is wired today and where the new options thread.
- `packages/chat/formula-view-component.js` — new file.
  Sibling of `value-component.js`.
  Exports `formulaViewComponent($parent, powers, { backStack })` returning `{ showFormula(identifier, type), blurFormula }`.
  Calls `E(powers).getFormula(identifier)` lazily on first show; caches the result per-modal-session.
- `packages/chat/formula-view-registry.js` — new file.
  Exports a `formulaViewRegistry` mapping formula type → `{ header, helpText, propertyList }`.
  Each `propertyList` entry declares `{ label, renderMode: 'literal' | 'reference' | 'reference-list', literalKind?: 'code' | 'string' | 'array' | 'hex' | ... }`.
  The per-type rows in the design's § Formula-view layout taxonomy table compile directly to this registry shape.
- `packages/chat/index.css`: add the card-flip CSS variables (`--card-flip-duration`, `--card-flip-easing`) and the `prefers-reduced-motion` override.
  Add classes for the gear icon, the back face, and the back-face property list (`<dl>`-style).

### Test surfaces

- **Daemon AVA unit tests** (`packages/daemon/test/`):
  - Existing: `endo.test.js` lines 2377-2510 (three `@info` tests) — rewrite to call `getFormula` directly.
  - New file or new test block: `getFormula(identifier)` returns the expected `FormulaRecord` for `eval`, `lookup`, `guest`, `make-archive`, `make-from-tree`, `make-unconfined`, `peer`, plus an `empty-state` formula type (e.g., `worker`, `pet-store`) to cover the empty-properties branch.
  - New authority test: a guest's facet does not expose `getFormula`; calling it through a guest-only ref fails with the standard "no such method" guard rejection.
    The existing test pattern for guest-vs-host authority asymmetry (search `packages/daemon/test/` for tests on `provideGuest` and `GuestInterface`-guarded surfaces; many tests build a `host`+`guest` pair and assert on host-only methods).
  - Cross-peer-locator rejection: `getFormula(<cross-peer-locator>)` is rejected with a clear error per the design's § Security Considerations.
  - Run with: `cd packages/daemon && npx ava test/endo.test.js --timeout=120s` per the root `CLAUDE.md` § Build and Test.
- **CLI integration test** (`packages/cli/test/`):
  - Existing CLI tests live under `packages/cli/test/`; add an `endo inspect` test that constructs an `eval` formula via `endo make`, then runs `endo inspect <name>` and asserts on the rendered output.
  - The `--json` flag emits the raw `FormulaRecord` for scripting.
- **Chat unit tests** (`packages/chat/test/unit/`):
  - Existing similar pattern: `command-registry.test.js`, `markdown-render.test.js`.
  - New file: `formula-view-registry.test.js` — each row in the taxonomy table renders the expected header/helpText/propertyList shape for a synthetic input.
- **Chat component tests** (`packages/chat/test/component/`, happy-dom-based):
  - Existing example: `packages/chat/test/component/inventory-component.test.js`.
  - New: `formula-view-component.test.js` — open the modal on an `eval` value, press `F`, assert the back face renders the `eval` layout; click the `worker` reference button, assert the modal lands on the front face for the worker; press `Backspace`, assert the modal returns to the `eval` (front face).
  - New: a single component test asserts the gear icon on inventory rows opens the modal already flipped (parity with "open + F").
- **Chat e2e tests** (`packages/chat/test/e2e/`, Playwright):
  - Existing examples: `channel-spaces.spec.ts`, `monaco-editor.spec.ts`, `token-autocomplete.spec.ts`.
  - New: `formula-view.spec.ts` — covers the screen-reader smoke (aria-live update), the reduced-motion fallback, and the cycle test (A → B → A with stack depth `2/3` indicator).
  - Per `designs/chat-playwright-smoke.md` § Build and Loading, the harness is already wired; the new spec file lands alongside the existing three.

### Recommended commit ladder (four cuts; design-doc-status invariant)

This implementation lands on `master` (per `journal/projects/endo-but-for-bots/README.md` § Rules of engagement, design lands on `llm` and implementations land on `master`; PR #439 already merged the design onto `llm`).
The merged design's Status is "Not Started" today; per the README's roadmap convention, the final cut updates the design's metadata to "In Progress" or "Implemented" (the builder picks one based on whether all four cuts ship together).

Each cut should pass `yarn lint` and `yarn docs` independently per `CLAUDE.md` § Pre-PR checklist:

1. **Cut 1 (daemon, drop-`@info` + add `getFormula`):**
   - `packages/daemon/src/interfaces.js`: add `getFormula` to `HostInterface`; remove `InspectorHubInterface` and `InspectorInterface`.
   - `packages/daemon/src/types.d.ts`: corresponding interface edit per the daemon CLAUDE.md § Keep exported facet `.d.ts` interfaces in sync.
   - `packages/daemon/src/host.js`: remove `@info` from `specialNames` (line 209); add `getFormula` as a Far method on `EndoHost`.
   - `packages/daemon/src/daemon.js` lines 5704-5829: gut `makePetStoreInspector`'s exo-construction shell, keeping only the per-type metadata function as the internal implementation of `getFormula`.
   - `packages/daemon/test/endo.test.js` lines 2377-2510: rewrite the three `@info` tests to call `getFormula(identifier)`.
   - Add new daemon AVA tests: `getFormula` per-type coverage; guest does not expose `getFormula`; cross-peer locator rejection.
   - Verify: `cd packages/daemon && yarn lint && npx ava test/endo.test.js --timeout=120s`.

2. **Cut 2 (CLI, `endo inspect`):**
   - `packages/cli/src/commands/inspect.js`: new file.
   - `packages/cli/src/endo.js`: add the `.command('inspect <name-or-identifier>')` row.
   - `packages/cli/test/`: new integration test for `endo inspect` with `--json` and human-readable modes.
   - Verify: `cd packages/cli && yarn lint && npx ava`.

3. **Cut 3 (chat, modal back face and gear icon):**
   - `packages/chat/formula-view-registry.js`: new file with the layout taxonomy per the design's § Formula-view layout taxonomy.
   - `packages/chat/formula-view-component.js`: new file with the back-face renderer.
   - `packages/chat/value-component.js`: grow the flip control, `F` key handler, back-stack, `Escape`-flip-to-front behavior, `Shift+P` Enter Profile binding.
   - `packages/chat/inventory-component.js`: render the gear icon on inventory rows.
   - `packages/chat/chat.js`: extend `#value-frame` DOM, thread the back-face mount point through `controlsComponent` / `valueComponent`.
   - `packages/chat/index.css`: card-flip variables and reduced-motion override.
   - `packages/chat/test/unit/formula-view-registry.test.js`, `packages/chat/test/component/formula-view-component.test.js`, `packages/chat/test/e2e/formula-view.spec.ts`: new test files.
   - Verify: `cd packages/chat && yarn lint && npx ava test/unit/ test/component/`.

4. **Cut 4 (design-doc status + README sync):**
   - `designs/formula-inspector.md` metadata table: bump `Updated` to the build date and flip `Status` to `In Progress` (or `Implemented` per the project's status discipline if all four cuts land together).
   - `designs/README.md`: sync the summary table row and any milestone-table entries per `designs/CLAUDE.md` § Progress Tracking ("Any modification to a design document — especially its metadata — must be synchronized with `designs/README.md`").
   - This cut lands on `llm` rather than `master`, paralleling the PR #439 design-PR shape and the project README's rule.
   - This may need its own PR (the merged design landed on `llm`; the metadata bump and Status flip is a follow-up design PR per project convention).

The cuts can be stacked or one PR; the ladder is for review-readability and for cherry-pickability if the daemon cut is independently useful.

### Library concepts and sections (journal)

- [`journal/library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md`](../../../library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md) — the canonical writeup of the prior `formula-inspector.md` shape (pre-consolidation), kept for reference; the new merged design supersedes the edit-toggle and dedicated-panel parts.
  The per-type metadata catalog and the formula-references-as-clickable-links discipline survive in the merged design.
- [`journal/library/sections/endo-but-for-bots--llm-designs-drp--daemon-surface-and-subscription.md`](../../../library/sections/endo-but-for-bots--llm-designs-drp--daemon-surface-and-subscription.md) — the host-only-daemon-method precedent paragraph the design cites.
  The builder need not re-read this for implementation guidance; the design has already absorbed the discipline.
- [`journal/library/concepts/formula-graph.md`](../../../library/concepts/formula-graph.md) — the on-disk substrate (`<statePath>/formulas/<head(2)>/<tail(62)>.json`) that `getFormula` reads through.
  Background for the *Implementation notes* section of any commit message that touches `daemon.js` formula-loading paths.
- [`journal/library/sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md`](../../../library/sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md) — the existing modal-action vocabulary the builder extends.

### Project README context (rules of engagement)

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md):
  - § Rules of engagement — designs land on `llm`; implementations land on `master`.
    Cuts 1, 2, 3 land on `master`; Cut 4 (the design-status bump) lands on `llm`.
  - § Standing authorizations — the maintainer's blanket "you are generally authorized to post freely on endo-but-for-bots" covers any reviewer-thread reply during the build's review loop.
  - § Authority structure — every commenter on this repo is effectively maintainer-equivalent; `CHANGES_REQUESTED` from any reviewer is treated as such.

### Open questions for the builder

- **`make-bundle` in the taxonomy table but not in `formula-type.js`.**
  The merged design lists `make-bundle` in § Formula-view layout taxonomy (and the prior `makePetStoreInspector` branched on `make-bundle`), but the canonical type list at `packages/daemon/src/formula-type.js` lines 6-40 omits `make-bundle`.
  The builder should either: (a) drop the `make-bundle` row from the registry and surface the discrepancy in a *Notes* section of the build's PR description, or (b) confirm via grep over `packages/daemon/src/` whether `make-bundle` is a legacy type that has been retired in favor of `make-archive` / `make-from-tree`.
  No library entry pre-resolves this; the type-list growth from 26 (prior researcher) to 33 (merged design) confirms the type catalog is in flux.
- **`Shift+P` Enter Profile parity gap fix.**
  The design proposes shipping `Shift+P` for Enter Profile in the same commit as the back-face flip (Open Question #2 in the merged design).
  The builder should treat this as part of Cut 3 (chat) since it lives in `value-component.js` next to the `F` flip handler; the chat-command-bar.md modeline must also gain a `Shift+P enter profile` row on the front face per § Modeline Completeness.
- **Card-flip animation register at the Chat level.**
  The merged design proposes a 200 ms 3D rotateY plus reduced-motion cross-fade for V1, with `peruacru/animation.js` as the cue if the animation grows complex.
  No animation register exists at the Chat level yet; the builder ships the inline CSS variables in Cut 3 and an open follow-up design can promote the variables into a Chat-wide register later.
- **Where exactly `inspectorId` allocation chain dies after `@info` removal.**
  The builder traces `provideInspector` (or whatever provider mints `inspectorId`) and confirms whether that allocation chain is now dead-code reachable only from the removed special name.
  If so, retire the provider too; if not (e.g., if `inspectorId` is still referenced by formula-graph code), leave it and document.
- **CLI verb test fixture pattern.**
  The CLI test layout requires understanding how the existing CLI tests spin up a daemon, mint a value, and assert on stdout.
  The builder should consult the closest existing pattern (likely a test for `endo show` or `endo locate`) and follow it for `endo inspect`.
```

## Library writeback

Verified the five keyword shortcuts the prior researcher added on 2026-06-12 (`` `@info` special name ``, `` `@info` name hub ``, `inspector special name host-only`, `host-only daemon method precedent`, `Host method absent on Guest`) are still in `journal/library/keywords.md` at lines 3917-3921; no new shortcuts needed for this engagement (the merged design's terms route through the same keyword cluster).
No concept-page edits, no section pruning, no missing concept drafts (the formula-inspector and DRP sections already cover the substantive material; the merged design's new artifacts like `getFormula(identifier)` are implementation surface the next builder dispatch will document via a `result` entry rather than a library section).

## Open questions

The four *Open questions for the builder* in the refinement (`make-bundle` row reconciliation, `Shift+P` modeline row, animation register, `inspectorId` allocation chain) are policy/implementation choices for the builder, not library gaps.
The library has full coverage for the merged design's substrate (`formula-inspector` section + DRP section + `formula-graph` concept + `value modal and states` section).

Self-improvement: nothing this time.
