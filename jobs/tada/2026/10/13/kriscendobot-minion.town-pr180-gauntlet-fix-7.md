I applied the round-7 must-fix items to PR #180 and pushed them as one follow-up commit, `b824519`. CI is green on that head: `ci-wait-merge.sh --no-merge` returned 0, with all 3 checks passing. That includes the live-daemon run against the real Endo daemon, where the "guest git: create → mint → stock-git push → restart → revoke" test passed.

**What changed, by seat:**
- **decomplector (must-fix):**
  - I removed `createKey`, `createNamed` and the named index.
  - `E(git).create()` now allocates a partition in a one-off evaluation. The formula a guest keeps is ``E(git).open(`<partitionId>`)``, and the new `POST /partitions/:id/open` route answers only for the partition's owner, so replaying the formula is just a lookup.
  - I put back the design-doc sentence explaining why this doesn't follow the `@sites` path: `minion-git-remote` is the only process that writes the partition store.
- **saboteur:**
  - The per-owner cap now counts every partition an owner has and rescans at the cap, so a partition an operator deletes frees its slot without a restart.
  - `createGit` and `readOnlyGit` check the pet name again under a lock per guest and pet name, so two concurrent calls can no longer leave an unreachable partition.
  - When the control plane sends back a body that isn't JSON, the error now includes the HTTP status and the parse error.
- **breaker, saboteur and engine-realist:** `provideGuest` creates the guest's git caplet only if the host doesn't already have it. It binds the guest's `git` name only if that name is free. If the guest already uses `git` for something else, it logs that and leaves it alone.
- **breaker:**
  - `minion-git-remote` now exits non-zero if the control listener can't start or bind. A process sitting on port 3005 then shows up as a failed unit instead of silently collecting credentials.
  - `DEPLOYMENT.md` now says not to rotate the secret in place, and gives the recovery steps if it has to be.
- **pruner:** I removed the security-model text that was repeated across files, the duplicate guest-provisioning paragraph in `DEPLOYMENT.md`, comments that only restated the code next to them, and the repeated env-var and config text.

**Tests:** I updated the store, control-plane, caplet and root-host-socket tests to match. A new test covers adding `git` once, including for guests created before this deploy, and not overwriting an existing `git` name. Locally, typecheck passes and the unit suite has one failure: `projectPartition > propagates a git failure`. That test covers code this round didn't touch, and it passed in CI. I also posted a completion summary comment on the PR for this round.

**Not done:** the breaker's suggestion that the caplet also verify it is talking to the real control server (a unix socket at a restricted path, or the server proving the secret) is not implemented. Exiting on a failed bind covers the case where a squatter holds the port at boot. It does not cover a process that grabs the port during a restart. I noted it in the PR comment but did not post a follow-up job.

Mid-job I accidentally threw away my uncommitted edits with a stray `git checkout`. I re-applied them all from a script before committing, and the pushed head is complete.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (5221159 cached reads)
- Output: 35112 tokens
- Cost: $2.8625598
- Wall-clock: 1148s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
