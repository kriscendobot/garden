---
title: Flanking-delimiter-run rules
source: designs/chat-markdown-render.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5e6dbb533c9b9853c681588541362dbdda3a91c6
source_date: 2026-03-27
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
topics: [chat-ui]
status: current
parent: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules
---

The scanner classifies each delimiter run by left-flanking / right-flanking flags, computed from the characters immediately before and after the run:

- **Left-flanking** — the run is not followed by Unicode whitespace, and either (a) is not followed by punctuation, or (b) is preceded by Unicode whitespace or punctuation.
- **Right-flanking** — the run is not preceded by Unicode whitespace, and either (a) is not preceded by punctuation, or (b) is followed by Unicode whitespace or punctuation.

These two flags determine which runs may *open* an emphasis pair and which may *close* it. A left-flanking run may open; a right-flanking run may close; a run that is both may do either, subject to the intraword restriction below.

### Intraword-`_` restriction

A run of `_` characters that is both left-flanking and right-flanking cannot open *or* close emphasis. This is what prevents `foo_bar_baz` from emphasizing `bar`: each `_` is flanked on both sides by non-whitespace non-punctuation, so it cannot open or close. The same input with `*` (`foo*bar*baz`) *does* trigger emphasis, because `*` has no equivalent intraword restriction. The asymmetry is intentional in CommonMark: code identifiers commonly contain underscores; prose emphasis commonly uses asterisks.

### Placeholder classification

The chat parser sees a `` Private Use Area character at every chip slot. The flanking-rule logic classifies `` as a regular character — non-whitespace and non-punctuation — so a delimiter run adjacent to a placeholder behaves as if it were adjacent to a letter. This lets users write `**@alice**` to bold a name chip and have it work, and prevents `*foo*` from misclassifying as right-flanking.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
