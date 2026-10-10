The Pools section of `scripts/jobs/accountant-statement.sh` now estimates each pool's unattributed spend, and it's pushed to main2 as commit `9326040281f`. The hermetic test passes (39 passed, 0 failed), and a read-only run against the live journal gives the figures below.

**What the statement shows now.** The Pools table has three new columns, followed by a one-line "Method:" note:
- **used tokens (est.):** the pool's ceiling × used %, so it counts every caller on the account.
- **arc-charged:** the token total (input + output + cache creation) of usable ledger rows that carry an arc. Only rows on the pool's own hosts (from `config/subscription-mapping`) and its own provider count, back to the pool's last reset. Rows that don't record a provider are assigned one from the model name (`claude*` → anthropic, `gpt`/`codex`/`o<digit>` → openai). Lines that can't be parsed are skipped rather than voiding the sum.
- **unattributed (est.):** the difference, with its share of used tokens. It shows `0` if the arc rows exceed the estimate.

Arc spend could be split by pool, so no fleet-wide fallback was needed. The statement is still read-only and deterministic.

**Live run:**

| pool | used % | used tokens (est.) | arc-charged | unattributed (est.) |
| --- | ---: | ---: | ---: | ---: |
| claude-endolin1 | 27 | 73.1M | 5.1M | 67.9M (92%) |
| claude-endolin2 | 1 | 1.6M | 0 | 1.6M (100%) |
| claude-oros | 11 | 19.8M | 628.6K | 19.1M (96%) |
| codex-endolin | 75.0 | - | 0 | - |

The claude-endolin1 row matches the gap the maintainer proxy described (about 73M used, about 5M charged to arcs). codex-endolin has a percent ceiling rather than a token ceiling, so it gets no token estimate.

**Other changes:**
- **Tests:** `scripts/jobs/test/accountant-arc-apportionment-test.sh` now covers the new columns. The fixture includes a row from before the reset, one from another host, an untagged row, an unparseable line, and a percent-ceiling pool.
- **Docs:** `context/operations/accountant.md` describes the new columns and their limits.

**Limits:**
- The estimate is only as accurate as each pool's ceiling calibration. The ceilings are manual figures that have disagreed by about 3× before.
- Usage rows with no arc, or recorded with `source: none`, count as unattributed.
- A full statement run took about 15 seconds against the live journal.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-accountant-statement-unattributed-share.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1963520 cached reads)
- Output: 12886 tokens
- Cost: $1.3018240000000003
- Wall-clock: 277s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
