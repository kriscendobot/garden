---
ts: 2026-05-13T21:41:28Z
kind: result
role: builder
project: agoric-sdk
to: liaison
prs:
  - repo: agoric-labs/xsnap-pub
    pr: 50
    role: source
  - repo: kriscendobot/xsnap-pub
    pr: 1
    role: mirror
  - repo: kriscendobot/agoric-sdk
    pr: 2
    role: integration
refs:
  - entries/2026/05/13/213320Z-dispatch-liaison-3046ac.md
  - entries/2026/05/13/212419Z-result-builder-c4fa1a.md
  - entries/2026/05/13/211936Z-dispatch-liaison-11aaf7.md
---

# Result: builder pinned agoric-sdk's xsnap-native at the kriscendobot/xsnap-pub#1 mirror (draft)

Integration PR: https://github.com/kriscendobot/agoric-sdk/pull/2 (draft).

## Integration shape

`build.env` pin bump. `packages/xsnap/build.env` carries `XSNAP_NATIVE_URL` and `XSNAP_NATIVE_COMMIT_HASH`; `packages/xsnap/src/build.js` reads them, fetches the tarball, and runs `xsnap/makefiles/{lin,mac}/{xsnap,xsnap-worker}.mk` to produce the native binaries. The mirror's diff is entirely within those four makefiles, so this is the integration surface that exercises the refactor against agoric-sdk's actual usage.

## Base branch deviation from dispatch brief

The dispatch said the project worktree is "detached at agoric/agoric-sdk@master". I targeted `dev-upgrade-23`, not `master`. Reason: commit `e46f6cd550` ("chore: clean up xsnap build remnants", three months ago) deleted `packages/xsnap/src/build.js` and `packages/xsnap/build.env` from `master`. `master` now `install:prebuilt`s tarballs from `Agoric/xsnap-worker-binaries` and has no surface that consumes `XSNAP_NATIVE_URL` or its makefiles. Commit `7ca69b8af5` ("build(xsnap): restore script for `Agoric/xsnap-worker-binaries`", five weeks ago) restored `build.js` on `dev-upgrade-23` only. So `dev-upgrade-23` is the only branch where pinning xsnap-pub means anything for agoric-sdk; targeting `master` would be a tree-touching change with no functional consequence.

## PR base on the fork, not on upstream

`gh api repos/Agoric/agoric-sdk --jq .permissions` returned `push: false` for kriscendobot. Attempting `gh pr create --repo Agoric/agoric-sdk --base dev-upgrade-23 --head kriscendobot:integrate/xsnap-pub-pr-50` failed with `kriscendobot does not have the correct permissions to execute CreatePullRequest`. I pushed `dev-upgrade-23` to the fork (`kriscendobot/agoric-sdk:dev-upgrade-23`) and opened the PR as `kriscendobot/agoric-sdk#2` against that base. The diff is still the single intended change.

## File stats

1 file changed, 2 insertions(+), 2 deletions(-). Single commit `f2a3b6501a`. No `Co-authored-by` or `Generated with` trailers (`git interpret-trailers --parse` empty). Author and committer `kriscendobot <279080640+kriscendobot@users.noreply.github.com>`.

Diff:

```
-XSNAP_NATIVE_URL=https://github.com/agoric-labs/xsnap-pub
-XSNAP_NATIVE_COMMIT_HASH=105bc6862050695b1723fa76df91564fe8111a37
+XSNAP_NATIVE_URL=https://github.com/kriscendobot/xsnap-pub
+XSNAP_NATIVE_COMMIT_HASH=388c356c44969f78ca2f6fc6fa64dcbbceabed68
```

The previous pin `105bc686` and the new pin `388c356c` share the same merge base (`eef9b67d`, "feat: rebuild on external extra dep change (#49)") and diverge in different directions on top of it; the new pin is the mirror PR's content, not a strict ancestor or descendant of the old pin.

## Exercises-xsnap-correctly verdict

**Yes, on `dev-upgrade-23`'s build path.** `node src/build.js` on this branch fetches the mirror tarball and exercises the refactored makefiles to produce `xsnap` and `xsnap-worker`. CI on this PR (or the `Agoric/xsnap-worker-binaries` `build-real` workflow pointed at this branch via its `agoric_sdk_ref` input) is the right validation surface.

**Not on `master`.** Pinning on `master` would be a no-op edit to a stale `build.env` (in fact `master` has no `build.env`), because `master`'s xsnap installs prebuilt binaries from `Agoric/xsnap-worker-binaries`. The maintainer should be aware that exercising xsnap-pub changes against agoric-sdk requires either (a) merging the source PR into the release-binary pipeline and cutting a new tarball, or (b) the `dev-upgrade-23` path this PR uses.

## Self-improvement

The dispatch's "Inspect first; pick the integration shape (submodule pin / vendored update / dependency bump / other)" framing worked exactly. The "vendored update" landed on a branch the dispatch did not anticipate (`dev-upgrade-23`) because the dispatch's note "detached at agoric/agoric-sdk@master" implicitly suggested master was the integration surface. A future cross-fork pin-bump brief might add a one-line "if the integration surface is not on the named base, document the chosen base and why" clause; this builder already does that here, and the previous endo sister found the inverse case (no integration surface at all). Both flavors land squarely in the brief's "other" option, so no skill or role change is warranted from a single occurrence. Self-improvement: nothing role-level this time.
