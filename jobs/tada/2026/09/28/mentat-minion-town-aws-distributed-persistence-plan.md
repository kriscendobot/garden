Completion report:

## Job: mentat-minion-town-aws-distributed-persistence-plan — DONE

**Deliverable:** `designs/aws-distributed-persistence.md` on branch `design/aws-distributed-persistence`, opened as **draft PR kriscendobot/minion.town#126** against the frozen base `main-f69bf87` (the same frozen base the sibling designs use; single-file diff verified; the mermaid fence validated `OK flowchart-v2`). Left draft per the manual-gauntlet regime — promote with **run the gauntlet #126**.

**The existing plan, found:** the decision of record is `clip-usage-metering.md` § 10 item 8 (PR #42 review), adopting endojs/endo-but-for-bots#637 — `makeDaemonDatabaseAws` (DynamoDB `DaemonDatabase` engine: async warm boot into a mirror, sync reads, ordered write-behind) plus `makeS3ContentStore`. Reconciliation: that PR is draft, **conflicting, stale since 2026-07-08**, and written against `daemon-database.js`, which `llm` has since renamed to `manager-database.js` and grown to schema v3 (secrets tables, `formula.type`). In minion.town, the account/billing DynamoDB adapters are live in prod, but there is no S3 content-store adapter (fs-only gateway store), no daemon table, and **no backups of anything** — no PITR, no SQLite backup, no CAS backup.

**What the design adds over #637:** a shard-ready key schema (PK `shardId`, SK `kind#key`, so PR #124's sharding step 2 becomes data motion, not migration); a durability split (async formula writes await their DynamoDB flush, preserving the manager's persist-before-visible invariant; only the sync surface keeps bounded write-behind lag); per-shard lease items with epoch fencing via `TransactWriteItems` `ConditionCheck`; a 400 KB body-spill guard; S3 CAS layout `shards/<shardId>/store-sha256/<hex>` with lifecycle tiering and a GC port replacing the mtime grace window with pending-publish lease rows; gateway vhost records to DynamoDB (also closing git-remote's cross-instance CAS gap); a seven-step reversible migration (interim backup lane first, gateway before daemon, active/standby before sharding); cost model at three scales (idle shard ≈ storage cents; the bill scales with bytes and mutations, not population); failure-mode table; metering rides unchanged.

**Open questions for the maintainer** (§ 10 of the design): refresh PR #637 in place vs. fresh PR; accept the durability split; fencing granularity; table topology; gateway/daemon CAS unification timing; storage principal vs. S3 rent; compute posture at cutover; provisioning authorization.

**Proposed build sequence** (suggested basenames, not posted): `build-minion-town-aws-backup-lane`, `fix-ebfb-pr637-refresh-manager-seams`, `build-endo-daemon-aws-flavour-lease`, `probe-endo-daemon-aws-fidelity`, `build-minion-town-content-store-s3`, `build-minion-town-aws-provisioning`, `build-minion-town-daemon-aws-cutover`, `design-minion-town-aws-multi-host`.

**Follow-ups / notes:** the interim backup lane is the cheapest standing risk to retire and needs no upstream work. The inbox drain was offline all three attempts (journal clone rc=124 timeouts — host connectivity/clone-path symptom, not job state; GitHub pushes and the board record worked fine). Cross-referenced siblings PR #123/#124/#125; the Cloudflare sibling had not landed and is cited by expected filename. One small doc staleness noticed in passing: `DEPLOYMENT.md`'s portability rule names only `src/auth/stores/` though billing added a second adapter — recorded in the design's reconciliation table, no separate fix posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-minion-town-aws-distributed-persistence-plan.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3897627 cached reads)
- Output: 44120 tokens
- Cost: $14.3127538
- Wall-clock: 822s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
