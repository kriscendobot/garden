**Fix round 13 for kriscendobot/minion.town PR #184: all six must-fix items are done, the fixes are pushed, and CI is green on `2e7f126`.**

I pushed four follow-up commits (`8b20ee3`..`2e7f126`) onto `fix/prod-probe-dispatch-backstop` with `safe-push-pr-head.sh`, which only adds commits on top.

- **stylist** (`8b20ee3`): `repo`/`REPO` are now `repository`/`REPOSITORY` in the backstop handler, its result field, its environment variable, and its test. The provisioner now sets the `REPOSITORY` environment variable. I did not use `arguments` for the rest parameter as asked: it is a reserved name in a module and would not run. It is `requestArguments` instead.
- **saboteur** (`d6d516e`): `tokenFromSecret` now refuses any token that is not visible ASCII, including CR/LF. The error names only the secret id. Regression tests cover CR/LF and similar cases, plus a property over all JavaScript strings.
- **prover** (`d94fe05`): a new `deploy/aws/ci-runner/test/provision-ci-runner.test.mjs` runs the real provisioning script against fake `aws` and `gh` commands that record every call. It covers both the create and the update path. It checks:
  - the Lambda package, handler, environment and role policy;
  - the three-hour EventBridge rule and zero retries;
  - the rule's Lambda target;
  - the invoke permission, scoped to the rule and the account.

  Taking the rule restriction out of the script makes both cases fail. CI runs this test next to the Lambda tests, in a step renamed "Test ci-runner Lambdas and provisioner".
- **breaker** (`2e7f126`): I narrowed the documented guarantee rather than adding stored event IDs. The provisioner comment and DEPLOYMENT.md now say each firing dispatches at least once. A rare duplicate run is absorbed the same way as the existing cron duplicate.
- **surfacer** (`2e7f126`): the probe dispatch token is no longer in DEPLOYMENT.md's "must create first" table. It is now described as optional at provision time: the script warns, and every dispatch fails until the token is seeded.
- **scribe**: I posted a top-level summary for this round's commits that includes local and CI results ([issuecomment-6209227122](https://github.com/kriscendobot/minion.town/pull/184#issuecomment-6209227122)). The round-12 comment the scribe flagged was not edited.
- **Optional test suggestions (corner-prober, fast-checker)**: new tests check that every kind of event gives the same single `main` dispatch, including a randomized check, and that the GitHub client returns nothing on a 204 and parses a JSON body.
- **Not changed**: spec-keeper's comment-only `Reflect.apply` suggestion. The other in-tree `fetch` callers don't do it either.

**Verification:** locally, 25 of 25 tests pass and `bash -n` on the provisioning script is clean. `ci-wait-merge.sh` returned 0: `test (typecheck + vitest)` succeeded on `2e7f126`. I ran the CI wait as two bounded foreground runs, about 9 minutes each, rather than one 3600-second wait; the first stopped on rc 4 while the run sat queued for about 13 minutes.

**Follow-ups:** none. Panel-14 runs next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-13.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2219611 cached reads)
- Output: 20358 tokens
- Cost: $1.5616742000000001
- Wall-clock: 1069s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
