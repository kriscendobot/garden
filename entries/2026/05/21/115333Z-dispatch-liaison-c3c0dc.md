---
ts: 2026-05-21T11:53:33Z
kind: dispatch
role: builder
project: endo-but-for-bots
to: builder
---

# Dispatch: builder c3c0dc — implement Endo Gateway design

Dispatch root: `dispatches/builder--c3c0dc/`. Project worktree on `endojs/endo-but-for-bots@master` (head fetched at prepare time).

Maintainer directive (2026-05-21T11:53Z): *"Please dispatch a builder to implement the gateway as designed."*

## Source design

Primary spec: **`designs/endo-gateway.md`** on `endojs/endo-but-for-bots@llm` (47KB, status: Proposed; 2026-05-10).

In brief: introduce an **Endo Gateway** — a system-service Daemon configuration that owns the host's external surface (one port, HTTP-virtual-hosts OCapN to many users, terminates Noise-encrypted OCapN over WebSocket, relays into per-user daemons by their public keys). The Gateway and the per-user Daemon are the *same binary* in two configurations. Per-user daemons no longer terminate external HTTP for the host; they connect outbound to the Gateway over a local-only channel and register the weblets they want exposed.

Related/companion designs to read for context:
- `designs/daemon-web-gateway.md` — the existing per-user gateway inside the daemon.
- `designs/familiar-gateway-migration.md` — migration of the gateway out of the Chat dev server into the daemon proper (already implemented).
- `designs/gateway-bearer-token-auth.md` — bearer-token + per-IP rate-limit + CIDR allowlist (already implemented).
- `designs/ocapn-network-transport-separation.md` — the Noise netlayer that this design relies on for confidentiality (so the gateway WebSocket carrying OCapN does not need TLS).
- `designs/familiar-unified-weblet-server.md` — the single-port unified web server inside the daemon (2026-04-17 revision flagged the multi-user multiplex problem this design addresses).
- `designs/daemon-256-bit-identifiers.md` — Ed25519 OCapN node identifiers.

Fetch the design from llm:
```sh
git fetch git@github.com:endojs/endo-but-for-bots.git llm:refs/heads/upstream-llm
git show upstream-llm:designs/endo-gateway.md > /tmp/endo-gateway.md
```

(Or `https://github.com/endojs/endo-but-for-bots.git` if SSH not available.)

## Task

This is a **substantial architectural change**. Read the design end-to-end first. The implementation surface will touch at minimum:

- `packages/daemon/` — new Gateway configuration mode (versus per-user Daemon mode); virtual-host routing; OCapN-over-Noise-over-WS termination; outbound register-from-daemon channel.
- `packages/cli/` — `endo gateway` verb(s) for system-service install / register / status.
- New package or directory split if the Gateway mode warrants it.
- Tests proportional to the new surface (unit + integration where the daemon test harness supports it).
- Changeset entries for every package whose source you touched (`'@endo/daemon': minor` likely, plus any helpers).

### Phase 1: read + scope

Read `designs/endo-gateway.md` end-to-end. Survey current `packages/daemon/src/` and `packages/cli/src/` for what already exists (much of the per-user gateway substance is implemented per `familiar-gateway-migration.md` and `gateway-bearer-token-auth.md`). **Write a one-page scope plan** to a `/tmp/gateway-scope.md` file before touching code:

- What's already there.
- What this PR will land in one cycle.
- What's deferred to follow-ups (and named for the followup ledger).

If the scope plan suggests the design is too big to land in one PR (likely), pick the **smallest coherent slice** that creates working scaffolding (e.g. the configuration-mode dispatch, the local-only register channel from per-user daemon → gateway, *without* yet wiring all the weblet-relay paths) and call out the deferred pieces explicitly.

**It is acceptable, and probably correct, to land a *scaffolding PR* in one cycle and surface the rest as a `gap` report.** Don't get stuck trying to land all 47KB of design in one builder dispatch.

### Phase 2: implement the slice

Branch from current `master`. Implement what your scope plan said. Conventional-commit subject(s). Authorship: bot identity (endolinbot), since this isn't a mirror of someone else's PR.

### Phase 3: validate

`yarn lint && yarn test` for every package whose source you touched. Tolerate pre-existing known-failures; flag any new red.

### Phase 4: push + open DRAFT PR

Push branch `feat/endo-gateway` to `endojs/endo-but-for-bots`. Open DRAFT PR against `master`:

```
gh pr create --repo endojs/endo-but-for-bots --base master --head feat/endo-gateway --draft \
  --title "feat(daemon,cli): Endo Gateway — system-service multi-user host (scaffolding slice 1)" \
  --body "<see below>"
```

Body must:
- Cite the source design (`designs/endo-gateway.md`) and the issue (`endojs/endo-but-for-bots#173`).
- Summarize the substance: Gateway = system-service Daemon configuration; one port per host; HTTP-virtual-hosts OCapN; relays to per-user daemons.
- Explicitly state which slice this PR lands.
- List the deferred slices for the followup ledger.

## Per-action authorization

- Standing on `endojs/endo-but-for-bots`: push to `feat/endo-gateway`, create draft PR against `master`.
- READ-ONLY everywhere else.
- No comments. Don't un-draft. Don't merge.

## Out of scope

- Do not also touch the `daemon-web-gateway.md` / `gateway-bearer-token-auth.md` / `familiar-gateway-migration.md` substance — those are stated as "already implemented" in the design's background. Build *on top of* them; don't re-implement them.
- Don't ferry upstream; don't run the gauntlet's downstream stages (the liaison handles those on your return).

## Report

≤ 500 words (slightly longer cap given the design's substance):
1. The scope plan you wrote (paste-and-trim from `/tmp/gateway-scope.md`).
2. Commits landed (subjects + final head SHA after push).
3. `yarn lint` / `yarn test` results per touched package.
4. PR URL.
5. The deferred slices, named in the form that goes into the followup ledger.
6. One-line `Self-improvement: ...`.

Write into `journal/entries/2026/05/21/<HHMMSS>Z-result-builder-c3c0dc.md` and commit+push to origin journal before returning.
