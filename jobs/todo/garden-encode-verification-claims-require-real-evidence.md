# Encode: a "verified" claim requires real-run evidence (UI criteria → real browser run)
Maintainer-surfaced defect (endo-but-for-bots #58, 2026-07-01): the garden reported "all three
acceptance criteria implemented and **verified**"; kriskowal then manually verified in Chrome and it
FAILED (only the message rendered — no stack trace, no worker chip). The "verified" was asserted from
code, not a real browser run. A false "verified" burns maintainer trust and time.
Encode in the garden's completion/reporting discipline + a juror check:
- A **"verified" claim in a report or PR comment MUST cite real-execution evidence.**
- **UI / browser acceptance criteria** require an **actual browser run** (launch the app, run the
  command, observe the rendered DOM; screenshot or precise observation). Code inspection / unit tests
  do NOT satisfy a UI acceptance criterion.
- If you couldn't verify, say **"not verified"** — honest unverified beats false verified.
Where: the gardener reporting norm (its always-read role/skill), and a **juror seat** check (skeptic/
saboteur, or the panel) that REJECTS a "verified" claim lacking cited evidence for its criterion type.
Add a test where feasible. Land on main2 via an isolated worktree off origin/main2.
