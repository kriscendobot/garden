I applied all six must-fix items from the round-3 panel on PR #184 in one commit, pushed it, and CI is green: `ci-wait-merge.sh` returned rc 0 with 3/3 checks passing (test, Claude harness amd64 and arm64).

**How each item was handled:**
1. **Repeated dispatches with no in-flight guard:** I documented the accepted bound rather than adding a guard, following the panel's own steer. The Lambda keeps no state, so a call made before GitHub lists the run it just dispatched will dispatch again. On the five-minute timer that only happens if the listing lags by minutes. A hostile caller could queue one probe per call, but the runner runs them one at a time, and that caller can already mint runners. This is written up in `DEPLOYMENT.md` § Dispatch backstop and in a code comment in `lambda/index.mjs`.
2. **Freshness only checks `created_at`:** I accepted this as a known limitation instead of reworking the check, as the decomplector advised. Rounds 1–3 all patched this same check. The new limitations note lists the cases that keep the backstop quiet for up to 3.5 hours: a manual non-strict run, a `workflow_run` after a deploy, and a queued run. It points to the existing alarms as the cover for that gap.
3. **Lambda role could lose access to the probe secret:** fixed in `provision-ci-runner.sh`. The role is now always granted the secret by name pattern (`...:secret:minion/prod-probe-dispatch-token-??????`), whether or not the secret exists yet. A secret added later by any means is readable without re-running the provisioner, and the warning is kept when the secret is missing.
4. **`makeHandler` `@returns`:** it now lists both result shapes of the backstop op (`fresh` and `dispatched`).
5. **`DEPLOYMENT.md`:** added a `minion/prod-probe-dispatch-token` row to the secrets table. I also noted that `minion-town-ci-jit-minter` now serves two ops and keeps its name because renaming means redeploying it, and updated the cutover step to describe the new grant. The Lambda's header comment already said it does both jobs, so I left it alone.
6. **PR body:** cut from 438 to 290 words. "What to attend to" is now a pointer to `DEPLOYMENT.md` § Dispatch backstop.

**Checks:** all 24 Lambda unit tests pass locally, and `bash -n` and `shellcheck` raise nothing new on the provisioner. The change has not been run against real AWS; in particular, the name-pattern IAM grant has only been checked by reading the code.

Commit `57721e4` was pushed with `safe-push-pr-head.sh` on top of `caf64b3`, a normal fast-forward. Per the stage instructions I did not re-run the panel; the gauntlet driver posts round 4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1919939 cached reads)
- Output: 9384 tokens
- Cost: $1.1884517999999995
- Wall-clock: 917s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
