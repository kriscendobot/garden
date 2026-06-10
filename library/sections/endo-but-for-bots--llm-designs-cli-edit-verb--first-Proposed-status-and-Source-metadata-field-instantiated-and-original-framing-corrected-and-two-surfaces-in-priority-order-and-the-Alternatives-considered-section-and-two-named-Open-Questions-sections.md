---
title: "cli-edit-verb.md — first §Proposed Status ingested + §Source metadata field instantiated + §the original framing corrected discipline + §two surfaces in priority order + §the Alternatives considered section + §two named Open Questions sections (original + surfaced-by-builder-dispatch)"
source-slug: endo-but-for-bots--llm-designs-cli-edit-verb
section-slug: first-Proposed-status-and-Source-metadata-field-instantiated-and-original-framing-corrected-and-two-surfaces-in-priority-order-and-the-Alternatives-considered-section-and-two-named-Open-Questions-sections
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-edit-verb.md
source-repo: endojs/endo-but-for-bots
source-path: designs/cli-edit-verb.md
source-author: Kris Kowal (prompted)
total-lines: 1394
ingest-cycle: 279
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `cli-edit-verb.md` — the `edit` verb: hash-anchored line-based patches for AI agents

A 1394-line design — **the largest design-doc in the cluster ingested** and the first **`Proposed`** Status observed. Status: **Proposed**; Created 2026-05-08; Author Kris Kowal (prompted); Source: PR #153 inline review comment.

§First-explicit-observation in library: **§the-Proposed-Status-named-explicitly-as-a-Status-instance — §cycle-265's-CLAUDE.md-spec-named-eight-Status-values + §cycle-279-IS-the-first-Proposed-instance-observed**.

## §The Source metadata field instantiated — PR inline review comment anchor

Line 8 carries the §Source-field per cycle 265's CLAUDE.md spec's optional metadata:

> **Source** | PR [#153](https://github.com/endojs/endo-but-for-bots/pull/153) inline review comment [discussion_r3212462309](https://github.com/endojs/endo-but-for-bots/pull/153#discussion_r3212462309) on `designs/cli-store-verb-text-modes.md:403`

§First-explicit-observation in library: **§the-Source-metadata-field-instantiated-with-PR-inline-review-comment-anchor — §the-design-IS-spawned-by-a-named-PR-review-comment + §the-Source-field-carries-the-PR-number + §the-discussion-anchor-ID + §the-line-anchor-on-the-sibling-design + §three-named-anchors-in-one-Source-field**.

§The-Source-field-cites-three-levels-of-context:
1. **PR number** (`#153`) — the broader review.
2. **Discussion anchor** (`discussion_r3212462309`) — the specific inline comment.
3. **Line anchor** (`designs/cli-store-verb-text-modes.md:403`) — the specific line of the sibling design being reviewed.

§the-Source-field-IS-a-named-three-anchor-citation-shape; §sibling-pattern to academic citation conventions; §first-explicit-observation in library.

## §The original framing corrected discipline

Lines 33-43 carry §a-design-acknowledging-its-original-framing-was-wrong-and-corrected:

> *The original framing of this design positioned `endo edit` (a CLI verb human or scripted callers invoke) as the primary surface. Maintainer review on PR #162 corrected that framing. AI agents do not type CLI commands. They invoke tools, and those tool calls drive the daemon's `EndoGuest` API directly. The CLI is a thin convenience wrapper around that API for human operators and shell scripts; the daemon-side capability is the load-bearing surface that needs the design care.*

§First-explicit-observation in library: **§the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected — §the-correction-IS-named-explicitly + §the-correction-cites-the-PR-that-caused-it (PR #162) + §the-correction-IS-prose-not-removed-content**.

§Sibling-pattern to cycle 269's §the-named-evolution-of-a-system's-purpose-as-design-rationale (Chat-becoming-the-debugger-of-last-resort) — but here the evolution IS within the design's own lifecycle.

§Two-cycles-with-named-evolution-of-rationale-within-a-design-document (269 + 279); §the-discipline-IS-honest-record-keeping-of-design-iteration.

## §Two surfaces in priority order — primary + secondary

Lines 45-58:

> *The two surfaces in priority order:*
>
> *1. **Primary: `E(guest).edit(directoryRef, path, patch, options)`.** The daemon-side eventual-send API. This is what an agent's tool-call lands on. It performs the read, anchor validation, splice, and write under a single mount-internal critical section.*
>
> *2. **Secondary: `endo edit <name-path> --patch <file> --format hashline`.** A thin CLI wrapper that resolves the name path, reads the patch from a file or stdin, and delegates to the same daemon API as a single eventual send.*

§First-explicit-observation in library: **§two-surfaces-in-priority-order-named-explicitly (primary + secondary) — §the-design-distinguishes-primary-from-secondary-surfaces + §the-naming-IS-explicit-not-implicit + §the-cli-surface-IS-secondary-not-primary-despite-being-the-historical-default**.

§Sibling-pattern to cycle 269's §two-co-equal-halves (Chat + Debugger) — but here the two surfaces are **NOT** co-equal; one is **primary** and one is **secondary**. §two-named-design-shapes-for-multi-surface-features (co-equal + primary-secondary).

§First-explicit-observation in library: **§two-named-design-shapes-for-multi-surface-features (co-equal-halves cycle 269 + primary-and-secondary-surfaces cycle 279) — §the-cluster-now-distinguishes-two-named-multi-surface-relationships**.

## §Hashline as named wire format with three named adopting projects

Lines 64-73:
> *Hashline is a wire format for line-anchored file edits, originated by [oh-my-pi](https://github.com/can1357/oh-my-pi) and adopted by sibling projects ([opencode-hashline](https://github.com/izzzzzi/opencode-hashline), the `hive` agent framework, and others).*

§Four-named-projects-in-the-hashline-ecosystem:
1. **oh-my-pi** (originator).
2. **opencode-hashline** (adopting project).
3. **hive** (agent framework adopting it).
4. **(and others)** — §the-named-ellipsis-acknowledges-broader-adoption.

§First-explicit-observation in library: **§named-prior-art-attribution-with-named-originator-and-three-named-adopting-projects — §the-design-distinguishes-the-originator-from-adopters + §each-IS-named-and-linked + §sibling-pattern to academic citation conventions for prior art that has multiple adopters**.

§Three-cycles-with-named-prior-art-attribution-with-named-related-project (273 Muddle + 277 Muddle-Roam + 279 hashline-cluster); §the-discipline-IS-now-canonical-across-three-cycles.

## §The dual-purpose anchor — location identifier + staleness check

Lines 70-73:
> *Its insight: every line in a file gets a short content-hash anchor displayed alongside its line number whenever the agent reads the file, and edit operations reference those anchors instead of reproducing text.*

§First-explicit-observation in library: **§the-dual-purpose-anchor (location identifier + staleness check) — §the-content-hash-IS-both-WHERE-the-line-IS + §WHETHER-the-line-has-changed + §the-design-leverages-the-content-hash-twice-for-two-purposes-from-one-computation**.

§Sibling-pattern to many compare-and-swap conventions where the CAS token IS both the location and the staleness check. §the-content-hash-as-CAS-token-and-location-token-in-one.

§Three-named-properties-of-the-hashline-anchor:
1. **Short** — abbreviated content hash, not the full hash.
2. **Per-line** — every line has its own anchor.
3. **Displayed alongside the line number** — shown when read, used when edited.

§the-hashline-format-IS-a-display + reference-protocol-pair — §the-display-format-on-read + §the-reference-format-on-edit-operations.

## §Display format on read — `   1#a3 // @ts-check`

Lines 75-80 (the display format example):
> ```
>    1#a3 // @ts-check
> ```

§The-format-IS-three-parts: line-number + `#` + short-hash + (space + line-content); §the-`#`-IS-the-named-separator; §sibling-pattern to many diff-display-conventions but with hash-not-pipe-as-separator.

§First-explicit-observation in library: **§the-`<line-number>#<hash> <content>`-display-format-as-named-hashline-display-shape — §the-`#`-IS-the-named-separator-between-line-number-and-hash + §the-space-IS-the-separator-between-hash-and-content + §the-display-format-IS-the-protocol's-canonical-rendering**.

## §The Investigate dependencies we can imitate or rely on section

Lines 333-380 carry §an-Investigate-section — a named research / survey section before the design's main body.

§First-explicit-observation in library: **§the-Investigate-dependencies-we-can-imitate-or-rely-on-section-as-named-survey-discipline — §before-naming-the-design, §the-author-surveys-related-libraries-and-conventions + §the-discipline-IS-research-explicitly-named-and-recorded + §sibling-pattern to academic literature-review sections**.

## §Phase-prefixed headings grouping numbered phases

Lines 964-1059 carry §two-named-Phase-prefixed-headings each containing nested numbered phases:

- **`## Phase: daemon-side EndoGuest.edit for true atomicity`** (line 964) containing:
  - `### Phase 1: API surface and wire envelope`
  - `### Phase 2: daemon-side splice with mount-internal lock`
  - `### Phase 3: secondary formats`
- **`## Phase: multi-file atomicity`** (line 1004) containing:
  - `### Phase 4: multi-file edit batch`

§First-explicit-observation in library: **§two-named-Phase-prefixed-headings-grouping-numbered-phases — §the-`## Phase: <goal>`-form-groups-numbered-sub-phases-under-a-named-goal + §the-discipline-IS-different-from-cycle-269's-six-numbered-Phases + §the-Phase-grouping-IS-by-named-goal-not-just-sequence-number**.

§Sibling-pattern to many engineering documents where phases are grouped by milestone or theme. §the-cycle's-discipline-IS-grouping-phases-by-named-goal-rather-than-as-a-flat-numbered-sequence.

## §The Alternative formats considered section — named rejection record

Lines 1082-1166 carry §four-numbered-Alternatives-considered-with-rejection-rationales:

1. **Alt 1: unified diff (RFC 2440-ish)** — rejected.
2. **Alt 2: search-and-replace blocks (Aider's "diff" format)** — rejected.
3. **Alt 3: JSON Patch (RFC 6902)** — rejected.
4. **Alt 4: do nothing; tell agents to use `endo write` with the whole file** — rejected.

§First-explicit-observation in library: **§the-Alternative-formats-considered-section-as-named-rejection-record — §each-alternative-IS-named-with-an-RFC-or-format-citation + §each-IS-rejected-with-a-named-rationale + §the-section-IS-the-design's-honest-record-of-the-alternatives-considered**.

§Sibling-pattern to cycle 269's eleven Design Decisions of shape "X over Y because Z" — but here each Alt has its own subsection with its own rationale, rather than being inline in a Design Decisions list.

§Two-named-design-shapes-for-comparative-decisions:
1. **Design Decisions list** with "X over Y because Z" entries (cycle 269 + 271).
2. **Alternative formats considered section** with per-alternative subsections and rejection rationales (cycle 279).

§First-explicit-observation in library: **§two-named-design-shapes-for-comparative-decisions (inline-Design-Decisions-list + dedicated-Alternative-X-considered-section)**.

## §Two named Open Questions sections — original + surfaced-by-builder-dispatch

Lines 1168-1199 carry §a-first-Open-Questions-section (the original).
Lines 1201-1273 carry §a-Resolved-during-builder-dispatch section.
Lines 1275-1304 carry §a-second-Open-Questions-section: §Open-Questions-surfaced-by-builder-dispatch.

§First-explicit-observation in library: **§two-named-Open-Questions-sections-with-distinct-temporal-markers — §the-first-Open-Questions-section-IS-the-original-author's + §the-second-IS-named-"surfaced-by-builder-dispatch" + §a-middle-Resolved-section-marks-which-of-the-original-questions-have-been-answered + §the-three-section-shape-encodes-the-design's-temporal-evolution**.

§Sibling-pattern to cycle 273's §the-Edge-Cases-section-as-named-cumulative-discovery-record — but here the discovery is split across three temporally-anchored sections.

§Four-named-rationale-sections-in-design-documents now (extending cycle 277's three-named-rationale-sections):
1. **Design-Decisions** (prospective).
2. **Lessons-Learned** (retrospective).
3. **Edge-Cases** (discovered-during-impl).
4. **Open-Questions + Resolved + Open-Questions-surfaced-by-builder-dispatch** (the temporally-evolving question log).

§First-explicit-observation in library: **§four-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned + Edge-Cases + Open-Questions-evolution-log)**.

## §The "tentative pending kriskowal confirmation" marker

Line 867: `### Reapply search algorithm (tentative pending kriskowal confirmation)`.

§First-explicit-observation in library: **§the-maintainer-confirmation-pending-marker-as-named-tentativeness-discipline — §the-design-NAMES-which-portions-IS-tentative + §the-tentativeness-cites-the-specific-maintainer-whose-confirmation-IS-pending + §sibling-pattern to many engineering documents that distinguish committed-content-from-pending-review**.

§Two-cycles-with-named-tentativeness-marker (272 string.js's "Be prepared for these changes" + 279 cli-edit-verb's "tentative pending kriskowal confirmation"); §the-discipline-IS-emergent.

## §The "Reshape sibling for" section — named cross-design reshape relationship

Lines 1376-1383 carry §a-`## Reshape sibling for`-section — naming the cross-design-relationship where this design RESHAPES a sibling.

§First-explicit-observation in library: **§the-`## Reshape sibling for`-section-as-named-cross-design-reshape-relationship — §the-design-NAMES-which-other-design-it-reshapes + §sibling-pattern to cycle 265's CLAUDE.md spec's `Supersedes` metadata field + §the-reshape-relationship-IS-a-different-named-relationship-shape-(softer-than-supersedes)**.

§Three-named-cross-design-relationship-shapes-now:
1. **`Source`** (cycle 265's CLAUDE.md + cycle 279's instance) — extracted from.
2. **`Supersedes`** (cycle 265's CLAUDE.md) — replacement.
3. **`Reshape sibling for`** (cycle 279) — softer reshape relationship.

§First-explicit-observation in library: **§three-named-cross-design-relationship-shapes (Source + Supersedes + Reshape-sibling-for) — §the-cluster's-cross-design-vocabulary-has-three-named-relationships**.

## §"Why a single new method, not a `readText` + `writeText` pair"

Line 945 carries §a-Why-X-not-Y-subsection-as-named-rationale-shape.

§First-explicit-observation in library: **§the-`### Why <X>, not <Y>`-subsection-as-named-comparative-rationale — §the-design-NAMES-the-alternative + §the-design-NAMES-why-the-alternative-IS-rejected + §sibling-pattern to cycle 269's "X over Y because Z" but as a dedicated subsection**.

## §Cycle 279 first-explicit-observations roundup (twelve)

1. **§the-Proposed-Status-named-explicitly-as-a-Status-instance** — first Proposed design ingested.
2. **§the-Source-metadata-field-instantiated-with-PR-inline-review-comment-anchor** — three-anchor citation shape.
3. **§the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected**.
4. **§two-surfaces-in-priority-order-named-explicitly** (primary daemon API + secondary CLI wrapper).
5. **§two-named-design-shapes-for-multi-surface-features** (co-equal-halves + primary-and-secondary-surfaces).
6. **§named-prior-art-attribution-with-named-originator-and-three-named-adopting-projects** (hashline + oh-my-pi + opencode-hashline + hive).
7. **§the-dual-purpose-anchor** (location identifier + staleness check).
8. **§the-`<line-number>#<hash> <content>`-display-format-as-named-hashline-display-shape**.
9. **§the-Investigate-dependencies-we-can-imitate-or-rely-on-section-as-named-survey-discipline**.
10. **§two-named-Phase-prefixed-headings-grouping-numbered-phases** (Phase-by-goal grouping).
11. **§the-Alternative-formats-considered-section-as-named-rejection-record** — four numbered alternatives with rationales.
12. **§two-named-Open-Questions-sections-with-distinct-temporal-markers** — original + surfaced-by-builder-dispatch.

Plus: §the-maintainer-confirmation-pending-marker-as-named-tentativeness-discipline + §the-`## Reshape sibling for`-section-as-named-cross-design-reshape-relationship + §three-named-cross-design-relationship-shapes (Source + Supersedes + Reshape-sibling-for) + §the-`### Why <X>, not <Y>`-subsection-as-named-comparative-rationale + §four-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned + Edge-Cases + Open-Questions-evolution-log).

## §Recurring meta-pattern counters bumped at cycle 279

- §**three-cycles-with-named-prior-art-attribution-with-named-related-project** (273 Muddle + 277 Muddle-Roam + 279 hashline-cluster).
- §**two-cycles-with-named-evolution-of-rationale-within-a-design-document** (269 + 279).
- §**two-named-design-shapes-for-multi-surface-features** (co-equal-halves cycle 269 + primary-and-secondary-surfaces cycle 279).
- §**two-named-design-shapes-for-comparative-decisions** (inline-Design-Decisions-list + dedicated-Alternative-X-considered-section).
- §**two-cycles-with-named-tentativeness-marker** (272 + 279).
- §**three-named-cross-design-relationship-shapes** (Source + Supersedes + Reshape-sibling-for).
- §**four-named-rationale-sections-in-design-documents** (Design-Decisions + Lessons-Learned + Edge-Cases + Open-Questions-evolution-log).
- §**twenty-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (cycle 277's count + cycle 279).
- §**one-hundred-and-twelfth consecutive designs-chat alternation cycles 166-250 + 252-279** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-`edit`-verb's-disciplines apply to the §game-engine-cluster:

- §**§game-engine-edit-verb** with two surfaces in priority order: primary daemon API (`E(guest).editGameState(...)`) + secondary CLI wrapper (`game edit ...`).
- §**§the-dual-purpose-anchor** for game-state-edits — content-hash anchor IS both location identifier and staleness check.
- §**§the-`<line-number>#<hash> <content>`-display-format** for game-state-read.
- §**§the-Investigate-dependencies-we-can-imitate-or-rely-on-section** — survey existing game-edit libraries.
- §**§Phase-prefixed headings** grouping game-engine-implementation phases by named goal.
- §**§the-Alternative-formats-considered-section** for game-state-patch formats.
- §**§two named Open Questions sections** with temporal markers (original + surfaced-by-builder-dispatch).
- §**§the-`### Why <X>, not <Y>`-subsection** for comparative game-rule rationale.

## §Tier-1 borrowing

§the-Proposed-Status-named-explicitly-as-a-Status-instance + §the-Source-metadata-field-instantiated-with-PR-inline-review-comment-anchor + §the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected + §two-surfaces-in-priority-order-named-explicitly + §two-named-design-shapes-for-multi-surface-features + §named-prior-art-attribution-with-named-originator-and-three-named-adopting-projects + §the-dual-purpose-anchor + §the-`<line-number>#<hash> <content>`-display-format + §the-Investigate-dependencies-section + §two-named-Phase-prefixed-headings-grouping-numbered-phases + §the-Alternative-formats-considered-section + §two-named-Open-Questions-sections-with-distinct-temporal-markers.

## §Tier-2 borrowing

§the-maintainer-confirmation-pending-marker + §the-`## Reshape sibling for`-section + §three-named-cross-design-relationship-shapes + §the-`### Why <X>, not <Y>`-subsection + §four-named-rationale-sections-in-design-documents.

## §Tier-3 borrowing

§three-cycles-with-named-prior-art-attribution-with-named-related-project (273 + 277 + 279) + §two-cycles-with-named-evolution-of-rationale-within-a-design-document (269 + 279) + §two-cycles-with-named-tentativeness-marker (272 + 279) + §two-named-design-shapes-for-multi-surface-features + §two-named-design-shapes-for-comparative-decisions + §twenty-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §library-reaches-785-sections at cycle 279 + §one-hundred-and-twelfth consecutive designs-chat alternation cycles 166-250 + 252-279.

## Pattern summary (tag-prefixed)

§the-Proposed-Status-named-explicitly + §the-Source-metadata-field-instantiated (three-anchor citation: PR # + discussion ID + line-anchor) + §the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected + §two-surfaces-in-priority-order (primary daemon API + secondary CLI wrapper) + §two-named-design-shapes-for-multi-surface-features (co-equal-halves + primary-and-secondary-surfaces) + §named-prior-art-attribution-with-named-originator-and-three-named-adopting-projects (hashline + oh-my-pi + opencode-hashline + hive) + §three-cycles-with-named-prior-art-attribution (273 + 277 + 279) + §the-dual-purpose-anchor (location + staleness check) + §the-`<line-number>#<hash> <content>`-display-format + §the-Investigate-dependencies-we-can-imitate-or-rely-on-section + §two-named-Phase-prefixed-headings-grouping-numbered-phases + §the-Alternative-formats-considered-section + §two-named-design-shapes-for-comparative-decisions + §two-named-Open-Questions-sections + §four-named-rationale-sections-in-design-documents (Design-Decisions + Lessons-Learned + Edge-Cases + Open-Questions-evolution-log) + §the-maintainer-confirmation-pending-marker + §the-`## Reshape sibling for`-section + §three-named-cross-design-relationship-shapes (Source + Supersedes + Reshape-sibling-for) + §the-`### Why <X>, not <Y>`-subsection.
