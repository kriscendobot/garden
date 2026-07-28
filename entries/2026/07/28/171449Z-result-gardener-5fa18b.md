---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-28T17:14:51Z
---
project: garden
repo: kriscendobot/garden

# scholar cycle: ATProto and UCAN in the addressing/authentication taxonomy

Job `scholar-atproto-ucan-addressing-taxonomy`, from the garden's own issue
inbox (issue spine `issue-kriskowal-garden-34`, submitter kriskowal). Two
deliverables: a source-cited report on the issue thread, and library ingestion
of the primary specs.

## Report

Posted to https://github.com/kriscendobot/garden/issues/34#issuecomment-5107168809
(issue left OPEN, per `skills/issue-inbox`). It answers the two questions
(does the DID row have a connection-hint analogue; how do ATProto and UCAN fit
the taxonomy) and extends the maintainer's four rows into a table with explicit
axes. Three corrections to the earlier partial answer are load-bearing:

1. **Row four splits.** Only self-certifying / verifiable-history DID methods
   (`did:plc`, `did:webvh`, degenerately `did:key`) are grounded in the
   authority to update. `did:web` is grounded in DNS plus TLS plus write access
   to a path, so it collapses back into the URL row; the ATProto DID spec says
   so directly ("does not provide a mechanism for migration or recovering from
   loss of control of the domain name").
2. **The ATProto reading holds, with one genuine disanalogy.** The layering is
   confirmed and the account-migration guide is the proof (the DID stays, the
   `#atproto_pds` endpoint moves, the repository CIDs are invariant). But the
   PDS is the *authoritative* location, not an advisory hint, because a mutable
   repository needs someone to say what the current `rev` is, and currency
   cannot be verified from content. That is the real dividing line between the
   content-address row and the mutable-authority row.
3. **Noise does not belong beside OCapN locators and Iroh addresses.** Noise
   (Revision 34, 2018-07-11) defines no addressing, naming, or discovery; it is
   the mechanism that makes a key-grounded designator meaningful, not a peer of
   the two addressing schemes.

Also reported: DID-Linked Resources is real and current but a **Draft Community
Group Report** whose integrity check is a SHOULD-verify-when-present `checksum`,
not hash-as-identity; DID 1.1 is a Candidate Recommendation Snapshot (05 March
2026), not a Recommendation, and declares resolution out of scope; UCAN's 1.0
text is published on `main` across the sub-specs but tagging is inconsistent
(latest tag `v1.0-rc.1`, Revocation self-describes `v1.0.0-rc.1`, sub-spec repos
carry no tags), so pin the commit rather than the version string.

The Endo recommendation is deliberately narrow: keep UCAN out of the
content-locator design (a reference beats a certificate wherever a CapTP session
exists), and file a separate design for third-party data-plane write authority
if a non-CapTP publisher is ever needed. One non-goal is proposed for the
content-locator design: a magnet URN must never grow a "latest version"
affordance, because that would make every source trusted-for-freshness.

## Ingested (4 sources, 18 sections)

| Source | Kind | Anchor | Sections |
|---|---|---|---|
| `atproto--specs-did` | web | content SHA-256 `624594bb` (fetched `direct`) | 4 |
| `atproto--specs-repository` | web | content SHA-256 `bb8ddfac` (fetched `direct`) | 5 |
| `ucan-wg--spec-readme` | repo | commit `9955aa1f` (2026-07-08) | 5 |
| `ucan-wg--delegation-readme` | repo | commit `1cb32dbc` (2026-07-08) | 4 |

No source was skipped as already-current: all four are first ingests, so the
idempotency check had no recorded anchor to match.

## Index pages touched

- **New topic**: `decentralized-identifiers` (the DID family as one row in the
  addressing taxonomy; the method split; the parsing contract; ATProto as the
  worked example). Deliberately distinct from `identity` (identity
  decomposition) and `ucan-authorization` (DIDs as principals).
- **New concepts**: `atproto-repository-mst`, `did-document-service-endpoint`,
  `content-address-versus-signature`.
- **Extended concept**: `ucan-delegation` gained 9 rows pointing at the spec
  proper, so the existing dialog-db-derived page is no longer the only evidence.
- **Topic pages with new section rows**: `decentralized-identifiers`,
  `content-addressed-storage`, `ucan-authorization`, `capability-security`,
  `capability-theory`, `identity`, `networking`, `persistence`,
  `data-structures`, `local-first-sync`, `marshal`, `patterns`.
- **README indexes**: `sources/README.md` gained a new
  "Addressing and authorization specifications (ATProto, UCAN)" section with
  four rows (re-composed onto the tip after a peer edit tripped the lander's
  base-blob guard, which is the guard working as intended);
  `topics/README.md` gained the `decentralized-identifiers` Index row;
  `concepts/README.md` gained three bullets; `keywords.md` gained four lines.

## Library-organization decisions (scholar discretion)

- **A new topic rather than stretching `identity`.** `identity` is about how
  identity decomposes into separable identifiers (the tripartite pattern).
  The DID material is about one identifier kind and its resolvable document,
  and it needed to sit beside `content-addressed-storage` as its complement.
  Bending `identity` to hold both would have blurred the partition.
- **`content-address-versus-signature` as a concept, not a section.** The
  hash-authenticates-bytes versus signature-authenticates-an-assertion
  distinction is the single most reusable idea in this cycle and it is not
  owned by any one source. A concept page is the right home; the ATProto
  commit-signing section is its sharpest primary citation.
- **ATProto specs ingested as `source_kind: web`, not as repo files.** The
  atproto.com pages are the canonical published form; the website repository
  path could not be resolved from the API. Recorded honestly in `notes:`,
  including the caveat that the content hash covers site chrome, so a
  navigation change can trip the check without the spec changing.

## Gates

- `library-slug-prefix-check.sh --changed --allow-new-prefix`: OK (both
  `atproto--*` slugs are a new host with no siblings to diverge from).
- `library-link-check.sh --changed` on the staged commit: OK. Re-run
  `--source-slug` on all four clusters against the landed tip: OK.
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh`: both landed
  as the final step; the topics-count check is now idempotent-current.

## Follow-on

Posted `scholar-ingest-atproto-ucan-did-specs` (carrying the ISSUE NOTE
verbatim) for the named remainder: the `at://` URI scheme, blobs, the data
model, sync, W3C DID Core plus the 1.1 status note, the `did:plc` method spec,
UCAN Invocation and Revocation, the deferred sections of the two UCAN sources
already ingested, and the lower-priority `did:web` / `did:key` / `did:webvh` /
DID-Linked-Resources set. It carries a comment obligation to tell the maintainer
where the citation trail lives once ingestion completes, and the standing
never-close-the-issue rule.

Self-improvement: `land-journal-edit.sh` takes its body file **positionally**
(`[--base-blob <sha>] [--force] <path> [body-file]`), but both `roles/scholar/AGENT.md`
and `journal/library/conventions.md` describe it only as "body from a body-file
or stdin", which reads like a `--body-file` flag. A 42-file landing loop written
from the role brief failed on every file before the usage line was read. Worth a
one-line correction in the role brief's *Land content edits through the lander*
bullet showing the literal argument order. Routing this per
`skills/self-improvement` rather than editing the role file myself.
