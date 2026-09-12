---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-12T04:22:19Z
---
---
project: endo-but-for-bots
role: botanist
---
# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-12 recheck sweep (no row due)

Job `dependabotany-recheck-endo-but-for-bots-20260912-042007`. Re-derived the cumulative ledger with the recovery grep and reconciled every historical embargo/escalation row against live GitHub, not stale rows.

## Active due rows
None. The live open `dependabot[bot]` PR census is empty (`gh pr list --repo endojs/endo-but-for-bots --author app/dependabot --state open` returned `[]`), so there is no open proposal on which a due embargo verdict can be executed. The most recent Dependabot set (`--state all`, PRs #1168–#1174 from the 2026-09-06 run) is entirely terminal; nothing newer has been proposed.

## Historical rows re-confirmed terminal (live re-fetch)
- **PR #1168** (`zizmorcore/zizmor-action` 0.6.2 → 0.6.3) — `EMBARGO-2026-09-06` row superseded by terminal **MERGE-NOW**. MERGED, merge commit `f3cf70225460d8dc62612534a934b3593a333d32`, since 2026-09-06T22:34:48Z.
- **PR #1170** (grouped all-minor-patch, 21 updates) — terminal **MERGE-NOW**. MERGED, merge commit `ca0d709b9721600b0eaad410a18c6b52f9d1af5c`, since 2026-09-07T00:00:05Z.
- **PR #1174** (`better-sqlite3` 12.11.1 → 13.0.3) — HELD/escalation row superseded by terminal engine-compatibility **REJECT** (`better-sqlite3@13.0.3` declares Node `>=22`; project advertises `^20.17.0 || >=22.9.0`). CLOSED without merge at unchanged head `c040390092c18eab33e943d9848028ebf0b469cd` since 2026-09-07T04:29:04Z.
- **PR #923** — terminal **REJECT** (stale all-minor-patch group partially reverting the base). Remains CLOSED without merge since 2026-08-10T21:25:33Z.
- Older embargo rows (#197, #362, #868, and the 2026-07/08 action/npm sets) are all recorded terminal in prior entries; none reopened.

## Schedule state
- Daily backstop `dependabotany-recheck-endo-but-for-bots` present, `cadence: daily`, `preflight: dependabotany-preflight.sh` attached, `last_dispatched: 2026-09-12T04:20:07Z` (this job). Retained — the standing safety net.
- No precise one-shot recheck schedules remain (each self-deletes on fire). None orphaned.

## Disposition
No conduct, close, embargo, shepherd, or re-review action taken or needed: the embargoed set is empty and every historical row is terminal. Sweep clean.
