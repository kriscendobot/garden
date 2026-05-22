---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 242
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-22T22:23:42Z
last_appended_at: 2026-05-22T22:23:42Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#242

Created from the code-panel verdict (26 seats, in-band fallback) on `feat(ocapn): consume syrups-framed ocapn-test-suite for Python interop` (branch `feat/syrups-ocapn-framing`). The PR introduces the `@endo/syrups` package (a comma-less netstring fork) and an opt-in `framing: 'syrups'` option on `makeTcpNetLayer`, then opts the Python-interop test server into the matching framing. Six deferrals warrant revisit when the PR (or its upstream mirror, if one is later ferried) merges.

## Items

- [ ] **Cross-package state-machine sharing.**
  **Source juror(s)**: integrator, migrator.
  **Round**: 1.
  **Recommended action**: design and open a follow-up PR (or design doc) for an internal `@endo/length-prefix` (or equivalent) helper shared between `@endo/netstring` and `@endo/syrups`.
  The prefix-state machine is byte-for-byte identical apart from the closing comma. Today the two files diverge on comment style and copy-paste maintenance. Lift the shared state into an internal package to eliminate two-copy drift risk. Out of scope here; lands after the OCapN pre-standards group settles the framing.

- [ ] **Netlayer-level chunk-boundary stress test.**
  **Source juror(s)**: saboteur, corner-prober, prover.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR adding a multi-message, frame-boundary-fragmented round-trip test to `packages/ocapn/test/netlayer-tcp-syrups.test.js`.
  The current `round-trip through the test-only TCP netlayer` test uses one message; the sniffer test asserts on byte-shape only. Add a 2-3 message run that fragments at the syrups frame boundary to defend the deframer's `pushChunk` lifecycle.

- [ ] **`NetlayerHandlers.handleMessageData` zero-byteOffset invariant.**
  **Source juror(s)**: integrator, spec-keeper.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding a JSDoc on `NetlayerHandlers.handleMessageData` (or the relevant types module) naming the zero-`byteOffset` view requirement that `tcp-test-only.js` lines 136-141 currently honors via a fresh-copy allocation.
  If the consumer ever loses that requirement, the copy becomes dead overhead. Tracking the invariant on the consumer side lets the two ends move together.

- [ ] **README forward-compat note.**
  **Source juror(s)**: archivist, pruner.
  **Round**: 1.
  **Recommended action**: open a follow-up docs PR amending `packages/syrups/README.md` § Scope.
  Add a one-line forward note that if the OCapN pre-standards group picks a different framing, this package becomes a frozen historical artifact rather than an evolving primitive. Helps a future reader who finds the package and wonders why it stops getting attention.

- [ ] **`test-ocapn-python` CI startup reliability.**
  **Source juror(s)**: gateway.
  **Round**: 1.
  **Recommended action**: open a follow-up CI PR replacing the `sleep 5` + `cat /tmp/ocapn-server.log` startup wait in `.github/workflows/ci.yml:497-505` with a port-open probe loop or a server-emits-ready-line check.
  Unreliable on a slow runner. Out of scope here; the test passes on the present CI matrix.

- [ ] **0.x initial-release changeset-bump convention.**
  **Source juror(s)**: releaser, changeset-auditor.
  **Round**: 1.
  **Recommended action**: open a maintainer discussion (issue or design doc) on the monorepo-wide convention for `0.x` initial-release changesets.
  This PR's `.changeset/syrups-initial.md` uses `'@endo/syrups': patch` on a brand-new package; the convention question (`patch` vs `minor` vs no-changeset-with-hand-set-version) deserves a documented rule so the next wholly-new package doesn't relitigate it. Proposed rule: 0.x initial-release changesets should be `minor`, not `patch`, when the package is wholly new.
