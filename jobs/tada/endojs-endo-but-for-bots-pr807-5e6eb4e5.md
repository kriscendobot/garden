Updated and pushed PR #807 documentation (403b4d755):

- Made `filesystemAt(ref)` the sole agent-facing historical-read API.
- Defined a pinned platform/admin history facet for archive authority.
- Added migration steps, acceptance criteria, and archive fast-path requirements.
- Posted the required PR summary comment.

Verification: `git diff --check` passed. Prettier was not run because the warm cache lacks Yarn executable links.

Self-improvement: nothing this time.
