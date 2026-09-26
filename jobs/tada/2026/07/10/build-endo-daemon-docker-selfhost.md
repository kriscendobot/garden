I halted this job rather than executing it, because it re-attempts work the maintainer explicitly declined a day ago.

## What I found

The job asks me to build the `daemon-docker-selfhost` design in `endojs/endo-but-for-bots` (Docker image bundling daemon/worker/CLI, persistent state, external gateway HTTP/WS exposure, remote bearer-token auth) and open a mergeable PR.

That is exactly the line the maintainer **already built and closed** as PR #134 ("feat(daemon,docker): daemon Docker self-hosting + gateway remote-auth wiring"), CLOSED 2026-07-09T05:53Z. I verified the closure directly via `gh`. Recorded rationale (my project memory, confirmed): the work "is headed rapidly in another direction" — toward `@endo/gateway` + `@endo/mcp` packages grown **organically** with the Garden's AWS bring-up, maintainer-paced, explicitly **not** via a fleet-dispatched build job.

**Root cause of the spurious job:** the design record `journal/plan/designs/endo-but-for-bots/daemon-docker-selfhost.md` is still `status: Not Started`, `milestone: M3`, untouched since the roadmap import. A design→PR / milestone producer spawned this build off that stale record, unaware of the decline. It will keep re-spawning until the record is retired.

## What I did

- Verified PR #134's CLOSED state, checked for any reversal (no reversing broadcast; latest broadcast 2026-07-09 is the fork-watchers one; design record unchanged since import).
- Did **not** build anything and did **not** open a PR — surfaced the contradiction instead, per standing "confirm before hard-to-reverse / outward-facing action" discipline.
- Messaged the maintainer via the liaison (`inbox/maintainer` 20260710T121239Z-960b47) explaining the conflict and recommending: (1) mark the `daemon-docker-selfhost` record Superseded/Declined pointing at closed PR #134 + the gateway/MCP direction; (2) audit sibling M3 records #134 subsumed (e.g. `gateway-bearer-token-auth`). Offered to build a fresh PR if the direction has in fact reversed and they re-post.
- Updated project memory (`endo-gateway-mcp-direction.md`) with the re-spawn hazard so a future gardener claiming this job halts rather than builds.

## What changed

No code, no PR, no garden main2 commit. Only a maintainer message and a local memory note.

## Follow-ups (for the maintainer/liaison)

- Retire the stale `daemon-docker-selfhost` design record so producers stop re-spawning this job.
- If Docker-selfhost is genuinely wanted again, re-post and I'll build it.

Marking complete-as-declined so this doesn't requeue another gardener into the same wall.
