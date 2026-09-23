---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/daemon/src/networks/setup-ws-relay.js
source_line_range: 1-46
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 392 chat-lane ingest paired to cycle 391 designs-
  lane daemon-lore. 46-line setup-ws-relay.js, a concrete
  runlet that installs a WebSocket relay network module
  into the daemon. The cycle 391 lore named the runlet
  shape; cycle 392 shows a runlet in code. Fortieth
  AUTHORED conformant single-body section doc in post-
  refactor era. Eighty-second consecutive non-garden source
  after the pivot (310-392). §eighty-two-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  runlet-as-named-program-shape-in-source — the file is a
  concrete instance of the RUNLET shape that cycle 391
  daemon-lore named. It exports `main(powers)`, returns a
  result string, and is transient (not intended to exceed
  the life of main). The lore vocabulary maps directly to
  the source shape. §the-named-lore-vocabulary-realized-
  in-source as tier-3 meta-pattern.

  §The-named-Usage-comment-as-self-documenting-command —
  lines 2-3: "Usage (installs the ws-relay network caplet
  at NETS/ws-relay): endo run --UNCONFINED packages/
  daemon/src/networks/setup-ws-relay.js --powers @agent".
  The file's first comment IS its operating manual. §the-
  named-usage-as-header-comment as tier-3 meta-pattern.

  §The-named-requires-powers-agent-explicit-comment — line
  5: "Requires --powers @agent because the script calls
  makeUnconfined()." Honest acknowledgment of WHY the
  higher powers are needed. The script declares its own
  authority requirement and the reason. §the-named-
  authority-requirement-with-reason as tier-3 meta-
  pattern; sibling shape to cycle 357's for-expedience-
  as-honest-acknowledgment.

  §The-named-edit-defaults-below-comment — line 6: "Edit
  the defaults below to target a different relay server."
  The header tells the reader where in the file to
  customize. §the-named-customization-pointer-in-header
  as tier-3 meta-pattern.

  §The-named-runlet-installs-caplet — line 2's "ws-relay
  network caplet" + line 3's `endo run` (the runlet
  invocation form) reveals the relationship: a RUNLET
  installs a CAPLET. The runlet has main() that bootstraps
  the daemon's caplet registry. §the-named-runlet-as-
  caplet-installer as tier-3 meta-pattern.

  §The-named-env-var-with-or-default-pattern — lines 30-
  31: `const relayUrl = env.WS_RELAY_URL || 'wss://endo-
  relay.fly.dev';`. JavaScript's `||` short-circuit
  provides default fallback. §the-named-env-var-with-or-
  fallback as tier-3 meta-pattern.

  §The-named-public-default-relay-wss-endo-relay-fly-dev
  — the default relay is a public Fly.io-hosted service:
  `wss://endo-relay.fly.dev`. §the-named-public-default-
  service-acknowledged-in-source as tier-3 meta-pattern;
  the source IS the configuration; the default is
  explicitly the public hosted endpoint.

  §The-named-formula-env-persists-across-reincarnation —
  lines 19-21 of the JSDoc explain: "The resolved values
  are persisted in the formula env so they survive
  reincarnation without a pet-store lookup at boot time."
  §the-named-formula-env-as-persistent-config as tier-3
  meta-pattern; the runlet's resolved env values become
  part of the formula's persisted state, so daemon
  restarts don't lose the relay URL.

  §The-named-makeUnconfined-as-network-service-installer —
  lines 33-40: `E(powers).makeUnconfined(undefined,
  wsRelaySpecifier, { powersName: '@agent', resultName:
  'network-service-ws-relay', env: { ... } })`. The
  makeUnconfined call creates the network service formula
  by loading the ws-relay.js specifier with the given env.
  §the-named-makeUnconfined-as-formula-factory as tier-3
  meta-pattern.

  §The-named-move-from-arbitrary-name-to-nets-namespace —
  line 42: `await E(powers).move(['network-service-ws-
  relay'], ['@nets', 'ws-relay']);`. After install, the
  formula is RELOCATED from the arbitrary install name
  `network-service-ws-relay` to the canonical namespace
  path `@nets/ws-relay`. §the-named-install-then-move-to-
  canonical-path as tier-3 meta-pattern; the install
  creates a formula under any name, then a move places it
  at the well-known address.

  §The-named-NETS-prefix-as-network-namespace — `@nets`
  is the daemon's network-service namespace (per the move
  target). §the-named-at-prefixed-namespaces-in-daemon-
  registry as tier-3 meta-pattern; the daemon has
  multiple @-prefixed namespaces (@nets for networks,
  @agent for self, etc.) accessible via path syntax.

  §The-named-result-string-as-success-confirmation — line
  44: `return 'ws-relay network installed at NETS/ws-relay
  (relay: ${relayUrl})';`. The runlet returns a human-
  readable success string. Cycle 391 lore said runlets are
  "not expected to return anything"; this runlet DOES
  return something, suggesting the lore is loose, not
  strict. §the-named-runlet-may-return-message-anyway as
  tier-3 meta-pattern.

  §The-named-harden-main-as-export-discipline — line 46:
  `harden(main);`. Every named export gets a harden() call
  per CLAUDE.md (line 7 of the bot-fork CLAUDE.md: "Every
  named export MUST have a corresponding `harden(
  exportName)` call immediately after the declaration").
  §the-named-harden-after-named-export as tier-3 meta-
  pattern; the discipline applies even to runlets.

  §The-named-import-from-eventual-send-for-E — line 8:
  `import { E } from '@endo/eventual-send';`. The E()
  remote-call mechanism is imported as a named entity.
  Cycle 321 named eventual-send's E; cycle 392 shows a
  runlet using it.

  §The-named-JSDoc-ERef-type-import — line 10: `/**
  @import { ERef } from '@endo/eventual-send' */`. The
  JSDoc @import syntax from cycle 376 + cycle 387 AGENTS.
  md applied here.

  Closes seven citation arcs: cycle 391 (1, adjacent
  forward; daemon-lore vocabulary → concrete runlet in
  source; lore-vocabulary-realized-in-source new framing)
  + cycle 369 (4, @endo/daemon README named the daemon as
  application runner; cycle 392 shows the runlet installs
  a network service formula at @nets/ws-relay) + cycle
  385 (2, @endo/chat README named CapTP-over-WebSocket;
  the ws-relay network module presumably provides the
  WebSocket transport) + cycle 367 (12, exo's powers
  pattern is the parameter shape used by makeUnconfined)
  + cycle 321 (12, eventual-send E() is the call
  mechanism) + cycle 326 (66, pure-naming-as-discipline)
  + cycle 322 (66, errors not directly invoked in this
  runlet). Pushes citation-arc-closures-in-pivot to FOUR-
  HUNDRED-TWENTY-THREE (416 + 7 net new).
---

46-line setup-ws-relay.js, a concrete runlet that installs a WebSocket relay network module into the daemon. Chat-lane after cycle 391 designs-lane daemon-lore. §the-named-runlet-as-named-program-shape-in-source (single most structurally interesting move; the cycle 391 lore vocabulary maps directly to this source shape); §the-named-lore-vocabulary-realized-in-source. §the-named-Usage-comment-as-self-documenting-command; §the-named-usage-as-header-comment. §the-named-requires-powers-agent-explicit-comment (authority requirement with reason); §the-named-authority-requirement-with-reason. §the-named-edit-defaults-below-comment. §the-named-runlet-installs-caplet (runlet/caplet relationship: runlet bootstraps daemon's caplet registry). §the-named-env-var-with-or-default-pattern. §the-named-public-default-relay-wss-endo-relay-fly-dev. §the-named-formula-env-persists-across-reincarnation (runlet env becomes part of persisted formula state). §the-named-makeUnconfined-as-network-service-installer. §the-named-move-from-arbitrary-name-to-nets-namespace (install-then-move-to-canonical-path discipline). §the-named-NETS-prefix-as-network-namespace; §the-named-at-prefixed-namespaces-in-daemon-registry. §the-named-result-string-as-success-confirmation (lore said "not expected to return anything"; this runlet does return — §the-named-runlet-may-return-message-anyway). §the-named-harden-main-as-export-discipline. §the-named-import-from-eventual-send-for-E. §the-named-JSDoc-ERef-type-import. Seven citation arcs closed.
