The panel review is posted. Panel disposition was **must-fix**.

Panel round 5 complete for endojs/endo-but-for-bots PR #1158 (`designs/exo-db.md`).

- Set up an isolated project worktree of the PR head (`kriscendobot/endo-but-for-bots` @ `design/exo-db`).
- Ran `panel.sh` in single-round mode against base SHA `f109e8f4` (the real merge-base of the upstream `llm` base branch, per base-normalization guidance). Disposition: **must-fix**.
- Seats surfaced load-bearing design gaps: goal #4's "conditional writes" don't match the existence-only mutator surface (no CAS/optimistic-concurrency path, so read-modify-write loses updates under the design's own concurrency model); the retention ledger / crash-recovery intent keys on `(database formula, row key)` with no table component even though one formula holds multiple tables (cross-table key collision unhandled); the `delete` path isn't walked through the five-step retention protocol; and the per-database-formula mutation queue serializes all tables, cutting against the horizontal-scaling motivation.
- Posted the aggregate as a `gh pr review`. Because the reviewing bot is the PR author, GitHub rejected a `--request-changes` review, so it was posted as a `--comment` review with an explicit "disposition: must-fix; treat as request-changes" header for the next-stage-owed heuristic.

No fixes, un-drafting, or looping performed — this is a single panel stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (419102 cached reads)
- Output: 3141 tokens
- Cost: $0.713005
- Wall-clock: 236s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
