Done. Pushed to `main2` as `f8745a46e`.

## Completion report

The maintainer lowered the default concurrent gardener count for all hosts from 100 to 20 (effective 2026-07-06). I updated the operator-facing documented default in three places:

- **`context/operations/starting.md`** — `set-gardeners.sh 100` → `20`, and "~100 is normal" → "~20 is normal".
- **`context/operations/scaling.md`** — "~100 workers is normal" → "~20 workers is normal".
- **`CLAUDE.md`** (job-system section) — "large pool of gardeners (~100)" → "pool of gardeners (~20)", the sizing norm the liaison/tutorial reads.

Left untouched, per the job's instruction, the purely descriptive "~100-gardener fleet" scale-context comments about historical contention/thundering-herd behavior in `designs/job-board.md`, `roles/watchman/AGENT.md`, and `docs/bulletin/DESIGN.md` — none present 100 as the recommended default.

No code/enforcement change: the value the scaler enforces is per-host journal state (`hosts/<host>`), set operationally via `set-gardeners.sh`; this job only changed the documented default.

Committed with an explicit pathspec and pushed to `main2` via rebase-CAS (`367a7543c..f8745a46e`).

No follow-ups.
