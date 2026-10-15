# Completion report: endojs-endo-but-for-bots-pr356-gauntlet-20261007-panel-2

The panel ran and reached a real **must-fix** verdict, but I couldn't post the review from this host. So I'm closing with the `panel-error` marker, which makes the driver retry this round on a host that can post. I did not fix or un-draft anything.

**What I did**
1. **Checkout:** made an isolated checkout of `endojs/endo-but-for-bots@design/gateway-packaging-aws-stack` at head `0b057f985`. The first attempt was killed by the 120s git limit; it worked with `GARDEN_REPO_GIT_TIMEOUT=900`.
2. **Panel:** ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 356 origin/llm-b1c3f4d`, which exited 0 with **must-fix**. It reused seat verdicts saved by an earlier attempt (record `a0bbc863a401`) for this same head, so the seats were not re-run.
   - Nine seats requested changes: packager, locksmith, breaker, purist, wire-watcher, integrator, pruner, gateway and decomplector.
   - The PR description also fails the template check: all seven template headings are missing, and seven headings not in the template were added.
3. **Posting:** `gh pr review --request-changes` failed twice.
   - First, the `gh` wrapper refused the body because it used bare `#N` references while also naming `nodejs/node`. I rewrote them as `endojs/endo-but-for-bots#N`.
   - Second, GitHub returned `Resource not accessible by personal access token (addPullRequestReview)`. This host's bot token has no PR write access on `endojs`, which is already recorded in the memory note `bot-pat-no-pr-write-endojs`.
   - No review exists on `0b057f985`; the latest review on the PR is from `18b52cac4`.

**Why `panel-error` and not `must-fix`:** the job tells `must-fix` to be used whenever `panel.sh` exits 0, and that happened here. But the next stage only sees a verdict that was actually posted, and none was. The standing guidance for this host (memory note `bot-pat-no-pr-write-endojs`) is to close this case with `panel-error` so a capable host retries. That retry reuses the saved seat verdicts while the head stays at `0b057f985`, so it's cheap.

**Changes:** none to any repo. I added two facts to the memory note: retries reuse the saved panel verdicts, and bare `#N` references must be written as full repo references.

**Follow-ups**
- The real fix is to give the bot token PR read and write access on `endojs`.
- The PR is already out of draft (`isDraft: false`) even though the panel says must-fix.
- The PR description needs rewriting to the template.
- Packager finding 1: the diff carries CI, tsconfig, test and security-doc changes inherited from a stale base, alongside the design docs. The gateway seat also says the stale base re-lands the parent design from `endojs/endo-but-for-bots#343`. Both point to a **weave** (re-pinning the merge base) as the fix.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-gauntlet-20261007-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 70 tokens (2012299 cached reads)
- Output: 12031 tokens
- Cost: $1.5806717999999997
- Wall-clock: 1811s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
