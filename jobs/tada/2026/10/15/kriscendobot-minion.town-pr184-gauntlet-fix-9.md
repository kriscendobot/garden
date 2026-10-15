Fix round 9 for kriscendobot/minion.town PR #184 is pushed as `b4b70e2` on `fix/prod-probe-dispatch-backstop`, and CI is green (`ci-wait-merge.sh` returned rc 0). The bot token can't read the PR's check rollup, so the wrapper fell back to the Actions runs API. That shows one run, `test (typecheck + vitest)`, which succeeded. Commit statuses and non-Actions checks are not visible that way. The Lambda tests also pass locally, 42 of 42.

**Must-fix items applied from the panel-9 review:**
- **Duplicate dispatches** (corner-prober, saboteur, breaker, spec-keeper): two overlapping Lambda runs could both dispatch a probe. The backstop now runs one at a time:
  - The provisioner reserves a concurrency of one, turns off retries, and drops events older than 240 seconds.
  - After dispatching, the handler polls up to 8 times, 2 seconds apart, until GitHub lists the new run, and throws if it never shows up.
  - `DEPLOYMENT.md` now states the one case this doesn't cover: if the run is still unlisted after polling, the next check may dispatch again, and the workflow's concurrency group replaces the older pending run.
  - New tests: back-to-back invocations dispatch once, a slow listing is waited for, a never-listed run throws, and an earlier dispatch isn't mistaken for the new one.
- **Only the first 100 runs were read** (corner-prober): the handler now pages until a run counts, a page reaches past the 3.5-hour window, or the list ends. It stops with an error after 10 pages. I added the 101-run case the panel asked for, a stop-paging case and a too-many-pages case, and the property test now covers lists of up to 250 runs.
- **Invoke permission** (locksmith): the existing permission entry is no longer trusted. Every provision removes it and re-adds it, limited to EventBridge, this rule, and this AWS account.
- **Workflow contract** (prover): a new test reads `prod-probe.yml` and checks the `probe` job, its single `Probe production` step, and `--strict`. I broke the workflow four different ways and the test failed each time.
- **Token parser** (fast-checker): property tests now check that any token round-trips and that any malformed input gives exactly the fixed error, never the secret.
- **Smaller items:**
  - typist: the handler now takes an ignored event argument.
  - stylist: renamed `gh` to `githubRequest`, `fc` to `fastCheck`, the two `*Arb` names to `*Arbitrary`, and the retry counter `i` to `attempt`.
  - archivist: the docs now say "counts as evidence for the backstop", and only a finished `Probe production` step shows the probe ran.
  - orthographer: changed the test label to "canceled" and kept GitHub's `cancelled` value.
- **Summary comment** (scribe): posted on the PR (issuecomment-6196593626). It covers this round and round 8's commit `111051f`.

**Not done:**
- **Releaser's changeset:** declined. The repo has no `.changeset/` setup, and the packager and changeset-auditor jurors found nothing to record. The step operators must take (seeding the token) is already in `DEPLOYMENT.md`.
- **Coverage-auditor (comment-only):** it asked for a c8 coverage report; I didn't add one.

**Follow-ups:**
- The AWS changes (one-at-a-time concurrency, retry settings, the permission replacement) only take effect on the next run of `provision-ci-runner.sh`. This host has no AWS access, so I haven't run it.
- The driver should post panel-10 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3095476 cached reads)
- Output: 33335 tokens
- Cost: $2.1549312000000005
- Wall-clock: 1269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
