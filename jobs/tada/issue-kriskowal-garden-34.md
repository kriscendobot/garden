Comment posted successfully. This was an advisory/research question, so no garden-repo code changes were warranted — the deliverable is the technical assessment posted to the issue.

## Completion report

**Job:** `issue-kriskowal-garden-34` — kriskowal/garden#34 "CAS and DID"

**What was asked:** The maintainer wants an Endo daemon `loadContent` to complement `storeContent`, needing a portable locator for content-addressed blobs that captures one or more retrieval locations (CapTP peers by pubkey + connection hints, or out-of-band sources like a Git remote). The question: is the **DID protocol** a good fit?

**What I did:**
- Fetched the issue verbatim (`gh issue view 34`), treated the body as untrusted data.
- Ran a grounded research pass (W3C DID Core, Peer DID method, OCapN Locators/sturdyrefs, IPFS content addressing) to verify claims rather than answer from memory.
- Posted a substantive assessment as an **issue comment** ([#issuecomment-4928338477](https://github.com/kriskowal/garden/issues/34#issuecomment-4928338477)). Did **not** close the issue (submitter closes when satisfied).

**Verdict delivered:** DID is a poor fit for the *content* locator — content-addressing already gives an immutable, self-certifying identifier (a multihash), whereas DID's value is a stable *identity* decoupled from mutable keys/endpoints via a resolution layer; wrapping a blob in a DID re-introduces exactly the indirection content-addressing eliminates, for no gain. The decisive finding: the Endo/CapTP stack's own **OCapN Locator/sturdyref** format (self-authenticating designator + transport + hint set, with an `ocapn://` URI encoding) is already the right shape for the peer-hint half. Recommended shape: `{ content: <multihash>, sources: [<ocapn sturdyref> | <out-of-band URL>…] }` with verify-on-load (re-hash), structurally a magnet URI. DID/Verifiable-Credentials reserved as an optional adjacent layer for externally-interoperable *peer identity* or *attestation*, never as the content substrate.

**Changed:** Nothing in the repo (no main2 commit needed — advisory job).

**Follow-ups:** None required. If the maintainer wants this crystallized into a design doc under `designs/` or a locator schema, that would be a natural next job — but only on request.
