---
role: weaver
tier: mentor
arc: minion-town-mcp-ocapn
posted_at: 2026-11-02T07:11:33Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-07T03:00:28Z cleared=none -->

---
arc: minion-town-mcp-ocapn
role: weaver
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
Weave https://github.com/endojs/endo-but-for-bots/pull/1481 onto the current head of its parent https://github.com/endojs/endo-but-for-bots/pull/1478 (branch build/ocapn-noise-session-queue). Snapshot that head to a new frozen build/ocapn-noise-session-queue-<short-sha>, rebase build/ocapn-noise-session-reconnect-rekey onto it, resolve conflicts, force-push with lease, and move the PR base. Keep the old frozen snapshots: other PRs may still be stacked on them.

Why: #1481's base (build/ocapn-noise-session-queue-2a16357) predates llm commit 27705a4cdf (test(sandbox): fix Linux resource limit and cleanup assertions). Everything stacked on it fails the bwrap tests on ubuntu-26.04; the same weave cleared them on #1478.

Expect real conflicts. #1478 was squashed to a feat commit plus a changeset when it was woven onto #1476, because #1476 reshaped the heartbeat code in network.js (see the tada report weave-endojs-endo-but-for-bots-pr1478-onto-pr1476-20261102). A hand port with a folded-commit list in the message, as that weave did, is acceptable when a per-commit rebase is unworkable. Keep both sides' behavior.

#1478's peer shepherd (shepherd-endojs-endo-but-for-bots-pr1478-ci-after-weave-20261102) may still be running. Re-read #1478's head when you start. If that job is still in doin and CI on the head is in progress, wait in the foreground (bounded) so you pin a settled head. Do not comment on the PR. Report the new #1481 head and CI state. Red that matches the known base signatures (ironhorse oracle stage3-math 054/055, #1591's bwrap timeout flake) does not fail this job; name it in the report.

