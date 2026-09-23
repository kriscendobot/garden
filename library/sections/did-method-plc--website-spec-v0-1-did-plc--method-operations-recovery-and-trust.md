---
title: did:plc method, operations, recovery, and directory trust
source: website/spec/v0.1/did-plc.md
source_repo: did-method-plc/did-method-plc
source_commit: c11a01823b60d50b9658ecebd80cdbc524694208
source_date: 2026-01-06
source_authors: [David Buchanan]
ingested: 2026-07-29
ingested_by: scholar
topics: [identity, decentralized-identifiers, capability-security]
status: current
---

> Abstract: `did:plc` is a self-certifying, strongly consistent DID whose identifier derives from the signed genesis operation; a priority-ordered rotation-key set supplies controlled recovery, while the PLC directory is trusted only for availability and fork ordering, not for inventing valid history.

Every operation carries the complete active state and (after genesis) the previous operation CID. The signed genesis operation is DAG-CBOR encoded, SHA-256 hashed, base32 encoded, and truncated to 24 characters: `did:plc:${base32Encode(sha256(createOp)).slice(0,24)}`. This binds the identifier to its initial operation rather than to a directory allocation.

`rotationKeys` is a non-duplicated, priority-ordered list of one to five `did:key` public keys, separate from DID-document `verificationMethods`. Lower array index means higher authority. Within 72 hours, a higher-authority key may submit an operation at the last valid fork point and invalidate an operation or chain signed by a lower-authority key. Tombstoning follows the same recovery window.

The directory checks signatures and recovery rules, persists the public operation log, and renders current state. Its trust is bounded: it can deny service or choose which fork to serve, but cannot manufacture a valid signed operation. Clients can validate the full audit log, including signatures, predecessor links, and recovery ordering. `alsoKnownAs` and service claims are not cross-validated by the directory, so a handle or service endpoint needs independent bidirectional verification.

Source: [website/spec/v0.1/did-plc.md](https://github.com/did-method-plc/did-method-plc/blob/c11a01823b60d50b9658ecebd80cdbc524694208/website/spec/v0.1/did-plc.md) at commit `c11a0182`.
