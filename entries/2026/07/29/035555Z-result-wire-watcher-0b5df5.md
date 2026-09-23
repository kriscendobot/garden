---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-07-29T03:55:57Z
---
# result: wire-watcher, PR #881 (endojs/endo-but-for-bots)

Dispatch: panel seat `wire-watcher`, PR https://github.com/endojs/endo-but-for-bots/pull/881
("feat: add attenuated Google Sheets facets"), diff base `03e9aec6`.

### wire-watcher

**Verdict:** request-changes

`parseA1` is a security parser — the only thing between a confined facet and
the whole spreadsheet. It returns `undefined` for anything that is not a plain
bounded rectangle, and `confine` reads that as *no objection* rather than
*cannot decide*. All three escapes are reproduced against the real code.

**Findings:**

- **must-fix** — `src/powers.js:130-135`: the range-scope containment check is
  guarded on `parsed`, so any selector `parseA1` cannot model skips it. Scope
  `{range:'A1:B2'}` admits `A:ZZZ`, `A1:C`, `1:1000`, and the named range
  `Budget`, forwarded verbatim to the client. End-to-end through the real power
  objects: a reader confined to `Tasks!A1:B2` issues `get Tasks!A:ZZZ`; a write
  power confined to `A1:B2` issues `clear A:ZZZ` — unbounded disclosure and
  unbounded erasure. `designs/exo-google-sheets.md:261` lists `'A:A'` as a valid
  range form, so this is the documented happy path, not malformed input. The
  `allowedRanges` branch (`powers.js:140-153`) rejects these same inputs because
  it requires `parseA1(full)` to succeed — the discipline is present in one
  branch, missing in the other. Fail closed: under a non-empty scope, an
  unparseable selector must throw.
  [proposed-rule: a confinement check that cannot parse its input must reject
  it; a parser returning `undefined` is a refusal to decide, never an approval.]

- **must-fix** — `src/powers.js:126` with `src/a1.js:73-77`: a range scope that
  names a tab does not confine the tab. `contains` ignores sheet names
  ("callers decide"), and this caller does not — the sheet check keys on
  `scope.sheet`, which `range()` never sets. So `reader.range('Tasks!A1:C10')`
  admits `Secret!A1:B2`: same rectangle, any tab. `part('Tasks!A1:C10')` is safe
  only because `partScope` sets both axes (`a1.js:114-116`); `range()`
  (`facets.js:183`) is the exposed hazard. Compare `scopeRange.sheet` against
  the resolved sheet. [rule: designs/exo-google-sheets.md § Ranges — "rejects
  ranges naming any other tab"]

- **should-fix** — `src/a1.js:46-51`: when the cells part is not a rectangle,
  `parseA1` discards the sheet the selector *did* name. Under `{sheet:'Tasks'}`
  with `setAllowedSheets(['Tasks'])`, `Secret!A:C` re-derives its sheet from the
  scope, passes the allowlist on a tab it never named, and is sent as
  `Tasks!Secret!A:C` — one string, two meanings. Lex the sheet part
  independently of whether the cells part parses.
  [rule: skills/adversarial-tests/SKILL.md § parser divergence]

- **should-fix** — `test/exo-google-sheets.test.js`: every confinement test uses
  a well-formed rectangle (`C1`, `Other!A1`), so the escapes above are not just
  unfixed but untested by omission. Add the syntactically-valid non-rectangular
  family — `A:ZZZ`, `A1:C`, `1:1000`, a named range, `Secret!A:C` — plus a case
  pinning `range('Tasks!A1:C10')` against another tab.
  [rule: skills/adversarial-tests/SKILL.md § failure-mode catalog]

**Notes (out of scope but worth flagging):**

- **comment-only** — `src/facets.js:128-142`: `readRecords` uses
  `Object.fromEntries`, so duplicate headers silently collapse to the last
  column; a records reader and a raw-values reader then disagree about the same
  row. `__proto__` as a header is safe (own property), worth one test to keep it
  so. [rule: skills/adversarial-tests/SKILL.md § parser divergence]
- **comment-only** — `src/powers.js:159-165`: `boundCells` caps disclosure after
  the fetch, not the request, so `maxCellsPerRead` bounds no API cost — only the
  token bucket does. Worth saying in the docstring.
- Charging the throttle before the confinement check (`powers.js:227-230`) is
  right — a prober pays for rejected probes. Revocation, the granted-timer
  discipline for `follow`, and the no-globals claims hold as written;
  `facets.js` greps clean for `client`, `access`, and `revoke`.

Self-improvement: this seat's "check before trust" axis is written for bytes
that get evaluated, and read off-target against a *designation* parser where
nothing executes. The sharpening: the axis applies whenever a parse result gates
an authority, and the tell is a truthiness guard on a parser's output —
`if (parsed && …)` inside a check is fail-open by construction. The companion
tell, worth carrying forward: one integrity check implemented twice in a single
function where only one copy handles the parse failure.
