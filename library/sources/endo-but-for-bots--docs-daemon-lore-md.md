---
source_kind: design-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: docs/daemon-lore.md
source_line_range: 1-100
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: partial-ingest
notes: |
  Cycle 391 designs-lane ingest. Partial ingest (first 100
  of 212 lines) of daemon-lore.md, the bot-fork's daemon
  glossary. Thirty-ninth AUTHORED conformant single-body
  section doc in post-refactor era. Eighty-first
  consecutive non-garden source after the pivot (310-391).
  §eighty-one-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  document-grown-by-LLM-rework-discipline — lines 18-21
  describe the document's growth method: "(1) pasting in
  notes and snippets of chat conversation, (2) telling an
  LLM-empowered-agent to rework it, (3) then later
  reviewing or refining its progress." The DOCUMENT ITSELF
  IS WRITTEN BY THE AGENT it documents. §the-named-
  document-written-by-agent-it-documents as tier-3 meta-
  pattern; the agent uses the document to know how to
  write the document — a meta-recursive loop.

  §The-named-lore-as-acknowledged-not-yet-organized-name —
  lines 12-16: "This document is called 'lore' because the
  author (jcorbin) deos not yet know how to group or
  otherwise organize it, and so hesitates to call this a
  'Guide' or 'Reference' documentation." Honest
  acknowledgment of the document's working-status. Sibling
  honest-acknowledgment shape from cycles 357/359/372/375/
  377/378/379/390. Note: the typo "deos" remains in source
  — agent rework hasn't caught it yet. §the-named-typo-as-
  evidence-of-WIP-status as tier-3 meta-pattern.

  §The-named-let-suffix-as-program-shape-vocabulary —
  lines 25-95 define FOUR "let" terms in sequence: caplet
  + runlet + worklet + weblet. The `let` suffix names a
  class of bot-fork programs differentiated by lifecycle
  and runtime context. §the-named-four-let-programs-by-
  shape as tier-3 meta-pattern.

  §The-named-caplet-as-capability-program — line 26-28: "A
  program that exports `make(powers)`, and returns a
  capability, and is intended to live as long as that
  capability shall live." Caplet = capability-bounded-
  lifetime program. §the-named-program-lifetime-tied-to-
  capability-lifetime as tier-3 meta-pattern.

  §The-named-runlet-as-main-program — lines 74-77: "A
  program that exports `main(powers)`, and is not
  expected to return anything, and consequently, is not
  intended to exceed the life of the main." Runlet =
  exports `main()`, transient program. §the-named-main-
  bounded-program-shape as tier-3 meta-pattern.

  §The-named-worklet-as-Worker-caplet — lines 82-86: "A
  caplet that is intended to run in a Worker." Worklet =
  caplet + Worker context. Companion observation: "Workers
  can be co-tenant but YMMV what with availability and
  HardenedJS not being quite bullet-proof for passable
  proxies." §the-named-co-tenant-worker-with-YMMV-hedge as
  tier-3 meta-pattern; the hedge acknowledges a real but
  not fully resolved security boundary.

  §The-named-weblet-as-WebView-caplet — lines 88-95:
  "A caplet that runs in a WebView. Web views are not
  safely co-tenant. They rely on same origin isolation.
  They persist only so long as the window is open."
  Weblet = caplet + WebView context, with three security/
  lifetime caveats. §the-named-three-properties-of-
  weblet-isolation as tier-3 meta-pattern.

  §The-named-capability-as-identity-and-authority-twin-
  purposes — lines 32-37: a capability is a reference
  that serves TWO PURPOSES SIMULTANEOUSLY: Identity (the
  reference is a handle that identifies the object) and
  Authority (the object's behavior encodes what operations
  are permissible). The OCAP definition distilled to a
  two-purpose framing. §the-named-twin-purpose-capability-
  framing as tier-3 meta-pattern.

  §The-named-four-named-OCAP-principles — lines 38-51 list
  four key principles: Reference as Authority + Pass-by-
  reference + Encapsulation + Principle of Least Authority.
  §the-named-four-OCAP-principles-enumerated as tier-3
  meta-pattern; the same POLA principle from cycle 377's
  SES secure-coding-guide recurs in the bot-fork's lore
  document — cross-fork canon.

  §The-named-mint-makePurse-as-capability-example-recurs —
  lines 66-71: "a mint's `makePurse()` method returns a
  **capability** (a purse object with deposit/withdraw
  methods)—not because the mint executes the deposit/
  withdraw operation directly, but because the returned
  purse object encodes the authority to perform deposits
  and withdrawals within the system's security policy."
  The mint/purse example recurs from cycle 367 exo README
  (mint-purse-payment-as-canonical-OCAP-example) and is
  now in the bot-fork's lore. §the-named-mint-purse-
  payment-canonical-example-recurs-in-lore as tier-3 meta-
  pattern; the same canonical OCAP example threads through
  multiple cluster documents.

  §The-named-jcorbin-as-named-author-in-lore-text — line
  14 names the author "jcorbin" in the prose. Sibling shape
  to cycle 360's eslint-plugin Agoric-specific-attribution
  fossil — both name authors explicitly in source.

  §The-named-capability-vs-standard-object-distinction —
  lines 53-57: "Standard objects are generic containers
  that can have any methods attached / Capabilities are
  objects with *restricted* behavior determined by
  interface guards." The capability-vs-object distinction
  is named explicitly. §the-named-restricted-via-interface-
  guards-as-defining-feature as tier-3 meta-pattern.

  §The-named-partial-ingest-status-marker — frontmatter
  carries `status: partial-ingest` to indicate cycle 391
  did not read all 212 lines; the Gateway section and
  subsequent material remain for future complementary-lens
  cycles.

  Closes seven citation arcs: cycle 390 (1, adjacent
  forward; evoke/config.sh launch config → daemon-lore
  vocabulary; both establish the bot-fork's agent-and-
  program vocabulary) + cycle 367 (11, mint-purse-payment-
  as-canonical-OCAP-example recurs in lore) + cycle 377
  (4, POLA from secure-coding-guide recurs as named
  OCAP principle in lore) + cycle 369 (3, @endo/daemon
  README named the daemon as application runner; daemon-
  lore gives the program vocabulary for what runs IN the
  daemon) + cycle 360 (3, Agoric-specific-attribution
  fossil parallel: jcorbin as named author in prose) +
  cycle 326 (65) + cycle 322 (65). Pushes citation-arc-
  closures-in-pivot to FOUR-HUNDRED-SIXTEEN (409 + 7 net
  new).
---

Partial ingest of 212-line daemon-lore.md, the bot-fork's daemon glossary. §the-named-document-grown-by-LLM-rework-discipline (single most structurally interesting move; document explicitly grown by paste + LLM-rework + review loop); §the-named-document-written-by-agent-it-documents (meta-recursive). §the-named-lore-as-acknowledged-not-yet-organized-name; §the-named-typo-as-evidence-of-WIP-status (`deos` for `does`). §the-named-let-suffix-as-program-shape-vocabulary (caplet + runlet + worklet + weblet); §the-named-four-let-programs-by-shape. §the-named-caplet-as-capability-program; §the-named-program-lifetime-tied-to-capability-lifetime. §the-named-runlet-as-main-program. §the-named-worklet-as-Worker-caplet; §the-named-co-tenant-worker-with-YMMV-hedge. §the-named-weblet-as-WebView-caplet. §the-named-capability-as-identity-and-authority-twin-purposes; §the-named-twin-purpose-capability-framing. §the-named-four-named-OCAP-principles (Reference as Authority + Pass-by-reference + Encapsulation + POLA). §the-named-mint-makePurse-as-capability-example-recurs (from cycle 367); §the-named-mint-purse-payment-canonical-example-recurs-in-lore. §the-named-jcorbin-as-named-author-in-lore-text. §the-named-capability-vs-standard-object-distinction. Seven citation arcs closed.
