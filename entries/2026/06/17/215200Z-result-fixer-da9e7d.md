---
ts: 2026-06-17T21:52:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/213200Z-dispatch-fixer-da9e7d.md
---

Addressed three kumavis directives on PR #452 (iroh heartbeat):

- **Copilot review (pullrequestreview-4519716420).** Two inline asks:
  1. `iroh-heartbeat.js:64` — `timeoutMs` default was wired to the constant
     `KEEPALIVE_TIMEOUT_MS` (60s), so callers overriding only `intervalMs`
     broke the "tolerate a single dropped beat" invariant. Default now
     derives from `2 * intervalMs`. New test
     `timeoutMs defaults to twice the chosen intervalMs` covers it.
     Inline reply: https://github.com/endojs/endo-but-for-bots/pull/452#discussion_r3431671802
  2. `iroh-heartbeat.js:126` — `sendDatagram` error log reached for
     `.message`, would crash the loop on a native throw of `null`. Now
     renders via a defensive `renderThrown(value)` helper. New test
     `a non-Error thrown by sendDatagram is rendered without re-throwing`
     covers it.
     Inline reply: https://github.com/endojs/endo-but-for-bots/pull/452#discussion_r3431671999

  Both fixes landed in one commit (62b5eefcb) since they share a file and a
  review.

- **Teardown question (issuecomment-4735591371).** Posted the answer as a
  top-level comment on the PR (issuecomment-4735846280). Substance: this
  PR does **not** teardown the peer formula on connection end. The
  `tearDown(reason)` path in `serveStream` closes the CapTP session
  (rejecting outstanding questions and revoking imported presences) and
  the QUIC connection. On the outbound path, the existing
  `capTp.closed → cancelConnection` wiring also cancels the per-dial
  `connectionContext`. The peer formula itself stays alive across
  connection loss by design: `remote-control.js` transitions from
  `connectedState` back to `startState` on `currentCancelled`, and
  `ResilientPeerGateway` re-dials on the next `provide`. The peer
  formula's `dropLiveValue(context.id)` only runs through the
  remote-control's `dispose` callback when an incarnation is replaced.
  Flagged the keep-alive-timeout case as a potential policy upgrade
  (stronger "gone" signal than a plain stream close) for kumavis to
  decide as a follow-up.

- **Lint.** No real failure to fix. All `lint` check runs on the prior
  head (f24c54713) completed `success`. Local `yarn lint` (root), `yarn
  lint:prettier`, `yarn build:types:check`, `yarn docs` all pass. The
  new lint run on 62b5eefcb is in progress; my changes are confined to
  one source file and one test, both lint-clean and type-clean.

Pre/post head SHAs: f24c54713 → 62b5eefcb.

Tests: `packages/daemon`: `yarn ava test/iroh-heartbeat.test.js` — 9
passed (7 prior + 2 new). Daemon typecheck (`yarn lint:types`) clean.

Pre-push-gates: probes run on staged + ancestor diff. Only my two files
are staged. All probes pass on my files (`no-non-ascii-in-source`,
`no-ascii-banners`, `no-inline-import-jsdoc`, `no-pull-citations`,
`filename-no-stutter`, `test-package-no-main`). Two probes report
preexisting findings against `origin/master` that are not from this PR
(`security-md-hash-uniform: missing packages/endo/SECURITY.md`,
`sentence-per-line-md` on dozens of preexisting markdown files); both
are noise from comparing against the wrong base (`master` not `llm`)
when the working tree is on a detached HEAD without a tracking upstream.

Pushed append-only: `git push origin HEAD:kriskowal-iroh-heartbeat`.

Recommended next stage: `next: cleaner` (gamut stage 1) once the
maintainer is satisfied with the teardown-answer comment. Until then the
DRAFT stays parked for kumavis to read the answer and decide whether
the policy upgrade (peer-formula teardown on keep-alive timeout) is
in-scope or follow-up.

Self-improvement: nothing this time.
