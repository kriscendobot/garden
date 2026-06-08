---
title: "designs/cli-store-verb-text-modes.md — Unified axis scheme replaces multiplied verbs + reshape-blocker-for-PR + blobs-are-bytes + three-orthogonal-axes + same-flag-for-read-and-write"
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
---

# Unified axis scheme replaces multiplied verbs + reshape-blocker-for-PR + blobs-are-bytes + three-orthogonal-axes + same-flag-for-read-and-write

A 446-line **Proposed** design (Created 2026-05-08). §Source-field-cites-PR-AND-inline-review-discussion-id with line number (`#discussion_r3205660244` on `packages/cli/src/commands/write-text.js:15`). The design exists because the maintainer's review on PR #128's `write-text.js` line 15 pushed back on two new top-level verbs as a presentation problem.

## §Reshape-blocker-for-PR as named relationship type

The design declares §This-design-is-a-reshape-blocker-for-PR-#128 in the introduction and §Reshape-blocker-for as a §named-section-with-impact-enumeration at the end. §Reshape-blocker-for is a §new-relationship-type-distinct-from-Supersedes-or-Dependencies: §the-design-doesn't-replace-an-old-shape (Supersedes) + §the-design-doesn't-depend-on-another-design (Dependencies); §the-design-blocks-an-in-flight-PR-until-its-shape-is-revised.

§When-a-design-must-land-before-a-PR-can-merge, §use-the-Reshape-blocker-for-section-to-name-the-PR-and-the-files-it-touches. §The-impact-enumeration names §the-specific-files-that-will-be-removed (`packages/cli/src/commands/write-text.js` and `packages/cli/src/commands/read-text.js`) and §what-replaces-them (new `endo write` / `endo read` verbs).

§Thirtieth-honest-design-evolution-record family member; §fourteenth-different-shape in 2026-06 cluster: §Reshape-blocker-for-PR as design-evolution-record-shape. §Sibling-to-cycle-238's §design-revision-after-CHANGES_REQUESTED but distinct: cycle 238 was a redesign after PR rejection; cycle 240 is a parallel design that blocks an in-flight PR's merge until the shape is reconsidered. §Two-cycles-with-PR-driven-redesign-shapes (cycles 238 + 240) — two different temporal relationships to the in-flight PR.

## §Three-orthogonal-axes for the CLI surface

The design's §load-bearing-observation is that the existing verbs mix §three-axes:

1. **§Source / sink:** stdin, stdout, file path, argv string literal.
2. **§Representation:** opaque blob (bytes), text (UTF-8 string), JSON (structured passable value), bigint (passable scalar), tree (`readable-tree` of nested entries).
3. **§Where-it-lives-in-the-formula-graph:** content-addressed immutable formula (`readable-blob`, `readable-tree`) vs. primitive value (passable string, bigint), vs. path inside a mutable mount.

§The-third-axis-was-introduced-without-naming. §PR-#128's-`writeText` introduced the mutable-mount axis without naming it; both `endo store --text` (write a string-value formula) and `endo write-text` (write UTF-8 bytes through a mount) look like "save some text" but operate against different addressing schemes. §When-an-axis-is-introduced-without-naming, §the-design-debt-IS-the-axis-name + §the-fix-is-to-name-the-axis-not-to-add-more-verbs.

§The-CLI-already-presents-a-confusing-surface-around-stored-content + §adding-two-more-top-level-verbs-without-a-presentation-strategy-multiplies-the-confusion. §Verb-count-as-named-cost — §each-new-verb-multiplies-the-surface-area + §the-presentation-strategy-IS-the-design.

## §Survey-table-of-existing-verbs

The design opens with two tables enumerating the §existing-store-family-verbs (eleven rows for write-side; six rows for read-side). §The-survey-IS-the-evidence-of-the-confusion. §When-a-design-proposes-to-reshape-a-CLI-surface, §the-design-MUST-enumerate-the-existing-surface-first + §the-table-IS-the-baseline-against-which-the-reshape-is-measured.

§Per-verb-row enumerates four columns: Verb / Source / Sink representation / Pet name produced. §The-table-format-makes-the-orthogonal-axes-visible-as-different-columns. §When-a-design-reveals-orthogonal-axes-in-existing-verbs, §a-table-with-per-axis-columns-IS-the-revelation-mechanism.

## §Unified-axis-scheme as the recommendation

```
endo store [--blob|--text|--json|--bigint|--tree]    # representation
           [-p <file>|--stdin|--literal <s>]         # source
           [-n <name-path>]                          # destination
           [--as <agent>]
```

§Mutual-exclusion-of-flag-groups: §representation-flag-required-and-mutually-exclusive + §source-flag-required-and-mutually-exclusive. §The-flag-groups-IS-the-axes. §When-a-CLI-verb-has-multiple-axes, §each-axis-becomes-a-required-mutually-exclusive-flag-group + §the-flag-groups-name-the-axes-and-the-flags-name-the-positions-on-each-axis.

§Eleven-canonical-form-examples follow the scheme:

```
endo store --blob -p ./image.png -n photos/cat
endo store --text --literal "hello" -n greeting
endo store --text --stdin -n notes/meeting     # subsumes write-text
endo store --json --stdin -n inbound/payload
endo store --tree -p ./src -n project          # subsumes checkin
```

§Subsumes-old-verb annotations name the migration explicitly per row. §When-a-canonical-form-replaces-an-existing-verb, §the-canonical-form-MUST-annotate-the-subsumption-inline-with-a-comment + §the-reader-sees-which-old-verb-each-line-replaces.

## §Same-flag-for-read-and-write

The `-p <file>` flag is §the-same-flag-for-input-and-output-paths: `endo store -p <file> -n <name>` reads from a file; `endo cat -p <file> <name>` writes to a file. §The-direction-of-flow-is-implicit-in-the-verb + §the-flag-stays-the-same-letter. §When-a-verb-pair-takes-symmetric-file-arguments, §use-the-same-flag-not-`--from`/`--to`-duals + §the-verb-disambiguates-direction.

§Symmetry-by-verb-pair-not-by-flag-prefix. §Sibling-to-cycle-238's §cancellation-promise-as-platform-neutral-interface (both designs choose symmetry-by-verb-shape over symmetry-by-flag-rename).

## §No-encoding-flag-the-daemon-does-not-negotiate-codecs

§All-text-input-and-output-is-UTF-8. §There-is-no-`--encoding`-flag. §Inputs-that-are-not-valid-UTF-8-in-text-modes-are-rejected-at-the-CLI-boundary. §When-a-CLI-touches-text-modes, §pick-one-encoding-and-reject-everything-else-at-the-boundary + §the-daemon-doesn't-negotiate-codecs + §validation-is-at-the-CLI-not-spread-throughout.

§Sibling-to-cycle-237's §undefined-sorts-greater-than-anything-else as §named-canonical-decision-about-input-shape (both designs make a single decision and refuse to negotiate). §Two-cycles-with-canonical-single-encoding-or-ordering-decision (cycles 237 + 240).

## §Blobs-are-bytes as load-bearing maxim

§Decisions-section opens with §Blobs-are-bytes — the maxim is §attributed-to-a-specific-PR-review-comment (PR #153 discussion_r3213469481): "Blobs are bytes." §When-a-maxim-is-load-bearing, §quote-it-verbatim-from-the-PR-review-and-cite-the-comment-id-by-link.

§Three-cycles-with-PR-discussion-link-as-named-provenance (cycles 238 + 239 + 240). §The-PR-discussion-link is now a recurring named-provenance shape. §When-a-named-decision-resulted-from-a-PR-discussion, §link-to-the-comment-id-not-just-the-PR-number — §the-comment-id-anchors-to-the-specific-sentence + §the-PR-number-anchors-only-to-the-larger-context.

§No-content-type-on-blobs: §the-daemon-does-not-store-charset-content-type-or-text-vs-blob-mode-on-blobs. §When-data-has-out-of-band-metadata, §the-metadata-stays-out-of-band (in pet name, in consumer's expectation, or in a sibling formula). §Three-named-places-for-out-of-band-metadata (pet-name + consumer-expectation + sibling-formula). §When-a-store-supports-many-data-types, §pick-the-narrowest-uniform-representation-and-name-the-out-of-band-metadata-locations.

§The-`--text`-and-`--blob`-split is §intentionally-narrow: §`--text`-is-for-primitive-string-values + §it-does-not-absorb-a-file-into-a-blob-with-text-metadata. §When-a-flag-could-be-overloaded-to-add-metadata, §refuse-the-overload + §point-the-user-at-the-explicit-blob-path-with-downstream-UTF-8-decode.

## §Two-viable-name-choices with Pro/Con per choice

The design enumerates §two-viable-choices for the read verb (extend `endo cat` vs introduce `endo retrieve`), each with §Pro and §Con bullet lines. The §recommendation chooses `endo cat` because §the-verb-count-argument-that-motivates-this-whole-reshape-applies-just-as-forcefully-to-the-read-side. §A-new-retrieve-verb-undoes-that-economy.

§Internal-consistency-test-as-design-discipline: §the-argument-that-justifies-the-reshape-must-also-apply-to-the-symmetric-decisions-inside-it; §when-a-design-rejects-new-verbs-on-the-write-side, §it-must-also-reject-new-verbs-on-the-read-side + §otherwise-the-internal-consistency-fails. §When-a-design-considers-an-extension, §audit-whether-the-design's-own-rationale-rejects-the-extension.

## §Three-decisions section with quoted maintainer reviews

§Decisions-section enumerates three numbered decisions:

1. **§Blobs-are-bytes** — quoted from PR #153 discussion.
2. **§`endo write`-is-the-right-name** — quoted from PR #153 discussion ("Write is fine.") + §alternatives-considered (`endo set`, `endo poke`, `endo put`) + §reserved-future-siblings (`edit`, `patch`).
3. **§`endo store --tree` does not accept stdin in non-zip mode** — §incoherent-flag-combinations-rejected-with-error-pointing-to-coherent-alternative.

§Three-cycles-with-numbered-Design-Decisions in library now (cycle 230 had 5 + cycle 236 had 9 + cycle 240 has 3). §Two-cycles-with-Decisions-section-that-quote-the-maintainer-review-verbatim (cycles 238's CHANGES_REQUESTED quote + cycle 240's two-quotes-from-PR-#153). §When-a-decision-was-affirmed-by-a-maintainer-review, §quote-the-affirmation-verbatim + §the-quote-IS-the-evidence-of-affirmation.

## §Three-alternatives-with-three-fates (all rejected)

§Alternatives-considered enumerates three alternatives:

- **Alt 1: keep `write-text` / `read-text` as-is** — §rejected (inflates verb count and entrenches the conflation).
- **Alt 2: only add `--text` to `endo store`; defer mount-path writes** — §rejected as partial-fix (PR #128 needs an answer; deferring leaves the new top-level verbs in place).
- **Alt 3: single `endo write` verb subsumes both formula and mount cases** — §rejected because §the-operation's-effect-depends-on-the-state-of-the-daemon-rather-than-on-the-verb-the-user-typed + §surprising-and-hard-to-script-defensively.

§Alt-3-as-state-dependent-dispatch-anti-pattern: §when-a-verb's-effect-depends-on-implicit-state, §the-script-cannot-defend-against-the-state-changing + §the-verb-becomes-context-dependent. §This-IS-the-shape-of-state-dependent-dispatch-rejected-as-CLI-design-anti-pattern. §Sibling-to-cycle-238's §Alt-A-rejected (mutate-by-recreate would invalidate guest references): both rejections name §the-operation's-effect-depends-on-implicit-state-IS-the-failure-mode.

§Two-cycles-with-Alternatives-Considered-section-with-named-fates (cycles 238 + 240). §Cycle-238 had (rejected + rejected + deferred); §cycle-240 has (rejected + rejected + rejected). §Three-fates-discipline now varies: §two-different-fate-distributions in the same family.

## §Edit-and-patch reserved as future siblings

§Reserved-future-siblings: §`edit`-and-`patch`-are-reserved-as-future-siblings-to-`read`/`write` + §the-`edit`-verb-is-designed-in-the-sibling-`cli-edit-verb`-PR-#162-which-this-design-does-not-prejudge-its-shape. §When-a-verb-family-has-near-neighbors, §reserve-the-near-neighbor-names-explicitly + §point-at-the-sibling-design-that-will-fill-them + §explicit-non-prejudgment-of-the-sibling-shape.

§Sibling-to-cycle-238's §Alt-C-deferred (three-way split with inspector facet) where the deferral named the §non-breaking-condition; cycle 240's reservation names §the-sibling-design-that-fills-it. §Two-cycles-with-explicit-future-reservation in 2026-06 cluster (cycles 238 + 240).

## §Two-different-API-shapes-for-two-different-substrates

The design names a §clean-distinction-between-formula-creation-and-mount-mutation:

- §`endo store` → §formula-creation (storeBlob/storeValue at daemon level): creates a new content-addressed or value formula.
- §`endo write` → §mount-mutation (writeText at daemon level): mutates a path inside an already-existing mutable mount.

§The-CLI-distinction-mirrors-the-underlying-daemon-distinction. §When-the-substrate-has-two-different-APIs-for-two-different-purposes, §the-CLI-MUST-name-them-distinctly-even-if-the-user-experience-feels-similar + §don't-collapse-two-substrate-APIs-into-one-CLI-verb. §Sibling-to-cycle-236's §three-axis-table (Method × Source × Confinement) — both designs use orthogonal-axes-to-prevent-collapse-of-distinct-substrate-APIs.

## §PR-stacking-discipline in Sibling-design section

§Sibling-design names §the-PR-stacking-order: *PR #153 lands first, PR #162 ships on top*. §When-two-sibling-designs-must-land-in-order, §the-Sibling-design-section-names-the-order. §First-cycle-with-PR-stacking-discipline-named-explicitly in library.

§Sibling-to-cycle-236's §three-cycles-with-explicit-flow-and-convenience-wrapper (where the order of staging methods was named). §Two-different-shapes-of-ordering-discipline: §method-call-order-discipline (cycle 236) + §PR-merge-order-discipline (cycle 240).

## §Deferred section with named future-cost

§Deferred-section names §Windows-text-mode-transcoding as future work + §names-the-condition-under-which-it-becomes-blocking + §names-the-cost (*one-bit schema addition on the blob or directory entry plus a CLI-side egress branch*). §Three-named-things-per-deferred-item: §the-future-feature + §the-trigger-condition + §the-cost-estimate.

§When-a-design-defers-a-feature, §name-it-with-three-things (feature + trigger + cost) + §don't-leave-the-deferral-purely-open. §Sibling-to-cycle-238's §Alt-C-deferred where the §non-breaking-condition was named — cycle 240 deepens the discipline with §three-named-things-per-deferral.

## §Test-plan section with six named scenarios

Six test scenarios named: unit option-parser tests + `--text --literal` round-trip + `--blob -p <file>` round-trip + tree round-trip + `--tree --stdin` rejection + mount-path round-trip. §When-a-design-replaces-existing-verbs, §the-test-plan-includes-round-trip-tests-against-the-new-shape + §explicit-rejection-tests-against-incoherent-flag-combinations.

§Two-cycles-with-Test-plan-named-in-the-design-doc (cycles 238 + 240). §Six-named-scenarios + §rejection-tests-explicitly-listed.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Reshape-blocker-for-PR as named relationship type (thirtieth honest-design-evolution-record family member; fourteenth-different-shape).
- §The-third-axis-was-introduced-without-naming — when an axis is introduced without naming, the fix is to name the axis not to add more verbs.
- §Three-orthogonal-axes-mixed-in-existing-verbs as the load-bearing observation.
- §Verb-count-as-named-cost.
- §Survey-table-of-existing-verbs as the baseline against which the reshape is measured.
- §Per-axis-columns-in-the-survey-table makes orthogonal axes visible.
- §Mutual-exclusion-of-flag-groups names the axes.
- §Same-flag-for-read-and-write — symmetry by verb pair, not by flag prefix.
- §No-encoding-flag-the-daemon-does-not-negotiate-codecs — pick one encoding and reject everything else at the boundary.
- §Blobs-are-bytes as load-bearing maxim attributed to a specific PR review comment.
- §No-content-type-on-blobs — out-of-band metadata stays out of band; three named locations (pet-name + consumer-expectation + sibling-formula).
- §Two-different-API-shapes-for-two-different-substrates (formula-creation vs mount-mutation).
- §Alt-3-as-state-dependent-dispatch-anti-pattern — when a verb's effect depends on implicit state, the script cannot defend against the state changing.

**Tier-2 (design discipline):**

- §Internal-consistency-test-as-design-discipline — the argument that justifies the reshape must apply to the symmetric decisions inside it.
- §Two-viable-name-choices with Pro/Con per choice; the recommendation cites the design's own rationale.
- §Reserved-future-siblings — when a verb family has near neighbors, reserve the near-neighbor names explicitly and point at the sibling design.
- §Sibling-design with §PR-stacking-discipline named explicitly.
- §Three-named-things-per-deferral (feature + trigger + cost).
- §Decisions-section-quotes-the-maintainer-review-verbatim — when a decision was affirmed by maintainer review, quote the affirmation verbatim.

**Tier-3 (named comparisons):**

- §Subsumes-old-verb annotations in canonical-form examples — the reader sees which old verb each line replaces.
- §When-a-canonical-form-replaces-an-existing-verb, §the-canonical-form-MUST-annotate-the-subsumption-inline-with-a-comment.
- §Rejection-tests-explicitly-listed in the test plan (`--tree --stdin` is rejected with a pointing error message).

## §Synthesis target — slot machine library

For a slot machine library:

- §game-verb-axis-table for §game-mode-presentation discipline.
- §unified-axis-scheme-replaces-multiplied-verbs for §game-action-presentation: §`spin --classic --coin <n>` rather than `spin-classic` and `spin-classic-bonus` as separate verbs.
- §three-orthogonal-axes for §game-action-design: §game-mode + §payout-shape + §where-it-lives-in-the-rule-graph.
- §same-flag-for-input-and-output for §symmetric-game-action-verbs.
- §no-encoding-flag — §game-engine-doesn't-negotiate-currency-codes; pick one and reject everything else at the boundary.
- §blobs-are-bytes for §game-payout-tokens-are-opaque (no embedded metadata).
- §no-content-type for §game-tokens-don't-carry-currency-type; out-of-band via §game-pet-name or §sibling-formula.
- §two-different-API-shapes-for-two-different-substrates for §game-state-creation-vs-game-state-mutation.
- §state-dependent-dispatch-anti-pattern — §game-rules-whose-effect-depends-on-implicit-game-state-cannot-be-scripted-defensively.
- §reshape-blocker-for-PR for §game-rule-revision-blocks-feature-PR-until-rule-shape-is-revised.
- §verb-count-as-named-cost for §game-rule-count-as-named-cost; each new game rule multiplies the rule surface area.
- §reserved-future-siblings for §game-action-near-neighbors.
- §PR-stacking-discipline for §game-feature-PR-stacking-order.
- §three-named-things-per-deferral for §game-feature-deferred-with-trigger-and-cost.

## §Library meta-counters

- §Library-reaches-746-sections at cycle 240 (designs-lane cli-store-verb-text-modes).
- §Seventy-fourth consecutive designs-chat alternation cycle (cycles 166-240).
- §Thirtieth-honest-design-evolution-record family member (new shape: §Reshape-blocker-for-PR-as-named-relationship-type).
- §Fourteenth-different-shape-of-design-evolution-record in 2026-06 cluster (214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230 + 232 + 236 + 238 + 240).
- §Seven-cycles-on-no-new-abstractions discipline now (cycles 211 + 214 + 222 + 232 + 236 + 238 + 240) — the design's whole posture is §don't-multiply-the-verbs.
- §Five-cycles-with-Dependencies-table-with-Relationship-column (cycles 224 + 230 + 236 + 238 + 240).
- §Sixth-Prompt-section-instance (cycles 198 + 224 + 230 + 236 + 238 + 240).
- §Three-cycles-with-PR-discussion-link-as-named-provenance (cycles 238 + 239 + 240) — recurring shape.
- §Two-cycles-with-PR-driven-redesign-shapes (cycles 238 CHANGES_REQUESTED + cycle 240 inline-review-comment-on-line) — two different temporal relationships to in-flight PR.
- §Two-cycles-with-Alternatives-Considered-section-with-named-fates (cycles 238 + 240) — fate distributions vary (238 had rejected+rejected+deferred; 240 has rejected+rejected+rejected).
- §Two-cycles-with-Decisions-section-that-quote-the-maintainer-review-verbatim (cycles 238 + 240).
- §Two-cycles-with-explicit-future-reservation in 2026-06 cluster (cycles 238 + 240).
- §Three-cycles-with-numbered-Design-Decisions (cycle 230 + 236 + 240).
- §Two-cycles-with-Test-plan-named-in-the-design-doc (cycles 238 + 240).
- §First-cycle-with-PR-stacking-discipline-named-explicitly in library.
- §First-cycle-with-three-named-things-per-deferral (feature + trigger + cost).
- §First-cycle-with-state-dependent-dispatch-anti-pattern-named-as-such.
- §First-cycle-with-Subsumes-old-verb-annotations-in-canonical-form-examples.
- §Twelve-design-cluster for endoclaw + cli-http + cli-store now (cycle 238's eleven + cycle 240's cli-store-verb-text-modes).

(Kris Kowal (prompted) authored)
