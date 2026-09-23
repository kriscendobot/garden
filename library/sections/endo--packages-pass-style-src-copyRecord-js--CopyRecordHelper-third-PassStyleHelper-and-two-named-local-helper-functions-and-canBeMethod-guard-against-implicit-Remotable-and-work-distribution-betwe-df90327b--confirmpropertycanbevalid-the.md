---
title: §confirmPropertyCanBeValid — the second named local helper
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

Lines 25-41:
```js
const confirmPropertyCanBeValid = (candidate, key, value, reject) => {
  return (
    (typeof key === 'string' ||
      (reject &&
        reject`Records can only have string-named properties: ${candidate}`)) &&
    (!canBeMethod(value) ||
      (reject &&
        // TODO: Update message now that there is no such thing as "implicit Remotable".
        reject`Records cannot contain non-far functions because they may be methods of an implicit Remotable: ${candidate}`))
  );
};
```

§The-property-validator-is-a-two-rule-AND-conjunction:

1. **§Key-must-be-string** — rejects symbol-keyed properties.
2. **§Value-must-not-be-method-like** — rejects properties whose value `canBeMethod()` returns true.

§The-key-must-be-string-discipline: §record-keys-are-string-only-because-symbol-keys-carry-non-passable-identity; §sibling-pattern to cycle 148's symbol.js Hilbert-Hotel encoding — symbols ARE passable as values but NOT as keys; §the-discipline-IS-encoded-at-the-helper-level.

§The-value-must-not-be-method-like-discipline: §a-method-shaped-value-suggests-this-IS-secretly-a-Remotable + §if-it's-a-Remotable-it-should-go-through-the-RemotableHelper-not-the-CopyRecordHelper + §the-CopyRecordHelper-rejects-method-shaped-values-to-force-the-correct-pass-style; §canBeMethod-from-`./remotable.js`-IS-the-cross-cluster-disambiguation-import.

§The-TODO-comment (line 38): *"Update message now that there is no such thing as 'implicit Remotable'"*. §The-TODO-acknowledges-the-error-message-has-design-drift; §sibling-pattern to git's `TODO(name):` comment convention; §two-cycles-with-honest-TODO-acknowledgment (152 memo-race's TODO about consolidation + 264 copyRecord's TODO about message-update); §two-cycles-with-named-design-drift-acknowledged-in-comment-without-fix.

§First-explicit-observation in library: **§the-cross-cluster-disambiguation-discipline — §when-one-pass-style-could-be-confused-with-another, §the-helper-imports-the-other-helper's-detector-to-reject-the-overlap**.
