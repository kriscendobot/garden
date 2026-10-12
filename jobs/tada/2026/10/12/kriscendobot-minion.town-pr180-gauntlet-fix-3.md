## Fix round 3 for kriscendobot/minion.town PR #180: pushed, CI green

I pushed one follow-up commit to the PR head (`42de416` → `89d36db`), and CI passed on it: `ci-wait-merge.sh` returned rc 0, with `test` and both `Claude harness` (amd64, arm64) checks green.

**Changes in `89d36db`:**
- **`deploy/aws/scripts/deploy-git-remote.sh`:** the secret file is now created with permissions 0600 (`install -m 0600 /dev/null`) before the secret is written, instead of fixing permissions afterwards. This answers transplanter's file-permission point.
- **`DEPLOYMENT.md`:**
  - MCP mint/adopt and pet-store binding no longer appear in the deferred-work list (integrator 1).
  - A new line says the `127.0.0.1` control address only works when both services run on one host (transplanter 2).
- **`src/config.ts` and `src/endo/git-remote/git-caplet.ts`:** both error messages for a wrong control address now say the same thing. The existing test regex still matches; the two affected test files pass (12 tests) and typecheck is clean.

**PR body edits:**
- It now says the PR merges only after #178 (integrator 3).
- It explains why `designs/git-remote-capability.md` § 12.2 and the DEPLOYMENT.md phase table stay as written (integrator 2). § 12.2 is work in the upstream Endo repo, and the phase table only records what is deployed.

**Completion summary:** I posted it as https://github.com/kriscendobot/minion.town/pull/180#issuecomment-6118985602 (scribe 1 and 3). It maps each finding from all three review rounds to the commit that fixed it, or says why it was declined.

**Declined, with reasons in the summary comment:**
- **transplanter 1 (the deploy script writes a fixed, guessable secret):** wrong. The script body is an unquoted heredoc, so the escaped `\$(openssl …)` runs on the server and each host gets its own random secret. I checked this with a local reproduction.
- **procurer (use `isRecord` from `@endo/pass-style`):** declined. That `isRecord` tests for a frozen copy-record and throws on unfrozen input, so it can't stand in for the local check on a parsed JSON response.

**Follow-ups:**
- Locksmith's round-2 finding 3 is still in the code: a read-only partition can revoke another read-only URL on the same partition if it knows that URL's token hash. Round 3's locksmith didn't raise it again, and the summary comment says it is unchanged.
- The control address still doesn't accept `::1`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1957754 cached reads)
- Output: 10755 tokens
- Cost: $1.2272828
- Wall-clock: 878s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
