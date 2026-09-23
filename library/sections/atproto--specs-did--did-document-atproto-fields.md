---
title: The three atproto fields extracted from a resolved DID document
source_kind: web
source_url: https://atproto.com/specs/did
source_content_sha256: 624594bb04584d272731005ef390469357db8c9937211516ad94c5984fc3fedf
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [decentralized-identifiers, identity, networking]
status: current
---

> Abstract: The DID-method-agnostic parsing contract for an atproto DID document: the claimed handle in `alsoKnownAs` (bidirectionally validated), the `#atproto` signing key in `verificationMethod` (type `Multikey`), and the `#atproto_pds` entry in `service` (type `AtprotoPersonalDataServer`) whose `serviceEndpoint` is the account's PDS location. This is the worked example of the DID `service` set as a configuration-dependent location hint: the endpoint moves during account migration while the DID stays fixed, and the spec explicitly warns that a valid URL does not imply a functional server.

After a DID document has been resolved, atproto-specific information needs to be extracted. This parsing process is agnostic to the DID method used to resolve the document. The DID declared in the document (in the `id` field) should always be verified against what was expected.

## The handle, in `alsoKnownAs`

> "The handle claimed by the DID is found in the `alsoKnownAs` array. Each element of this array is a URI string. Handles will have the URI prefix `at://`, followed by the handle hostname, with no other URI parts or trailing characters. The first syntaxtually valid handle found in the ordered list is treated as the claimed handle, even if it fails to resolve bi-directionally. Any other handle URIs should be ignored."

> "It is crucial to validate the handle bidirectionally, by resolving the handle to a DID and checking that it matches the current DID document."

The DID, not the handle, is the primary account identifier. "An account whose DID document does not contain a valid and confirmed handle can still participate in the atproto ecosystem. Software should be careful to either not display any handle for such account, or obviously indicate that any handle associated with it is invalid."

This is the operational answer to DID Core's own caution that "the presence of an `alsoKnownAs` assertion does not prove that this assertion is true": a one-way claim becomes usable only when a second, independent lookup closes the loop.

## The signing key, in `verificationMethod`

> "The public atproto signing key for the account is found under the `verificationMethod` array, in an object with `id` ending `#atproto`, the `controller` matching the DID itself, and `type` matching the fixed string `Multikey`. The first valid atproto signing key in the array should be used, and any others ignored. The `publicKeyMultibase` field will be the public key in multibase encoding."

> "A valid signing key is required for most atproto functionality. An account with no valid key in their DID document is likely broken."

## The PDS location, in `service`

> "The PDS service network location for the account is found under the `service` array, with `id` ending `#atproto_pds`, and `type` matching `AtprotoPersonalDataServer`. The first matching entry in the array should be used, and any others ignored. The `serviceEndpoint` field must contain an HTTPS URL of server. It should contain only the URI scheme (`http` or `https`), hostname, and optional port number, not any 'userinfo', path prefix, or other components."

> "A working PDS is required for most atproto account functionality."

And the caution that makes it a hint rather than a guarantee:

> "Note that a valid URL doesn't mean the the PDS itself is currently functional or hosting content for the account. During account migrations or server downtime there may be windows when the PDS is not accessible, but this does not mean the account should immediately be considered broken or invalid."

Neither the key nor the PDS entry is stated as an RFC-2119 MUST on the document. They are required for the system to work, and the spec says so in those words.

## Extensibility and `id` forms

> "Other protocol and application features may make use of `verificationMethod` keys and `service` entries. For example, labeling uses an additional key type, and application-specific 'AppView' instances use bespoke service entries."

> "When parsing the `id` field in object elements of the `service` and `verificationMethod` arrays, implementations should support both relative fragment syntax (eg, `'id': '#atproto_pds'`) and fully-qualified syntax (eg, `'id': 'did:web:example.com#atproto_pds'`)."

Source: [https://atproto.com/specs/did](https://atproto.com/specs/did), content SHA-256 `624594bb`.
