---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/gatekeeper.ts
source_line_range: "1-1283"
source_commit: 2c9d59098d852370f27882702dd39a159b3c12f5
comment_subject: the Gatekeeper RPC contracts for account authentication, observer verification, approval and revert, persistent hooks, and sensitive observations
source_authors: [Kenton Varda, "Yo'av Moshe", Phillip Jones, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
section_count: 5
status: current
---

`gatekeeper.ts` defines the privileged RPC protocol between the Workshop and independently deployed Gatekeeper Workers. This thematic digest concentrates its many declaration comments into five security and lifecycle contracts: account authority, observer verification, session approval and revert, persistent hook rebinding, and observation confinement. It omits routine display metadata and iframe plumbing. Filed under the `cloudflare-os-gatekeeper` concept, with the generic session and approval rules also grounding the `mcp-server-connector` implementations.

| Section | Topics | Status |
|---------|--------|--------|
| [Account authentication and resource authority](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--account-authentication-and-resource-authority.md) | authentication-gatekeepers, capability-mediated-integrations, capability-security, cloudflare-workers-agent-hosting | current |
| [Observer verification across past and future reads](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--observer-verification-contract.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
| [Approval, simulation, rejection, and revert](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--approval-and-revert-contract.md) | capability-mediated-integrations, capability-security | current |
| [Persistent hook binding and fresh-session delivery](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--persistent-hook-lifecycle.md) | capability-mediated-integrations, capability-security, cloudflare-workers-agent-hosting | current |
| [Sensitive observation confinement](../sections/cloudflare-os--packages-workshop-shared-src-gatekeeper--sensitive-observation-confinement.md) | collaborative-workspace-sharing, capability-mediated-integrations, capability-security | current |
