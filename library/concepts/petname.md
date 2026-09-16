---
id: petname
aliases: ["petname", "petnames", "petname system", "pet name", "per-holder naming", "Zooko's triangle", "edgename", "petname path"]
topics: [identity, distributed-objects]
---

# petname

A **petname** is a name a holder chooses for an object, private to that holder, and bound one-to-one to an object reference: the holder's own stable, memorable handle for a capability, as distinct from a globally-unique identifier (which no party controls in a decentralized system) or a human-meaningful-but-non-unique "nickname". Petname systems are the naming layer over an object-capability substrate: because a capability designates an object without carrying an authoritative name, *naming* is supplied separately and per-context — the same object may be called different things by different holders, and a holder's petname for an object is the same regardless of who introduced the reference. The design point petnames continually raise is that a strictly object-identifying name can *hide* semantically-relevant distinctions the machine layer cares about — for example, two references to the same object obtained by different delegation paths carry different message-ordering guarantees under E-order, yet a petname would show them as one name (Karp's "petnames versus E-order" open question). Endo and OCapN use petnames (and petname *paths* / edgenames) as the human- and code-facing naming layer for guests, formulas, and remote presences, keeping the name a per-context binding rather than an intrinsic, forgeable global identifier.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cap-talk-2009-2012--petnames-versus-e-order](../sections/cap-talk-2009-2012--petnames-versus-e-order.md) | Karp's open question: a petname's object-identifying rule ("same object, same name") collapses the delegation-edge distinction E-order needs, so a petname UI can hide which reference carries the message-ordering guarantee. |
| [cap-talk-2009-2012--file-api-taming-tahoe](../sections/cap-talk-2009-2012--file-api-taming-tahoe.md) | Name-free file/directory capabilities (a file does not know its own name; naming is a per-directory binding), and the (directory, name) tuple that restores just enough naming context to compute siblings. |
| [endo-but-for-bots--packages-chat-message-parse-js--petname-regex-validates-and-extracts-and-petname-edgename-naming-inversion](../sections/endo-but-for-bots--packages-chat-message-parse-js--petname-regex-validates-and-extracts-and-petname-edgename-naming-inversion.md) | Endo chat's petname/edgename parsing: the concrete petname-path syntax and the petname-vs-edgename naming inversion in practice. |
| [cap-talk-2009-2012--zookos-triangle-and-petname-mappings](../sections/cap-talk-2009-2012--zookos-triangle-and-petname-mappings.md) | Petnames and lambda names combine memorable and securely unique naming but differ in the direction of their mappings. |

## See also

- [[web-key]] — the capability *representation* that a petname names; petnames are the human layer, web-keys/sturdyrefs the wire layer.
- [[delegates-and-epithets]] — the adjacent naming/attribution concept (names as delegated epithets).
- [[object-sameness]] — whether two references denote "the same" object, the equality question a petname's one-to-one binding presumes an answer to.

## Common confusions

- **"A petname is a global username."** No — a petname is *per-holder* and need not be unique or shared; two holders may use different petnames for the same object, and a petname is meaningful only relative to the holder who assigned it.
- **"Petname = the object's real name."** A capability-designated object has no authoritative name; a petname is a binding a holder (or a directory) supplies, not a property the object carries.
