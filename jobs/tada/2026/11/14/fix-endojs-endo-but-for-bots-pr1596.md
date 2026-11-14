I fixed three correctness bugs in PR #1596's MVS resolver (the code that picks npm dependency versions) and pushed them to its draft branch. The new head is `cabdd761c8`. CI has 34 of 35 checks green; the one red check, `zizmor`, is a repo-wide workflow problem that this PR doesn't touch.

The job didn't name the findings: the last panel stopped before its reviewers ran, and round 6 fixed only naming style. So I reviewed `packages/exo-npm/src/mvs-resolver.js` myself and fixed what I found.

**Fixes (commit `e60e1a31c1`):**
- **Short version ranges didn't work.** Ranges like `"inherits": "2"`, `^1.2`, `~1`, `1.2`, `>1`, `<=1.2`, `1.0.0 - 2`, and `>= 1.0.0 < 3` (space after the operator) never matched, so real packages failed with "no version satisfies". `<2` went the other way and matched every version. `satisfiesRange` now expands each range into simple comparisons the way npm's `semver` does. Something that isn't a version, like a tag name, matches nothing.
- **Optional dependencies were treated as required.** npm copies optional dependencies into `dependencies` when it publishes a package, so a missing `fsevents` failed the whole resolution. A name listed in both is now treated as optional only.
- **Optional peers were installed.** A peer marked optional in `peerDependenciesMeta` is no longer installed. It is only checked when the package is already in the result.

Commit `cabdd761c8` updates the changeset and `designs/mvs-resolver.md` to match.

**Checks:**
- I added four tests, and all four fail on the previous head.
- All 73 `@endo/exo-npm` tests pass.
- `tsc`, eslint, prettier, and the pre-push checks against the pinned base are clean.
- I pushed with `safe-push-pr-head.sh`; it only added commits on top of the branch.
- I posted a summary comment on the PR (issuecomment-6875045100).

**Follow-ups:**
- **`zizmor` failure:** the `v8` tag of `peter-evans/create-pull-request` moved, so `update-action-pins.yml:49` and `update-action-pins-major.yml:49` fail. `llm` fails the same way, and open PR #1659 fixes it. Once #1659 lands, re-run the check on #1596 or weave the branch onto a newer base.
- **Fresh gauntlet:** I did not start one by hand. Because the head moved after a completed panel, the completion step should add a re-review request to the review docket. If none appears, run `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1596-gauntlet panel --add-rounds 2`.
- **Install workaround:** `yarn install` fails in the checkout (the `better-sqlite3` native build). Running it with `--mode=skip-build` and the node-modules linker was enough to run the tests.
- **Left as is:** the resolver still fetches package metadata in offline mode. The base did the same, so I didn't change it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1596.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6320463 cached reads)
- Output: 36566 tokens
- Cost: $3.1072286
- Wall-clock: 1064s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
