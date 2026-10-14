## Completion report: kriscendobot/minion.town PR #167, gauntlet undraft stage

**Result:** PR #167 ("design: non-interactive root MCP principal for the kriscendobot canary") is now out of draft. Checked again after the change: `isDraft=false` and the head is still `8368f8c66ac60b810242b7210e2529fb12ad5008`.

**What I did**
1. **Advisory appellate pass** (claude-sonnet-5-5 on the PR diff; it does not block the un-draft). Possible issues the panel may have missed:
   - **User deletion:** cleanup for premise A2 uses `AdminDeleteUser` on the production pool, protected only by a string match. Stalling and disabling the user would be safer than deleting it.
   - **Spend after revocation:** a revoked bearer is cut off within 15 minutes, but the `watchInbox` children it started keep spending from the shared pool until a human kills them. That pool is shared with the human root, so it can also be drained to block the maintainer, and § 3 doesn't list that risk.
   - **Sweep:** it deletes by name prefix and the timestamp encoded in the name. A manual run, or a stuck entry that gets re-posted, could break the serialization it relies on and reap a live run's children.
   - **Exit 75 (auth unavailable):** it has no `transient` reason. A brief Cognito or network error could send the maintainer through an interactive MFA re-mint, and a helper that dies before writing its status file shows up as a canary failure instead.
   - **Revocation levers:** lever 2 (the allowlist) may need a restart, and lever 3 doesn't invalidate tokens already issued. So the "primary" lever is the slowest, and the fast ones also cut off the human root.
   - **Leak model:** the client secret sits in the same JSON as the refresh token, which weakens the "partial leak" argument. Calling `GetSecretValue` on every token request also adds CloudTrail noise.
   - **Host pin:** the reader role trusts only `endolin-garden1`, but the design never adds a `requires: host=` pin to the job.
   - **Verifier isolation:** that no other verifier accepts this token rests on a one-time survey at `d750b09` and a prose rule, with no test or lint enforcing it.
2. **Metadata gate:** fresh `gh pr view` showed state OPEN, head `8368f8c66ac60b810242b7210e2529fb12ad5008` (matching the head the panel passed) and `isDraft=true`.
3. Ran `gh pr ready` to take the PR out of draft.

**Follow-ups:** none required. The appellate notes may be worth passing to the PR author or maintainer for a follow-up revision of the design.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-20261013-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (149161 cached reads)
- Output: 1722 tokens
- Cost: $0.35084020000000005
- Wall-clock: 168s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
