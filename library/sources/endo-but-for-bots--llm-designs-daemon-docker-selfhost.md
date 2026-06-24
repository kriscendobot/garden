---
source: designs/daemon-docker-selfhost.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: ee535f5947224fffbe3d8c4cec9fb65c87cb5b29
source_date: 2026-03-02
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-first-comment-style design ingest. 236-line *Not
  Started* design (Kris Kowal, 2026-03-02). Addresses the
  *always-on-server* deployment gap — today the daemon runs only
  as a local process managed by Familiar or manually via the
  CLI; *there is no supported way to run a daemon as an
  always-on server*.

  §Four-requirements frame: container image / state persistence
  / network exposure / remote authentication.

  §Docker image: Node:22-slim base + pre-built bundles (no yarn
  install in image) + VOLUME /data/endo for state + EXPOSE 8920
  + bind to 0.0.0.0:8920 (vs local daemon's 127.0.0.1 default —
  inside Docker, localhost binding makes the gateway
  unreachable).

  §Entrypoint pattern: lazy-init on first start (if state/ dir
  doesn't exist, run `endo init`); exec into daemon (PID 1 in
  container, signals reach directly).

  Single most structurally interesting move: §external TLS — *the
  daemon does not handle TLS itself. This keeps the daemon
  simple and follows Docker conventions. Users who want HTTPS
  use a reverse proxy, which also handles certificate renewal*.
  Three claims compose:
    - *the standard Docker pattern* — TLS is a proxy concern
    - *avoids bundling certificate management* (Let's Encrypt
      renewal, OCSP stapling, modern TLS suite selection are
      non-trivial moving targets)
    - *a future enhancement could add `--tls-cert` and `--tls-
      key` flags* — but *not required for the initial Docker
      image* (§don't-build-it-now-could-build-it-later)

  §Docker Compose example: two-services-one-volume pattern
  (endo + caddy + endo-state volume); `restart: unless-stopped`
  policy; `ENDO_GATEWAY_REMOTE=true` enables remote auth.

  §State-directory layout: three subdirs — `state/` (formula
  store + pet names + message logs), `keys/` (256-bit agent
  keypairs — cycle 60's d256), `worker/` (worker process logs).
  Single-volume-three-subdirectories discipline.

  §Bundled-agents optional: future addition of Lal/Fae bundles
  via `ENDO_LAL_PATH`/`ENDO_FAE_PATH` env vars — same image
  serves users *with* or *without* AI agents.

  §Chat-UI-hosting: gateway serves static Chat bundle; user
  navigates to daemon URL → Chat UI → appends `#agent=<id>` URL
  anchor to authenticate. §URL-anchor-not-query-string
  discipline: fragments are not sent to the server (token never
  appears in server logs or HTTP referer headers).

  §Reuse-Familiar-bundle-script discipline: docker build script
  runs `packages/familiar/scripts/bundle.mjs`, copies bundles to
  Docker context, builds image. *No separate build system —
  ensures parity between desktop and server deployments*.

  §Files Modified: only *two* existing files change
  (daemon-node.js adds `--addr` flag; gateway.js supports
  ENDO_GATEWAY_REMOTE env var). The §minimal-daemon-side-change
  discipline: most weight is in new infrastructure files;
  daemon becomes Docker-friendly through additive flags, not
  through restructuring.

  §Four Design Decisions codify choices: External TLS / Same
  bundles as Familiar / Volume for state / 0.0.0.0 binding.
  §codification-as-Design-Decisions discipline: each non-obvious
  choice named and justified.

  Three §Related Designs: gateway-bearer-token-auth (remote
  authentication for the gateway, required for Docker self-
  hosting); familiar-bundled-agents (bundled Lal/Fae,
  optionally included); familiar-daemon-bundling (the bundle
  pipeline this design reuses).

  Cycle 139 was nominally papers-lane (cycle 138 was comments).
  Papers-lane has been blocked for 33+ consecutive cycles. Cycle
  139 pivoted to designs-lane. Fourth daemon-* design after
  endopi-* family closure (cycles 133 + 135 + 137 + 139).
---

> Abstract: `daemon-docker-selfhost.md` (236 lines, *Not Started*)
> addresses the *always-on-server* deployment gap — today the
> daemon runs only locally (Familiar or CLI); this design adds
> *a Docker image and standard deployment patterns* for VPS-
> style 24/7 hosting.
>
> §Four requirements: container image / state persistence /
> network exposure / remote authentication.
>
> §Docker image: Node:22-slim + pre-built bundles + VOLUME +
> EXPOSE + 0.0.0.0 bind (vs local daemon's 127.0.0.1). §Lazy-
> init entrypoint runs `endo init` only on first start.
>
> **Single most structurally interesting move**: §external TLS
> — *the daemon does not handle TLS itself*. TLS is a proxy
> concern (Caddy / nginx / Traefik / cloud LB); the daemon
> avoids bundling certificate management. §design-as-deferral
> pattern.
>
> §Docker Compose two-services-one-volume pattern (endo +
> caddy). §State-directory layout: `state/` + `keys/` +
> `worker/`. §URL-anchor-not-query-string for Chat auth (token
> never appears in server logs).
>
> §Reuse-Familiar-bundle-script discipline: docker build runs
> Familiar's bundler; *no separate build system — ensures
> parity between desktop and server deployments*.
>
> §Minimal-daemon-side-change: only two existing files modify
> (`--addr` flag + `ENDO_GATEWAY_REMOTE` env var); most weight
> is in new infrastructure files.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline](../sections/endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline.md) | daemon, agent-conventions | current |

Tight 236-line *Not Started* design. The four-requirements +
external-TLS-discipline + reuse-Familiar-bundles form one
coherent server-deployment story. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from
  `endojs/endo-but-for-bots@ee535f59` (the branch `origin/llm`)
  via the local bare-clone.
- Created 2026-03-02 by Kris Kowal in commit `ee535f59`. Status:
  *Not Started*.
- **Thirty-first-comment-style design ingest.** Fourth
  daemon-* design after the endopi-* family closure (cycles 133
  + 135 + 137 + 139). Pairs with cycle 109's familiar-electron-
  shell, cycle 111's familiar-gateway-migration, cycle 113's
  familiar-daemon-bundling to complete the deployment-shape
  picture across Familiar (Electron, cycles 109/111/113/114),
  Docker (this cycle), and the daemon itself (cycles 111/119/
  133/135/137).
- Cycle 139 was nominally **papers-lane** (cycle 138 was
  comments). Papers-lane has been blocked for **33+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 139
  pivoted to designs-lane.
- One cohesion-honest section.
