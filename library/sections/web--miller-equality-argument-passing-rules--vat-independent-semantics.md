---
title: "Argument Passing Rules: vat-independent pass-invariance (PassByCopy, PassByConstruction, Settled)"
source_kind: web
source_url: https://erights.org/elib/equality/passing-rules.html
source_content_sha256: 674e5229902870f36b8ac0a3ca4398a021591a529c4f4c54023be1e84d78b9fe
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [marshal, capability-theory, eventual-send]
status: current
---

E's *vat-independent* argument-passing taxonomy — the object-passing classification of the equality chapter, and the direct E-language ancestor of Endo's marshal **pass-style**. All argument transformations must be consistent with both the capability rules and E's partial-ordering constraints. The pass-invariance rules:

- **Calls don't fork.** In any immediate (synchronous) message pass — call, success, failure, escape — the arguments transmitted are the arguments received, and the return results passed are the return results received.
- **Sends make Promises.** In an eventual-send, the return result always starts as a Promise for the outcome.
- **Args stay Resolved.** Transmitted Resolved arguments are always received as Resolved.
- **Args stay Settled.** In any message pass, immediate or eventual, transmitted Settled arguments are always received as Settled.
- **PassByCopy args stay Near.** Transmitted Near references to **PassByCopy** objects are always received as Near references to the identical objects; across vats this means the PassByCopy arguments must be *copied* by delivery time. (Combined with Args-stay-Settled, PassByCopy hashtables pass by copy successfully, because the hashtable insists its keys be Settled, so the keys arrive Settled and designating the same objects.)
- **PBC args stay Near.** Transmitted Near references to a **PassByConstruction** object are always received as Near references to a *Presence* of the same object; across vats, the remote presence must be *constructed* by delivery time. (PassByCopy is a special case of this rule.)
- **Once Broken always Broken.** Transmitted Broken references are always received as Broken.

This is the page from which the E pass-style vocabulary — **PassByCopy** (copied to the receiving vat), **PassByConstruction / PBC** (a Presence constructed in the receiving vat), and **PassByProxy** (the Selfish default; the object stays home and a Far reference is received, covered in [Vat-based Rules](../sections/web--miller-equality-argument-passing-rules--vat-based-rules.md)) — derives. In Endo's marshal these become **pass-by-copy** (copyArray / copyRecord / tagged / primitives / errors) and **pass-by-presence** (remotable / Far); see the [[pass-by-construction]] concept for the E ↔ Endo mapping.

Implicit in the following rules is that all transformations of arguments and return results must be consistent with both capability rules and E's partial-ordering constraints.

- **Calls don't fork:** In any immediate message pass (synchronous: call, success, failure, escape) the arguments transmitted are the arguments received, and the return results passed are the return results received.
- **Sends make Promises:** In an eventual-send, the return result always starts as a Promise for the outcome.
- **Args stay Resolved:** In any message pass, transmitted Resolved arguments are always received as Resolved (but due to the Lost Resolution bug, in current E implementations it may be received as a Promise instead).
- **Args stay Settled:** In any message pass, whether immediate or eventual (asynchronous: sendOnly, pipelined-send), transmitted Settled arguments are always received as Settled arguments.
- **PassByCopy args stay Near:** In any message pass, transmitted Near references to PassByCopy objects are always received as Near references to the identical objects. If the message is sent between vats, this means the PassByCopy arguments must be copied by the time the message is delivered. Putting the above two rules together, PassByCopy hashtables can be successfully passed by copy, because the hashtable insists its keys must be Settled, and so these keys will also arrive as Settled and designating the same objects.
- **PBC args stay Near:** In any message pass, transmitted Near references to a PassByConstruction object are always received as Near references to a *Presence* of the same object. If the message is sent between vats, this means the remote presence of the PassByConstruction argument must be constructed by the time the message is delivered. (The above PassByCopy rule can be seen as a special case of this one.)
- **Once Broken always Broken:** In any message pass, transmitted Broken references are always received as Broken.

Source: [Argument Passing Rules](https://erights.org/elib/equality/passing-rules.html) § Vat Independent Semantics, Mark S. Miller, erights.org; fetched 2026-06-27 via the erights.github.io GitHub Pages mirror, content SHA-256 `674e5229` (byte-identical to the prior Internet-Archive capture).
