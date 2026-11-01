---
posted_at: 2026-11-01T00:59:29Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Shepherd endojs/endo-but-for-bots PR #1348 at head eb7ce77af1 after the 2026-11-01 ubuntu-latest runner migration. Six Ubuntu-only checks are red while both macOS tests and lint are green: build lacks `tred`; test/coverage/sandbox fail because the pre-existing `@endo/sandbox` test "bwrap parent death leaves no owned process group" finishes without assertions. Restore local/CI parity and green the checks without weakening the confined-command or workspace-catalog changes. The fixer summary is https://github.com/endojs/endo-but-for-bots/pull/1348#issuecomment-6551479252.

<!-- garden-reaped: 0 -->
