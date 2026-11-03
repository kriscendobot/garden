**Clean stage for #1643: coverage is done and pushed, but CI was still pending at the 3600s deadline, and two checks are already red.** I expect the re-posted stage to end at rc 3 (RED) unless those two are fixed or rerun green.

**Coverage pass (`packages/skills`, head now `a4bc0f6c7`)**

| File | Lines before | Lines after | Branches before | Branches after |
| --- | --- | --- | --- | --- |
| `load.js` | 93.22% | 100% | 85.71% | 100% |
| `node.js` | 96.25% | 100% | 87.09% | 100% |
| `parse.js` | 99.54% | 100% | 96.29% | 100% |
| `prompt.js` | 100% | 100% | 100% | 100% |

- **Tests:** the suite went from 17 to 23 tests and passed 8 runs in a row. The new tests cover:
  - an oversized `SKILL.md`
  - sorting across sources
  - frontmatter lines that aren't keys
  - unreadable directories and files
  - a working directory that can't be examined
  - home as the working directory
- **Lint:** `yarn lint` reports 0 errors and 2 warnings, one of them in `src/node.js` and one in `test/prompt.test.js`. Neither line was changed here. Prettier passes.
- **Platform arms:** the package has none, so no platform-specific tests are needed.

**Commits pushed with `safe-push-pr-head.sh`**
- `226424834` `fix(skills)`: the coverage tests exposed a real bug. Running from the home directory listed `~/.claude/skills` twice, so each skill there loaded twice and warned that it overrode itself. Each directory is now listed once, and this commit also adds the tests. This goes slightly beyond a plain coverage pass, so the panel should look at it.
- `a4bc0f6c7` `chore(skills)`: removes the sort comparator's equal-names arm, which can't run because names come from a `Map`.

**CI on `a4bc0f6c7`**
`ci-wait-merge.sh` returned rc 4 at the deadline; I ran it in consecutive bounded polls totaling 3600s. 34 of 36 checks had finished; `test (22.x, macos-15)` and `test (24.x, macos-15)` were still running.
- **`test-xs` (red):** this is the known Node 26 failure, where `.node-version` `lts/*` now resolves to 26 and `sesNode/module` flips on `ThrowTypeError/intrinsic-metadata.js`. It isn't caused by this diff, `llm` has no fix yet, and it needs the maintainer's decision.
- **`cover (22.x, ubuntu-latest)` (red):** `@endo/sandbox` failed with "process group 13857 survived bounded cleanup" in the `bwrap` test `timeout and repeated cancellation reap process groups`. This PR doesn't touch that package, and the same job passed on the previous head, so it looks like a flake. I didn't rerun it because the run was still in progress and a rerun can only start once it finishes.
- **Earlier macOS failure:** on the previous head `e97d478e0`, `test (24.x, macos-15)` failed in `@endo/floot#test`. This PR doesn't touch that package either, but I didn't dig into the cause. Watch for it when the current macOS jobs finish.

This is rc 4, not rc 3, so I'm not signaling a failure and the driver can re-post the stage. The coverage work won't need redoing; the next claimant only has to watch CI at this head.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1643-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 42 tokens (1715047 cached reads)
- Output: 22153 tokens
- Cost: $1.5406933999999999 (1 engagement(s) unpriced)
- Wall-clock: 4559s

<!-- garden-usage-end -->
