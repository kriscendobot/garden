---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §`AtAtPrefixPattern` compiled at module load
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

```js
const AtAtPrefixPattern = /^@@(.*)$/;
harden(AtAtPrefixPattern);
```

The §regex-as-frozen-constant discipline. Compiled once,
hardened (so the prototype's `.exec` and `.lastIndex` can't
be tampered with via prototype pollution). The `^@@(.*)$`
matches *any* string starting with `@@`, capturing the rest.
Note: `(.*)` is non-greedy w.r.t. anchoring (the `$` forces
match to end of string), so `match[1]` is everything after
the *first* `@@`.
