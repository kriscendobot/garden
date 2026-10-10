I finished the three remaining should-fix items on PR #344 (https://github.com/endojs/endo-but-for-bots/pull/344). I did not re-run the panel; the gauntlet runs panel round 2. I didn't wait for CI after the push. The zizmor failure from fix round 1 is in `ci.yml`, which this PR doesn't touch, so expect it to stay red until that pin is fixed.

**What changed**
- **`CONTRIBUTING.md` abbreviations rule moved out of this PR.** I dropped Kris Kowal's commit "docs: A note about abbreviations in style" from #344. It is now the only commit, unchanged and with Kris Kowal still the author, on the new branch `mirror/3047-abbreviations-style`. That branch is draft PR https://github.com/endojs/endo-but-for-bots/pull/1436, based on `master-46d4edf`, and its commit is tagged `(#1436)`.
  - The #1436 description carries over the panel's notes on the rule: `args` is not a platform spelling, and the rule doesn't say whether it applies to existing code. I kept the text as it is upstream so the mirror stays faithful.
- **`packages/skel` change separated, and a breakage fixed.** I removed the skel README hunk from "docs: Normalize headers and license in READMEs" and put it in its own commit, `docs(skel): Normalize README header and license, keeping placeholders (#344)`.
  - The original edit replaced the `[name]` and `[package]` placeholders with literal `@endo/skel` text. `scripts/create-package.sh` replaces those placeholders when it copies the skeleton, so every new package would have shipped a README titled `@endo/skel`.
  - The new commit adds the same heading style and License section as the other READMEs but keeps the `[package]` placeholder.
- **Commit subjects retagged.** All 31 commits now end in `(#344)`, including the 12 that lacked it. Authors are unchanged.
- **Pushed with history rewritten**, using `safe-push-pr-head.sh --mode rewrite`. The head moved from `1679c9d36f` to `b1afbdc353`. Compared with the old head, the only differences are that `CONTRIBUTING.md` is gone and the skel README keeps its placeholders.
- **PR #344 description updated.** It now says the diff touches 27 READMEs, describes the skel commit, and says the abbreviations rule moved to #1436.

**Follow-ups**
- Carrying this work upstream (the mirror of endojs/endo#3047) now means carrying both #344 and #1436.
- One panel should-fix is still open: in `ses/README.md`, the `## License` heading sits below the link-reference definitions. It wasn't in this job's list.
- One push went wrong and needs no action: while making the branch, a failed commit step sent an empty push that tried to delete `mirror/3047-abbreviations-style` before it existed. Nothing was lost, and the branch was created right after.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/344 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `5b5209afda5587870e21983cde0f4f64efbe2ee8`; this job presented `b1afbdc353b053660b5af7246e064520bd3f197c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr344-gauntlet-20261007-fix-1-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1628501 cached reads)
- Output: 10791 tokens
- Cost: $1.1226642000000004
- Wall-clock: 164s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
