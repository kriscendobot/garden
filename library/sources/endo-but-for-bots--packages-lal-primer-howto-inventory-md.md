---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/howto-inventory.md
source_line_range: 1-133
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 439 designs-lane ingest. 133-line howto-
  inventory.md from @endo/lal's agent-facing primer.
  Completes the howto-* trio alongside the already-
  ingested howto-code.md (cycle 409) and howto-
  capabilities.md (cycle 437). Eighty-seventh AUTHORED
  conformant single-body section doc in post-refactor
  era. One-hundred-and-twenty-ninth consecutive non-
  garden source after the pivot (310-439).
  §one-hundred-and-twenty-nine-cycles-with-named-pivot-
  domain-stay.

  Single most structurally interesting move: §the-named-
  pet-names-as-gc-roots — lines 118-121: "Warning: if
  the garbage collector is enabled and you remove all
  names for a capability you've shared, the other party
  loses access." This reveals that the inventory naming
  layer is not just a human-readable alias system but
  the LIVENESS LAYER for capability access. Pet names
  are GC roots: as long as ANY local name points to a
  shared capability, the other party can still access
  it; when ALL names are removed, the GC may collect the
  capability, revoking the remote party's access. The
  user-facing /rm command thus has a remote-access
  side-effect when the GC is enabled. §the-named-
  naming-layer-as-liveness-layer as tier-3 meta-pattern.
  The cluster has framed cotenant (cycle 433, horizontal
  isolation), exfiltration (cycle 436, outbound), and
  execution-context-leak (cycle 438, trusted window);
  cycle 439 names a fourth dimension: LIVENESS-REVOCATION
  via GC — when all names are removed, access is revoked
  at the GC boundary. §the-named-liveness-revocation-as-
  fourth-security-dimension as tier-3 meta-pattern.

  §the-named-special-name-vs-pet-name-user-facing-
  vocabulary — lines 4-9: special names are @-prefixed
  read-only indelible names (@self, @host, @agent, etc.);
  pet names are user-chosen lowercase-alphanumeric-with-
  hyphens. The USER-FACING vocabulary maps "special name"
  to the @-prefixed kind. Cycle 394's pet-name.js named
  THREE naming namespaces from the implementation: (1)
  lowercase-pet-name, (2) UPPERCASE-special-name (HOST
  etc.), (3) @-prefixed-lowercase. The user-facing
  howto collapses this to TWO: special names (= @-
  prefixed, indelible) vs pet names (= user-chosen,
  mutable). The UPPERCASE namespace is a code-internal
  concern that does not appear in user documentation.
  §the-named-user-facing-namespace-simpler-than-
  implementation-namespace as tier-3 meta-pattern.

  §the-named-Chat-only-features-with-no-cli-equivalent
  — lines 40-44: "/view is read-only; /edit lets you
  change and save. Both are Chat-only features with no
  direct CLI equivalent." Reinforces cycle 409's CLI-as-
  privilege-escalation: the asymmetry runs BOTH directions.
  CLI has UNCONFINED (not in Chat); Chat has /view and
  /edit (not in CLI). The two surfaces each hold
  operations the other cannot. §the-named-chat-and-cli-
  as-non-overlapping-operation-sets as tier-3 meta-
  pattern. Sibling to cycle 409's one-direction framing
  (CLI has what Chat lacks); cycle 439 names the reverse
  (Chat has what CLI lacks).

  §the-named-checkin-as-cli-only-privilege — lines 78-80:
  "This is a CLI-only operation — it accesses the local
  filesystem directly." checkin requires CLI because it
  needs local filesystem access; Chat cannot do it. Same
  structural reason as cycle 409's UNCONFINED-only-on-CLI
  (direct host access requires CLI). §the-named-local-
  filesystem-access-requires-cli as tier-3 meta-pattern.

  §the-named-rm-removes-name-not-value — lines 114-116:
  "This removes the name, not the underlying value. Other
  names pointing to the same value are unaffected." Pure
  reference semantics: the inventory is a namespace over
  capabilities; names and capabilities are distinct
  layers. §the-named-name-value-separation-in-inventory
  as tier-3 meta-pattern.

  §the-named-mktmp-for-daemon-managed-scratch — line 73:
  "/mktmp -n scratch". A scratch directory managed by the
  daemon lifecycle rather than the user's own filesystem.
  §the-named-daemon-managed-scratch-vs-user-mounted-dir
  as tier-3 meta-pattern.

  §the-named-inventory-full-crud-in-one-howto — the
  howto covers CREATE (/mount, endo checkin), READ (/ls,
  /view), UPDATE (/edit, /mv, /cp), DELETE (/rm), plus
  SHARE (/share + /adopt-locator). A complete CRUD+ map
  of the inventory surface. §the-named-inventory-as-full-
  crud-namespace as tier-3 meta-pattern; the pet-name
  layer is a full namespace with create/read/update/
  delete/share operations.

  §the-named-share-plus-adopt-as-cross-node-cap-transfer
  — lines 124-133: /share returns a locator URL; /adopt-
  locator on another machine binds it. Same mechanism as
  cycle 437's howto-capabilities.md cross-network sharing.
  §the-named-locator-as-portable-cap-reference as tier-3
  meta-pattern; the locator is the portable form of the
  capability reference across machines.

  §the-named-eighty-seven-conformant-cycles-and-counting.

  Closes ten citation arcs: cycle 438 (1, adjacent
  forward; navigation-guard chat-lane precedes this
  designs-lane) + cycle 437 (3, howto-inventory completes
  the howto-* trio; primer now has three howto docs,
  each covering a distinct user-facing surface) + cycle
  409 (3, CLI-only-for-privilege: checkin is CLI-only
  for same reason as UNCONFINED; Chat/CLI asymmetry now
  named in both directions) + cycle 394 (5, MAJOR
  REFINEMENT — three-namespace implementation collapses
  to two-namespace user-facing vocabulary; UPPERCASE
  special names are code-internal) + cycle 429 (3,
  CapTP at user-facing layer; /share + /adopt-locator
  closes cross-network cap transfer) + cycle 433 (3,
  cotenant + liveness; GC-based liveness-revocation is
  fourth security dimension alongside cotenant/
  exfiltration/execution-context-leak) + cycle 416 (3,
  trust-boundary — pet names as GC roots; naming is
  the liveness mechanism) + cycle 326 (75) + cycle 322
  (75) + cycle 435 (3, Chat affordances confirmed —
  /view and /edit are Chat-only with no CLI equivalent).
  Pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-
  AND-FIFTY-TWO (842 + 10 net new).
---

133-line howto-inventory.md from @endo/lal's agent-facing primer. Completes the howto-* trio (howto-code cycle 409, howto-capabilities cycle 437, howto-inventory cycle 439). Designs-lane after cycle 438 chat-lane familiar/src/navigation-guard.js. **Single most structurally interesting move**: §the-named-pet-names-as-gc-roots — *lines 118-121: "Warning: if the garbage collector is enabled and you remove all names for a capability you've shared, the other party loses access." The inventory naming layer is not just a human-readable alias system but the LIVENESS LAYER: pet names are GC roots, and removing ALL names for a shared capability may revoke the remote party's access. The user-facing /rm command has a remote-access side-effect when the GC is enabled.* §the-named-naming-layer-as-liveness-layer as tier-3 meta-pattern. The cluster's security vocabulary now spans FOUR dimensions: COTENANT (cycle 433) + EXFILTRATION (cycle 436) + EXECUTION-CONTEXT-LEAK (cycle 438) + LIVENESS-REVOCATION (cycle 439). §the-named-liveness-revocation-as-fourth-security-dimension. §the-named-special-name-vs-pet-name-user-facing-vocabulary: user-facing "special names" = @-prefixed indelible (@self, @host, @agent); user-facing "pet names" = user-chosen mutable. Cycle 394's three-namespace implementation (lowercase, UPPERCASE, @-prefixed) collapses to two user-facing namespaces; UPPERCASE is code-internal. §the-named-user-facing-namespace-simpler-than-implementation-namespace. §the-named-Chat-only-features-with-no-cli-equivalent (lines 40-44: /view and /edit are Chat-only; the CLI/Chat asymmetry runs BOTH directions — CLI has UNCONFINED, Chat has /view+/edit); §the-named-chat-and-cli-as-non-overlapping-operation-sets (sibling to cycle 409's one-direction framing). §the-named-checkin-as-cli-only-privilege; §the-named-local-filesystem-access-requires-cli. §the-named-rm-removes-name-not-value (reference semantics: name and capability are distinct layers); §the-named-name-value-separation-in-inventory. §the-named-mktmp-for-daemon-managed-scratch; §the-named-daemon-managed-scratch-vs-user-mounted-dir. §the-named-inventory-full-crud-in-one-howto (CREATE + READ + UPDATE + DELETE + SHARE); §the-named-inventory-as-full-crud-namespace. §the-named-share-plus-adopt-as-cross-node-cap-transfer; §the-named-locator-as-portable-cap-reference. §the-named-eighty-seven-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-FIFTY-TWO.
