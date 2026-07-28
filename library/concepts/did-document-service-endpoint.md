---
id: did-document-service-endpoint
aliases: [service endpoint, serviceEndpoint, DID service, DID document service, atproto_pds, AtprotoPersonalDataServer, PDS endpoint, alsoKnownAs, connection hint analog for DIDs, location hint, configuration-dependent hint]
topics: [decentralized-identifiers, identity, networking]
---

# did-document-service-endpoint

The DID-shaped analogue of a locator's connection hints. A DID document's `service` property is OPTIONAL and, when present, "MUST be a set of Service Endpoint maps"; W3C DID Core describes services as "means of communicating or interacting with the DID subject or associated entities via one or more service endpoints", and a `serviceEndpoint` value may itself be a string, a map, or a set of both. The spec never asserts that a listed endpoint is honest, reachable, or serving anything in particular: resolving a DID proves the controller published the endpoint, not that the endpoint is truthful. So it is a hint in the same sense as a magnet `tr=` tracker, useful and untrusted, verified by something else or not at all. The deployed worked example is ATProto's `#atproto_pds` entry (`type: AtprotoPersonalDataServer`, `serviceEndpoint` an HTTPS origin with no path), which moves when an account migrates hosts while the DID and the repository's CIDs stay fixed, and which the spec explicitly cautions is not a liveness claim: "a valid URL doesn't mean the the PDS itself is currently functional". One important asymmetry against a magnet source: ATProto's endpoint is **authoritative**, not advisory, because a mutable repository needs somebody to say what the current revision is, and currency cannot be verified from content. The adjacent property `alsoKnownAs` is weaker than it looks: it is a set of URIs and "the presence of an `alsoKnownAs` assertion does not prove that this assertion is true", which is why ATProto mandates bidirectional handle validation rather than trusting the claim.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [atproto--specs-did--did-document-atproto-fields](../sections/atproto--specs-did--did-document-atproto-fields.md) | The #atproto_pds service entry: type AtprotoPersonalDataServer, an HTTPS origin with no path, and the explicit caution that a valid URL is not a liveness claim. |
| [atproto--specs-did--blessed-did-methods](../sections/atproto--specs-did--blessed-did-methods.md) | Which DID methods carry a resolvable document at all, and why did:web's DNS grounding collapses the hint and the identity onto one authority. |
| [atproto--specs-repository--self-certifying-repository](../sections/atproto--specs-repository--self-certifying-repository.md) | 'The authoritative location of an account's repository is the associated Personal Data Server. An account's current PDS location is declared in the DID Document.' |

## See also

- [[content-address-versus-signature]] — the verification half of a DID document, and why it composes beside a hash rather than replacing one.
- [[atproto-repository-mst]] — what the PDS endpoint points at.
- [[tripartite-identity]] — the identity-decomposition pattern a DID plus handle plus PDS entry instantiates.
- [[noise-ik-session-establishment]] — the key-grounded alternative, where the designator authenticates the peer rather than the controller asserting a location.
