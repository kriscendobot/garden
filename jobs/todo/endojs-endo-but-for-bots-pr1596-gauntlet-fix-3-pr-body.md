---
posted_at: 2026-10-31T21:07:57Z
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Relay: update the PR body of endojs/endo-but-for-bots PR #1596

https://github.com/endojs/endo-but-for-bots/pull/1596

The gauntlet fix-3 stage (job `endojs-endo-but-for-bots-pr1596-gauntlet-fix-3`) pushed head
`3eaff56784d612d173978d2802d12984ca7f6922` to `build/m3-mvs-resolver-reference`. That push applied the
round-3 panel findings (the pruner's PR-body items 7–10, and the removal of `parseRangeMajor`).
The worker's host (oros-studio) gets a 403 on `updatePullRequest` for endojs, so the body edit is relayed here.

Task: write the body below VERBATIM (everything between the BEGIN/END markers, not including the markers) to a file and run
`gh pr edit 1596 -R endojs/endo-but-for-bots --body-file <file>`. Then confirm with
`gh pr view 1596 -R endojs/endo-but-for-bots --json body` that it contains the `<!-- garden-job: build-mvs-resolver -->` marker.
Do not change code, push, or post reviews. If the PR is closed or merged, do nothing and report that.

----- BEGIN BODY -----
Refs: `designs/mvs-resolver.md` (the accepted M3 minimum-version-selection design).

## Description

The JavaScript registry resolver in `packages/exo-npm/src/mvs-resolver.js` now groups the ranges requested of each package and selects, per group, the least published version that satisfies every range in it, widening only when the dependency graph demands it.
A range joins the first group that some published version satisfies together with it, and otherwise starts its own group.
This replaces the `parseRangeMajor` slot key, which is removed.

- **Least satisfying selection.** An unrelated newer compatible release no longer advances the resolution.
- **Disjoint ranges coexist.** Ranges no single version satisfies together (`~1.2.0` and `~1.3.0`, `^0.1.0` and `^0.2.0`, `^1.0.0` and `^2.0.0`) resolve to separate versions, as npm would install them, instead of failing the resolution or silently discarding a constraint. A union such as `^1.0.0 || ^2.0.0` shares a version with a later narrower range.
- **Pre-release precedence.** Versions compare by full semver precedence, so a range's pre-release floor is enforced (`^1.0.0-beta.2` rejects `1.0.0-alpha.1`, and `beta.2` sorts before `beta.10`). `satisfiesRange` admits a pre-release only when the range names a pre-release of the same `major.minor.patch`.
- **Pruning.** Packages and diagnostics reachable only through a superseded selection are dropped; this goes beyond the design's Go-style description.

### Security Considerations

No new authority or trust boundary.

### Scaling Considerations

A new range tries each existing group of its package once before starting a new one.

### Documentation Considerations

The changeset `.changeset/exo-npm-mvs-least-satisfying.md` covers the behavior change and the removed export.

### Testing Considerations

`packages/exo-npm/test/mvs-resolver.test.js` covers selection, grouping, pre-release handling, optional and workspace diagnostics, and pruning.

### Compatibility Considerations

`@endo/exo-npm` is `private: true` and unreleased; `parseRangeMajor` had no consumers outside the package.

### Upgrade Considerations

No live-state migration or operator action is required. Resolutions recomputed after this change may select older package trees and therefore produce a different resolution hash.

<!-- garden-job: build-mvs-resolver -->
----- END BODY -----
