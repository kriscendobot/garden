**Completion report: kriscendobot-minion.town-pr184-gauntlet-undraft**

PR #184 is now marked ready for review on the head the panel passed (`63f7edb8a24567762ea67dccfb1fa4b5a9c95b6d`). The PR is "fix(probe): dispatch the production probe on an EventBridge schedule", based on `main-bc11010`.

- **Pre-mutation check:** the PR was OPEN and still a draft, and its head was exactly `63f7edb8…`. I then ran `gh pr ready`.
- **Post-mutation check:** it now shows `isDraft=false` and the head is still `63f7edb8…`.
- **Advisory appellate pass** (one `claude -p` run with Sonnet over the 782-line diff, recorded only and not used to block anything). It raised these points:
  1. Manual `workflow_dispatch` runs now use `--strict`, including the backstop's dispatches. So a missing credential or a skipped check turns the run red and opens or updates the `prod-probe-failure` issue.
  2. In `provision.sh`, the policy rewrite removes the old Lambda permissions before adding the new one. If it fails in between, EventBridge can no longer invoke the Lambda.
  3. The Lambda has no retries, no dead-letter queue and no alarm. If the PAT expires or GitHub returns an error, dispatches stop without anyone noticing. A CloudWatch alarm on Lambda `Errors` would catch this.
  4. Seeding does not test the PAT against GitHub, so a bad token only shows up at the next 3-hour firing.
  5. Dispatching with `ref: main` can race a deploy. The concurrency group can also drop a pending dispatch, so the docs' claim that it is "lossless" is overstated.
  6. Actions: write is broader than the docs suggest: a leaked token could disable the probe workflow.
  7. `teardown.sh` hides delete errors, so a partial teardown looks successful.

**Follow-ups (optional, not blocking):** points 2–4 are worth a follow-up hardening job: the alarm on Lambda errors, a non-destructive policy update and a PAT check at seed time. Nothing was changed in the garden repo.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168451 cached reads)
- Output: 1425 tokens
- Cost: $0.3911742
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
