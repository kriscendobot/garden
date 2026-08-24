---
id: observer-verification
aliases: [observer verification, observer record, Gatekeeper verifier, excludeObservers]
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
---

# Observer verification

Cloudflare OS's information-flow check for shared gadgets: each non-owner proves through their own Gatekeeper accounts that they can independently read all external data the gadget observed, and later incompatible observations are blocked while that person remains authorized.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [security invariant and observer model](../sections/cloudflare-os--docs-observers--security-invariant-and-observer-model.md) | Defines historical verification and forward exclusion for gadget collaborators. |
| [observer records and verifiers](../sections/cloudflare-os--docs-observers--observer-records-and-verifiers.md) | Separates authorization intent, configured accounts, opaque handles, and vendor identity. |
| [configuration and re-verification on open](../sections/cloudflare-os--docs-observers--configuration-and-reverification-on-open.md) | Selects accounts and repeats Gatekeeper checks on every open. |
| [forward exclusion and sharing-change teardown](../sections/cloudflare-os--docs-observers--forward-exclusion-and-sharing-change-teardown.md) | Blocks incompatible observations while excluded users remain authorized. |
| [Gatekeeper observer strategies](../sections/cloudflare-os--docs-observers--gatekeeper-observer-strategies.md) | Chooses private, atomic, data-set-tracking, or low-stakes enforcement per resource. |
| [Collaborator observer verification](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--collaborator-observer-verification.md) | Requires each collaborator's own Cloudflare account to prove resource access. |

## See also

- [[permission-edge-graph]]
- [[lazy-graph-revocation]]
- [[cloudflare-os-gatekeeper]]
