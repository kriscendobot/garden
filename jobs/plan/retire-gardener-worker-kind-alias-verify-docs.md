---
gate: orchestrated
orchestrated_by: retire-gardener-worker-kind-alias-split-resume
priority: normal
posted_by: producer
posted_at: 2026-09-29T20:16:33Z
---

---
tier: mentor
fallback-tier: minion
token-budget: 80000
dispatch: automatic
---
Child 2/2 of orchestration `retire-gardener-worker-kind-alias-split` (split of
`retire-gardener-worker-kind-alias`). Runs after child 1
(`retire-gardener-worker-kind-alias-env-fallback`) has removed the
`GARDEN_GARDENER_CLONE` env alias.

Code retirement landed in `02513cd130f`; this child closes out verification + docs.

1. Gate re-verification on the follower `endolin-garden2-5bcdff64` (the original
   directive required it be checked directly): confirm no `garden-gardener@N` unit is
   enabled/present and no `state/gardeners/` markers remain there. Use the sysop
   (`scripts/jobs/send-host-op.sh`) or the host disposition/inventory reports; the
   deployed `install-units.sh` RETIRED_UNITS entry prunes `garden-gardener@.service`
   on reconcile, so confirm that host has deployed a checkout containing
   `02513cd130f`. If a stray unit survives and removing it needs a
   maintainer-attested `unit` op, message the maintainer rather than forging
   attestation. `journal/hosts/*` already carry no `gardeners:` line — just confirm.
2. Docs: update `designs/anthropic-worker-kind-monk.md` (Status row + "Implementation
   status" section: stage 2/3 retirement complete, cite `02513cd130f` and child 1's
   commit, record the historical-read decision for v1 `worker_kind: gardener`
   records and what happened to `reputation/arms/gardener/…` — read common.sh /
   reputation-reduce.sh to state it accurately). Sweep `CLAUDE.md`,
   `context/operations/starting.md`, `context/operations/scaling.md`,
   `context/first-run/auth.md`, and `grep -rn "gardeners:\|set-gardeners\|garden-gardener@\|migrate-host-to-monk" context roles skills README.md CLAUDE.md`
   for stale mentions of the legacy alias; fix them.

Land directly on `main2`. Orchestrated failure contract: if you finish but the gate
check fails (legacy units/markers live on a host), end your report with
`<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.
