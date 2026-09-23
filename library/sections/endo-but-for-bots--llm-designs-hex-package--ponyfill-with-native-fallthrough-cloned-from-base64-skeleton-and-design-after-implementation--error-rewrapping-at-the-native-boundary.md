---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §Error-rewrapping-at-the-native-boundary
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```js
export const decodeHex =
  nativeFromHex !== undefined
    ? (string, name) => {
        try {
          return nativeFromHex(string);
        } catch (e) {
          // Native throws SyntaxError with no caller context.  Rewrap
          // to match the fallback's error shape.
          throw Error(
            `Invalid hex in string ${name ?? '<unknown>'}: ${/** @type {Error} */ (e).message}`,
          );
        }
      }
    : jsDecodeHex;
```

§Native-fromHex-throws-SyntaxError-with-no-caller-context.
§Fallback-jsDecodeHex-throws-Error-with-`name`-and-offset.
§The-decodeHex-wrapper-rewraps-native-errors so callers who do
`catch (e) { if (/Invalid hex/.test(e.message)) ... }` see the
same shape on both paths.

§Design-Decision-6 codifies this: "Cost: an extra try/catch and
an allocation on the error path. Benefit: a stable error
contract." §Tradeoff-named-explicitly.

§Compare-to-cycle-89-error/assert.js' §error-shape-discipline.
§This-design-applies-the-same-discipline-at-a-different-layer:
not the SES error layer, but the §native-vs-fallback-boundary.
