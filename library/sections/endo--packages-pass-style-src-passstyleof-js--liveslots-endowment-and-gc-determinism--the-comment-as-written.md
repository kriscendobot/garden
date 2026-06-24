---
title: The comment as written
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "219-245"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports the globalThis-installed passStyleOf when present (liveslots delegation), how the install-on-global gate stands in for explicit authorization, and the GC-detection hazard the delegated implementation must preserve determinism to avoid"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, persistence]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism
---

Lines 221-235 in the captured commit, on the
`PassStyleOfEndowmentSymbol`-conditioned export of `passStyleOf`:

> If there is already a PassStyleOfEndowmentSymbol property on the
> global, then presumably it was endowed for us by liveslots with
> a `passStyleOf` function, so we should use and export that one
> instead.
> Other software may have left it for us here, but it would
> require write access to our global, or the ability to provide
> endowments to our global, both of which seems adequate as a
> test of whether it is authorized to serve the same role as
> liveslots.
>
> NOTE HAZARD: This use by liveslots does rely on `passStyleOf`
> being deterministic. If it is not, then in a liveslot-like
> virtualized environment, it can be used to detect GC.

The corresponding code:

```js
export const PassStyleOfEndowmentSymbol = Symbol.for('@endo passStyleOf');

export const passStyleOf =
  (globalThis && globalThis[PassStyleOfEndowmentSymbol]) ||
  makePassStyleOf([
    CopyArrayHelper,
    ByteArrayHelper,
    CopyRecordHelper,
    TaggedHelper,
    ErrorHelper,
    RemotableHelper,
  ]);
```

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
