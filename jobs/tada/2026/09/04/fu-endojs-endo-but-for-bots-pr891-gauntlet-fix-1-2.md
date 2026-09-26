The work is complete. Let me summarize.

## Completion report

**Job:** Re-groom `designs/README.md` in endojs/endo-but-for-bots so its "Current totals" header block reconciles with the per-rebase delta notes that had drifted out of agreement (noted while fixing PR #891).

**The drift I found:** The current-totals block was dated **2026-08-29** and claimed **196 designs** (48 Complete/Implemented, 36 In Progress, 37 Proposed, …). Beneath it, six delta notes (2026-08-25 → 2026-09-03) each recorded a rebase/status change and bumped a running design count — but that running count had already fallen behind the summary table, so neither the header buckets nor the delta lineage reconciled with the table they summarize.

**The recount** (by the block's own declared method — tallying the Status column of the summary table's 201 rows):

| Bucket | Header | Actual | Δ |
|---|---|---|---|
| Complete/Implemented | 48 | 49 | +1 |
| In Progress | 36 | 39 | +3 |
| Proposed | 37 | 38 | +1 |
| **Total designs** | **196** | **201** | **+5** |

Every other bucket (Not Started 49, Active 2, Reference 13, Deprecated 3, Draft 1, Superseded 4, Approved 1, cbor-codec, genie) was already correct. The +5 accounts exactly for the designs the delta notes added since the header: `hardener-indexed-cardinality`, the `genie-integration` re-add, `exo-git-follow-root-advancement`, `npm-dev-publisher-attenuation`, `endo-workflow` (with its Proposed→In Progress flip), and `daemon-secret-manager`.

**What changed:**
- `designs/README.md` — collapsed the stale header + its six layered delta notes into a single **2026-09-04** reconciled current-totals block (201 designs), per the index's single-current-totals-block rule.
- `designs/ARCHIVE.md` — moved the superseded 2026-08-29 block (delta lineage folded into it) to *Superseded totals*, and added a *Historical groom notes* entry.
- Totals prose only — no design's Status, the summary table, milestone tables, or estimates changed.

**PR:** [endojs/endo-but-for-bots#1146](https://github.com/endojs/endo-but-for-bots/pull/1146) (draft — ensure-pr.sh default), head `kriscendobot:groom-designs-readme-totals-reconcile-20260904`, base `llm`. PR body carries the full recount table.

**Follow-ups:** PR sits as draft awaiting review/un-draft; a future grooming pass should keep appending delta notes to `ARCHIVE.md` rather than layering them back into the index (the convention the drift violated).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr891-gauntlet-fix-1-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1529117 cached reads)
- Output: 23771 tokens
- Cost: $1.9015967499999995
- Wall-clock: 360s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
