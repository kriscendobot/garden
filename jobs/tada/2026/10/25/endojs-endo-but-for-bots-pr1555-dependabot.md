**PR #1555 is not merged: it is embargoed until 2026-10-27 because CI is red, and none of the red checks are caused by this bump.** The package itself cleared every other check. The bump is `@earendil-works/pi-tui` 0.87.1 → 1.3.0, a direct dependency of `packages/agentry` on the `llm` branch.

**What the review found**
- **Base check:** `llm` is still at 0.87.1 everywhere, so this PR is a real upgrade. It is 1 commit ahead and 0 behind, and no other Dependabot PR moves this package.
- **Lockfile:** only pi-tui 1.3.0 moved. Its two dependencies (`get-east-asian-width` 1.6.0, `marked` 18.0.11) are the same exact versions 0.87.1 uses and were already in the lockfile. No new packages, and the license is MIT on both sides.
- **Two copies of pi-tui:** 0.87.1 stays in the lockfile because `pi-coding-agent@0.87.1` still requires it. That works today because the shared `Component` interface didn't change between versions.
- **Maturity:** 1.3.0 was published 2026-10-15T19:14Z, so the 7-day waiting period ended 2026-10-22T19:14Z.
- **Publisher:** the same GitHub Actions trusted publisher released both versions, with provenance attestations on both.
- **Advisories:** none on either side in OSV or GHSA. The one nearby `marked` advisory covers 18.0.0–18.0.1, not 18.0.11. The bump does not fix a known vulnerability.
- **Source read** (both tarballs, scripts disabled): no install scripts and no executables. The new files make no network calls, start no processes and write no files. The parts agentry uses (`Container`, `Text`, `truncateToWidth`) are unchanged apart from two small additions to `Text`. I read no changelogs or release notes, so no content classification was needed.
- **Local tests:** the agentry pi-extension test file passes 52/52 on 1.3.0. One test fails in the full agentry suite: `eval › conflict-rebase`. It is a git-rebase test that doesn't import pi at all, and I didn't confirm it also fails on the base branch.

**Why CI is red:** GitHub moved its `ubuntu-latest` runners to Ubuntu 26.04, and the same checks are failing on every Dependabot PR opened today. Each failure already has a fix PR open:

| Failure | Fix PR |
| --- | --- |
| `tred: command not found` (failed again after a rerun) | #1546 |
| Playwright doesn't support Chromium on Ubuntu 26.04 | #1556 |
| `packages/sandbox` bwrap tests, breaking `sandbox-drivers` and both `cover` jobs | #1542 |

These belong to the base branch, so I pushed nothing to this PR.

**What I did**
1. Posted a verdict comment with all the findings (https://github.com/endojs/endo-but-for-bots/pull/1555#issuecomment-6402599236). It said MERGE-NOW once CI is green.
2. Started the merge script (`ci-wait-merge.sh --dependabot-auto-merge`). Once the failures were classified as runner breakage I stopped it; nothing was merged.
3. Posted a second comment saying the first is replaced by EMBARGO-2026-10-27, with the failure table (https://github.com/endojs/endo-but-for-bots/pull/1555#issuecomment-6403235990).
4. Scheduled a one-time recheck, `dependabotany-recheck-endo-but-for-bots-pr1555`, for 2026-10-27T00:15:00Z. If the runner fixes have landed on `llm` by then, it merges the PR through the same script. The existing daily recheck also covers this PR.
5. Wrote the ledger entry at `journal/entries/2026/10/25/210303Z-message-botanist-92d614.md`.

There were no garden repo changes.

**Follow-ups**
- Merging #1546, #1556 and #1542 unblocks this PR and the other Dependabot PRs opened today.
- Suggestion: bump the whole pi package family (`pi-agent-core`, `pi-ai`, `pi-coding-agent`, `pi-tui`) together, for example as a Dependabot group, to get rid of the two copies of pi-tui. 1.4.0 is already out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1555-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4145622 cached reads)
- Output: 19476 tokens
- Cost: $2.0689083999999998
- Wall-clock: 3391s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
