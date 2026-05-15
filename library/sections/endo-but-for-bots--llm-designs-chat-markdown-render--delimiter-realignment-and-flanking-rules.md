---
title: Delimiter realignment to CommonMark and the flanking-delimiter scanner
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
---

> Abstract: The inline-parser rewrite replaces the regex-per-delimiter approach in `parseInline` with a single left-to-right state-machine scanner that enforces CommonMark's flanking-delimiter-run rules. Delimiter semantics realign fully with CommonMark: `*text*` / `_text_` = italic, `**text**` / `__text__` = bold, `~text~` / `~~text~~` = strikethrough (GFM), `` `text` `` = inline code. Underline (`<u>`) drops entirely (no standard CommonMark delimiter for it); `/slash/` italic retires (too many URL false positives). The `_`-vs-`*` intraword distinction is preserved: `foo_bar_baz` does *not* trigger emphasis (CommonMark's intraword-underscore restriction), but `foo*bar*baz` *does* (no equivalent restriction on `*`). The `` Private Use Area placeholder character used for chip slots is classified as a regular character (non-whitespace, non-punctuation) for boundary purposes, so placeholder-adjacent emphasis behaves predictably.

## The state-machine scanner

The current `parseInline` runs each delimiter's regex independently, which cannot express double-delimiter recognition, nesting, escape sequences, or boundary rules without quadratic-or-worse regex contortion. The rewrite is a single-pass left-to-right scanner that produces a token stream and then assembles nested `Token` trees from it. `renderInlineTokens` recurses on the tree.

The scanner's per-character work:

1. Read the next character. If it is a backslash, consume the following character as a literal (escape-sequence handling, Gap 6).
2. If it is a backtick, count the run length N. Scan forward for the next run of exactly N backticks. If found, emit a code-span token. If not, emit the backticks as literal text.
3. If it is a delimiter character (`*`, `_`, `~`), accumulate the delimiter run and record its flanking-flags (see below). Push onto a delimiter stack for later matching.
4. Otherwise emit a literal-text token.

After the scan completes, walk the delimiter stack left-to-right pairing left-flanking openers with right-flanking closers, producing nested emphasis / strong tokens. The stack-walk is the part that handles inline nesting (Gap 8): nested `<strong>` containing `<em>` falls out of pairing same-character runs in stack order.

## Flanking-delimiter-run rules

The scanner classifies each delimiter run by left-flanking / right-flanking flags, computed from the characters immediately before and after the run:

- **Left-flanking** — the run is not followed by Unicode whitespace, and either (a) is not followed by punctuation, or (b) is preceded by Unicode whitespace or punctuation.
- **Right-flanking** — the run is not preceded by Unicode whitespace, and either (a) is not preceded by punctuation, or (b) is followed by Unicode whitespace or punctuation.

These two flags determine which runs may *open* an emphasis pair and which may *close* it. A left-flanking run may open; a right-flanking run may close; a run that is both may do either, subject to the intraword restriction below.

### Intraword-`_` restriction

A run of `_` characters that is both left-flanking and right-flanking cannot open *or* close emphasis. This is what prevents `foo_bar_baz` from emphasizing `bar`: each `_` is flanked on both sides by non-whitespace non-punctuation, so it cannot open or close. The same input with `*` (`foo*bar*baz`) *does* trigger emphasis, because `*` has no equivalent intraword restriction. The asymmetry is intentional in CommonMark: code identifiers commonly contain underscores; prose emphasis commonly uses asterisks.

### Placeholder classification

The chat parser sees a `` Private Use Area character at every chip slot. The flanking-rule logic classifies `` as a regular character — non-whitespace and non-punctuation — so a delimiter run adjacent to a placeholder behaves as if it were adjacent to a letter. This lets users write `**@alice**` to bold a name chip and have it work, and prevents `*foo*` from misclassifying as right-flanking.

## Multi-backtick code spans

CommonMark §6.1 lets an inline code span be opened by a run of N backticks and closed by a matching run of exactly N. The state-machine scanner already counts run length when it encounters a backtick; the only additional work is the forward scan for an N-run closer and the content-stripping rule:

- ` `` code with `backtick` `` ` — double-backtick span contains a literal single backtick.
- ` ``` code with `` two `` ``` ` — triple-backtick span contains literal double backticks.

Leading and trailing single spaces are stripped if the content is not entirely spaces, so `` ` ` `` produces a literal backtick.

No further inline parsing happens inside code spans — no bold, no italic, no placeholder detection.

## N-character code fences

The block parser detects fence openers with `/^(`{3,}|~{3,})(\w*)$/`. The fence character (backtick or tilde) and the run length N are recorded. The fence closes when a line starts with at least N of the same character and nothing else follows. This handles the case where a code-fenced block needs to contain a literal ` ``` ` — open with ` ```` ` (four backticks), embed ` ``` ` as content, close with ` ```` ` or more.

## Escape sequences

Backslash escapes (Gap 6) let users emit literal `*`, `_`, `` ` ``, `[`, and `\` characters. The scanner consumes `\X` as a literal `X` for any of those metacharacters; other backslash sequences pass through as `\X`.

## Translation

| Paper / CommonMark term | Endo-side surface |
|---|---|
| flanking delimiter run | left-flanking / right-flanking flags computed per-run by the scanner |
| delimiter stack | the LIFO stack of open delimiter runs waiting to be paired with a closer |
| intraword-underscore restriction | CommonMark §6.4: a left-and-right-flanking `_` run cannot open or close emphasis |
| Private Use Area character | ``, the chip-slot marker; classified as a regular non-whitespace non-punctuation character by the scanner |

## Implications for Endo

The flanking-rule + delimiter-stack design is *the* lingua franca for inline parsers across the Markdown ecosystem (CommonMark reference, `markdown-it`, `remark`, `pulldown-cmark`). Endo's `@endo/markmdown` adopts the same shape rather than rolling a new approach, which means future contributors who already know CommonMark internals can read the scanner without translation.

The placeholder-as-regular-character classification is a small but important decision: it lets the chat layer's chip mechanism compose with the parser without either side knowing about the other. The chat layer marks chip slots before the parser runs and walks the parsed DOM afterward; the parser sees only the runes and treats them like any other letter. This is the parser equivalent of *consumers own rendering, producers own typed shape* — the chip semantics are the *consumer's* concern, and the parser owns the typed shape (the AST) that the consumer post-processes.

## Common confusions

- *"`\n` is a hard break in CommonMark"* — no. CommonMark renders paragraph-internal `\n` as a space (soft break); hard breaks require two trailing spaces or a backslash before the newline. The chat parser treats every `\n` as `<br>` (hard break), which is a deliberate, documented divergence preserved by the redesign (Gap 13, "Keep as-is").
- *"strikethrough is in CommonMark"* — no. Strikethrough (`~text~`, `~~text~~`) is a GFM extension on top of CommonMark. The chat parser already supported `~text~`; the redesign keeps it and adds `~~text~~`.

## See also

- [endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis.md) — the 14-gap table and current vs CommonMark delimiter mapping.
- [endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) — why the typed AST shape stays in `@endo/markmdown` while the DOM rendering is consumer-owned.
- [endo-but-for-bots--llm-designs-chat-components--inventory-and-messages](endo-but-for-bots--llm-designs-chat-components--inventory-and-messages.md) — the package-message kind whose body is rendered through the markdown pipeline.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
