I opened https://github.com/endojs/endo-but-for-bots/pull/1578 against `llm`. It moves `browser-test/` to Playwright 1.64.1 and keeps the Browser Tests job on `ubuntu-latest`. A trial run on the Ubuntu 26.04 image passed, but one unrelated CI check is still red, so the PR isn't fully green yet.

**Support check: yes.** Playwright supports `ubuntu26.04-x64` from 1.61.0 onward; I confirmed it's in both its system-dependency list and its browser download list. The latest release is 1.64.1 (2026-10-14). The repo's `browser-test/` still pins 1.60.0.

**The pin isn't on `llm`.** The job assumed `llm` was pinned to `ubuntu-24.04`, but it isn't:
- **`llm`** already runs on `ubuntu-latest`. Its nightly Browser Tests run has been failing at "Install Playwright Browsers" with "Playwright does not support chromium on ubuntu26.04-x64" (for example, run 40439886955).
- **#1349** is where the pin the maintainer commented on lives. That PR is based on `master-6ee3fda`, not `llm`.
- **#1556** is an open draft that would pin `llm` to `ubuntu-24.04`. No revert PR existed yet.

So for `llm`, "reverting the pin" means upgrading Playwright.

**What #1578 changes:** only `browser-test/package.json` and `package-lock.json`, from 1.60.0 to 1.64.1. Playwright 1.64 needs Node 20 or later; CI uses Node 22.
- It's on bare `llm` rather than a frozen snapshot branch. `ensure-pr.sh` refused that until I set `GARDEN_ALLOW_FLOATING_BASE=1`. I overrode it because Browser Tests only runs for PRs based on `llm` or `master`, and running it was the point. #1556 does the same.
- **CI:** Browser Tests passed on the ubuntu-26.04 image (12 tests, run 40564004527), and lint passed.
- **One red check:** "Test project mutual dependency versions" fails with `tred: command not found`. The new runner image is missing a graphviz tool; it isn't caused by this change and fails on other branches today too. Draft #1566 ("install graphviz-tools…") fixes it. Once that lands, a rerun should turn this check green.

**Other actions:**
- I removed the `endojs-endo-but-for-bots-browser-test-ubuntu-latest-recheck` schedule with `remove-schedule.sh`, so it won't fire again.
- I replied in the maintainer's #1349 review thread, pointing to #1578: https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392944764

**Follow-ups:**
- #1578 is a draft, so it still needs its gauntlet and the maintainer's review.
- Once it lands, #1556 can be closed.
- #1349's `ubuntu-24.04` pin can be dropped when that branch picks up the Playwright bump.
- After #1566 lands, re-run the failing check on #1578.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-browser-test-ubuntu-latest-recheck-20261027-185020.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1862523 cached reads)
- Output: 10213 tokens
- Cost: $1.1421405999999998
- Wall-clock: 790s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
