---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §hostile-input-rejection-at-construction discipline
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

> *Empty path components and `.` / `..` segments are rejected
> at construction time so the resulting tree cannot escape
> the archive's namespace.*

The §fail-fast-at-construction discipline:

- Reject at `makeExoZip(zipBytes)` — the caller learns
  *immediately* that the archive is malformed.
- Not at `lookup` — caller might *never* look up the bad
  path; the rejection would be silently bypassed.

The §security-check-at-the-entry-point pattern. A path-
traversal vector (`'../../etc/passwd'` in a zip entry) is
caught *before* the tree exists, not buried in lookup logic.
