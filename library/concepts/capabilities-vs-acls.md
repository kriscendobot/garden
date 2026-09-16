---
id: capabilities-vs-acls
aliases: ["capabilities vs ACLs", "capabilities versus ACLs", "ACL vs capability", "capability vs ACL", "access control list vs capability", "ACLs on capabilities", "capabilities on ACLs", "equivalence myth", "are ACLs and capabilities equivalent", "identity vs token", "token vs identity"]
topics: [capability-theory, capability-security, cap-talk-open-questions]
---

# capabilities-vs-acls

The comparison at the center of object-capability security: an **access-control list** decides access by asking *who is asking?* (subject identity, checked against a per-resource list), while a **capability** decides access by *possession of an unforgeable reference* that fuses designation and authority. The two are **not equivalent**. An ACL-like mechanism can be built efficiently on top of a capability system (a group manager plus a first-class user object); the reverse is "almost impossible and damned inefficient" because user identity authorizes *multiple* objects, violating the requirement that a capability name a single unique object, and separating authority from the object identifier. The asymmetry has practical teeth: delegation, confinement, and the principle of least authority are unsolvable with ACLs (confinement provably so), and ACLs' delay-the-access-check-until-a-late-stage structure is the root of the confused-deputy family. Jonathan Shapiro laid out the whole argument on the founding cap-talk thread in 1998 ("card keys are actually capabilities that are difficult to copy"); Miller-Yee-Shapiro's *Capability Myths Demolished* (2003) later formalized it as the Equivalence Myth over four models.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cap-talk-1998--card-keys-are-capabilities](../sections/cap-talk-1998--card-keys-are-capabilities.md) | Token vs. identity; ACLs build on capabilities cheaply, not the reverse; confinement provably unsolvable with ACLs (Shapiro 1998). |
| [cap-talk-1998--acls-on-capabilities](../sections/cap-talk-1998--acls-on-capabilities.md) | The group-manager + user-object recipe for ACL-on-capabilities; why capabilities cannot be built on ACLs; UNIX fd is a capability. |
| [cap-talk-1998--acl-vs-capability-challenge-problems](../sections/cap-talk-1998--acl-vs-capability-challenge-problems.md) | Shapiro's challenge problems; the hard part of the ACL solution is reconstructing caller identity, which a capability never needs. |
| [papers--miller-capability-myths-demolished-2003--equivalence-myth](../sections/papers--miller-capability-myths-demolished-2003--equivalence-myth.md) | The 2003 formalization: properties A/B/C; references-as-arrows shows the models differ by arrow direction. |
| [papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat](../sections/papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat.md) | The three structural failures of ACLs (authorize, authenticate, accountability). |
| [cap-talk-1998--capability-definition-and-delegation](../sections/cap-talk-1998--capability-definition-and-delegation.md) | Designation plus permitted operations; recursive delegation exposes the owner-only ACL mismatch. |
| [cap-talk-1999--principal-attribution-proxies-and-confinement](../sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md) | A principal label on a capability cannot distinguish direct action, delegation, proxying, or confused use. |
| [cap-talk-1999--principal-policy-and-confinement-debate](../sections/cap-talk-1999--principal-policy-and-confinement-debate.md) | The unresolved 1999 debate over principal policy inside controlled compartments. |
| [cap-talk-2002-2003--normal-users-can-construct-least-authority](../sections/cap-talk-2002-2003--normal-users-can-construct-least-authority.md) | Proposed row-plus-column matrix distinction and the normal-user creation criterion that fed the four-model analysis. |
| [cap-talk-2002-2003--li-gong-keykos-and-capability-myths](../sections/cap-talk-2002-2003--li-gong-keykos-and-capability-myths.md) | On-list reaction to critiques that excluded KeyKOS and conflated authentication with authorization. |
| [cap-talk-2002-2003--state-transition-model-of-trust-management](../sections/cap-talk-2002-2003--state-transition-model-of-trust-management.md) | An early formal ACL-vs-capability comparison whose capability model omits forwarders, wrongly ranking trust management above capabilities. |
| [cap-talk-2002-2003--capability-myths-demolished-reception-and-usenix-rejection](../sections/cap-talk-2002-2003--capability-myths-demolished-reception-and-usenix-rejection.md) | The USENIX committee read the ACL-vs-cap myth-demolitions as minor nitpicks; Miller's post-mortem on why the argument failed to land. |
| [cap-talk-2002-2003--access-matrix-column-vs-row-distinction](../sections/cap-talk-2002-2003--access-matrix-column-vs-row-distinction.md) | Extending a privilege needs the matrix column in ACLs but the column and the row in capabilities; the real difference is behaviour under untrusted code. |
| [cap-talk-2002-2003--programming-with-capabilities-without-ownership](../sections/cap-talk-2002-2003--programming-with-capabilities-without-ownership.md) | A capability program models each authority as a delegable facet instead of attaching an exclusive owner identity to every object. |
| [cap-talk-2004-2008--reference-versus-capability](../sections/cap-talk-2004-2008--reference-versus-capability.md) | A reference carries capability meaning only when possession authorizes its behavior under unforgeable acquisition rules. |
| [cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies](../sections/cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies.md) | An ACL-shaped application can recreate identity lookup and confused deputies on a pure ocap substrate. |
| [cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09](../sections/cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09.md) | The 2009 list reception of Close's "ACLs don't": reviewers concede the access-matrix equivalence is "incorrect" yet reject the paper as decades-old — the equivalence myth dismissed as obvious yet unabsorbed. |
| [cap-talk-2013-2016--identity-policy-at-grant-time-not-use-time](../sections/cap-talk-2013-2016--identity-policy-at-grant-time-not-use-time.md) | Identity or roles may narrow a capability grant without becoming the later access decision; policy subtracts authority at delegation time. |
| [cap-talk-2013-2016--macaroons-capabilities-versus-credentials](../sections/cap-talk-2013-2016--macaroons-capabilities-versus-credentials.md) | Macaroons are capability-friendly bearer tokens only when use couples one explicit designator to authority; credential-pool use remains identity/predicate shaped. |

## See also

- [[principle-of-least-authority]] — one of the disciplines ACLs cannot express.
- [[confused-deputy]] — the attack class ACLs structurally admit and capabilities prevent.
- [[card-keys]] — Shapiro's analogy that card keys are hard-to-copy capabilities.
- [[revocation-by-withdrawal]] — how capability systems take authority back.
