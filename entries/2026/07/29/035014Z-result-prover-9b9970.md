---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-07-29T03:50:15Z
---
Prover seat, PR endojs/endo-but-for-bots#881 ("feat: add attenuated Google Sheets facets"),
diff base 03e9aec6089699e7f780f2382d52161c3c36aa04, head 789fbe386a443c67149f39122765937c3e790b40.

### prover

**Verdict:** request-changes

**Findings:**

- **must-fix** — `part()`/`sheet()`/`range()` *widen*, and no test pins that they
  narrow. `src/powers.js:268` (`narrow: patch => at({ ...scope, ...patch })`)
  *replaces* the scope key instead of intersecting it, and `narrow` is reached from
  guest-callable exo methods (`src/facets.js:179-183`, `:202-206`, `:226-230`,
  `:266-270`). Verified against the built facets under `@endo/init`: a guest handed
  `spreadsheet.sheet('Tasks').range('A1:B2')` is refused `read('C1')` but ADMITTED
  `range('A1:Z999').read('Z999')` -> `get Tasks!Z999`, and `sheet('Salaries').read('A1')`
  -> `get Salaries!A1`; likewise `part('Salaries')`. Same on the write side:
  `writer.part('Tasks!A1:B2').writeOnly().range('A1:Z9').write('Z9', ...)` -> `update Tasks!Z9`.
  `test/exo-google-sheets.test.js:87-94` and `:118-125` assert only that narrowing never
  widens the *verb* axis, so the suite reads as though the scope axis is pinned when in
  fact every assertion passes with the hole present. `README.md:73` ("Narrowing mints,
  never masks") and `designs/exo-google-sheets.md:113` ("a narrower whole of the same
  authority class") are load-bearing prose claims with no backing test, and they are
  currently false. [rule: skills/regression-evidence/SKILL.md § Equivalence claims need a backing test]

- **must-fix** — Range confinement fails **open** on any selector `parseA1` cannot parse.
  `src/powers.js:130-135` guards the containment check with `parsed &&`, so a facet scoped
  to `Tasks!A1:B2` reads, overwrites, and erases whole columns and rows: verified
  `granted.read('A:Z')` -> `get Tasks!A:Z`, `granted.read('1:999')` -> `get Tasks!1:999`,
  `granted.write('A:Z', ...)` -> `update Tasks!A:Z`, `granted.clear('A:Z')` -> `clear Tasks!A:Z`.
  Note the internal inconsistency that makes this a defect rather than a policy choice: the
  `allowedRanges` check at `:140-153` fails **closed** on the very same unparseable input.
  Every scope test uses the bounded selector `C1` only, so nothing reddens.
  [rule: skills/adversarial-tests/SKILL.md § Boundary]

- **should-fix** — Execution-untested surfaces the PR body and README claim. No test performs
  a *successful* `append` or `clear`, so those confinement paths are never exercised on the
  happy path: delete `access.admit(...)` from `makeAppendPowers.append` (`src/powers.js:315`),
  removing append's confinement entirely, and the suite stays green. `writeBatch` and
  `readBatch` are never invoked at all (`test:80`, `:84` assert only their *absence* on the
  facet that lacks them). `sheets()` never returns a non-empty list (client stub `test:41`
  returns `sheets: []`), so the `gridProperties` mapping at `src/facets.js:115-121` has zero
  coverage. Untested controls: `setAllowedRanges`, `setMaxCellsPerRead`,
  `setMaxRequestsPerMinute` and its `Math.min(tokens, value)` clamp (`src/powers.js:196`),
  and the `maxCellsPerRead` cap itself. [rule: skills/coverage-driven-testing/SKILL.md]

**Notes (out of scope but worth flagging):**

- comment-only — The throttle test (`test:257-265`) leaves `now` at the wall-clock default
  even though `src/powers.js:78` documents the injection point as existing for exactly this.
  A fake clock would also let the test pin *refill*, which nothing currently does.
  [rule: skills/regression-evidence/SKILL.md]
- comment-only — `confine` composes `Tasks!Other!A:Z` for an unparseable cross-tab selector
  under a sheet scope (`src/powers.js:136-139`). The API will reject it, so it is not an
  escape, but it is a malformed designation reaching the client rather than a refusal at the
  boundary. [proposed-rule: a confinement check that cannot parse its input must refuse, never construct a designation it did not verify]

Method: the facets were exercised directly (workspace packages symlinked, `@endo/init/debug.js`
lockdown, stub client recording every call). Each admitted/refused line above is observed
output, not inference.

Self-improvement: the recurring shape here is a scope-narrowing API whose `narrow` merges a
patch — the widening hazard is invisible at the call site and the natural test (narrow once,
probe one out-of-scope selector) passes with it present. Worth adding to
`skills/adversarial-tests/SKILL.md` as an attenuation category: for every narrowing verb,
test that re-applying it with a *wider* designation is refused, and that a designation the
parser cannot read is refused rather than admitted.
