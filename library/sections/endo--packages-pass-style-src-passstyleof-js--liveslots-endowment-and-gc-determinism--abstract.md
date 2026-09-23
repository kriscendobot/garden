---
title: Abstract
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

The pass-style package exports `passStyleOf` with a small but
load-bearing twist: if a `Symbol.for('@endo passStyleOf')` property
is already on `globalThis` at module-init time, the package uses
*that* function as its exported `passStyleOf` instead of
constructing its own. The longform comment surrounding the
`PassStyleOfEndowmentSymbol` export and the conditional export is
the canonical source for three claims the construct rests on:
(1) liveslots (the Agoric SwingSet vat host) needs to swap in a
*virtualization-aware* `passStyleOf` so that Far-virtualized
objects from durable stores classify correctly; (2) the
**install-on-global gate is the authorization check** — any caller
that can install the symbol property on the start-compartment
global is already trusted at the same level as liveslots (write
access to the start compartment is roughly equivalent to being
liveslots); and (3) **a delegated implementation MUST preserve
the determinism of `passStyleOf`**, because otherwise a liveslot-like
virtualized environment exposes a *garbage-collection detector* to
any guest that can ask "what is the pass-style of this value?" and
observe a different answer depending on whether the host has
swept some intermediate state.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
