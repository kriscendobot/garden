I recorded a fresh staged gauntlet for endojs/endo-but-for-bots#1349 at head `28177349`. Its stages have not run yet, so no panel has reviewed this head so far.

**What I found**
- PR #1349 is open, not a draft and mergeable. Its head is `28177349d018` on `build/hardened-text-codecs-shim`, its base is `master-ebc7904`, and its review decision is CHANGES_REQUESTED.
- The retcon job (`retcon-endo-pr1349-20261028`) moved the head from `991f8af4` to `28177349`, and its panel-head freshness check says review is required. The last finished panel reviewed `991f8af47e27`.
- CI is fully green at `28177349`, per the shepherd job `…-pr1349-shepherd-28177349`. Its one red result was a macOS daemon EPIPE test that passed on rerun.
- No other gauntlet record for #1349 is active, and no #1349 jobs are in todo or plan.

**What I did**
- I ran `post-gauntlet.sh --by gardener endojs-endo-but-for-bots-pr1349-gauntlet-20261028-28177349 https://github.com/endojs/endo-but-for-bots/pull/1349`, using the same naming pattern as the earlier `…-20261028-991f8af4` restage. It is the feature kind, with up to 6 review rounds, 6 resumes and 2 stage retries.
- I confirmed the record is on `origin/journal2` at `jobs/gauntlet/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-28177349.md`, in state pending at the viability stage.
- The `gauntlet.sh` driver on the leader host now runs it one stage at a time: viability, clean, panel-1 at `28177349`, fix rounds if needed, then un-draft. The PR is already out of draft, so the un-draft step will change nothing.
- I made no garden commits and changed nothing on the PR.

**Follow-ups**
- **The #1425 overlap is probably still open.** The last panel's integrator seat had an open must-fix: #1349 makes the same XS lockdown-compartment change as the draft PR #1425. If the new panel raises it again, the maintainer will have to pick one of the options in the earlier ferry-restage message.
- **Ferry:** the ferry directive was re-staged by the retcon job. The maintainer should run `scripts/ferry.sh` only after this gauntlet passes at `28177349`.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `991f8af47e27cee09c6e3db5babf9714dbd60214`; this job presented `28177349d0180f4a515e2bb17833ffcbe2ad6749`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-28177349.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (927699 cached reads)
- Output: 4096 tokens
- Cost: $0.7838038000000003
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
