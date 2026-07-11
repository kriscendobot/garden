---
title: PUT, POST, PATCH, DELETE — the verb-semantics muddle and the read-modify-write problem
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [networking]
status: current
---

## Abstract

Morningstar's worked demonstration of the **impedance mismatch** between HTTP's fixed
verbs and real application operations, centered on the **PUT/POST tension**. In
simplified form PUT is a "Write" and POST an "Update" — "or maybe it is the other way
around; which is which is not really clear." The one clearly-specified rule is that **PUT
must be idempotent** and POST need not be, which makes POST "the universal catch-all
verb." He walks the case analysis that never settles: a resource-creation wants PUT if the
requester names the identity, POST if the server generates it; a full replacement wants
PUT, a side-effectful operation POST; but you rarely want a raw PUT without server-side
validation/canonicalization, and any context-sensitive transformation breaks idempotency
so "maybe use POST" — except ETags can restore the precondition so "maybe PUT after all,"
and he "can keep waffling back and forth indefinitely." **The root problem: most
real-world updates are not pure writes but read-modify-write cycles.** Using PUT for
update forces the client to understand the *complete* state representation (it must supply
it), including embedded state-transition URIs — inviting the client to rewrite the set of
available transitions and undercutting the server's ability to carry state the client need
not model. REST accommodates races with **409 Conflict**, but a server concurrently
touching disjoint state can then raise spurious 409s. **PATCH** (RFC 5789) is "the only
update semantics that makes sense at all" — he would rather redefine PUT to mean PATCH and
drop the extra verb, though that would make PUT non-idempotent. He closes on the
**poverty of error feedback**: a rejected PUT throws the client into "here's an updated
copy of the state you couldn't change; you guess what we didn't like," forcing it to model
every possible failure; and a **DELETE** 405 cannot distinguish a semantic prohibition
(immutable resource) from insufficient authority — "this sort of concern probably applies
to most if not all of the HTTP methods."

## Content

The mapping of the standard HTTP method verbs onto a complete set of operations for
managing an application resource is "tricky and fraught with complications" — another
artifact of the **impedance mismatch** between HTTP and specific application needs.

One continuing source of confusion is the **tension between PUT and POST**. In simplified
form a PUT is a Write and a POST is an Update — "or maybe it is the other way around;
which is which is not really clear." The spec says PUT should store the resource *at* the
given URI while POST stores it *subordinate to* the given URI, but "the action performed
by the POST method might not result in a resource that can be identified by a URI." The
one thing clearly specified is that **PUT is supposed to be idempotent** while POST is not
so constrained — with the result that **POST tends to end up as the universal catch-all
verb**.

The case analysis never settles:

- A resource-creation operation wants **PUT** if the requester specifies the resource's
  identity, but **POST** if the server generates the identity.
- A complete-replacement write wants **PUT**; a side-effectful operation should be
  **POST**.
- But we normally would not want a server to allow a raw PUT without validity checking and
  canonicalization; if that transformation is context-sensitive (including sensitive to
  the previous state), the operation might not be idempotent, "so maybe you should really
  use POST."
- Except that **ETag** headers can ensure the thing being written is what we expected, "in
  which case maybe we can use PUT after all."

"I think I can keep waffling back and forth between these two options indefinitely." It is
not that a very expert HTTP pedant could not name the correct operation in a given case,
"but two different very expert HTTP pedants quite possibly might not give the same answer."

**The root cause is read-modify-write.** At root, "most real world data update operations
are not pure writes but read-modify-write cycles." Regarding PUT as delivering a *total*
replacement requires the client to have a **complete understanding of the state
representation**, since it must supply it in the PUT body — including all the linked URIs
embedded in the representation that drive the state engine, thus "inviting the client to
rewrite the set of available state transitions." Alternatively letting the server
reinterpret or augment the representation during PUT again risks idempotency. Moreover, one
benefit a server brings is the potential to support a **richer state representation than
the client needs to fully understand** (XML/JSON let the client elide the parts it does not
understand) — but a read-modify-write cycle that passes the complete state through the
client forces the client to model the entire state (at least the portions it may edit).

REST accommodates concurrent state change by having the server reject incompatible PUTs
with a **409 Conflict** error — but this means a server wanting to concurrently modify
disjoint portions of state the client might not care about "risks introducing such 409
errors in cases where no conflict actually exists from a practical perspective." More
recent HTTP implementations add the **PATCH** verb for partial updates (not universally
supported). Morningstar thinks PATCH (RFC 5789) is "the only update semantics that makes
sense at all," and we would probably be better off making PUT mean what they call PATCH and
getting rid of the extra verb — though that would make PUT no longer idempotent; the
alternative is to require PATCH always and deprecate PUT entirely.

**Error feedback is impoverished.** PUT update failures throw the client into a mode of
"here's an updated copy of the state you couldn't change; you guess what we didn't like
about your request," instead of a response indicating the particular problem. This forces
the client to model *all* the possible failure cases, whereas a more explicit protocol
only requires the client to understand the failures it can act on and lump the rest into
"problem I can't deal with." As things stand, "the poverty of available error feedback
effectively turns everything that goes wrong into 'problem I can't deal with.'"
**DELETE** has similar trouble: a `405 Not Allowed` could mean either the resource is in a
state from which deletion is semantically forbidden (e.g., an immutable resource) or the
requester lacks authority — "this sort of concern probably applies to most if not all of
the HTTP methods."

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
