---
title: Authority boundaries — visibility vs. authoritativeness, and client vs. server representation
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects, capability-theory]
status: current
---

## Abstract

Two related concerns Morningstar raises about REST's representational conceit, both about
**authority**. First, manipulating resources by passing representations "tends to result
in confusion between **visibility and authoritativeness**" — the model does not innately
distinguish representations of *reality* (how things are) from representations of *intent*
(how someone would like them to be), and since different parties are authoritative over
different aspects of a resource, the **lines of authority become blurry and confused**.
Sometimes this is fixable by **splitting the resource into pieces that align the authority
boundaries with the resource boundaries** (the product-catalog example: separate the
marketing-owned description from the accounting-owned price into distinct resources — "a
cleaner and simpler system" that "generalizes in all sorts of interesting and useful
ways"). But when authority boundaries do *not* correspond to discrete portions of state
(marketing and legal both editing the same descriptive text), you must invent "specialized
resources that represent distinct control channels" — an **approval resource that looks a
lot more like a control signal than a data representation**, "which starts looking a lot
more like the imperative model that REST eschews." Second, REST's representational framing
tends to ignore the **client/server separation of concerns**: the client is authoritative
over the *user's intentions* and presentation; the server over the *"true" state of
reality* and business logic — a profoundly asymmetric division of labor. Adopting the
CRUD-ish verb set tempts you to treat representations as "platonic data objects whose
existence transcends the client/server boundary," "a descent into solipsism and madness"
that comingles purely-client-side, purely-server-side, and genuinely-shared information and
blurs who is authoritative over facts visible to both. The authority-alignment discipline
here is the same instinct behind [object capabilities](../concepts/object-capability.md) —
make authority travel *with* designation rather than leaving it ambient and confusable.

## Content

### Representational? Differentiable! (visibility vs. authoritativeness)

The idea that resources are manipulated by passing around representations of them, rather
than by operating on them directly, tends to result in **confusion between visibility and
authoritativeness**. The model does not innately distinguish representations of reality
(the way things actually are) from representations of intent (the way somebody would like
them to be). Since the different parties concerned with a resource may be authoritative
with respect to different aspects of it, we can easily end up with **blurry and confused
lines of authority**.

In some cases this can be addressed by **breaking the resource into pieces, each embodying
a different area of concern** — but this only works when the authority boundaries
correspond to identifiable, discrete subsets of the resource's representation. If
authority boundaries are based on considerations that do not correspond to specific
portions of state, you would instead have to invent specialized resources representing
distinct **control channels** of some kind, "which starts looking a lot more like the
imperative model that REST eschews."

Illustration — a **product catalog** where each product is a resource carrying descriptive
information (promotional text, image pointers) and a price used for both display and
billing. We want marketing to update the description but not the price, and accounting to
update the price but not the description. One way is a POST handler that infers which
portions of the resource a request updates and accepts/rejects based on the requester's
credentials. **A more RESTful approach represents the description and the pricing as
distinct resources** — this aligns the authority boundaries with the resource boundaries,
"resulting in a cleaner and simpler system," and "generalizes in all sorts of interesting
and useful ways."

Now a case where the boundary cannot be so cleanly drawn: the descriptive text can be
edited by both the marketing department and the legal department (marketing maximizing
sales appeal, legal minimizing liability). We cannot have one resource for the "marketing
aspects" and another for the "legal aspects" of the same text — it is a singular body of
work and the distinction is too subjective to automate. But we could say legal has final
approval authority, and model this as one resource representing the text in draft form,
another representing the approval authorization, and probably a third representing the
published form. Morningstar thinks this is reasonable — but "the approval resource looks a
lot more like a **control signal** than it looks like a data representation."

### Client representation vs. server representation

A particular concern is that REST's representational conceit "doesn't necessarily take
into account the **separation of concerns between the client and the server**." The
typical division of labor places the **client** in charge of presentation and user
interface and treats it as authoritative with respect to the **user's intentions**, while
placing the **server** in charge of data storage and business logic and treating it as
authoritative with respect to the **"true" state of reality**. This relationship is
"profoundly asymmetrical, as you would expect any useful division of labor to be" — which
means the kinds of things client and server have to say to each other will be very
different even when they are talking about the same thing.

Nothing fundamental in REST says the representations the client transfers to the server
and the ones the server transfers to the client must be the same. Nevertheless, once you
adopt the **CRUD-ish verb set** REST is based on — where every operation is framed in
terms of the representation of a specific resource with a specific URI — you easily begin
to think of these as **platonic data objects whose existence transcends the client/server
boundary**. "This begins a descent into solipsism and madness." The mindset leads to
"confusing and inappropriate comingling" among information of purely client-side concern,
of purely server-side concern, and information truly pertinent to both. In particular one
side or the other is often authoritative over facts visible to both, but the exchanged
representation is defined in a way that **blurs or conceals that authority**. The
confusion is not inherent in REST per se (nor unknown to competing approaches), but it is
a weakness REST designs are prone to unless care is taken.

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
