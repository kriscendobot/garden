# Fix round 3: endojs/endo-but-for-bots PR #1538 — done, CI green

I applied every finding from the deterministic prepass block and pushed one follow-up commit, `35f7e32f9`, to `endojs/endo-but-for-bots:build/daemon-git-clone`. CI is green: `ci-wait-merge.sh` returned rc 0 with 35 checks and 0 failures. The gauntlet's exact prepass command (`pre-push-gates.sh --no-auto-fix --probes-only --base-ref 54d3d2a…`) now passes. Its only output is the non-blocking pruner advisory.

**no-inline-import-jsdoc**
- `packages/git/src/native-git-backend.js`: added `@import { Writable } from 'node:stream'` to the top `@import` block and replaced the inline `import('node:stream').Writable` with `Writable`.
- `packages/sandbox/src/drivers/bwrap.js`: added `@import * as NodeFs from 'fs'` and changed the three `/proc` helper parameters (`readProcStat`, `waitForStopped`, `listChildPids`) from `typeof import('fs')` to `typeof NodeFs`.

**spell-out-identifiers**
- `packages/daemon/src/host.js`: renamed the `_args` stub parameters to `_arguments`.
- `packages/sandbox/src/drivers/bwrap.js`: renamed `err` to `error` in the launcher-kill `catch`.
- `packages/sandbox/test/bwrap.test.js`: renamed `args` to `spawnArguments` in the spawn stub.
- `packages/git/src/native-git-backend.js`: renamed `args` to `gitArguments` in `runRemoteGitAt` (including its input property), `gitClone`, `runRemoteGit`, `remoteFetch`, `remotePush`, `runGitRaw`, `streamGitBuffer` and `runGit`.

**Findings beyond the prepass block.** Re-running the probe with today's blocklist flagged more lines that the next panel would also fail on, so I fixed those too:
- Renamed `GIT_BASE_ARGS` to `GIT_BASE_ARGUMENTS` and `remoteProtocolArgs` to `remoteProtocolArguments`. Both are only used inside `native-git-backend.js`.
- In `packages/git/test/native-git-backend.test.js`, the two `runRemoteGitAt` calls had to change from `args:` to `gitArguments:` to match the renamed input property.
- In the same test, the fixture shell script used `head -c`, which the probe misreads as an identifier `c`. I swapped it for `dd if=/dev/zero bs=N count=1`, which writes the same bytes.

**Pruner advisory (host.js `makeGitRemotePolicyRecord` comment).** I kept it. It states that `provideGitRemote` and `provideGitClone` share one policy-record shape, and it carries the parameter's type.

**Local checks**
- eslint: 0 errors on all touched files.
- `yarn lint:types`: passes for the git and sandbox packages.
- bwrap tests: 43 passed.
- git backend tests: 15 passed. A first run had 5 failures from `execFile` timeouts while the host was busy; the baseline and a re-run both passed 15/15.

**Push mishap.** My first `safe-push-pr-head.sh` call used the wrong remote and created `build/daemon-git-clone` on the bot's own fork (`kriscendobot/endo-but-for-bots`). I pushed to the correct remote straight away and deleted that stray branch. The PR head was not affected.

**Follow-ups:** none. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (3800779 cached reads)
- Output: 16427 tokens
- Cost: $1.7914157999999998
- Wall-clock: 3495s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
