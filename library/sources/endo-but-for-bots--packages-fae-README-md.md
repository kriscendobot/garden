---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/README.md
source_line_range: 1-230
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 419 designs-lane ingest. 230-line README.md for
  @endo/fae — Fae's own self-description (distinct from
  the COMPARISON documents cycles 415, 417 read). Sixty-
  seventh AUTHORED conformant single-body section doc in
  post-refactor era. One-hundred-and-nine consecutive non-
  garden sources after the pivot (310-419). §one-hundred-
  and-nine-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  fae-as-multi-agent-factory-with-three-caplet-layers —
  lines 3-29 reveal a STRUCTURAL difference between Fae
  and Lal the cluster's prior framings had not articulated.
  Lal IS an agent (one caplet, one loop). Fae is a
  FACTORY caplet that creates named agent instances —
  multiple agents per Fae deployment. The architecture has
  THREE caplet layers per agent: (1) LLM Provider Factory
  (presents config form to HOST); (2) Fae Factory (creates
  agent instances via createAgent(name, options)); (3)
  Driver (per-agent caplet running the inbox/LLM loop).
  §the-named-three-layer-factory-driver-caplet-
  architecture as tier-3 meta-pattern. The cluster's
  Fae-vs-Lal framings now extend to AGENT CARDINALITY:
  Lal is one agent; Fae is a factory for multiple named
  agents. The 2D design space from cycle 417 gains
  another dimension: agent-cardinality.

  §the-named-PINS-as-restart-survival-mechanism — lines
  30-38: "Agents created with `pin: true` survive `endo
  restart`. The driver caplet's formula ID is written to
  the daemon's `PINS` directory. On startup,
  `revivePins()` calls `provide()` on each pinned formula,
  which re-imports `driver.js`, calls `make()`, looks up
  the provider config and agent guest from the driver's
  namespace, and restarts `spawnWorkerLoop`. Unpinned
  agents are not restored." Cycle 415's COMPARISON said
  Lal has no session persistence — Fae has a DIFFERENT
  mechanism (PINS) for restart survival. §the-named-
  pinning-as-explicit-persistence as tier-3 meta-pattern.

  §the-named-revivePins-as-rehydration-on-startup — line
  33-37. The daemon's startup hook calls provide() on
  each pinned formula. §the-named-formula-id-pin-as-
  rehydration-handle as tier-3 meta-pattern.

  §the-named-sixth-document-joins-opus-4-5-faction —
  line 46: "claude-opus-4-5-20251101 (Anthropic)" in
  the README's defaults table. Cluster's drift cluster
  now has SIX documents:
  - Faction A (sonnet-4-6): lal/config.js + lal/setup.js
    (2 docs)
  - Faction B (opus-4-5): lal/README + lal/LAL-
    ARCHITECTURE + fae/COMPARISON-FAE-LAL + **fae/
    README** (4 docs)
  - Faction C (3-5-sonnet-20241022): lal/simulator/
    README (1 doc)
  §the-named-drift-factions-extend-across-packages as
  tier-3 meta-pattern; the faction membership now
  spans fae and lal packages. The drift is not
  package-local.

  §the-named-fae-tool-count-9-vs-comparison-8 — lines
  137-141 list NINE built-in tools (list + lookup +
  store + remove + send + reply + listMessages +
  dismiss + adoptTool). But cycle 415's COMPARISON-
  FAE-LAL.md said "8 built-in + unlimited adopted
  tools" (line 18). NINE vs EIGHT — drift WITHIN one
  package (fae). The README and COMPARISON disagree.
  §the-named-fae-internal-tool-count-drift as tier-3
  meta-pattern; cluster's tool-count-drift framing
  recurs within ONE package, mirroring earlier intra-
  package drift in lal (cycles 401-407).

  §the-named-adoptTool-as-meta-tool-for-runtime-
  extension — line 141: "adoptTool — adopt a tool
  capability from an incoming message." The
  distinctive Fae tool — the META-TOOL that enables
  dynamic tool discovery (cycles 415, 416 framings).
  §the-named-meta-tool-as-self-extension-primitive as
  tier-3 meta-pattern.

  §the-named-tools-categorized-as-examples-vs-real —
  lines 222-229: tools/ directory has TWO classes:
  example tools (greet, math, timestamp — toy
  examples) and filesystem tools (read-file, write-
  file, edit-file, list-dir, run-command — real fs
  access constrained to FAE_CWD). §the-named-toy-
  vs-real-tool-classification as tier-3 meta-pattern.

  §the-named-fourth-env-var-namespace-FAE_CWD — line
  157: `FAE_CWD=/path/to/project yarn setup-fs-tools`.
  The cluster's env-var collection grows to four:
  - ENDO_LLM_* (cycle 410 setup-script outer)
  - LAL_* (cycle 400/406 provider-internal)
  - form-field names (cycle 410 submission middle)
  - FAE_CWD (cycle 419 fae-tool-internal)
  §the-named-four-env-var-namespaces-across-packages
  as tier-3 meta-pattern; cycle 410's three-namespace
  framing extends to four with a new package.

  §the-named-fae-uses-chat-package-for-UI — lines 168-
  178: "Start the @endo/chat UI in a separate terminal:
  cd packages/chat; yarn dev. Open http://localhost:
  5173." Fae depends on @endo/chat for its UI. §the-
  named-cross-package-UI-dependency as tier-3 meta-
  pattern. Cluster's package dependency map: fae →
  lal (providers), fae → conversation-tree
  (transcript), fae → chat (UI). Three external
  dependencies named.

  §the-named-fae-allows-per-agent-custom-system-prompt
  — lines 127-130: `createAgent('poet', { pin: true,
  systemPrompt: 'You are a poet. Respond only in
  verse.' })`. Fae allows per-agent custom system
  prompts. Cycle 415 said Lal has a hardcoded ~2500-
  word system prompt; Fae has a default AND per-
  agent override. §the-named-customizable-system-
  prompt-per-agent as tier-3 meta-pattern; cycle 415's
  framing refined.

  §the-named-agent-name-as-lowercase-noun — lines 121-
  130: example agent names are `'fae'`, `'researcher'`,
  `'scratchpad'`, `'poet'`. Lowercase nouns, no @-
  prefix, single-word descriptors. §the-named-
  descriptive-agent-name-convention as tier-3 meta-
  pattern; sibling to cycle 411's pet-name format.

  §the-named-at-fae-addressing-in-chat — line 178:
  "Send messages with `@fae Hello!`." @-addressing
  reaches the Fae agent by name. Cycle 405's chat-
  supports-slash-and-at-addressing framing confirmed
  at the cross-package level.

  §the-named-as-flag-for-agent-impersonation — line
  187: "yarn endo inbox --as fae". The endo CLI
  supports impersonation via --as. The maintainer can
  see the agent's inbox AS the agent. §the-named-CLI-
  impersonation-as-debugging-affordance as tier-3
  meta-pattern.

  §the-named-tool-transfer-via-chat-message-with-at-
  reference — line 164: `@fae Here is a timestamp
  tool @timestamp-tool`. Example of tool transfer via
  chat — user sends Fae a tool capability via @-
  reference; Fae adopts and uses it. §the-named-user-
  facing-capability-passing-via-at-reference as tier-
  3 meta-pattern; the capability-passing model in
  user-facing form. Concrete instance of the cycle
  415 framing for FaeTool as capability.

  §the-named-purge-as-destructive-reset — line 196:
  `yarn endo purge -f` to start over. Destructive
  operation. §the-named-purge-as-fresh-start as
  tier-3 meta-pattern.

  §the-named-three-step-setup-pattern — lines 74-100:
  three explicit steps: setup, create-provider,
  setup-factory. Each step is a separate yarn command.
  Sibling to cycle 410's lal three-step-provisioning-
  flow but at a different layer — Fae's setup is
  also three-step but for the FACTORY architecture.
  §the-named-fae-three-step-setup-mirrors-lal-three-
  step-setup as tier-3 meta-pattern.

  §the-named-fae-Anthropic-default-required-vs-optional
  — line 47: "API key (required for Anthropic,
  optional for local)". Cycle 406's asymmetric-auth-
  requirement framing confirmed at the README level.

  §the-named-sixty-seven-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 418 (1, adjacent
  forward; conversation-tree's interface-tax framing
  parallels Fae's factory-architecture interface
  tax — multiple caplet layers per agent) + cycle 417
  (5, agent-cardinality dimension joins the 2D design
  space from cycle 417 — now 3D) + cycle 415 (5, Fae-
  internal-tool-count-drift (9 vs 8) mirrors Lal-
  internal-tool-count-drift from cycles 401-407) +
  cycle 410 (5, fourth env-var namespace extends
  cycle 410's three-namespace framing; cluster's
  three-step-setup pattern repeats at the package
  level) + cycle 405 (3, @-addressing in chat
  confirmed at cross-package level) + cycle 411 (3,
  agent-name-as-lowercase-noun sibling to pet-name
  format) + cycle 326 (75) + cycle 322 (75) + cycle
  364 (4, shapes count with new dimension) + cycle
  387 (3, branded-types via createAgent options).
  Pushes citation-arc-closures-in-pivot to SIX-
  HUNDRED-AND-FIFTY-FOUR (644 + 10 net new).
---

230-line README.md for @endo/fae — Fae's own self-description (distinct from COMPARISON documents). Designs-lane after cycle 418 chat-lane conversation-tree/src/memory-backend.js. **Single most structurally interesting move**: §the-named-fae-as-multi-agent-factory-with-three-caplet-layers — *Fae is a FACTORY caplet that creates named agent instances (multiple agents per deployment) — Lal IS an agent (one caplet, one loop). Fae's architecture has THREE caplet layers per agent: Provider Factory + Fae Factory + per-agent Driver. The cluster's 2D design space from cycle 417 gains another dimension: agent-cardinality.* §the-named-three-layer-factory-driver-caplet-architecture as tier-3 meta-pattern. §the-named-PINS-as-restart-survival-mechanism (Fae has explicit persistence Lal lacks); §the-named-pinning-as-explicit-persistence. §the-named-revivePins-as-rehydration-on-startup; §the-named-formula-id-pin-as-rehydration-handle. §the-named-sixth-document-joins-opus-4-5-faction (fae/README joins the faction — 4 docs in opus-4-5, 2 in sonnet-4-6, 1 in 3-5-sonnet); §the-named-drift-factions-extend-across-packages (drift is not package-local). §the-named-fae-tool-count-9-vs-comparison-8 (README says 9 built-in tools; COMPARISON-FAE-LAL said 8 — drift WITHIN fae package); §the-named-fae-internal-tool-count-drift (cycle 401-407 lal-internal-tool-count-drift recurs in fae). §the-named-adoptTool-as-meta-tool-for-runtime-extension; §the-named-meta-tool-as-self-extension-primitive. §the-named-tools-categorized-as-examples-vs-real; §the-named-toy-vs-real-tool-classification. §the-named-fourth-env-var-namespace-FAE_CWD (cycle 410's three-namespace extends to four: ENDO_LLM_* + LAL_* + form-fields + FAE_CWD); §the-named-four-env-var-namespaces-across-packages. §the-named-fae-uses-chat-package-for-UI; §the-named-cross-package-UI-dependency (fae → lal + conversation-tree + chat). §the-named-fae-allows-per-agent-custom-system-prompt (cycle 415's Lal-hardcoded-prompt refined: Fae has default + per-agent override); §the-named-customizable-system-prompt-per-agent. §the-named-agent-name-as-lowercase-noun; §the-named-descriptive-agent-name-convention. §the-named-at-fae-addressing-in-chat. §the-named-as-flag-for-agent-impersonation (CLI debugging affordance); §the-named-CLI-impersonation-as-debugging-affordance. §the-named-tool-transfer-via-chat-message-with-at-reference; §the-named-user-facing-capability-passing-via-at-reference. §the-named-purge-as-destructive-reset. §the-named-three-step-setup-pattern; §the-named-fae-three-step-setup-mirrors-lal-three-step-setup (cycle 410's three-step-provisioning-flow recurs at fae level). §the-named-fae-Anthropic-default-required-vs-optional (confirms cycle 406's asymmetric-auth-requirement). §the-named-sixty-seven-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-FIFTY-FOUR.
