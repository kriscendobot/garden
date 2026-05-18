---
slot: 1
status: in-flight
design_path: designs/cli-http-client.md
pr_number: 286
current_stage: weaver
in_flight_dispatch: 22744b
last_update: 2026-05-18T09:21:00Z
started_at: 2026-05-18T08:00:00Z
host: endolinbot
---

Shepherd diagnosed CI gap: PR #286 is `mergeable: CONFLICTING` /
`mergeStateStatus: DIRTY` against llm. GitHub doesn't create the
synthetic merge ref for conflicting PRs, so `pull_request` workflows
never dispatch — that's why 0 CI runs. The conflict is on
`designs/README.md` (an llm-side update after the builder branched);
daemon source files auto-merge cleanly. Same shape as PR #284's
weaver stage. Dispatching weaver to rebase onto current llm.

Dispatch root: `dispatches/weaver--22744b`.
