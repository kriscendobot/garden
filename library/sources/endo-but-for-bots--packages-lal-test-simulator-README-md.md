---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/test/simulator/README.md
source_line_range: 1-55
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 403 designs-lane ingest. 54-line README.md for
  @endo/lal's simulator testing harness. Fifth lal-package
  artifact in the cluster after cycle 399's lal README,
  cycle 400's providers/config.js source, cycle 401's
  LAL-ARCHITECTURE.md design doc, and cycle 402's
  agent.types.d.ts. Fifty-first AUTHORED conformant
  single-body section doc in post-refactor era. Ninety-
  three consecutive non-garden sources after the pivot
  (310-403). §ninety-three-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  mock-internals-real-externals — the simulator inverts
  the usual mocking arrangement. Most simulators mock the
  external service (the LLM provider) and exercise the
  real internal code. This simulator does the opposite:
  it MOCKS the internal daemon (mock-powers.js provides
  fake EndoGuest implementations) but uses the REAL
  external LLM provider (lines 3-5: "real LLM providers
  (Anthropic, OpenAI, llama.cpp) using mock guest powers
  instead of a full Endo daemon"). The purpose: "debug
  provider configuration, auth, and behavior without
  starting the daemon" (line 5). The bifurcation flips
  the usual test-time mock surface. §the-named-inverted-
  mock-surface-real-external-mock-internal as tier-3
  meta-pattern.

  §the-named-three-different-Claude-models-across-four-
  documents — line 21 shows `LAL_MODEL=claude-3-5-
  sonnet-20241022` as the example model. Cycle 399 README
  said `claude-opus-4-5-20251101`. Cycle 400 source said
  `claude-sonnet-4-6-20250514`. The simulator README's
  example uses `claude-3-5-sonnet-20241022` — a THIRD
  distinct Claude model string, dated 2024-10-22 (much
  older than either of the other two). The lal package
  now contains THREE different default Claude model
  strings across FOUR documents (README + LAL-
  ARCHITECTURE + source-default + simulator-example).
  §the-named-three-model-strings-across-four-documents-
  in-one-package as tier-3 meta-pattern. Extends cycle
  401's TWO-documents-agree-against-source framing —
  here it's THREE-documents-disagree-with-each-other and
  the source. The document tier has FURTHER stratified.

  §the-named-minimal-mock-only-enough-for-one-message —
  line 28: "Builds mock guest powers (in-memory
  directory, single inbox message)." The mock implements
  only as much as needed to deliver ONE message and
  observe ONE reply + dismiss. §the-named-minimal-test-
  setup-only-for-canonical-flow as tier-3 meta-pattern.

  §the-named-dual-entry-point-script-and-test — line 14
  ("yarn simulator") + line 43 ("yarn test
  test/simulator/run-simulator.test.js") expose the same
  flow as TWO entry points. The same code runs as a
  standalone debugging script AND as an Ava test in CI.
  §the-named-same-flow-via-script-and-test as tier-3
  meta-pattern.

  §the-named-credential-gated-test-skip — line 46: "If
  LAL_AUTH_TOKEN is not set for Anthropic, the test
  skips." The test gracefully degrades when credentials
  are missing rather than failing. §the-named-graceful-
  skip-on-missing-credentials as tier-3 meta-pattern;
  sibling to standard CI discipline.

  §the-named-mock-exposes-observation-hooks — lines
  51-52: the mock-powers.js exposes `whenDismissed(n)`
  and `sent` for the runner to wait and inspect.
  §the-named-test-mock-as-assertion-surface as tier-3
  meta-pattern. The mock is also the place where
  test-side observation hooks live.

  §the-named-two-minute-timeout-on-canonical-flow —
  line 31: "Waits until the agent dismisses that
  message (or 2-minute timeout)." 2-minute upper bound
  on the canonical reply+dismiss flow. §the-named-
  bounded-test-timeout-for-non-deterministic-LLM as
  tier-3 meta-pattern; sibling to standard AVA test
  timeouts but specifically calibrated for the non-
  deterministic LLM response time.

  §the-named-canonical-conversation-as-reply-and-dismiss
  — line 30: "asking the agent to reply and dismiss
  it." The smallest meaningful conversation in Lal is
  reply + dismiss — two tool calls. §the-named-minimum-
  agent-loop-iteration as tier-3 meta-pattern.

  §the-named-yarn-simulator-as-debugging-entry-point —
  the script is positioned as a DEBUGGING tool (not
  primarily a test) — "debug provider configuration,
  auth, and behavior." The same flow run as a test in
  CI is secondary. §the-named-debugging-script-first-
  test-second as tier-3 meta-pattern.

  §the-named-claude-3-5-sonnet-20241022-in-simulator —
  the specific model string `claude-3-5-sonnet-
  20241022`. Claude 3.5 sonnet (October 2024). Now
  superseded by Claude 4.x but still referenced in
  this example. Document drift in DEEP form: an
  example file references a model that has been
  deprecated for over a year. §the-named-stale-model-
  example-in-debugging-doc as tier-3 meta-pattern.

  §the-named-fifty-one-conformant-cycles-and-counting
  as session-level observation.

  Closes seven citation arcs: cycle 402 (1, adjacent
  forward; types file in the same package; the
  simulator README is the fifth artifact) + cycle 401
  (2, the design doc names the simulator briefly in
  the project layout but doesn't describe it; cycle
  403 reveals what the design doc omits) + cycle 400
  (3, source default is one of three model strings in
  the cluster; cycle 403 adds a third) + cycle 399 (3,
  README is another of three model strings) + cycle
  346 (3, name-aliasing patterns for the canonical
  reply/dismiss flow) + cycle 326 (75) + cycle 322
  (75). Pushes citation-arc-closures-in-pivot to
  FIVE-HUNDRED-AND-FIVE (498 + 7 net new). **The
  cluster crosses 500 citation-arc-closures.**
---

54-line README.md for @endo/lal's simulator testing harness. Fifth lal-package artifact in the cluster. Designs-lane after cycle 402 chat-lane lal agent.types.d.ts. **Single most structurally interesting move**: §the-named-mock-internals-real-externals — the simulator MOCKS the internal daemon but uses the REAL external LLM, INVERTING the usual test-time mock surface (most simulators mock externals and exercise real internals); §the-named-inverted-mock-surface-real-external-mock-internal as tier-3 meta-pattern. §the-named-three-different-Claude-models-across-four-documents (cycle 403 surfaces a THIRD model string `claude-3-5-sonnet-20241022` distinct from both cycle 399 README's opus-4-5 and cycle 400 source's sonnet-4-6 — lal package now has THREE different model strings across four documents); §the-named-three-model-strings-across-four-documents-in-one-package as tier-3 meta-pattern (the document tier has further stratified — cycle 401's TWO-documents-agree-against-source framing must now distinguish further between documents that agree and documents that disagree among themselves). §the-named-minimal-mock-only-enough-for-one-message; §the-named-minimal-test-setup-only-for-canonical-flow. §the-named-dual-entry-point-script-and-test; §the-named-same-flow-via-script-and-test. §the-named-credential-gated-test-skip; §the-named-graceful-skip-on-missing-credentials. §the-named-mock-exposes-observation-hooks; §the-named-test-mock-as-assertion-surface. §the-named-two-minute-timeout-on-canonical-flow; §the-named-bounded-test-timeout-for-non-deterministic-LLM. §the-named-canonical-conversation-as-reply-and-dismiss; §the-named-minimum-agent-loop-iteration. §the-named-yarn-simulator-as-debugging-entry-point; §the-named-debugging-script-first-test-second. §the-named-claude-3-5-sonnet-20241022-in-simulator; §the-named-stale-model-example-in-debugging-doc. §the-named-fifty-one-conformant-cycles-and-counting. Seven citation arcs closed; **pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-FIVE — cluster crosses 500.**
