# Botanist report: endojs/endo-but-for-bots PR #1550 (`zizmorcore/zizmor-action` 0.6.4 → 0.7.1)

**Verdict: MERGE-NOW, but it is not merged.** The final merge step refused because a recently added conductor check requires a completed review panel on the exact PR head, and Dependabot PRs never get one. The PR is still open; I escalated the gap to the maintainer.

## Diligence
- **Base check:** only one workflow line uses this action, `.github/workflows/zizmor.yml:41`, and on `llm` it still pins v0.6.4 (`cc914d7f…`). So the PR is not superseded, and the diff touches only that file.
- **Pins:** I resolved both tags to commits on 2026-10-25. Both are lightweight tags and both match the PR's pins: v0.6.4 → `cc914d7f…` and v0.7.1 → `85b2b9fb…`. The owner is `zizmorcore`.
- **What actually moves** (there is no lockfile):
  - The action itself: v0.6.4 → v0.7.1, released 2026-10-15T23:23Z.
  - The zizmor tool it runs: 1.30.1 → 1.31.1, uploaded to PyPI 2026-10-15T23:12Z.
  - An internal `upload-sarif` step: v4.37.9 → v4.38.2, tag checked and matching. Our workflow never runs this step because it sets `advanced-security: 'false'`.
- **Maturity:** the freshest version is v0.7.1, so the 7-day wait ended 2026-10-22T23:23Z.
- **Advisories:** none on either side of the bump, across GHSA, OSV and PyPI.
- **Source read** (8 commits): the action stopped pulling a digest-pinned Docker image. It now downloads the zizmor wheel from PyPI with hash checking (`pip download --require-hashes`) and runs it directly. The token is handled the same way as before. I found no new network calls besides PyPI, no telemetry, and no text addressed to AI reviewers.
- **CI:** all 32 checks green on head `adf14606`. Nothing needed fixing and I pushed nothing.
- I created a project worktree for the merge step; its scripts-disabled install succeeded (WARM-CACHE built).

## Disposition
- I posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1550#issuecomment-6402433612
- I ran `ci-wait-merge.sh --dependabot-auto-merge`. CI passed and the approval step was correctly skipped for a Dependabot author. It then stopped with **`panel-head-blocked reason=missing rc=11`** and did not merge.
- **Why:** main2 commit `65ed9070fc5` (2026-10-23) added that panel check to every conductor merge, including Dependabot merges. Dependabot PRs never get a panel, so every botanist MERGE-NOW is now blocked. The `ci-wait-merge` tests fake a fresh panel by default, so T16/T25 did not catch this. This is the first time it has happened that I could find.
- I did **not** change the check myself. The conductor docs say the Dependabot path "retains every other conductor guard", so exempting it is a policy decision.

## Follow-ups
- **Maintainer decision needed** (sent through the maintainer inbox): (a) skip the panel check for Dependabot merges, the same way approval is skipped; (b) run a panel on each Dependabot PR; or (c) let the botanist write a "botanist-reviewed head" record that the check accepts. I recommend (a) or (c).
- I recorded a ledger row for this PR (journal `entries/2026/10/25/200506Z-message-botanist-a1afe2.md`) and left a comment on the PR saying the merge is held. The daily recheck (`dependabotany-recheck-endo-but-for-bots`) already exists and will retry the merge once the policy is settled.
- Upstream has since released v0.8.0 (2026-10-23). Its 7-day wait isn't over yet, and Dependabot will propose it once this PR lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1550-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2039442 cached reads)
- Output: 12660 tokens
- Cost: $1.3896164000000004
- Wall-clock: 633s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
