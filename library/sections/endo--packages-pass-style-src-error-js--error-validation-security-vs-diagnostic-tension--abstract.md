---
title: Abstract
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "184-362 (isErrorLike + confirmRecursivelyPassableErrorPropertyDesc + confirmRecursivelyPassableError + ErrorHelper)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The block-level rationale for `isErrorLike` (lines 213-225) sets the
  *security-vs-diagnostic-preservation* tension that drives the rest of
  the file: prefer to let an error continue to function as a diagnostic
  even when it is not fully passable, by attaching the validity
  complaints as *notes* on the error rather than swallowing the
  original diagnostic. The implementation then enforces a strict
  four-property own-data-property allowlist (`message`, `stack`,
  `cause`, `errors`) via `confirmRecursivelyPassableErrorPropertyDesc`,
  with `cause` recursing as a single passable error and `errors`
  recursing as a copyArray-of-passable-errors. A subtle
  passStyleOf-side-effect under unsafe-hardenTaming is noted: invoking
  `confirmRecursivelyPassableError` *alters* the candidate by calling
  the stack-accessor repair from the previous section.
parent: endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension
---

The block beginning at line 213 names the design tension that drives error-validation: *Validating error objects are passable raises a tension between security vs preserving diagnostic information*. The package's resolution: prefer to let the error-like test succeed even when the error would not strictly validate, so marshal can use the malformed error as the *top-level error to report from*; the validity diagnostics that `assertError` would have produced are then *attached as notes* to the malformed error rather than thrown. *A malformed error is passable by itself, but not as part of a passable structure.* The strict validation surface is implemented as a **four-property own-data-property allowlist**: `message` (string), `stack` (string), `cause` (recursive passable error), `errors` (copyArray of recursive passable errors). The four-property allowlist is the *positive spec*; any other own property fails as *extra unpassed property*. The validation function `confirmRecursivelyPassableError` requires (a) the candidate is error-like (`instanceof Error`); (b) the prototype is the prototype of a registered error constructor (with name in the `errorConstructors` Map covering `Error`, `EvalError`, `RangeError`, `ReferenceError`, `SyntaxError`, `TypeError`, `URIError`, plus `AggregateError` conditionally); (c) the candidate has an own `message` string property; (d) every own property satisfies the per-property validation. Crucially, the validation function *also* invokes `repairError` as a side effect when `repairError !== undefined` (i.e. under unsafe-hardenTaming): *Under these circumstances only, passStyleOf alters an object as a side effect, converting the "stack" property to a data value.* The side-effect is explicitly disclaimed in the comment because *side-effect during `passStyleOf`* would normally be a defensive-consistency violation; the disclaimer scopes it to the unsafe-hardenTaming configuration only. The block also names a `getErrorConstructor` cautionary note: the constructor returned by the function might be `AggregateError`, which has different construction parameters from the other error constructors, so *use `makeError` which encapsulates this non-uniformity*. The file concludes with the `ErrorHelper` PassStyleHelper export that wires `confirmErrorLike` as `confirmCanBeValid` and `confirmRecursivelyPassableError` as the recursive-validation surface.
