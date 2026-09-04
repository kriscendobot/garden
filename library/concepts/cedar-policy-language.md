---
id: cedar-policy-language
aliases: ["Cedar", "Cedar policy language", "Cedar authorization engine", "cedar-policy", "Amazon Verified Permissions", "Verified Permissions", "AVP", "PARC", "principal action resource context", "policy-as-code authorization", "verification-guided development"]
topics: [policy-language-authorization, capability-security]
---

# cedar-policy-language

**Cedar** is AWS's open-source (Apache 2.0) language and engine for fine-grained access control, announced open-sourced in May 2023 and framed in 2026 as "perfectly timed for AI agents." Its model is **policy-as-code over PARC**: every authorization request names a **P**rincipal (the actor), an **A**ction, a **R**esource, and a request-time **C**ontext, and a small embedded engine adjudicates it to *permit* or *forbid* by evaluating an externally-stored set of **policies**. Cedar supports both **RBAC** (role-based — permissions attached to roles the principal holds) and **ABAC** (attribute-based — permissions predicated on attributes of the principal, resource, and context), typically over a declared **schema** of entity types and a graph of **entities** (users, groups, resources and their relationships). The distinguishing engineering claim is **verification-guided development**: the engine is formally modeled, its safety and correctness properties are proved with automated reasoning, and the model is tested to match the **Rust** implementation — so the reference monitor itself is argued correct. Cedar ships two ways: as **Amazon Verified Permissions** (a managed service with a *central, auditable policy store* and millisecond decisions across applications) and as **embeddable open-source libraries** for authoring, validating, and evaluating policies locally or offline.

Cedar is the archetype of the model the garden's corpus contrasts with object capabilities: a **central reference monitor consulting a policy set**, where the actor holds ambient authority (it *is* some principal) and the engine decides per request whether that ambient identity may touch a named resource. The designation (the resource name in the request) and the authority (the policy in the store) travel by separate routes and are reconciled by the engine — exactly the split that produces the [[confused-deputy]] failure mode object capabilities close by construction. See [[policy-vs-capability-authorization]] for the head-to-head, and [[capability-security]] for the alternative discipline.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cedar-aws-announcement--overview](../sections/cedar-aws-announcement--overview.md) | Cedar open-sourced: a policy language + engine that decouples access control from application logic, supporting RBAC and ABAC over principal/action/resource. |
| [cedar-aws-announcement--verification-guided-development](../sections/cedar-aws-announcement--verification-guided-development.md) | The engine is formally modeled, its safety proved by automated reasoning, and the model tested to match the Rust implementation. |
| [cedar-aws-announcement--verified-permissions-and-local-use](../sections/cedar-aws-announcement--verified-permissions-and-local-use.md) | Central, auditable policy storage via Amazon Verified Permissions, plus embeddable libraries for local/offline authorization. |
| [thestack-cedar-for-ai-agents--overview](../sections/thestack-cedar-for-ai-agents--overview.md) | The actor/action/resource (PARC) shape and why a decoupled, formally-verified engine suits AI agents as new actors. |

## See also

- [[policy-vs-capability-authorization]] — Cedar's ACL/policy model versus the object-capability model minion.town and Endo pursue.
- [[capability-security]] — the object-capability discipline that is the structural alternative.
- [[confused-deputy]] — the failure mode the designation-vs-authority split in a policy engine invites and ocap closes.
- [[capability-chain]] — a typed capability-attenuation chain (dialog-db) that occupies the middle ground between policy tokens and pure ocap.
