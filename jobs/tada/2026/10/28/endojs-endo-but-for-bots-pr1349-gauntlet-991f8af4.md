I recorded a fresh staged gauntlet for endojs/endo-but-for-bots#1349, so this job is done. The gauntlet's own stages, including the panel review at the exact head, have not run yet.

**What I found**
- The PR is open and not a draft. Its head is `991f8af47e27` on `build/hardened-text-codecs-shim`, its base is `master-ebc7904`, and all 15 CI checks pass there.
- `991f8af47e` is the fix for the maintainer's review (job `…-pr1349-fix-maintainer-review`). It restores the measured Chromium codec range. The last completed panel reviewed the previous head, `1e19cde89b`, so no panel verdict covers the current head.
- No other gauntlet was active for #1349, and none was in todo, doin or plan.

**What I did**
- I ran `post-gauntlet.sh` to record gauntlet `endojs-endo-but-for-bots-pr1349-gauntlet-20261028-991f8af4`. It is the feature kind, with up to 6 review rounds, 6 resumes and 2 stage retries. I confirmed the record exists on `origin/journal2` at `jobs/gauntlet/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-991f8af4.md` (state pending, stage viability).
- The `gauntlet.sh` driver on the leader host now runs it one stage at a time: viability → clean → panel-1 at `991f8af4` → fix rounds if needed → un-draft. Since the PR is already out of draft, the un-draft step changes nothing.
- I made no garden commits and changed nothing on the PR.

**Follow-ups**
- **The #1425 overlap is still undecided.** The last panel's integrator seat had an open must-fix: #1349 makes the same XS lockdown-compartment change as the draft PR #1425. The new panel will probably raise it again, and the maintainer has to pick an option before it clears. Options (a), (b) and (c) are in message `…-018bed2a350d` from job `…-ferry-restage-20261028`.
- **The ferry directive is out of date.** `jobs/ferry/endojs-endo-but-for-bots-pr1349.md` still expects head `b122ff91ef`. I did not restage it. That should happen only after this gauntlet passes at the current head and the #1425 question is settled.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `1e19cde89b2810be097cf4bd8839ec4d7d43905f`; this job presented `991f8af47e27cee09c6e3db5babf9714dbd60214`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-991f8af4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (967709 cached reads)
- Output: 4475 tokens
- Cost: $0.8733618000000001
- Wall-clock: 57s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
