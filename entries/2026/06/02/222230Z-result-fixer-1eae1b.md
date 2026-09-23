---
ts: 2026-06-02T22:22:30Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--1eae1b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - entries/2026/06/02/221403Z-dispatch-liaison-1eae1b.md
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/394#pullrequestreview-4413543939
  - https://github.com/endojs/endo-but-for-bots/pull/394#issuecomment-4607470548
---

# result: fixer #1eae1b — added git-CLI integration test to #394

Addressed kriskowal's CHANGES_REQUESTED review (`4413543939`) on PR
#394 by adding the integration test he asked for.

## What landed

One regular-append commit on `design/gateway-package-phase-6`:

- New head SHA: `b22e0db66`.
- Test file (new): `packages/gateway/test/git-http-integration.test.js`.
- One new ava test (`test.serial`), skipped when `git` or
  `git-http-backend` are not installed.

The test stands up an `http.createServer` on `127.0.0.1:0`, wires
`makeGitHttpHandler` to a `resolveRepo` that returns a capability
backed by the `git http-backend(1)` CGI binary serving an on-disk
bare repo, mints formula-id-shaped repo id and bearer token, and
drives the real `git` CLI through:

1. `git push` with a wrong bearer token (exercises the 401 path on
   the wire; asserts the client surfaces the rejection).
2. `git push main:main` with the right bearer (asserts success and
   the resolveRepo grant).
3. `git clone` from a fresh working tree into a sibling temp dir
   (the canonical pull round trip; asserts the file and commit
   message survive).

## Local test result

```
cd packages/gateway && npx corepack yarn ava test/git-http.test.js test/git-http-integration.test.js
→ 38 tests passed (37 existing + 1 new)

cd packages/gateway && npx corepack yarn ava
→ 275 tests passed (full package)
```

Lint:
- `yarn lint:eslint`: 0 errors (158 pre-existing warnings in other
  test files; none in the new file).
- `yarn lint:types`: passes (exit 0).

## Top-level PR comment

Posted as `https://github.com/endojs/endo-but-for-bots/pull/394#issuecomment-4607470548`
(id `4607470548`). The body cites the new test path, the addressing
SHA (b22e0db66), the auth-scheme rationale (see below), and the
skip-when-absent gate.

## Auth scheme exercised

**Bearer**, via `git -c http.extraHeader=Authorization: bearer
<token>`.

Both schemes are documented as accepted in `src/git-http.js` and
both have unit coverage in `git-http.test.js` (Bearer in the
`handleRequest forwards info/refs` and similar tests; Basic with
empty user in `handleRequest accepts Basic auth with empty user`).
The integration test picks Bearer because it is the more direct knob
from the git CLI:

- Bearer needs only an `http.extraHeader` config line; no credential
  helper, no `askpass`, no environment plumbing.
- Basic-with-empty-user would require either a `git-credential`
  helper script written to disk (more moving parts) or a magic-URL
  `http://:<token>@host/...` form (which leaks the token into
  `~/.git-credentials` and the process listing).

The handler-side dispatch is on the scheme keyword, not the byte
shape of the credentials (the `does not confuse Bearer hex with
Basic hex` unit test pins that invariant), so the integration test
does not need to cover both schemes end-to-end to be confident the
Basic path also works on the wire; the unit test already proves the
parser.

## Out of scope (intentionally not touched)

- The stack-wide `Uint8Array`-as-sole-wire-shape directive from
  kriskowal's #393 review: per dispatch brief, separate decision and
  separate dispatch.
- `src/git-http.js` and any non-test source: kriskowal asked for a
  test, not implementation changes.
- The base branch `design/gateway-package-phase-5` (#393).
- Un-draft / re-request review: this is a draft PR and the dispatch
  did not authorize either.

## Notes

- The integration test uses `test.serial.skip` rather than `test.skip`
  so the gate composes with the package convention from
  `project/CLAUDE.md` § Testing with AVA ("Gateway, daemon, and
  fork-based tests must be `test.serial`"). The `git http-backend`
  CGI spawn is heavyweight enough that running it in parallel with
  the other gateway tests' daemon-spawning patterns would risk
  filesystem contention.
- An incidental `yarn format` whitespace change in
  `packages/hex-test/package.json` was reverted before commit; that
  file is unrelated to the PR scope.
- Pre-push gates: format clean, lint:eslint clean (0 errors on new
  file), lint:types clean, ava clean. No yarn.lock churn so no
  separate `chore: Update yarn.lock` commit needed.

Self-improvement: nothing this time.
