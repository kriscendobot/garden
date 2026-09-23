---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §parse-passes-freeze-with-badArray-slots discipline
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

```js
const parse = str =>
  unserialize(
    freeze({
      body: str,
      slots: badArray,
    }),
  );
```

The §freeze-the-envelope: the `{body, slots}` capdata object
passed to `unserialize` is *frozen*. Why? `unserialize`
*shouldn't* mutate it, but freezing makes that *impossible*
even if a future bug or attack tries.

The §inline-comment-cites-stabilize-md: the file *again*
cites the preparing-for-stabilize.md doc — the third instance
of the same citation in this file. The §triple-stabilize-
citation across `arrayTarget` + `badArray` discussion + this
inline `freeze`-but-not-`harden` comment.

The §every-mention-cites-the-rationale discipline: the
author *anticipates* that future readers will ask "why
`freeze` and not `harden`?" at each occurrence; the answer is
*inlined at every occurrence*.
