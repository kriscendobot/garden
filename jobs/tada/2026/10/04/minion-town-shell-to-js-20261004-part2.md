---
handed-off: minion-town-shell-to-js-20261004-part2-b-gauntlet
deliverable-complete: false
---
# Part 2 report: deploy scripts converted to JavaScript (job minion-town-shell-to-js-20261004-part2)

All 21 in-scope `deploy/aws/scripts/*.sh` are now Node ESM, in two stacked draft PRs. Part 1 (#151) hasn't merged yet, so both stack on it. Merge order is #151 → #152 → #153.

**Incident:** the first smoke test of the 2a scripts accidentally ran against the real AWS account and briefly broke the ocap.site ACME policy. It's restored. Details are under Follow-ups.

## What changed

**#152 (2a)**: https://github.com/kriscendobot/minion.town/pull/152. Head `chore/javascript-only-scripts-part-2a`, base is a frozen copy of part 1 (`chore/javascript-only-scripts-part-1-dcc2d64`). These are the 14 host-run provisioning scripts:
- Account and billing: `deploy-accounts-store`, `deploy-billing-store`, `set-account-role`.
- Cognito: `deploy-cognito-github-idp`, `deploy-cognito-siwe-idp`, `deploy-cognito-guest-scope`.
- Lambdas: `deploy-pre-token-gen`, `deploy-thunk`.
- Secret delivery: `deploy-account-endpoint-secret`, `deploy-billing-secrets`, `deploy-npm-registry-secret`.
- Other: `deploy-clip-acme-iam`, `deploy-npm-registry-dns`, `seed-clip-fixture`.

It also adds shared helpers in `lib/`: process and AWS-call handling plus exit cleanup in `common.js`, presigned secret staging in `artifacts.js`, Cognito read-modify-write in `cognito.js`, and a dependency-free ZIP writer in `zip.js`. Hosts no longer need `python3` or `zip` for these scripts.

**#153 (2b)**: https://github.com/kriscendobot/minion.town/pull/153. Head `chore/javascript-only-scripts-part-2b`, base is a frozen copy of 2a (`chore/javascript-only-scripts-part-2a-8712a29`). These are the 7 CD-path scripts: `deploy-caddy`, `deploy-www`, `deploy-endo-gateway`, `deploy-git-remote`, `deploy-oauth2-proxy`, `deploy-clip-dns`, `deploy-endo-federation`.
- The CD workflow (`.github/workflows/deploy.yml`) now runs the 5 CD ones with `node`.
- The two tests that grepped shell source text now test the exported JS functions directly.
- New test files: `test/deploy-provisioning-scripts.test.mjs` (19 cases) and `test/deploy-cd-scripts.test.mjs` (9 cases).

**Across both PRs:**
- Every caller is updated: the workflow, systemd/Caddy comments, DEPLOYMENT.md, READMEs, designs and source comments.
- The `.sh` files and their allowlist entries are deleted. The allowlist now holds only part 3's 8 scripts plus 3 box-side scripts outside `deploy/aws/scripts/` (`endo-federation-box.sh`, `npm-registry-backup.sh`, `endo-daemon-reap-port-orphans.sh`).
- Arguments, environment variables, exit paths and log lines are kept.
- **Behavior change:** an explicitly set `AWS` variable is now always used. Before, an override that failed the executable check silently fell back to the real `~/.local/bin/aws`.

## How it was checked

- **Commands sent to the box:** all 12 SSM programs from the 2b scripts are byte-identical to the shell versions' apart from a trailing newline. I compared them by running the old `.sh` with a stubbed `ssm_run` against the new `.js` with a fake `aws`.
- **Branch coverage:** every converted script ran its main and refusal paths against a fake `aws`, with the real CLI removed from `PATH`/`HOME`. For the secret-delivery scripts this included confirming the temporary S3 secret objects are deleted on exit.
- **Federation preflight:** it ran read-only against the real Endo history and correctly refuses the current pin, which lacks the #1333 change.
- **Not run live:** the pre-token-gen and thunk Lambda deploys, the secret renderers, the npm DNS record, the clip seed, and all CD scripts. Each PR body records, per script, how it was exercised.
- `tsc --noEmit` and the no-new-shell guard pass. Full vitest has 1 failure, `test/git-remote/capability.test.ts` ("propagates a git failure"). Neither PR touches that file, and it fails the same way when run on its own on this host.

## Follow-ups

- **Incident: the first 2a smoke test reached real AWS.**
  - **Cause:** `/tmp` is noexec here, so the fake `aws` failed the executable check and the old fallback picked up the real CLI.
  - **What it did:** 7 of the 2a scripts ran against the account (`set-account-role`'s list and attempted role change are 2 runs of one script).
    - `set-account-role list` only read data.
    - `set-account-role role` hit a nonexistent account and wrote nothing.
    - `deploy-accounts-store`, `deploy-billing-store`, `deploy-cognito-guest-scope` and both Cognito IdP scripts re-applied the state that was already live. I checked that the live IAM policies byte-match what the scripts render. CloudTrail shows the guest-scope cleanup was first applied on 2026-08-27.
    - `deploy-clip-acme-iam Z1` pointed the ACME DNS policy at a bogus zone. I restored it immediately with the real ocap.site zone, `Z048672026UQWLGHNEQE0`, after confirming the zone ID. For about 2 minutes, only an ocap.site certificate renewal would have failed.
  - **Prevention:** the change to always use an explicit `AWS` closes this hole, and there's a test for it. The incident is written up in #152's description.
- **Gauntlets:** `ensure-pr.sh` allows one PR per job marker, so #153 uses a derived marker (`minion-town-shell-to-js-20261004-part2-b`). I posted its gauntlet record myself (`minion-town-shell-to-js-20261004-part2-b-gauntlet`). #152's gauntlet will be staged by the normal job-completion step.
- **Before merging #153:** the CD-path scripts will first run live when CD runs after the merge. Their SSM payloads are unchanged; the new parts are the host-side AWS calls and S3 presign/cleanup.
- **Part 3:** it should stack on #153.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 148 tokens (12992582 cached reads)
- Output: 107090 tokens
- Cost: $6.7337884
- Wall-clock: 1017s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
