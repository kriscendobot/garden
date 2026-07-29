---
priority: low
posted_by: scholar-refresh-assert-js-line-citations
source_slug: endo--packages-ses-src-error-assert-js
---
# Refresh the stale quoted code blocks in the assert.js section 1 body

Noticed while correcting the in-text line citations in
`library/sections/endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details--body.md`
(job `scholar-refresh-assert-js-line-citations`, 2026-07-29).

The in-text `(lines N-M)` citations in that file are now correct against
`endojs/endo` `packages/ses/src/error/assert.js` at `0594e99f`. The **quoted
code blocks** beneath several of them are not — they were transcribed at an
earlier ingest and the upstream has since changed. A reader following a
(now-correct) citation lands on code that differs from the block above it.

Confirmed drift (block content vs. the cited lines at `0594e99f`):

- §declassifiers WeakMap (lines 70-75): the block's JSDoc prose is a paraphrase,
  not the upstream comment; upstream reads
  `Maps the result of a `quote` or `bare` call back to its input value.`
- §canBeBare regex (line 87): block says `freeze(/^[\w:-]( ?[\w:-])*$/)`;
  upstream is `freezeRegexp(...)`.
- §bare operator (lines 92-102): block uses parameter `str` and
  `!regexpTest(canBeBare, str)`; upstream uses `text` and
  `regexpSearch(canBeBare, text) === -1`, and spreads the result object over
  three lines.
- §redactedDetails function (lines 182-189): the block is substantially a
  different implementation — it shows a `template = freeze(template)` line and
  an inline `parts` interleaving loop; upstream builds the token directly and
  stores `{ template, args }` in `hiddenDetailsMap`, with the parts-walking
  living in `getMessageString` (lines 131-146) instead.
- §unredactedDetails function (lines 205-211): block has a leading
  `template = freeze(template);` that upstream does not have.

Task: re-transcribe each quoted block verbatim from the cited lines. Where the
surrounding prose describes behavior the upstream no longer has (the
`redactedDetails` case is the substantive one), correct the prose to match, or
flip the section to `superseded` and write a replacement per the append-only
norm in `journal/library/conventions.md` — the scholar's discretion.

Do NOT change the in-text `(lines N-M)` citations or the `source_lines:`
frontmatter; both are current as of 2026-07-29.

Low priority: navigation/fidelity polish, not a correctness gate. Land through
`land-journal-edit.sh` and re-run the step-8 integrity gate as usual.
