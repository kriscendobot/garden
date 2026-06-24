---
source: packages/cli/src/{pet-name,message-format,message-parse,number-parse,random,prompt}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/cli/src
source_path: packages/cli/src/pet-name.js, packages/cli/src/message-format.js, packages/cli/src/message-parse.js, packages/cli/src/number-parse.js, packages/cli/src/random.js, packages/cli/src/prompt.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
genre: §endo-source-comment-fragment §canonical-CLI-utility-cluster
cycle: 195
lane: chat
status: current
title: §number-parse.js (the §strict-bigint-regex)
parent: endo--packages-cli-src-utility-cluster--six-tight-utilities-with-pet-name-paths-mention-parsing-and-second-confirmation-of-gap-between-design-and-implementation
---

```js
export const parseBigint = (input = '') => {
  const trimmed = input.trim();
  if (!/^(0|[1-9][0-9]*)$/.test(trimmed)) {
    throw new Error(`Invalid number: ${input}`);
  }
  return BigInt(trimmed);
};
```

§Thirteen-lines. §The-§strict-regex `/^(0|[1-9][0-9]*)$/`
matches:

- `0` (just zero).
- `[1-9][0-9]*` (non-zero positive integer, no leading zeros).

§Rejects: §negative-numbers (no `-` allowed); §decimal-points;
§hex-prefix `0x`; §scientific-notation; §leading-zero-with-
followup (`007`); §empty-string.

§Why-strict: `BigInt('123')` succeeds; `BigInt('-123')` also
succeeds (negative bigint). §The-regex-narrows-to-non-negative-
integer-with-no-leading-zeros — the §canonical-shape for
non-negative-bigint-input.

§The-`input = ''` default makes §undefined-input behave like
empty-string. §Combined-with-the-empty-string-rejection, this
yields §a-clean-throw-on-undefined.

§Compare-to-cycle-191-zip's §assertNatNumber (also `Number
.isSafeInteger + non-negative` check). §Both-are-§validate-
the-canonical-integer-shape patterns; cycle 191 validates
JS-number; cycle 195 parses-from-string-then-validates.

§Tier-1-borrowing: §parseBigint-with-strict-regex for any
§CLI-argument that must be a §non-negative-integer (no
leading zeros, no decimals, no signs).
