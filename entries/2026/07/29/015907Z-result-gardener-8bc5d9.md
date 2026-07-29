---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-29T01:59:22Z
---
project: garden
issue_spine: issue-kriskowal-garden-34

Scholar cycle for job `scholar-ingest-atproto-ucan-did-specs`: ingested the
four remaining ATProto primary specs named as priority items 1-3 of the job.
The ATProto specs set in the library is now complete (DID, repository, AT URI
scheme, blob, data model, sync).

## Sources ingested (4 sources, 23 sections)

| Source slug | URL | Anchor | Sections |
|---|---|---|---|
| `atproto--specs-at-uri-scheme` | https://atproto.com/specs/at-uri-scheme | content SHA-256 `f52bbd10` | 5 |
| `atproto--specs-blob` | https://atproto.com/specs/blob | content SHA-256 `e9de13e4` | 4 |
| `atproto--specs-data-model` | https://atproto.com/specs/data-model | content SHA-256 `519f0d90` | 6 |
| `atproto--specs-sync` | https://atproto.com/specs/sync | content SHA-256 `89ca2839` | 8 |

All four fetched through `scripts/jobs/fetch-source.sh`, all
`source_fetched_via=direct`. All are `source_kind: web`; the anchor is the
content hash over the rendered page bytes, and every source page repeats the
standing caveat that the hash covers site chrome as well as spec prose. No
idempotency skips: none of these four had a prior source page.

Nothing was ingested for priority items 4-8 (W3C DID Core, `did:plc`, UCAN
Invocation and Revocation, the deferred UCAN sections, the lower-priority DID
methods); they are the deferred backlog, carried by the follow-on job below.

## What the four sources add that the corpus did not have

- **`at://` is explicitly not content-addressed** and handle-authority URIs
  "are not durable", with the spec's own remedy: pair the AT URI with a CID
  when a strong reference is required. The taxonomy previously had this
  second-hand from the repository spec.
- **The primary DRISL-versus-DAG-CBOR statement** and the blessed CID set in
  full, which the repository and blob specs both cite rather than state.
- **Inductive verification by operation inversion** stated as a design
  argument (holding a full MST per repository is "unrealisticly expensive at
  scale"), plus the honest caveat that `since` and `prevData` "are neither
  authenticated (signed) nor self-certifying".
- **The boundary of self-certification in a deployed federation**: repository
  data verifies offline, identity and account data does not, a gap in one
  repository's commit stream is detectable but wholesale filtering of that
  repository is not.

## Pages touched

- Topics (9, all pre-existing, no new topic pages): `decentralized-identifiers`
  (+11 rows), `content-addressed-storage` (+14), `local-first-sync` (+8),
  `data-structures` (+5), `networking` (+4), `endpoint-security` (+4),
  `persistence` (+3), `identity` (+1), `multi-tenant-platform` (+1).
- Concepts (3, all extended, none new): `atproto-repository-mst` (+14 rows),
  `content-address-versus-signature` (+4), `did-document-service-endpoint`
  (+3). While landing `did-document-service-endpoint` I removed a duplicated
  `## Sections that touch this concept` heading, a pre-existing defect.
- Indexes: `sources/README.md` (+4 rows in the addressing-taxonomy web-source
  table), `keywords.md` (+2 lines, both resolving to `atproto-repository-mst`).

## Integrity gate (step 8) and regenerators (step 9)

- `library-link-check.sh --source-slug <slug>` for each of the four slugs: OK,
  every checked link resolves to a committed file. (`--changed` reported "no
  changed library source/section files" because the files were already landed
  by the time the gate ran; `--source-slug` is the right scope after landing.)
- `regenerate-topics-counts.sh --check`: STALE as expected before step 9, with
  no missing topic page.
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both ran and
  landed as the final landing step (`library/sections/README.md` and
  `library/topics/README.md` on `origin/journal2`).

## Follow-on job

Posted `scholar-ingest-did-core-plc-ucan-specs`, carrying the ISSUE NOTE
verbatim, naming the remainder in priority order: W3C DID Core (with the
DID 1.1 Candidate Recommendation Snapshot version note), `did:plc`, UCAN
Invocation and Revocation, the deferred UCAN sections, and the lower-priority
DID methods.

## Comment obligation deferred, not dropped

The job's comment obligation fires "when the ingestion is complete (this job
plus any successor it posts)". A successor exists, so no comment was posted on
https://github.com/kriscendobot/garden/issues/34 this cycle; the obligation is
carried verbatim in the follow-on job body. The issue was not closed.

## Operating note for the next scholar cycle

`scholar-staging-clone.sh` returns a single shared per-host path
(`.garden-state/scholar-staging/journal`). A concurrent scholar peer was
working in the same tree during this cycle, so five whole-file topic-page lands
were correctly refused by `land-journal-edit.sh --base-blob`. The clearing loop
(re-read the file from `origin/journal2` into a temp path, re-apply rows with
`insert-sections-table-row.sh` there, re-land with the fresh base blob) worked
every time and is written into the follow-on job's Rules section.
