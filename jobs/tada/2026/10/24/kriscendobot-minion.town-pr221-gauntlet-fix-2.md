Completion report: fix round 2 of the gauntlet for kriscendobot/minion.town PR #221 (design: recursively attenuated DynamoDB capabilities).

I applied the latest panel review's findings (review 5636729071, headed "Must-fix before merge") to `designs/recursive-dynamodb-capabilities.md`. That covers all six must-fix items and the should-fix items. I pushed it as follow-up commit `d65ac219` with `safe-push-pr-head.sh` (`680172f7` → `d65ac219`). CI on the new head is green: `changes` and `test` passed, and the Claude harness job was skipped. `ci-wait-merge` returned rc 0.

**Must-fix items:**
- **Skeptic 1 (index vs. base key space):**
  - §3.2 now says every item an index query returns is rechecked against the base-table key space and item shape. Items that fail are dropped, and the page gives no count of dropped rows.
  - Indexes get their own key ranges, with numeric sort-key intervals and query sort-range intersection.
  - A consistent-read request on an index is refused.
  - §8 explains why the sweep tolerates stale index reads: every sweep step is a conditional write against the base item, the next pass picks up missed rows, binding is idempotent, and the recount is guarded by the capacity row's `version`.
- **Skeptic 2 (filters and bounds):**
  - Filters are now written as the typed condition trees the design already uses, not AWS expression strings.
  - The access-pattern table now shows what each query reads and is billed for separately from what it returns.
  - The row-shape change is stated openly: attributes are promoted to top level, and every coupon write path is touched.
- **Ergonomist 1 (revocation):** Both `derive` methods now return the same `{ capability, grantId }`. Only the host-side `derive` takes `name`, and only named grants are durable. One table in §6 lists every revocation path and whether it survives a restart.
- **Ergonomist 2 (errors):** Every method resolves to a `Result`. A promise rejects only when the remote connection breaks. `derive` problems come back as `invalid-request`.
- **Novice 1:** The key-space paragraph is now a numbered rule list with a worked `COUPON#` → `COUPON#7` example.
- **Novice 2:** A new opening section gives a short mental model and a glossary (caplet, broker, control, grant, facet, gate, generation).

**Should-fix and comment items:**
- A `Restriction` type where an omitted part inherits the parent's value.
- The guard language is named, and `derive` checks fixed attributes where it can decide the answer.
- The final revocation check and the AWS call happen in one turn, with nothing in between.
- The daily recount starts from scratch each pass and never writes a partial count.
- On restart, tombstones are read before any grant is rebuilt.
- Terminal rows move to new `COUPON#retired#<status>` index partitions, so they leave the partitions the sweep reads.
- Billing is named as the known case that needs a transaction across two tables.
- `Page` and `limit-exceeded` (with `limit` and `retryable`) are defined.
- New test bullets, duplicate text removed, and §10 merged with the follow-ups.

**Lint:** the cliché check found nothing. The British-spelling check flags only `cancelled`, the existing option name, which matches Endo's spelling. I left it.

**Follow-up:** none from this stage. The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2610123 cached reads)
- Output: 23598 tokens
- Cost: $1.7506566
- Wall-clock: 958s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
