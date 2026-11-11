The report is already committed on journal2 (a prior attempt landed it before being reaped), and my fresh regeneration is byte-identical to the committed tip. The job is complete.

## Completion report

**Job:** `context-graph-size-audit-focused-20261111-222010` — focused context-graph size audit (library/context/roles/skills; designs and journal/projects excluded).

**What I did:**
- Re-derived job state on this fresh worktree: found no `2026-11-11` report in the live journal worktree, then regenerated the audit with `scripts/context-graph-size-audit.py --main-root . --journal-root /home/kris/garden/journal --date 2026-11-11 --exclude-root-glob 'designs/*.md' --exclude-journal-seed 'projects/README.md'`.
- Landed it via `land-journal-edit.sh` (with `reports` in `GARDEN_EDITABLE_TREES`), which reported **"no change — already at origin/journal2 tip"**: a prior (reaped) attempt had already committed the identical report.
- Verified `reports/context-graph-size-audit-focused-2026-11-11.md` exists on `origin/journal2` and is **byte-identical** to my regeneration. No duplicate or overwrite created.

**Result:**
- Report path: `journal/reports/context-graph-size-audit-focused-2026-11-11.md`
- Focused main2 context library: **278 reachable documents, 51 reorganization candidates** (whole-graph walk: 9445 docs, 332 candidates).

**Movement since the prior focused run (2026-10-12):**
- main2 reachable docs **272 → 278 (+6)**; reorg candidates **51 → 51 (flat)**.
- Largest-15 growth: `systemd-units.md` 737→796 lines, `local-verify/SKILL.md` 613→646, `liaison/AGENT.md` 500→512, `job-board/SKILL.md` 398→434 (climbed to #8), `COMMON.md` 351→353.
- `ci-failure-classification-loop/SKILL.md` (340) dropped out of the top-15; `caplet-validation/SKILL.md` (345) is now #15. No new document entered the top ranks.
- Signal worth flagging: the two largest docs (`systemd-units.md`, `local-verify/SKILL.md`) keep expanding month-over-month while the candidate count holds steady — net growth concentrated at the already-largest files.

**Follow-ups:** none required; recurring schedule continues normally next month.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/context-graph-size-audit-focused-20261111-222010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 26 tokens (744983 cached reads)
- Output: 4968 tokens
- Cost: $1.0514115 (1 engagement(s) unpriced)
- Wall-clock: 356s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
