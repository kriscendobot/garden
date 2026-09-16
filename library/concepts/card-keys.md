---
id: card-keys
aliases: ["card keys", "card key", "swipe card", "swipe cards", "card keys are capabilities", "Shapiro card key analogy"]
topics: [capability-theory, capability-security]
---

# card-keys

Jonathan Shapiro's founding cap-talk analogy (1998): a building **card key** looks like an access-control list (many individually-rescindable cards, a modifiable set of doors, central deletion) but is *actually a capability that is difficult to copy*. Security rests on the *token* you hold, not on your *identity* — hand me your card and I get into the building, exactly as with a capability. The ACL-like features are an ACL constructed on top of a capability primitive: give each capability a unique identifier and interpose a **destroyable indirection object**, so a single card can be rescinded (destroy its indirection) without reissuing everyone's cards. The analogy is the intuition pump for the whole capabilities-vs-ACLs argument, and the indirection object it introduces is the EROS revocation primitive (the caretaker/forwarder pattern).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cap-talk-1998--card-keys-are-capabilities](../sections/cap-talk-1998--card-keys-are-capabilities.md) | The analogy in full: token vs. identity; the three ACL-looking features explained as capability-primitive constructions. |
| [cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys](../sections/cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys.md) | Frascadore's originating swipe-card-vs-key framing that Shapiro answers. |
| [cap-talk-1998--capability-ids-and-indirection-revocation](../sections/cap-talk-1998--capability-ids-and-indirection-revocation.md) | The destroyable indirection object that makes a card-key rescindable, and grows the key-ID space. |
| [cap-talk-2000-2001--authorization-certificates-are-all-around-us](../sections/cap-talk-2000-2001--authorization-certificates-are-all-around-us.md) | Everyday bearer/authorization certificates (credit card as designation-not-authentication, cookies, order tickets); the card-key pattern is the world's default. |

## See also

- [[capabilities-vs-acls]] — the argument the analogy serves.
- [[revocation-by-withdrawal]] — the modern generalization of the destroyable-indirection revocation.
