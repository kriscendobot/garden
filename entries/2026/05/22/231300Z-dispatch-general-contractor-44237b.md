---
ts: 2026-05-22T23:13:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 324
    role: target
refs:
  - entries/2026/05/22/230521Z-result-cleaner-9f17b7.md
---

# Dispatch: fixer 44237b — sockPath fix on endo-but-for-bots#324 (lal primer-CAS smoke)

Dispatch root: `dispatches/fixer--44237b/`. Project worktree on `endojs/endo-but-for-bots@test/familiar-primer-cas-smoke`.

Cleaner-9f17b7 found PR #324's own new tests fail on CI: `cover (20.x, ubuntu-latest)` and `cover (24.x, ubuntu-latest)` both fail tests 3, 4 (daemon-spawning) with `ENOENT: ... endo.sock` from `runEndo` (`packages/daemon/index.js:385`). The cause: `sockPath` resolves to a 109-char absolute path on CI, exceeding Unix socket path limit. Tests 1, 2 (pure-filesystem) pass.

## Task

Apply the canonical sockPath-shortening pattern from `packages/daemon/test/gateway.test.js`:
- Use `MAX_UNIX_SOCKET_PATH` constant.
- Apply `getConfigDirectoryName` truncation.

Update `packages/lal/test/primer-cas-smoke.test.js` to follow the discipline; verify locally if possible (path will be runner-host-dependent); push to `test/familiar-primer-cas-smoke`; CI watch.

## Report

≤ 300 words at `/home/kris/dispatches/fixer--44237b/journal/entries/2026/05/22/<HHMMSS>Z-result-fixer-44237b.md`; commit+push.
