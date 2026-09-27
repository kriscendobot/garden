---
tier: mentat
dispatch: manual
---
role: scholar
handler-timeout: 10800

# Refresh the garden's documentation to match current workflows and cybernetics

Maintainer request (kriskowal, 2026-09-27): *update the garden's documentation to reflect the current workflows and
cybernetics. They have evolved somewhat.* Repo: the garden itself (`kriscendobot/garden`, `main2`). Documentation
changes land directly on `main2` per CLAUDE.md § Conventions. Use the open-questions review-PR carve-out only for a
genuine maintainer decision you uncover.

## Method: derive from the code and history, not from memory
Survey `git log origin/main2` for roughly the last three weeks (the churn has been heavy since ~2026-09-15), the
`designs/` that landed in that window, and `journal/jobs/tada/` reports. For each documented surface, check the
claim against current code and fix drift. Prefer short, accurate prose and links over restating a design. Keep
CLAUDE.md an orientation map; push detail into `context/`, role, and skill docs.

## Surfaces to reconcile (at minimum)
- `CLAUDE.md`, `README.md` (including § Key vocabulary), `roles/liaison/AGENT.md`, `roles/gardener/AGENT.md`, `roles/COMMON.md`.
- `context/operations/*` (especially `starting.md`, `deploy.md`, `leader-follower.md`, `scaling.md`, `health.md`,
  `harden-container.md`), and `context/first-run/*`.
- The skills touched by recent changes (job-board, orchestration, panel, pre-push-gates, local-verify, model-selection).
- `designs/cybernetics-audit.md` and `designs/cybernetics-economic-resilience.md`: bring their "current state"
  sections in line, or add a short status note rather than rewriting history.

## Known evolutions to cover (verify each in code before documenting)
- **Worker lifecycle:** headless-session completion (`continue` prompt, in-process completion nudge, first-session
  productivity baseline), the `mentat` tier and `post-manual-job.sh`, and monk/gardener/cleric slotting.
- **Rolling deploy:** canary pinning to a fixed target, follower deferral publishing and "quiesce for deploy", advisory
  probe units excluded from canary health, "peer offline" clearing and catch-up releases, the candidate test gate, and
  the attested sysop `deploy` op as the manual escape hatch.
- **Cybernetics and budget:** the fleet monk ceiling and its cap-times-slack apportionment near weekly reset, the
  budget leveler's dwell/confirm behavior, quota checkpoints aggregated across hosts for shared subscriptions (with
  supersession), and the decision ledger's record-on-change discipline (the triager-pacing churn fixes).
- **Watches:** comment-latency (reactji-anchored), journal-contention (latency/retry anomaly detection, clone auto-remedy),
  the fleet-wide storm guard, and coalesced watchdog notices with `--recovered`.
- **Security:** the container-hardening launcher (no `--privileged`, no passwordless sudo), its probe, and the
  pending-recreate state.
- **Review machinery:** the re-export deprecation policy (pre-push probe plus `reexport-auditor` seat), and the
  orchestrator's final-disposition re-derivation.
- **Muster:** the optional TypeSafe Jev pilot (`muster-pilot.sh`), advisory only.
- **Known gaps worth stating plainly:** e.g. the budget leveler still counts drained/offline hosts in its apportionment
  (observed 2026-09-26, when oros-studio held 3–4 idle monk slots); `maintainer-archive.sh` needs the `.md` suffix.

## Deliver
Commits on `main2`, grouped by area. A report listing each surface changed, each drift found and fixed, and anything
you found documented but no longer true in code, with a recommendation for each. Complete via the normal completion
path.
