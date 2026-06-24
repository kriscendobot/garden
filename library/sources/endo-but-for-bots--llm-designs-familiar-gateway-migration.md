---
source: designs/familiar-gateway-migration.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-02-26
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-seventh endo-but-for-bots design ingest. **Status:
  Complete** (*Implemented*). The 127-line design documents the
  gateway-from-Chat-into-daemon migration — the WebSocket gateway
  bridging browser clients to the Endo daemon was originally in
  `packages/chat/scripts/gateway-server.js` (launched by Chat's
  Vite dev plugin); the migration relocated it to the daemon as
  a built-in service that serves both HTTP (weblet virtual hosts)
  and WebSocket (CapTP sessions) on `ENDO_ADDR` (default
  `127.0.0.1:8920`).
  
  Cycle 111 ingests this design as the *first* of cycle 109's
  three named dependencies (along with `familiar-unified-weblet-
  server` and `familiar-daemon-bundling`). Three structurally
  interesting moves: (1) the *daemon-must-own-this-concern*
  rationale — *if [the gateway] remains in Chat, then every
  application that wants to connect to the daemon from a browser
  must either depend on Chat or reimplement the gateway. The
  daemon should own this concern* — the canonical *cross-cutting-
  service-belongs-in-the-shared-substrate* discipline; (2) the
  *attack-surface-reduction* observation — *Moving the gateway
  into the daemon reduces the attack surface: one fewer process
  with access to the Unix socket* — consolidation-as-security
  with named metric; (3) the *protocol-preservation-across-
  migration* invariant — *The WebSocket protocol is unchanged.
  Existing browser clients work without modification* — only
  the hosting process moved.
  
  Pairs structurally with cycle 109's familiar-electron-shell
  (which named this design as a required dependency). Single-
  section cohesion-honest ingest. The §Status block enumerates
  *five concrete shipped facts* with code-path references,
  applying the file-level implementation-tracking discipline.
---

> Abstract: `designs/familiar-gateway-migration.md` documents the
> *gateway-from-Chat-into-daemon* migration. The WebSocket gateway
> that bridges browser clients to the Endo daemon originally lived
> in `packages/chat/scripts/gateway-server.js` (launched by Chat's
> Vite dev plugin); the migration relocates it to the daemon as a
> built-in service. The §Status block enumerates five concrete
> shipped facts: (1) `@apps` formula in `daemon-node.js` launches
> `web-server-node.js` as an unconfined guest with @endo powers;
> (2) gateway listens on `ENDO_ADDR` (default `127.0.0.1:8920`);
> (3) serves both HTTP (weblet virtual hosts) AND WebSocket (CapTP
> sessions) on the single port; (4) `packages/chat/scripts/
> gateway-server.js` retained as standalone for Chat's Vite dev
> plugin connecting via Unix socket; (5) Familiar reads
> `ENDO_ADDR` or defaults to `127.0.0.1:8920`. The §rationale:
> *the gateway is the entry point for all browser-based CapTP
> connections. If it remains in Chat, then every application
> that wants to connect to the daemon from a browser must either
> depend on Chat or reimplement the gateway. The daemon should
> own this concern*. The §gateway HTTP endpoint serves WebSocket
> at `/` for CapTP (preserved `E(gatewayBootstrap).fetch(token)`
> protocol) + HTTP requests routed to weblet virtual hosts. The
> §`endoBootstrap.gateway()` method reused — *connecting to
> itself via the internal CapTP rather than over the Unix socket*.
> The §CLI additions: `endo gateway` prints WebSocket URL; `endo
> start --gateway-port <port>` configures. The §Security
> Considerations: localhost-only restriction preserved (127.0.0.1,
> ::1); `fetch(token)` token-gate (formula-identifier-derived,
> unguessable); *Moving the gateway into the daemon reduces the
> attack surface: one fewer process with access to the Unix
> socket*. The §Compatibility: WebSocket protocol unchanged so
> existing browser clients work without modification. The
> §Upgrade: pre-migration daemons don't have a gateway, CLI
> detects and restarts or falls back.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [gateway-moved-from-chat-vite-plugin-into-daemon](../sections/endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon.md) | daemon | current |

The 127-line file is honestly one cohesive argument-cluster — *one architectural migration* with shipped-Status block, problem-rationale, six design subsections, and security/scaling/test/compatibility/upgrade considerations. Single-section ingest preserves the unified structure.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-02-26 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 127 lines.
- **Twenty-seventh endo-but-for-bots design ingest**. Cycle 111 ingests this design as the *first* of cycle 109's three named dependencies for the Familiar Electron Shell.
- Cycle 111 was scheduled for chat-lane (exhausted) and pivoted to familiar-design-lane continuing the pattern of cycle 109. The three remaining cycle 109 dependencies still in queue: `familiar-unified-weblet-server` (In Progress) and `familiar-daemon-bundling` (Complete).
- Single-section cohesion-honest count. The 127-line file is *one architectural migration* — Status + Problem + Design (six subsections) + Considerations (security / scaling / test / compatibility / upgrade) all serve the same migration narrative.
