---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §passableAsJustin (the documented diagnostic surface)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
export const passableAsJustin = (passable, shouldIndent = true) => {
  let slotCount = 0;
  const convertValToSlot = val => `s${slotCount++}`;
  const { toCapData } = makeMarshal(convertValToSlot);
  const { body, slots } = toCapData(passable);
  const encoded = JSON.parse(body);
  return decodeToJustin(encoded, shouldIndent, slots);
};
harden(passableAsJustin);
```

§Four-step-flow:

1. §Allocate-a-slot-counter starting at 0.
2. §Make-a-marshal with `s0`, `s1`, ... slot allocator.
3. §Convert-the-passable to capData encoding.
4. §Render-the-capData-as-Justin via decodeToJustin.

§This-is-the-§CLAUDE.md-cited diagnostic API: "When rendering
a passable value for a log message, use `passableAsJustin`
from `@endo/marshal` rather than `JSON.stringify`, which
produces ambiguous output for remotables and promises."

§Why-not-JSON.stringify: JSON.stringify treats remotables and
promises as opaque (renders as `{}` or fails). §Justin-
rendering shows them as `slot(0)`, `slot(1)`, ... with §named
slot indices. §Diagnostic-clarity-without-revealing-slot-
identity.

§Compare-to-cycle-89-error/assert.js' §`details`-template-tag-
for-hiding-arguments-from-causal-console. §Both-are-§diagnostic-
formatting-disciplines for hardened-JS environments.
