**PR #1583 viability: proceed.** The PR is open and still a draft. It was opened 2026-10-29T04:11:51Z, so nothing newer can have replaced it, and the upstream change that motivated it has merged.

**Deciding question:** Has the upstream change that prompted this reconciliation (endojs/endo#3376) landed, with no newer PR or base commit already doing the same reconciliation of `designs/hardened-text-codecs-shim.md`?

Yes, on both counts.

**Evidence:**
- **The motivating change has landed.** endojs/endo#3376 ("fix(ses): tolerate frozen null arguments/caller pills on API functions") merged at 2026-10-29T03:58:33Z. #1583 was opened about 13 minutes later to record that merge in the design.
- **The premises the PR relies on still hold.** #1349 (the codec-specific constructor encapsulation) is CLOSED, and #1425 (the XS lockdown-Compartment repair) is still OPEN. That matches how the PR separates what is obsolete from what is still owed.
- **The base is current.** The PR's base `llm-9a14ddf` (`9a14ddf660`) is 0 commits behind `llm`. The design file was last touched on `llm` by `5438a788` on 2026-10-07 ("mark hardened text codecs shim implemented"), which comes before the #3376 merge. So `llm` does not yet record the supersession.
- **No newer replacement exists.** I searched for other PRs on hardened-text-codecs:
  - #1431 is a draft that records the encapsulation revision from #1349. #1583 now treats that revision as superseded, so #1583 is the newer one and could make #1431 redundant, not the other way round.
  - #1576 is ready for review and records the Phase 3 downstream `Buffer` audit. It edits the same two files but covers different content, so it does not supersede #1583.
- **Nothing to address yet.** There are no comments or reviews. The diff touches only `designs/README.md` and `designs/hardened-text-codecs-shim.md`.

**Follow-ups:**
- Once #1583 lands, the maintainer may want to close #1431 as superseded.
- #1576 and #1583 edit the same two files, so whichever merges second will probably need a weave.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1583-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177854 cached reads)
- Output: 1772 tokens
- Cost: $0.43477080000000007
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
