---
ts: 2026-06-23T00:00:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

Opened mirror PR for endojs/endo#3099 ("perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling" by turadg) as endojs/endo-but-for-bots#509.

Branch: `mirror-endo-3099` rebased onto frozen base `master-7c25992`.
Head SHA: `367b9dccef5227e8dc55a6778f4a0025d7b7d165`.
Commit count: 11.

Conflict resolution:
- `packages/bundle-source/src/zip-base64.js`: HEAD had the simpler pre-profiling version; upstream version added the full profiling harness referencing `profile.js`. Resolved by accepting the upstream version at the conflict commit.
- `packages/bundle-source/src/endo.js`: same pattern — upstream added profiler arguments. Resolved by accepting upstream version.
- `packages/bundle-source/package.json` (twice): upstream added scripts (`bundle:agoric-source-specs`, `trace:merge`) that collided with the existing `profile:agoric-bundling` script already on master. Resolved by merging both sets of scripts.

The cherry-pick was done in two stages because the first attempt skipped `a8ccbb26a` ("feat(bundle-source): add opt-in chrome trace profiling"). The second pass applied all 11 commits correctly, though the insertion point for the trace-merge commit ended up at the tip (the commit is last in the local history rather than second). Content is correct.

PR is DRAFT. The steward's per-cycle survey will pick it up for cleaner → judge → fixer-loop → un-draft.

Self-improvement: when cherry-picking a range with `a..b`, the start SHA is exclusive — cherry-pick the first commit separately and then use `<first>..b` or list all SHAs explicitly to avoid silently dropping the boundary commit.
