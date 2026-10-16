---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Fix the host usage meter undercounting finished monk jobs. Found by `oros-health-checkup-20261016-080509` on oros-studio-garden-ce242c49.

**Defect.** `_meter_session_total` (`scripts/jobs/usage-meter.sh`) sums billable tokens only from `*.jsonl` files still present under `$GARDEN_CCUSAGE_LOGDIR` (`~/.claude/projects`). On genuine completion, `scripts/jobs/handlers/monk-claude.sh` (around line 616) `rm -f`s the top-level session transcript, so the deterministic session id cannot be `--resume`d later. That is correct for resume safety, but every finished job's top-level tokens then drop out of the host's `budget/live/<pool>/<host>` `spend:`. Evidence on oros, 2026-10-16: spend held at about 85.5M (±0.1M, not monotone) from 06:47Z to 09:32Z while two monks ran continuously. Over the same span, Anthropic's own `rate_limit.seven_day.utilization` rose 0.38 → 0.39. Only 3 `.jsonl` files under `~/.claude/projects` had an mtime after 06:45Z. Several finished jobs' project dirs are gone or hold only `<sid>/` subdirs.

**Impact.** The claim gate is not affected: `status` reads `used_percent` from the utilization ledger, which is correct at 39%. Spend-based consumers do read a biased, non-monotone figure: `fit-quota-calibration.sh`, the accountant arc, `triager-pace.sh`, and the `spend/cap` status fallback when no utilization ledger row exists.

**Suggested fix (verify first).** Retire rather than delete. Move the finished transcript, keeping its mtime, to a meter-visible directory outside Claude's projects tree, for example `$GARDEN_STATE/retired-transcripts/<base>-<sid>.jsonl`. Have `_meter_session_total` scan it alongside the logdir; message-id dedupe already handles overlap. Prune retired files older than the longest window, about 8 days. Resume safety holds because `<sid>.jsonl` no longer exists under the project dir. Mention in the commit message that spend figures will rise toward the truth, since it shifts calibration inputs. Land on main2 with a test: a retired transcript is still counted inside the window and pruned outside it.
