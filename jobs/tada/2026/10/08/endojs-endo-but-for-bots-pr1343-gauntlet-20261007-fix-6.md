# Gauntlet fix round 6: endojs/endo-but-for-bots PR #1343

I applied the round-6 must-fix items and pushed them to the PR head. CI is green: all 26 checks passed after one unrelated flaky job was re-run.

## The must-fix items
Two seats requested changes: the **duality-auditor** and the **releaser**. The **decomplector** voted comment-only but marked one item should-fix, which I also fixed.

I pushed three follow-up commits to `kriscendobot:issue982-build-special-names` with `safe-push-pr-head.sh`, moving the head from `a7590864f` to `67b11a61d`:

1. **`de30ae2da` refactor(daemon): share one daemon-reserved special-name list** (decomplector)
   - The list of names the daemon binds itself was spelled out twice, in `host.js` and `guest.js`. It now lives once, as `daemonReservedSpecialNames` in `pet-name.js`, and both files read it.
   - The names rejected are the same as before: `@main` plus `@agent`, `@self`, `@host`, `@mail`, `@nets` and `@planes`.
2. **`1ff109276` docs(daemon): state provideHost introducedNames direction** (duality-auditor items 1 and 2)
   - The `provideHost` entry in `help.md` now lists its options and says that `introducedNames` maps the other way from `provideGuest`'s `endowments`. `help-text-data.js` was regenerated from it.
   - In the CLI `mkguest` command and `endo.js`, the local variable is renamed `introductions`, with a comment explaining why each `--introduce` pair is flipped into `endowments`.
   - I did not move `provideHost` itself onto `endowments`. That is a larger API change, and the seats themselves suggested a follow-up issue for it.
3. **`67b11a61d` docs: focus the guest endowments changeset on upgraders** (releaser)
   - The changeset now lists the reserved names and drops the sentences about how the daemon enforces the rules internally.
   - It says that guests created by an earlier daemon gain `@main` the next time they load. I checked that the base branch did not bind `@main` in guests.
   - It states plainly that the `@endo/cli` and `@endo/agentry` changes are internal re-plumbing that needs the new daemon. Their `minor` bumps are unchanged.
   - `fae`, `jaine`, `lal` and `claude-sandbox` are all `private: true`, so they don't need changeset entries.

## Local checks
- eslint on the changed files: no errors, only existing warnings.
- `help-text.test.js` and `provision-lifecycle.test.js` (which covers special endowments): 18 tests passed. To run them I had to rebuild the local `better-sqlite3`, which had been compiled for a different Node version.
- I could not run `endo.test.js` locally: the deep worktree path makes the test socket path longer than Linux allows. CI ran the full suite instead.

## CI
- On the first run, the `test (22.x, ubuntu-latest)` job timed out in `@endo/marshal` `encodePassable.test.js`. This PR does not touch that package.
- I re-ran the failed job once the run finished, and it passed.
- The final `ci-wait-merge.sh --no-merge` returned rc 0: `total=26 failed=0 → CI GREEN`.

## Follow-ups (not done here)
- Several seats suggested a separate issue to move `provideHost` onto `endowments` (ordinary keys only).
- The integrator seat suggested two things before un-drafting:
  - Fold the caller migration from `16de8967d` into the breaking `aa1aaa9cc` commit, so every commit builds on its own.
  - Squash the review follow-up commits into the commits they revise.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4172235 cached reads)
- Output: 18306 tokens
- Cost: $1.9426470000000005
- Wall-clock: 3740s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
