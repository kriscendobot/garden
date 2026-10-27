cadence: weekly
last_dispatched: 2026-10-27T18:50:20Z
job_basename_prefix: endojs-endo-but-for-bots-browser-test-ubuntu-latest-recheck
occupancy: skip
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weekly check (maintainer kriskowal, inline comment https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392495217 on `.github/workflows/browser-test.yml:23`): endojs/endo-but-for-bots' Browser Tests workflow is pinned to `runs-on: ubuntu-24.04` because Playwright 1.60.0 did not support the Ubuntu 26.04 `ubuntu-latest` image. Check whether the repo's current Playwright version (and the latest Playwright release) now supports ubuntu-latest (Playwright release notes / supported-platform list; ideally a trial run). If NOT yet supported: report that and stop (no PR). If supported: open (via ensure-pr.sh) a PR against `llm` reverting the pin to `ubuntu-latest` (bumping Playwright if needed), drive CI green, report the PR, and then remove this schedule (`set-schedule.sh` / the schedule skill) so it stops firing. Do not open a duplicate if a revert PR for this already exists.
