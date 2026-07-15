---
role: designer
model: gpt-5.6-terra
priority: high
---
Design a compatibility-safe migration in kriskowal/garden main2 that reserves gardener as the generic job-doing agent and renames the Anthropic/Claude worker kind from gardener to monk.

Establish the orthogonal taxonomy explicitly: worker kind monk/provider anthropic/runtime Claude; cleric/openai/Codex; hermit/local/Ollama; every worker is generically a gardener that claims a job and adopts a task role. Inventory every persisted and executable surface affected, including worker-kind registry and defaults, gardener.sh and handler names, systemd templates and instantiated units, scaler/count configuration, claim metadata, journal host records and historical tada/reputation events, routing and auction eligibility, metrics/bulletin/proxy/reaper logic, scripts and environment variables, tests, documentation, and fleet-wide deployment.

The design must provide a staged, reversible migration with backward-compatible reading of historical worker_kind: gardener records, no double-running units, no lost claims or worktrees, leader/follower rollout order, journal schema/version considerations, aliases and their retirement criteria, exact validation/rollback gates, and a fleet-wide acceptance test proving monk claims Anthropic work while cleric and hermit routing remain unchanged. Distinguish terminology-only edits from persisted-state migrations. Surface any naming collision or reason monk is unsuitable rather than forcing the name.

Land the accepted design artifact directly on main2 per garden repository policy; do not implement the migration in this job and do not change the live fleet.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: cleric
  claimed_at: 2026-07-15T03:40:32Z
