---
title: §`qp`-eager-vs-`q`-lazy comparison
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

```
- `q` is lazy, minimizing the cost for using it in an error that's never
  logged. Unfortunately, due to layering constraints, `qp` is not
  lazy, always rendering to quasi-quoted Justin immediately.
```

§Two-template-tags-with-two-different-laziness-policies:
- `q` (from @endo/errors): §lazy-renders-only-if-the-error-is-logged.
- `qp` (from @endo/marshal): §eager-renders-immediately-because-of-layering-constraints.

§Honest-disclosure-of-layering-constraint — §unfortunately-due-to-layering-constraints. §Borrowable-pattern: §when-the-design-can't-match-an-existing-policy + §the-reason-is-architectural, §name-the-constraint + §accept-the-asymmetry.

§Sibling to cycle 220 familiar-localhttp-protocol's §honest-disclosure-of-limitations + cycle 224 daemon-web-gateway's §Caveat-emptor-disclosure. §Three-cycles-on-honest-acknowledgment-of-architectural-asymmetry now.
