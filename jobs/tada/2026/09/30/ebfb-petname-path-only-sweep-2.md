---
handed-off: ebfb-petname-path-only-sweep-3
deliverable-complete: false
---
I didn't finish this job. CI isn't green yet, and the PR body update and completion comment aren't done. I pushed two more commits to PR #1390 (head now `3eb4c48bc4`) and handed the rest to a new job, `ebfb-petname-path-only-sweep-3`.

**Real daemon bug fixed:** when no worker was named, `makeUnconfined` in `packages/daemon/src/host.js` fell back to the plain string `'@node'`. The daemon now rejects plain strings as names (`namePathFrom`), so every call that omitted the worker would have failed. It now defaults to `['@node']`.

**Commit `e4f551033e`: remaining callers that passed a plain string**
- **Single names in variables:** wrapped as `[x]` at `lookup` and `storeValue` calls in:
  - fae (`endo-skill.js`, `credentials.js`, `tool-makers.js`)
  - `jaine/agent.js`
  - floot (7 sites in `agent.js`, plus `machine-admin-setup.js`, `container-mounts.js`, `dev-review.js`)
  - `lal/agent.js`
  - the codex-sandbox audit journal
  - the network listen-address name in `tcp-netstring.js` and `ocapn.js`
- **Values that are user or model input:** split on `/` instead. This covers the `lal` lookup tool, the fae store tool, and the file-explorer dialog names.
- **agentry credential policy:** its type is `string | string[]`, so a string is wrapped and an array passes through.
- **`claude-session-provisioner`:** it was spreading the path into `lookup(...clientPath)`; it now passes `lookup(clientPath)`.
- **Worker and result names given as plain strings to `makeUnconfined`:** fixed in space-file-explorer, `platform` fs `attach`/`mkmem` and the module doc comments, `setup-iroh.js` and its test, `endo.test.js`, and the `endo-fs-exec` test.
- **Left alone on purpose:** `remove(name)` and `has(name)`. They take the path as separate string arguments, so a plain string is still valid there.

**Commit `3eb4c48bc4`: two failures from the first CI run**
- **`fae/test/subagent-host.test.js`:** 7 tests failed because the test's fake host stored names as plain strings, so it missed the arrays the code now passes. I updated the fake.
- **`reminder/test/plugin.test.js`:** failed on macOS for the same reason, and I fixed its fake the same way.

Both suites pass locally, and `setup-iroh.test.js` passes too. `tsc` shows no errors in daemon, floot, fae, space-file-explorer, platform, agentry, claude-sandbox, codex-sandbox and lal. ESLint on the changed files reports no errors when run per package. I didn't wait for CI to rerun on `3eb4c48bc4`.

**Question to the maintainer:** I asked whether the mount / `@endo/platform` file-system surface should follow the same arrays-only rule. That was deliberately left out of #1390. It doesn't block anything.

**What `ebfb-petname-path-only-sweep-3` now owns:**
1. Get CI green on `3eb4c48bc4`. Likely causes of what's left: other test fakes that compare plain-string names, or plain-string worker arguments to `provideWorker`, `makeBundle` or `evaluate`.
2. Run the daemon suite locally from a short path.
3. Audit and revert codemod edits to non-daemon receivers.
4. Run the pre-push gates, update the PR body's status section, and post the completion summary comment.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (5382552 cached reads)
- Output: 23273 tokens
- Cost: $2.2845783999999996
- Wall-clock: 906s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
