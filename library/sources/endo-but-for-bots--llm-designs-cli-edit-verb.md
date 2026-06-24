---
title: "cli-edit-verb.md — the `edit` verb: hash-anchored line-based patches for AI agents"
source-slug: endo-but-for-bots--llm-designs-cli-edit-verb
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-edit-verb.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-edit-verb.md
total-lines: 1394
ingest-cycle: 279
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `cli-edit-verb.md`

A 1394-line design — the largest design-doc in the cluster ingested and **the first `Proposed` Status observed**. Source field cites a PR inline review comment with three-level anchor citation.

## Key moves

- **§The Proposed Status named explicitly as a Status instance** — first Proposed design ingested.
- **§The Source metadata field instantiated with PR inline review comment anchor** — three-anchor citation shape (PR # + discussion ID + line-anchor on sibling design).
- **§The design acknowledges a prior framing was wrong and IS corrected** — *"The original framing of this design positioned `endo edit` as the primary surface. Maintainer review on PR #162 corrected that framing"*.
- **§Two surfaces in priority order named explicitly** — primary (`E(guest).edit(...)` daemon API) + secondary (`endo edit ...` CLI wrapper).
- **§Two named design shapes for multi-surface features** — co-equal-halves (cycle 269) + primary-and-secondary-surfaces (cycle 279).
- **§Named prior-art attribution with named originator and three named adopting projects** — hashline + oh-my-pi (originator) + opencode-hashline + hive + (and others).
- **§The dual-purpose anchor** — location identifier + staleness check; the content hash IS both WHERE the line IS + WHETHER it has changed.
- **§The `<line-number>#<hash> <content>` display format** as named hashline display shape.
- **§The Investigate dependencies we can imitate or rely on section** as named survey discipline.
- **§Two named Phase-prefixed headings grouping numbered phases** — Phase-by-goal grouping (`## Phase: daemon-side ...` containing Phase 1-3 + `## Phase: multi-file ...` containing Phase 4).
- **§The Alternative formats considered section as named rejection record** — four numbered alternatives (unified diff + search-and-replace blocks + JSON Patch + do-nothing) with rationales.
- **§Two named design shapes for comparative decisions** — inline-Design-Decisions-list (cycle 269) + dedicated-Alternative-X-considered-section (cycle 279).
- **§Two named Open Questions sections with distinct temporal markers** — original + Resolved + Open-Questions-surfaced-by-builder-dispatch (three-section shape).
- **§Four named rationale sections in design documents** — Design-Decisions + Lessons-Learned + Edge-Cases + Open-Questions-evolution-log.
- **§The maintainer-confirmation-pending marker** — *"tentative pending kriskowal confirmation"*.
- **§The `## Reshape sibling for` section** as named cross-design reshape relationship.
- **§Three named cross-design relationship shapes** — Source + Supersedes + Reshape-sibling-for.
- **§The `### Why <X>, not <Y>` subsection** as named comparative rationale.

## Section files

- [§First Proposed status + §Source metadata field instantiated + §original framing corrected + §two surfaces in priority order + §the Alternatives considered section + §two named Open Questions sections](../sections/endo-but-for-bots--llm-designs-cli-edit-verb--first-Proposed-status-and-Source-metadata-field-instantiated-and-original-framing-corrected-and-two-surfaces-in-priority-order-and-the-Alternatives-considered-section-and-two-named-Open-Questions-sections.md) — structural pattern observations (1394-line file ingested in pattern-scope).

## Ingest scope

Cycle 279 (designs-lane after cycle 278's chat-lane zip-signature). 1394-line file ingested in pattern-scope. **First-explicit-observations (twelve plus secondary)**: the-Proposed-Status-named-explicitly + the-Source-metadata-field-instantiated + the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected + two-surfaces-in-priority-order-named-explicitly + two-named-design-shapes-for-multi-surface-features + named-prior-art-attribution-with-named-originator-and-three-named-adopting-projects + the-dual-purpose-anchor + the-`<line-number>#<hash> <content>`-display-format + the-Investigate-dependencies-section + two-named-Phase-prefixed-headings-grouping-numbered-phases + the-Alternative-formats-considered-section + two-named-Open-Questions-sections-with-distinct-temporal-markers. Plus: the-maintainer-confirmation-pending-marker + the-`## Reshape sibling for`-section + three-named-cross-design-relationship-shapes + the-`### Why <X>, not <Y>`-subsection + four-named-rationale-sections-in-design-documents.
