---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/follow-up.sh
`follow-up.sh:185-196` treats a failed cursor publish as best-effort, but after marking reports locally seen a later no-op tick never retries it; the 12:59:07 warning leaves a leadership-change replay window indefinitely. Persist a pending seen-cursor publication marker and retry publishing it on subsequent ticks until `cursor-set.sh` succeeds, clearing it only after durable publication.
