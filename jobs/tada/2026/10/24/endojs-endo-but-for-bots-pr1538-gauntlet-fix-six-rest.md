Completed PR #1538 round-six fixes and pushed head `95ad1e7ac68d6c9042bba615833ba5c82797fa7c` to `build/daemon-git-clone`.

- Moved clone staging into daemon-private storage and strengthened cleanup/publication checks.
- Preserved bwrap signal semantics using `--info-fd` init reporting.
- Added swapped-staging, XS file-power, and bwrap lifecycle coverage.
- Split package changesets, removed the Floot changeset, and refreshed the PR description.
- Updated the review summary: https://github.com/endojs/endo-but-for-bots/pull/1538#issuecomment-6378583553
- CI coverage, sandbox-driver, release, build, and Node 22/24 Linux/macOS test jobs passed. CI lint remains red solely on the repository-wide warning baseline; its TypeScript and API-documentation stages passed.
- Follow-up: panel re-review and separate cleanup of the existing lint-warning baseline.

Self-improvement: nothing this time.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a4898713d72c7542754aa90f9f6852f024a593f3`; this job presented `95ad1e7ac68d6c9042bba615833ba5c82797fa7c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-six-rest.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 6281s

<!-- garden-usage-end -->
