I've dispatched the mentat-tier supervisor that kriskowal asked for on endojs/endo-but-for-bots#695 and replied on the PR.

**Preflight.** The preflight returned exit 2, but I didn't treat it as a no-op. The only matching text on the PR was the peer job `endojs-endo-but-for-bots-pr695-6b37106d` replying that the effort is tied to arc kriscendobot/garden#47. The main ask, dispatching a mentat-tier supervisor, had no job on the board (`plan`, `todo` or `doin`), so I went ahead.

**Supervisor job.** I posted `ebfb-sturdyref-layering-supervisor-20260930` through `scripts/jobs/post-manual-job.sh` (tier mentat, manual dispatch, role orchestrator). It is in `jobs/todo/` on origin `journal2`. Its brief tells it to:
- **Build the stack:** turn the nine layers into a stacked series of builder PRs (shim → SES → pass-style → marshal → CapTP wire → CapTP construction → OCapN enliven → daemon → Agent API). The PRs run one after another under an orchestration, based on frozen `llm-<sha7>` branches, so the maintainer can review each PR and the whole stack.
- **Reconcile first:** before splitting the work, decide whether to reuse, rebase or retire each earlier SturdyRef artifact, and offer any retirement to the maintainer as "close as superseded". The artifacts are PRs #541, #698, #700–#704, #737 and #871, the parked `ebfb-sturdyref-rebase-*` and `retire-snapshot` jobs, and the parked `endo-sturdyref-enliven-design`. That last one builds on HandledPromise, while the maintainer's new first layer is a separate `SturdyRef` global, so it must not be promoted as-is.
- **Link to the arc:** link every stack PR and job to kriscendobot/garden#47 and keep a stack index there, as the peer asked in my inbox.
- **Come back to #695:** keep #695 parked until the daemon layer (8) lands, then post a follow-up to revisit #695 and #871.

**PR reply.** Comment https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5904073194 names the supervisor and the plan. The first attempt was refused by the `gh` wrapper for using bare `#N` references alongside another repo; I rewrote them as `endojs/endo-but-for-bots#N` and it posted.

**Follow-ups:**
- The supervisor is manual dispatch, so it waits for a mentat worker or for the maintainer to start it.
- The retrospective job (`endojs-endo-but-for-bots-pr695-5e067785-retro`) is still parked in `plan/`; I didn't touch it.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a9decaa5`; this job presented `e22f7e5cd15c5d9776ce0202b0fef3d2f663e4d6`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-5e067785.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (669453 cached reads)
- Output: 5542 tokens
- Cost: $0.6384186000000001
- Wall-clock: 87s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
