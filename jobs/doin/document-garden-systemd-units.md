---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

Repo: kriscendobot/garden, branch main2 (garden's own repo; land directly on main2, no PR).

Task: write complete documentation of every systemd unit the garden ships, reachable from the garden's README.md. Requested by the maintainer (liaison session, endolin-garden2, 2026-09-28).

Scope:
- Cover every unit and template under scripts/systemd/ (~100 files: .service, .timer, and @-templates), plus any unit that scripts/jobs/install-units.sh renders or enables from elsewhere. Missing a unit counts as a defect.
- For each unit, document:
  - Purpose (one or two sentences).
  - What it runs (script path).
  - Trigger or cadence: timer OnCalendar/OnUnitActiveSec, oneshot or long-running, instance naming for templates.
  - Where it runs: every host, or leader-only via the is-main-host exec-condition. Also say whether it still ticks under the fleet drain or the foreman brake.
  - Which worker kinds and instances it spawns, if any.
  - Key env knobs and defaults.
  - State it writes (the $GARDEN_STATE paths, and the journal paths it touches).
  - How to inspect it (journalctl/systemctl commands).
  - How to stop it durably. Note that `disable` is not durable because the reconciler re-arms within ~90s; `mask` is.
  - Related design or context docs.
- Group the units sensibly: worker pools, leader-only singletons, watchers, recovery/health, deploy, per-host maintenance, budget/leveling, and so on. Include a summary table (unit, cadence, host scope, one-line purpose) at the top.
- Put it under context/operations/ (for example systemd-units.md, or a directory if one file gets too large), and link it from README.md and context/operations/README.md. Cross-link from deploy.md, leader-follower.md, scaling.md and health.md where they discuss units.
- Derive every fact from the unit files and scripts themselves, not from memory. Where a unit looks orphaned, dead or undocumented in intent, say so plainly in an "anomalies" section rather than guessing.
- Add a cheap completeness check (for example a test under scripts/jobs/test/) that fails when a unit file in scripts/systemd/ has no entry in the doc, so the doc can't silently drift.

Do not change unit behavior; this is documentation plus the drift check only.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-28T19:40:06Z
