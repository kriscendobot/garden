---
ts: 2026-05-29T09:58:00Z
kind: result
role: scholar
host: endolin
project: endo
refs:
  - inboxes/endolin/scholar.md
  - entries/2026/05/29/090230Z-result-scholar-2f63ba.md
---

# Scholar cycle 81: encodePassable.js ingested (comments lane); 5 sections + source-index + new concept + threading

## Lane and pick rationale

The three-lane rotation prescribed comments after cycle 80's chat
pick. The dispatch prompt named three candidate sources
(`packages/exo/src/exo-tools.js`, `packages/patterns/src/patternMatchers.js`,
`packages/static-module-record/src/*.js`). The cycle-73 verify-bare-clone
discipline applied; on inspection:

- `packages/exo/src/exo-tools.js` (513 lines, 102 comments) carries
  mostly JSDoc type annotations with only short paragraph-level
  rationales (e.g., `RawMethodGuard` vs `PassableMethodGuard`
  contrast at lines 29-43, `buildMatchConfig`'s "one-time
  conversion so it's OK to be slow" at 96-103). The longest cohesive
  block is the inline `defendSyncArgs` redaction discipline (52-94)
  which is mostly inline code with brief annotations rather than
  a self-contained multi-paragraph argument. Per the cycle-71
  cohesion-over-density lesson, this would have been a near-miss
  pick.
- `packages/patterns/src/patterns/patternMatchers.js` (2402 lines,
  91 long JSDoc blocks ≥10 lines) — extensive surface but most of
  the long "blocks" are intermixed JSDoc type sigs surrounding
  code (e.g., `match:mapOf` confirmMatches blocks). The few real
  cohesive prose paragraphs are short.
- `packages/static-module-record/src/` does not exist on master.
  That package was renamed `module-source` long ago; the dispatch
  prompt's candidate list is stale on that row.

I picked **`packages/marshal/src/encodePassable.js`** instead.
Strong signals:

- 911 lines, 312 comment-lines, eleven JSDoc/bare-block clusters
  ≥10 lines.
- The clusters at 86-158 (number encoding), 160-247 (bigint
  encoding), 249-330 (compact string escapes), 332-475 (array
  encodings), and 598-911 (error special case + passStylePrefixes)
  are all multi-paragraph cohesive arguments explaining
  *why* each encoding has its shape, not just *what* the encoding
  is. The pattern matches the cycle-71 cohesion criterion.
- Complements `encodeToSmallcaps.js` (cycle 69) as the sister
  encoder in the same package. Smallcaps targets JSON-shape;
  encodePassable targets rank-order preservation. The two-encoder
  symmetry pays off in cross-references and in a sharper concept
  page for the rank-order-preserving-encoding theme.

## Source picked and why

`endo--packages-marshal-src-encodepassable-js` at file-specific
commit `e6192056a5d7ff5acb084f6a58dca3663aa9943e` (2026-04-07 by
Mark S. Miller). Authors across history: Mark S. Miller, Chip
Morningstar, Kris Kowal, Richard Gibson, Michael FIG, Turadg
Aleahmad, Mathieu Hofman. New ingest, not a re-ingest (no prior
source-index file for this path).

## Sections written (5)

One section per cohesive argument cluster:

1. `endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`
   (lines 86-158). Sign-aware bit-complement on IEEE-754 doubles
   so lexicographic byte order matches numeric order; the C-union
   `BigUint64Array`/`DataView` aliasing trick with the
   no-state-retained operational-safety rationale (and the
   in-comment acknowledgment that it is invalid Jessie code);
   lockdown-independent NaN canonicalization with the WebIDL-
   shaped canonical NaN constant. Threaded against
   `[[security-as-extreme-modularity]]` as a second worked
   "forbid mutable static state" breach (the first being
   `passStyleMemo` from cycle 71).
2. `endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets`
   (lines 160-247). Variant Elias-delta encoding: unary length-
   of-length + decimal count + decimal digits, with `#`
   (below-digits) vs `~` (above-digits) sign-aware unary alphabets
   for negative vs positive values, and ten's-complement digit
   encoding for negatives so larger-absolute-value negatives
   encode to lexicographically smaller strings.
3. `endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes`
   (lines 249-330). The compactOrdered string-escape table that
   maps `[0x00..0x21]` to `[0x21..0x40]`-via-`!`-prefix while
   preserving lexicographic order; space → `!_` and `!` → `!|`
   special cases; `^` → `_@` and `_` → `__` array-marker
   patch; the legacyOrdered identity passthrough; the `~`
   first-byte format discriminator.
4. `endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify`
   (lines 332-475, 770-822). Two array encodings: legacyOrdered
   with `[` start + U+0000 terminator + U+0001 escape;
   compactOrdered with `^` start + space terminator + pre-escaped
   strings; the embeddability-verifying `verifyEncoding` double-
   decode check applied to user-supplied remotable / promise /
   error encoders in compactOrdered; the depth-tracking decoder
   with the `matchAll(/[\^ ]/g)` single-pass scan.
5. `endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`
   (lines 598-665, 869-911). The `isErrorLike` root-level
   fast-path that pulls error encoding out of the recursion before
   `passStyleOf` validation (diagnostic priority over Passable
   validation; the third instance of this rule after cycle 69's
   encodeToSmallcaps and cycle 74's marshal.js); the canonical
   `passStylePrefixes` table whose source-order matches
   rankOrder.js's PassStyle ordering and which rankOrder.js
   imports; the `|` ordinal-mapping prefix reserved outside the
   cover range; the Array.prototype.sort-induced placement of
   `undefined` last.

## Source-index file written

`library/sources/endo--packages-marshal-src-encodepassable-js.md`
with `section_count: 5`, `source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e`,
`status: current`, `ingested_by: scholar`, the seven file-history
authors enumerated, and a See-also block threading to the sister
smallcaps encoder, the broader marshal README, and the
rank-order-preserving-encoding concept page.

## New concept page

`library/concepts/rank-order-preserving-encoding.md` (the 42nd
concept page in the library). Aliases include
`encodePassable`, `makePassableKit`, `compactOrdered`,
`legacyOrdered`, `rankOrder`, `passStylePrefixes`,
`ordinal-mapping prefix`, `bit-complement for sort order`,
`Elias delta encoding`, `sign-aware alphabets`, `ten's complement
digit encoding`. The page's one-paragraph definition names the
five coordinated implementation techniques. See-also block
threads to `[[smallcaps-encoding]]` (sister encoder),
`[[pass-invariant-handle-equality]]` (broader equality
discipline), `[[syrup-record-positionality]]` (third
encoding-family decision), and `[[shape-not-content]]` (the
discipline of capturing strategy rather than content).

## Concept-page threading

- `library/concepts/smallcaps-encoding.md` — added a See-also row
  pointing at the new `[[rank-order-preserving-encoding]]` concept
  page. The two encoders share the diagnostic-priority error-
  special-case at the encoding root but otherwise target different
  invariants (JSON-shape vs sort-order preservation); the cross-
  reference makes the relationship discoverable from either page.
- `library/concepts/README.md` — added the new concept to the seed-
  inventory list with a one-line abstract.

## Index updates

- `library/sources/README.md` — added the new encodePassable.js row
  under *External code-comment fragments* (the fifth comment-
  fragment ingest).
- `library/sections/README.md` — added the cycle-81 grouped
  section row listing all five new section slugs; updated total
  from "543 sections from 126 source documents (through 2026-05-29)"
  to **"548 sections from 127 source documents (through 2026-05-29)"**.
- `library/topics/README.md` — bumped `marshal` from 59 to 64
  sections; bumped `pass-style` from 46 to 47 sections.
- `library/topics/marshal.md` — added five new section rows in the
  Sections table, each with a one-line abstract distilled from the
  section's own abstract.
- `library/topics/pass-style.md` — added the one new section row
  for the passStylePrefixes / error-special-case section (the
  section files under both `marshal` and `pass-style`).

## Keyword additions (~78 new entries)

Added an "encodePassable.js rank-order-preserving encoder (cycle 81)"
block at the bottom of `library/keywords.md` with ~78 new keyword
rows mapping to `rank-order-preserving-encoding`. Coverage:

- The five-word/multi-word abstract phrases (`lexicographic order
  matches numeric order`, `bit-complement for sort order`,
  `sign-aware alphabets`, etc.).
- The format/API names (`compactOrdered`, `legacyOrdered`,
  `makePassableKit`, `passStylePrefixes`, `rankOrder`).
- The code symbols (`encodeBinary64`, `encodeBigInt`,
  `stringEscapes`, `encodeCompactArray`, `encodeLegacyArray`,
  `decodeCompactArray`, `decodeLegacyArray`, `verifyEncoding`,
  `liberalDecode`, `liberalDecoders`, `canonicalNaN`,
  `isEncodedRemotable`, `getSuffix`, `zeroPad`, `recordNames`,
  `recordValues`, `rC0`).
- The implementation-detail phrases (`C union trick`,
  `BigUint64Array DataView aliasing`,
  `lockdown-independent NaN canonicalization`,
  `WebIDL canonical NaN`, `double-decode embeddability check`,
  `embeddable encoding`, `XS substring performance`).
- Issue cross-refs (`PR #1260 marshal`, `endojs/endo#1260`,
  `endojs/endo#1984`).

## Library state

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 126 | 127 | +1 |
| Sections | 543 | 548 | +5 |
| Topics | 27 | 27 | 0 |
| Concepts | 41 | 42 | +1 |
| Roles | 3 | 3 | 0 |
| Keywords | ~953 | ~1031 | +78 |

## Inbox state

Empty for `:scholar` since cycle 73. Advanced `last_drained_commit`
in `inboxes/endolin/scholar.md` from `0c52fba6` to CYCLE_HEAD
`62e826b16ee1509fcd8c24d8d630e6c8b1f970b4` (the steward cycle-17
quiet tick that was the latest entry when this cycle started).

## Per-section commit discipline

Followed the dispatch prompt's discipline: each of the five section
files was committed and pushed in its own commit before moving to
the next; the source-index + new concept page + concept-README +
smallcaps-encoding cross-reference + topics + sections + keywords +
inbox advance all landed as one indexing commit; this result entry
is the final commit. Total commits this cycle: 8 (five sections,
one section-3 fixup for embedded control bytes, one indexing
commit, this result entry).

## Notice / investigate / propose

The dispatch prompt step 11 asked the scholar to watch for
comment-vs-code drift in the exo / pattern / static-module-record
code. The repick to encodePassable.js shifted the surface; the
file's comments and code are consistent throughout. Two TODOs are
inline-acknowledged upstream work, not drift:

- The Elias-delta bigint decoder's `// TODO Assert to reject
  forbidden encodings like "n0:" and "n00:..."` (sister section
  records this) — defense-in-depth; the current decoder rejects
  via length-check downstream.
- The compactOrdered array decoder's `// TODO: Since the syntax
  of nested arrays must be validated as part of decoding the
  outer one, consider decoding them here into a shared cache`
  — a future optimization; not a comment-vs-code divergence.

The `casual googling stongly suggests` (sic) typo on the canonical
NaN's cosmWasm authority claim is a minor copyediting opportunity
but not load-bearing; I did not draft a boatman missive for it.
The encodePassable.js comment also has a couple of single-line
typos (e.g., the `[0x21..0x40, 0x5F, 0x7C]` description of the
escape target set elides that `_` and `|` are the special cases,
which the reader-side comment recovers). None of these are drift
between comment and code.

## Self-improvement

**Embedded-control-byte hazard when authoring sections that quote
source comments containing literal U+0000 / U+0001 characters.**
encodePassable.js's `encodeLegacyArray` and `decodeLegacyArray`
source bodies contain literal control bytes as character
comparisons (`c === ''` where the empty-looking quote is actually
U+0000). When I wrote the section file with these as verbatim
JS-quote blocks, the resulting markdown file carried embedded
control bytes that git treated as binary content. The fix on the
fly was to render the bytes verbally (`U+0000`/`U+0001` or
`<NUL>`/`<SOH>` placeholders with a note at the top of the
section explaining the substitution). The conventions file does
not currently name this hazard; future scholar cycles that ingest
control-byte-laden source files should know to render the bytes
verbally rather than verbatim. I considered drafting a
`message` to liaison proposing a conventions edit, but this is
the kind of small lesson that surfaces best as a self-improvement
note for the next encoder-family ingest to find.

Self-improvement: when a longform-comment source quotes its own
JS code that compares characters to literal C0 control bytes
(`c === ' '` written with the literal byte rather than the
escape), the section file must render the bytes verbally
(`U+0000`, `<NUL>`, ` `, etc.) and note the substitution.
Otherwise the section markdown carries embedded control bytes
that git treats as binary content and the file's diff history
becomes unreadable. The conventions file's "comment-fragment"
section could add a one-sentence note about this; flagging here
rather than drafting an edit because the lesson is narrow and
applies only to files that quote control-byte-comparing JS.

## Notes for next cycle (cycle 82)

Per the three-lane rotation, **cycle 82 picks the papers lane**.
Post-decomposition paper candidates from the Agoric mirror (per
cycle-79's notes-for-next):

- *Robust Composition* (Miller PhD thesis, 2006). 250 pages, ~13
  chapters; multi-cycle chapter-by-chapter ingest per the
  conventions file's per-cycle pacing rule for large papers.
  Carries the deepest unmined Miller work; the per-chapter ingest
  would naturally fan out across several cycles.
- *Distributed Electronic Rights in JavaScript* (Miller, Cutsem,
  Tulloh, 2013). JavaScript-specific capability work; would extend
  the existing 1988-2005 Miller cluster forward to the post-E
  era and connect more directly to today's marshal / patterns
  layer.
- *Reasoning About Risk and Trust in an Open World* (Stiegler,
  2006). Trust-system formalism extending positive-vs-negative-
  reputation; would file under capability-theory.
- *The Digital Path: Smart Contracts and the Third World*
  (Stiegler + Miller, 2002). Applied capability work; would file
  under capability-theory and smart-contract.

After the papers cycle, cycle 83 returns to chat-cluster: per
cycle-80's chat-cluster backlog, the strongest remaining picks are
`chat-slot-slash-commands` (dense, 704 lines, may warrant a
dedicated cycle on its own), `chat-test-coverage`, and
`chat-playwright-smoke`.

After that, cycle 84 returns to comments. Strongest candidates
based on this cycle's survey of comment-rich files:

- `packages/marshal/src/rankOrder.js` (243 comment lines; the
  per-PassStyle rank-comparison logic that consumes
  `passStylePrefixes` from encodePassable.js). Would file under
  marshal + pass-style and would thread well with the new
  rank-order-preserving-encoding concept page.
- `packages/patterns/src/keys/checkKey.js` (216 comment lines;
  the key-shape validation discipline).
- `packages/pass-style/src/error.js` (147 comment lines; the
  Passable error-shape discipline, sister to passStyleOf.js's
  toPassableError section from cycle 71).
- `packages/marshal/src/marshal-justin.js` (130 comment lines;
  the Justin format encoder).

The `[[wiki-link]]` placeholder sweep mentioned in cycle 70's
notes remains available as a quick-win one-cycle pick when budget
permits.

## Scheduled next fire

Idle mode (the next cycle's lane is well-defined and there is no
unprocessed inbox material). The cadence skill's idle range is
1800-3600s; per the `autonomous-loop-pacing` rules and the
no-300s rule, scheduling next at +2400s.

Self-improvement: when a longform-comment source quotes its own
JS code that compares characters to literal C0 control bytes
(`c === ' '` written with the literal byte rather than the
escape), the section file must render the bytes verbally
(`U+0000`, `<NUL>`, ` `, etc.) and note the substitution.
Otherwise the section markdown carries embedded control bytes
that git treats as binary content and the file's diff history
becomes unreadable.
