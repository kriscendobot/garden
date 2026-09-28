The per-host disposition report is on `journal2`, and I confirmed it can be read back.

- **Path:** `reports/host-disposition-2026-09-28.md`
- **Commit:** `58008fb5e9db274d6461a7e5812b80ad3172e0f2`
- **URL:** https://github.com/kriscendobot/garden/blob/journal2/reports/host-disposition-2026-09-28.md

I wrote it through the producer clone with the `ensure_clone`/`sync_clone`/`commit_and_push` retry loop, not by editing the live `journal/` worktree. After a fresh fetch, `origin/journal2:reports/host-disposition-2026-09-28.md` matched the file I wrote byte for byte. One deviation from the spec: I ran that check in the producer clone instead of `git -C journal`, because my instructions forbid running git in the garden root, and `journal/` shares that repo. Both read the same `origin/journal2`.

**Headline completion rates** (completions ÷ claims; fleet average is 53% over 24h and 72% over 7d):

| host | 24h | 7d | pattern |
| --- | --- | --- | --- |
| endolin-garden-ece02cb4 (best) | **93%** (125/134) | **91%** (304/334) | 0 terminal failures in 24h; healthy baseline |
| endolin-garden2-5bcdff64 | **37%** (69/187) | 66% (267/402) | 111 terminal failures in 24h, all in the monk pool: monks complete 30% of claims, clerics 87% |
| oros-studio-garden-ce242c49 (worst) | **26%** (21/81) | **25%** (22/88) | 58 transient kills vs 2 terminal failures; no claims since about 2026-09-27T17Z (idle or offline now) |

**Notable:**
- **garden2:** terminal failures peaked on 2026-09-27 between 12:00 and 20:00Z (about 100), but have not stopped. There were 6 more between 01:00 and 05:00Z today, and garden2's monk completion rate over the last 6h is still 57%. It may be worth a check that its credentials fix is complete.
- **oros-studio:** it still declares `monks: 4` in `hosts/` but has been silent for about 13h, so it is either offline or stuck.

**What I built:**
- **Report tool:** a reusable script, `scripts/jobs/host-disposition-report.py`, pushed to `main2` in commit `3771b615390`. It only reads the journal clone and takes the windows as an option (`--windows 6h,24h,7d`), so anyone can regenerate the report.
- **Host discovery:** it finds hosts from claim commits and the jobs currently in progress, not from a fixed list.
- **Per-kind table:** besides the main table, it follows each claim to what happened to it next, broken down by host and worker kind. That table is what shows garden2's failures are confined to its monks.
- **Commit formats:** all four message shapes in the job spec still hold. One difference: completion commits name the worker as `<host>/gardener-N`, not by kind, so the kind breakdown comes from claim commits.

As the spec asked, I haven't diagnosed either failing host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/report-host-disposition-20260928.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (856298 cached reads)
- Output: 11254 tokens
- Cost: $0.8954516
- Wall-clock: 157s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
