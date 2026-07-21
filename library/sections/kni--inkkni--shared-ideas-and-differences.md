---
title: Shared ideas with Ink, and where kni diverges
source: INKKNI.md
source_repo: kriskowal/kni
source_commit: 3a62b89ee1cedf495d841c351d6149857a919665
source_date: 2026-01-02
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

Abstract: kni is an homage to Inkle's Ink and shares its core ideas — pithy question/answer option notation (`*` show-once, `+` show-forever, `* []` fall-through), `{curly|brace}` meta-narrative, the divert/goto arrow `->`, thread collection after nested option groups, and a JSON artifact separating parser from runtime. This section captures those commonalities and the mechanical divergences: kni is pure JavaScript (runs in browser or server), is significant-whitespace (one bullet per line; parentage inferred from indentation), requires an explicit `>` prompt (the inference experiment failed against conditional/looping/collecting threads), uses fully-qualified `@label` notation with no `=== title ===` inference, and differs in variable/list/conditional notation (`{(variable)}` to print, `{(condition)?then|else}` conditionals, condition-and-consequence option prefixes). Provenance context for readers who know Ink.

kni is an homage, inspired by Inkle's Ink. The languages share several key ideas: pithy question/answer notation for option narrative (including `*` show-once options, `+` show-forever options, and `* []` fall-through when options are exhausted); `{curly|braces|delimited|by|pipes}` for meta-narrative; the divert/goto arrow `->`; collection of narrative threads after nested option groups; and generation of a JSON artifact that separates parser from runtime.

Despite the similarities, kni differs from Ink in many ways:

- kni is entirely implemented in **JavaScript**, so every part runs in the browser or on a server.
- kni is a **significant-whitespace** language: threads need only one bullet per line, and parentage and children are inferred from indentation.
- kni does not have the `<>` line-join operator; instead lines may wrap, and an express solidus `/` (or double `//`) marks line/paragraph breaks.
- kni does not have `=== title ===` notation and does not infer a `title.` prefix for `= subtitle`. kni only has `@label` notation, which must state the fully-qualified label.
- kni **requires explicit prompting** with `>`. Early versions experimented with inferring the prompt location, but the inference did not play well with conditional threads that collect options, loops, or variable changes, nor with subroutines that collect options. (Ink appears to require all options on the same level and supports conditions directly on options, which likely accounts for its implicit end-of-list prompting.)
- kni's `{variable|text}` is similar but not identical to Ink's: printing a variable uses `{(variable)}` (not `{variable}`); once-only lists leave the final variant empty (`{a|b|c|}`) rather than a special marker; conditionals are `{(condition)?then|else}` rather than `{condition: then}` and work with comparison operators; and kni adds variable-backed lists `{(expression)|a|b|c}`, loops `{@expression|a|b|c}`, and hash-based arbitrary choices `{#expression|a|b|c}`.
- kni's conditional-option notation differs slightly (`+ {seen.clue} Accuse Mr.\ Jefferson.`) and adds condition-and-consequence prefixes (`{-arrow}` guards on and consumes an arrow) and pure consequence prefixes (`{+3arrow}`).
- kni has `!`-bulleted assignment blocks (currently assignment-only) and inline `{+gold}` / `{=10 hearts}` state mutation.
- The compiled JSON and the virtual machine that runs it are entirely different from Ink's.

Source: [INKKNI.md](https://github.com/kriskowal/kni/blob/3a62b89ee1cedf495d841c351d6149857a919665/INKKNI.md) at commit `3a62b89e`.
