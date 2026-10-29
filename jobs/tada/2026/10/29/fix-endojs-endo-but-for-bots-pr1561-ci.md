# PR #1561 fix-CI report: CI is still red, but none of the failures come from this PR

I didn't push anything to PR #1561. Its own tests pass. The remaining failures are in the CI runner environment and need PR #1566 to land; nothing in this PR can fix them.

**Failing checks on head `e33aaa5f61`:**
- **`test (24.x, macos-15)`:** a flake. A test in the `@endo/floot` package hit an unhandled `ClientDestroyedError` (read-only `message`) from undici. This PR doesn't touch floot. I re-ran the job and it passed, 246/246 tasks.
- **`build`:** the dependency-graph script fails with `tred: command not found` because the runner image has no graphviz. This happens on unrelated PRs too.
- **`sandbox-drivers`, the `test` jobs on ubuntu-latest (Node 22 and 24), and both `cover` jobs:** the `@endo/sandbox` bwrap tests fail on the new Ubuntu runner (`ulimit: Illegal option -u` and the "parent death" test). Because turbo runs with `--concurrency=1`, that failure stopped the Linux runs before this PR's own package tests (`@endo/exo-agent-factory`) ever ran.

**Checks I ran locally on Node 22, in an isolated project checkout:**
- `ava`: 28/28 tests pass, including the four restart tests against a real daemon.
- `tsc` and `eslint` are clean, apart from one existing `@ts-nocheck` warning.
- `yarn install` leaves `yarn.lock` unchanged.

To run the daemon tests I replaced a `better_sqlite3.node` binary in my checkout's `node_modules` with one built for Node 22. That was a local setup fix only; nothing was committed.

**What I posted and recorded:**
- A triage comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1561#issuecomment-6491036127
- An update to the existing memory note on these CI failures: PR #1566 is the fix, the concurrency=1 abort hides later tests, and the floot macOS failure is a flake.

**Follow-ups:**
- PR #1566 (installs graphviz and makes the bwrap tests portable) is green but still a draft. It needs the maintainer to un-draft and merge it.
- Once #1566 is on `llm`, the stack (`build/exo-agent-factory-core` → #1561) needs a weave, then a CI re-run, to go green. I didn't post that weave job because it can't run until #1566 lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1561-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3255057 cached reads)
- Output: 13241 tokens
- Cost: $1.6255114000000004
- Wall-clock: 3724s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
