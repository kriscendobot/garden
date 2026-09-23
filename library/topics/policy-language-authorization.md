Policy-language, policy-as-code authorization: a central engine adjudicates each principal / action / resource / context request against an externally-stored policy set (RBAC + ABAC), decoupled from application logic. Cedar (AWS's open-source, formally-verified Rust engine) is the worked example. This is the ambient-authority, reference-monitor complement to the object-capability model in [[capability-security]] and [[capability-theory]] — the two are contrasted head-on in [[policy-vs-capability-authorization]].

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Cedar open-sourced: a policy language and authorization engine](../sections/cedar-aws-announcement--overview.md) | policy-language-authorization, capability-security | Cedar externalizes fine-grained access control from application logic into policies a small engine evaluates over principal/action/resource, supporting RBAC and ABAC. |
| [Verification-guided development: a formally modeled engine](../sections/cedar-aws-announcement--verification-guided-development.md) | policy-language-authorization | Cedar's engine is formally modeled, its safety properties proved by automated reasoning, and the model tested to match the Rust implementation. |
| [Amazon Verified Permissions, central policy storage, and offline use](../sections/cedar-aws-announcement--verified-permissions-and-local-use.md) | policy-language-authorization | Cedar ships as a managed service with a central, auditable policy store and as embeddable libraries for local/offline authorization. |
| [Cedar as an access-control building block for AI agents](../sections/thestack-cedar-for-ai-agents--overview.md) | policy-language-authorization, capability-security | The Stack's thesis that a decoupled, formally-verified, pluggable authorization engine suits AI agents as new actors making access decisions at machine speed. |

## See also

- [[capability-security]] — the object-capability discipline (unforgeable references, least authority) that is the structural alternative to a policy engine.
- [[capability-theory]] — the deeper ocap theory (confused deputy, designation-carries-authority) the contrast rests on.
- [[capability-mediated-integrations]] — the garden's applied ocap answer to the same external-service-authorization problems Cedar's integrations address.
- [[ucan-authorization]] — a token/capability hybrid that sits between a pure policy engine and pure ocap.
- [[oauth-credentials]] — the scope-string credential model minion.town is moving *off*, toward ocap.
