---
title: §Use-Cases section (five named OAuth targets)
source-slug: endo-but-for-bots--llm-designs-endoclaw-oauth
section-id: the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-oauth.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-oauth.md
total-lines: 99
status: Not Started (Parent: endoclaw)
ingest-cycle: 234
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
---

```
- Gmail: read emails, draft responses, label messages
- Google Calendar: read events, create events
- Notion: read/write pages and databases
- Todoist: read/create tasks
- Any OAuth2-compatible API
```

§Five-named-use-cases with §per-use-case-named-operations (read/draft/label for Gmail; read/create for Calendar; etc.). §The-fifth-use-case is the §general-pattern (Any OAuth2-compatible API).

§Borrowable-pattern: §enumerate-concrete-use-cases-and-then-generalize. §The-specific-examples-tell-the-reader-what-the-design-supports; §the-general-case-tells-the-reader-the-shape.
