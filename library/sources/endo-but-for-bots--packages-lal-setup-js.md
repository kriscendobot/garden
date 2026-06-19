---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/setup.js
source_line_range: 1-105
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 410 chat-lane ingest. 105-line setup.js, the
  provisioning entry point that launches the lal agent
  inside the Endo daemon. Twelfth lal-package artifact in
  the cluster. **ONE-HUNDREDTH consecutive non-garden
  source after the pivot — session-level milestone.**
  Fifty-eighth AUTHORED conformant single-body section
  doc in post-refactor era. §one-hundred-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  three-env-var-namespaces-for-same-config — setup.js
  reveals that the lal configuration flows through THREE
  distinct naming systems at THREE layers:
  1. OUTER (maintainer-facing): ENDO_LLM_HOST,
     ENDO_LLM_MODEL, ENDO_LLM_AUTH_TOKEN, ENDO_LLM_NAME
     (lines 65, 67-70). The setup script reads these
     from process.env.
  2. MIDDLE (form-submission inter-component): { name,
     host, model, authToken } (line 98). The setup
     script submits these to the form. No "ENDO_LLM_"
     or "LAL_" prefix; just the field names.
  3. INNER (agent-internal): LAL_HOST, LAL_MODEL,
     LAL_AUTH_TOKEN, LAL_MAX_TOKENS, LAL_MAX_MESSAGES
     (cycles 400 + 406). The provider factory reads
     these from its own env parameter.
  §the-named-three-namespaces-for-one-config-flow as
  tier-3 meta-pattern. Three setup layers; three
  prefix conventions; the same conceptual config.

  §the-named-three-namespaces-as-parallel-to-three-
  surfaces — cycle 405 named three SURFACES for three
  AUDIENCES (LLM tool catalog + guest-power method
  surface + user-facing Chat slash commands). Cycle 410
  names three NAMESPACES for three LAYERS of the same
  CONFIG. Structural parallel: layered systems
  routinely have one naming per layer. §the-named-
  per-layer-naming-convention as tier-3 meta-pattern.

  §the-named-fourth-document-drift-faction-confirmed —
  line 7's example: `ENDO_LLM_MODEL=claude-sonnet-4-6-
  20250514`. This AGREES with cycle 400's source
  default (config.js line 31). The Anthropic-default
  model strings across lal-package documents now fall
  into THREE FACTIONS:
  - Faction A (sonnet-4-6): config.js source + setup.
    js example agree.
  - Faction B (opus-4-5): README + LAL-ARCHITECTURE.md
    agree.
  - Faction C (3-5-sonnet-20241022): simulator README
    stands alone.
  §the-named-document-drift-factions as tier-3 meta-
  pattern. Refines cycle 403's three-model-strings
  framing — not just three strings but three
  factions of mutually-agreeing documents. The
  document tier has stratified into factions.

  §the-named-introducedNames-with-at-agent-pointing-
  to-host-agent — line 53: `introducedNames: harden({
  '@agent': 'host-agent' })`. The canonical idiom for
  giving a guest a reference to the host agent.
  §the-named-canonical-introducedNames-idiom as tier-
  3 meta-pattern.

  §the-named-makeUnconfined-as-daemon-API-equivalent-
  to-CLI-flag — line 58: `await E(agent).makeUnconfined
  ('@main', lalSpecifier, { ... })`. UNCONFINED is
  available both via the CLI `--UNCONFINED` flag
  (cycle 409) AND via the daemon's makeUnconfined
  method. §the-named-privilege-mode-via-CLI-flag-or-
  daemon-method as tier-3 meta-pattern; two surfaces
  for the same privilege escalation.

  §the-named-idempotent-provisioning-via-has-check —
  lines 45-48. The setup script checks `await E(agent)
  .has('controller-for-lal')` and skips if already
  provisioned. §the-named-existence-check-as-
  idempotency-guard as tier-3 meta-pattern.

  §the-named-three-step-provisioning-flow — (1)
  provideGuest 'setup-lal' (line 52-56) if not
  present; (2) makeUnconfined to launch agent.js
  (line 58-61); (3) optionally submit form with env-
  derived config (line 84-102). §the-named-provision-
  launch-configure as tier-3 meta-pattern.

  §the-named-explicit-config-vs-reachability-probe-
  as-decision — lines 72-82. The setup decides whether
  to auto-submit the form based on: explicit env-var
  ANY-of-three-set OR Ollama reachability probe.
  Three branches: explicit-config → submit, no-config-
  and-reachable → submit defaults, no-config-and-
  unreachable → leave for manual. §the-named-three-
  branch-config-decision as tier-3 meta-pattern.

  §the-named-isOllamaReachable-probe-via-fetch-v1-
  models — lines 21-32. The reachability probe
  fetches `${host}/v1/models` with a 3-second timeout.
  Lightweight endpoint chosen specifically for liveness
  check. §the-named-lightweight-endpoint-as-liveness-
  probe as tier-3 meta-pattern.

  §the-named-followMessages-with-filter-and-
  reverseLocate — lines 89-102. The setup script
  watches the inbox for a form-type message from a
  sender it identifies via reverseLocate. The
  canonical pattern: followMessages + type filter +
  sender check. §the-named-canonical-inbox-watch-
  pattern as tier-3 meta-pattern.

  §the-named-reverseLocate-as-inverse-of-locate —
  line 94: `const [fromName] = await E(agent).
  reverseLocate(message.from)`. Inverse of locate
  (cycle 407 named): locate returns a URL; reverseLocate
  takes a URL and returns the pet-name array. §the-
  named-locate-and-reverseLocate-as-inverse-pair as
  tier-3 meta-pattern.

  §the-named-ollama-as-dummy-auth-token-recurs — line
  69: `const authToken = env.ENDO_LLM_AUTH_TOKEN ||
  'ollama'`. SAME pattern as cycle 406's providers/
  index.js. The literal string 'ollama' appears as a
  dummy auth token in TWO files. §the-named-ollama-
  string-as-dummy-auth-across-files as tier-3 meta-
  pattern.

  §the-named-qwen3-as-default-model-consistent-across-
  files — line 68: `const model = env.ENDO_LLM_MODEL
  || 'qwen3'`. Cycle 400's config.js had defaultModels.
  ollama = 'qwen3'. Setup.js and config.js AGREE on
  qwen3. Internal consistency on Ollama default;
  inconsistency on Anthropic default (three
  factions). §the-named-ollama-default-stable-vs-
  anthropic-default-fragmented as tier-3 meta-
  pattern.

  §the-named-harden-on-main-export — line 104:
  `harden(main)`. setup.js DOES follow the harden-
  every-export convention. Cycle 406's providers/
  index.js and cycle 408's providers/anthropic.js do
  NOT. §the-named-harden-discipline-inconsistent-
  across-package confirms cycle 406's framing with
  another data point: setup.js follows, providers/
  do not.

  §the-named-setup-as-CLI-invocation-via-comment —
  line 4: `// endo run --UNCONFINED setup.js
  --powers @agent`. The file opens with the
  CLI invocation that runs it. §the-named-CLI-
  invocation-as-file-header-comment as tier-3 meta-
  pattern.

  §the-named-no-await-in-loop-eslint-disable — lines
  93, 97: `// eslint-disable-next-line no-await-
  in-loop`. The followMessages loop intentionally
  awaits per-message; the lint rule is silenced.
  §the-named-sequential-await-in-loop-as-intentional
  as tier-3 meta-pattern.

  §the-named-lalSpecifier-as-resolved-URL — line 13:
  `const lalSpecifier = new URL('agent.js', import.
  meta.url).href`. Resolves agent.js relative to
  setup.js's module URL. §the-named-import-meta-
  url-as-module-anchor as tier-3 meta-pattern.

  §the-named-config-via-form-not-env-after-
  provisioning — setup.js calls makeUnconfined
  WITHOUT an env parameter (lines 58-61). The agent
  gets config via FORM submission, not via env. The
  inner CLAUDE.md confirmed this: "LLM provider
  configuration (host, model, auth token) is received
  via forms at runtime, not environment variables."
  §the-named-form-as-runtime-config-channel as tier-3
  meta-pattern.

  §the-named-cycle-410-as-one-hundredth-post-pivot —
  the structural fact: cycle 410 is the ONE-HUNDREDTH
  consecutive non-garden source after the pivot
  (310-410). §the-named-one-hundred-post-pivot-cycles-
  reached as session-level observation.

  §the-named-fifty-eight-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 409 (1, adjacent
  forward; the define-endow attenuation pattern this
  agent will use is launched by setup.js) + cycle 408
  (3, providers/anthropic.js dispatched eventually
  from form-config submitted here) + cycle 407 (3,
  primer-tool catalog the agent uses is loaded after
  setup.js launches it) + cycle 405 (5, three-
  namespaces parallels three-surfaces structural
  framing) + cycle 403 (5, three-Claude-model-strings
  now refined to three-factions with setup.js
  agreeing with config.js source) + cycle 401 (3,
  design doc described form-based config — setup.js
  confirms) + cycle 400 (3, qwen3-as-ollama-default
  consistent between config.js and setup.js;
  Anthropic default disagrees) + cycle 406 (3,
  harden-discipline-inconsistent-across-package
  confirmed — setup.js follows, providers/ don't) +
  cycle 326 (75) + cycle 322 (75). Pushes citation-
  arc-closures-in-pivot to FIVE-HUNDRED-AND-SIXTY-
  NINE (559 + 10 net new).
---

105-line setup.js, the provisioning entry point that launches the lal agent inside the Endo daemon. Twelfth lal-package artifact in the cluster. **CYCLE 410 IS THE ONE-HUNDREDTH POST-PIVOT CYCLE** — session-level milestone. Chat-lane after cycle 409 designs-lane primer/howto-code.md. **Single most structurally interesting move**: §the-named-three-env-var-namespaces-for-same-config — *the lal configuration flows through THREE distinct naming systems at THREE layers: OUTER (ENDO_LLM_*; maintainer-facing) → MIDDLE (form-field names {name, host, model, authToken}; submission layer) → INNER (LAL_*; agent-internal). Three setup layers; three prefix conventions; the same conceptual config.* §the-named-three-namespaces-for-one-config-flow as tier-3 meta-pattern. §the-named-three-namespaces-as-parallel-to-three-surfaces (cycle 405 named three surfaces; cycle 410 names three namespaces — same per-layer naming pattern); §the-named-per-layer-naming-convention as tier-3 meta-pattern. §the-named-fourth-document-drift-faction-confirmed (line 7's example uses `claude-sonnet-4-6-20250514` AGREEING with cycle 400's source — the four lal-package documents now form THREE FACTIONS: sonnet-4-6 {config.js + setup.js}, opus-4-5 {README + LAL-ARCHITECTURE}, 3-5-sonnet {simulator README alone}); §the-named-document-drift-factions as tier-3 meta-pattern. §the-named-introducedNames-with-at-agent-pointing-to-host-agent; §the-named-canonical-introducedNames-idiom. §the-named-makeUnconfined-as-daemon-API-equivalent-to-CLI-flag; §the-named-privilege-mode-via-CLI-flag-or-daemon-method. §the-named-idempotent-provisioning-via-has-check; §the-named-existence-check-as-idempotency-guard. §the-named-three-step-provisioning-flow; §the-named-provision-launch-configure. §the-named-explicit-config-vs-reachability-probe-as-decision; §the-named-three-branch-config-decision. §the-named-isOllamaReachable-probe-via-fetch-v1-models; §the-named-lightweight-endpoint-as-liveness-probe. §the-named-followMessages-with-filter-and-reverseLocate; §the-named-canonical-inbox-watch-pattern. §the-named-reverseLocate-as-inverse-of-locate; §the-named-locate-and-reverseLocate-as-inverse-pair. §the-named-ollama-as-dummy-auth-token-recurs; §the-named-ollama-string-as-dummy-auth-across-files. §the-named-qwen3-as-default-model-consistent-across-files (Ollama default stable across config.js and setup.js); §the-named-ollama-default-stable-vs-anthropic-default-fragmented. §the-named-harden-on-main-export (setup.js follows; providers/ don't); §the-named-harden-discipline-inconsistent-across-package (confirmed again). §the-named-setup-as-CLI-invocation-via-comment; §the-named-CLI-invocation-as-file-header-comment. §the-named-no-await-in-loop-eslint-disable. §the-named-lalSpecifier-as-resolved-URL; §the-named-import-meta-url-as-module-anchor. §the-named-config-via-form-not-env-after-provisioning; §the-named-form-as-runtime-config-channel. §the-named-cycle-410-as-one-hundredth-post-pivot; §the-named-one-hundred-post-pivot-cycles-reached as session-level observation. §the-named-fifty-eight-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-SIXTY-NINE.
