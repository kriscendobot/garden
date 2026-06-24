---
source_kind: repo-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/chat/README.md
source_line_range: 1-98
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 385 designs-lane ingest. 98-line README for @endo/
  chat, the bot-fork's web-based chat application. The
  llm-branch sibling of master's goblin-chat (cycle 374
  named the cli demo as the master-branch capability-
  passing surface; cycle 385 introduces the web GUI form
  on llm). Thirty-third AUTHORED conformant single-body
  section doc in post-refactor era. Seventy-fifth
  consecutive non-garden source after the pivot (310-385).
  §seventy-five-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  CapTP-over-WebSocket-extends-CapTP-over-netstring —
  cycle 369's @endo/daemon README named "CapTP over
  netstring message envelopes" as the daemon's
  communication channel; cycle 385 reveals there is ALSO
  a CapTP-over-WebSocket layer for browser clients (line
  57-58: "Browser opens WebSocket to daemon's built-in
  gateway. CapTP Handshake"). Same protocol, different
  transports. §the-named-CapTP-as-transport-agnostic-
  protocol as tier-3 meta-pattern. Cycle 369's four-layer
  protocol stack (Unix socket + netstring framing + CapTP
  + user-agent capabilities) gains a parallel: WebSocket +
  (no framing needed, WebSocket frames already) + CapTP +
  agent capabilities.

  §The-named-five-features-list-inbox-inventory-chat-eval-
  peers — lines 11-15: Inbox + Inventory + Chat + Eval +
  Known Peers. FIVE named surfaces of the chat app, each
  a different agent-interaction primitive. §the-named-
  five-tab-application-surface as tier-3 meta-pattern.

  §The-named-inventory-as-pet-names-aka-capabilities —
  line 12 explicitly equates "pet names" with
  "capabilities" via parenthetical alias: "Browse and
  manage pet names (capabilities)". The vocabulary
  alignment is named openly: petnames ARE capabilities
  in this design. §the-named-petname-equals-capability-
  alias-discipline as tier-3 meta-pattern.

  §The-named-pet-name-syntax-at-prefix-recurs-from-cli-
  demo — lines 86-87 show `@pet-name` and `@pet-name:
  edge-name` syntax. Cycle 374's @endo/cli/test/demo/
  names-in-transit.js used the same exact syntax
  (`@counter:doubler`). The convention spans CLI and web
  surfaces — same wire format, different UIs. §the-
  named-pet-name-syntax-spans-CLI-and-web as tier-3
  meta-pattern.

  §The-named-edge-name-as-named-second-part-of-petname
  — the colon-separated form (`@pet-name:edge-name`) is
  the same as cycle 374's `@counter:doubler` but with the
  conceptual name "edge-name" for the post-colon part.
  The petname is the WHOLE rooted reference; the edge-
  name is the specific sub-reference along the way.
  §the-named-edge-name-vs-pet-name-distinction as tier-3
  meta-pattern.

  §The-named-Eval-as-named-feature — line 14 lists "Eval:
  Evaluate JavaScript expressions with pet name
  endowments." The chat UI lets users RUN JAVASCRIPT
  against the daemon's capability graph. §the-named-eval-
  with-petname-endowments-as-power-user-surface as
  tier-3 meta-pattern; the eval feature gives users
  direct access to compose capabilities via JavaScript.

  §The-named-ses-as-browser-dependency — line 98 lists
  `ses - Secure ECMAScript (HardenedJS)` as a dependency.
  The chat app runs hardened JS in the BROWSER, not just
  in the daemon. §the-named-hardened-JS-in-browser-too
  as tier-3 meta-pattern; the bot-fork's web client
  inherits the same hardening discipline as the server
  side.

  §The-named-Vite-Endo-plugin-as-bootstrap-helper — lines
  27-31 describe the plugin's three jobs: ensure daemon
  running + read gateway address and agent ID + inject
  connection parameters. The plugin is the development-
  time glue between Vite (the bundler) and Endo (the
  daemon). §the-named-bundler-plugin-as-daemon-aware-
  bootstrap as tier-3 meta-pattern.

  §The-named-five-step-connection-flow — lines 56-60
  list five connection steps: Vite Plugin → WebSocket →
  CapTP Handshake → AGENT Fetch → UI Initialization. The
  protocol stack from connection establishment to UI
  ready. §the-named-bootstrap-as-five-phase-pipeline as
  tier-3 meta-pattern.

  §The-named-known-peers-as-fifth-tab — line 15: "List
  all known remote Endo peers and their connection
  hints." The chat app shows OTHER daemons it knows
  about. This is the §the-named-social-network-already-
  shipping observation (cycle 374) at the GUI level —
  the network of peers is a first-class browseable
  surface. §the-named-peer-list-as-named-UI-surface as
  tier-3 meta-pattern.

  §The-named-three-keyboard-shortcuts — lines 62-66:
  `"` or `'` for chat dialog + `.` for eval dialog +
  `Escape` to close. THREE-key UI: send-message + run-
  code + escape. §the-named-quote-dot-escape-three-key-
  ui as tier-3 meta-pattern.

  §The-named-development-server-uses-system-daemon —
  lines 34-38: the dev server uses your system's Endo
  daemon at `~/.local/state/endo/`. State persists
  across dev server restarts; CLI changes reflect in
  the UI. §the-named-shared-daemon-state-between-CLI-
  and-web as tier-3 meta-pattern; the chat app is not
  a separate runtime, it's a different UI on the same
  underlying daemon.

  §The-named-eight-package-dependency-list — lines 93-98
  list eight @endo/* dependencies plus ses: @endo/captp +
  @endo/far + @endo/exo + @endo/pass-style + @endo/
  daemon + ses. (Six listed, with two of them — @endo/
  captp and @endo/far — being the substrate the chat
  layer composes atop.)

  §The-named-extracted-from-cli-demo-cat-js — line 7:
  "extracts the chat functionality from `packages/cli/
  demo/cat.js`." The chat package's origin is a CLI
  demo file. §the-named-package-extracted-from-demo-
  file as tier-3 meta-pattern; ad-hoc demo code grew into
  a packaged surface. Cycle 374's @endo/cli demo
  directory is precisely where this lineage starts.

  Closes seven citation arcs: cycle 384 (1, adjacent
  forward; tools index → chat README; both are llm-
  branch surfaces of the bot-fork) + cycle 374 (4, same
  pet-name syntax in CLI demo and web app; chat is the
  web-GUI sibling to cli's social-network-already-
  shipping demo) + cycle 369 (2, CapTP over netstring
  named; cycle 385 reveals CapTP over WebSocket as
  parallel transport; transport-agnostic-protocol new
  framing) + cycle 367 (6, exo dependency) + cycle 321
  (10, eventual-send / E dependency) + cycle 326 (59,
  pure-naming) + cycle 325 (7, pass-style dependency).
  Pushes citation-arc-closures-in-pivot to THREE-HUNDRED-
  SEVENTY-FOUR (367 + 7 net new).
---

98-line README for @endo/chat, the bot-fork's web-based chat application. §the-named-CapTP-over-WebSocket-extends-CapTP-over-netstring (single most structurally interesting move; cycle 369 daemon named CapTP-over-netstring; cycle 385 reveals CapTP-over-WebSocket parallel transport for browser clients); §the-named-CapTP-as-transport-agnostic-protocol. §the-named-five-features-list-inbox-inventory-chat-eval-peers. §the-named-inventory-as-pet-names-aka-capabilities (line 12 parenthetical alias makes the equation explicit). §the-named-pet-name-syntax-at-prefix-recurs-from-cli-demo (same `@pet-name:edge-name` syntax across CLI and web); §the-named-pet-name-syntax-spans-CLI-and-web. §the-named-edge-name-vs-pet-name-distinction. §the-named-Eval-as-named-feature (JavaScript with petname endowments as power-user surface). §the-named-ses-as-browser-dependency (hardened JS in browser too). §the-named-Vite-Endo-plugin-as-bootstrap-helper. §the-named-five-step-connection-flow (Vite Plugin → WebSocket → CapTP Handshake → AGENT Fetch → UI Initialization). §the-named-known-peers-as-fifth-tab (peer list as named UI surface; social-network-already-shipping at GUI level). §the-named-three-keyboard-shortcuts. §the-named-development-server-uses-system-daemon (chat is a different UI on the same daemon, not a separate runtime). §the-named-extracted-from-cli-demo-cat-js (package origin traced to CLI demo file; cycle 374 demo directory is the lineage start). Seven citation arcs closed.
