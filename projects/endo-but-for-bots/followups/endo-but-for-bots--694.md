---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 694
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-07-12T18:59:19Z
last_appended_at: 2026-07-12T18:59:19Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#694

Created from the code-panel verdict (22 seats) on `feat: Docker self-hosting
image with authenticated remote gateway` (branch
`build/daemon-docker-selfhost-remote-gateway`, base `llm-f7932ed`). The panel's
in-scope must-fix (the CIDR allowlist fail-open) and the bundled should-fix docs
and `.dockerignore` items were fixed in the gauntlet's fixer pass (head
`f09fd724a1`). The items below were dispositioned `follow-up` (useful, not
blocking un-draft) and warrant revisit when the PR (or an upstream mirror, if
one is later ferried) merges.

## Items

- [ ] **daemon-node env-glue is untested.**
  **Source seat(s)**: assessor.
  **Round**: 1.
  **Recommended action**: open a follow-up PR that exercises the env-var glue in
  `packages/daemon/src/daemon-node.js` (`ENDO_GATEWAY_REMOTE` `'true'`/`'1'`
  branches and `ENDO_GATEWAY_ALLOWED_CIDRS` -> `makeAddressChecker` -> the
  wired `startWsGateway`) by setting the env vars and observing the resulting
  gate, rather than only unit-testing the downstream pure function. Consider
  extracting the glue into a testable helper.

- [ ] **The rejected-connection crash-guard is line-covered but never triggered.**
  **Source seat(s)**: breaker, assessor.
  **Round**: 1.
  **Recommended action**: add a test that actually emits an `'error'` on a
  rejected server-side socket after `ws-gateway.js` installs
  `socket.on('error', () => {})`, so the crash-prevention behavior the line
  exists for is verified, not just executed.

- [ ] **Property-based coverage for the CIDR/IP parser.**
  **Source seat(s)**: fast-checker, corner-prober.
  **Round**: 1.
  **Recommended action**: introduce `fast-check` as a `packages/daemon`
  devDependency and add a property asserting the default checker admits only
  localhost across arbitrary strings, plus round-trip properties for
  `parseCIDR`/`addressMatchesCIDR`. Would generalize past the example
  assertions added this round.

- [ ] **Dockerfile native-dep toolchain / architecture story.**
  **Source seat(s)**: packager.
  **Recommended action**: `node:22-bookworm-slim` ships no C/C++ toolchain, yet
  the root `dependenciesMeta.*.built` opts `better-sqlite3` and
  `@ipshipyard/node-datachannel` into build scripts. On an arm64 host without a
  matching prebuild, `yarn install --immutable` fails mid-build with an opaque
  node-gyp error. Either add `build-essential python3-minimal` or document the
  verified target architectures. Also consider a base-image digest pin for
  reproducible rebuilds.

- [ ] **Stale design/spec references to the never-read `ENDO_GATEWAY=remote`.**
  **Source seat(s)**: integrator, scribe.
  **Recommended action**: this PR's changeset documents that `ENDO_GATEWAY=remote`
  was never read by the code and that the real names are `ENDO_GATEWAY_REMOTE` /
  `ENDO_GATEWAY_ALLOWED_CIDRS`. Sweep `designs/` for the stale name
  (`designs/daemon-web-gateway.md`, `designs/gateway-bearer-token-auth.md`,
  `designs/weblet-next.md`) and reconcile `designs/daemon-docker-selfhost.md`
  (still `Status: Not Started`, `--addr` flag, target path
  `packages/daemon/src/gateway.js` vs the shipped `ws-gateway.js`), which the
  PR body claims to reconcile but does not edit.

- [ ] **Unbounded warn-log on rejected connections.**
  **Source seat(s)**: breaker.
  **Recommended action**: the address-reject path `console.warn`s per
  connection with no rate limit (the `fetchLimiter` guards only `fetch()`), so
  a flood of rejected connection attempts produces unbounded log volume.
  Consider rate-limiting the reject log.
