---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Garden repo (main2). Found by `oros-health-checkup-20261013-133505` on 2026-10-14.

**Defect.** The first `inbox-read.sh` for a new doer id spends about 13 minutes on oros-studio-garden-ce242c49 deepening its freshly seeded shallow per-id journal clone (`journal_deepen_from_root`, called from `sync_clone`, scripts/jobs/common.sh). Neither inbox-read nor a canary probe needs journal history. The canary probe's no-LLM round trip (`gardener.sh` canary-probe branch → `inbox-read.sh "$base"`) therefore misses the rolling-deploy's 600s deadline. The leader fails a healthy canary and roll-drains oros.

Evidence (oros journald, 2026-10-14):
- 03:25:25 monk-2 claims `canary-probe-oros-studio-garden-ce242c49-e1e898bdc9d4-r2`; the claim fixes aba64ba1/e1e898bd work.
- 03:25:55 inbox-read seeds a shallow clone from the local root repo.
- 03:36:31 "could not complete shallow journal clone … from local root repo".
- 03:39:31 "deepened journal clone … to the shallow root repo's boundary; it stays shallow".
- 03:39:33 "completed canary probe". Meanwhile the leader drained oros at 03:35 ("did not reach tada within 600s").
- The root repo is itself shallow (`.git/shallow` has 1 line), so the deepen can only reach the root's boundary anyway.

**Ask.** Keep history-free readers off the deepen path: at minimum inbox-read's per-id clone and the canary-probe path. Options include an opt-out env honored by `sync_clone`, or deferring the deepen to a background or later sync. Add a test in scripts/jobs/test/ showing that a fresh inbox-read clone does not run `--unshallow`, and keep the existing history-walking readers correct. Land on main2.
