# Scholar: ingest W3C DID Core, did:plc, and the remaining UCAN specs

Wear the [scholar](../../roles/scholar/AGENT.md) role and continue the library
ingestion begun by `scholar-atproto-ucan-addressing-taxonomy` (result of
2026-07-28) and continued by `scholar-ingest-atproto-ucan-did-specs` (result of
2026-07-29). Those two cycles spent their budgets on eight sources; this job
picks up the named remainder. The maintainer's report is already on the issue
thread, so this is ingestion only, plus the comment obligation at the end.

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
| `atproto--specs-at-uri-scheme` | content SHA-256 `f52bbd10` | 5 |
| `atproto--specs-blob` | content SHA-256 `e9de13e4` | 4 |
| `atproto--specs-data-model` | content SHA-256 `519f0d90` | 6 |
| `atproto--specs-sync` | content SHA-256 `89ca2839` | 8 |

The ATProto specs set (DID, repository, AT URI scheme, blob, data model, sync)
is now complete in the library. Concepts touched so far:
`atproto-repository-mst`, `content-address-versus-signature`,
`did-document-service-endpoint`, `ucan-delegation`; topic
`decentralized-identifiers` is the taxonomy's home page.

## The remainder, in priority order

Respect the standing 3-to-5-source / ~25-section cycle budget and post a
further `scholar-*` job (carrying the ISSUE NOTE verbatim) for whatever is
left.

1. **W3C DID Core** (https://www.w3.org/TR/did-1.0/, Recommendation 19 July
   2022). The single most-cited missing source: the `service` /
   `serviceEndpoint` and `alsoKnownAs` normative language is currently quoted
   from the report and from ATProto's use of it rather than held in the
   library. Record the version note honestly:
   https://www.w3.org/TR/did-1.1/ is a **Candidate Recommendation Snapshot
   dated 05 March 2026** which moves verification relationships into
   Controlled Identifiers 1.0 and declares resolution out of scope (deferring
   to DID Resolution v0.3, a working draft). This is a large document; it may
   well be a cycle on its own.
2. **`did:plc` method spec**
   (https://raw.githubusercontent.com/did-method-plc/did-method-plc/main/website/spec/v0.1/did-plc.md).
   Genesis-hash derivation, rotation-key ordering, the 72-hour recovery
   window, and the bounded trust the PLC directory asks for. Repo source, so
   anchor on the file-specific commit, not the repo HEAD.
3. **UCAN Invocation** (https://github.com/ucan-wg/invocation) and **UCAN
   Revocation** (https://github.com/ucan-wg/revocation). Note honestly that
   Revocation's README self-describes as `v1.0.0-rc.1` while Invocation reads
   "Version 1.0.0", and that neither repository carries tags or releases.
4. **Deferred sections of the two UCAN sources already ingested**, named in
   their source pages: the UCAN spec's Lifecycle / Time / Token-Resolution /
   Nonce / Metadata / Implementation-Recommendations / FAQ / Related-Work
   sections, and the Delegation spec's full Policy detail (selectors, glob
   matching, connectives, quantification, differences from jq, validation
   semantics) plus Semantic Conditions.
5. **Lower priority, only if budget allows**: `did:web`
   (https://w3c-ccg.github.io/did-method-web/), `did:key` v0.9
   (https://w3c-ccg.github.io/did-key-spec/), `did:webvh` v1.0
   (https://identity.foundation/didwebvh/v1.0/), and DID-Linked Resources
   (https://w3c-ccg.github.io/did-linked-resources/, a **Draft Community Group
   Report**, not Recommendation-track; its `checksum` parameter is a
   SHOULD-verify when present, not hash-as-identity).

## Rules

- Use `scripts/jobs/scholar-staging-clone.sh` for staging and
  `scripts/jobs/land-journal-edit.sh` for every content file. W3C pages are
  `source_kind: web`; hash them with `scripts/jobs/fetch-source.sh`. The UCAN
  and `did:plc` specs are repository files: anchor on the file-specific
  commit, not the repo HEAD.
- **The staging clone is a single shared per-host path.** A concurrent scholar
  peer works in the same tree, so land each file as soon as you author it, and
  pass `--base-blob` to `land-journal-edit.sh` on every whole-file replacement
  of a shared index (a topic page, a concept page, `sources/README.md`,
  `keywords.md`). On a refusal, re-read the file from `origin/journal2` into a
  temp path, re-apply your rows there with
  `scripts/jobs/insert-sections-table-row.sh`, and re-land. The
  2026-07-29 cycle hit five such refusals and this loop cleared all of them.
- Run the step-8 integrity gates and the step-9 regenerators
  (`regenerate-sections-index.sh`, `regenerate-topics-counts.sh`) before
  completing. Note that `library-link-check.sh --changed` reports nothing once
  your files are already landed; scope with `--source-slug <slug>` instead.
- Note version and status honestly in every source page. Several of these
  specs moved recently and memory gets them wrong.

## Comment obligation

Do **not** re-post the report; it is already on the thread. When the ingestion
is complete (this job plus any successor it posts), add one short comment on
https://github.com/kriscendobot/garden/issues/34 saying which primary specs are
now in the garden's library and where, so the maintainer knows the citation
trail is durable. **Never close the issue**; the submitter closes it.
