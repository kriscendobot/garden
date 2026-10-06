Fix round 5 for kriscendobot/minion.town#163 is pushed as `e40b9f4`, and CI is green on it: 3 of 3 checks passed (`ci-wait-merge.sh` rc 0).

**Must-fix items from the round 5 review:**
- **breaker:** `deploy-caddy.sh` now takes the gate-token lock before its first config write. It holds the lock through the prune, `caddy validate`, `systemctl reload` and `caddy_environment_ensure`. A secret script's restart can no longer start caddy on a half-written or unvalidated config, or collide with the reload. The lock logic is in a new function, `caddy_environment_lock`, which holds it until the shell exits. `caddy_environment_ensure` skips taking it again when the caller already holds it.
- **pruner:** I shortened the PR body's "Operator-visible behavior" and "Tests" sections to short summaries.

**Should-fix items from comment-only seats, also done:**
- **locksmith:** the lock moved from `/run/lock`, which any local user can write to, to `/run/minion-town/caddy-environment.lock`. Its directory is created 0700 and must be owned by the caller.
- **spec-keeper:** the `refreshing` unit state is now checked along with `active`, `activating` and `reloading`.
- **stylist:** renamed the local `environ` to `environ_path`.
- **typist:** `{$…}` is now written `{$...}` in `DEPLOYMENT.md` and the PR body.
- **scribe:** posted a round summary comment with the verification status (issuecomment-6007679430). It also adds the round 4 CI link that the earlier summary left out.

**Tests:** I added 5 tests: waiting for a deploy that holds the lock, not re-taking a held lock, the private lock directory, the `refreshing` state, and the lock coming before the writes and `caddy validate` in `deploy-caddy.sh`. The existing wiring test was updated for the new order. Local vitest passes 49 of 49 tests across the two caddy test files.

**Not done (follow-ups):**
- **spec-keeper #1** (restate the incident cause): `DEPLOYMENT.md` already names the reload client and a hand-run `caddy reload` as the processes that fill in the parse-time form, so I made no change.
- **corner-prober and fast-checker:** their suggested extra boundary and property tests are left for later.
- **coverage-auditor:** no coverage report exists for this repo, so line coverage of the new code is still unchecked.
- **Formatting:** `DEPLOYMENT.md` already had Prettier warnings before this round; I didn't reformat it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-20261005-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1995685 cached reads)
- Output: 14414 tokens
- Cost: $1.368665
- Wall-clock: 592s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
