---
title: Markdown and Spelling Conventions
source: CONTRIBUTING.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [repository-governance]
status: current
notes: The Spelling section restates doc/design/style.md's pluralization rule; see cask--style--pluralization.
---

Abstract: CASK's contribution conventions, which are entirely about document hygiene (the project has no PR-process or commit-message rules in this file). **Markdown style**: wrap prose at approximately 80 columns and begin every sentence on a new line, so that a diff to one sentence does not cascade into rewrapping the rest of the paragraph (the worked example shows editing the second sentence touching neither the first nor the third). Avoid leaving honorifics (Dr., Mr., Mrs.) or abbreviations at the end of a line, since a period at a line break can be mistaken for a sentence end; break a too-long sentence at a natural clause boundary instead. Prefer Markdown tables over hand-aligned ASCII columns, and Mermaid diagram fences over ASCII art, because both render well on GitHub and are easier to maintain. **Spelling**: prefer regular English plurals over Latin or Greek forms (indexes not indices, matrixes not matrices, vertexes not vertices) because the regular plurals are more welcoming to an international developer community. (Note: the one-sentence-per-line wrap discipline is the project's own convention and is independent of the garden's own house-style rules.)

## Markdown style

We wrap prose at approximately 80 columns. Every sentence begins on a new line. This ensures that diffs remain clean: a change to one sentence does not cascade into rewrapping subsequent sentences in the same paragraph.

Avoid leaving punctuation like honorifics (Dr., Mr., Mrs.) or abbreviations at the end of a line, since a period at a line break can be mistaken for the end of a sentence. When a sentence is too long for a single line, break it at a natural clause boundary.

The worked contrast: in the one-sentence-per-line form, editing the second sentence does not touch the first or third. In the run-together form, inserting a word in the first sentence rewraps text into every subsequent line of the paragraph.

Prefer Markdown tables over hand-aligned ASCII columns, and Mermaid diagram fences over ASCII art. Both render well on GitHub and are easier to maintain than their plaintext equivalents.

## Spelling

Prefer regular English plurals over Latin or Greek forms: indexes (not indices), matrixes (not matrices), vertexes (not vertices), and so on. Both forms are valid, but the regular plurals are more welcoming to an international developer community.

Source: [CONTRIBUTING.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/CONTRIBUTING.md) at commit `cdb975d8`.
