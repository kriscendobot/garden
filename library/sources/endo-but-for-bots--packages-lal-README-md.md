---
source_kind: repo-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/README.md
source_line_range: 1-50
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 399 designs-lane ingest. 50-line README for @endo/
  lal, the bot-fork's LLM-powered agent caplet that runs
  on the @endo/daemon. Forty-seventh AUTHORED conformant
  single-body section doc in post-refactor era. Eighty-
  ninth consecutive non-garden source after the pivot
  (310-399). §eighty-nine-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  lal-as-LLM-agent-caplet-with-five-tool-capabilities —
  lal is a concrete instance of the AGENT-AS-CAPLET shape
  that cycle 391 daemon-lore named in the abstract. The
  agent uses LLM tool calls to interact with the daemon
  via FIVE named capability surfaces: (1) manage pet
  names (list/lookup/remove/move/copy); (2) send and
  receive messages; (3) adopt capabilities from messages;
  (4) request capabilities from its host; (5) inspect
  capabilities via help() methods. §the-named-LLM-agent-
  as-named-caplet-shape as tier-3 meta-pattern; LLM
  agents are caplets that happen to use LLM internally
  for decision-making, parameterized over the daemon's
  capability graph.

  §The-named-tool-calls-as-named-capability-invocations
  — the LLM tool calls translate to capability
  invocations on the daemon. The TOOL ABSTRACTION at the
  LLM layer maps to the CAPABILITY ABSTRACTION at the
  daemon layer. §the-named-LLM-tool-capability-bridge as
  tier-3 meta-pattern; the lal agent IS the bridge
  between LLM-world tool-calls and daemon-world capability
  invocations.

  §The-named-LAL_HOST-anthropic-vs-llama-cpp-dispatch —
  lines 16-17: "If `LAL_HOST` contains `anthropic.com`,
  the Anthropic provider is used; otherwise the llama.cpp
  (OpenAI-compatible) provider is used." HEURISTIC
  PROVIDER DISPATCH via URL string match. §the-named-
  heuristic-provider-dispatch-via-url-match as tier-3
  meta-pattern; the dispatch logic is not via config
  declaration but via URL inspection at runtime.

  §The-named-five-env-var-config-surface — LAL_HOST +
  LAL_MODEL + LAL_AUTH_TOKEN + LAL_MAX_TOKENS + LAL_MAX_
  MESSAGES. Five environment variables configure the
  agent. §the-named-five-env-var-as-LLM-config-surface as
  tier-3 meta-pattern.

  §The-named-LAL_MAX_MESSAGES-truncation-as-context-size-
  workaround — lines 25 + 33-34: "Truncate to last N
  messages before sending (avoids context-size errors)";
  "For a llama.cpp server that returns 'context size'
  errors, set `LAL_MAX_MESSAGES` (e.g. to `30`) to send
  only the last N messages and stay under the server's
  limit." Workaround for a real LLM constraint surfaced
  in the config. §the-named-context-window-as-config-
  knob as tier-3 meta-pattern.

  §The-named-four-example-env-files — local.env.example +
  cloud.env.example + openai.env.example + opus.env.
  example. Four deployment shapes with named example
  files: local Ollama, cloud Ollama with auth, OpenAI-
  compatible, Anthropic Opus. §the-named-deployment-
  shape-examples-as-files as tier-3 meta-pattern.

  §The-named-claude-opus-4-5-as-named-default-model —
  line 22: "claude-opus-4-5-20251101" as Anthropic
  default. The README dates from when claude-opus-4-5
  (= Opus 4.5) was the recent default. Sibling shape to
  cycle 360's Agoric-specific-plugin attribution fossil —
  both name a moment in time via the version they pin.
  §the-named-default-model-as-time-fossil as tier-3
  meta-pattern.

  §The-named-four-step-agent-lifecycle — lines 46-50:
  (1) Create a guest profile named `lal`; (2) Start
  monitoring its inbox for messages; (3) Respond to
  messages using LLM-driven tool calls; (4) Send replies
  back to message senders. §the-named-create-monitor-
  respond-reply as tier-3 meta-pattern; the LLM agent's
  lifecycle is an event-loop with explicit phases.

  §The-named-llama-cpp-as-OpenAI-compatible — line 17
  notes "llama.cpp (OpenAI-compatible) provider." The
  agent's design treats llama.cpp's OpenAI-compatibility
  as a single named provider. §the-named-protocol-
  compatibility-as-named-provider-conflation as tier-3
  meta-pattern; multiple backends can share one provider
  identifier if they speak the same wire protocol.

  §The-named-source-your-configuration-as-shell-idiom —
  line 40: `source local.env.example`. The README uses
  bash `source` to load environment variables. §the-
  named-source-pattern-as-config-loading as tier-3 meta-
  pattern; the configuration mechanism is shell-native.

  §The-named-fifty-line-README-for-LLM-agent-package — a
  substantial LLM-agent caplet documented in 50 lines.
  Sibling shape to cycle 369's daemon (14-line README,
  substantial system) and earlier minimal-but-rich
  examples.

  Closes seven citation arcs: cycle 398 (1, adjacent
  forward; check-bundle utility → lal as actual agent
  consumer) + cycle 391 (3, caplet definition from
  daemon-lore; lal is a concrete LLM-agent caplet) +
  cycle 392 (2, runlet/caplet relationship; lal is a
  caplet that runlets like setup-ws-relay can install) +
  cycle 381 (3, @endo/genie was the bot-fork's agent
  FRAMEWORK; @endo/lal is one concrete agent built using
  the framework substrate — genie + lal pair) + cycle
  374 (8, social-network-already-shipping; lal is the
  LLM-driven participant in the social network) +
  cycle 326 (74, pure-naming-as-discipline) + cycle 322
  (74, @endo/errors not directly invoked). Pushes
  citation-arc-closures-in-pivot to FOUR-HUNDRED-SEVENTY-
  TWO (465 + 7 net new).
---

50-line README for @endo/lal, the bot-fork's LLM-powered agent caplet. §the-named-lal-as-LLM-agent-caplet-with-five-tool-capabilities (single most structurally interesting move; concrete instance of agent-as-caplet shape from cycle 391); §the-named-LLM-agent-as-named-caplet-shape. §the-named-tool-calls-as-named-capability-invocations; §the-named-LLM-tool-capability-bridge (lal IS the bridge between LLM-world tool-calls and daemon-world capability invocations). §the-named-LAL_HOST-anthropic-vs-llama-cpp-dispatch; §the-named-heuristic-provider-dispatch-via-url-match. §the-named-five-env-var-config-surface; §the-named-five-env-var-as-LLM-config-surface. §the-named-LAL_MAX_MESSAGES-truncation-as-context-size-workaround; §the-named-context-window-as-config-knob. §the-named-four-example-env-files (local + cloud + openai + opus); §the-named-deployment-shape-examples-as-files. §the-named-claude-opus-4-5-as-named-default-model; §the-named-default-model-as-time-fossil. §the-named-four-step-agent-lifecycle (Create + Monitor + Respond + Reply); §the-named-create-monitor-respond-reply. §the-named-llama-cpp-as-OpenAI-compatible; §the-named-protocol-compatibility-as-named-provider-conflation. §the-named-source-your-configuration-as-shell-idiom. §the-named-fifty-line-README-for-LLM-agent-package. Seven citation arcs closed.
