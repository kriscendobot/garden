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
title: §Lowercase-default-with-uppercase-fallback-to-JS-path
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```js
export const encodeHex =
  nativeToHex !== undefined
    ? (bytes, options) => {
        if (options?.uppercase) {
          // TC39 native only produces lowercase.  Uppercase is rare
          // enough that falling back to the JS path is acceptable.
          return jsEncodeHex(bytes, options);
        }
        return nativeToHex.call(bytes);
      }
    : jsEncodeHex;
```

§Three-case-branching: §native-available-no-uppercase (fast
path); §native-available-uppercase (fall back to JS); §native-
unavailable (always JS).

§The-comment-explains-the-discipline: "TC39 native only produces
lowercase. Uppercase is rare enough that falling back to the JS
path is acceptable." §This-is-§deliberate-asymmetry-acknowledged-
in-comment. §Compare-to-cycle-152-pass-style/symbol.js'
§three-case-decoder for symbol passability — both designs name
their case-by-case asymmetry rather than papering over it.

§Design-Decision-5 codifies this: "options.uppercase only on
encode; decodeHex accepts both. Symmetric to the native TC39
proposal: Uint8Array.prototype.toHex takes no case option (output
is lowercase); Uint8Array.fromHex accepts both cases."

§The-philosophy-named: "Our options.uppercase is an additive
extension that falls back to the JS path when set, matching the
proposal's philosophy of delegating to user code for non-default
behavior."
