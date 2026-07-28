---
title: Inversion of control, and the security properties UCAN does and does not provide
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: The architectural claim ("There is no Authorization Server (AS) that sits between requestors and resources") and the candid limits that follow it: a structurally valid chain can be semantically invalid, certificate chains "do not provide confinement on their own", sub-delegation happens without alerting the delegator, and revocation "exists as a last resort". Read this before treating a UCAN as equivalent to an object-capability reference.

## Inversion of control

> "Inversion of control is achieved due to two properties: self-certifying delegation and reference passing. There is no Authorization Server (AS) that sits between requestors and resources. In traditional terms, the owner of a UCAN resource is the resource server (RS) directly."

> "This inverts the usual relationship between resources and users: the resource grants some (or all) authority over itself to agents, as opposed to an Authorization Server managing the relationship between them."

Claimed advantages: fully distributed and scalable; self-contained request without intermediary; partition tolerance with support for replicated data and machines; flexible granularity; and "compositionality: no distinction between resources residing together or apart".

## Security considerations, in the spec's own words

> "Each UCAN includes an assertions of what it is allowed to do. 'Proofs' are positive evidence (elsewhere called 'witnesses') of the possession of rights. They are cryptographically verifiable chains showing that the UCAN issuer either claims to directly own a resource, or that it was delegated to them by some claimed owner. In the most common case, the root owner's ID is the only globally unique identity for the resource."

> "Root capability issuers function as verifiable, distributed roots of trust. The delegation chain is by definition a provenance log. Private keys themselves SHOULD NOT move from one context to another. Keeping keys unique to each physical device and unique per use case is RECOMMENDED ... 'Sharing authority without sharing keys' is provided by capabilities, so there is no reason to share keys directly."

Three limits stated plainly:

> "Note that a structurally and cryptographically valid UCAN chain can be semantically invalid. The executor MUST verify the ownership of any external resources at execution time. While not possible for all use cases (e.g. replicated state machines and eventually consistent data), having the Executor be the resource itself is RECOMMENDED."

> "While certificate chains go a long way toward improving security, they do not provide confinement on their own. The principle of least authority SHOULD be used when delegating a UCAN: minimizing the amount of time that a UCAN is valid for and reducing authority to the bare minimum required for the delegate to complete their task."

> "This delegate should be trusted as little as is practical since they can further sub-delegate their authority to others without alerting their delegator. UCANs do not offer confinement (as that would require all processes to be online), so it is impossible to guarantee knowledge of all of the sub-delegations that exist. The ability to revoke some or all downstream UCANs exists as a last resort."

The practical reading for a system that already has object-capability references: a UCAN gives you offline verifiability and third-party delegability, and pays for them with no confinement, unobservable sub-delegation, and best-effort revocation. Where a live reference is available, it dominates on exactly those three axes.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
