---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/test/simulator/mock-powers.js
source_line_range: 1-296
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 404 chat-lane ingest. 296-line mock-powers.js, the
  mock-internals implementation cycle 403's simulator
  README described. Sixth lal-package artifact in the
  cluster (after README, providers/config.js, LAL-
  ARCHITECTURE.md, agent.types.d.ts, test/simulator/
  README.md). Fifty-second AUTHORED conformant single-body
  section doc in post-refactor era. Ninety-four
  consecutive non-garden sources after the pivot (310-404).
  §ninety-four-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  guest-power-surface-larger-than-LLM-tool-surface — the
  mock implements TWENTY-TWO methods (help, has, list,
  lookup, remove, move, copy, makeDirectory, listMessages,
  resolve, reject, adopt, dismiss, request, send, reply,
  storeValue, identify, locate, followMessages, evaluate,
  form). Cycle 401's LAL-ARCHITECTURE.md table named 18
  tools (cycle 402 noted the 16-tools comment vs 18-in-
  table inconsistency). The mock provides FIVE methods
  that are NOT in the LLM tool catalog: reply,
  storeValue, locate, followMessages, form. These are
  GUEST POWERS the agent consumes programmatically
  (followMessages drives the main loop; locate, identify,
  storeValue support introspection; reply and form are
  surface-specific). §the-named-LLM-exposed-tool-surface-
  as-subset-of-guest-power-surface as tier-3 meta-pattern.
  The agent doesn't expose every guest power to the LLM;
  it filters the surface.

  §the-named-mock-incomplete-relative-to-tool-catalog —
  the mock omits ONE tool from the LAL-ARCHITECTURE
  catalog: inspectCapability. If the test path
  exercises inspectCapability, it would fail. Either a
  deliberate omission (the canonical reply+dismiss flow
  doesn't need it) or a small bug. §the-named-mock-
  omits-one-tool-from-design-catalog as tier-3 meta-
  pattern.

  §the-named-mock-with-finite-iterator-vs-real-infinite-
  iterator — lines 87-91: followMessages yields each
  message in the messages array ONCE and then completes
  (the generator returns). The REAL Endo daemon's
  followMessages is INFINITE — it blocks waiting for
  new messages indefinitely. The mock has REDUCED
  SEMANTICS. The test ends after the agent processes
  the single canned message because the iterator
  completes. §the-named-finite-mock-infinite-real as
  tier-3 meta-pattern. Extends cycle 403's mock-
  internals-real-externals framing with a semantic
  refinement: the mock internals are not just MOCKED
  but SEMANTICALLY REDUCED.

  §the-named-asymmetric-observation-hooks — lines 42-57:
  whenDismissed is per-message-number (Map-keyed,
  resolves the specific message's promise). whenSend is
  a single global one-shot promise. The semantics
  differ: multiple sends can occur but only one wait
  resolves; multiple dismissed messages each have their
  own promise. §the-named-per-message-vs-global-
  observation-hook as tier-3 meta-pattern.

  §the-named-test-prompt-hardcoded-in-mock — line 79:
  "Hello from the simulator. Please reply with a short
  greeting and then dismiss this message (dismiss
  message 1)." The simulator's canonical test prompt
  is HARDCODED inside the mock — not parameterized in,
  not configured from env. §the-named-canonical-test-
  prompt-hardcoded as tier-3 meta-pattern.

  §the-named-mock-marker-field — pattern used in
  makeDirectory (line 161-162: `{ __mockDirectory:
  true, path: key }`), request (line 209-213:
  `{ __mockRequest: true, ... }`), evaluate (line
  279-282: `{ __mockEval: true, message: ... }`). The
  mock returns objects with `__mockX: true`
  discriminator fields so the test can identify them.
  §the-named-mock-discriminator-as-test-marker as
  tier-3 meta-pattern.

  §the-named-flat-map-as-directory — lines 22-23, 102-
  157: the mock's directory is a flat Map keyed by
  path-joined-with-slash strings. `list` recursively
  interprets first-level subdirectory names. §the-
  named-path-joined-string-as-flat-key as tier-3 meta-
  pattern; the directory is conceptually hierarchical
  but stored as a flat map with synthetic compound
  keys.

  §the-named-evaluate-stubbed-completely — lines 278-
  283: the mock returns `{ __mockEval: true, message:
  'Mock would run: ${source.slice(0, 50)}...' }`. No
  actual code execution. The simulator's purpose
  (provider debugging) doesn't need real evaluate.
  Important because cycle 401 named evaluate as Lal's
  most powerful tool — the mock cannot exercise it.
  §the-named-most-powerful-tool-stubbed-in-mock as
  tier-3 meta-pattern.

  §the-named-form-method-stubbed-with-no-op — lines
  285-287: form() returns Promise.resolve() with no
  implementation. This is the FORM-SUBMISSION flow
  cycle 402 found in the WorkerConfig type and in
  lal/CLAUDE.md but NOT in LAL-ARCHITECTURE.md. The
  mock STUBS the surface so the agent can call form()
  without crashing, but no form behavior is
  exercised. §the-named-stub-anticipates-unused-
  surface as tier-3 meta-pattern; sibling to cycle
  402's vestigial-types-from-abandoned-design — here
  the mock anticipates a future surface where the
  types anticipate a past surface.

  §the-named-makePromiseKit-from-endo-promise-kit —
  line 9. Standard Endo idiom for promise/resolver
  bundling. Used twice: dismissWaiters (per-message
  Map of promise-kits) and nextSendPromise (single
  global). §the-named-promise-kit-as-Endo-idiom as
  tier-3 meta-pattern.

  §the-named-endo-localhost-URL-shape — line 269:
  `endo://localhost/?id=${ID}&type=handle`. The
  endo:// URL scheme is a deep Endo convention; the
  mock synthesizes URLs of this shape for the locate
  method. §the-named-endo-URL-scheme-as-deep-Endo-
  convention as tier-3 meta-pattern.

  §the-named-SELF_ID-as-hardcoded-string-constant —
  line 11: `const SELF_ID = 'lal-self-id'`. The mock
  uses string IDs in place of opaque handles. Lines
  25-26 set '@self' → SELF_ID and '@host' → 'host-id'
  in the directory. §the-named-hardcoded-string-ID-
  in-mock as tier-3 meta-pattern.

  §the-named-reply-vs-send-as-distinct-methods —
  lines 216-228 (send) vs lines 230-248 (reply).
  Reply finds the parent message's number, determines
  the other party (the from or to depending on
  direction), records the recipient, and includes a
  replyTo field. Send is one-way. §the-named-reply-as-
  send-with-direction-inference as tier-3 meta-
  pattern; reply is structurally a send plus a parent-
  lookup for direction inference.

  §the-named-adopt-as-marker-not-actual-capability —
  lines 188-195: the mock stores a string
  `'adopted-from-msg-${N}'` as the value. The mock
  doesn't exercise capability semantics; adopted
  values are placeholder markers. §the-named-mock-
  flattens-capability-semantics as tier-3 meta-
  pattern.

  §the-named-dismiss-as-three-operations — lines 197-
  206: dismiss splices the message out of the array,
  resolves the waiter promise, and deletes the waiter
  entry. Three operations in sequence; the mock
  records the canonical end-of-conversation as the
  resolution of a wait promise. §the-named-dismiss-
  triggers-wait-resolution as tier-3 meta-pattern.

  §the-named-fifty-two-conformant-cycles-and-counting
  — fifty-second AUTHORED conformant single-body
  section doc in post-refactor era.

  Closes eight citation arcs: cycle 403 (1, adjacent
  forward; the simulator README pointed at this mock
  file by name) + cycle 402 (2, .d.ts WorkerConfig
  type the mock's form() stub anticipates) + cycle
  401 (3, LAL-ARCHITECTURE.md tool catalog the mock
  is incomplete relative to) + cycle 400 (3, the
  cluster's drift framings are now refined by mock-
  vs-real semantic-reduction direction) + cycle 318
  (3, makePromiseKit idiom) + cycle 326 (75) + cycle
  322 (75) + cycle 387 (3, branded-types discipline
  the mock simplifies away). Pushes citation-arc-
  closures-in-pivot to FIVE-HUNDRED-AND-THIRTEEN
  (505 + 8 net new).
---

296-line mock-powers.js, the mock-internals implementation cycle 403's simulator README described. Sixth lal-package artifact in the cluster. Chat-lane after cycle 403 designs-lane lal/test/simulator/README.md. **Single most structurally interesting move**: §the-named-guest-power-surface-larger-than-LLM-tool-surface — *the mock implements TWENTY-TWO methods, FIVE of which (reply, storeValue, locate, followMessages, form) are NOT in the LAL-ARCHITECTURE tool catalog. The agent doesn't expose every guest power to the LLM; the LLM-exposed tool surface is a SUBSET of the guest-power surface.* §the-named-LLM-exposed-tool-surface-as-subset-of-guest-power-surface as tier-3 meta-pattern. §the-named-mock-incomplete-relative-to-tool-catalog (omits inspectCapability — the canonical reply+dismiss path doesn't need it); §the-named-mock-omits-one-tool-from-design-catalog. §the-named-mock-with-finite-iterator-vs-real-infinite-iterator (followMessages mock yields once and returns; real is infinite); §the-named-finite-mock-infinite-real (refinement of cycle 403's mock-internals-real-externals — mock internals are SEMANTICALLY REDUCED). §the-named-asymmetric-observation-hooks (whenDismissed per-message; whenSend global one-shot); §the-named-per-message-vs-global-observation-hook. §the-named-test-prompt-hardcoded-in-mock (canonical test prompt baked in); §the-named-canonical-test-prompt-hardcoded. §the-named-mock-marker-field (`__mockX: true` discriminator); §the-named-mock-discriminator-as-test-marker. §the-named-flat-map-as-directory; §the-named-path-joined-string-as-flat-key. §the-named-evaluate-stubbed-completely; §the-named-most-powerful-tool-stubbed-in-mock. §the-named-form-method-stubbed-with-no-op; §the-named-stub-anticipates-unused-surface (mock anticipates future surface; types anticipate past surface — symmetric inversion of cycle 402's vestigial-types). §the-named-makePromiseKit-from-endo-promise-kit; §the-named-promise-kit-as-Endo-idiom. §the-named-endo-localhost-URL-shape; §the-named-endo-URL-scheme-as-deep-Endo-convention. §the-named-SELF_ID-as-hardcoded-string-constant; §the-named-hardcoded-string-ID-in-mock. §the-named-reply-vs-send-as-distinct-methods; §the-named-reply-as-send-with-direction-inference. §the-named-adopt-as-marker-not-actual-capability; §the-named-mock-flattens-capability-semantics. §the-named-dismiss-as-three-operations; §the-named-dismiss-triggers-wait-resolution. §the-named-fifty-two-conformant-cycles-and-counting. Eight citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-THIRTEEN.
