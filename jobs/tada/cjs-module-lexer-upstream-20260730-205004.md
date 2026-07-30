## Upstream inspection: nodejs/cjs-module-lexer

**Job:** cjs-module-lexer-upstream-20260730-205004
**Issue:** https://github.com/kriskowal/garden/issues/55 (Tracking upstream cjs-module-lexer)

### What I did
- Cloned a bare copy of `nodejs/cjs-module-lexer` from GitHub and inspected its `main` branch for new commits since the `2.2.0` release.
- Cross-checked the GitHub Releases and Tags APIs to confirm no newer tags, pre-releases, or drafts exist.

### Result: no new commits since 2.2.0
- Latest tag/release: **2.2.0** — published 2026-01-02, commit `cb772fa` ("2.2.0", Guy Bedford).
- `main` HEAD is exactly the `2.2.0` tag (`cb772facaab04a64deced6161b5c0efec683189f`); `git log 2.2.0..main` is empty.
- No newer tags, pre-releases, or draft releases (three most recent releases: 2.2.0, 2.1.1, 2.1.0).
- Last code change before 2.2.0: `3ed4537` ("feat: remove use of eval by doing our own string parsing", nodejs/cjs-module-lexer#118), already included in 2.2.0.

### What changed
- Posted a comment reporting the result on https://github.com/kriskowal/garden/issues/55 (kriscendobot/garden#55 — the API-resolved canonical repo).
- Notified the maintainer via the message bus.

### Follow-ups
- None. The issue was left open per instructions; no upstream issues or PRs were opened or modified.
- Next scheduled upstream check should re-run this inspection to catch any post-2.2.0 commits.
