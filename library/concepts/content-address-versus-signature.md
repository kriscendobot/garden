---
id: content-address-versus-signature
aliases: [content address vs signature, hash versus signature, what a hash authenticates, what a signature authenticates, verify-on-load, self-verifying bytes, attestation by digest, signature over a content address, xt, exact topic]
topics: [content-addressed-storage, decentralized-identifiers, capability-security]
---

# content-address-versus-signature

Two verification primitives are routinely conflated and do different jobs. **A hash authenticates the bytes**: it is checkable by anyone, offline, forever, against nothing but the bytes themselves, with no key, resolver, clock, expiry, or revocation in the path. **A signature authenticates an assertion about bytes by a key**: to check it you need the current key material, which means resolution, which means a live lookup against mutable state. The consequence that matters when designing a locator: signature verification degrades with time and key rotation, hash verification does not. ATProto states this cost out loud in its own repository specification, and it is the clearest available statement of the trade: an atproto commit signs the SHA-256 of the DRISL-CBOR-serialized unsigned commit, whose `data` field is a CID link to the Merkle-tree root, so the signature says *this account asserts that this content address is its current state* while the Merkle root says *this is that tree*; but "neither the signature itself nor the signed commit indicate either the type of key used ... That information must be fetched from the account's DID document. With key rotation, verification of older commit signatures can become ambiguous." The design rule that falls out: name content by hash, keep the verification path free of any resolver, and add signed attestation (Verifiable Credentials, Sigstore, in-toto, an atproto commit) as a strictly additive, orthogonal layer that supplies attribution without adding a dependency. A content locator's source set can be arbitrarily large, heterogeneous, and hostile precisely because verification never leaves the bytes.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [atproto--specs-repository--commit-objects-and-signing](../sections/atproto--specs-repository--commit-objects-and-signing.md) | The sharpest primary statement of the asymmetry: the signature covers a CID link, and 'with key rotation, verification of older commit signatures can become ambiguous'. |
| [atproto--specs-repository--self-certifying-repository](../sections/atproto--specs-repository--self-certifying-repository.md) | Self-certifying content plus an authoritative PDS location: what a hash can settle and what only an authority can assert (currency). |
| [ucan-wg--spec-readme--canonicalization-envelope-and-cids](../sections/ucan-wg--spec-readme--canonicalization-envelope-and-cids.md) | A certificate that is itself content-addressed; did:key is required precisely to keep a resolver out of the signature-verification path. |
| [atproto--specs-did--did-document-atproto-fields](../sections/atproto--specs-did--did-document-atproto-fields.md) | Resolving a DID proves the controller published the endpoint, not that the endpoint is honest; 'a valid URL doesn't mean the the PDS itself is currently functional'. |

## See also

- [[atproto-repository-mst]] — the content-addressed structure the signature covers.
- [[did-document-service-endpoint]] — the other half of a DID document, the location hint, which is likewise unverified by the identifier.
- [[content-addressed-block-store]] — the storage-side expression of naming by hash.
- [[ucan-delegation]] — a certificate whose validity is a signature check, deliberately kept resolver-free by requiring `did:key`.
