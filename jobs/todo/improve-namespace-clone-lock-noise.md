---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/namespace-clone-maintenance.sh
`namespace-clone-maintenance.sh:123-148` is intended to suppress per-clone soft-lock warnings, but the 2026-10-14T16:38:23Z–16:39:20Z warning tail still emitted three of them. Harden its capture/filter path and add a non-TTY journald-priority regression fixture so busy clones produce only the coalesced contention summary.
