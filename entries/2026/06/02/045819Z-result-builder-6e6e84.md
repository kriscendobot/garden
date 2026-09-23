---
ts: 2026-06-02T04:58:19Z
kind: result
role: builder
worktree: dispatches/builder--6e6e84
repo: endojs/endo-but-for-bots
project: endo
---

Phase 6 of the @endo/gateway implementation stack lands as DRAFT
PR #394 (https://github.com/endojs/endo-but-for-bots/pull/394).
Base: design/gateway-package-phase-5 (PR #393's head). Head:
design/gateway-package-phase-6.

Feature 3: Git smart-HTTP with formula-identifier bearer-token
auth. The handler at packages/gateway/src/git-http.js parses
Authorization in both Bearer and empty-user Basic forms (the
canonical git-cli convention), validates the URL path against the
64-lowercase-hex formula-id shape, and routes the three smart-HTTP
operations (info/refs, git-upload-pack, git-receive-pack) onto a
caller-supplied resolveRepo adapter. The handler conflates
"no repo" and "wrong token" into a single 401 so a probing
attacker cannot enumerate repo ids.

Byte fields cross the exo boundary as immutable ArrayBuffer per
the @endo/bytes convention (Uint8Array would not have passed the
makeExo passable-style enforcement; switched mid-build after the
first test run flagged it).

Architectural choices:
- Feature 3 is independent of every other feature per the design's
  Configuration Model, so the handler does not gate on udsBootstrap.
  makeGateway only requires the resolveRepo power when gitHttp is
  on (default-on); a missing adapter raises at construction time
  rather than silently 401-ing every request.
- The HTTP listener that routes /git/... requests to the handler
  is the embedder's, not the gateway's, mirroring Phase 4 / 8
  discipline. Follows in a separate PR.
- Added @endo/base64 as a new dependency for atob/btoa (the
  globals are not guaranteed in every SES realm).
- The daemon-side resolveRepo implementation is not part of this
  PR; the dispatch's "compose with @endo/git rename" decision
  resolves to: PR #382 (@endo/endo-git extraction) is merged, but
  PR #390 (rename to @endo/git) is still open and not in our base.
  This PR's prose names both forms; no direct dependency on either.

Files:
- packages/gateway/src/git-http.js (new; 593 lines)
- packages/gateway/test/git-http.test.js (new; 759 lines, 37 tests)
- packages/gateway/index.js (added getGitHttpHandler + wiring)
- packages/gateway/package.json (added @endo/base64 dep,
  ./src/git-http.js export)
- packages/gateway/test/admin.test.js, gateway.test.js,
  ocapn-ws.test.js (stub resolveRepo in test helpers since gitHttp
  is default-on)
- yarn.lock (separate chore commit)

Tests: 274/274 green (37 new + 237 existing). yarn lint: 0 errors,
158 pre-existing any-type warnings. Pre-flight regression-evidence
confirmed: breaking the auth check fails the "401s on missing
Authorization header" test; breaking the path validation fails
the parseGitHttpPath + handleRequest 400-on-malformed-repo-id
tests.

Self-improvement: the design's `UserDaemon.handleHttp` sketch (in
the Phase 4 bootstrap typedef) names Uint8Array for the body
field, but makeExo's passable-style enforcement rejects typed
arrays. Every gateway-facing exo that carries bytes needs the
immutable ArrayBuffer shape (per @endo/bytes) on the wire,
regardless of what the design prose says. The cost of reading the
design and writing the typedef before exercising the exo was
about 20 minutes of failed-test diagnosis when a 30-second check
against the Phase 2 pattern (which already uses immutable
ArrayBuffer everywhere) would have caught it at design time.
Suggestion for the gardener: consider adding an "immutable bytes
on exo boundaries" call-out to skills/pre-pr-checklist/SKILL.md
or to the project CLAUDE.md's "Exo and Interface Authoring"
section so a future builder spots the pattern without paying for
the round trip.
