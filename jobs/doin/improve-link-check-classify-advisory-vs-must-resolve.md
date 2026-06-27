Harden `scripts/jobs/library-link-check.sh` so the standing scan's red signal stays actionable. The hourly scholar cycle uses `--all`, which walks every markdown file (including leaf section bodies via the `find ... -name '*.md'` work-list at line ~296) and conflates ~166 perpetually-dangling verbatim section-body links with the genuinely-broken nav/index/source-table links into one saturated FAIL count. The `--nav` scope already isolates the must-resolve set (scholar-authored index pages + sections/README.md + library README.md, excluding leaf bodies). Change: in `--all`, classify each dangling link by its source file — must-resolve (nav/index/source-table/cross-reference rows) vs advisory (verbatim leaf section-body links) — and tally + exit separately: nonzero only when a must-resolve link dangles, with advisory dangling reported as a separate informational count. Update the help text at line ~41 (which already claims `--all` "Excludes leaf section bodies" — that is false today, a doc/behavior divergence) to match. This lets the standing `improve-deterministic-section-link-integrity-scan` wrapper surface real navigation breakage instead of a number that is red every cycle by construction.

---
claim:
  host: endolinbot
  gardener: 69
  claimed_at: 2026-06-27T11:36:04Z
