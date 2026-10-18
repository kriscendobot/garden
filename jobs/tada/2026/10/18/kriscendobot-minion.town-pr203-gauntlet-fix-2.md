# Gauntlet fix round 2: kriscendobot/minion.town PR #203

I fixed both must-fix items from the round-2 panel review and pushed the commit to the PR head. CI never started before the 3600 s deadline: the run stayed queued the whole time, so this stage is still pending.

**What I changed** (one commit, `3ef6ad7`, on `design/git-remote-s7-bearer-identity-test`, pushed with `safe-push-pr-head.sh` in advance mode, `03247a8 -> 3ef6ad7`). All edits are in `designs/git-remote-capability.md` § 7.

- **Must-fix from decomplector (the store could reclaim live partitions):**
  - The first successful `open` now moves a partition from *pending* to **confirmed**. This is a signal the store can see.
  - The daemon saves the `open` formula before running it, so a confirmed partition always has a formula keeping it.
  - An **orphan** is now defined as a partition still pending a bounded interval after its `create`. The store reclaims orphans and refunds the quota. A late `open` gets a clear rejection, and the guest calls `create` again.
  - The store never reclaims a confirmed partition under this rule.
  - I removed the incorrect § 12.7 attribution. § 12.7 covers collecting unreachable objects inside a live partition, which is a different thing.
- **Must-fix from novice (terms used before they were defined):** I added a short walk-through of one partition's life before the route list and tables. It defines the allocator credential, retention key, facet key and root secret in the order they come up.
- **Should-fix items I also took:**
  - Each delegated facet is now saved as its own formula, so per-facet revocation and budgets survive a restart. This is reflected in the daemon row and in ownership-map items 1 and 3.
  - The facet-key row now says a read-only holder cannot recover the retention key.
  - One sentence explains why the root secret is outside the bearer-secret test.
  - The four `→` arrows in the ownership table are now ASCII `->`.
  - The maintainer citation now matches the document's usual `maintainer @kriskowal, <date>` form.
  - The closing naming sentence is narrowed to say that store states are named for what the store sees.
- **Not addressed** (all should-fix or comment-only): the ergonomist's rename of "retention key" and the route-to-secret column, the novice's current-versus-required table labels and table trimming, the skeptic's request for a #180 code reference and the `/hello` nonce, and the critic's `/hello` verifier storage and facet-count cap. The panel can raise them again in round 3 if they still matter.

**CI:** The Actions run `39136125731` for `3ef6ad7` stayed `queued` from 14:28 until past the 15:28 deadline; it never started. The repo had 4 runs queued and 0 in progress, so the self-hosted runner looks offline or not picking up jobs, rather than busy. The bot token can't read `statusCheckRollup` or check-runs (403), so I tracked the run through the Actions runs API. `ci-wait-merge.sh` was started but stopped by the tool's background time limit before its own deadline. My direct polling covered the full window.

**Follow-up:** Someone should check whether the minion.town CI runner is online. Earlier runs on this branch (`03247a8`, `e67a403`) passed.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1451558 cached reads)
- Output: 10111 tokens
- Cost: $1.0017395999999998
- Wall-clock: 3742s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
