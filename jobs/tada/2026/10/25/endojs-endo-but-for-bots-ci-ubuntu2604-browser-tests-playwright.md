## Completion report: endojs/endo-but-for-bots browser-tests red on Ubuntu 26.04

I opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1556** against `llm` and its `browser-tests` check is green.

**Fix.** One change, to `.github/workflows/browser-test.yml`: the `browser-tests` job now runs on `ubuntu-24.04` instead of `ubuntu-latest`. A comment explains why and says when to move back to `ubuntu-latest` (together with an upgrade to Playwright 1.64 or later). This matches the sibling depcheck fix in #1546. Commit `aee74c8239` is on the `fix/ubuntu2604-browser-tests-playwright` branch.

**Why pin rather than upgrade.**
- `browser-test/` pins `@playwright/test` 1.60.0, which refuses to install browsers on Ubuntu 26.04.
- Playwright 1.64 does support 26.04 (1.64.0 shipped 2026-10-07, latest is 1.64.1). But upgrading is a jump of four minor versions across Chromium, Chrome Dev, Firefox and WebKit on a brand-new OS, plus a lockfile change. Pinning is the smaller, safer change.

**Other Playwright jobs on `ubuntu-latest`.** No change needed. The only other `playwright install` is in the `test` job in `ci.yml`, through `@endo/preact-container` and `@endo/preact-social`. Both use `^1.64.0`, and that version handles `ubuntu26.04-x64`.

**Floating base.** The PR targets bare `llm`, opened with `GARDEN_ALLOW_FLOATING_BASE=1`. `browser-test.yml` only runs for PRs based on `master` or `llm`, so on a frozen `llm-<sha>` base the check this PR repairs would never run.

**CI on #1556.**
- `browser-tests` passed in 3m7s, with 12 Playwright tests passing (run 40231991302).
- `lint`, `zizmor`, `check-action-pins` and change detection all passed.
- Every other check was skipped by change detection; none failed.

**Follow-ups.**
- The gauntlet (clean → panel → fix-loop → un-draft) stages automatically when this job completes.
- Once #1556 merges, Dependabot MERGE-NOW PRs such as #1553 should go green after a rebase or re-run.
- Later, upgrading `browser-test/` to Playwright 1.64 or later would let the job go back to `ubuntu-latest`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ci-ubuntu2604-browser-tests-playwright.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1080135 cached reads)
- Output: 7007 tokens
- Cost: $0.822223
- Wall-clock: 926s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
