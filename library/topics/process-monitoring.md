# process-monitoring

OS-level observation and bounding of a running process and its descendants — the recursively-spawned fork/exec tree beneath a supervisor. The cross-cutting concern is: given a process the supervisor is responsible for, watch (and optionally allow/deny) the security-relevant operations of that process and every child it spawns, without pulling the rest of the system into scope. This is the enforcement/observation half of sandboxing a spawned program, distinct from — and complementary to — in-process object-capability confinement (which denies authority by construction rather than intercepting operations at the OS boundary). This topic collects mechanisms and APIs for it; the first entry is Apple's `es_new_descendants_client`, an EndpointSecurity client whose scope is exactly a process and its descendant tree.

## Sections

| Section | One-line summary |
|---|---|
| [client creation and signature](../sections/web--apple-es-new-descendants-client--client-creation-and-signature.md) | endpoint-security, process-monitoring | The constructor for a monitoring client scoped to a process and its descendant tree. |
| [descendant-monitoring semantics](../sections/web--apple-es-new-descendants-client--descendant-monitoring-semantics.md) | endpoint-security, process-monitoring | The scoping rule: observe the caller, observe-and-gate its recursive descendant tree, ignore everything else. |
| [muting and client requirements](../sections/web--apple-es-new-descendants-client--muting-and-client-requirements.md) | endpoint-security, process-monitoring | Reduced deployment cost (no root, no TCC) is what makes the descendant-scoped monitor practical to run. |
| [Devoker vigil health monitor](../sections/unum--devoker-four-layer-architecture.md) | agent-fleet-orchestration, process-monitoring | The vigil timer polls the worker unit's ActiveState/SubState/Result triple to restart-on-failure, idle-kick pending work, run a stuck-task detector, and size occupancy-aware burst concurrency. |

## See also

- endpoint-security — Apple's macOS framework providing the auth/notify event stream this topic's first mechanism rides on.
- daemon — the Endo daemon's OS-sandbox backends (bwrap/seccomp on Linux, SBPL on macOS) confine and observe spawned process subtrees; descendant monitoring is the observation counterpart to those confinement backends.
- capability-security — the deny-by-construction alternative to observe-and-authorize process monitoring; Endo's projects deliberately bet on structural confinement over OS-level supervision.
