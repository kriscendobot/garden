---
title: Safe promises versus passable promises and the reentrancy attack the distinction defends against
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "369-401"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "isSafePromise: the safety predicate, its relationship to marshal's passable-promise classification, and the residual reentrancy gap the check cannot close"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, capability-security, marshal]
status: current
kind: index
section_count: 5
---

Sections:

- [Abstract](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise--abstract.md)
- [Body](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise--body.md)
- [Implications](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise--implications.md)
- [Common confusions](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise--common-confusions.md)
- [See also](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise--see-also.md)

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
