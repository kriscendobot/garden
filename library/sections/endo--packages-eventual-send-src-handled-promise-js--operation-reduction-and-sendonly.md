---
title: Operation reduction in dispatchToHandler — SendOnly substitution, applyMethod via get+applyFunction, and the minimal handler surface
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "122-194"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "How dispatchToHandler reduces the six-operation API to a three-method minimum, and why SendOnly is a wrapper around the corresponding non-SendOnly operation"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, captp]
status: current
kind: index
section_count: 5
---

Sections:

- [Abstract](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly--abstract.md)
- [Body](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly--body.md)
- [Implications](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly--implications.md)
- [Translation](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly--translation.md)
- [See also](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly--see-also.md)

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
