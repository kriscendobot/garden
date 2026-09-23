---
title: Account authentication and resource authority
source: packages/workshop-shared/src/gatekeeper.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/gatekeeper.ts
source_line_range: "1-230, 428-672"
source_commit: 2c9d59098d852370f27882702dd39a159b3c12f5
comment_subject: independently deployed Gatekeepers split vendor discovery, account authority, identity-only authentication, and resource-scoped grants
source_authors: [Kenton Varda, "Yo'av Moshe", Phillip Jones, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, capability-mediated-integrations, capability-security, cloudflare-workers-agent-hosting]
status: current
---

The Workshop reaches each external service through an independently deployed Gatekeeper Worker and receives fine-grained capabilities to resources rather than ambient access to an account. The protocol separates public vendor discovery, a privileged user-account capability, and per-resource Durable Object classes. Its connect flow distinguishes transient verified-email authentication from persisted full-resource authority, treats an empty resource-pattern list as an intentional request for no data access, and requires nonce-protected connect and reconnect URLs.

## Capability layers

`GatekeeperVendor` is the public service-binding root. It describes the vendor, reports supported resource URL patterns, supplies TypeScript declarations for progressive agent discovery, and begins account connection. The returned `GatekeeperUser` is already specialized to one human and therefore represents all authority available through that account. Only the Workshop UI may hold it. From that account the Workshop can mint per-resource Gatekeeper classes whose `ctx.props` carry the credentials and resource identity.

This layering keeps selection separate from grant. The Overseer may obtain a resource class and call `describe()` before the user grants a gadget access. Actual authority enters the gadget only through the instantiated Gatekeeper session.

## Authentication and incremental grants

`connectAccount()` accepts two independent dimensions:

- `scopes: "auth"` requests only enough authority to obtain a provider-verified email. The grant is transient and discarded after the callback exposes the identity.
- `scopes: "full"` creates a persisted connected account.
- `resourceUrlPatterns` narrows full authorization to selected independently grantable resource types. Omission means all types; `[]` means none. Treating the empty list as omission would silently over-request access.

The browser URL returned from connect or reconnect must contain a cryptographic nonce in addition to any Durable Object identifier. A short-lived connection object can hold the callback and delete itself on timeout. The completion callback records credential refreshability expiry separately from short-lived access-token caching, while explicit expired and restored notifications keep the Workshop's account state current.

For sign-in, `getAuthenticatedEmail()` must return only a provider-verified address because the Workshop keys accounts by email. Incremental `ensureResources()` can later expand selected resource grants without conflating identity proof with data authority. Revoking the account breaks the account capability and all Gatekeepers derived from it; reconnecting preserves those capability identities while replacing credentials.

Source: [packages/workshop-shared/src/gatekeeper.ts](https://github.com/cloudflare/cloudflare-os/blob/2c9d59098d852370f27882702dd39a159b3c12f5/packages/workshop-shared/src/gatekeeper.ts) at commit `2c9d59098d` (lines 1-230 and 428-672).
