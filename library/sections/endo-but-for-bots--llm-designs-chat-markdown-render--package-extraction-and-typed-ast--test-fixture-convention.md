---
title: Test fixture convention
source: designs/chat-markdown-render.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5e6dbb533c9b9853c681588541362dbdda3a91c6
source_date: 2026-03-27
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast
---

Each fixture is a pair sharing a basename: `test/fixtures/md/<name>.md` and `test/fixtures/html/<name>.html`. The test runner reads every `.md` file in `fixtures/md/`, parses it with `parseBlocks`, renders the resulting AST to a DOM fragment via `renderBlocks` (using `happy-dom`), serializes the fragment to HTML with `fragment.innerHTML` (or equivalent), and compares the result against the corresponding `.html` file.

This produces a **language-agnostic fixture set**: the `.md` and `.html` files are plain text, trivially reviewable in any editor or diff tool, and could be reused to validate an alternative implementation. The `.html` files contain the expected output exactly as produced by `happy-dom` serialization (including attribute order and whitespace), so they can be regenerated with a `--update` flag when the renderer changes intentionally.

The initial fixture set covers `emphasis`, `bold`, `code-spans`, `code-fences`, `headings`, `lists`, `nested-lists`, `tables`, `links`, `blockquotes`, `horizontal-rules`, `escapes`, `nesting`, `boundaries`, and `mixed` — fifteen pairs that together exercise the full grammar.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
