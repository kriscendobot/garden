---
title: "daemon-make-archive — §source-only-archive-replaces-precompiled-bundle + §Phases-1-5-complete-then-6-7-8-added-with-status-back-to-In-Progress + §three-axis-table-Method-by-Source-by-Confinement + §@node-required-host-only-special-name + §makeFromTree-and-makeUnconfinedFromTree + §composable-stageTree-plus-convenience-wrapper + §naming-by-source-shape-not-by-product + §nine-Design-Decisions + §fourth-Prompt-section-instance-with-Follow-on-prompt"
source-slug: endo-but-for-bots--llm-designs-daemon-make-archive
section-id: source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-make-archive.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-make-archive.md
total-lines: 813
status: In Progress (2026-04-23 → 2026-04-24; Phases 1-5 complete; Phases 6-7-8 added)
ingest-cycle: 236
ingest-date: 2026-06-08
lane: designs
---

# daemon-make-archive — Source-only archives replace precompiled bundles; phases grew beyond original scope

An 813-line **In Progress** design (created 2026-04-23; updated 2026-04-24). §The-original-scope-was-Phases-1-5-replacing-makeBundle-with-makeArchive. §After-completion-Phases-6-7-8-were-added (§the-Status-flipped-back-to-In-Progress) for §@node-host-only-special-name + §makeFromTree + §makeUnconfinedFromTree. §The-design-document-grew-with-the-implementation.

## §Twenty-eighth-honest-design-evolution-record family member with a new shape: §Phases-grew-beyond-original-scope-and-Status-flipped-back-to-In-Progress

The opening status quote captures the §design-evolution-event:

> **Phases 1–5 are complete.** The design has since grown Phase 6 (the `@node` special name, described below), Phase 7 (`makeFromTree` from a readable tree), and Phase 8 (`makeUnconfinedFromTree` via a scratch-staging bridge). Status is now **In Progress** again. The 2026-04-24 revision: [...]

§Borrowable-pattern: §when-a-design-completes-its-original-scope-and-then-grows-new-phases, §the-Status-section-explicitly-tracks-the-status-flip-back-to-In-Progress + §the-Status-narrative-names-the-new-phases-with-one-line-summaries. §Different-from cycle 230 endor-npm-registry-proxy's §phases-by-number-with-implementation-files (cycle 230 was always In Progress; cycle 236 flipped back).

§Twelve-different-shapes-of-design-evolution-record in 2026-06 cluster now:

| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |
| 224 | §Status-Complete-with-explicit-Design-deviations-None-significant |
| 226 | §six-Parent-pointer-children-sharing-a-template |
| 227 | §uniform-PassStyleHelper-shape-across-pass-style-kind-files |
| 228 | §Status-Superseded-by-named-successor + §Roadmap-calibration-via-git-blame |
| 230 | §phases-by-number-with-implementation-files-and-remaining-one-line-purposes |
| 232 | §later-member-of-an-established-cluster-template |
| 236 | §Phases-grew-beyond-original-scope-and-Status-flipped-back-to-In-Progress |

§Twelve-different-shapes for naming-the-design-implementation-relationship.

## §The-load-bearing-substitution: source-only-archive replaces precompiled-bundle

§Three-named-problems with the old `makeBundle` format:

1. §Bundles-are-JSON-wrapped-binary that has to be decoded and re-parsed before execution.
2. §Precompiled-module-formats-carry-Babel-compiled-functor-source — §significantly-larger + §cannot-be-re-shared-with-workers-that-lack-the-precompile-parsers.
3. §Rust-workers-cannot-read-a-base-64-JSON-wrapper-out-of-band + §cannot-reuse-the-CAS for module sources.

§The-replacement `makeArchive`:

1. §Takes-a-readable-blob-reference-to-a-ZIP-file containing `compartment-map.json` + modules in §source-formats (no precompiled).
2. §Lets-Node.js-workers-compile-each-module-at-runtime via `@endo/module-source`.
3. §Lets-Rust-workers-read-the-content-directly-from-the-CAS + §run-in-process.
4. §Removes-`makeBundle`-entirely — §replaces-every-`-b`/`--bundle`-CLI-option-with-`-z`/`--archive`.

§Borrowable-pattern: §when-a-format-has-three-named-problems-that-the-replacement-eliminates, §enumerate-them + §enumerate-the-replacement's-four-named-properties + §the-substitution-is-defined-by-the-three-eliminations + §the-four-additions. §Sibling to cycle 230 endor-npm-registry-proxy's §enumerate-the-existing-substrate's-prerequisites-and-eliminate-each-one. §Two-cycles-with-this-shape now.

## §The-three-axis-table (Method × Source × Confinement)

§The-novel-architectural-table introduced in the 2026-04-24 revision:

| Method | Source | Confinement |
|---|---|---|
| `makeArchive` | ZIP blob pet name | Compartmentalised (any worker) |
| `makeFromTree` | Readable tree or mount pet name | Compartmentalised (any worker) |
| `makeUnconfined` | Filesystem path string | Unconfined (Node only) |
| `makeUnconfinedFromTree` | Readable tree or mount pet name → scratch | Unconfined (Node only) |

§Four-shapes-of-make-distinguished-by-source-and-confinement. §The-table-IS-the-design-language. §Two-axes-(source × confinement) generate §a-2x2-naming-scheme with §source-as-the-naming-suffix (Archive / FromTree / Unconfined / UnconfinedFromTree).

§Borrowable-pattern: §when-a-design-has-multiple-related-methods, §name-them-by-the-axes-that-distinguish-them + §a-two-by-two-table-IS-the-naming-rationale. §Cycle 236 explicitly says §every-`make*`-already-returns-a-caplet-so-the-naming-axis-IS-the-distinguishing-axis-not-the-product-name.

§Sibling to cycle 222 endoclaw-skill-registry's §three-recursive-EndoDirectory-levels-with-uniform-shape + cycle 226 endoclaw-cluster's §two-facet-control-pair canonical-shape — but cycle 236 is §a-2x2-method-naming-table not §a-uniform-pattern-applied-recursively.

## §`@node` as §required-host-only-special-name

§The-Phase-6-architectural-move:

> Guests do **not** see `@node`; it is a host-only capability.

§Three-properties of `@node`:
1. §Required-not-optional — every `HostFormula` carries a mandatory `nodeWorker` field.
2. §Host-only-not-guest-visible — guests inherit a filtered view that omits `@node`.
3. §XS-workers-explicitly-reject-makeUnconfined — directing callers to `@node`.

§Borrowable-pattern: §when-a-capability-is-only-meaningful-on-one-substrate, §expose-it-as-a-required-special-name-on-the-host + §filter-it-out-of-guest-views + §make-the-rejecting-substrate-name-the-redirect-target-in-its-error-message. §Three-layer-discipline:
- §Architecture: required-on-host.
- §Visibility: hidden-from-guests.
- §Error-message: names-the-redirect-target.

§The-redirect-is-always-available — §it-is-not-a-best-effort-lookup. §Borrowable-pattern: §when-an-error-points-at-an-alternative, §the-alternative-must-be-guaranteed-to-exist.

§Sibling to cycle 234 endoclaw-oauth's §the-agent-never-sees-the-token — both designs §filter-the-capability-out-of-the-guest's-view. §Cycle-234-hides-the-credential-from-the-agent-using-the-capability; §cycle-236-hides-the-capability-from-the-guest-not-allowed-to-use-it.

§All-users-purge-state-for-this-change + §no-migration-path. §Borrowable-pattern: §when-the-cleaner-design-requires-state-purge, §accept-the-one-time-cost + §don't-build-an-optional-field-crutch. §Sibling to cycle 234's §when-removing-legacy-is-cleaner-than-maintaining-shim. §The-pattern: §state-purge-as-acceptable-design-cost.

## §Naming-by-source-shape-not-by-product

> Every `make*` method already returns a caplet, so the legacy placeholder `makeCaplet` was weak — it failed to distinguish the tree-backed path from `makeArchive` and `makeUnconfined`. The distinguishing axis is the *source shape*, so the name names the source: `makeFromTree`.

§Borrowable-pattern: §when-all-methods-in-a-family-produce-the-same-product, §name-them-by-the-distinguishing-axis-not-by-the-product. §The-legacy-name `makeCaplet` was abandoned because §it-failed-to-distinguish-among-siblings.

§Sibling to cycle 229 marshal-justin's §Justin-as-a-JavaScript-subset (named by syntactic subset, not by output product). §Two-cycles-on-naming-by-distinguishing-axis-not-by-product.

## §Composable-alternative: §stageTree-as-public-primitive + §makeUnconfinedFromTree-as-convenience-wrapper

```ts
stageTree(treeName: string): Promise<EndoScratchMount>;
```

> `stageTree` materialises a tree into a fresh scratch mount and returns the mount (a normal daemon capability). Callers can then invoke `makeUnconfined(worker, mount.path, …)` themselves. `makeUnconfinedFromTree` is semantically `stageTree` followed by `makeUnconfined`, wired with the right lifetime linkage.

§Borrowable-pattern: §expose-the-primitive-as-a-public-method + §provide-the-convenience-wrapper-as-a-method-that-composes-the-primitive. §Two-shapes-for-the-same-operation: §explicit-two-step + §single-convenience-method. §Sibling to cycle 222 endoclaw-skill-registry's §two-shapes-for-the-same-operation (explicit-five-step-flow + single-convenience-command).

§Three-cycles-with-explicit-flow-and-convenience-wrapper:
- Cycle 222: explicit CLI five-step + `endo hub install` convenience.
- Cycle 226 cluster: explicit Endo operations + composability pattern.
- Cycle 236: `stageTree` + `makeUnconfined` explicit + `makeUnconfinedFromTree` convenience.

## §thisDiesIfThatDies — §lifetime-linkage discipline

> The scratch directory is a `thisDiesIfThatDies` dependency of the caplet. When the caplet is cancelled or collected, the scratch directory is removed — no orphan trees accumulating in the state tree.

§Named-lifetime-linkage-mechanism `thisDiesIfThatDies`. §Borrowable-pattern: §when-a-resource-must-live-and-die-with-another-resource, §name-the-linkage-mechanism + §the-name-IS-the-API-contract. §`thisDiesIfThatDies` is §the-explicit-name-for-the-dependency-relationship.

§Sibling to cycle 217 @endo/errors' §`__HIDE_`-prefix-protocol — both designs §lightweight-cross-mechanism-coordination-via-named-convention. §Cycle 217 uses a name-prefix; cycle 236 uses a named-method.

## §Source-only-contract-preserved-via-parser-map-omits-precompiled-parsers

> On the Node side the `parserForLanguage` map we hand to `parseArchive` simply omits the precompiled parsers, so attempting to import a precompiled module surfaces a clean "unknown language" error from compartment-mapper. On the Rust side, [...] no precompiled-parser code lives in the Rust worker at all.

§Borrowable-pattern: §enforce-a-source-only-contract-by-omitting-the-precompiled-parsers-from-the-parser-map + §the-error-emerges-from-the-existing-machinery-not-a-new-check. §The-absence-of-code-IS-the-enforcement.

§Sibling to cycle 231 @endo/marshal/encodeToCapData's §dont-encode-defaults-that-throw (strict-by-default with opt-in extension). §Cycle-236-is-strict-by-omission-of-the-parser; §cycle-231-is-strict-by-default-that-throws.

§Four-cycles-on-strict-by-default-with-opt-in-extension now (cycles 226 + 230 + 231 + 236).

## §The-legacy-Node.js-bridge stays open indefinitely

> The stated long-term goal: grow the ecosystem (native capabilities, network capabilities, platform packages) so that buckets 2 and 3 shrink. It is not our goal to remove `@node`; it is our goal to make it rarely necessary.

§Borrowable-pattern: §the-legacy-bridge-stays-open-indefinitely + §the-goal-is-to-make-it-rarely-necessary-by-growing-the-alternative-ecosystem. §Different-from §deprecation-and-removal — §the-design-doesn't-promise-removal + §the-design-aims-at-disuse-not-deletion.

§Sibling to cycle 217 @endo/errors' §pre-1.13.0-SES-Agoric-bootstrap-vat-tolerance — both designs §keep-a-legacy-path-open + §explicitly-state-why. §Different-from cycle 228 daemon-os-sandbox-plugin's §Superseded-by-endo-posix-sandbox (cycle 228 declares the legacy obsolete; cycle 236 keeps the legacy active).

§Three-different-fates-for-legacy-paths-in-library:
- Cycle 217 (errors): legacy tolerated for named bootstrap vat (will phase out).
- Cycle 228 (sandbox-plugin): superseded with named replacement.
- Cycle 236 (make-archive): kept active indefinitely, goal is disuse.

## §Nine-Design-Decisions

The design has §a-numbered-Design-Decisions-section with §nine-named-decisions each with §a-paragraph-of-rationale. §Borrowable-pattern: §when-the-design-has-many-trade-off-decisions, §collect-them-in-a-Design-Decisions-section-with-numbered-bullets + §each-bullet-has-its-own-rationale-paragraph.

§Sibling to cycle 230 endor-npm-registry-proxy's §Five-Design-decisions-with-named-rationale-per-decision. §Two-cycles-with-numbered-Design-Decisions; §cycle-230-has-five + §cycle-236-has-nine — §the-bigger-design-has-more-decisions-explicitly-numbered.

The decisions span:
1. §Same-readable-blob-storage (reuse not introduce).
2. §Compartment-mapper's-parseArchive-on-Node (reuse canonical loader).
3. §Source-only-contract-on-both-workers.
4. §Remove-rather-than-deprecate (user authorized purge).
5. §XS-workers-do-not-implement-makeUnconfined (explicit-not-papered-over).
6. §`@node`-is-a-host-only-special-name.
7. §`makeFromTree`-unifies-the-archive-and-tree-paths.
8. §The-legacy-Node.js-bridge-stays-open-indefinitely.
9. §`@node`-is-a-required-host-dependency-not-optional.

## §Dependencies-table-with-Relationship-column

Three named dependencies (daemon-cas-management + daemon-capability-bus + daemon-mount) with §Relationship-column (Reuses + Unchanged + Consumes/Snapshots).

§Sibling to cycle 224 daemon-web-gateway's §Dependencies-table-with-Relationship-column. §Three-cycles-with-Dependencies-table-with-Relationship-column now (cycles 224 + 230 + 236).

## §Known-Gaps-and-TODOs section

§Six-named-checkbox-items in the Known Gaps section + §three-future-considerations. §Borrowable-pattern: §collect-the-uncompleted-work-in-a-Known-Gaps-and-TODOs-section-with-checkboxes + §named-rationale-per-gap.

§Sibling to cycle 230's §Five-Known-gaps-section-with-checkboxes. §Two-cycles-with-Known-Gaps-checklist-section.

## §Fourth-Prompt-section-instance with §Follow-on-prompt

Cycle 236 has §a-Prompt-section + §a-Follow-on-prompt-section. §The-Follow-on-prompt is the prompt for Phases 6-7-8 (which expanded the design beyond its original scope).

§Borrowable-pattern: §when-a-design-grows-beyond-its-original-prompt, §a-Follow-on-prompt-section-captures-the-additional-prompt-that-drove-the-expansion. §The-design-history-is-archaeologically-traceable through the prompts.

§Four-cycles-with-Prompt-section-captured now (cycles 198 + 224 + 230 + 236); §cycle-236-is-the-first-with-a-Follow-on-prompt — §a-new-sub-shape.

§Sibling to cycle 228 daemon-os-sandbox-plugin's §Roadmap-calibration-via-git-blame (cycle 228 cites commits; cycle 236 cites the Follow-on-prompt). §Two-different-archaeological-shapes (commits + prompts) for tracing design evolution.

## §Open-optimisation-tracked-as-follow-up

> *Open optimisation:* the worker currently streams the archive through CapTP; for archives already in the CAS we could skip the stream and have the Rust worker fetch the SHA-256 directly from `cas_archive::load_archive_from_cas`. Tracked as a follow-up; not required for correctness.

§Borrowable-pattern: §when-the-design-has-an-optimization-not-required-for-correctness, §name-it-explicitly + §mark-it-as-follow-up + §mark-it-as-not-required-for-correctness. §The-design-document-IS-the-tracking-system for known optimizations.

§Sibling to cycle 220 familiar-localhttp-protocol's §Research-needed-section. §Different-shape — cycle 220 names verification gaps; cycle 236 names optimization opportunities.

## §The-four-buckets section

> Buckets 2 and 3 are the Node-only bridge. The stated long-term goal: grow the ecosystem [...] so that buckets 2 and 3 shrink.

§Four-named-buckets categorize every caplet source:

1. §Archive-or-readable-tree-loaded-in-any-worker (preferred).
2. §Unconfined-Node-plugin-from-filesystem-path (legacy bridge).
3. §Unconfined-Node-plugin-from-tree (staging bridge).
4. §Eval-inside-an-individual-worker (ad-hoc escape hatch).

§Borrowable-pattern: §when-a-design-completes-a-classification, §enumerate-the-buckets + §name-which-are-preferred-and-which-are-bridges. §The-bucket-enumeration-IS-the-classification.

## §The-no-on-the-wire-format-change-needed observation

> The daemon stores the ZIP exactly as it stores any other readable blob today [...] no on-the-wire format change is needed there.

§Borrowable-pattern: §when-a-substitution-doesn't-need-a-new-wire-format, §name-it-as-a-non-change explicitly + §reuse-the-existing-substrate.

§Sibling to cycle 222 endoclaw-skill-registry's §no-new-abstractions — both designs §reuse-existing-primitives. §Cycle 222 reuses EndoDirectory; cycle 236 reuses readable-blob.

§Five-cycles-on-no-new-abstractions discipline now (cycles 211 + 214 + 222 + 232 + 236).

## Related material in the library

- **cycle 223 @endo/module-source**: §the-Node-worker-compiles-source-modules-via this package.
- **cycle 221 @endo/bundle-source**: §the-CLI's-`endo archive`-uses-`compartment-mapper.makeArchive`.
- **cycle 235 @endo/compartment-mapper/generic-graph**: §the-compartment-mapper-substrate cycle 236 builds on.
- **cycle 230 endor-npm-registry-proxy**: §sibling-substitution-design (both enumerate three named problems with old format and four named properties of replacement).
- **cycle 217 @endo/errors**: §legacy-tolerated-for-named-environment vs cycle 236's §legacy-kept-active-indefinitely.
- **cycle 228 daemon-os-sandbox-plugin**: §superseded-with-named-replacement contrast.
- **cycle 224 daemon-web-gateway + cycle 230**: §Dependencies-table-with-Relationship-column sibling.
- **cycle 222 endoclaw-skill-registry**: §explicit-flow-and-convenience-wrapper sibling.
- **cycle 234 endoclaw-oauth**: §filter-the-capability-out-of-the-guest's-view sibling.
- **cycle 198 + 224 + 230**: §Prompt-section-captured siblings (cycle 236 adds Follow-on-prompt).
- **cycle 229 marshal-justin**: §naming-by-distinguishing-axis-not-by-product sibling.

## §Library-reaches-742-sections at cycle 236 (designs-lane daemon-make-archive).

## §Seventieth consecutive designs-chat alternation cycles 166-236.

## §Twelve-different-shapes-of-design-evolution-record in 2026-06 cluster

§The-design-evolution-record-grows-by-one-with-cycle-236: §Phases-grew-beyond-original-scope-and-Status-flipped-back-to-In-Progress.

## §Four-cycles-with-Prompt-section-captured + §first-Follow-on-prompt

| Cycle | Design | Prompt purpose |
|-------|--------|----------------|
| 198 | patterns-diagnostic-feedback | §three-revision-pivots-visible-in-Prompt-section |
| 224 | daemon-web-gateway | §the-original-design-brief preserved |
| 230 | endor-npm-registry-proxy | §a-design-doc-as-a-design-reminder (self-referential) |
| 236 | daemon-make-archive | §Prompt + §Follow-on-prompt (first instance of two prompts) |

§Cycle-236-is-the-first-with-a-Follow-on-prompt-section — §when-a-design-grows-beyond-its-original-prompt, §a-Follow-on-prompt-section-captures-the-additional-prompt.

## §Three-cycles-with-Dependencies-table-with-Relationship-column

Cycles 224 + 230 + 236.

## §Four-cycles-on-strict-by-default-with-opt-in-extension

Cycles 226 + 230 + 231 + 236 (cycle 236's source-only-contract-via-parser-map-omits-precompiled-parsers).

## §Five-cycles-on-no-new-abstractions discipline

Cycles 211 + 214 + 222 + 232 + 236 (cycle 236's reuse-existing-readable-blob-storage).

## §Three-cycles-with-explicit-flow-and-convenience-wrapper

Cycles 222 + 226 + 236 (cycle 236's stageTree + makeUnconfinedFromTree).
