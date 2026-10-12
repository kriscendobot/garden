The description now states the behavior accurately, so the remaining should-fix is already covered. The prior fix commits (22ce87c, 42de416) address every must-fix item from round 2, and CI is green on the current head.

Report: PR #180 fix round 2

- **What I did:** I read the round-2 panel verdict (head `ae6ec13`). The PR head was already at `42de416`, which includes two earlier follow-up commits. I pushed nothing new.
- **Must-fix items already applied by those commits:**
  - Each guest caplet now gets an owner-scoped credential instead of the root control secret.
  - `git.create` replay is keyed on a host-minted nonce, not the guest's pet name.
  - A short control secret leaves the control listener off instead of crashing the public git plane.
  - The git tools mount only on the socket backend.
  - The three channel types are consolidated into one, and `MintedGitUrl` is now `MintedPartitionUrl`.
  - The git tools are renamed `readOnlyGit`, `mintGitUrl` and `revokeGitUrl`.
  - Restating comments are pruned.
  - The design doc's env table, the deferred item and `DEPLOYMENT.md` are reconciled.
- **Left as is:** the locksmith's should-fix that a read-only facet can revoke any read URL on its partition. I did not change the behavior; the `revokeGitUrl` tool description now says exactly that.
- **CI:** `ci-wait-merge.sh --no-merge` returned green (3 of 3 checks, 0 failed).
- **Follow-up:** the panel-3 re-post is the driver's job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (595073 cached reads)
- Output: 2660 tokens
- Cost: $0.3850186
- Wall-clock: 34s

<!-- garden-usage-end -->
