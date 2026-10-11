I've pushed the panel-3 must-fix and request-changes items to PR #177 as a follow-up commit, and CI is green on the new head.

**What changed** (commit `7513e22`, `69dc617..7513e22`, on `design/git-remote-served-clip`, file `designs/git-remote-served-clip.md`):
- **Novice, must-fix 1:** added a **Background** paragraph before "What this settles". It defines partition, attenuation, served ref, write side, CAS, `contentRoot`, clip, `endo-gateway` and vhost record. It is followed by a list of the arc's increments and a one-line description of each related design: #41, #49, #39, #88, #142, #170, #93 and #174.
- **Novice, must-fix 2:** added **The problem** paragraph: a shared link must survive a push, and a page load must never mix two pushes. § 1 now opens by explaining what a mutable origin and an immutable origin each cost.
- **Novice, should-fix 3:** § 5.1 now opens with a worked example of a push landing mid-load.
- **Pruner:** cut the "Grounded against" list from nine lines to three. I also cut the PR body to about 60 words: what the design settles and the pending Model S vs P decision. The `garden-job` marker is kept.
- **Critic:**
  - The coherence guarantee now names the leak where raw HTML opened directly under `/.content/<root>/` loads current scripts through absolute paths.
  - The doc explains why the cap is 16 roots.
  - The § 8 table now says "prevented" holds only while the page's root is still retained.
- **Critic 4 and skeptic 5:** a new deployment-assumption paragraph in § 4 says the design assumes one write-side process and one gateway, and what a second replica of either would change.
- I also replaced an existing ellipsis character (`…`) in § 7 with three dots, per the hard-to-type characters rule.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 with all 3 checks passing (`test` and Claude harness on amd64 and arm64). I ran the wait in bounded 560-second slices because of the tool time limit, not the single 3600-second deadline the job specified. The first `ci-wait-merge` run, started in the same command as the PR-body edit, went to the background and was stopped at its 10-minute limit. The body edit itself completed before that.

**Not done:** the remaining should-fix items, which no seat marked blocking, are left for the panel-4 judgment. These are:
- decomplector's "smaller primitive" and markers-vs-sweep questions;
- ergonomist's skip warning for pushed `.content` paths and the `unserve`/`unpublish` verb mismatch;
- skeptic's writer trust model and differential browser corpus test.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr177-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1438776 cached reads)
- Output: 8552 tokens
- Cost: $1.0758272
- Wall-clock: 1423s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
