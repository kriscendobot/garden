**Fix round 5, endojs/endo-but-for-bots PR #1362: done, CI green**

I pushed six follow-up commits (`7f73e29871..74d52b50fc`) to `build/npm-dev-registry-serving` with `safe-push-pr-head.sh`. The round-5 panel review is 5350328482 plus its continuation comment. I posted the fix summary at https://github.com/endojs/endo-but-for-bots/pull/1362#issuecomment-5887468778.

**Applied:**
- **Tar parsing mismatch (wire-watcher must-fix):** our tar reader and npm's could see different `package.json` files in the same archive. Uploads are now rejected if they have:
  - a header with a bad checksum;
  - a path prefix without the standard POSIX tar marker;
  - any non-zero byte after the first all-zero end block;
  - an extended header whose size disagrees with the entry it describes.

  Each case has a test, and the accepted-prefix case has one too. The real npm pack/install test still passes.
- **Env var rename (stylist must-fix):** `REGISTRY_STATE_DIR` is now `REGISTRY_STATE_DIRECTORY` in the config, admin CLI, tests and README. Any deployment unit that sets the old name needs the same rename.
- **assessor:** an unauthenticated dist-tag `PUT` now returns 401 before the body is read, like publish (tested).
- **breaker #1, wire-watcher #2:** upstream tags that point at a dev build, or whose name is itself a version number, are dropped (tested). I checked that the test fails without the fix.
- **corner-prober:** the expiry parser rejects impossible dates such as `2027-02-30` instead of rolling them over. Also added a test for the 214/215-character package-name limit.
- **purist #4:** the admin CLI's `grants issue` uses the same expiry parser.
- **purist #1:** registry errors are frozen when created, so their status code can't be rewritten.
- **archivist:** the comment on the dev-version format now says the commit hash is 7 to 40 hex digits.

Locally, the package's 79 tests, eslint (no errors) and tsc all passed.

**Not applied, with reasons given in the PR comment:**
- **migrator (`major` → `minor`):** the garden's changeset rule for a new package is a `major` changeset from `0.1.0`, set by maintainer directive on #513. The curator and packager seats agree.
- **packager, integrator (commit grouping):** regrouping the commits means rewriting history, so it's left for a retcon pass before un-draft.
- **integrator (the design in #1361 hasn't landed; phase order):** this needs a maintainer decision, not a code change. The PR stays in draft.
- **pruner, orthographer (`SECURITY.md`):** lint requires the file to stay byte-identical to the skel copy.
- Remaining should-fix and comment-only items (breaker #2; purist #2, #3, #5, #6; prover) are deferred.

**CI:** the first run had one red job, `test (22.x, macos-15)`, failing in `@endo/daemon` `daemon-teardown › an orphaned daemon shuts itself down…`. This PR doesn't touch that package. I re-ran that job once and it passed. A final `ci-wait-merge.sh` returned rc 0 with 33 checks and 0 failures.

**Follow-ups:**
- Retcon pass to regroup the commits before un-draft.
- Maintainer decision on #1361.
- Rename `REGISTRY_STATE_DIR` in any deployment unit.
- `daemon-teardown` may be flaky on macOS with Node 22; it cleared on one re-run.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (6835217 cached reads)
- Output: 26677 tokens
- Cost: $2.9217353999999998
- Wall-clock: 5788s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
