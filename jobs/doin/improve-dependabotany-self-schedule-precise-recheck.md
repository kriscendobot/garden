When the botanist embargoes a dependabotany row, have it deterministically place a one-shot recheck at the computed maturity-floor-to-the-hour (plus a small epsilon, e.g. floor+15m) via `scripts/jobs/set-schedule-once.sh`, instead of relying on the fixed-cadence daily `dependabotany-recheck-<project>` heartbeat (which fired ~8h before #197's 22:43Z floor and could take no terminal action) plus a maintainer hand-creating the precise one-shot (`dependabotany-recheck-endo-but-for-bots-pr197` at 23:00Z). Encode the floor computation + one-shot placement in the botanist's embargo step (`roles/botanist/AGENT.md` and whatever dependabotany sweep procedure it reads), keep the daily heartbeat only as a backstop, and have the one-shot self-delete after firing. This moves "place the precise maturity recheck" off the maintainer/agent and into a deterministic schedule write, eliminating the systematic no-op-heartbeat window for any embargoed row whose floor is not cron-aligned.

---
claim:
  host: endolinbot2
  gardener: 27
  claimed_at: 2026-06-30T14:51:17Z
