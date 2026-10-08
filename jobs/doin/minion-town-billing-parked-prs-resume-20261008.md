---
role: shepherd
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-10-08T19:31:31Z cleared=none -->

---
role: shepherd
tier: mentor
fallback-tier: minion
handler-timeout: 10800
priority: high
dispatch: automatic
---

# Unpark the minion.town PRs blocked by Actions billing, onto ci.minion.town

**HIGH PRIORITY.** #145 has merged, so `main`'s `test.yml` now runs on the self-hosted `ci.minion.town` runner. On 2026-10-08, kriscendobot/minion.town PRs parked with `PARKED-CI-BILLING`, or failed CI before any runner started, because of the GitHub Actions billing block. Known ones are #166, #169, #170, #171, #94, #122 and #153. Re-derive the list from the board and from the PRs' recent check runs.

PRs on a frozen `main-<sha>` base that predates #145 still run the old hosted-runner workflow. Move each one onto a frozen snapshot that includes #145. When only the base needs to change, the head can stay as it is. Then do the following:
- Rerun CI and confirm it runs on `ci-minion-town-*`.
- Resume each parked gauntlet with `scripts/jobs/gauntlet.sh --resume-from-stage <g> <clean|fix> [--iteration N]`. That covers #166, #170, #171 and the #94 screen gauntlet.
- Let the proxy screen #122 and #169 again so they can merge under the delegation.

The single runner handles one job at a time. The arm64 harness takes about 13.5 of its 20 minutes, and the host's CPU throttles after about 20 full CI runs a day. So run these one by one, not all at once. If throughput becomes the bottleneck, say so; scaling up costs money and needs maintainer approval above $50/month.

<!-- garden-annotation: key=cc627e8c389f by=producer at=2026-10-08T18:30:23Z fields=priority=high -->

Maintainer 2026-10-08: high priority, billing block stops all minion.town shepherds.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T19:31:43Z
