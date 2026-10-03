## Gauntlet fix round 4: kriscendobot/minion.town PR #145

I applied every must-fix item from the round-4 panel and pushed them as `37b05e8` (fast-forward from `09743bb`). CI on the new head is green: `ci-wait-merge` returned rc 0, with 3 of 3 checks passing and none failed.

**What changed:**

- **Prune race (saboteur, breaker, wire-watcher):** the minter's prune no longer deletes a busy runner or one minted in the last 15 minutes. It reads the age from the timestamp at the end of the runner's name. This protects a runner that has been minted but has not connected yet, whether it belongs to this host or another one. A new test covers a young runner, a busy runner, an orphaned runner and the exact cutoff.
- **Private-repo check at every mint (breaker, wire-watcher):** the minter looks up the repo before every mint and refuses unless it is private. Tests cover a public repo, a missing field, a non-boolean value and an empty response.
- **Secret leaking into errors (saboteur):** a malformed secret now fails with `secret <id> is not valid JSON` instead of an error that quotes the start of the token. The parsing moved into a separate `tokenFromSecret` function, which has its own test.
- **Runner loop (saboteur, assessor):**
  - If the runner exits within 30 seconds, the loop waits 60 seconds before minting again.
  - The background prune now detects an error thrown inside the Lambda, the same way mint already did, instead of logging it as a clean run.
- **Gaps in the cleanup between jobs (breaker):**
  - It now also clears the runner user's crontab, `/run/lock`, `/dev/mqueue`, any docker swarm state and all docker plugins.
  - It used to skip anything *named* like systemd's private temp directories, so a job could hide files there. Now it only skips root-owned entries that existed before the first job of this boot, plus systemd's own temp directories for the current boot.
  - The selftest workflow now plants decoys a job could use to survive the cleanup: a fake systemd temp directory, a `/run/lock` file and a crontab entry.
- **Teardown overrides (breaker):** the teardown script now accepts the same name overrides as the provision script (function, roles, secret, zone, hostname).
- **Naming (stylist):** renamed `zipdir` to `zip_directory`.
- **DEPLOYMENT.md trust note (breaker, wire-watcher):**
  - It now names the third-party code that runs as root through docker: `npm ci`, the build and the Endo checkout.
  - It says the runner is ephemeral only against non-malicious jobs.
  - It describes how a malicious job could get past that: tampering with `/opt/actions-runner`, or minting a runner and running it on another machine to capture later jobs.
- **Wire-watcher test request:** added tests for non-string `repo` and `op` values.

**Accounting comment (scribe):** I posted https://github.com/kriscendobot/minion.town/pull/145#issuecomment-5966346375. It lists which of round 3's and round 4's must-fix items were fixed and how, and names two that were declined, with reasons:
- The breaker's "spare only what systemd created" check is implemented as a boot-time snapshot plus a boot-id check, not true provenance. A job that is root through docker can still forge a spared entry, and the trust note already puts that case outside the cleanup's guarantee.
- The wire-watcher's note on where the release digest's trust comes from needed no change.

**Verification:** the Lambda tests pass locally (9 of 9), `bash -n` passes on the changed scripts, the workflow YAML parses, and CI is green.

**Follow-ups:** none from this stage; the driver re-posts the panel for round 5. The new cleanup steps and selftest decoys only get exercised on the real ci.minion.town host. Running the selftest workflow by hand there would confirm them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2408254 cached reads)
- Output: 23453 tokens
- Cost: $1.7707028000000005
- Wall-clock: 886s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
