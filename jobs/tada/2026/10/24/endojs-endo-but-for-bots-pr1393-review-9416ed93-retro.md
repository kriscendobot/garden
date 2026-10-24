## Retrospective: endojs/endo-but-for-bots#1393, review 5610193365

**Verdict: a process miss, added to the existing `post-gauntlet-fixer-change-unreviewed` cluster. I held the cluster rather than dispatching an improvement job.**

**What the review said (paraphrased).** kriskowal requested changes on head `6976bb0ee5`. The review body only asks the bot to acknowledge; the substance is in three inline threads:
1. Use a different prefix letter than `t` for Parcels in the ordered encoding.
2. `marshal-justin.js` imports from a module named `types.types.js`, which repeats "types"; please explain.
3. A `Map` type annotation in `marshal.js` fell back to `Map<number, any>`. He said falling back to `any` is never acceptable, and asked for a job that sets up no-`any` type checking across the repo.

**What I checked myself (not taken from the primary job's report):**
- Six panel rounds ran on this PR, the last on head `4445fbf937` (2026-10-03). At that head the map was still typed precisely (`Map<number, RemotableObject | Promise | SturdyRef>`) and the import pointed at `./types.js`. Both problems arrived with the 2026-10-15 Parcel pivot restack.
- The restack did start a fresh gauntlet (`endojs-endo-but-for-bots-pr1393-gauntlet`). Its clean stage failed on an unrelated daemon CI flake that the bot's token cannot rerun. That gauntlet then sat halted for a week. The new head reached the maintainer without any panel review.
- Finding 3 is something the panel would likely have caught: in round 5 the typist seat flagged a different `any` type in `dot-membrane.js`. Finding 2 is a likely stylist or ergonomist catch.
- Finding 1 is taste, not a miss. The `t` prefix was present through all six panel rounds, and the suggested `s` is already used for strings. The request for repo-wide no-`any` checking is new direction and belongs to the primary job.
- The primary job's fixes are on the PR: head `2a40caf714` (2026-10-22) restores the precise map type and imports from `./types.js` again.

**What I recorded:**
- **Miss record:** `review-misses/misses/endojs-endo-but-for-bots-pr1393-review-9416ed93.md`. Category `process`, severity minor, paraphrased grounds only. The writer reported `count=7`, `status=open`, `prs=475,858,1226,1227,1349,774,1393`, and no recurrence (the cluster was already open).
- **Threshold decision: hold, with the rationale written to the cluster.** The numeric floor is far exceeded. But the cluster is still open from a genuine recurrence on 2026-10-19 (the #1349 miss), whose maintainer alert was read with no decision recorded since. Per skill § 6, a second improvement round does not start without that decision. I sent no further alert.
- **New information in the rationale for that decision:** #1393 fails in a different way from #1349. On #1349 the freshness check noticed the unreviewed head but only queued it for the maintainer instead of starting a panel. On #1393 a gauntlet was started but halted on an off-diff CI flake and was never resumed or re-staged. Any second round should cover both. Candidate fixes: a sweep that resumes halted gauntlets, or running the panel before the clean stage when the clean failure has nothing to do with the diff.

**Follow-ups:**
- The maintainer needs to decide whether to sanction a second improvement round for `post-gauntlet-fixer-change-unreviewed`. It now holds 7 misses across 7 PRs.
- The PR #1393 gauntlet is still halted at the clean stage. Someone with rerun rights should retry `test (24.x, ubuntu-latest)` in run 38678986955 and resume it, or the gauntlet should be re-staged on head `2a40caf714`.

Nothing was committed to `main2`; the only writes were these two journal records.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4445fbf937910b0ab04af1cc5c5cc98b19088b99`; this job presented `2a40caf71433c639eaa5a855a5cd4c2dca979bf4`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1393-review-9416ed93-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2023762 cached reads)
- Output: 11590 tokens
- Cost: $1.3204644
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
