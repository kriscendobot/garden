## Dependabotany recheck: endojs/endo-but-for-bots, 2026-11-12

Nothing could be merged or closed this run. All five open Dependabot PRs are still waiting on two unmerged blocker PRs. Both blockers are now green and ready, so they only need a maintainer review and merge.

**Ledger:** The job's row snapshot was taken at a different journal commit than the one I synced to, so I fell back to the full ledger scan. It found five active rows: #1629, #1654, #1655, #1657 and #1658. These match the open Dependabot PRs exactly, and there are no new ones.

**Blockers:**
- **#1646** (pin `.node-version` to 24): this changed since yesterday. The 2026-11-11 shepherd and review runs got it green and moved it out of draft. It has no review decision yet and isn't merged.
- **#1613** (XS oracle lanes on Ubuntu 24.04): CI green and mergeable since 2026-11-01, with no review decision. Not merged.
- The `llm` branch is unchanged at `48d6f3e08bcc`.

**Verdicts (none changed):**
- **#1629** (setup-python 7.0.0 → 7.1.0): still embargoed (held). Its only failures are `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, which #1613 fixes. It merges through `ci-wait-merge.sh --dependabot-auto-merge` once #1613 and #1646 are on `llm`.
- **#1654, #1655, #1657, #1658:** the merge-now verdict stands but can't be carried out. Each PR's only failing check is `test-xs`, which also fails on `llm` itself, and #1646 fixes it. The two parked "conduct after #1646" plans are still in place.
- I didn't attempt any merge, because every PR still has a failing check.

**What I wrote:**
- Ledger entry: `entries/2026/11/12/023752Z-message-botanist-2c6058.md`.
- One message to the maintainer inbox (`msg-dependabotany-recheck-endo-but-for-bots-20261112-023509-87198ff4aa12`): the whole set now depends only on the maintainer merging #1613 and #1646.

**Follow-ups:** None for the fleet. After the maintainer merges #1613 and #1646, the daily recheck and the parked plans will merge the set automatically. Every maturity date has passed, so I didn't schedule any single-PR rechecks.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20261112-023509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1051979 cached reads)
- Output: 5664 tokens
- Cost: $0.8502598000000001
- Wall-clock: 159s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
