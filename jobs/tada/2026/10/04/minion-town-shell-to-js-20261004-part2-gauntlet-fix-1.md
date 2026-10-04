Fix round 1 for kriscendobot/minion.town PR #152 is pushed: commit `f30a7ed` on `chore/javascript-only-scripts-part-2a`, and CI is green (3 of 3 checks).

**Must-fix items:**
- **Ctrl-C and SIGTERM were ignored** (saboteur, breaker): `onExit` no longer adds SIGINT/SIGTERM listeners. Those listeners could never run in these synchronous scripts, and having them turned off Node's normal exit on those signals. `run` and the SSM poller now treat a child killed by a signal as fatal even when `allowFailure` is set. They exit with 128 + the signal number, so the exit hooks, including the S3 secret cleanup, still run. The trade-off: a signal sent only to the parent process, or a Ctrl-C during a `sleep`, now ends the script at once and skips those hooks.
- **Stale `deploy-cognito-*.sh` glob** (integrator): changed to `deploy-cognito-*.js` in `DEPLOYMENT.md`.

**Should-fix items also applied:**
- **Injected EnvironmentFile lines** (saboteur, breaker, wire-watcher): `renderEnvironmentFile` now rejects values that aren't strings or that contain a carriage return, newline, NUL or trailing backslash. The Stripe key checks now require the whole value to match (`^sk_test_[A-Za-z0-9]+$` and the same for the other two keys), not just the prefix.
- **JSON errors** (saboteur): a new `parseJson(text, source)` in `lib/common.js` and `readSecretJson` in `lib/artifacts.js` replace bare `JSON.parse`, so a parse error now names the secret or client it came from. The overly wide `try` in `deploy-npm-registry-secret.js` now covers only the render step and its error names the secret.
- **Zip ordering**: zip entries now sort by plain code-unit order rather than `localeCompare`, so the order no longer depends on the host's locale.
- **README**: the `deploy/aws/README.md` table describes `lib/common.js` correctly and has rows for `artifacts.js`, `cognito.js` and `zip.js`.
- **Spelling**: honour/honoured/behavioural/honours are now American in the converted scripts and the test.
- **Tests**: new tests cover the signal handling, the rejected EnvironmentFile values (newline, carriage return, NUL, trailing backslash, non-string) and the Stripe bypass cases. The deploy-script tests pass (22/22) and typecheck is clean.

One test outside this change, `test/git-remote/capability.test.ts`'s "propagates a git failure" case, fails on my machine. Remote CI is green, so it looks like a local-environment issue.

**Not done:**
- The PR title and body edits that integrator #3 and pruner asked for (drop "(2a)", shorten the incident write-up). The title and body still read as part of a series.
- Comment-only suggestions: verifying the Lambda `CodeSha256` before attaching it, keeping secrets out of process arguments, the SIGHUP cleanup, and splitting the `AWS`-override change into its own commit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1450884 cached reads)
- Output: 14073 tokens
- Cost: $1.2345328
- Wall-clock: 468s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
