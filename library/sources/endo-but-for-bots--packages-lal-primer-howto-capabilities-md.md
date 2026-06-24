---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/howto-capabilities.md
source_line_range: 1-143
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 437 designs-lane ingest. 143-line howto-
  capabilities.md from @endo/lal's agent-facing primer.
  Companion to cycle 409's howto-code.md. Grounds the
  cluster's accumulated attenuation framings (cycles
  409, 411, 425) in a complete user-facing flow.
  Eighty-fifth AUTHORED conformant single-body section
  doc in post-refactor era. One-hundred-and-twenty-
  seventh consecutive non-garden source after the pivot
  (310-437). §one-hundred-and-twenty-seven-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  attenuation-by-example-as-full-user-facing-flow —
  lines 69-99 give the COMPLETE end-to-end user-facing
  attenuation flow. The cluster's accumulated framings
  articulated this piece-by-piece across cycles 409
  (define-endow-as-attenuation-pattern), 411 (result-
  flows-to-host-not-agent), 425 (three ocap patterns).
  Cycle 437 has all seven steps in one place from the
  user's perspective:
  1. User holds powerful capability (e.g., project-dir
     read-write)
  2. User asks agent for attenuation: "I have a read-
     write directory. Please propose code that creates
     a read-only view."
  3. Agent calls define() with labeled named slots:
     `define("E(dir).readOnly()", { "dir": {"label":
     "The directory to attenuate"} })`
  4. User receives definition message; Chat shows
     inline form with slot per parameter
  5. User fills slots (binds `dir` to `project-dir`)
     and submits
  6. Code runs WITH USER'S ENDOWMENTS; produces
     attenuated capability
  7. User shares attenuated cap with untrusted agent:
     "@untrusted-agent Here is @read-only-view for you."
  §the-named-seven-step-user-facing-attenuation-flow
  as tier-3 meta-pattern. The cluster's attenuation
  framing is now fully grounded from the user's
  perspective.

  §the-named-capability-as-reference-with-authority —
  lines 3-5: "Capabilities are references to objects
  that can do things — directories, services, data
  stores, network endpoints. You interact with them
  through pet names in your inventory." Concise
  definition. §the-named-cap-as-reference-with-
  authority-via-pet-name as tier-3 meta-pattern.

  §the-named-show-vs-inspect-same-op-two-surfaces —
  lines 12, 18: /show my-capability (Chat slash
  command, user-facing) vs inspect("my-capability")
  (agent tool call, LLM-facing). Same operation, two
  surfaces. Cycle 405's three-surfaces framing
  extended with another concrete pair. §the-named-
  symmetric-user-and-agent-operations-via-different-
  surface as tier-3 meta-pattern.

  §the-named-view-edit-as-inline-content-affordances
  — lines 21-40: /view to read contents inline; /edit
  to modify in place. "Without leaving the
  conversation." The user's surface is rich enough to
  not require leaving Chat. §the-named-inline-content-
  manipulation-keeps-user-in-chat as tier-3 meta-
  pattern.

  §the-named-mount-then-send-as-canonical-cap-transfer
  — lines 42-57: TWO-STEP canonical pattern:
  - /mount /path -n petname (creates the capability)
  - @agent Here is @petname (transfers reference)
  §the-named-create-then-share-as-two-step-pattern
  as tier-3 meta-pattern. Sibling to cycle 419's
  tool-transfer-via-chat-message-with-at-reference.

  §the-named-request-resolve-as-explicit-cap-grant-
  flow — lines 59-67: /request to ask for capability;
  /resolve for host to grant. THREE-PARTY flow:
  requesting agent, host, granted capability. §the-
  named-human-user-as-grantor-via-resolve as tier-3
  meta-pattern.

  §the-named-read-only-wrapper-as-canonical-
  attenuation-pattern — lines 76-99: the read-only
  wrapper example matches cycle 409's howto-code.md
  ReadOnly attenuation example. Two angles, same
  pattern. The cluster's canonical attenuation
  example is consistent across the primer's two
  howto documents. §the-named-canonical-example-
  consistent-across-howto-docs as tier-3 meta-
  pattern.

  §the-named-slot-label-for-human-readability —
  line 86: `{"dir": {"label": "The directory to
  attenuate"}}`. Cycle 409's slot-metadata-includes-
  label-for-form-display now grounded with a
  concrete example. The label is what the USER sees
  in the form. §the-named-slot-label-as-form-prompt
  as tier-3 meta-pattern.

  §the-named-untrusted-agent-as-explicit-share-
  target — lines 97-99: "@untrusted-agent Here is
  @read-only-view for you." The target is named
  EXPLICITLY as untrusted. Attenuation matters
  specifically because the recipient may be hostile.
  Connects to cycle 433's cotenant threat model —
  the user-facing flow assumes the recipient might
  be adversarial. §the-named-untrusted-target-as-
  attenuation-motivation as tier-3 meta-pattern.

  §the-named-share-and-adopt-locator-as-cross-
  network-cap-transfer — lines 101-114: /share
  generates a locator; /adopt-locator on another
  machine binds it. "This works across network
  boundaries using Endo's peer protocols." Cluster's
  CapTP-as-transport (cycle 429) now extends to
  USER-FACING cross-network sharing. §the-named-
  CapTP-as-user-facing-cross-network-share as
  tier-3 meta-pattern.

  §the-named-readable-tree-vs-mount-as-snapshot-vs-
  live — lines 116-143: TWO kinds of directory
  capabilities:
  - Readable Tree: IMMUTABLE directory snapshot.
    Browsable inline.
  - Mount: LIVE filesystem directory. Browsable AND
    editable inline.
  Snapshot vs live; immutable vs mutable. §the-
  named-immutable-snapshot-vs-live-directory as
  tier-3 meta-pattern.

  §the-named-readable-tree-checkout-via-CLI —
  lines 126-129: `endo checkout my-tree ./local-
  dir`. Readable trees can be materialized to
  disk via CLI. §the-named-snapshot-materialization-
  via-checkout as tier-3 meta-pattern.

  §the-named-untrusted-agent-naming-as-design-cue —
  the name `@untrusted-agent` in line 98 is
  rhetorical. It signals to readers that
  attenuation is the pattern when the recipient
  ISN'T trusted. §the-named-rhetorical-naming-in-
  documentation-examples as tier-3 meta-pattern.

  §the-named-Chat-as-permission-management-confirmed
  — cycle 435 named chat-as-permission-management-
  UI. Cycle 437 confirms with concrete examples:
  /mount + send (grant), /request + /resolve
  (grant flow), define-endow (attenuated grant),
  /share + /adopt-locator (cross-network grant).
  §the-named-permission-management-as-pervasive-
  in-Chat-affordances as tier-3 meta-pattern.

  §the-named-readText-writeText-list-as-mount-
  tools — line 57: "The agent can now read and
  write files in that directory using its
  readText, writeText, and list tools." Cycle
  407 named readText/writeText as capability
  shortcuts; cycle 437 grounds them in the
  mount workflow. §the-named-three-mount-tools-
  for-fs-access as tier-3 meta-pattern.

  §the-named-eighty-five-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 436 (1, adjacent
  forward; six-layer-exfiltration-defense
  protects untrusted-agent-style recipients on
  the OUTBOUND side; attenuation is the cap-
  security counterpart) + cycle 433 (3, cotenant
  threat model — untrusted-agent recipient is
  explicit instantiation) + cycle 425 (5, three
  ocap patterns — attenuation is the one
  illustrated end-to-end here) + cycle 411 (5,
  MAJOR COMPLETION — result-flows-to-host-not-
  agent now grounded in concrete user-facing flow;
  user receives attenuated result, can share with
  third party) + cycle 409 (5, MAJOR COMPLETION —
  define-endow-as-attenuation-pattern now has its
  full user-facing flow documented) + cycle 405
  (3, three-surfaces framing — /show vs inspect
  same-op-two-surfaces) + cycle 429 (3, CapTP at
  user-facing layer via /share + /adopt-locator)
  + cycle 326 (75) + cycle 322 (75) + cycle 407
  (3, readText/writeText capability shortcuts
  grounded in mount workflow). Pushes citation-
  arc-closures-in-pivot to EIGHT-HUNDRED-AND-
  THIRTY-TWO (822 + 10 net new).
---

143-line howto-capabilities.md from @endo/lal's agent-facing primer. Companion to cycle 409's howto-code.md. Designs-lane after cycle 436 chat-lane familiar/src/exfiltration-defense.js. **Single most structurally interesting move**: §the-named-attenuation-by-example-as-full-user-facing-flow — *lines 69-99 give the COMPLETE end-to-end user-facing attenuation flow. The cluster's accumulated framings (cycles 409 define-endow, 411 result-flows-to-host, 425 three ocap patterns) now have all seven steps in one place: (1) user has powerful cap → (2) user asks agent for attenuation → (3) agent calls define() with labeled slots → (4) user receives form → (5) user fills slots → (6) code runs with user's endowments → (7) user shares attenuated cap with untrusted agent.* §the-named-seven-step-user-facing-attenuation-flow as tier-3 meta-pattern. §the-named-capability-as-reference-with-authority (concise definition); §the-named-cap-as-reference-with-authority-via-pet-name. §the-named-show-vs-inspect-same-op-two-surfaces (cycle 405's three-surfaces extended); §the-named-symmetric-user-and-agent-operations-via-different-surface. §the-named-view-edit-as-inline-content-affordances; §the-named-inline-content-manipulation-keeps-user-in-chat. §the-named-mount-then-send-as-canonical-cap-transfer (create-then-share two-step); §the-named-create-then-share-as-two-step-pattern. §the-named-request-resolve-as-explicit-cap-grant-flow (three-party flow); §the-named-human-user-as-grantor-via-resolve. §the-named-read-only-wrapper-as-canonical-attenuation-pattern (consistent across howto-code and howto-capabilities); §the-named-canonical-example-consistent-across-howto-docs. §the-named-slot-label-for-human-readability; §the-named-slot-label-as-form-prompt. §the-named-untrusted-agent-as-explicit-share-target (cycle 433 cotenant explicitly instantiated); §the-named-untrusted-target-as-attenuation-motivation. §the-named-share-and-adopt-locator-as-cross-network-cap-transfer (CapTP at user-facing layer); §the-named-CapTP-as-user-facing-cross-network-share. §the-named-readable-tree-vs-mount-as-snapshot-vs-live (immutable snapshot vs live directory); §the-named-immutable-snapshot-vs-live-directory. §the-named-readable-tree-checkout-via-CLI; §the-named-snapshot-materialization-via-checkout. §the-named-untrusted-agent-naming-as-design-cue; §the-named-rhetorical-naming-in-documentation-examples. §the-named-Chat-as-permission-management-confirmed (cycle 435 framing reinforced); §the-named-permission-management-as-pervasive-in-Chat-affordances. §the-named-readText-writeText-list-as-mount-tools; §the-named-three-mount-tools-for-fs-access. §the-named-eighty-five-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-THIRTY-TWO.
