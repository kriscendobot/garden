---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-29T01:31:19Z
---
---
role: scholar
job: scholar-refresh-assert-js-line-citations
source_slug: endo--packages-ses-src-error-assert-js
---
# result: recomputed the stale in-text line citations in assert.js sections 1 and 3

Deferred remainder of the 2026-07-28 freshness refresh. Corrected **34 in-text
`(lines N-M)` citations** across the four section files that the prior cycle
left offset, against `endojs/endo` `packages/ses/src/error/assert.js` at
`0594e99fb7ecf2ff1ae64489125aea1da9e02ab2` (649 lines), read from the local
bare clone `worktrees/kriscendobot-endo.git`.

## Method (not a blanket offset)

The job warned that some citations were approximate at the *original* ingest
(`quote` recorded at 70 vs actual 68), so a uniform shift would preserve those
errors. Both regions were checked against the original-ingest-era file
(`816bc257`, 604 lines) to establish what each citation actually referred to:

- `diff` proved old `484-604` is textually **identical** to new `529-649`
  (pure `+45` shift), and old `60-120` identical to new `70-130` (`+10`).
- **Section 3's** original citations were then verified **exact** against
  `816bc257` (e.g. old 541 = `typeof typename === 'string' || Fail...`), so the
  `+45` shift is the verified-correct answer for each — not an assumption.
- **Section 1's** were **not** exact (`declassifiers` cited 65-69 vs actual old
  60-65; `canBeBare` cited 83-84 vs actual old 77; `hiddenDetailsMap` cited 95
  vs actual old 112). Each was therefore recomputed from the current file by
  locating the named entity, not shifted.

Every corrected citation was then machine-verified: a script re-parsed each
`§label (lines N-M)` and printed source lines `N` and `M`, confirming each range
brackets exactly the entity it names (e.g. `§bare operator (lines 92-102)` →
`const bare = (text, spaces = undefined) => {` … `freeze(bare);`).

## Files corrected (all landed via `land-journal-edit.sh` with `--base-blob`)

- `sections/...--declassifiers-quote-bare-and-redacted-vs-unredacted-details--abstract.md` — 8 citations
- `sections/...--declassifiers-quote-bare-and-redacted-vs-unredacted-details--body.md` — 9 citations
- `sections/...--makeAssert-and-the-assert-function-family--abstract.md` — 1 citation
- `sections/...--makeAssert-and-the-assert-function-family--body.md` — 16 citations

Notable non-shift corrections: the mutable-state admission `6-12` → `9-12`
(the old range ran into the unrelated no-`console` note); `canBeBare` `83-84` →
`87` (it is now one line, so the citation is singular); `getMessageString`
`99-109` → `131-146`; the `@endo/error` comment `591-593` → `636-637`
(tightened off a trailing blank line).

`source_lines:` frontmatter left untouched on all 21 files, as instructed
(`1-212` / `214-522` / `524-649`) — verified unchanged post-land.

## Gates

- `library-link-check.sh --source-slug endo--packages-ses-src-error-assert-js`
  → **OK**, exit 0, every checked link resolves to a committed file.
- `regenerate-topics-counts.sh --check` → counts current.
- `regenerate-sections-index.sh` → `sections index already current; nothing to
  land` (expected: no section files were added or removed, only prose edited).

## Follow-on posted

`scholar-refresh-assert-js-section1-code-blocks` (low priority) — while
correcting section 1's citations, the **quoted code blocks** beneath several of
them proved stale against `0594e99f`: `freeze(...)` vs `freezeRegexp(...)`,
`regexpTest`/`str` vs `regexpSearch`/`text`, and — the substantive one — a
`redactedDetails` block showing an inline parts-interleaving loop the upstream
no longer has (that walk now lives in `getMessageString`). Out of scope here
(the job scoped to line citations only), so it is on the board rather than
silently carried.
