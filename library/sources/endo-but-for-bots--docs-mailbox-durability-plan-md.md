---
source_kind: design-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: docs/mailbox-durability-plan.md
source_line_range: 1-140
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: partial-ingest
notes: |
  Cycle 393 designs-lane ingest. Partial ingest (first 140
  of 189 lines) of mailbox-durability-plan.md, the bot-
  fork's plan for making mailbox state persist across
  daemon restarts. Forty-first AUTHORED conformant single-
  body section doc in post-refactor era. Eighty-third
  consecutive non-garden source after the pivot (310-393).
  §eighty-three-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  mailbox-as-pet-store-with-naming-convention-overlay —
  the mailbox is not a NEW persistence abstraction; it is
  a NAMING CONVENTION layered on top of the existing pet
  store primitive. Decimal-digit names ("0", "1", "2", ...)
  are message slots; "next-number" is the reserved name
  for the counter. The schema is encoded in the names
  themselves. §the-named-naming-convention-as-schema-
  overlay as tier-3 meta-pattern. Sibling shape to cycle
  374's petname-substitution-in-transit, cycle 386's
  petname-regex-validates-and-extracts, cycle 388's types-
  index naming-as-convention — all use naming as schema.

  §The-named-stable-message-id-depends-on-durability —
  lines 5-7: "Stable message identifiers depend on
  messages having identities that persist." Persistence
  is the PRECONDITION for stable identity. The two
  problems are sequenced: solve durability first, then
  stable identifiers. §the-named-durability-precedes-
  identity as tier-3 meta-pattern.

  §The-named-defer-stable-identifier-until-after-durability
  — lines 10-11: "We defer the question of stable message
  identifiers until after durability is in place." The
  design doc explicitly defers a second problem. §the-
  named-design-doc-defers-second-problem-explicitly as
  tier-3 meta-pattern; the document names what it is NOT
  solving and explains why the sequencing matters.

  §The-named-next-number-as-reserved-name — alongside
  decimal-digit message-slot names, "next-number" is a
  reserved name. §the-named-reserved-name-alongside-data-
  names as tier-3 meta-pattern.

  §The-named-message-stored-as-formula-identifier-not-
  content — line 36-37: "The value stored is the formula
  identifier of a persisted message (see below)." Slot
  values are FORMULA IDENTIFIERS pointing to the actual
  persisted messages, not the message content directly.
  Indirection via formula identifier. §the-named-
  indirection-via-formula-identifier as tier-3 meta-
  pattern; the mailbox store names map to formula IDs;
  formulas hold the actual content.

  §The-named-rehydrate-on-restart — line 17: "After a
  daemon restart, each mailbox is rehydrated from
  storage." Rehydration is the named operation for re-
  creating in-memory state from persisted state. §the-
  named-rehydrate-from-store-on-restart as tier-3 meta-
  pattern.

  §The-named-pet-store-as-reused-pattern — line 9: "using
  the same patterns we already have (pet store, formula
  graph)." The design EXPLICITLY uses existing daemon
  primitives. §the-named-discipline-of-reusing-existing-
  patterns as tier-3 meta-pattern; the design choice is
  to NOT invent a new primitive when an existing one
  fits.

  §The-named-counter-proposal-risk-acknowledged — lines
  63-67: "Counter-proposal risk: The back-and-forth in
  the eval-proposal workflow risks a host counter-
  proposing with an endowment the guest should not have.
  We may later remove or rework counter-proposals to
  mitigate this, but keep it in mind for now." The design
  names a known risk it has not yet solved, and asks the
  reader to remember it. §the-named-known-risk-deferred-
  with-explicit-remember-note as tier-3 meta-pattern;
  sibling honest-acknowledgment shape from cycles 357/
  359/372/375/377/378/379/390/391.

  §The-named-StampedMessage-rehydration-creates-fresh-
  dismissers — lines 80-85: on rehydration the daemon
  reconstructs StampedMessage with new dismisser exos and
  new promises; "any pre-restart dismisser references
  held by clients become invalid or are re-established by
  convention." Pre-restart client-held dismissers are
  acknowledged as breakable. §the-named-restart-breaks-
  pre-restart-references-by-convention as tier-3 meta-
  pattern; the design names what won't survive across
  restarts.

  §The-named-implementation-chooses-minimal-approach —
  lines 103-104: "Implementation chooses the minimal
  approach that fits the existing formula and persistence
  layers." The design defers a specific choice to the
  implementer. §the-named-design-defers-to-implementer-
  for-minimal-fit as tier-3 meta-pattern.

  §The-named-dismiss-by-delete-not-mark — lines 134-136:
  "the plan prefers delete so the store does not grow
  without bound for dismissed messages." Two options
  named (delete vs mark-as-dismissed); the choice and
  the reason are named together. §the-named-design-
  choice-with-named-alternative-and-reason as tier-3
  meta-pattern.

  §The-named-partial-ingest-status-marker — frontmatter
  carries `status: partial-ingest` for the 49 unread
  lines (followMessages and rehydration section + later
  material).

  §The-named-eval-proposal-with-petNamePaths-and-codeNames
  — lines 58-60: "The reviewer message should carry
  `petNamePaths` alongside `codeNames` so the host can
  resolve endowments in the guest's namespace at approval
  time." The eval-proposal message includes a path-and-
  name pair for endowment resolution. §the-named-
  petNamePaths-plus-codeNames-pair as tier-3 meta-
  pattern; sibling to cycle 386's petname-edgename-
  naming-inversion in shape (two-component naming for
  capability references).

  Closes seven citation arcs: cycle 392 (1, adjacent
  forward; runlet shape concrete in code + mailbox shape
  designed via existing primitives; both apply the
  discipline of reusing existing patterns) + cycle 391
  (2, daemon-lore mentioned mailbox; cycle 393 expands
  the durability plan) + cycle 374 (6, petname-
  substitution sibling for naming-as-schema; mailbox
  uses decimal names as schema overlay) + cycle 369 (5,
  daemon README named daemon as application runner;
  mailbox is a daemon-managed primitive) + cycle 357 (3,
  honest-acknowledgment sibling for counter-proposal-
  risk) + cycle 326 (67, pure-naming-as-discipline) +
  cycle 322 (67). Pushes citation-arc-closures-in-pivot
  to FOUR-HUNDRED-THIRTY (423 + 7 net new).
---

Partial ingest of 189-line mailbox-durability-plan.md (first 140 lines). §the-named-mailbox-as-pet-store-with-naming-convention-overlay (single most structurally interesting move; mailbox is NAMING CONVENTION on pet store, not new abstraction); §the-named-naming-convention-as-schema-overlay (sibling to cycles 374/386/388). §the-named-stable-message-id-depends-on-durability; §the-named-durability-precedes-identity. §the-named-defer-stable-identifier-until-after-durability; §the-named-design-doc-defers-second-problem-explicitly. §the-named-next-number-as-reserved-name. §the-named-message-stored-as-formula-identifier-not-content; §the-named-indirection-via-formula-identifier. §the-named-rehydrate-on-restart. §the-named-pet-store-as-reused-pattern; §the-named-discipline-of-reusing-existing-patterns. §the-named-counter-proposal-risk-acknowledged (sibling honest-acknowledgment shape); §the-named-known-risk-deferred-with-explicit-remember-note. §the-named-StampedMessage-rehydration-creates-fresh-dismissers; §the-named-restart-breaks-pre-restart-references-by-convention. §the-named-implementation-chooses-minimal-approach; §the-named-design-defers-to-implementer-for-minimal-fit. §the-named-dismiss-by-delete-not-mark; §the-named-design-choice-with-named-alternative-and-reason. §the-named-eval-proposal-with-petNamePaths-and-codeNames. Seven citation arcs closed.
