# Topic: decentralized-identifiers

> Abstract: The W3C DID family and the DID methods that matter in practice, viewed as one row in a broader addressing taxonomy: an identifier grounded in the **authority to update** a document, resolved indirectly, whose document carries mutable key material and a set of `service` / `serviceEndpoint` **location hints**. The topic collects the method split that decides whether that framing is even true (self-certifying or verifiable-history methods such as `did:plc`, `did:webvh`, and the degenerate `did:key`, versus the DNS-and-TLS-grounded `did:web`, which collapses back into the URL row), the parsing contract a consumer applies to a resolved document, and the deployed worked example, ATProto, whose `#atproto_pds` service entry is a configuration-dependent location hint that moves on account migration while the DID does not. Distinct from `identity` (how identity decomposes into separable identifiers, the tripartite pattern) and from `ucan-authorization` (DIDs as *principals* in a delegation chain rather than as *subjects* with resolvable documents); this topic is about the identifier and its document.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [atproto--specs-did--blessed-did-methods](../sections/atproto--specs-did--blessed-did-methods.md) | atproto specs/did | Only did:plc and did:web are blessed, deliberately a minimal set; did:web 'does not provide a mechanism for migration or recovering from loss of control of the domain name'. |
| [atproto--specs-did--did-document-atproto-fields](../sections/atproto--specs-did--did-document-atproto-fields.md) | atproto specs/did | The three fields a resolver extracts: the alsoKnownAs handle (bidirectionally validated), the #atproto Multikey signing key, and the #atproto_pds serviceEndpoint naming the account's PDS. |
| [atproto--specs-did--did-identifier-syntax](../sections/atproto--specs-did--did-identifier-syntax.md) | atproto specs/did | The generic DID syntax atproto validates (ASCII subset, lowercase method segment, no query or fragment, hard 2048-character limit) independent of which method is blessed. |
| [atproto--specs-did--public-key-representation](../sections/atproto--specs-did--public-key-representation.md) | atproto specs/did | A verificationMethod of type Multikey whose publicKeyMultibase is 'the same encoding scheme as used with did:key, but without the did:key: prefix'. |
| [atproto--specs-repository--self-certifying-repository](../sections/atproto--specs-repository--self-certifying-repository.md) | atproto specs/repository | A content-addressed Merkle tree of DRISL-CBOR objects, self-certifying, with the PDS as 'the authoritative location of an account's repository' declared in the DID document. |
| [atproto--specs-repository--commit-objects-and-signing](../sections/atproto--specs-repository--commit-objects-and-signing.md) | atproto specs/repository | The six commit fields and the signing procedure; the signature covers a CID link, and 'with key rotation, verification of older commit signatures can become ambiguous'. |

## See also

- `identity` — the identity-decomposition lens; a DID is one candidate account identifier within that pattern.
- `ucan-authorization` — where DIDs appear as principals (`iss` / `aud` / `sub`), narrowed to `did:key` so that no resolution step enters the verification path.
- `content-addressed-storage` — the complementary row: a hash names bytes and needs no resolver, where a DID names a subject and needs one.
- `capability-security` — the ocap discipline against which certificate-shaped authority (DID plus signature) is best contrasted.
- `networking` — service endpoints as connection hints alongside OCapN locators and other hint-bearing addresses.
