The pet-name-path sweep on endojs/endo-but-for-bots#1390 is done: head `065f1344ea` has every CI check green, including lint/types, tests on Node 22 and 24 for ubuntu and macOS, and coverage.

**What changed (6 commits, all pushed with `safe-push-pr-head.sh`):**
- **floot tests (`424c71d7ac`):** the test fakes stored and looked up names as plain strings, but callers now pass arrays. The fakes now key their stores by the joined path, which also fixes the `Unknown session "one"` failure. In machine-admin-setup, `provideGuest`, `storeLocator` and the `@main` worker check needed the same fix. All 195 floot tests pass.
- **agentry tests (`1f1ff6c309`):** the code-mode test fakes now accept paths.
- **cli (`fe0e8f6d4a`):** `resolve`, `send`/`reply` (the pet names in the message), `sendValue` and `endow` (worker and result names) now split names into paths. The `--as` agent name is now passed to `lookup` as one path instead of being spread into it, and the default worker is `['@node']`. This fixed the `cli/demo` CI failures.
- **Source and test fixes (`127738506c`):**
  - floot: the per-session git and code mounts, the machine-admin prompt examples, and dev-review's `@self` lookups.
  - sandbox: the scratch mount.
  - daemon test suite: `provideGit`, `provideSubMount` and tree-fixture names (these caused 19 CI failures).
  - chat: a type cast that broke the type check.
- **sandbox (`06177feb92`):** the per-slice scratch mount and the `SandboxPowers` type, to satisfy the type check.
- **daemon test (`065f1344ea`):** undid an earlier automated rewrite that wrongly wrapped `EndoRegistry.lookup(name, version)`, which takes a package name rather than a pet-name path.

**Also done:** I rewrote the PR body's status and testing sections to say the sweep is complete and CI is green, and posted the completion summary comment (issuecomment-5911837283).

**Not done locally:** step 3's daemon-suite run (the `cp -al` short-path copy) was skipped. The daemon can't start from this worktree's long path, so CI's daemon run is the evidence. A few local failures are from this machine rather than the change:
- The daemon-spawning tests in cli, host-shell and endo-fs-exec fail because of the long socket path.
- One agentry conflict-rebase test fails because of the global `rerere` git setting; it passes in CI.
- One agent-tools git-flow test fails because the repository-identity check trips here.

**Follow-ups:**
- #1343 (the endowment value side) is still open; rebase this branch over it if it lands first.
- The PR stays draft for the gauntlet job that's already running against it.
- The mount/`@endo/platform` filesystem interface still accepts either a string or an array. It's out of scope here and is noted as such in the PR body.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 10 tokens (845007 cached reads)
- Output: 3132 tokens
- Cost: $4.759487600000001 (1 engagement(s) unpriced)
- Wall-clock: 7242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
