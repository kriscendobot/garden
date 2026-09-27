Viability verdict for endojs/endo-but-for-bots PR #1298: **proceed**. I spent no clean, panel, fix or CI budget.

**PR facts:** The PR is OPEN and still a draft ("Ironhorse continuous-fuzz findings (regression locks)"). Its head is `kriscendobot:ironhorse-fuzz-findings` at `bbd65a4055` and its base is the pinned `llm-387ea66`. It is the standing branch that follows #1088, which merged. It was last updated today at 08:59Z, when the `13b68e2edb67861a` finding landed.

**Deciding question:** Does current `llm` already carry this PR's regression locks and fuzz-harness changes, or no longer need them, so that the standing findings PR has been displaced?

**Answer: no.** The PR has not been overtaken and its reason for existing still holds.

**Evidence:**
- Against current `llm` the branch is 23 commits ahead and 195 behind. The 23 commits are all regression locks for continuous-fuzz findings: `1a2012ae…`, `f83dc893…`, `c6c71d42…`, `2cc2ac67…`, `9894aac5…`, `13b68e2e…`, `197b32cc…`, the dtoa findings, and others.
- None of those files are on `llm`. I spot-checked 4 finding tests by path and all returned 404. `llm`'s `ironhorse-vm/tests` has 18 `finding_*` files, and none of them match these finding IDs.
- The fixes these regressions build on are already in `llm`, as the PR description says: `c8497fd88` (oracle meter widened to 64 bits) and `dbdddec76` (reuse the unescaped regexp source). The PR adds the locks that make sure those fixes stay in place, which `llm` does not yet have. So the reason for the PR still stands.
- The PR is a living draft: the fuzz service keeps adding findings to it (12 comments, the latest today). No newer PR or design replaces it; #1088, the only related PR, is its merged predecessor.

**Caveat for later stages:**
- One commit overlaps partly with newer `llm` work. `fdb9fef6e0` ("compare Number results by the oracle's exact double", finding `05264cccae42245a`) touches `ironhorse-fuzz/src/comparison.rs`, `lib.rs` and the `xs-oracle` shim. Since then `llm` has gained `0524e0eb81` ("a biased boundary spelling is not a value divergence") and `614015dbde` (09-20), which handle the same tie/boundary-spelling family a different way.
- Expect a conflict in `comparison.rs` when this is rebased or re-pinned onto current `llm`. Whoever resolves it may want to drop or reconcile `fdb9fef6e0` against `llm`'s `oracle_spelling_is_a_tie`.
- This is a rebase issue for the gauntlet's clean/fix stages. It does not make the PR superseded.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (335200 cached reads)
- Output: 3480 tokens
- Cost: $0.5252239999999999
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
