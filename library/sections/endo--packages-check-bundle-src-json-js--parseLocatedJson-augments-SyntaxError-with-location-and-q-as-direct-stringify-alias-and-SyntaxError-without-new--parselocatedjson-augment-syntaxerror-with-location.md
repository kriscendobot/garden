---
title: §parseLocatedJson — augment SyntaxError with location
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new
---

```js
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

§The-function-takes-`source`-AND-`location` + §location-is-passed-but-not-used-by-JSON.parse + §location-is-only-used-on-the-error-path. §When-a-parse-error-occurs-the-caller-wants-to-know-which-file-failed-not-just-that-it-failed. §The-location-is-the-context-the-error-needs-but-doesn't-have.

§First-explicit-observation in library of §augment-the-error-with-location-on-the-error-path-only as named-discipline. §The-location-doesn't-affect-the-success-path + §the-cost-is-only-paid-when-an-error-occurs.
