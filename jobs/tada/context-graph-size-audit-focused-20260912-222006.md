Focused context-graph size audit re-run and landed.

**What I did**
- Ran `scripts/context-graph-size-audit.py --main-root <this worktree> --journal-root /home/kris/garden/journal --date 2026-09-12 --exclude-root-glob 'designs/*.md' --exclude-journal-seed 'projects/README.md'` (revisions: main2 `f5e91b662553`, journal2 `87211d89d23e`).
- Landed the output as a new dated snapshot via `land-journal-edit.sh` (needed `GARDEN_EDITABLE_TREES` to include `reports`, which is outside the default `library projects` allowlist). Confirmed: `landed reports/context-graph-size-audit-focused-2026-09-12.md on origin/journal2`.

**Results (this run, 2026-09-12)**
- Total: **8546 documents walked, 311 reorganization candidates flagged**.
- main2 context library: 239 reachable / 38 candidates.
- journal2 library/: 8304 reachable / 271 candidates; projects/ and root: 1 each.
- Report path: `journal/reports/context-graph-size-audit-focused-2026-09-12.md`.

**Movement vs. prior focused run (2026-08-13)**
- Net growth everywhere — itself a signal: total walked **+362** (8184→8546), candidates **+10** (301→311). main2 library +26 reachable / +5 candidates (213→239, 33→38); journal2 library/ +336 reachable / +5 candidates.
- Largest-15 (main2) shifts: the previous #1, `context/operations/local-inference-amd.md` (670 lines, "very large"), **dropped off the list entirely** (shrunk/removed); new #1 is `context/control-surface-gallery.md` (541). `roles/liaison/AGENT.md` grew notably (366→428) and climbed the ranking; `skills/pr-creation-flow` 376→389, `CLAUDE.md` 321→336, `README.md` 419→421; `local-verify` shrank 557→535. New arrivals into the largest-15: `skills/design-dependency-walk` (330) and `skills/job-board` (284→329).

**Follow-ups**
- No prior run had landed since 2026-08-13 (schedule cadence 30d; `last_dispatched` 2026-08-13); this run brings the trend series current. Persistent top reorganization candidates (`control-surface-gallery.md`, `local-verify`, `agoric-chain-snapshot`, `liaison/AGENT.md`) remain oversized across both runs if a split is ever desired — no action taken, as this job is audit-only.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/context-graph-size-audit-focused-20260912-222006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (672056 cached reads)
- Output: 5060 tokens
- Cost: $0.8952810000000001
- Wall-clock: 98s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
