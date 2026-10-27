---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design: the budget road. Source design (maintainer-supplied, authored on the tower): https://tower.kriskowal.com/f7koc4preplunizm7bx55vtxf4/

Read that page in full (fetch it directly; do not rely on a summary) and land it as a garden design under `designs/`, adapted to this repo's actual budget machinery (accountant, foreman, budget-pools, token-backoff, `claim-job.sh`, the weekly arc apportionment/slate).

Gist, for orientation only: replace the weekly approved slate of concurrent budget shares with a standing ordered list of arcs ("the road", `allocation/road.json`, single writer `set-road.sh`) plus three fixed lanes (primary 0.5, secondary 0.3, library 0.2) over the half of weekly quota not reserved for the maintainer; unreserved budget is discretion spent in road order; one shared function computes verdict/admission/statements/status; the foreman notifies the maintainer only on full exhaustion; the accountant report becomes a statement, not an approval request; migration via `set-road.sh init` pinning the old slate's top arcs.

Deliverable: the design doc, with a migration plan and a list of the existing scripts/roles/skills it touches. If the design carries non-empty unresolved maintainer-facing open questions, use the review-PR carve-out (CLAUDE.md § Conventions); otherwise land bare on main2. Design only: do not implement.
