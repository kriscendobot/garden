---
title: Caution
source: packages/memoize/docs/memoize.md
source_repo: endojs/endo
source_commit: 2df33f43ef398fd98201a08e4b939302c13939fe
source_date: 2026-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

> Abstract: Closing caveat: memoize is a sharp tool. The safe patterns cover common cases; novel use-cases need careful security analysis. When in doubt, prefer explicit caches.

## Caution

We do not currently have the tooling to check or enforce the above requirements.
That's why we phrase this as *contingent safety*. The `memoize` function
only guarantees this if-then safety property, but it cannot tell if the
condition part was satisfied. When it is not, the guarantees do not follow.

Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
