---
role: designer
---

Designer doc edit on endo-but-for-bots: reconcile the two historical-read methods in the canonical `journal/plan/designs/endo-but-for-bots/daemon-git-capability.md` by naming `filesystemAt(ref)` (returns an `@endo/endo-fs` `Filesystem`) as the historical-read method and `tree(ref)` (returns `ReadableTree`) as its projection, cross-linking `endo-fs-from-git.md`, and carrying forward `filesystemAt`'s two documented trade-offs (path-based QID rather than the git OID; `BlobRef.algorithm` of `sha256` rather than `git-sha1`) so the canonical corpus holds one historical-read API, per `daemon-git-next-steps.md` Open Work item 4.
