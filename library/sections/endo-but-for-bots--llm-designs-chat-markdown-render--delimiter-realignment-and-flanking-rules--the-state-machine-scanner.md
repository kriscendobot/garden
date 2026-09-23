---
title: The state-machine scanner
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

The current `parseInline` runs each delimiter's regex independently, which cannot express double-delimiter recognition, nesting, escape sequences, or boundary rules without quadratic-or-worse regex contortion. The rewrite is a single-pass left-to-right scanner that produces a token stream and then assembles nested `Token` trees from it. `renderInlineTokens` recurses on the tree.

The scanner's per-character work:

1. Read the next character. If it is a backslash, consume the following character as a literal (escape-sequence handling, Gap 6).
2. If it is a backtick, count the run length N. Scan forward for the next run of exactly N backticks. If found, emit a code-span token. If not, emit the backticks as literal text.
3. If it is a delimiter character (`*`, `_`, `~`), accumulate the delimiter run and record its flanking-flags (see below). Push onto a delimiter stack for later matching.
4. Otherwise emit a literal-text token.

After the scan completes, walk the delimiter stack left-to-right pairing left-flanking openers with right-flanking closers, producing nested emphasis / strong tokens. The stack-walk is the part that handles inline nesting (Gap 8): nested `<strong>` containing `<em>` falls out of pairing same-character runs in stack order.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
