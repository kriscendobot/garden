# Gauntlet fix round 2: kriscendobot/minion.town PR #145 (CI green)

I applied the round-2 panel's must-fix items and pushed them as `aa3ef2d` on `ci-minion-town-runner`. CI passed on that head: 3 of 3 checks, `ci-wait-merge` rc 0.

**Changes, by panel seat:**
- **stylist:**
  - In `provision-ci-runner.sh` and `teardown-ci-runner.sh`, the AWS-CLI wrapper `A()` is now `aws_region()`.
  - The resource variables `AZ`, `SG`, `IGW`, `RT` and `ALLOC` are now `AVAILABILITY_ZONE`, `SECURITY_GROUP`, `INTERNET_GATEWAY`, `ROUTE_TABLE` and `ALLOCATION`. Teardown's loop variables are spelled out the same way.
  - In the minter (`lambda/index.mjs`), `sm` is now `secretsManagerClient`.
  - Because of this, the provisioner's `AZ` environment variable is now called `AVAILABILITY_ZONE`. Anyone who sets it must use the new name.
- **integrator:** the PR body cited #144 for the billing block, but #144 is an unrelated design PR about guest-account coupons. The body now states the billing block directly, since no tracking issue exists.
- **pruner:**
  - The file-by-file tour in the PR body is now one paragraph.
  - The runner comment at the top of `test.yml` is shorter.
  - The decorative section dividers in `bootstrap.sh` are replaced with comments that say why each step exists.
  - The notes on rotating the credential and on the narrowest token scope moved from the DEPLOYMENT.md Operate table into the trust note.
- **scribe:** I posted the missing summary comment covering the fixes from both rounds (issuecomment-5923804654), plus a short follow-up comment saying CI is green.

**Not changed:**
- Renaming the injected `gh` fetch parameter in the minter. Stylist raised it only as a note, not a must-fix.
- Moving the runner scripts into `deploy/aws/scripts/`. The round-2 integrator accepted the self-contained `deploy/aws/ci-runner/` layout.

**Checks:** besides CI, the minter's test suite passes locally (6 of 6), and `bash -n` passes on every edited script. `prettier --check` warns on the two minter files, but the file was already flagged before my edit.

**Follow-ups:** none from this stage. The driver re-posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1910565 cached reads)
- Output: 9990 tokens
- Cost: $1.228553
- Wall-clock: 780s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
