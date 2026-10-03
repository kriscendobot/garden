## Fix round 4: endojs/endo-but-for-bots PR #1390 (gauntlet `ebfb-petname-path-only-gauntlet`)

I applied the panel-4 must-fix items as seven follow-up commits and pushed them with `safe-push-pr-head.sh`, moving the head from `18d8207af1` to `c039e37251`. CI is green: `ci-wait-merge.sh` returned rc 0, 33 checks, 0 failed. Before that, the first wait returned rc 3: only `test (22.x, macos-15)` failed, on `daemon-teardown › an orphaned daemon shuts itself down`. That is the same macOS flake fix-3 hit, and this PR doesn't touch teardown code, so I re-ran only that job and it passed.

**What changed:**
- **evaluate callers passed bare strings (assessor, must-fix):**
  - lal `evaluate` now wraps each `edgeNames` entry as a one-segment path (`95fc12c3b8`).
  - fae `makeEvaluateTool` wraps the worker name, each endowment pet name and the result name, all hardened (`50f74b62d5`, new `packages/fae/test/evaluate-tool.test.js`).
  - Both tests run the calls through the daemon's real `namePathFrom`.
- **Nested channel mention still refused (breaker, must-fix):** the mention notification now uses the channel token's last segment as its edge name, through a new `mentionChannelEdgeName`. `chat.js` uses it for the `channel-reply-info` hint too (`a716c142c4`). The test no longer expects `feature/foo` as an edge name and now checks that no edge name contains `/`. The loop index is renamed `recapIndex`.
- **Unhardened path (warden, should-fix):** agent-tools `toPetNamePath` now returns a hardened array, with a test that it is frozen (`4c019e0bac`).
- **stageTree checked too late (breaker, should-fix):** `stageTree` now checks the scratch leaf with `petNamePathFrom` before it touches the tree, with a new daemon test (`ed50b50ba7`). The same commit has the spec-keeper doc fixes: the injectivity reasoning is spelled out, the property-test title matches what it checks, and the type-guards header comment is corrected.
- **Changeset (archivist, curator, migrator):** it now covers the chat edge naming, the `-author-N` numbering for repeated edge names, and the new `namePathLabel` export (`c733e30bf8`).
  - **I disagreed with the migrator** and kept the four 0.x packages at **minor** rather than major. Below 1.0, a minor bump is already the breaking-change bump, and major would move them to 1.0.0. The changeset now says this.
- **Bare-string examples:** the lal system prompt, the lal `inspect` message and the platform `layer-module` example now use arrays (`c039e37251`).
- **Local checks:** the touched unit suites pass under ava (chat, lal, fae, agent-tools, daemon `pet-name`), and eslint shows no new errors. The daemon's integration tests in `endo.test.js` can't run on this host because its better-sqlite3 build doesn't match Node 22. The CI Ubuntu legs ran them and passed.
- I posted a summary comment on the PR (issuecomment-5968488248). Nothing changed in the garden repo.

**Not done, likely to come up again at panel-5:**
- **Integrator must-fix: regroup the 85-commit history.** That means rewriting history, so I left it for a retcon pass before un-draft rather than doing it inside a follow-up-commit fix round. The driver or the maintainer should decide whether to post a `retcon #1390`.
- **Procurer must-fix: unknown.** Its detail was cut when the review was truncated, and the panel worktree is gone, so I couldn't act on it. Panel-5 should recover it.
- **Deferred should-fix items:** one shared helper for splitting typed names on `/` in the UI (purist, integrator), and a test that sends a bare string to every `NamePathArgumentShape` method (locksmith, saboteur, wire-watcher).
- The macOS `daemon-teardown` orphaned-daemon test failed again on this PR and only cleared on a re-run.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (7429618 cached reads)
- Output: 28122 tokens
- Cost: $3.178755600000001
- Wall-clock: 6043s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
