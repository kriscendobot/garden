---
title: Body
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "276-293"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps pulls error-like values out of the recursion at the root: errors that are not valid Passables (e.g., unfrozen errors) should still be encodable, because reporting their diagnostic information trumps reporting the failure to report"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style, errors]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case
---

### The shape of the special case

```js
const encodeToSmallcaps = passable => {
  if (isErrorLike(passable)) {
    // We pull out this special case to accommodate errors that are not
    // valid Passables. For example, because they're not frozen.
    // The special case can only ever apply at the root, and therefore
    // outside the recursion, since an error could only be deeper in
    // a passable structure if it were passable.
    //
    // We pull out this special case because, for these errors, we're much
    // more interested in reporting whatever diagnostic information they
    // carry than we are about reporting problems encountered in reporting
    // this information.
    const result = harden(
      encodeErrorToSmallcaps(passable, encodeToSmallcapsRecur),
    );
    assertEncodedError(result);
    return result;
  }
  return harden(encodeToSmallcapsRecur(passable));
};
```

The wrapper has three jobs:

1. **Detect error-likeness at the root.** `isErrorLike` (from
   pass-style) is a structural test that recognizes anything
   instanceof Error or that satisfies an error-shape predicate;
   it does not require the error to be a valid Passable.
2. **Route through the caller-supplied `encodeErrorToSmallcaps`.**
   The encoder's options bag carries an
   `encodeErrorToSmallcaps(error, encodeRecur)` callback (or the
   default `dontEncodeErrorToSmallcaps` that fails). The handler
   is responsible for producing the `{"#error": "...", "name": "...", ...}`
   shaped record.
3. **Validate the result.** `assertEncodedError` checks that the
   output is an object with a `#error` property whose value is a
   string. This is the encoder-side guarantee that even though
   the *input* was not necessarily a valid Passable, the *output*
   is a valid smallcaps encoding.

The corresponding recursive case (`case 'error':` in
`encodeToSmallcapsRecur`) handles errors that *are* valid
Passables (frozen, with the right own-property shape per pass-style),
which is the only way an error can appear nested inside a
passable structure.

### "Why at the root, and only at the root"

The comment names the structural invariant:

> The special case can only ever apply at the root, and therefore
> outside the recursion, since an error could only be deeper in
> a passable structure if it were passable.

The argument:

- A passable copyRecord has only passable own values. (per
  `copyRecord-guarantees.md`)
- A passable copyArray has only passable elements.
- A passable tagged has a passable payload.
- A passable error has only passable own properties.

Transitive closure: any error reachable through the
property-traversal of a passable value must itself be a passable
error. So a non-passable error can only appear at the **root** of
the encoder call; if it were deeper, the surrounding container
would not be passable, and we would already have rejected the
whole structure.

This is what justifies pulling the case out of the recursion. The
recursion's strict `passStyleOf`-based switch correctly rejects
non-passable values; the wrapper's pre-recursion check
*accommodates* a non-passable root that is specifically an error,
because the caller's intent is diagnostic, not data-payload.

### The diagnostic-information priority claim

The substantive design claim:

> for these errors, we're much more interested in reporting
> whatever diagnostic information they carry than we are about
> reporting problems encountered in reporting this information.

This is a **prioritization rule**: when the encoder receives an
error, the caller is asking the encoder to *report*, not to
*validate*. Refusing to encode because the error is not a valid
Passable would be the encoder's own failure mode obscuring the
caller's primary failure mode. The error encoding might be
incomplete (the error's stack might be omitted, custom own
properties might be dropped), but it is always non-empty.

The pattern echoes the broader Endo convention of *causal
diagnostics over strict validation* — the
`@endo/errors` package's `assert` mechanism is structured so that
a failed assertion produces a richer diagnostic than the absence
of one, and the `tameConsole` accumulates causal context across
calls to surface the original cause when an error reaches a
top-level reject.

### What the special case does *not* protect against

Two failure modes survive even with the special case:

1. **`encodeErrorToSmallcaps` itself fails.** If the caller's
   handler raises (e.g., because the error is too pathological
   to summarize), the encoder propagates that failure. The
   comment's "more interested in reporting" is a *prefer-not-to-fail*
   discipline, not a *cannot-fail* guarantee.
2. **The result is not a valid encoded error.** The
   `assertEncodedError` check is run after the handler returns;
   a handler that returns a malformed shape (no `#error`
   property, or a non-string message) raises. The internal
   message of that raise (`internal: Error encoding must have ...`)
   is a marshal-side hard fault, not a remediable validation
   error.

The case is a **softening of the encode contract for one shape
of root input**, not a general loosening of marshal's validation.

### Implication: error-likeness vs the pass-style error case

There is a subtle asymmetry between the two error paths:

- `isErrorLike` (used at the root) accepts errors that are not
  passable.
- `case 'error':` (in the recursion) handles errors that pass
  `passStyleOf` as `'error'`, which requires passability.

The encoder uses the looser test at the root and the stricter
test in the recursion. A reader debugging "why did this error
encode as a #error record at the root but get rejected when
nested" should consult the comment to understand the asymmetry:
non-passable errors are encodable at the root *because of the
diagnostic-priority rule*, but non-passable errors anywhere else
would mean the surrounding container is non-passable, and
marshal's normal validation kicks in.

### The harden() that bookends both paths

Both the special case and the normal recursion `harden(...)`
their output before returning. The wrapper-level `harden` is the
output-side discipline that ensures every callable upward of
`encodeToSmallcaps` sees a frozen value, regardless of which
encode path was taken. This is consistent with marshal's
*frozen-objects-only* rule from the README: inputs that should
be hardened *and* outputs that the caller can rely on to be
hardened. The duplicate harden in the recursion's other arms
(noted in the comment as "they don't hurt") is a defense-in-depth
pattern that survives a refactor.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L276-L293) at commit `e56bf00f`.
