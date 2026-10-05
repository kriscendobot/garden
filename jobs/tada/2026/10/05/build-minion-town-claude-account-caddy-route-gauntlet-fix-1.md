I applied all three must-fix items from the round-1 panel to kriscendobot/minion.town PR #159 and pushed the follow-up commit `2fb62e9`. CI is green: `ci-wait-merge` returned rc 0 with 3 of 3 checks passing. The fixed probe has not run against the live box yet.

**Must-fix items:**
- **migrator (one-layer deploy contract):** `deploy-caddy.sh` now skips the live `/account/claude` probe when oauth2-proxy does not answer on `:4180`, logging the skip. A `deploy_target: caddy` run therefore no longer depends on the other layers being up. The app on `:3000` was never needed, because the unauthenticated redirect comes from the login gate. The check that the reloaded config contains the route still always runs. I added a note on this to `DEPLOYMENT.md`.
- **fast-checker (tie-break never tested):** a new test makes overlapping prefixes compete. `/ocapn-daemon` paths must go to the `/ocapn-daemon*` route (:8931) and `/ocapn/session` to `/ocapn*` (:8930). I also added a fast-check property test for `patternMatches`: exact patterns match only exactly, `*` patterns match by prefix, and case is ignored.
- **pruner (too much prose):** I cut the bug-discovery story from the Caddyfile comment, shortened the test-file header, and rewrote the PR body without the per-file tour and test tally.

**Also fixed (comment-only notes):**
- **assessor:** the route check on the `caddy adapt` output now strips whitespace before matching, so a formatting change won't break it. I kept `grep` rather than switching to `jq`, because I couldn't confirm `jq` is installed on the box.
- **typist:** replaced the U+2026 ellipses in the test comments with ASCII `...`.

**Verification:**
- The new test file passes locally (10/10) and `tsc --noEmit` is clean.
- I checked the shell syntax of the rendered remote script with `bash -n`.
- I did not re-run the full suite or real-Caddy tests locally; CI ran the full vitest suite and typecheck.
- The test file still fails `prettier --check`, but it already did before this change and CI does not enforce prettier.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-caddy-route-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1004310 cached reads)
- Output: 8903 tokens
- Cost: $0.8888020000000001
- Wall-clock: 408s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
