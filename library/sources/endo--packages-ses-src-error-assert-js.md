---
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
ingested: 2026-06-01
ingested_by: scholar
section_count: 3
status: current
notes: |
  Eleventh comment-fragment ingest. Richard Gibson's most-recent
  authorship of SES's *assert* module — *the* substrate that holds
  the canonical `assert`, `Fail`, `details` (`X`), `quote` (`q`),
  `bare` (`b`), and `loggedErrorHandler` that the rest of the @endo
  codebase imports. The file is unusual in admitting *up front* in
  its header that it carries *top-level mutable state, observable
  to any code that has access to the loggedErrorHandler*; this
  candor-with-narrow-gate is the section-1 organizing rationale.
  Three argument-cluster sections capture: (1) the redaction
  discipline — declassifiers WeakMap + quote/bare + canBeBare
  regex + DetailsToken + redactedDetails (the `X` tag) vs
  unredactedDetails (`errorTaming: 'unsafe'`); (2) the rendering
  machinery — getLogArgs unquoting + console-substitution space-
  trimming, hiddenMessageLogArgs WeakMap, errorTagNum + tagError
  cross-reference (`Error#3`), sanitizeError moves host-added
  own-props to a note annotation, makeError factory, note + 
  hiddenNoteCallbacks streaming-annotation mode, defaultGetStackString
  non-privileged fallback, and the canonical `loggedErrorHandler`
  bridge object cycle 96's console.js consumes; (3) the user-
  facing surface — makeAssert factory with optRaise + unredacted
  flags, fail + Fail (one-line-throwing-template-literal idiom),
  the base assert and assert.equal (RangeError default) /
  assert.typeof (recursive-assertion idiom) / assert.string, the
  assign-then-freeze finalization pattern, and the module-level
  re-exports (`X`, `q`, `b`, `annotateError`, `assertEqual`,
  `makeError`). This source *completes* the SES causal-console
  bridge by exporting the `loggedErrorHandler` that cycle 96's
  console.js imports — cycle 90 (track-turns) produces annotations,
  cycle 93 (tame-v8) provides getStackString, cycle 96 (console.js)
  renders, and this cycle (assert.js) holds the state and exposes
  the bridge.
---

> Abstract: `packages/ses/src/error/assert.js` is SES's *assert*
> module — *the* substrate that holds the canonical `assert`, `Fail`,
> `details` (`X`), `quote` (`q`), `bare` (`b`), and `loggedErrorHandler`
> that every @endo and SES module imports. The 604-line file is
> unusual among @endo packages because it admits up-front that it
> carries *top-level mutable state, observable to any code that has
> access to the `loggedErrorHandler`*; the *intentional, narrow-gate*
> exposure is documented at the file header so a reader is told the
> exception up-front. The §redaction-discipline opens with the
> `declassifiers` WeakMap, `quote` (returns a frozen wrapper whose
> `toString` invokes `bestEffortStringify`), `bare` (returns input
> verbatim when it matches the `canBeBare = /^[\w:-]( ?[\w:-])*$/`
> regex, else falls back to `quote`), the `DetailsToken` prototype
> with `hiddenDetailsMap` for unobservable substitution storage, the
> default `redactedDetails` (`X`) template tag that produces type-
> tag substitutions like `(a TypeError)`, and the `unredactedDetails`
> variant used by `errorTaming: 'unsafe'` mode. The §rendering-
> machinery covers `getLogArgs` (unquoting + console-substitution
> space-trimming since the console inserts its own argument-separator
> spaces); `hiddenMessageLogArgs` WeakMap; `errorTagNum` counter +
> `tagError` (`Error#3` cross-reference); `sanitizeError` (strips
> host-added own-properties — V8 `stack` getter, non-V8 `fileName`/
> `lineNumber`/`columnNumber` — and preserves them as a `note`
> annotation); the `makeError` factory with AggregateError special-
> casing; the `note` function with `hiddenNoteCallbacks` for the
> streaming-annotation-after-the-first-log mode; the unprivileged
> `defaultGetStackString` fallback; and the canonical exported
> `loggedErrorHandler` bridge that cycle-96's `makeCausalConsole`
> imports. The §user-facing surface covers `makeAssert(optRaise,
> unredacted)`, the `fail` + `Fail` (one-line-throwing-template-
> literal idiom) + base assert, `assert.equal` (Object.is equality;
> RangeError default), `assert.typeof` (with recursive-assertion
> on its own typename arg), `assert.string`, the
> assertionFunctions/assertionUtilities/deprecated three-bag
> assign-then-freeze finalization, the module-level
> `assert = makeAssert()` canonical instance, and the re-exports
> `X` / `q` / `b` / `annotateError` / `assertEqual` / `makeError`
> as multiple-name affordances for different call-site idioms.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [declassifiers-quote-bare-and-redacted-vs-unredacted-details](../sections/endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details.md) | hardened-javascript, errors | current |
| [logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler](../sections/endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler.md) | hardened-javascript, errors | current |
| [makeAssert-and-the-assert-function-family](../sections/endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family.md) | hardened-javascript, errors | current |

The 604-line file decomposes into three argument-cluster sections. Lines 1-202 are the redaction discipline (header + declassifiers/quote/bare + DetailsToken + redactedDetails/unredactedDetails) → section 1. Lines 204-477 are the rendering machinery (getLogArgs + makeError + sanitizeError + tagError + note + loggedErrorHandler) → section 2. Lines 479-604 are the user-facing surface (makeAssert + fail + Fail + assert + equal + typeof + string + bundles + module-level exports) → section 3.

## Provenance

- Fetched 2026-06-01 from `endojs/endo@816bc2574052e686bb14efd95e4709180f79cca6` via the local bare-clone (the cycle-93 commit; assert.js has not been touched since).
- Last touched 2026-04-30 by Richard Gibson. Rich's authorship is appropriate given the V8-stack-attenuation work (cycle 93) Rich also authored; assert.js's `sanitizeError` is the *consumer* side of the V8 stack-getter discipline that tame-v8 set up.
- Verified file existence and comment density via bare-clone listing: 604 lines / file is *deliberately dense* — many short fragmentary comments rather than longform paragraphs. The decisive comment density is in the §header block (lines 1-12) and the §declassifiers / §canBeBare / §sanitizeError / §loggedErrorHandler micro-comments rather than a single block.
- **Eleventh comment-fragment ingest**. The chosen file *completes* the SES causal-console architecture:
  - **Cycle 90** `track-turns.js` (Mark Miller) — produces causal annotations on errors.
  - **Cycle 93** `tame-v8-error-constructor.js` (Richard Gibson) — provides `getStackString` capability with V8-attenuation.
  - **Cycle 96** `console.js` (Mark Miller) — renders the structured errors with cause/errors/notes/sub-errors.
  - **Cycle 98** `assert.js` (Richard Gibson, this ingest) — holds the canonical `assert`/`Fail`/`X` user-facing surface *and* exports the `loggedErrorHandler` bridge that cycle 96 consumes.
- Together the four ingests describe the *full SES causal-console substrate*: assert.js (state + user surface) → track-turns.js (annotations) → tame-v8 (stack-string) → console.js (rendering).
