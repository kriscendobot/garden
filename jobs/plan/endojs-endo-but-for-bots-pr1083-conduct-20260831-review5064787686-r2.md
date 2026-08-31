---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1083-resolve-conduct-build-5064787686-r2
priority: high
role: conductor
posted_by: gardener
posted_at: 2026-08-31T09:20:33Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finalize approved PR 1083 after conflict resolution

Repository: endojs/endo-but-for-bots; PR: https://github.com/endojs/endo-but-for-bots/pull/1083.

After the preceding weaver publishes a live-llm-based head, wear the conductor role and carry finalization to completion. Re-check that the PR is open, mergeable, current-head CI is green, and the maintainer approval from review 5064787686 remains effective. Un-draft if needed and merge using the conductor-owned method. Do not name or change that method in this job specification. If CI is pending, keep the job active through terminal status as required by the conductor role.

Bot repository only. Never merge agoric/agoric-sdk or endojs/endo upstream. If the gated outcome cannot be achieved, emit the orchestration failure signal required by the parked-child contract.
