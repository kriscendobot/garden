---
title: The GC-determinism hazard
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

The hazard the second paragraph names is subtle. `passStyleOf` is
called from many places, often as a guard (`assertPassable`,
`isPassable`, marshal's per-element classification). If a
liveslot-supplied `passStyleOf` is non-deterministic — if it can
return different classifications for the same value at different
times — then a guest program can use the *change* in classification
as an oracle for events the host did not intend to expose. The
canonical such event is **garbage collection**: a virtualized
reference whose backing slot has been swept and reconstituted may
be classified differently than one whose slot is still live. If
the guest sees `passStyleOf(x) === 'remotable'` at time T1 and
`passStyleOf(x) === 'tagged'` at time T2, the change is
information about the host's GC schedule.

GC-detection is a known covert-channel hazard in capability-secure
runtimes. It is most consequential for *information-flow* security:
two parties that share access to a virtualized reference can use
the host's GC to communicate without either party having an
explicit channel. The pass-style package's defense is therefore
not to *prevent* the channel (which would require liveslots to
buffer state across GC, an unacceptable cost) but to **require
the delegated classifier to be deterministic**. The hazard note
makes the requirement explicit so liveslots authors know to
preserve it.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
