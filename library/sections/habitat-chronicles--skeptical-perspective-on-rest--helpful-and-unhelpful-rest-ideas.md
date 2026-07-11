---
title: Pro and con — what REST gets right and what it gets wrong
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [networking, distributed-objects]
status: current
---

## Abstract

Morningstar's balance sheet on REST: the ideas he finds **extremely helpful** and the
ones he finds **less so**. The helpful side is essentially a *don't-reinvent-the-wheel,
trade-bandwidth-for-clarity* discipline — avoid layers of intermediation that add no
value (let HTTP do the jobs HTTP already does well); embed resource designators in the
communicated information rather than in a separate protocol spec document; trade
bandwidth for a reduction in interpretive latitude (say more explicitly, because a
receiver forced to figure something out could figure it wrong — "bandwidth is getting
cheaper all the time, whereas bugs are eternal"); use **URIs** as good-enough universal
designators; prefer **simple, robust, extensible, general-purpose data representations**
over fussy protocol-specific ones. The unhelpful side is where REST over-reaches: the
belief that HTTP's fixed verb set is *mostly all you need* (with the ahistorical conceit
that those verbs were a "carefully conceived set" rather than an ad-hoc collection);
**boundless faith in caching** as a universal scalability solvent; and the awkward
**shoehorning of application-level abstractions** onto HTTP's affordances (mapping app
errors onto the standard HTTP status codes "does violence to both sets," and layering
magical secondary semantics onto PUT/DELETE).

## Content

### Helpful ideas

There are several ideas from REST Morningstar finds extremely helpful (in no particular
order):

- **Avoid valueless intermediation.** Do not add layers of intermediation that do not
  actually add value. In particular, if HTTP already does a particular job adequately
  well, just let that job be done by HTTP itself. Implicit in this is the recognition
  that HTTP already does a lot of the jobs we build application frameworks to do.
- **Embed designators in the payload.** It is better to embed the designators for
  relevant resources in the actual information communicated rather than in a protocol
  specification document.
- **Trade bandwidth for less interpretive latitude.** More generally, it can be
  worthwhile to trade bandwidth for a reduction in interpretive latitude — explicitly
  communicate more stuff rather than letting the other end figure things out
  implicitly, because if one end needs to figure something out it could figure it out
  wrong. "Bandwidth is getting cheaper all the time, whereas bugs are eternal."
- **URIs are good enough.** To designate all kinds of things, URIs are good enough.
- **Simple general-purpose representations win.** Simple, robust, extensible,
  general-purpose data representations are better than fussy and precise
  protocol-specific ones.

### Less helpful ideas

Other ideas from REST he finds less helpful:

- **HTTP's verbs are "mostly all you need."** He rejects the belief that the fundamental
  method verbs of HTTP are mostly sufficient for just about every purpose. This is
  sometimes accompanied by the "odd and rather ahistorical" assertion that HTTP's verbs
  constitute a carefully conceived set with tight, well-defined semantics — as opposed
  to an ad-hoc collection of operations that seemed more or less sufficient at the time.
  The historical conceit is not material to the substance of the principles, but it
  generates a lot of unproductive discussion at cross purposes about irrelevant
  background details.
- **Caching as universal solvent.** He is skeptical of the "boundless faith in the
  efficacy of caching as the all-purpose solvent for scalability and performance
  issues."
- **Shoehorning abstractions onto HTTP.** The sometimes-awkward shoehorning of
  application-level abstractions onto the available affordances of HTTP. Mapping the
  defined set of standard HTTP error codes onto the set of possible problems in a
  specific application often "does violence to both sets." Another example is the
  occasional layering of "magical and unintuitive secondary application semantics" onto
  operations like PUT or DELETE.

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
