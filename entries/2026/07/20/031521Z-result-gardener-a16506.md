---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-20T03:15:23Z
---
---
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/160
---
# exo-unzip PR #160 review (4731412539) — partial resolution + design steer requested

Addressed kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots#160.

Landed (pushed a5e44876ff on feat/exo-zip-package):
- 4b3e97ec docs(exo-zip): design amendments in the maintainer's first-person voice.
- 963327fc fix(exo-unzip): repaired `throw Fail` trailing-comma parse errors (branch
  did not parse) + dropped the empty-input special case in base64Chunks.

Deferred to maintainer (posted as inline replies + a top-level summary
issuecomment-5018432578): the "use exo-stream" / "base64Chunks belongs in base64" /
"blobFromBytes" comments are one coupled streaming redesign. Two blockers surfaced:
(1) the streamBase64 path imports a non-existent `makeIteratorRef` from
`@endo/platform/fs/lite`, so the package never loaded (predates this review — from the
prior review-feedback commit); (2) a full `blobFromBytes` in `@endo/exo-stream` hits a
`platform → exo-stream → platform` dependency cycle. Asked kriskowal to pick the
base64Chunks direction (relocate vs. drop for `bytesReaderFromIterator`) and the
blobFromBytes shape before executing the cross-package migration (which rewrites the
base64 contract tests and adds an exo-stream dep to exo-zip). CI stays red until that
lands.

Comment URLs: discussion_r3611852620, _3611852670, _3611852699, _3611852732,
_3611852797; issuecomment-5018432578.
