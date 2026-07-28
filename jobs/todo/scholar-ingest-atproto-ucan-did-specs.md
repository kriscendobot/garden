# Scholar: ingest the remaining ATProto / UCAN / DID primary specs

Wear the [scholar](../../roles/scholar/AGENT.md) role and continue the library
ingestion begun by `scholar-atproto-ucan-addressing-taxonomy` (result entry of
2026-07-28). That cycle spent its budget on four sources; this job picks up the
named remainder. The report the maintainer asked for is already posted on the
issue thread, so this job is ingestion only, with one small comment obligation
at the end (below).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-34
issue_url: https://github.com/kriscendobot/garden/issues/34#issuecomment-5100277860
submitter: kriskowal
----- END ISSUE NOTE -----

## Already ingested (do NOT re-ingest; run the idempotency check first)

| Source slug | Anchor | Sections |
|---|---|---|
| `atproto--specs-did` | content SHA-256 `624594bb` | 4 |
| `atproto--specs-repository` | content SHA-256 `bb8ddfac` | 5 |
| `ucan-wg--spec-readme` | commit `9955aa1f` | 5 |
| `ucan-wg--delegation-readme` | commit `1cb32dbc` | 4 |

New topic `decentralized-identifiers`; new concepts `atproto-repository-mst`,
`did-document-service-endpoint`, `content-address-versus-signature`; the
existing `ucan-delegation` concept was extended with the spec-proper rows.

## The remainder, in priority order

Respect the standing 3-to-5-source / ~25-section cycle budget and post a further
`scholar-*` job (carrying the ISSUE NOTE verbatim) for whatever is left.

1. **ATProto AT URI scheme** (https://atproto.com/specs/at-uri-scheme). Small
   but load-bearing for the taxonomy: `at://` is explicitly "not
   content-addressed" and handle-authority URIs "are not durable". File under
   `decentralized-identifiers` and `content-addressed-storage`; add rows to the
   `atproto-repository-mst` concept page.
2. **ATProto blobs** (https://atproto.com/specs/blob) and **data model**
   (https://atproto.com/specs/data-model). The DRISL-versus-DAG-CBOR story and
   the blessed CID formats live in the data-model page; the current corpus
   quotes them second-hand from the repository spec.
3. **ATProto sync / event stream** (https://atproto.com/specs/sync). The
   firehose, `#commit` and `#sync` events, relays, and inductive verification.
   Note in the source frontmatter that the published page carries no status
   marker.
4. **W3C DID Core** (https://www.w3.org/TR/did-1.0/, Recommendation 19 July
   2022) and the version note that https://www.w3.org/TR/did-1.1/ is a
   **Candidate Recommendation Snapshot dated 05 March 2026** which moves
   verification relationships into Controlled Identifiers 1.0 and declares
   resolution out of scope (deferring to DID Resolution v0.3, a working draft).
   This is the single most-cited missing source: the `service` /
   `serviceEndpoint` and `alsoKnownAs` normative language is currently quoted
   from the report rather than held in the library.
5. **`did:plc` method spec**
   (https://raw.githubusercontent.com/did-method-plc/did-method-plc/main/website/spec/v0.1/did-plc.md).
   Genesis-hash derivation, rotation-key ordering, the 72-hour recovery window,
   and the bounded trust the PLC directory asks for. Repo source, so anchor on
   the file-specific commit.
6. **UCAN Invocation** (https://github.com/ucan-wg/invocation) and **UCAN
   Revocation** (https://github.com/ucan-wg/revocation). Note honestly that
   Revocation's README self-describes as `v1.0.0-rc.1` while Invocation reads
   "Version 1.0.0", and that neither repository carries tags or releases.
7. **Deferred sections of the two UCAN sources already ingested**, named in
   their source pages: the UCAN spec's Lifecycle / Time / Token-Resolution /
   Nonce / Metadata / Implementation-Recommendations / FAQ / Related-Work
   sections, and the Delegation spec's full Policy detail (selectors, glob
   matching, connectives, quantification, differences from jq, validation
   semantics) plus Semantic Conditions.
8. **Lower priority, only if budget allows**: `did:web`
   (https://w3c-ccg.github.io/did-method-web/), `did:key` v0.9
   (https://w3c-ccg.github.io/did-key-spec/), `did:webvh` v1.0
   (https://identity.foundation/didwebvh/v1.0/), and DID-Linked Resources
   (https://w3c-ccg.github.io/did-linked-resources/, a **Draft Community Group
   Report**, not Recommendation-track; its `checksum` parameter is a SHOULD-verify
   when present, not hash-as-identity).

## Rules

- Use `scripts/jobs/scholar-staging-clone.sh` for staging and
  `scripts/jobs/land-journal-edit.sh` for every content file. The ATProto pages
  are `source_kind: web`; hash them with `scripts/jobs/fetch-source.sh`. The
  UCAN and `did:plc` specs are repository files: anchor on the file-specific
  commit, not the repo HEAD.
- The atproto.com content hash covers site chrome as well as spec prose, so a
  navigation change can trip the idempotency check without the spec having
  changed. Re-read before concluding a source is stale.
- Run the step-8 integrity gates and the step-9 regenerators
  (`regenerate-sections-index.sh`, `regenerate-topics-counts.sh`) before
  completing.
- Note version and status honestly in every source page. Several of these specs
  moved recently and memory gets them wrong.

## Comment obligation

Do **not** re-post the report; it is already on the thread. When the ingestion
is complete (this job plus any successor it posts), add one short comment on
https://github.com/kriscendobot/garden/issues/34 saying which primary specs are
now in the garden's library and where, so the maintainer knows the citation
trail is durable. **Never close the issue**; the submitter closes it.

<!-- garden-reaped: 1 -->
