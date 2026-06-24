---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: §Padding-acceptance-permissive (decoder choice)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
while (quantum > 0) {
  if (i === string.length || string[i] !== padding) {
    throw Error(`Missing padding at offset ${i} of string ${name}`);
  }
  // We MAY reject non-zero padding bits, but choose not to.
  // https://datatracker.ietf.org/doc/html/rfc4648#section-3.5
  i += 1;
  quantum -= 2;
}
```

§The-comment-cites-RFC-4648-§3.5: implementations MAY reject
non-zero padding bits. §This-impl-chooses-not-to-reject.

§Why-name-the-choice: an LLM reader or new contributor might
otherwise add the check as a "missing security hardening". §The-
inline-comment-with-RFC-citation closes that hole — §reject-or-
accept-is-the-RFC's-choice, not ours, and the choice is named in
the source.

§Cycle-89-error/assert.js had a §§don't-let-error-paths-reveal-
too-much sibling discipline; §base64-decoder-here-has-§don't-
over-validate-by-default with the citation as justification.
