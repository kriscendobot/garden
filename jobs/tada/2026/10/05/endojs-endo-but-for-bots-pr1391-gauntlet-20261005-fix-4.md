# PR #1391, fix round 4: all must-fix items applied, CI green

I pushed one follow-up commit and rewrote the PR body. CI finished green (`ci-wait-merge` rc 0, 33 checks, 0 failed).

**Panel-4 must-fix items (review 5416795507):**

1. **prover: three tests in `packages/ses/test/sturdyref-shimmed.test.js` didn't depend on the PR's changes.** Commit `673167cf5a` (`test(ses): make the shimmed-SturdyRef survival tests load-bearing`) fixes this. The survival, start-binding and hardening tests now also check what a child compartment sees:
   - the child sees the same own property names on `SturdyRef`;
   - the child's binding has the same value and is writable and configurable;
   - inside the child, `SturdyRef`, its prototype and both statics are frozen.

   Only the PR's SturdyRef permit gives a child compartment its `SturdyRef` binding.
   - **Check:** I reverted `packages/ses/src/{global-object,intrinsics,lockdown,permits}.js` to base `ef4662f04b5`. All 6 tests in the file failed, and with HEAD sources restored all 6 pass. eslint and prettier are clean.
   - **Approach I dropped:** asserting that lockdown logs no "unpermitted" warning about SturdyRef. Lockdown never walks the global object, so it logs nothing about SturdyRef even on the reverted code.
2. **Template pre-pass and integrator: PR body missing two template headings.** I added `### Scaling Considerations` and `### Documentation Considerations`. The Documentation section says that no SES doc lists the shared globals (`HandledPromise` only appears in `CHANGELOG.md`), so the changeset is the user-facing record. I also added a sentence to Description naming the `@endo/sturdyref` patch, as the integrator's comment-only item 4 suggested.
3. **coverage-auditor: no stated reason why `@endo/sturdyref` has no XS tests.** Testing Considerations now says that:
   - `@endo/sturdyref`'s `test:xs` stays a stub because the package has no platform-specific code or exports;
   - `packages/ses`'s XS smoke test covers its cross-compartment behavior under lockdown;
   - `sturdyref-prelockdown.test.js` covers the captured-globals fix on Node.

   It also notes that every shimmed-case Node test fails when the `src` changes are reverted.

**Not done:** the integrator's should-fix item 2, dropping the four self-cancelling `test(daemon)` commits (`e703fad05d`, `d6d07ab446`, `14381fc8f5`, and the revert `0ebeab85eb`). It isn't a must-fix, and it would rewrite the branch history. It's a cleanup for the person who regroups the commits before merging.

**Other notes:**
- While CI ran, `gh pr view` failed for about 9 minutes. `ci-wait-merge` treated those ticks as not green (it never assumes green) and still reached GREEN at the end.
- `packages/relay-server/src/index.js` shows a file-mode change in the project worktree. I left it out of the commit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2215398 cached reads)
- Output: 14736 tokens
- Cost: $1.3586716000000005
- Wall-clock: 2684s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
