I applied the round-3 panel fixes to PR #210 (kriscendobot/minion.town) and pushed them to the PR's branch. The latest panel verdict was review `5597026384` ("Must-fix before merge"); there was no deterministic pre-pass block. CI is green: `ci-wait-merge.sh --no-merge` returned 0 on head `993aa54`, where the only workflow, "test (typecheck + vitest)", succeeded.

**Commits pushed** with `safe-push-pr-head.sh`, moving the head from `551914e` to `993aa54`:
- `950c35b` refactor(guest): renames "agent activity" to "guest agent activity" throughout, because only the guest seams are stamped. It also renames `Dynamo*` identifiers to `DynamoDatabase*`.
- `63898f7` fix(guest): the code fixes and new tests listed below.
- `993aa54` docs(deploy): adds a "Guest agent activity" section to DEPLOYMENT.md.

**Must-fix items addressed**
- **integrator:** the rename covers modules, types, the reserved partition (now `urn:minion-town:guest-agent-activity`) and the key domain. I also changed the PR title to "record every guest agent's last-active time".
- **saboteur, spec-keeper, corner-prober:** last-active times are now stored as epoch milliseconds and compared as numbers in both the in-memory and DynamoDB stores. Before, ISO strings sorted a year-10000 date before year 9999. Tests cover that boundary in both stores, and invalid dates are refused.
- **assessor:** a store write that hasn't settled after 30 seconds is abandoned and reported, and the next use retries it. `flush()` now always settles. A fake-timer test covers a write that never returns.
- **locksmith, breaker, wire-watcher:** the app role's DynamoDB policy now denies reads, whole-row replacement, queries and any other-attribute update on the activity rows, so the app can only advance a timestamp. A new test (`test/guest-agent-activity-policy.test.ts`) checks the policy as written in the deploy script.
  - Breaker's second point is not fixed, only stated honestly. The app role's `PutItem` can still replace a whole account row, including its role. That gap predates this PR, so I corrected the script comment and DEPLOYMENT.md, which claimed IAM prevents it. The server code only ever creates new accounts.
- **prover:** a new test (`test/guest-agent-activity-http-dynamodb.test.ts`) starts the app with `ACCOUNT_STORE=dynamodb` and checks that activity is written through DynamoDB.
- **migrator:** DEPLOYMENT.md now says to re-run `deploy-accounts-store.sh` before the first automatic deploy of this change, because CD never sets up IAM permissions. It also covers schema, retention, ownership and an acceptance check, which answers the archivist and integrator documentation requests.
- **benchmarker, scribe, fast-checker:** I posted a summary comment for the new head (issuecomment-6311914507). It explains why I didn't run a benchmark: the claims are deterministic write counts and fixed memory bounds, which tests already assert, not speed claims. I added two property tests: last-active times end up identical in both stores for any write order, and identity-cache lookups match an LRU model.

**Should-fix items also applied:** clearer names in tests, the "equal or later" comment, rejecting non-positive or non-finite bounds, recovering when the clock steps backward, caching the hashed key instead of the bearer identifier, a frozen write-only store facet, ephemeral ports in tests, narrower `catch` blocks, and removing the comment the pruner flagged.

**Not applied, left for the maintainer:**
- purist: replace `node:crypto` with `@endo/sha256`, which needs a dependency decision.
- spec-keeper: call injected methods via captured `Reflect.apply`.
- coverage-auditor: there is no c8 coverage report for this package.

**Local checks:** typecheck passes and the 37 activity tests pass. In the full local run, 2 tests under `test/git-remote/*` failed. This diff doesn't touch those files, and CI passed. I didn't confirm the cause, but they look like local git-setup problems.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr210-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4447626 cached reads)
- Output: 39978 tokens
- Cost: $2.6653011999999996
- Wall-clock: 1275s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
