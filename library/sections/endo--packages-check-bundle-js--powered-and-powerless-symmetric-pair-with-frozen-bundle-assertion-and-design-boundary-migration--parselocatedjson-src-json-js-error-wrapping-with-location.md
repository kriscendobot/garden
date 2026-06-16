---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: §`parseLocatedJson` (src/json.js) — error-wrapping with location
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
const q = JSON.stringify;

export const parseLocatedJson = (source, location) => {
  try {
    return JSON.parse(source);
  } catch (error) {
    if (error instanceof SyntaxError) {
      throw SyntaxError(`Cannot parse JSON from ${q(location)}, ${error}`);
    }
    throw error;
  }
};
```

§Twenty-two-line-helper. §The-discipline: wrap JSON.parse with
SyntaxError-rewrapping that adds the file location to the
error message.

§Three-cases:

1. §JSON.parse-succeeds → return result.
2. §JSON.parse-throws-SyntaxError → rewrap with location.
3. §JSON.parse-throws-non-SyntaxError → propagate (shouldn't
   happen for JSON.parse, but defensive).

§Compare-to-cycle-181-base64's §error-rewrapping-at-the-native-
boundary. §Same-pattern-applied-here for JSON instead of TC39
base64. §The-§stable-error-contract-with-caller-context is the
shared discipline.

§The-`q = JSON.stringify` shorthand at module top is a §local
alias that gives the rewrapper a §safe-quote-of-the-location
(filenames with special characters get JSON-escaped).
