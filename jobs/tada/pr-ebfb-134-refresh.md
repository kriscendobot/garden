Done. Writing the completion report.

**Completion report — `pr-ebfb-134-refresh`**

Refreshed PR #134 (endojs/endo-but-for-bots) into the canonical docker self-host + remote-auth PR. New head: `5dceb6a20`; PR is now `MERGEABLE` (was `CONFLICTING`) and marked **ready for review** (was draft).

**What I did**
- **Rebased onto current `llm`** (tip `1132289`). Rebuilt `feat/docker-selfhost` from `origin/llm` + the verified consolidation branch `wip/daemon-docker-selfhost-gateway-remote-auth` (`180ef1489`), force-pushed with `--force-with-lease`. The daemon's foreground/PID-1 mode is already on `llm`, so the PR no longer carries that commit; the stale `0xpatrickbot` and old-Dockerfile commits are gone.
- **Wired ws-gateway.js remote-auth.** `cidr.js`'s `makeAddressChecker` (implemented+tested but never connected) now gates WebSocket connections: localhost-only by default; `ENDO_GATEWAY=remote` admits any reachable client; `ENDO_GATEWAY_ALLOWED_CIDRS` admits ranges; disallowed clients closed `1008 "Only local connections allowed"`; remote mode logs a TLS warning. `daemon-node.js` reads both env vars and passes them through.
- **5 ws-gateway.test.js tests — verified by real execution.** Ran ava locally (`node ava/entrypoints/cli.js test/ws-gateway.test.js`): **5 tests passed** (localhost admit, non-local reject with documented reason, IPv4-mapped-IPv6 localhost admit, remote-mode admit, CIDR allowlist in/out). The reject test is regression-proven.
- **Added the CI test kriskowal requested.** New `.github/workflows/docker.yml` (commit `5dceb6a20`), adapted to the new two-stage Dockerfile layout: validates the Compose manifest, builds `docker/Dockerfile`, then smoke-tests from the runner's network namespace (outside the container) — asserts the `Endo Gateway` HTTP body, a `101` WebSocket upgrade (proving the image-default `ENDO_GATEWAY=remote` gate admits the bridged non-loopback client), and that the foreground daemon (PID 1) survives. Dumps container logs on failure. YAML validated locally.
- **Addressed CHANGES_REQUESTED.** Posted an explanatory PR comment ([#issuecomment-4892473999](https://github.com/endojs/endo-but-for-bots/pull/134#issuecomment-4892473999)) covering the rebase, the remote-auth wiring (citing the maintainer's 2026-07-06 decision to proceed now rather than wait on `@endo/gateway`, which reverses the earlier "return to draft" request), and the CI addition; updated the now-inaccurate title (dropped "static files", which are out of scope for this consolidated change) to `feat(daemon,docker): daemon Docker self-hosting + gateway remote-auth wiring`.

**Diff shape** (12 files, +604/−1 vs `llm`): `docker/` image (two-stage Dockerfile, entrypoint, CLI wrapper, Compose + Caddyfile, README), `.dockerignore`, changeset, `.github/workflows/docker.yml`, `ws-gateway.js`, `daemon-node.js`, `ws-gateway.test.js`.

**Not verified locally:** the Docker build/smoke itself — no docker daemon in this environment. That path runs in the new CI workflow; the unit-level remote-auth gate is what I verified by execution.

**#568 / #608 consolidation state (per your request to surface, both left untouched):**
- **#568** ("feat(daemon): add Docker self-host image", head `build/daemon-docker-selfhost`, base `llm`): OPEN, **draft**, **CONFLICTING**. The conflicting/superseded slice — now redundant with the refreshed #134.
- **#608** ("feat: Docker self-hosting image for the daemon", head `daemon-docker-selfhost`, base `master-eecc683`): OPEN, **not draft**, MERGEABLE — the already-un-drafted docker-image-only slice on an odd frozen base.
- Recommendation for the maintainer: #134 now supersedes both (it carries the docker image *and* the remote-auth wiring on current `llm`). #568 and #608 are candidates to close as consolidated into #134 once #134 is reviewed — your call, untouched as instructed.

**Follow-ups:** none blocking. Watch the new Docker CI job on #134's next check run; if the image build hits a `better-sqlite3` prebuilt-addon fetch issue on the runner, the container logs dumped by the smoke step will show it.
