---
title: "designs/inventory-grouping-by-type.md — Group table + Options Considered with preferred + additive API change + five Considerations sections"
source-slug: endo-but-for-bots--llm-designs-inventory-grouping-by-type
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-grouping-by-type.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-grouping-by-type.md
total-lines: 125
ingest-cycle: 250
ingest-date: 2026-06-08
lane: designs
---

# Group table + Options Considered with preferred + additive API change + five Considerations sections + cycle 250 milestone

A §125-line **Not Started** design (Created 2026-02-14; Updated 2026-02-24). The §sibling-design-to-cycle-248's-inventory-drag-and-drop (same author + same week + same chat-UI-inventory cluster). §Cycle-250-marks-the-250th-librarian-cycle in this session — §a-milestone-cycle.

## §Group table — four-column dispatch table

```
| Group | Formula Types | Icon | Description |
|-------|--------------|------|-------------|
| Handles | handle | Person silhouette | Agent identities |
| Hubs | directory, host, guest, pet-store | Folder | Naming containers |
| Workers | worker | Gear | Execution sandboxes |
| Everything Else | All remaining types | Circle | Blobs, eval results, promises, lookups |
```

§Four-named-groups + §four-column-table with §Group × Formula Types × Icon × Description. §Group-table-IS-the-categorization-and-the-presentation-vocabulary-in-one-place.

§The-fourth-row-is-`Everything Else` — §the-catch-all-bucket-explicitly-named-with-an-icon-and-description; §when-categorization-might-miss-types, §explicitly-name-the-catch-all-bucket + §the-catch-all-IS-the-completeness-guarantee. §Sibling-pattern-to-cycle-236's-four-buckets (which classified caplet sources with explicit catch-all "Eval-inside-individual-worker" as the escape hatch) — §two-cycles-with-explicit-catch-all-bucket-as-completeness-guarantee.

§First-explicit-observation in library of §four-column-Group-table-with-Icon-and-Description as categorization-and-presentation-vocabulary.

## §Options Considered with preferred — distinct from Alternatives Considered

§Two-Options-Considered: **Option A: Extend `followNameChanges()`** (preferred) + **Option B: New `identifyType(petName)` method**.

§Options-Considered-with-preferred is distinct from §Alternatives-Considered-with-fates (cycle 238 had rejected+rejected+deferred; cycle 240 had rejected+rejected+rejected). §The-difference: §Alternatives-Considered all-but-one-rejected + §Options-Considered the-preferred-one-named-and-both-described-as-viable.

§When-two-implementation-strategies-are-both-viable-but-one-is-preferred, §use-Options-Considered-not-Alternatives-Considered + §name-the-preferred-explicitly + §describe-both-with-their-trade-offs. §First-explicit-observation in library of §Options-Considered-with-preferred as distinct-from-Alternatives-Considered.

§The-trade-off-for-Option-A: §avoids-N+1-lookups + §lets-the-UI-group-at-subscription-time + §additive-change-shape. §The-trade-off-for-Option-B: §simpler-to-implement + §requires-a-round-trip-per-item.

§Three-shapes-of-design-doc-alternatives-section in library now: §Alternatives-Considered-with-three-rejected (240) + §Alternatives-Considered-with-rejected+deferred (238) + §Options-Considered-with-preferred (250). §The-vocabulary-of-the-section-IS-the-status-of-the-options.

## §Additive API change as backward-compatible discipline

```js
// Current: { add: 'my-file' } or { remove: 'my-file' }
// Proposed: { add: 'my-file', type: 'readable-blob' }
```

§The-change-event-shape-is-additive — *old consumers that don't read `type` are unaffected*. §Additive-API-change-is-backward-compatible discipline + §the-old-shape-is-a-subset-of-the-new-shape + §no-existing-consumer-breaks.

§Compatibility-Considerations explicitly: *The `type` field is additive — old consumers that destructure only `add` or `remove` are unaffected*. §When-a-new-protocol-field-is-added-to-an-existing-event-shape, §destructure-discipline-IS-the-compatibility-mechanism + §consumers-that-destructure-only-the-fields-they-need-are-immune-to-additive-changes.

§First-explicit-observation in library of §additive-API-change-via-destructure-immune-consumers as named compatibility discipline.

§Sibling-pattern-to-cycle-242's-forward-compatible-shim (ReadableBlob → ExoStream non-breaking refactor) — §two-different-shapes-of-compatibility-discipline: §forward-compatible-shim (242) + §additive-API-change-via-destructure-immune-consumers (250). §Two-cycles-with-explicit-named-backward-compatibility-discipline.

## §Five Considerations sections — sibling to cycle 248

§Five-Considerations-sections (Security + Scaling + Test Plan + Compatibility + Upgrade) — §exactly-the-same-five-named-Considerations-sections-as-cycle-248 (inventory-drag-and-drop).

§Two-cycles-with-the-same-Five-Considerations-sections-shape (248 + 250) — §same-author + §same-week + §same-design-cluster + §same-shape. §When-an-author-establishes-a-design-doc-template, §the-template-recurs-across-related-designs + §the-shape-IS-the-author's-discipline.

§First-explicit-observation in library of §design-doc-template-recurs-across-related-designs as named author-discipline.

§Sibling-to-cycle-246's-Endo-Idiom-section (which had four-named-disciplines and was the second instance of that section type) — §three-cycles-with-recurring-section-templates (232 + 246 Endo-Idiom + 248 + 250 Five-Considerations).

## §Twenty-six formula types named as substrate count

§Implementation-Notes section: *Formula types are defined in `packages/daemon/src/formula-type.js` (26 types).*

§Twenty-six-named-formula-types-in-the-substrate-but-only-three-explicit-groups + §the-fourth-bucket-`Everything Else`-absorbs-the-other-twenty-three. §When-a-substrate-has-N-types-but-the-UI-only-explicitly-categorizes-K, §explicitly-state-the-count + §the-difference-IS-the-Everything-Else-bucket-size.

§The-count-`26`-IS-the-substrate-evidence-of-the-categorization-scope. §When-a-design-categorizes-a-finite-set, §name-the-set's-size-explicitly + §the-reader-can-verify-the-categorization-is-complete.

§First-explicit-observation in library of §substrate-count-named-as-evidence-of-categorization-scope.

## §`identify()` already returns formula identifiers but not type

§Implementation-Notes section: *The `identify()` method on the agent already returns formula identifiers. The formula type is embedded in the stored formula but not currently returned to the client.*

§The-existing-API-already-has-the-information-internally + §the-design-extends-the-API-to-expose-what-the-substrate-already-knows. §When-a-substrate-has-the-information-but-doesn't-expose-it, §the-design-IS-the-exposure-not-the-computation.

§Sibling-pattern-to-cycle-242's-`@endo/platform`-extracts-existing-daemon-types (which extracted existing types into a shared package); §two-different-shapes-of-expose-existing-substrate-information: §cycle-242 extracts-types-into-shared-package + §cycle-250 extends-API-to-return-existing-internal-field.

## §Stretch goal — Alleged Interface

§Future-Alleged-Interface: *In the fullness of time, also expose the alleged interface name (from `M.interface()` guard definitions) as additional metadata. This would let the UI show richer type information, e.g., "EndoHost" rather than just "host". This is a stretch goal that requires plumbing interface names through the formula metadata.*

§The-stretch-goal-IS-the-named-future-extension + §the-reason-IS-the-named-cost ("requires plumbing interface names through the formula metadata"). §When-a-design-defers-a-feature, §name-the-cost-as-the-reason-for-the-deferral + §the-cost-IS-the-named-non-blocking-fact.

§Two-cycles-with-`stretch goal`-as-named-deferral-vocabulary (248 + 250) — §same-author + §same-week. §The-`stretch goal`-vocabulary-IS-this-author's-deferral-vocabulary. §First-explicit-observation in library of §a-specific-author's-recurring-deferral-vocabulary as named-discipline-signature.

§Five-cycles-with-explicit-deferral-of-a-named-future-feature now (238 + 240 + 242 + 248 + 250). §The-vocabulary-varies-but-the-discipline-recurs.

## §Security exposing-X-doesn't-grant-new-capabilities argument

§Security-Considerations: *Formula type is already determinable by inspecting behavior; exposing it explicitly doesn't grant new capabilities.*

§The-named-security-argument: §an-information-leak-that-already-exists-via-behavior-inspection-isn't-a-new-information-leak. §When-a-design-exposes-information-explicitly, §argue-that-the-information-was-already-implicitly-available + §the-explicit-exposure-doesn't-grant-new-capabilities.

§First-explicit-observation in library of §exposing-X-doesn't-grant-new-capabilities as named security argument shape.

§Sibling-pattern-to-cycle-244's-no-ambient-scheduling-security-invariant — §two-cycles-with-explicit-named-security-argument: §cycle-244 by-construction-no-ambient-X + §cycle-250 X-already-implicitly-available.

§Restrict-interface-metadata-to-host-level-authority as named-recommendation for the stretch goal — §when-exposing-implementation-details-could-leak-to-guests, §restrict-the-exposure-to-host-level-authority-not-guest-level. §When-a-stretch-goal-has-named-security-implications, §name-the-recommended-restriction-in-the-Security-Considerations-section + §don't-defer-the-security-thinking.

## §No-migration-needed because existing data already has the field

§Upgrade-Considerations: *Existing stored formulas already have `type` fields. No migration needed.*

§The-substrate-already-has-the-field + §the-API-extension-just-exposes-it + §so-no-migration-is-needed. §When-a-design-extends-the-API-to-expose-an-existing-substrate-field, §no-migration-IS-the-named-Upgrade-Considerations-content.

§Sibling-pattern-to-cycle-236's-state-purge-as-acceptable-design-cost — §two-different-shapes-of-Upgrade-Considerations-content: §cycle-236 state-purge-as-acceptable-cost + §cycle-250 no-migration-needed. §Two-different-substrates-and-two-different-outcomes-of-the-Upgrade-Considerations-question.

## §Three-row Affected Packages — daemon + chat + cli

§Affected-Packages section names three packages:

- `packages/daemon` — extend `followNameChanges()` or add `identifyType()`
- `packages/chat` — grouped inventory rendering
- `packages/cli` — `endo list` could gain a `--grouped` or `--type` flag

§Three-rows-vs-cycle-248's-one-row — §the-blast-radius-IS-different. §Cycle-248-was-UI-only-no-daemon-API-changes (one row); §cycle-250-extends-the-daemon-API + §requires-three-package-changes.

§When-a-feature-extends-the-substrate-not-just-the-UI, §the-Affected-Packages-section-grows-from-one-row-to-three-rows + §the-blast-radius-grows-with-the-substrate-change. §The-Affected-Packages-section-IS-the-blast-radius-evidence.

§Two-cycles-with-Affected-Packages-section (248 single-package + 250 three-packages) — §the-same-author's-template-with-different-blast-radii. §First-explicit-observation in library of §Affected-Packages-section-as-blast-radius-evidence-with-varying-row-counts.

## §System-items-with-@-prefix-remain-with-existing-toggle — preserve existing behavior

§The-`@`-prefixed-special-names (`@self`, `@agent`) §remain-in-their-respective-type-groups + §with-the-existing-toggle-to-show/hide-them. §When-a-redesign-changes-the-presentation-of-some-items, §preserve-the-existing-behavior-for-other-items + §the-preservation-IS-the-named-non-change.

§First-explicit-observation in library of §preserve-existing-toggle-as-named-non-change as design discipline.

§Sibling-to-cycle-242's-`subDir()` deferred-to-future-VFS-layer (which preserved existing behavior by deferring extension) — §two-different-shapes-of-named-non-change: §cycle-242 deferral + §cycle-250 preservation.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Group-table — four-column dispatch table (Group × Formula Types × Icon × Description).
- §Catch-all-bucket-explicitly-named — "Everything Else" with icon and description.
- §Options-Considered-with-preferred — distinct from Alternatives-Considered; both options viable, one preferred.
- §Additive-API-change-via-destructure-immune-consumers as named compatibility discipline.
- §Substrate-count-named-as-evidence-of-categorization-scope (26 types in substrate, 4 explicit groups).
- §The-design-IS-the-exposure-not-the-computation — when substrate already has the information.
- §Exposing-X-doesn't-grant-new-capabilities as named security argument shape.
- §Restrict-interface-metadata-to-host-level-authority — stretch-goal security thinking not deferred.
- §No-migration-needed — when API extension exposes existing substrate field.

**Tier-2 (design-doc shape patterns):**

- §Five-Considerations-sections recurring template (cycles 248 + 250 by same author).
- §Design-doc-template-recurs-across-related-designs as named author-discipline.
- §Affected-Packages-section-as-blast-radius-evidence with varying row counts.
- §`stretch goal`-vocabulary as named author's recurring deferral vocabulary.
- §Three-shapes-of-design-doc-alternatives-section in library now (Alternatives-with-three-rejected + Alternatives-with-rejected+deferred + Options-with-preferred).

**Tier-3 (named comparisons):**

- §Preserve-existing-toggle-as-named-non-change (system items with @-prefix).
- §Two-cycles-with-Affected-Packages-section with different blast radii (1 row vs 3 rows).
- §Two-cycles-with-explicit-named-backward-compatibility-discipline (242 forward-compatible-shim + 250 additive-API-change).

## §Synthesis target — slot machine library

For a slot machine library:

- §Game-action-categorization-table — four-column dispatch table (Group × Action Types × Icon × Description).
- §Catch-all-bucket-explicitly-named for §game-action-categorization-completeness-guarantee.
- §Options-Considered-with-preferred when §game-feature-has-two-viable-implementation-strategies.
- §Additive-API-change-via-destructure-immune-consumers for §game-event-extension-without-breaking-old-consumers.
- §Substrate-count-named-as-evidence-of-categorization-scope for §game-rule-count-vs-game-rule-group-count.
- §The-design-IS-the-exposure-not-the-computation for §game-rule-engine-already-has-the-information-design-extends-API-to-expose-it.
- §Exposing-X-doesn't-grant-new-capabilities for §game-state-exposure-doesn't-grant-new-game-actions.
- §Restrict-interface-metadata-to-host-level-authority for §game-engine-implementation-details-restricted-to-admin.
- §No-migration-needed for §game-state-already-has-the-field-design-extends-API-to-expose-it.

## §Library meta-counters

- §Library-reaches-756-sections at cycle 250 (designs-lane inventory-grouping-by-type).
- §**Cycle-250-milestone-cycle** — §the-250th-librarian-cycle-in-this-session + §the-library-has-grown-from-746-to-756-sections-in-the-last-10-cycles (cycles 241-250).
- §Eighty-fourth-consecutive designs-chat alternation cycle (cycles 166-250).
- §Twelve-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248 + 250).
- §Two-cycles-with-the-same-Five-Considerations-sections-shape (248 + 250) — same author + same week + same design cluster + same shape.
- §Two-cycles-with-Affected-Packages-section (248 single-package + 250 three-packages).
- §Two-cycles-with-`stretch goal`-as-named-deferral-vocabulary (248 + 250) — same author + same week.
- §Five-cycles-with-explicit-deferral-of-a-named-future-feature now (238 + 240 + 242 + 248 + 250).
- §Three-shapes-of-design-doc-alternatives-section in library (Alternatives-with-three-rejected + Alternatives-with-rejected+deferred + Options-with-preferred).
- §Three-cycles-with-recurring-section-templates (Endo-Idiom 232+246 + Five-Considerations 248+250).
- §Two-cycles-with-explicit-catch-all-bucket-as-completeness-guarantee (236 + 250).
- §Two-different-shapes-of-Upgrade-Considerations-content (236 state-purge-as-cost + 250 no-migration-needed).
- §Two-cycles-with-explicit-named-backward-compatibility-discipline (242 forward-compatible-shim + 250 additive-API-change).
- §Two-cycles-with-explicit-named-security-argument (244 no-ambient-X + 250 X-already-implicitly-available).
- §First-explicit-observation of seven patterns: §Options-Considered-with-preferred-as-distinct-from-Alternatives-Considered + §four-column-Group-table-with-Icon-and-Description + §additive-API-change-via-destructure-immune-consumers + §substrate-count-named-as-evidence-of-categorization-scope + §exposing-X-doesn't-grant-new-capabilities as named security argument + §design-doc-template-recurs-across-related-designs as named author-discipline + §preserve-existing-toggle-as-named-non-change.

(Kris Kowal (prompted) authored)
