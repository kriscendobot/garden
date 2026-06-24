---
ts: 2026-06-02T02:44:06Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: steward
dispatch_root: /home/kris/dispatches/fixer--d7299b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/024233Z-dispatch-steward-d7299b.md
  - https://github.com/endojs/endo-but-for-bots/pull/387
  - https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r3338318670
---

# result: fixer — #387 `.bench-engines` → `.engines` rename

Addressed kriskowal's CHANGES_REQUESTED inline comment on #387: renamed the
top-level home-directory cache from `$HOME/.bench-engines` to `$HOME/.engines`
across all references.

## Outcome

- New head SHA: `dceb649b375fc90646578b257d4179c4679b531d`
- Push: regular append `6884ae242..dceb649b3` to
  `endojs/endo-but-for-bots:fix-benchmark-wget-engines-master`. Succeeded.
- Single commit, endolinbot identity:
  `chore(benchmark): rename .bench-engines cache to .engines`

## Files modified (4)

- `packages/benchmark/install-engines.sh` (16 occurrences)
- `packages/benchmark/run-tests.sh` (2 occurrences)
- `packages/benchmark/README.md` (1 occurrence)
- `packages/hex/test/run-benches.sh` (2 occurrences)

Diff stat: 4 files changed, 23 insertions(+), 23 deletions(-).

The inner `engines/` subdirectory (e.g. `.engines/engines/xs/xst`) is
preserved; only the top-level `.bench-engines` literal was rewritten.

## Verifications

- `git grep -n bench-engines` exit code: `1` (no matches). PASS.
- `sh -n packages/benchmark/install-engines.sh` exit code: `0`. PASS.
- `sh -n packages/benchmark/run-tests.sh` exit code: `0`. PASS.
- `sh -n packages/hex/test/run-benches.sh` exit code: `0`. PASS.

## PR comments

None posted. The dispatch explicitly withheld authorization to resolve the
review thread, post comments, or un-draft; the steward owns the next-stage
follow-up (thread resolution after the maintainer reviews the fix).

## Out-of-scope

Nothing surfaced. The rename was a narrow, mechanical literal-string swap
contained to the 4 files the dispatch named; no cross-PR coordination or
deferred items.

Self-improvement: nothing this time.
