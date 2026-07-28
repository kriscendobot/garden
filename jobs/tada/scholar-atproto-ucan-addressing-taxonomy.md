All 42 files are on `origin/journal2`; the job worktree is clean (no garden `main2` changes were needed).

## Completion report

**Job:** `scholar-atproto-ucan-addressing-taxonomy` (scholar role, issue-inbox spine `issue-kriskowal-garden-34`).

### 1. Report posted

https://github.com/kriscendobot/garden/issues/34#issuecomment-5107168809 — issue left **OPEN** per `skills/issue-inbox`.

Every load-bearing claim is cited to a primary spec with version and status. Three findings correct or sharpen the maintainer's four-row taxonomy:

- **Row four splits.** Only self-certifying / verifiable-history methods (`did:plc`, `did:webvh`, degenerately `did:key`) are grounded in the authority to update. `did:web` is grounded in DNS, TLS, and write access to a path, so it belongs beside the URL row; the ATProto DID spec says so directly.
- **The ATProto reading is confirmed, with one real disanalogy.** Account migration is the proof (DID stays, `#atproto_pds` moves, repository CIDs invariant). But the PDS is the *authoritative* location, not an advisory hint, because a mutable repository needs someone to assert the current `rev`, and currency cannot be verified from content. That is the actual dividing line between the content-address and mutable-authority rows.
- **Noise does not belong beside OCapN locators and Iroh addresses.** Revision 34 (2018-07-11) defines no addressing, naming, or discovery; it is what makes a key-grounded designator meaningful, not a peer addressing scheme.

Status checks memory tends to get wrong, verified: DID 1.1 is a Candidate Recommendation Snapshot (05 March 2026), not a Recommendation, and declares resolution out of scope. DID-Linked Resources is real but a **Draft Community Group Report** whose `checksum` is a SHOULD-verify-when-present, not hash-as-identity. UCAN 1.0 text is published on `main` across sub-specs but tagging is inconsistent (latest tag `v1.0-rc.1`; Revocation self-describes `v1.0.0-rc.1`; sub-spec repos carry no tags) — pin the commit, not the version. ATProto now names its encoding DRISL, "successor to DAG-CBOR", at the same multicodec `0x71`.

Endo recommendation is narrow: keep UCAN out of the content-locator design (a reference beats a certificate wherever a CapTP session exists), file a separate design for third-party data-plane write authority if a non-CapTP publisher is needed, and state as a **non-goal** that a magnet URN must never grow a "latest version" affordance.

### 2. Library ingestion (4 sources, 18 sections)

`atproto--specs-did` (4), `atproto--specs-repository` (5), `ucan-wg--spec-readme` (5), `ucan-wg--delegation-readme` (4). All first ingests. New topic `decentralized-identifiers`; new concepts `atproto-repository-mst`, `did-document-service-endpoint`, `content-address-versus-signature`; existing `ucan-delegation` concept extended with 9 spec-proper rows; 12 topic pages, 4 README indexes, and `keywords.md` updated.

**Gates, all run and passing:** slug-prefix check OK; `library-link-check.sh` OK on the staged commit and re-run per-cluster against the landed tip; `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` landed as the final step, counts now idempotent-current.

### 3. Journal and follow-ups

- `result` entry `entries/2026/07/28/171449Z-result-gardener-5fa18b.md`.
- Follow-on job **`scholar-ingest-atproto-ucan-did-specs`** posted with the ISSUE NOTE verbatim, naming the exact remainder (`at://`, blobs, data model, sync, DID Core plus the 1.1 note, `did:plc`, UCAN Invocation and Revocation, the deferred sections of both UCAN sources, and the lower-priority method specs) plus its comment obligation.
- `message` entry to liaison `entries/2026/07/28/171508Z-message-gardener-fd5b4e.md`.

**One thing worth flagging:** the thread's last bot comment called endojs/endo-but-for-bots#662 a draft PR; it has since **merged** to `llm`. The report cites it as merged.

Self-improvement: `land-journal-edit.sh` takes its body file **positionally** (`[--base-blob <sha>] [--force] <path> [body-file]`), but `roles/scholar/AGENT.md` and `journal/library/conventions.md` describe it only as "body from a body-file or stdin", which reads like a `--body-file` flag — a 42-file landing loop written from the role brief failed on every file. Routed to liaison for a one-line correction in both places rather than edited myself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-atproto-ucan-addressing-taxonomy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 997 tokens (17145037 cached reads)
- Output: 105815 tokens
- Cost: $14.7707175
- Wall-clock: 1888s

<!-- garden-usage-end -->
