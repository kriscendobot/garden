Done. Here is my completion report.

---

**Job `improve-sections-table-row-insert-anchor` — complete.**

**What I did**

Built the work in an isolated worktree off `origin/main2` (the shared `/home/kris` tree is concurrently mutated), tested it, and pushed to `main2` (commit `5d81f1c40`, landed as `07a518328`).

**What changed (on `main2`)**

- **`scripts/jobs/insert-sections-table-row.sh <topic-file> <row>`** — a deterministic helper that parses a topic page's `## Sections` Markdown table and appends the new row immediately after the **last existing table row** (the `|`-leading line before the blank line that terminates the table), anchoring on the table boundary, **never** on a following heading. It locates `## Sections`, finds the first `|`-run after it, and inserts after that run's last line. Idempotent (an identical row leaves the file byte-for-byte unchanged); validates the row is a single pipe-leading line; preserves file mode; atomic swap.
- **`scripts/jobs/test/insert-sections-table-row-test.sh`** — 13 assertions across 7 cases: the regression (headingless see-also bullet list), an explicit `## See also` heading, table-to-EOF, idempotency, an empty table (header+separator only), the no-`## Sections` error, and malformed-row rejection. All pass.

**Verification**

Ran the test suite (13/13 PASS) and proved the fix against a copy of the live `journal/library/topics/pass-style.md` — the exact page from the 2026-06-28 erights-part-2 mis-placement. The new row landed at line 72, directly after the last table row (line 71), with the table-terminating blank line and the three headingless see-also bullets (74-76) untouched. The old "append at EOF after the bullets, outside the table" failure cannot occur via this path.

**Follow-up (posted as a job)**

`wire-scholar-to-sections-row-inserter` — the helper now exists, but the scholar still hand-constructs whole-file bodies. Wiring it to *use* the helper lives in `journal/library/conventions.md` (the scholar's always-read procedure doc) on the **journal2** branch, which must land via `land-journal-edit.sh` rather than a main2 push — a distinct branch/lander concern, so I scoped it out and queued it rather than bundling it. That follow-up is what actually displaces the recurring mis-placement at the source.

**Self-improvement:** confirmed `/tmp` is `noexec` on this host — direct execution of a script there returns exit 126; tests that invoke a script-under-test by path must call it via `bash "$SCRIPT"` to be mount-independent (the real garden tree under `/home/kris` executes fine).
