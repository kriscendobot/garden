Round-14 fixes for kriscendobot/minion.town#184 are pushed and CI is green. I declined the decomplector's must-fix again and flagged it to the maintainer, so the panel may flag it a fourth time.

**What was pushed** (`2e7f126` → `329cf0c`, through `safe-push-pr-head.sh` in advance mode):
- **`e92ea6f` fix(probe): reconcile the backstop's whole resource policy**
  - **corner-prober (must-fix):** the provisioner used to remove only the permission under the rule's own id. It now removes every permission on the backstop Lambda before adding the one scoped to the schedule rule. Only `ResourceNotFoundException` counts as "no policy"; any other read failure stops provisioning.
  - **corner-prober (summary-fix):** new tests cover:
    - a stray permission under another id;
    - a Lambda with no policy yet;
    - provisioning before the probe secret exists: it warns, still creates the Lambda, and grants the secret by name pattern.
  - **stylist:** `PROBE_REPO` is now `PROBE_REPOSITORY`.
  - **pruner:** the test file's narrating header is gone.
  - **saboteur (should-fix):** seeding a secret now rejects a token that isn't visible ASCII, the same rule the Lambdas enforce.
  - **transplanter (should-fix):** packaging stops with a clear error if `python3` is missing.
- **`ea0521c` docs (archivist):**
  - The minter and provisioner headers now say the minter holds the runner's GitHub credential and the backstop holds its own.
  - DEPLOYMENT.md now says the Lambda's policy admits only its EventBridge rule. An operator with their own invoke rights can still run it by hand, which matches the documented manual `aws lambda invoke`.
- **`329cf0c` test (fast-checker):** a property test checks that the GitHub client returns any JSON body as parsed, over 200 runs.
- **integrator (must-fix):** the PR body now says at least one dispatch per scheduled firing, since EventBridge can redeliver one.
- **scribe (summary-fix):** I posted a summary comment covering the fixes, the declines and verification (issuecomment-6211759054).

**Declined:**
- **decomplector: replace the Lambda with an EventBridge API destination.** Rounds 10 and 11 raised this as comment-only and declined it; this round calls it must-fix with no new evidence. I kept the Lambda because:
  - the token would move into an EventBridge Connection, so rotating it would need `update-connection` instead of the documented `put-secret-value`;
  - a failed dispatch would only increment a `FailedInvocations` counter, instead of logging GitHub's response.

  I messaged the maintainer, offering to post the redesign as a separate job if they want it.
- **integrator (should-fix):** splitting the backstop out of the CI runner's provision and teardown scripts is left as a possible follow-up. Squashing the 23-commit history is left to merge time.

**Verification:** the three affected test files pass 28/28 locally, and `bash -n` on the provisioner is clean. The PR's one CI run, `test (typecheck + vitest)` on `329cf0c`, sat queued for about 22 minutes waiting for a self-hosted runner, then passed. `ci-wait-merge.sh --no-merge` returned rc=0 (CI green).

**Follow-ups:** the maintainer's answer on the API-destination redesign, and optionally a separate lifecycle for the backstop.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-14.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2252527 cached reads)
- Output: 17867 tokens
- Cost: $1.5033253999999998
- Wall-clock: 1729s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
