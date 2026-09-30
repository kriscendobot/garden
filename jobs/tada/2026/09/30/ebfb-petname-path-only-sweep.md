---
handed-off: ebfb-petname-path-only-sweep-2
deliverable-complete: false
---
I didn't finish the sweep on endojs/endo-but-for-bots#1390. I fixed the errors CI reported and handed the rest to a successor job, `ebfb-petname-path-only-sweep-2`, which is posted.

**What I found:** the latest CI run on the head (`e1f3522a3f`) was red. Lint failed with about 30 type errors, and the test jobs failed on `packages/fetch` `plugin.test.js`.

**What I pushed** (commit `b7c33a65d1` on `build/pet-name-path-only`):
- **Chat UI packages** (chat, space-chat, spaces-util): calls that send, reply, edit, endow or evaluate now give the daemon pet-name paths instead of bare strings, splitting the UI's slash-separated strings. The `LookupHub` type in `name-hub.js` now accepts only a path.
- **space-file-explorer:** the earlier codemod had broken `powersName: '@agent'` into an undefined `powersName` shorthand. I restored it as `['@agent']` and made the result name a path.
- **agent-tools `makeDaemonEvaluate`:** pet names and the result name are converted to paths before they reach the daemon, and its test is updated.
- **fetch, a real bug:** `lookupOptional` passed a bare string. The daemon now rejects that, and the `try/catch` around it quietly treated the rejection as "no policy authority granted". It now passes `[name]`, and the fetch tests pass (11/11).
- **claude-sandbox `setup-hosted.js` and the daemon `git-authority-types.test-d.ts`** now pass paths.

**Checks:** locally `tsc` is clean for daemon (which covers agentry), chat, claude-sandbox and agent-tools. The agent-tools and fetch tests pass, and eslint shows only warnings that were already there. I did not re-run CI or the full daemon test suite after pushing.

**Left for the successor job** (the job body has the full list with file and line numbers):
1. About 35 more places still pass a pet name to the daemon as a bare string variable. Where a value's type is `any`, `tsc` can't catch these. They include fae `endo-skill.js`, floot `agent.js`, lal, codex-sandbox `audit-journal.js`, and agentry `code-mode-provision-host.js`. There is also a `lookup(...clientPath)` spread in claude-sandbox that should pass the array. Any `try/catch` around these may hide the rejection, as the fetch one did.
2. Re-run CI and the daemon suite. Suspects from the first hand-off include `channel.test.js`, `code-mode-provisioning-*`, `content-store-gc*`, `directory-read-only-view` and `debugger-captp`.
3. Check the codemod's changes outside the daemon for wrapped arguments that aren't pet names, and revert those.
4. Ask the maintainer whether the mount / `@endo/platform` fs paths follow the same rule. That question hasn't been sent yet.
5. Then run the pre-push gates, update the PR body's status section, and post the completion summary comment.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 98 tokens (3572429 cached reads)
- Output: 17602 tokens
- Cost: $1.7411737999999999 (1 engagement(s) unpriced)
- Wall-clock: 7464s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
