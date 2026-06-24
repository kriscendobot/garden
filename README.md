# Garden bulletin

_As of 2026-06-24T22:31:17Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260624T222907Z-d848e0` — from gardener:research-siwe-oauth-providers, reply_to `research-siwe-oauth-providers`: # Research: OAuth/OIDC "Sign in with your Ethereum address" (SIWE landscape)
- `20260624T223047Z-ff38ba` — from gardener:harden-fleet-gh-identity, reply_to `harden-fleet-gh-identity`: Heads-up from job harden-fleet-gh-identity (gardener-21): the live tree

## Board
### todo (0)
(none)

### doin (11)
- `build-github-mention-watcher` — Build a GitHub-wide @kriscendobot mention watcher, gated on a verified-truste...
- `bulletin-show-job-descriptions` — Bulletin: show a short description per job, not just the slug/count
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `harden-fleet-gh-identity` — Harden the fleet's GitHub identity so it is deterministically the bot
- `harden-producer-push-path` — Harden the producer push path: confirm the push landed; fix the shared-clone ...
- `improve-mentor-journalctl-timeout` — Guard mentor.sh's journalctl probe with a timeout (it can hang indefinitely)
- `reliable-pause-resume` — Make liaison "pause" and "resume" reliable (codify scripts + role), from rece...
- `scholar-ingest-cask-3` — Scholar: continue the library ingest of kriskowal/cask (cycle 4)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask
- `scholar-ingest-collections-operators` — Scholar: ingest the remaining kriskowal/collections operator READMEs
- `scholar-ingest-frb-3` — Scholar: ingest the kriskowal/frb grammar + compiler source (cycle 4 — the la...

### tada (74)
- `scholar-ingest-cask-2` — scholar-ingest-cask-2 — done (gardener 52, endolinbot, 2026-06-24)
- `shepherd-ebfb-pr57` — CI converged to green with no intervention required.
- `scholar-ingest-frb-2` — Completion report — scholar-ingest-frb-2 (kriskowal/frb cycle 3)
- `scholar-ingest-collections` — Completion report: scholar-ingest-collections (gardener 22)
- `revise-readme-liaison-interface` — Completion report
- … and 69 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 222158Z-result-scholar-b75cfb.md: # Result: scholar-ingest-collections (deepening cycle, gardener 22)
- 222204Z-progress-gardener-c30c5e.md: gardener-81 on endolinbot claimed job shepherd-ebfb-pr57
- 222236Z-progress-gardener-c51dbb.md: gardener-70 on endolinbot claimed job scholar-ingest-collections-operators
- 222327Z-progress-gardener-080aa4.md: gardener-22 on endolinbot completed job scholar-ingest-collections
- 222344Z-progress-gardener-244b81.md: gardener-69 on endolinbot claimed job build-github-mention-watcher
- 222420Z-progress-gardener-6e616c.md: gardener-47 on endolinbot completed job port-ebfb-pr57-onto-475
- 222439Z-progress-gardener-83fb23.md: gardener-18 on endolinbot completed job revise-readme-liaison-interface
- 222541Z-progress-gardener-ad38d8.md: gardener-6 on endolinbot claimed job bulletin-show-job-descriptions
- 222638Z-progress-gardener-244e3e.md: gardener-18 on endolinbot claimed job address-copilot-ebfb-pr474
- 222655Z-result-gardener-siwe-oauth.md: # Research — OAuth/OIDC "Sign in with your Ethereum address" (the SIWE landscape)
- 222918Z-progress-gardener-2a4e22.md: gardener-81 on endolinbot completed job shepherd-ebfb-pr57
- 222942Z-progress-gardener-7b2b84.md: gardener-42 on endolinbot completed job research-siwe-oauth-providers
- 222949Z-progress-gardener-9c8d7b.md: gardener-18 on endolinbot completed job address-copilot-ebfb-pr474
- 223035Z-progress-gardener-1bd9d5.md: gardener-28 on endolinbot claimed job improve-mentor-journalctl-timeout
- 223044Z-progress-gardener-4880a0.md: gardener-62 on endolinbot claimed job scholar-ingest-cask-3
## Latest

Eight jobs landed in tada and the todo queue drained to zero. On the endo-but-for-bots front, shepherd-ebfb-pr57 reported CI converged to green with no intervention, port-ebfb-pr57-onto-475 and address-copilot-ebfb-pr474 both completed, clearing the PR #57/#474 work. The SIWE/OAuth research job finished and its report is waiting as a maintainer message (`research-siwe-oauth-providers`) — worth a read if the "Sign in with your Ethereum address" question is still live. The scholar fleet kept grinding through the library ingest, completing the cask cycle 2, collections, and frb cycle 3 passes and immediately reclaiming the next cycles (cask-3, collections-operators, frb-3). One thing for the maintainer to notice directly: the `harden-fleet-gh-identity` gardener posted a heads-up about the live tree's GitHub identity — that message is queued and the job is still in doin. Newly claimed and in flight: the GitHub-wide @kriscendobot mention watcher, the bulletin per-job descriptions, the mentor journalctl-timeout guard, and reliable pause/resume.
