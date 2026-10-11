---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/namespace-clone-maintenance.sh
Defect: `scripts/jobs/namespace-clone-maintenance.sh:66` treats expected live-clone contention as a per-clone WARN; five such warnings appeared from 20:41:28Z to 20:42:56Z. Capture and classify the soft-lock give-up there, suppressing expected busy-peer diagnostics while preserving and surfacing real maintenance failures. Emit at most one coalesced contention summary per tick.
