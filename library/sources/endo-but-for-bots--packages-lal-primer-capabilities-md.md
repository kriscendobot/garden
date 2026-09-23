---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/capabilities.md
source_line_range: 1-149
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 411 designs-lane ingest. 148-line capabilities.md
  from @endo/lal's agent-facing primer. Thirteenth lal-
  package artifact in the cluster. Fifty-ninth AUTHORED
  conformant single-body section doc in post-refactor era.
  One-hundred-and-first consecutive non-garden source after
  the pivot (310-411). §one-hundred-and-one-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  result-flows-to-host-not-agent-in-define-endow — lines
  32-33: "You receive a receipt, not the result. The host
  sees the result in their inbox and may share it with
  you via reply()." Cycle 411 refines cycle 409's
  attenuation framing. Cycle 409 named define-endow as the
  attenuation pattern but did not specify WHERE the result
  goes. Cycle 411 reveals: the agent receives only a
  RECEIPT; the RESULT lives in the host's inbox/inventory;
  the host MAY share back via reply(). The authority flow
  is asymmetric in BOTH directions: host controls the
  input capability AND host controls whether the agent
  sees the result. §the-named-receipt-not-result-for-
  define as tier-3 meta-pattern. The agent's proposal
  yields no automatic output to the agent.

  §the-named-evaluate-result-stored-in-own-directory-vs-
  define-result-flows-to-host — evaluate's resultName
  stores the result IN THE AGENT's directory (line 43:
  "stores the result under resultName"); define's result
  flows to the HOST. evaluate is AGENT-CENTRIC; define
  is HOST-CENTRIC. The two patterns differ not just on
  WHO PROVIDES THE CAPABILITY (already known) but ALSO
  on WHO RECEIVES THE RESULT (newly named). §the-named-
  result-direction-as-second-asymmetry-between-evaluate-
  and-define as tier-3 meta-pattern.

  §the-named-define-preferred-CONDITIONALLY — lines 22-24:
  "Prefer `define()` when the user asks for code but you
  don't have all the required capabilities in your
  directory." Cycle 407 named define as PREFERRED (with
  "(PREFERRED)" annotation). Cycle 411 reveals the
  preference is CONDITIONAL: when the agent doesn't have
  the cap. If the agent DOES have the cap, evaluate is
  appropriate. §the-named-conditional-preference-on-
  inventory-state as tier-3 meta-pattern. Cycle 407's
  framing now refined to "conditionally preferred."

  §the-named-two-name-kinds-special-and-pet — lines 5-18.
  Special names (@-prefixed, read-only, indelible);
  pet names (lowercase alphanumeric with hyphens, 1-128
  chars, mutable). §the-named-special-vs-pet-names-as-
  name-discipline as tier-3 meta-pattern; sibling to
  cycle 386's petname-edgename framing — the cluster's
  naming vocabulary now has THREE kinds: special names,
  pet names, edge names.

  §the-named-four-canonical-special-names — lines 10-13:
  @self, @host, @agent, @main. §the-named-canonical-
  special-name-set as tier-3 meta-pattern.

  §the-named-at-agent-meaning-ambiguous — line 12 says
  "@agent — The own agent reference." But cycle 410's
  setup.js had `introducedNames: harden({ '@agent':
  'host-agent' })` — introducing @agent as the HOST
  agent. The primer's wording "own agent reference" is
  ambiguous: own = self-own (own=mine) or own = owning
  (own = the one who granted you powers)? In setup.js's
  context, @agent points to the host-agent. The
  ambiguity may be intentional (the same special name
  refers to "your agent" from your perspective, which
  for a guest is its host's agent) or yet another doc-
  drift instance. §the-named-at-agent-disambiguation-
  needed as tier-3 meta-pattern.

  §the-named-globals-count-disagrees-between-primer-
  documents — capabilities.md (lines 96-122) lists THREE
  globals: E, M, makeExo. Cycle 409's howto-code.md
  listed FOUR (E + M + makeExo + harden). Cycle 401's
  design doc said three (E + M + makeExo). Two primer
  documents disagree on the globals list — ANOTHER
  intra-primer drift instance. §the-named-globals-three-
  vs-four-across-primer-documents as tier-3 meta-
  pattern. Yet another count-drift instance.

  §the-named-evaluate-five-arguments — line 40:
  `evaluate('@main', "E(counter).increment()",
  ["counter"], ["my-counter"], "increment-result")`.
  Five positional arguments: workerName + source +
  codeNames + edgeNames + resultName. §the-named-
  evaluate-positional-signature as tier-3 meta-pattern.

  §the-named-codeNames-vs-edgeNames-distinction — lines
  47-49: "The codeNames array lists variable names used
  in your source code. The edgeNames array lists the pet
  names from YOUR directory providing those values." So
  codeNames are LEXICAL (in source) and edgeNames are
  INVENTORY (in your directory). Mapping is positional:
  codeNames[i] ↔ edgeNames[i]. §the-named-lexical-name-
  to-inventory-name-positional-mapping as tier-3 meta-
  pattern.

  §the-named-evaluate-runs-in-named-worker — line 40:
  the first argument is workerName, e.g. '@main'.
  evaluate can run in a specific worker. Line 146 shows
  `evaluate(undefined, ...)` — undefined defaults
  somewhere. §the-named-workerName-as-isolation-
  selector as tier-3 meta-pattern.

  §the-named-good-vs-bad-patterns-as-pedagogical-shape
  — lines 63-76. The primer's pedagogy includes
  explicit "Good" and "Bad" examples to avoid mistakes.
  §the-named-explicit-bad-example-in-pedagogy as tier-
  3 meta-pattern.

  §the-named-assignment-returns-undefined-anti-pattern
  — line 75: `const result = E(db).get("users")` is
  BAD because the last expression is an assignment,
  and assignments return undefined. §the-named-
  expression-style-trap as tier-3 meta-pattern;
  expression-only evaluation contexts have a familiar
  pitfall.

  §the-named-define-flow-includes-wait-for-host-reply
  — lines 132-138: the workflow has FOUR steps,
  including step 4 "Wait for the host to share the
  result via a reply message, then reply() to the
  original sender." §the-named-async-multi-party-flow-
  with-host-mediated-result as tier-3 meta-pattern.

  §the-named-evaluate-requires-capability-in-message —
  lines 143-144: the evaluate workflow starts with
  "Receive request: 'Please increment my counter' (and
  they sent you the counter)" — the requester must
  already have sent the capability. The agent adopts
  it, then evaluates. §the-named-evaluate-requires-
  prior-capability-acquisition as tier-3 meta-pattern.

  §the-named-define-result-flows-asymmetrically-three-
  parties — define's three roles: requester (sends
  initial request) → agent (proposes via define) →
  host (endows capability AND receives result). The
  result goes to the HOST, not the requester. The
  agent then has to ask the host to share back, then
  forward to the requester. THREE-PARTY flow with
  TWO mediations. §the-named-three-party-define-flow-
  with-two-mediations as tier-3 meta-pattern.

  §the-named-pet-name-format-1-to-128-characters — line
  17-18: "lowercase alphanumeric with hyphens (a-z0-9-,
  1–128 characters)." Same constraint cycle 401's inner
  CLAUDE.md mentioned but with a different scope (there
  it was for special names; here for pet names). §the-
  named-128-char-name-budget as tier-3 meta-pattern.

  §the-named-makeExo-with-this-state-pattern — lines
  115-122 example: `increment() { return ++this.state.
  count; }`. The makeExo methods use `this.state` for
  internal state. §the-named-makeExo-this-state-as-
  instance-state-pattern as tier-3 meta-pattern.

  §the-named-three-purposes-for-globals — lines 124-
  127: "Use these to: Invoke methods on capabilities
  passed as endowments; Create new capabilities to
  send back to requesters; Define type-safe interfaces
  for your created objects." Three named purposes.
  §the-named-three-canonical-uses-of-eval-globals as
  tier-3 meta-pattern.

  §the-named-fifty-nine-conformant-cycles-and-counting
  — fifty-ninth AUTHORED conformant single-body section
  doc in post-refactor era.

  Closes ten citation arcs: cycle 410 (1, adjacent
  forward; @agent meaning is ambiguous given cycle 410's
  setup.js context) + cycle 409 (5, MAJOR refinement —
  attenuation framing now specifies result-flows-to-
  host, not back to agent; cycle 409 didn't address
  result destination) + cycle 407 (3, define-preferred
  is CONDITIONALLY preferred — refines the absolute
  framing) + cycle 401 (3, design doc said three
  globals — primer/capabilities matches design;
  primer/howto-code disagrees) + cycle 386 (3, special-
  vs-pet sibling to petname-edgename framing) + cycle
  402 (3, evaluate signature matches the types in
  agent.types.d.ts) + cycle 326 (75) + cycle 322 (75)
  + cycle 364 (4, shapes count keeps growing) + cycle
  346 (3, name-aliasing for special names). Pushes
  citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-
  SEVENTY-NINE (569 + 10 net new).
---

148-line capabilities.md from @endo/lal's agent-facing primer. Thirteenth lal-package artifact in the cluster. Designs-lane after cycle 410 chat-lane lal/setup.js. **Single most structurally interesting move**: §the-named-result-flows-to-host-not-agent-in-define-endow — *lines 32-33 refine cycle 409's attenuation framing: "You receive a receipt, not the result. The host sees the result in their inbox and may share it with you via reply()." The RESULT flows to the HOST, not back to the agent. The agent's proposal yields no automatic output to the agent — only a receipt acknowledging the proposal was processed.* §the-named-receipt-not-result-for-define as tier-3 meta-pattern. §the-named-evaluate-result-stored-in-own-directory-vs-define-result-flows-to-host (evaluate is AGENT-CENTRIC; define is HOST-CENTRIC); §the-named-result-direction-as-second-asymmetry-between-evaluate-and-define. §the-named-define-preferred-CONDITIONALLY (cycle 407's absolute preference refined to conditional: prefer define WHEN you don't have the cap); §the-named-conditional-preference-on-inventory-state. §the-named-two-name-kinds-special-and-pet (cycle 386's petname-edgename now joined by special-vs-pet); §the-named-special-vs-pet-names-as-name-discipline. §the-named-four-canonical-special-names (@self, @host, @agent, @main); §the-named-canonical-special-name-set. §the-named-at-agent-meaning-ambiguous (primer says "own agent reference" but cycle 410's setup.js shows @agent introduced AS the host-agent); §the-named-at-agent-disambiguation-needed. §the-named-globals-count-disagrees-between-primer-documents (capabilities.md: 3 globals; howto-code.md: 4 globals; design doc: 3); §the-named-globals-three-vs-four-across-primer-documents (yet another doc-vs-doc drift). §the-named-evaluate-five-arguments (workerName + source + codeNames + edgeNames + resultName); §the-named-evaluate-positional-signature. §the-named-codeNames-vs-edgeNames-distinction (lexical name in source ↔ inventory name in directory; positional pairing); §the-named-lexical-name-to-inventory-name-positional-mapping. §the-named-evaluate-runs-in-named-worker; §the-named-workerName-as-isolation-selector. §the-named-good-vs-bad-patterns-as-pedagogical-shape; §the-named-explicit-bad-example-in-pedagogy. §the-named-assignment-returns-undefined-anti-pattern (expression-style trap); §the-named-expression-style-trap. §the-named-define-flow-includes-wait-for-host-reply (4-step workflow); §the-named-async-multi-party-flow-with-host-mediated-result. §the-named-evaluate-requires-capability-in-message; §the-named-evaluate-requires-prior-capability-acquisition. §the-named-define-result-flows-asymmetrically-three-parties (requester → agent → host with two mediations); §the-named-three-party-define-flow-with-two-mediations. §the-named-pet-name-format-1-to-128-characters; §the-named-128-char-name-budget. §the-named-makeExo-with-this-state-pattern (this.state for internal state). §the-named-three-purposes-for-globals; §the-named-three-canonical-uses-of-eval-globals. §the-named-fifty-nine-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-SEVENTY-NINE.
