---
title: §slotToVal-render-when-slot-is-bound + §slot-render-when-not-bound
source-slug: endo--packages-marshal-src-marshal-justin
section-id: Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
---

```js
case 'slot': {
  // ...
  if (index < slots.length) {
    const renderedSlot = nestedRender(slots[index]);
    return iface === undefined
      ? out.next(`slotToVal(${renderedSlot})`)
      : out.next(`slotToVal(${renderedSlot},${nestedRender(iface)})`);
  }
  return iface === undefined
    ? out.next(`slot(${index})`)
    : out.next(`slot(${index},${nestedRender(iface)})`);
}
```

§Four-output-shapes depending on §two-binary-conditions:
- §slot-index-is-in-the-slots-array (renders as `slotToVal(...)`) vs §slot-index-is-out-of-range (renders as `slot(N)`).
- §iface-is-defined (passes iface as second argument) vs §undefined (omits it).

§Borrowable-pattern: §the-rendered-call-shape-depends-on-the-available-context — §when-slots-are-bound-render-the-bound-form + §when-slots-are-not-bound-render-the-by-index-form.
