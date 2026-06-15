---
ts: 2026-06-15T06:11:45Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/15/061000Z-result-fixer-a7416e.md
---

# Result: PR #411 reconstructed to root-cause-only fix

Maintainer directive on PR #411 at 2026-06-15T06:06:02Z: *"Please reconstruct this branch to simply address the root cause. Update the description and title."*

## Root cause (confirmed)

[microsoft/playwright#41000](https://github.com/microsoft/playwright/issues/41000): a regression in Playwright's extract-zip path against Node.js 24.16.0, present in 1.57.0 through 1.59.x and fixed in 1.60.0. Symptoms in our logs: 167 MiB Chrome-for-Testing zip downloads in ~1.5s, `pw:install extracting archive` is the last log line, no further output for the full per-attempt timeout. Repeats deterministically across reruns and prior pins (`^1.49.1`, `1.58.2`). Confirmed green at 1.60.0 in run [27527097138](https://github.com/endojs/endo-but-for-bots/actions/runs/27527097138) on commit `45810f0f1`.

## Reconstruction

Reset `--mixed` to `origin/master-07aff33`, dropped the workflow edits and intermediate pin commits, restaged only the minimum.

Pre-push head: `45810f0f1`.
Post-push head: `a54f033e8`. Force-pushed with lease.

New commits:

| SHA | Commit |
| --- | --- |
| `ba9d11b33` | `ci(browser-test): pin @playwright/test to 1.60.0 to fix install hang on Node 24.16` |
| `a54f033e8` | `chore: Update browser-test/package-lock.json` |

Net diff vs `master-07aff33`:

```
 browser-test/package.json      |  2 +-
 browser-test/package-lock.json | 43 +++++++++++++++++++++---------------------
```

Workflow file (`.github/workflows/browser-test.yml`) is back to base (no cache, no retry, no debug, no timeout bumps, no `pull_request:` widening, no chrome-rename change).

## Dropped commits

- `d46c43b1c` cache Playwright browsers + retry install
- `dd65c157f` job timeout 60m + retry per-attempt 15m
- `37440d0e2` Playwright 1.58.2 pin (superseded)
- `3fbe0af31` DEBUG=pw:install + drop chrome rename
- `56c3e9ddb` retry per-attempt 30m + job ceiling 120m
- `467b6f1cb` run on all pull requests regardless of base branch
- `45810f0f1` restore chrome-unstable rename for chromium-next channel

All seven were diagnostic or scaffolding for a different failure shape (CDN-seed window). They are dropped because the root-cause fix (the version bump) obviates them; the maintainer can revisit cache+retry in a narrowly-scoped follow-up if the CDN flake recurs.

## PR edits

- Title old: `ci(browser-test): cache Playwright browsers + retry install`
- Title new: `ci(browser-test): pin @playwright/test to 1.60.0 to fix install hang on Node 24.16`
- Body rewritten to root-cause framing (Summary, Root cause, Why this version, Diff, Test plan). Prior cache/retry framing dropped.
- Top-level comment posted at-mentioning @kriskowal: [issuecomment-4705060140](https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4705060140).
- PR stayed DRAFT. Review not re-requested (per dispatch brief).

## Pre-push gates

`pre-push-gates.sh --probes-only` passed (8/8 probes).

## Next stage

`next: liaison`. The maintainer authored the directive directly and will decide the follow-up (most likely: re-ferry to upstream endojs/endo#3296 with the leaner diff, then conductor on green).

Self-improvement: nothing this time. The reset-restage-rewrite-body pattern is canonical fixer retcon work; the dispatch brief named the steps clearly.
