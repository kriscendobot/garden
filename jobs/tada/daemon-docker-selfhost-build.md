The draft PR is confirmed open (#608, draft, base `master-eecc683`, head `daemon-docker-selfhost`). Work is complete.

## Completion report

**Job:** `daemon-docker-selfhost-build` (builder) — build the `daemon-docker-selfhost` design for `endojs/endo-but-for-bots`, open a DRAFT PR.

**Outcome:** Opened **DRAFT PR endojs/endo-but-for-bots#608** — "feat: Docker self-hosting image for the daemon" (base `master-eecc683`, head `daemon-docker-selfhost`). Base branch is `master` (frozen snapshot) because the change touches no package source, only new top-level files.

**What I built** (new files under `docker/` + root `.dockerignore`):
- `docker/Dockerfile` — builds the monorepo, runs `packages/daemon/src/daemon-node.js` in the foreground, `VOLUME /data/endo`, `STOPSIGNAL SIGINT`.
- `docker/docker-entrypoint.sh` — foreground start with env-overridable state/runtime/socket paths (shellcheck-clean).
- `docker/docker-compose.yml` — one-service example with a named state volume, no published port.
- `docker/README.md` — self-hosting guide: build/run, state persistence table, and an explicit "Remote access" section documenting the gap.
- `.dockerignore` — lean build context.

**Design-status drift I surfaced (important):** The design's headline requirement — authenticated remote access "per the Complete `gateway-bearer-token-auth` design" — is not buildable: `gateway-bearer-token-auth` is marked Complete/Implemented but is **not implemented anywhere** (no `GatewayBootstrap`, `ENDO_GATEWAY`, HTTP/WebSocket gateway, or bearer-token gate on `master`/`llm`/`garden`). The Docker design also assumes a `familiar` bundle pipeline and a daemon `--addr` flag that don't exist here. The real daemon is UNIX-socket controlled.

Rather than fabricate the gateway or bridge the raw control socket to TCP (which would grant unauthenticated remote control), I delivered the buildable, **safe** subset — container + real state persistence + local CLI control — and documented the remote-auth gap in the PR body and README. The image deliberately publishes **no** network port.

**Verification:** `sh -n` + `shellcheck` clean on the entrypoint; `prettier --check` clean on Markdown/Compose; no banner probes triggered; daemon-node argument order and the `ENDO_SOCK`/`@endo/where` socket resolution cross-checked against source. The image was **not** built/run — no Docker daemon on this host; a build-and-run pass belongs to the gauntlet or a reviewer with Docker (stated in the PR).

**Follow-ups (also messaged to the liaison):**
1. Correct `gateway-bearer-token-auth` status Complete → Not Started.
2. The authenticated-remote-gateway portion of `daemon-docker-selfhost` is blocked on `gateway-bearer-token-auth` actually being built; consider posting that prerequisite before the remote-access follow-up on #608.
3. Slim bundle-based image and optional daemon `SIGTERM` handling (noted in README/PR).

Message delivered to `liaison` inbox (`20260705T234349Z-017bc2`). Builder stage done; the gardener's gauntlet (panel → fixer loop → un-draft) continues from the open draft.
