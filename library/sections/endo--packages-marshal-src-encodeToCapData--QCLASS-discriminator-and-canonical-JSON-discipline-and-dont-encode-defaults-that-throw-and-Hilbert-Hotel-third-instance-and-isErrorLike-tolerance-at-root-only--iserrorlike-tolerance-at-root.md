---
title: §isErrorLike-tolerance at root only
source-slug: endo--packages-marshal-src-encodeToCapData
section-id: QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
status: shipping
ingest-cycle: 231
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-encodeToCapData--QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
---

```js
const encodeToCapData = passable => {
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
    return harden(encodeErrorToCapData(passable, encodeToCapDataRecur));
  }
  return harden(encodeToCapDataRecur(passable));
};
```

§The-root-error-special-case is the §design-bet:
- §An-error-at-the-root-might-be-non-frozen / non-Passable / etc.
- §We-want-the-diagnostic-information + §we-don't-want-to-fail-while-trying-to-report-an-error.
- §The-special-case-can-only-ever-apply-at-the-root because §deeper-errors-must-already-be-Passable (and so are handled by the regular case).

§Borrowable-pattern: §lenient-at-the-root + §strict-deeper. §Borrowable-pattern: §when-the-design-is-about-error-reporting, §be-extra-tolerant-of-malformed-inputs-at-the-error-reporting-path.

§Sibling to cycle 217 @endo/errors' §two-channels-for-two-audiences (thrown-error redacted + console-log full) — both designs §error-reporting-is-extra-tolerant.
