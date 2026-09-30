Fixed and pushed to `main2` as `2dd04a517b5`. The cached-remote fallback and the leader-cache fallback now warn once per outage instead of on every tick. The new test and the related existing suites pass.

**What changed, all in `scripts/jobs/common.sh`:**
- **Two new helpers.** `fallback_warn <source> <msg>` keeps a per-source marker directory under `$GARDEN_STATE/fallback-warn/<source>/`. The first fallback of an outage logs the WARN. Later ones are only counted. If the fallback is still happening after `GARDEN_FALLBACK_ESCALATE_AFTER` seconds (900 by default), it logs one `ERROR:` line. `fallback_warn_clear <source>...` closes the marker and logs one "recovered" line with the suppressed count.
- **Stale markers.** If a marker's last fallback is older than the 900-second limit, it is treated as leftover and replaced with a fresh episode. An old marker that was never cleared therefore can't hide a new warning or trigger an instant ERROR.
- **journal_remote.** Its three fallback warnings (cache, root origin, per-instance clones) now go through `fallback_warn`. A successful direct read of the worktree origin clears all three markers.
- **leader_host.** The "leader fetch failed" warning goes through `fallback_warn`, and a successful leader fetch clears it.
- **Log levels.** `log()` now gives `ERROR*` lines journald's err level, the same as FATAL, so the one-time escalation shows up at error priority.
- **Behaviour otherwise unchanged.** The fallback order, cache writes, repair steps, the refusal of foreign origins and the error exits are exactly as before. Only the logging changed.

**Tests:**
- **New test.** `scripts/jobs/test/fallback-warn-dedup-test.sh` (14 checks) covers seven fallbacks producing one WARN, the suppressed count, the single escalation, recovery on a direct read, a new outage warning again, the leader fallback path, and stale-marker reuse. I added it to `.github/workflows/checks.yml`.
- **Existing suites.** `journal-worktree-relink-test`, `journal-remote-origin-rewrite-guard-test`, `repo-locks-test` and `main-host-test` all pass.
- **One unrelated failure.** `tests/checks/run.sh` still fails on `test_maintainer_inbox_information_hiding.sh`. It fails the same way on unmodified HEAD, so this change didn't cause it.

**Follow-ups:**
- The escalation is only a log line; it doesn't message the maintainer. If you want that, `alert_maintainer` could be hooked into the escalation step.
- Hosts pick this up on their next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-fallback-warn-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1705100 cached reads)
- Output: 17945 tokens
- Cost: $1.3297920000000003
- Wall-clock: 269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
