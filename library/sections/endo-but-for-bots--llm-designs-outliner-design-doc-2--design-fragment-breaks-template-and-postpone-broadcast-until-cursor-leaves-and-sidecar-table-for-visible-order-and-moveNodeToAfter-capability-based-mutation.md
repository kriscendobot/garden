---
title: "outliner-design-doc-2.md — free-form design fragment that breaks the canonical design-doc-template + postpone-node-creation-until-cursor-leaves-or-debounce-timer + indent-dedent-as-types-of-edits-later + sidecar-table-for-visible-order + moveNodeToAfter capability-based mutation"
source-slug: endo-but-for-bots--llm-designs-outliner-design-doc-2
section-slug: design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner-design-doc-2.md
source-repo: endojs/endo-but-for-bots
source-path: designs/outliner-design-doc-2.md
source-author: Endo project (unattributed; design fragment style)
total-lines: 10
ingest-cycle: 263
ingest-date: 2026-06-10
lane: designs
---

# `outliner-design-doc-2.md` — a free-form design fragment that breaks the canonical design-doc-template

A **10-line** prose-only design fragment in `endo-but-for-bots/designs/`. Stands out from the cluster as the **only design file in the directory without the canonical metadata table** (no Status / Created / Updated / Author / Parent fields). Reads as a §design-conversation-not-a-design-doc — a sequence of architectural recommendations and open questions about the outliner UI's protocol behavior.

This file is structurally interesting precisely **because** it breaks the template. The cluster's ninety-plus designs follow the template religiously (per the directory's CLAUDE.md spec); this one is the exception. §the-template-deviation-IS-the-pattern; §when-a-design-is-a-fragment-rather-than-a-spec, §the-metadata-table-is-omitted; §the-format-IS-evidence-of-the-design's-maturity-or-purpose.

## §The "design-doc-2" suffix — a §follow-up-design naming convention

The filename `outliner-design-doc-2.md` signals it is the **second** design pass on the outliner (sibling outliner-* files: `outliner_drag_and_drop.md` (1020 lines) + `OUTLINER_INTERACTION_PATTERNS.md` (997 lines)).

§the-`-design-doc-2`-suffix-IS-a-follow-up-design-naming-convention — §when-a-design-iterates-on-a-prior-design, §a-`-2`-suffix-is-the-canonical-name; §sibling-pattern to git's commit-fixup convention (`fixup!` prefix) — §the-name-IS-the-evidence-of-revision; §first-explicit-observation in library.

## §Three-named-outliner-comparison-points (Roam + Obsidian + Workflowy)

Line 1: *"like interacting with a traditional outliner like Roam Research, Obsidian, or Workflowy"*.

§Three-named-comparison-points-for-UX-positioning:
- §**Roam Research** — the bidirectional-link-and-graph outliner with `[[backlinks]]`.
- §**Obsidian** — the local-first markdown outliner.
- §**Workflowy** — the canonical pure-outliner with infinite-zoom and hoist-as-root.

§the-three-named-comparison-points-IS-the-target-UX-positioning — §when-a-design-aims-to-match-existing-UX, §name-three-canonical-examples-rather-than-describe-the-feel-abstractly; §the-three-names-collectively-define-the-target-better-than-a-paragraph-of-description; §sibling-pattern to design-doc convention of §enumerate-concrete-examples-then-generalize (cycle 234 OAuth's five named providers; cycle 257 proactive-messages's four named use cases); §first-explicit-observation in library of §three-named-comparison-points-as-UX-positioning-shorthand.

## §References `docs/OUTLINER_INTERACTION_PATTERNS.md` by relative path

Line 3: *"You can find some recommendations for how to achieve this in docs/OUTLINER_INTERACTION_PATTERNS.md"*.

§the-design-fragment-points-at-a-companion-prose-document-by-named-path; §sibling-pattern to cycle 261's §the-substrate-design-names-the-derivative-design-by-link; §two-cycles-with-document-references-by-named-path (261 + 263).

§the-reference-path-is-`docs/...`-but-this-file-is-in-`designs/...` — §the-companion-document-lives-in-a-sibling-directory; §the-cross-directory-relative-path-might-mean-the-file-was-moved-but-the-reference-not-updated; §a-named-evidence-of-design-doc-drift; §first-explicit-observation in library of §cross-directory-relative-path-as-evidence-of-design-doc-drift.

## §Postpone-node-creation-until-cursor-leaves-or-debounce-timer

Line 7 (the central architectural recommendation):

> *if the cursor is in one node, then the user hits enter, it would create a peer, but we don't know that the user intends to keep it a peer, since they might then hit tab, or shift-tab to indent or dedent respectively, and so my current recommendation is that we postpone node creation until the user's cursor leaves a node, or some debounced timer expires, and then allow indent/dedent operations to be represented as types of edits later*

§Three-named-deferral-strategies-for-broadcast:
1. §**cursor-leaves-the-node** — explicit user-driven boundary.
2. §**debounced-timer** — time-based boundary when cursor doesn't leave.
3. §**represent-as-edits-later** — fallback when broadcast has already happened.

§the-protocol-broadcast-timing-is-a-three-way-choice-not-an-immediate-broadcast — §when-a-UI-action-might-be-corrected-by-an-immediately-following-action, §postpone-the-broadcast-until-the-correction-window-closes + §use-cursor-position-OR-time-as-the-window-boundary; §first-explicit-observation in library of §postpone-broadcast-until-correction-window-closes-using-cursor-position-OR-time-as-boundary.

§the-`peer/indent/dedent`-sequence-IS-the-canonical-example — three keystrokes that could be one logical action; §when-the-most-recent-edit-might-undo-the-second-most-recent, §broadcasting-each-edit-individually-creates-protocol-noise; §the-postponed-broadcast-pattern reduces this noise.

§the-design-uses-"my current recommendation"-as-named-tentativeness-marker — §the-author-is-uncertain + §"my current"-IS-explicit-revision-allowance; §sibling-pattern to design-doc convention §Status: Not Started; §two-named-tentativeness-styles (design-doc-template uses Status field; design-fragment uses prose hedges); §first-explicit-observation in library.

§the-cursor-position-IS-the-natural-edit-boundary — §the-cursor-is-the-user's-focus-of-attention; §when-the-cursor-leaves, §the-edit-is-conceptually-complete; §first-explicit-observation in library.

## §Indent/dedent as types of edits later

Line 7's tail: *"then allow indent/dedent operations to be represented as types of edits later (which are presumably affecting the replyTo value and order of nodes)"*.

§Two-data-fields-affected-by-indent/dedent:
- §**`replyTo`** — the parent-pointer; indent/dedent walks the tree relative to neighbors.
- §**order-of-nodes** — the §visible-order-distinct-from-creation-order.

§the-indent/dedent-operation-decomposes-into-two-field-edits — §when-a-UI-operation-feels-atomic, §the-protocol-may-represent-it-as-a-composition-of-field-edits; §sibling-pattern to capability-systems' decomposition discipline (cycle 234 OAuth's six-step flow); §two-cycles-with-decompose-atomic-UI-operation-into-named-protocol-edits (234 + 263); §first-explicit-observation in library.

§the-`(which are presumably affecting...)`-parenthetical — §the-author-hedges-with-`presumably`; §two-prose-hedges-in-one-fragment so far ("my current recommendation" + "presumably"); §the-hedging-IS-the-evidence-of-design-iteration-in-progress.

## §Non-chronological child node order — a named assumption-break

Line 9: *"how we should go about recording the visible order of child nodes, since we are no longer assuming they are listed chronologically"*.

§the-prior-assumption-was-chronological-ordering + §the-new-design-breaks-that-assumption; §sibling-pattern to cycle 250's named-assumption-break (system-items-with-`@`-prefix-remain-with-existing-toggle); §two-cycles-with-named-prior-assumption-break (250 + 263).

§visible-order-distinct-from-creation-order — §two-orderings-now-coexist (creation-order is implicit in creation timestamps; visible-order is explicit in the new sidecar); §sibling-pattern to git's commit-graph (creation order via timestamps + topological order via parent links); §the-design-introduces-a-second-ordering-axis; §first-explicit-observation in library of §two-orderings-coexist-creation-order-implicit-and-visible-order-explicit.

## §Sidecar-table-for-visible-order — backward-compat discipline

Line 9: *"It would be best if we can do this without modifying the message schema, so maybe we have an extra table within the outliner channel that allows storing this kind of information"*.

§Named-backward-compat-discipline — *"without modifying the message schema"*; §the-message-schema-is-treated-as-frozen + §new-data-goes-in-a-sidecar-table; §sibling-pattern to cycle 245's panic-cluster's pre-lockdown-capture + cycle 246's lockdown-relink-of-shims (don't-modify-the-platform; capture-it-instead); §the-discipline-is-the-same-across-platform-and-protocol-layers — §when-a-thing-is-treated-as-immutable, §augment-via-a-named-sidecar-not-by-mutation; §three-cycles-with-augment-via-named-sidecar-not-by-mutation (245 + 246 + 263).

§"an extra table within the outliner channel" — §the-sidecar-lives-WITHIN-the-outliner-channel + §it-IS-channel-local-not-message-local; §the-sidecar's-scope-IS-the-channel-not-the-individual-message; §first-explicit-observation in library of §the-sidecar-lives-within-the-channel-not-on-the-individual-message-as-named-scope-decision.

## §moveNodeToAfter capability-based mutation

Line 9: *"The ability to mutate the placement of a node should require access to that node, like `channel.moveNodeToAfter(node, newPrecursor)` or something"*.

§The-mutation-requires-the-node-capability — §holding-the-node-IS-the-authorization-to-mutate-its-placement; §sibling-pattern to cycle 261's substrate-canonical-two-facet-pattern (capability-by-construction); §nine-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261 + 263).

§`channel.moveNodeToAfter(node, newPrecursor)` — §the-method-takes-two-named-capability-arguments (the node being moved + the new predecessor); §the-API-signature-IS-the-authorization-contract.

§"or something" — the author's prose-hedge on the API name itself; §three-prose-hedges-in-one-fragment ("my current recommendation" + "presumably" + "or something"); §first-explicit-observation in library of §three-prose-hedges-in-one-design-fragment-as-evidence-of-active-design-discussion.

## §The ".f" typo as evidence of human authorship

Line 9 literally ends with `or something.f` — a typographical evidence-of-human-authorship trace. §the-typo-IS-the-evidence — design-fragments are not heavily-edited; the typo's preservation suggests §the-fragment-IS-treated-as-conversational-not-formal; §first-explicit-observation in library of §a-preserved-typo-as-evidence-of-design-fragment's-informal-status.

## §The fragment is the only outliner design in the cluster without metadata table

Cross-check via directory listing: `outliner_drag_and_drop.md` (1020 lines), `OUTLINER_INTERACTION_PATTERNS.md` (997 lines) all follow the canonical design-doc-template per `designs/CLAUDE.md`. Only `outliner-design-doc-2.md` is a 10-line fragment.

§the-cluster-has-large-outliner-designs-and-one-fragment — §the-fragment-IS-the-current-design-thinking-in-flight + §the-large-files-ARE-the-prior-design-iterations; §when-a-design-is-in-flight-the-fragment-form-is-preferable-to-the-template-form because §the-template's-Status-Created-Updated-fields-imply-a-stability-the-design-doesn't-yet-have; §first-explicit-observation in library of §the-fragment-form-IS-the-right-form-for-design-in-flight-because-the-template-implies-stability-the-design-doesn't-have.

## §Cycle 263 first-explicit-observations (twelve)

1. **§the-template-deviation-IS-the-pattern** — the cluster's only design-without-metadata-table.
2. **§the-`-design-doc-2`-suffix-as-named-follow-up-naming-convention**.
3. **§three-named-comparison-points-as-UX-positioning-shorthand** (Roam + Obsidian + Workflowy).
4. **§cross-directory-relative-path-as-evidence-of-design-doc-drift**.
5. **§postpone-broadcast-until-correction-window-closes-using-cursor-position-OR-time-as-boundary**.
6. **§"my-current-recommendation"-as-named-tentativeness-marker-in-prose-design**.
7. **§the-cursor-position-IS-the-natural-edit-boundary-for-broadcast-timing**.
8. **§decompose-atomic-UI-operation-into-named-protocol-edits-on-named-fields**.
9. **§two-orderings-coexist-creation-order-implicit-and-visible-order-explicit**.
10. **§the-sidecar-lives-within-the-channel-not-on-the-individual-message-as-named-scope-decision**.
11. **§three-prose-hedges-in-one-design-fragment-as-evidence-of-active-design-discussion**.
12. **§a-preserved-typo-as-evidence-of-design-fragment's-informal-status**.

Plus: **§the-fragment-form-IS-the-right-form-for-design-in-flight-because-the-template-implies-stability-the-design-doesn't-have**.

## §Recurring meta-pattern counters bumped at cycle 263

- §**nine-cycles-with-explicit-capability-by-construction-discipline** (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261 + 263).
- §**three-cycles-with-augment-via-named-sidecar-not-by-mutation** (245 + 246 + 263).
- §**two-cycles-with-document-references-by-named-path** (261 + 263).
- §**two-cycles-with-named-prior-assumption-break** (250 + 263).
- §**two-cycles-with-decompose-atomic-UI-operation-into-named-protocol-edits** (234 + 263).
- §**two-named-tentativeness-styles** (design-doc-template's Status field + design-fragment's prose hedges).
- §**ninety-sixth consecutive designs-chat alternation cycles 166-250 + 252-263** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-design-fragment-form-applies-to-game-engine-in-flight-thinking:

- §**game-design-fragment** without metadata table — for tentative architectural recommendations not yet ready for the design-doc-template.
- §**three-named-comparison-points** for §game-UX-positioning (e.g., Las-Vegas-physical-slot + classic-arcade-pinball + modern-mobile-slot-app).
- §**postpone-bet-broadcast-until-correction-window-closes** — §when-a-player-presses-bet-then-immediately-presses-cancel, §the-protocol-should-not-have-broadcast-the-bet-yet; §use-cursor-(focus)-position-OR-debounced-timer-as-the-window-boundary.
- §**decompose-atomic-game-action-into-named-protocol-edits** (e.g., spin-the-reels → set-bet-amount + commit-bet + lock-reels + release-reels-on-stop).
- §**sidecar-table-within-the-game-channel** for §visible-order-of-game-events-distinct-from-chronological-game-event-order.
- §**moveBetToAfter(bet, newPrecursor)** capability-based-mutation — §holding-the-bet-IS-the-authorization-to-reorder-it.
- §**game-design-fragments-with-prose-hedges** ("my current recommendation", "presumably", "or something") to mark in-flight thinking.

## §Tier-1 borrowing

§the-template-deviation-IS-the-pattern + §the-`-design-doc-2`-suffix-as-named-follow-up + §three-named-comparison-points-as-UX-positioning-shorthand + §postpone-broadcast-until-correction-window-closes + §the-cursor-position-IS-the-natural-edit-boundary + §decompose-atomic-UI-operation-into-named-protocol-edits-on-named-fields + §two-orderings-coexist + §the-sidecar-lives-within-the-channel + §moveNodeToAfter-as-capability-based-mutation-requiring-the-node + §nine-cycles-with-explicit-capability-by-construction-discipline.

## §Tier-2 borrowing

§"my-current-recommendation"-as-named-tentativeness-marker + §three-prose-hedges-in-one-design-fragment + §the-fragment-form-IS-the-right-form-for-design-in-flight + §preserved-typo-as-evidence-of-informal-status + §cross-directory-relative-path-as-evidence-of-design-doc-drift.

## §Tier-3 borrowing

§three-cycles-with-augment-via-named-sidecar-not-by-mutation (245 + 246 + 263) + §two-cycles-with-document-references-by-named-path (261 + 263) + §two-cycles-with-named-prior-assumption-break (250 + 263) + §two-cycles-with-decompose-atomic-UI-operation-into-named-protocol-edits (234 + 263) + §library-reaches-769-sections at cycle 263 + §ninety-sixth consecutive designs-chat alternation cycles 166-250 + 252-263.

## Pattern summary (tag-prefixed)

§the-template-deviation-IS-the-pattern + §the-design-fragment-form-vs-the-design-doc-template-form + §the-`-design-doc-2`-suffix-as-named-follow-up + §three-named-comparison-points-as-UX-positioning-shorthand + §design-fragment-points-at-companion-prose-document-by-path + §cross-directory-relative-path-as-evidence-of-design-doc-drift + §postpone-broadcast-until-correction-window-closes-using-cursor-position-OR-time-as-boundary + §three-named-deferral-strategies-for-broadcast + §the-cursor-position-IS-the-natural-edit-boundary-for-broadcast-timing + §decompose-atomic-UI-operation-into-named-protocol-edits-on-named-fields + §two-orderings-coexist + §the-sidecar-lives-within-the-channel-not-on-the-individual-message + §moveNodeToAfter-as-capability-based-mutation-requiring-the-node + §"my-current-recommendation"-as-named-tentativeness-marker + §three-prose-hedges-in-one-design-fragment + §preserved-typo-as-evidence-of-informal-status + §the-fragment-form-IS-the-right-form-for-design-in-flight + §nine-cycles-with-explicit-capability-by-construction-discipline + §three-cycles-with-augment-via-named-sidecar-not-by-mutation.
