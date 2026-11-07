Clean stage done for kriscendobot/minion.town#254: I added the missing tests and CI is green on the new head (7/7 checks).

**Coverage.** CI was already green when I started, but several new branches had no tests, so I didn't treat it as a no-op. I pushed one tests-only commit, `083da5d`, through `safe-push-pr-head.sh` (fast-forward from `d90975d`). It covers:
- **`takeRecoveryOutcome` / `rememberRecoveryOutcome`:**
  - only known provider labels are kept (`SIWE` becomes `Ethereum`); unknown or tampered ones are dropped and get the generic text;
  - a malformed or wrong-kind stored record is removed and ignored;
  - storage that throws is tolerated.
- **`submitWaitlist`:** a 5xx reply and a network failure both get the "temporarily unavailable" message, and the server's own error text isn't shown.
- **Recovery route:** a blank `x-auth-request-provider` header leaves `identityProvider` out of the 404 body.

**Dead code.** I found none; the old `say('waitlist-status', …)` failure messages were replaced, not left behind.

**Local checks.** The two touched test files pass (62/62) and `npm run typecheck` is clean. The full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("exited 128"). This PR doesn't touch that file; I believe it's a sandbox artifact, since the `test` check, which runs the same suite, passed in CI.

**CI.** On the first run, `gate (firefox)` failed: two `test/agent-ui-browser.test.ts` tests timed out at 5000ms. That file isn't part of this PR, and the same gate passed on the previous head with identical app code, so I reran only the failed job. Attempt 2 passed, and `ci-wait-merge.sh --no-merge` then returned rc 0 (GREEN).

**Infra follow-up.** In this sandbox the bare clone `worktrees/kriscendobot-minion.town.git` and `~/.cache/gh` are read-only. That made `ensure-project-worktree.sh` fail ("Read-only file system") and `gh run view --log` fail too. I worked in a throwaway clone under `$TMPDIR` and pointed `XDG_CACHE_HOME` at `$TMPDIR`. It looks like the same read-only mount problem as the earlier host `tmpexec` outage, so other gardener jobs will probably hit it. Separately, when the worktree script first failed, I ran a `git log` and a `git fetch` in the garden root by mistake; the fetch errored out and changed nothing.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1968401 cached reads)
- Output: 8927 tokens
- Cost: $1.1672602000000003
- Wall-clock: 2195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
