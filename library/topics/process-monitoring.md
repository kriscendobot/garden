# process-monitoring

OS-level observation and bounding of a running process and its descendants — the recursively-spawned fork/exec tree beneath a supervisor. The cross-cutting concern is: given a process the supervisor is responsible for, watch (and optionally allow/deny) the security-relevant operations of that process and every child it spawns, without pulling the rest of the system into scope. This is the enforcement/observation half of sandboxing a spawned program, distinct from — and complementary to — in-process object-capability confinement (which denies authority by construction rather than intercepting operations at the OS boundary). This topic collects mechanisms and APIs for it; the first entry is Apple's `es_new_descendants_client`, an EndpointSecurity client whose scope is exactly a process and its descendant tree.

## Sections

| Section | One-line summary |
|---|---|
| [client creation and signature](../sections/web--apple-es-new-descendants-client--client-creation-and-signature.md) | endpoint-security, process-monitoring | The constructor for a monitoring client scoped to a process and its descendant tree. |
| [descendant-monitoring semantics](../sections/web--apple-es-new-descendants-client--descendant-monitoring-semantics.md) | endpoint-security, process-monitoring | The scoping rule: observe the caller, observe-and-gate its recursive descendant tree, ignore everything else. |
| [muting and client requirements](../sections/web--apple-es-new-descendants-client--muting-and-client-requirements.md) | endpoint-security, process-monitoring | Reduced deployment cost (no root, no TCC) is what makes the descendant-scoped monitor practical to run. |
| [Devoker vigil health monitor](../sections/unum--devoker-four-layer-architecture.md) | agent-fleet-orchestration, process-monitoring | The vigil timer polls the worker unit's ActiveState/SubState/Result triple to restart-on-failure, idle-kick pending work, run a stuck-task detector, and size occupancy-aware burst concurrency. |
| [auditing-capability-systems](../sections/cap-talk-2002-2003--auditing-capability-systems.md) | cap-talk 2003-October | Snapshot audits and protected logs can bound damage, but ongoing execution needs mechanisms that preserve the checked invariant. |
| [literate-ai worker storage: receiver-selection-and-request-protocol](../sections/literate-ai--docs-architecture-worker-storage-protocol--receiver-selection-and-request-protocol.md) | agentic-sdlc, process-monitoring | Storage health uses a digest-bound private request to an exact worker's receiver; observations authorize nothing. |
| [literate-ai worker storage: deadlines-and-failures](../sections/literate-ai--docs-architecture-worker-storage-protocol--deadlines-and-failures.md) | agentic-sdlc, process-monitoring | A receiver-side watchdog yields request-bound timeouts, so success is never inferred from a missing response. |
| [literate-ai worker storage: independent-quota-domains](../sections/literate-ai--docs-architecture-worker-storage-protocol--independent-quota-domains.md) | agentic-sdlc, process-monitoring | Byte and inode quotas are checked per opaque domain; an empty quota list never means unlimited. |
| [literate-ai worker storage: public-storage-inspection](../sections/literate-ai--docs-architecture-worker-storage-protocol--public-storage-inspection.md) | agentic-sdlc, process-monitoring | litai worker health inspects once and exits permit, hold, or retry; denied or stale pressure evidence stays unknown. |
| [literate-ai worker storage: explicit-alert-history](../sections/literate-ai--docs-architecture-worker-storage-protocol--explicit-alert-history.md) | agentic-sdlc, process-monitoring | Opt-in owner-only alert state deduplicates transitions without ever changing the job decision. |
| [literate-ai worker storage: admission-polling-and-cleanup](../sections/literate-ai--docs-architecture-worker-storage-protocol--admission-polling-and-cleanup.md) | agentic-sdlc, process-monitoring | Lifecycle commands hold later work on critical findings; cleanup apply needs exact expiring authorization. |

## See also

- endpoint-security — Apple's macOS framework providing the auth/notify event stream this topic's first mechanism rides on.
- daemon — the Endo daemon's OS-sandbox backends (bwrap/seccomp on Linux, SBPL on macOS) confine and observe spawned process subtrees; descendant monitoring is the observation counterpart to those confinement backends.
- capability-security — the deny-by-construction alternative to observe-and-authorize process monitoring; Endo's projects deliberately bet on structural confinement over OS-level supervision.
