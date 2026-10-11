---
id: bound-worker-health-observation
aliases: [worker storage observation, request-bound health probe, worker resource health evidence, observation is not authorization]
topics: [agentic-sdlc, process-monitoring]
---

# bound-worker-health-observation

A worker-resource measurement that is evidence only: each observation is bound to exact worker, capacity-policy, job, and request-digest identities, carries explicit per-metric statuses (including `timed-out`, `unsupported`, and `unknown`) so absence never reads as health, and expires as admission evidence. It can hold new work, but it never authorizes execution, allocation, or deletion; cleanup needs a separate exact, expiring authorization.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Receiver selection and request protocol](../sections/literate-ai--docs-architecture-worker-storage-protocol--receiver-selection-and-request-protocol.md) | Binds the request to exact worker, policy, job, and nonce identities and validates a digest-bound response. |
| [Deadlines and failures](../sections/literate-ai--docs-architecture-worker-storage-protocol--deadlines-and-failures.md) | Makes timeout explicit in a request-bound response so success is never inferred from silence. |
| [Independent quota domains](../sections/literate-ai--docs-architecture-worker-storage-protocol--independent-quota-domains.md) | Keeps failed or unsupported quota measurement explicit rather than collapsing to unlimited capacity. |
| [Public storage inspection](../sections/literate-ai--docs-architecture-worker-storage-protocol--public-storage-inspection.md) | Exposes permit, hold, and retry outcomes, and binds a result to a job without authorizing it. |
| [Explicit alert history](../sections/literate-ai--docs-architecture-worker-storage-protocol--explicit-alert-history.md) | Unknown measurements cannot erase an incident, and alert suppression never alters the decision. |
| [Workflow admission, polling, and cleanup](../sections/literate-ai--docs-architecture-worker-storage-protocol--admission-polling-and-cleanup.md) | Separates admission holds and read-only cleanup proposals from the authorization needed to delete. |

## See also

- [[specification-authority-chain]] — the larger Literate AI rule that evidence and authority are distinct artifacts.
