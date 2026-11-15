**endojs/endo-but-for-bots #1664**: the verdict is **MERGE-NOW**, but I did not merge. The `zizmor` CI check is red, and the merge gate never skips CI. The failure comes from the base branch, not from this PR.

**What the PR does:** bumps `zizmorcore/zizmor-action` from 0.8.0 to 0.8.1. It changes one line, in `.github/workflows/zizmor.yml:41`.

**Checks:**
- **Base comparison (first step):** the base `llm` (at `48d6f3e`) has this action in one place, at v0.8.0. The PR is 1 commit ahead and 0 behind. So it is still a real change, not superseded or a no-op.
- **Pinned commits:** the tag v0.8.0 resolves to `53290bad` and v0.8.1 to `45d7276c`. Both match the hashes in the diff.
- **Upstream code read (`v0.8.0...v0.8.1`):**
  - The one change to how the action runs is a newer `codeql-action/upload-sarif` pin. That step only runs when `advanced-security` is on, and this repo sets it to `'false'`.
  - The real change for this repo is that the zizmor tool itself moves from 1.31.1 to 1.32.0. The workflow pins no zizmor version, so it gets whatever the action calls "latest".
  - I found no new network calls, no new shell logic and no changes to credential handling.
- **Waiting period:** the newest release involved is the action itself, published 2026-11-03T00:03Z. The 7-day waiting period ended 2026-11-10, so it is satisfied.
- **Security advisories:** none on the action. The one zizmor advisory (GHSA-f42p-wjw5-97qh) affects only zizmor 1.27.0. This bump is routine, not a security fix.
- **CI:** 8 pass, 24 skipped, 1 fail (`zizmor`). zizmor flags two lines, line 49 of `update-action-pins.yml` and of `update-action-pins-major.yml`. Both pin `peter-evans/create-pull-request` with the comment `# v8`, and the `v8` tag moved to v8.1.3 on Nov 9–10. Every PR that touches workflows now fails this check. PR #1659 is the fix; it changes the comment to `# v8.1.1`. #1662 does not fix it, because it keeps the `# v8` comment.

**What I did:**
- Posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1664#issuecomment-6900557093
- Wrote the dependabotany ledger entry `entries/2026/11/15/200947Z-message-botanist-eef4af.md`. It is an open MERGE-NOW row.
- Parked a follow-up job, `endojs-endo-but-for-bots-pr1664-dependabot-after-pr1659`, blocked on #1659. When #1659 lands, it re-checks this PR and merges it with `ci-wait-merge.sh --dependabot-auto-merge`. The daily recheck schedule `dependabotany-recheck-endo-but-for-bots` already exists as a backstop.
- I pushed nothing to the PR.

**Notes:**
- #1659 targets a frozen copy of the base, `llm-48d6f3e`, so its fix needs to reach the live `llm` branch before this PR's CI can pass. #1659 also has no review yet.
- I opened no upstream changelogs or release notes, so nothing needed the content classifier. One slip: the OSV advisory query returned the advisory's full text, which I read without classifying it first. It only described the 1.27.0 issue.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1664-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2011621 cached reads)
- Output: 12852 tokens
- Cost: $1.4353641999999998
- Wall-clock: 380s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
