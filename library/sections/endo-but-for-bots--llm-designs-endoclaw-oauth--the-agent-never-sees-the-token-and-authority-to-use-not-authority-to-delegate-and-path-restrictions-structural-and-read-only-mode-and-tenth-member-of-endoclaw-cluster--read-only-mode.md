---
title: §Read-only-mode
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

```ts
setReadOnly(flag: boolean): void;  // restricts to GET/HEAD
```

§A-boolean-mode-toggle that restricts the HTTP method allow-list to GET and HEAD. §Borrowable-pattern: §a-boolean-mode-flag-with-named-restriction-class — the §named-restriction-class is §HTTP-safe-methods (GET + HEAD).

§The-agent-can-read-emails-but-not-send-them, §read-calendar-events-but-not-create-them. §Borrowable-pattern: §when-the-host-grants-a-credential-for-read-use, §a-boolean-toggle-prevents-write-side-effects.

§Sibling to cycle 226 endoclaw-browser's §BrowserControl.setReadOnly(true) (disables fill/click/submit). §Two-cycles-with-the-setReadOnly-mode-toggle.
