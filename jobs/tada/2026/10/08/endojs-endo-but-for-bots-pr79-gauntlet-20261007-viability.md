**Viability report: endojs/endo-but-for-bots PR #79** ("test(ses): pin namespace mutation parity with Node.js")

The PR has not been superseded, so the gauntlet may proceed. Its upstream mirror is still open, and neither repo has an equivalent test yet.

Deciding question: Is the SES namespace-mutation parity test missing from both repos' default branches, with no other test covering the same check, while the upstream mirror is still open?
**Answer: yes.**

Evidence:
- **PR #79:** open, not a draft, not merged. The head is `9ae6e4d5586`, the base is `master-c49fb04` (`c49fb048b`), and there are no reviews.
- **Last maintainer word:** the most recent maintainer comment (2026-06-07) says #79 mirrors upstream endojs/endo#3231 (head `d704b3c46`). Earlier, on 2026-05-29, the maintainer asked for a rebase and a CI shepherd. Nothing since then withdraws or replaces the PR.
- **Upstream mirror:** endojs/endo#3231 is still open and unmerged.
- **Test file:** `packages/ses/test/namespace-mutation.test.js` returns 404 on endojs/endo's default branch and on endo-but-for-bots `master`.
- **Equivalent tests:** a code search for "namespace mutation" and `_namespace-mutation` found nothing in either repo. The reason for the PR, pinning how SES Compartment namespace mutation compares with Node.js ESM, still holds.

Problem for the next stages: the head is 150 commits ahead of `master-c49fb04` and 0 behind. Its tip is the test commit, but it also carries about 149 unrelated commits, all listed in the PR diff: stream flatMapReader, pass-style document.all, chacha12, and others. So the head looks like it was rebased onto a newer master while the PR's `base` field stayed at the old frozen snapshot. This doesn't change the viability answer, but the clean stage, or a weave to a current `master-<sha7>`, should move the base before the panel runs. Otherwise the panel will review the whole divergence instead of one test file.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr79-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (167976 cached reads)
- Output: 1708 tokens
- Cost: $0.4021152
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
