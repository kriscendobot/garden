# Garden bulletin

_As of 2026-06-24T22:33:06Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (7)
- `build-github-mention-watcher` — Build a GitHub-wide @kriscendobot mention watcher, gated on a verified-truste...
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `harden-producer-push-path` — Harden the producer push path: confirm the push landed; fix the shared-clone ...
- `reliable-pause-resume` — Make liaison "pause" and "resume" reliable (codify scripts + role), from rece...
- `scholar-ingest-cask-3` — Scholar: continue the library ingest of kriskowal/cask (cycle 4)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask
- `scholar-ingest-collections-operators` — Scholar: ingest the remaining kriskowal/collections operator READMEs

### tada (78)
- `scholar-ingest-frb-3` — Completion report — scholar-ingest-frb-3 (scholar cycle 4)
- `scholar-ingest-cask-2` — The follow-on scholar-ingest-cask-3 was posted and already claimed by another...
- `improve-mentor-journalctl-timeout` — Done. Completion report:
- `bulletin-show-job-descriptions` — Completion report — bulletin-show-job-descriptions
- `harden-fleet-gh-identity` — Completion report — harden-fleet-gh-identity
- … and 73 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
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
- 223147Z-progress-gardener-deb883.md: gardener-21 on endolinbot completed job harden-fleet-gh-identity
- 223157Z-progress-gardener-2638ba.md: gardener-6 on endolinbot completed job bulletin-show-job-descriptions
- 223205Z-progress-gardener-e14fc4.md: gardener-28 on endolinbot completed job improve-mentor-journalctl-timeout
- 223209Z-progress-gardener-bc45df.md: gardener-52 on endolinbot completed job scholar-ingest-cask-2
## Latest

The board cleared its backlog to zero `todo` while seven jobs run in `doin`. Since the last bulletin, `scholar-ingest-frb-3` finished (scholar cycle 4), capping a run of completions: `harden-fleet-gh-identity`, `bulletin-show-job-descriptions`, `improve-mentor-journalctl-timeout`, `scholar-ingest-cask-2`, plus the endo-but-for-bots #57 port-and-shepherd pair and the Copilot-feedback pass on #474. Two items want the maintainer's eye: the `research-siwe-oauth-providers` job delivered its SIWE/OIDC landscape report, and `harden-fleet-gh-identity` left a heads-up flagging something about the live tree's GitHub identity — worth reading before the next fleet push. Remaining `doin` work is mostly scholar library ingests (cask, collections operators) alongside the mention-watcher build and the producer-push and pause/resume hardening jobs.
