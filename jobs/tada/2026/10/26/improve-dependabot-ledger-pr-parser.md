**Report: improve-dependabot-ledger-pr-parser**

The ledger parser fix is pushed to `main2` as 045584288e1. The preflight test suite passes 46/46. The two new regression fixtures fail on the old parser and pass on the new one.

**The bug.** The parser at `scripts/jobs/dependabotany-preflight.sh:256-287` bound each `EMBARGO-YYYY-MM-DD` date to the first `#<number>` on the same line, or failing that, the first anywhere in the entry. The botanist's line `- Row: EMBARGO-2026-10-26 … tred -> #1546` therefore made the CI-fix PR #1546 a Dependabot ledger row.

**The fix.** The parsing now lives in a new `ledger_entry_embargo_rows` function, a single awk pass that runs under mawk. It reads each entry as records: a line plus its indented continuation lines. Each embargo date binds to the first of these that applies:
1. A PR reference right next to the date, such as `#197 (EMBARGO-…`, `PR #1553 — EMBARGO-…`, a table cell holding a pull URL, or a reference whose open parenthesis contains the date.
2. The PR named at the start of the list item or table row.
3. A reference in the record that is in the entry's structured set. That set comes from `pr:` lines, pull URLs under `prs:`, labelled `PR:` lines, and the PRs named in the first H1 heading.
4. The first PR in the structured set.
5. The first PR in the entry bound by rule 1 or 2.
6. `unknown`.

A bare `#N` anywhere else no longer binds outside the structured set. The rest of the gate is unchanged: the drain fold, per-PR terminal markers, sorting and due-ness.

**Check against the real ledger.** I ran the old and new parsers over all 36 journal entries that contain an embargo date. Only two results changed, and both are corrections:
- `2026/10/25/204040Z-…3491f2`: the #1546 row is gone; that line now binds to #1553.
- `2026/08/19/021706Z-…430202`: the old parser bound a wrapped row's date (the `EMBARGO-2026-08-21` line under `#1007`) to #1005. It now binds to #1007.

**Tests.** Two cases were added to `scripts/jobs/test/dependabotany-preflight-test.sh`:
- The incident shape, with unrelated cross-references to #1546 and #1542 (bare, `PR #`, and URL forms). Only the #1553 row should appear.
- A multi-row sweep with no structured set: row labels, a date on an indented continuation line, and a `#197 (EMBARGO-…)` reference. Each date must bind to its own PR and the cross-references must not appear.

**Follow-ups:** none. The new parser applies on each host's next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-ledger-pr-parser.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1387551 cached reads)
- Output: 23888 tokens
- Cost: $1.4345822000000004
- Wall-clock: 260s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
