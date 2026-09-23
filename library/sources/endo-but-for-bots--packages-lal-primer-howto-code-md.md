---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/howto-code.md
source_line_range: 1-140
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 409 designs-lane ingest. 140-line howto-code.md
  from @endo/lal's agent-facing primer. Eleventh lal-package
  artifact in the cluster after the README, providers/
  config.js, LAL-ARCHITECTURE.md, agent.types.d.ts,
  simulator README, mock-powers.js, primer/README.md,
  providers/index.js, primer/tools.md, and providers/
  anthropic.js. Fifty-seventh AUTHORED conformant single-
  body section doc in post-refactor era. Ninety-nine
  consecutive non-garden sources after the pivot (310-409).
  §ninety-nine-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  define-endow-as-attenuation-pattern — lines 46-48: "This
  pattern is central to attenuation — the agent proposes
  a transformation, you provide the powerful input, and
  the output is a less-powerful capability you can share
  safely." The define-endow flow cycle 407 revealed as
  PREFERRED for code is EXPLICITLY DESIGNED for capability
  attenuation. The cluster's drift framings around the
  proposal/grant workflow (cycle 401 said it didn't
  exist; cycle 402 called types vestigial; cycle 407
  revised both because the primer prefers define) now
  resolves to a sharper conclusion: define-endow is the
  PRIMITIVE for attenuation. The agent (limited authority)
  proposes code with named slots; the user (strong
  authority) endows the slots with their capabilities;
  the result is a less-powerful capability the agent can
  share safely. §the-named-attenuation-as-three-role-
  flow-agent-user-result as tier-3 meta-pattern.

  §the-named-three-roles-in-attenuation — (1) agent
  proposes code with named slots; (2) user endows the
  slots with their authority; (3) result is the
  attenuated capability stored in the agent's inventory
  for sharing. The TWO-roles (LLM + user) at the surface
  level become a THREE-ROLE structure when authority
  flows. §the-named-cap-attenuation-as-design-of-define-
  endow as tier-3 meta-pattern.

  §the-named-attenuation-as-explicit-design-goal — line
  46: "This pattern is central to attenuation." First
  artifact in the cluster that explicitly LABELS
  attenuation as the design intent of a specific
  mechanism. Connects to all prior cap-attenuation
  framings (cycle 387 branded-types-from-validators is
  one form; this is another). §the-named-explicit-
  attenuation-label as tier-3 meta-pattern.

  §the-named-two-code-patterns-evaluate-vs-define-endow
  — lines 4-6: "Endo lets you evaluate JavaScript in a
  secure sandbox with access to capabilities. There are
  two main patterns: evaluate (you provide the
  capabilities) and define/endow (the agent proposes,
  you provide)." The two patterns are not just two
  tools but two AUTHORITY FLOWS. §the-named-authority-
  flow-direction-as-distinguishing-feature as tier-3
  meta-pattern.

  §the-named-define-takes-name-to-label-metadata —
  line 27-30: `define("E(db).get('users')", { "db":
  {"label": "A database to query"} })`. The slot
  metadata is an OBJECT keyed by slot name, each
  with a `label` field. §the-named-slot-metadata-as-
  name-to-label-record as tier-3 meta-pattern.

  §the-named-endow-references-message-number — line
  40: `/endow 5`. The endow command takes the message
  number of the proposal. The inbox is the conduit
  for proposals; the endow command picks one by
  number. §the-named-message-number-as-proposal-
  reference as tier-3 meta-pattern.

  §the-named-Cmd-Enter-to-expand-to-editor — lines
  16-17: "Press Enter to evaluate, or Cmd+Enter to
  expand to a full editor." Two-tier evaluation:
  inline-form or full-editor. §the-named-two-tier-
  evaluation-interface as tier-3 meta-pattern.

  §the-named-at-symbol-for-endowment-binding — line
  14-15: "Type `@` to add endowments — you bind
  variable names in the code to capabilities in your
  inventory." The @ symbol in /js triggers endowment.
  Sibling to cycle 405's chat-supports-slash-and-at-
  addressing — the @ symbol is doing double duty as
  both a message-recipient prefix AND an endowment-
  binding trigger.

  §the-named-UNCONFINED-flag-only-on-CLI — lines 65-68:
  `endo run --UNCONFINED ./setup.js --powers @agent`.
  The UNCONFINED flag is CLI-only and gives full host
  access. Chat has no equivalent — for security. §the-
  named-CLI-as-privilege-escalation-surface as tier-3
  meta-pattern.

  §the-named-spawn-command-for-worker-creation — lines
  70-76: `/spawn -n my-worker`. Workers are "isolated
  execution contexts." The /spawn command creates one.
  §the-named-workers-as-isolated-execution-contexts as
  tier-3 meta-pattern.

  §the-named-four-globals-in-evaluated-code — lines
  80-83: E, M, makeExo, harden. Four named globals
  available in evaluate. Cycle 401's design doc
  mentioned three (E, M, makeExo); this primer adds
  harden. §the-named-evaluate-environment-globals as
  tier-3 meta-pattern. Possibly another instance of
  document-vs-document drift: cycle 401's design doc
  undercounts the globals.

  §the-named-no-top-level-await-in-evaluate — line 90:
  "Top-level await is not supported. For single async
  calls, the promise itself is the completion value."
  Evaluate is expression-style, not statement-style.
  §the-named-expression-only-evaluation-context as
  tier-3 meta-pattern.

  §the-named-completion-value-as-result — lines 87-88:
  "The completion value (the last expression) becomes
  the result, so make sure the final expression
  evaluates to whatever you want to produce." Lisp-
  style implicit return. §the-named-implicit-last-
  expression-return as tier-3 meta-pattern; sibling to
  classic Lisp/Ruby implicit-return semantics.

  §the-named-endowments-as-lexical-bindings — lines
  85-86: "Endowments are lexical bindings — each code
  name becomes a variable in scope." The endow
  mechanism uses lexical scoping. The code names in
  define() become lexical variables; the user's
  chosen capabilities bind to those variables.
  §the-named-name-binding-via-lexical-scope as tier-3
  meta-pattern.

  §the-named-async-IIFE-as-workaround-for-no-top-level-
  await — lines 96-102: when multiple async steps are
  needed, the convention is `(async () => { ... })()`.
  §the-named-IIFE-as-async-encapsulator as tier-3
  meta-pattern.

  §the-named-graduated-guide-three-levels — lines 104-
  139: three levels of capability building.
  (1) Simple value transformation (line 106-111).
  (2) Creating a new capability object (line 113-121).
  (3) Wrapping for attenuation (line 125-139).
  Each level builds on the previous. §the-named-three-
  level-progression-from-transform-to-construct-to-
  attenuate as tier-3 meta-pattern.

  §the-named-makeExo-as-dominant-cap-construction-
  pattern — lines 116-121, 129-135: both code-creation
  examples use makeExo. §the-named-makeExo-over-Far-
  in-LLM-examples as tier-3 meta-pattern; the primer's
  pedagogical preference matches the CLAUDE.md
  guidance "Prefer makeExo() with an M.interface()
  guard over Far() for remotable objects."

  §the-named-M-as-pattern-matcher-DSL — M.interface,
  M.call, M.returns, M.string, M.any. The M
  vocabulary defines interface guards and argument
  patterns. §the-named-M-DSL-for-interface-guards as
  tier-3 meta-pattern.

  §the-named-ReadOnly-as-canonical-attenuation-example
  — lines 125-139: the third graduated example is
  specifically a ReadOnly view of a read-write
  store. The canonical attenuation: remove write
  authority, keep read authority. §the-named-read-
  only-as-canonical-attenuation as tier-3 meta-
  pattern.

  §the-named-fifty-seven-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 408 (1, adjacent
  forward; this doc explains the design of define-
  endow that cycle 408 saw through the provider lens)
  + cycle 407 (3, cycle 407 revised cycle 402's
  framing because primer said define() is preferred;
  cycle 409 reveals WHY — define-endow is the
  attenuation primitive) + cycle 402 (5, the
  PendingProposal types implement the proposal half
  of define-endow; not vestigial — central design)
  + cycle 401 (3, design doc said "no proposal/grant
  workflow" but this primer reveals proposal IS the
  preferred pattern AND has a specific name — define-
  endow — AND a specific purpose — attenuation;
  cycle 401's design doc was both wrong about the
  absence and missing the attenuation framing) +
  cycle 405 (3, primer-organized-by-audience; primer
  uses @-symbol for endowment binding — sibling to
  @-addressing for messages) + cycle 387 (5, branded-
  types-from-validators is one form of attenuation;
  define-endow is another; explicit-attenuation-label
  now connects them) + cycle 326 (75) + cycle 322
  (75) + cycle 364 (4, shapes count keeps growing
  — now NINE-PLUS-and-counting drift directions
  and a meta-framing of attenuation as design intent)
  + cycle 346 (3, name-aliasing for @ symbol used in
  two different contexts). Pushes citation-arc-
  closures-in-pivot to FIVE-HUNDRED-AND-FIFTY-NINE
  (549 + 10 net new).
---

140-line howto-code.md from @endo/lal's agent-facing primer. Eleventh lal-package artifact in the cluster. Designs-lane after cycle 408 chat-lane providers/anthropic.js. **Single most structurally interesting move**: §the-named-define-endow-as-attenuation-pattern — *lines 46-48 explicitly state: "This pattern is central to attenuation — the agent proposes a transformation, you provide the powerful input, and the output is a less-powerful capability you can share safely." The define-endow flow cycle 407 revealed as PREFERRED for code is EXPLICITLY DESIGNED for capability attenuation. The cluster's drift framings around the proposal/grant workflow now resolve to a sharper conclusion: define-endow is the PRIMITIVE for attenuation.* §the-named-attenuation-as-three-role-flow-agent-user-result as tier-3 meta-pattern. §the-named-three-roles-in-attenuation (agent proposes + user endows with strong authority + result is less-powerful capability for safe sharing); §the-named-cap-attenuation-as-design-of-define-endow. §the-named-attenuation-as-explicit-design-goal; §the-named-explicit-attenuation-label (first artifact in cluster that explicitly LABELS attenuation as design intent of a specific mechanism). §the-named-two-code-patterns-evaluate-vs-define-endow; §the-named-authority-flow-direction-as-distinguishing-feature. §the-named-define-takes-name-to-label-metadata; §the-named-slot-metadata-as-name-to-label-record. §the-named-endow-references-message-number; §the-named-message-number-as-proposal-reference. §the-named-Cmd-Enter-to-expand-to-editor; §the-named-two-tier-evaluation-interface. §the-named-at-symbol-for-endowment-binding (sibling to cycle 405's chat-supports-slash-and-at-addressing — @ does DOUBLE DUTY for messages AND endowments). §the-named-UNCONFINED-flag-only-on-CLI; §the-named-CLI-as-privilege-escalation-surface. §the-named-spawn-command-for-worker-creation; §the-named-workers-as-isolated-execution-contexts. §the-named-four-globals-in-evaluated-code (E + M + makeExo + harden); §the-named-evaluate-environment-globals (cycle 401 said three; primer says four — possibly another doc-vs-doc drift instance). §the-named-no-top-level-await-in-evaluate; §the-named-expression-only-evaluation-context. §the-named-completion-value-as-result; §the-named-implicit-last-expression-return. §the-named-endowments-as-lexical-bindings; §the-named-name-binding-via-lexical-scope. §the-named-async-IIFE-as-workaround-for-no-top-level-await; §the-named-IIFE-as-async-encapsulator. §the-named-graduated-guide-three-levels (transform → construct → attenuate); §the-named-three-level-progression-from-transform-to-construct-to-attenuate. §the-named-makeExo-as-dominant-cap-construction-pattern; §the-named-makeExo-over-Far-in-LLM-examples. §the-named-M-as-pattern-matcher-DSL; §the-named-M-DSL-for-interface-guards. §the-named-ReadOnly-as-canonical-attenuation-example; §the-named-read-only-as-canonical-attenuation. §the-named-fifty-seven-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-FIFTY-NINE.
