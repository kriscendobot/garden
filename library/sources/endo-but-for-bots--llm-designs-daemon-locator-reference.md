---
source: designs/daemon-locator-reference.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f1d88c71845cc36187c078856e66014525c4c7f6
source_date: 2026-03-17
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-ninth-comment-style design ingest. 213-line *Current*
  status design (created 2026-03-18). The *canonical reference*
  for the Endo locator URL format. Pairs with cycle 49's
  daemon-locator-terminology (the *rename design*); this is the
  concrete *what the format actually is* document.

  Three locator formats:
    (a) Standard: `endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}`
    (b) With connection hints: adds repeated `at={address}` query parameters
    (c) Invitation: adds `from={hostHandleNumber}` parameter

  Single most structurally interesting move: the §externalize↔
  internalize duality with LOCAL_NODE sentinel.
    - `externalizeId(id, formulaType, agentNodeNumber, addresses?)`
      replaces LOCAL_NODE with the agent's own public key (so
      recipients know which peer to contact).
    - `internalizeLocator(locator, isLocalKey)` recognizes any
      known local agent key and normalizes to LOCAL_NODE (so
      internal storage is canonical across sibling agents).
    - Round-trip invariant: `internalId → externalizeId →
      internalizeLocator → internalId ✓`.

  §LOCAL_NODE sentinel `'0'.repeat(64)`: *all-zeros is never a
  valid Ed25519 public key, making it a safe sentinel for "this
  daemon"*. The §safe-by-impossibility-in-the-domain discipline:
  the sentinel is *not* a tagged or namespaced value — it's a
  value the domain itself rules out. Cryptographically
  negligible probability of collision.

  §Internal vs external distinction: internal `{number}:{node}`
  is compact, storage-efficient. External `endo://...` is
  URL-shaped, suitable for sharing.

  §Method taxonomy: nine methods organized into four families.
  Name Resolution (identify/locate/lookup → identifier/locator/
  value, same path input three output types). Reverse Resolution
  (reverseIdentify/reverseLocate/reverseLookup, symmetric six).
  Enumeration (list/listIdentifiers/listLocators). Writing
  (write internal-only; writeLocator accepts either; the
  §define-once-destructure-up discipline — defined in
  directory.js, carried up through host.js + guest.js *not
  re-implemented at each layer*). Subscription
  (followNameChanges, followLocatorNameChanges).

  §parseLocator strict validation: protocol must be `endo://`;
  node must be 64-char hex; required `id` + `type`; allowed
  `id`/`type`/`at`; *any other parameter causes validation
  failure*. The §reject-unknown-parameters discipline. Invitation
  locators bypass `parseLocator` because they have a `from`
  parameter — separate invitation-acceptance paths in daemon.js
  and host.js.

  §Connection hints (`at` parameters) are *ephemeral*: identifier
  stored durably; hints forwarded to peer info system via
  `addPeerInfo`; hints are *not stored with the formula — they
  are looked up fresh when producing a locator for sharing*. The
  §addressing-is-not-identity discipline: peer's network address
  may change; public key doesn't. Locators carry durable identity
  in `nodeNumber`/`id`/`type`; ephemeral `at` carries currently-
  reachable addresses.

  §Eight-file index covers the locator machinery decomposition:
  locator.js / formula-identifier.js / formula-type.js
  (primitives) → directory.js (method-providers) → host.js +
  guest.js + mail.js (method-carriers) → daemon.js (invitation
  construction).

  Cycle 135 was nominally papers-lane (cycle 134 was comments).
  Papers-lane has been blocked for 29+ consecutive cycles. Cycle
  135 pivoted to designs-lane. Second daemon-* design ingest
  after the endopi-* family closure (cycle 133 was the first
  with daemon-guest-eval-simplification).
---

> Abstract: `daemon-locator-reference.md` (213 lines, *Current*
> status) is the *canonical reference* for the Endo locator URL
> format. Pairs with cycle 49's `daemon-locator-terminology` (the
> *rename design*); this is the concrete *what the format
> actually is* document.
>
> §Three locator formats: standard (`endo://{node}/?id={n}&type={t}`),
> with connection hints (`&at={addr}`), invitation (`&from={hostHandle}`).
>
> **The single most structurally interesting move**: the
> §externalize↔internalize duality with LOCAL_NODE sentinel.
> `externalizeId` replaces LOCAL_NODE with the agent's own
> public key for external audiences; `internalizeLocator`
> recognizes any local agent key and normalizes to LOCAL_NODE
> for internal storage. *Round-trip invariant: internalId →
> externalizeId → internalizeLocator → internalId ✓*.
>
> §LOCAL_NODE = `'0'.repeat(64)` — *all-zeros is never a valid
> Ed25519 public key*. The §safe-by-impossibility-in-the-domain
> discipline: sentinel safe because the domain's structure
> prevents collision.
>
> §Nine-method taxonomy in four families: Name Resolution
> (identify/locate/lookup) / Reverse Resolution (reverseIdentify/
> reverseLocate/reverseLookup) / Enumeration (list/listIdentifiers/
> listLocators) / Writing (write/writeLocator) / Subscription
> (followNameChanges/followLocatorNameChanges). §writeLocator
> is the canonical write — defined once in directory.js,
> carried up through host.js + guest.js via destructuring.
>
> §parseLocator strict validation rejects unknown parameters;
> §invitation locators bypass (separate paths). §Connection
> hints are *ephemeral* — looked up fresh when producing a
> locator for sharing; the §addressing-is-not-identity
> discipline.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel](../sections/endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel.md) | daemon, ocapn | current |

Tight 213-line *Current* reference. The whole content hangs off
one mechanism: the locator-URL format + its
internalize↔externalize duality. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@f1d88c71` (the
  branch `origin/llm`) via the local bare-clone.
- Created 2026-03-18 by Kris Kowal. Last touched 2026-03-17 in
  commit `f1d88c71`.
- Status: *Current*. The reference is treated as the
  authoritative format spec.
- **Twenty-ninth-comment-style design ingest.** Pairs with cycle
  49's `daemon-locator-terminology` (rename design), cycle 51's
  `daemon-agent-network-identity` (LOCAL_NODE sentinel origin),
  cycle 60's `daemon-256-bit-identifiers` (256-bit identifier
  migration; Ed25519 public key as node ID). The four designs
  cover the locator topology.
- Cycle 135 was nominally **papers-lane** (cycle 134 was
  comments). Papers-lane has been blocked for **29+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 135
  pivoted to designs-lane.
- One cohesion-honest section.
