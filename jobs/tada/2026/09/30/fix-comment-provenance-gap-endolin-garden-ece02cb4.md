I found the call site and fixed it; the fix is pushed to `main2` as `c63c16cad57`.

**Which call site:** `gauntlet_terminal_comment` in `scripts/jobs/gauntlet.sh`. It posts the "Gauntlet terminal — review-budget-reached / halted / parked-ci-billing" status comment on a PR with `gh pr comment`. It was added in `e4fe55c740f` on 2026-09-27, which fits alerts starting on 09-29 once it was deployed. It runs from the gauntlet timer with no LLM involved, but it never set `GARDEN_NO_LLM`, so every post raised the provenance-gap alert. The gap check runs before `gh` itself does, so every quota-cooled retry of an owed terminal comment also added to the count. That explains 22+ hits from one host.

I could not confirm this against the actual comments: GitHub's rate limit was exhausted when I tried to list comments from that host. The conclusion comes from reading the code. I checked every script that posts a comment, closes a PR, or posts a review, and this was the only machine-only one still missing `GARDEN_NO_LLM`. `pr-receipt`, `mirror-close`, `block-pr-comment`, `comment-reply` and `comment-reactji` already set it; the other scripts that post comments are run by LLM workers.

**Changes:**
- **`scripts/jobs/gauntlet.sh`:** `GARDEN_NO_LLM=1` is now set on just that one `gh pr comment` call. The comment footer now reads `model automatic`, and the gap alert no longer fires for it.
- **`scripts/jobs/test/gauntlet-gh-stub.sh`:** the stub now records the `GARDEN_NO_LLM` value each posted comment saw.
- **`scripts/jobs/test/gauntlet-test.sh`:** a new check that the terminal comment is posted with `GARDEN_NO_LLM=1`.

**Testing:** I ran the real `gauntlet_terminal_comment` function directly against the test `gh` stub, and it posted with `GARDEN_NO_LLM=1`. The new check in `gauntlet-test.sh` has not actually run: that test stops at its first subtest ("tick 1: todo=[] stage=clean child=g1-clean"), and it fails the same way on unmodified `main2`, so the failure isn't from this change.

**Follow-ups:**
- `gauntlet-test.sh` fails on `main2` at its first subtest and needs a separate fix.
- After the next rolling deploy, check that `comment-provenance-gap-endolin-garden-ece02cb4` stops growing. If it keeps growing, there is a second path, and the alert text should be extended to name the calling script so the next hunt doesn't depend on reading code.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-provenance-gap-endolin-garden-ece02cb4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2161842 cached reads)
- Output: 10981 tokens
- Cost: $1.2383244
- Wall-clock: 644s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
