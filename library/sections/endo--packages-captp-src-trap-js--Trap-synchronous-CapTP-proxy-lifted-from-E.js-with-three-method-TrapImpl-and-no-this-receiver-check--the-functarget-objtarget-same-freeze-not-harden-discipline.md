---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §funcTarget + objTarget — same freeze-not-harden discipline
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

```js
const funcTarget = freeze(() => {});
const objTarget = freeze({ __proto__: null });
```

**Identical** to cycle 146's E.js. The §freeze-not-harden
discipline + the §preparing-for-stabilize.md doc-link comment.

Both files contain *the same JSDoc comment* word-for-word:

> *`freeze` but not `harden` the proxy target so it remains
> trapping. Thus, it should not be shared outside this module.*
>
> *See https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md*

The §verbatim-comment-shared-across-derived-files pattern: the
comment travels with the code. When *either* file's code
changes, the comment moves with it. The §rationale-is-load-
bearing observation.
