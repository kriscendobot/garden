---
ts: 2026-05-22T23:11:00Z
kind: result
role: fixer
worktree: dispatches/fixer--44237b/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/231300Z-dispatch-general-contractor-44237b.md
---

# Result: fixer on PR #324 (test/familiar-primer-cas-smoke)

## Task

PR #324's two daemon-spawning tests (host can checkin the bundled primer;
sub-guest receives the primer via storeIdentifier) failed `cover` jobs in CI
with `ENOENT: no such file or directory, access '.../endo.sock'`.
Root cause: the assembled sockPath on CI was
`/home/runner/work/endo-but-for-bots/endo-but-for-bots/packages/lal/tmp/primer-cas-<label>-<counter>/endo.sock`
which is 110 chars, over the Linux UNIX-domain-socket cap (~107).
The daemon could neither bind nor write the socket file, so the client's
`access()` in `makeEndoClient` raised ENOENT.

## Fix shape

Applied the canonical sockPath-shortening pattern from
`packages/daemon/test/gateway.test.js`:

- Introduced `MAX_UNIX_SOCKET_PATH = 90`.
- Computed `SOCKET_PATH_OVERHEAD = tmpRoot.length + 1 + 'endo.sock'.length + 1 + 8`
  (the `+ 8` headroom matches gateway.test.js).
- Derived `MAX_CONFIG_DIR_LENGTH = max(8, MAX_UNIX_SOCKET_PATH - SOCKET_PATH_OVERHEAD)`.
- In `makeConfig(label)`, sanitize the label, truncate to
  `MAX_CONFIG_DIR_LENGTH`, then append `#<counter>` as a disambiguator so
  distinct calls always produce distinct paths even when truncated labels
  would collide.

On CI: tmpRoot is 70 chars, MAX_CONFIG_DIR_LENGTH resolves to 8, and the
full socket path becomes 94 chars (e.g. `.../tmp/host-che#0001/endo.sock`).

Prettier auto-fixed one local-formatting nit before commit. No other lint
or typecheck signals were reachable without a full `yarn install`, which
was skipped given the bounded dispatch.

## Commit and push

- Branch: `test/familiar-primer-cas-smoke`
- SHA: `3787a905b0610a17ec64532bab360e3dbd8e5546`
- Title: `fix(lal): shorten sockPath in primer-cas-smoke to fit Linux 107-char cap`
- Push: succeeded; GitHub's dependabot vuln banner is unrelated noise.

## CI status

A fresh workflow run (id 26316337952 / 26316337935 / 26316337976) launched
on push. As of this entry, all jobs are `pending`. The previously failing
`cover (20.x, ubuntu-latest)` and `cover (24.x, ubuntu-latest)` jobs are
in this run. Watching them to completion is left to the
orchestrator's per-cycle scan; the fix is targeted at the exact failure
mode their logs surfaced and a local path-length simulation confirms the
new paths fit under 107 chars.

No top-level summary comment posted; the dispatch did not include an
external-repo action authorization, and this is a draft PR continuing
through the gamut.

## Out-of-scope items

None. The fix is local to one test file, touches no production code, and
preserves the previous behavior in every non-truncation case.

Self-improvement: the lal package CLAUDE.md could carry a one-liner
pointing future daemon-spawning lal tests at `gateway.test.js`'s
sockPath-shortening pattern; the same trap caught a smoke test that did
not know the canonical mitigation existed. Routing as a `message` to the
liaison rather than a daemon-side change since lal's tests are the ones
that need to know.
