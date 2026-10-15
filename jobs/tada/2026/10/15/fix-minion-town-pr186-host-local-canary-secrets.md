I shrank PR #186 to keep the root-canary secrets on `endolin-garden1` as host-local files, and pushed it as `cada623`. CI for that commit hasn't run: it was still waiting for a runner after about 20 minutes.

**Scope check first.** I re-read #191 and the maintainer's newest comment (issuecomment-6201208707). Its pivot is to account keys and to building the OCapN canary first; it didn't change #186's scope. The design on #191's head still says #186 shrinks and becomes the second step, so I went ahead.

**What changed** (all in `deploy/aws/scripts/`):
- **Removed:**
  - the `minion-root-canary-reader` role and its host-restricted trust policy;
  - the Secrets Manager secret `minion/root-canary` and its resource policy;
  - the `ROOT_CANARY_SOURCE_INSTANCE_ID` requirement and the `ec2 describe-instances` lookup.
- **`root-canary-deploy-client.mjs`** now only creates the Cognito client and checks it against the design. A new test confirms it calls nothing but Cognito.
- **`root-canary-mint.mjs`** writes the refresh token to a mode-0600 file on the mint host. The default is `~/.garden-state/root-canary/credential.json`, and `ROOT_CANARY_CREDENTIAL_FILE` overrides it. Before revoking the token it replaces, it records that token in the file, so a mint that dies partway leaves it for the next mint or revoke to clean up.
- **Reading the file:** the bearer helper, `root-canary-status.mjs` and `root-canary-revoke.mjs` read this file now. They refuse it if it isn't a regular file owned by the same user with mode 0600.
- **Revoke and runtime:** revoke now goes through Cognito's fixed revoke URL, so running the canary needs no AWS credentials. Minting still needs AWS access to read the client's secret.
- **Unchanged:** the dedicated Cognito client, the one-time interactive mint for Flow A, the audit records without tokens, and the failure contract. `missing`, `unreadable`, `refused` and `mismatched` exit 75; `unreachable` exits 1.

**Docs:** I updated the root-canary section of `DEPLOYMENT.md`, including a note on the "secrets live only in Secrets Manager" rule. `designs/root-canary-principal.md` gets a dated amendment to Section 2.3 and the parts that describe the scripts. Its other sections still mention the old Secrets Manager setup; that cleanup waits for #191's open questions. I also updated the PR body (Phase 3 marked dropped, `.mjs` paths), posted an explanatory comment (issuecomment-6203957556), and left #186 as a draft.

**Tests:**
- The two root-canary test files pass (101 tests), and `tsc` is clean.
- The full suite has 1 failure out of 1158: `test/git-remote/capability.test.ts > projectPartition`. It fails the same way when run alone, and this PR touches nothing in that area. I believe it's caused by this host's environment, but I didn't check it against the base branch.

**Follow-ups:**
- CI run 38820131843 for `cada623` was still queued when I stopped. The previous heads passed CI.
- A fix job is queued for the gauntlet's round 11 (`kriscendobot-minion.town-pr186-gauntlet-fix-11`). It will run on top of `cada623`. Its findings on `refreshRootToken` (it repeats the server's token check, and it adds reasons beyond the design's three) still apply, and I didn't address them.
- The maintainer still needs to answer #191's open questions 1, 3 and 4. Running Flow A still needs the maintainer's GitHub sign-in.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-pr186-host-local-canary-secrets.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3667295 cached reads)
- Output: 34951 tokens
- Cost: $2.455071
- Wall-clock: 1549s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
