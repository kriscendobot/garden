---
title: Why this design exists separately
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
notes: **Status: Complete** upstream. Depends on `chat-color-schemes.md` (the parent design that introduces light + dark schemes) and `chat-high-contrast-mode.md` (for the high-contrast variants); neither parent ingested yet. Extends the `scheme` field on `SpaceConfig` first referenced by [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] but not detailed there.
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application
---

The parent design `chat-color-schemes.md` introduces the schemes
themselves (light + dark, driven by media query); this design adds
the **per-space override mechanism** on top. The split keeps the
*what is a dark scheme* question separate from the *who decides
which scheme applies* question:

- *What* — `chat-color-schemes.md` (not yet ingested).
- *Who* — this design.

The high-contrast variants from `chat-high-contrast-mode.md` (also
not yet ingested) integrate via the same `data-scheme` mechanism:
the variant names become two more attribute values; no further
machinery is needed.
