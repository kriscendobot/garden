Wire the scholar's library-ingestion procedure to USE
scripts/jobs/insert-sections-table-row.sh when adding a row to a topic page's
"## Sections" table, so the deterministic anchored inserter actually displaces
the agent-constructed whole-file body that caused the 2026-06-28 erights-part-2
mis-placement (pass-style.md, journal entry 161137Z).

The helper now exists on main2 (commit 5d81f1c40 / scripts: deterministic
Sections-table row inserter). What remains is the CONSUMER wiring, which lives on
the journal2 branch and so must land via land-journal-edit.sh, not a main2 push:

- journal/library/conventions.md is the scholar's always-read procedure doc (per
  the standing lesson: to make a role ALWAYS find a directive, put it in the doc
  it reads every job). Add to the per-source ingestion / topic-page procedure an
  explicit instruction: insert a Sections-table row with
  `scripts/jobs/insert-sections-table-row.sh <topic-file> "<row>"`, which anchors
  on the table's last row / terminating blank line — never on a trailing
  "## See also" heading (which is frequently absent). State the rule precisely so
  the agent does not hand-construct the whole-file body for a row insertion.
- Optionally cross-reference from roles/scholar/AGENT.md step 6/8 (README/index
  updates) if a pointer there reduces lookups.

Acceptance: a scholar reading conventions.md is told to call the helper for
Sections-table row insertion, and the headingless-see-also mis-placement cannot
recur from the documented path.

---
claim:
  host: endolinbot
  gardener: 41
  claimed_at: 2026-06-28T16:26:17Z
