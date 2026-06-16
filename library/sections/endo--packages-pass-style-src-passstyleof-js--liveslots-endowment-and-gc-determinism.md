---
title: PassStyleOfEndowmentSymbol — liveslot delegation, the "host has write access to our global" gate, and the GC-determinism hazard
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
kind: index
section_count: 8
---

Sections:

- [Abstract](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--abstract.md)
- [The comment as written](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--the-comment-as-written.md)
- [Why liveslots needs to swap in its own implementation](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--why-liveslots-needs-to-swap-in-its-own-implementation.md)
- [The install-on-global gate as authorization](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--the-install-on-global-gate-as-authorization.md)
- [The GC-determinism hazard](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--the-gc-determinism-hazard.md)
- [How the hazard interacts with the memo](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--how-the-hazard-interacts-with-the-memo.md)
- [Implications](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--implications.md)
- [See also](endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism--see-also.md)

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
