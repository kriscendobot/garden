---
title: "Pattern: scheme-aware tokens with intentional exceptions"
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state
---

The design is a worked example of the **scheme-aware tokens with intentional exceptions** discipline:

- *Default policy*: every hardcoded color outside `:root` is replaced with a `var(--*)` that varies by scheme.
- *Intentional exceptions*: elements rendered on saturated `--accent-primary` backgrounds (sent-message bubbles, active-conversation rows) keep hardcoded `white`/`rgba(255,255,255,...)` because they are designed against the accent, not against the page background. The exception is recorded inline in the design and re-asserted in [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]].

The discipline keeps `index.css` searchable: any hardcoded color that survived the migration is documented as an intentional exception, so a future audit can grep for hex literals and treat each survivor as either a regression or a documented exception. See [[sentinel-with-rationale]] for the parallel pattern in other parts of the system.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
