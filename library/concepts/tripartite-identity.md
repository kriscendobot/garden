---
id: tripartite-identity
aliases: ["tripartite identity", "tripartite identity pattern", "tripartite identity model", "three-identifier model", "account identifier", "login identifier", "public identifier", "social identity", "session authentication identifier", "DB key identity", "Randy Farmer tripartite", "identity decomposition"]
topics: [identity, capability-security]
---

# tripartite-identity

Randy Farmer's **tripartite identity pattern** (Habitat Chronicles, 2008): a user's identity
should be **decomposed into three separable identifiers**, each carrying a single role,
rather than conflated into one overloaded handle (the conflation — e-mail doubling as login
*and* public name — is what farmed the spam that drove users away, per Yahoo!'s finding). The
three legs:

- **Account identifier (DB key)** — one **permanent, unique, random** database key; the
  "closest thing the company has to a user," **not under the user's control**, and
  **invisible/inert** with **no inherent public capabilities** (not an e-mail, login name,
  public name, or IM address). Its permanence is what lets the other two legs churn without
  data-migration pain, and its capability-free character is **POLA applied to identity** — the
  value that *names* the account confers no authority by being seen.
- **Login identifier(s)** — the session-authenticating credential: historically a
  name/password pair, but the service may **adopt an external namespace** (verified e-mail) or
  accept **capability-based logins** federated from OpenID / OAuth / Facebook Connect (a
  delegated session-establishing capability, not a re-typed password). Separation from the
  account buys customization, mitigated migration, account-crack protection, and
  multi-supplier aggregation.
- **Public identifier(s)** — the deliberately **non-unique, compound, mutable, context-plural**
  social face (photo + nickname + profile); **multiple personas per context**, never used to
  authenticate.

The 2008-11-12 Internet Identity Workshop update states the load-bearing insight for the
garden's ocap access-control lineage: **no publicly shared identifier is required (or even
desirable) for session authentication** — a relying party should see only the Public ID plus a
**permission-bound session key** granting scoped access to the account. Account IDs are
**local** to a context/site/RP, not global; publicly-sharable capability-based identifiers
(e-mail, readable URLs, phone numbers) are held **out of scope**, handled separately by the RP.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [habitat-chronicles--tripartite-identity-pattern--overview](../sections/habitat-chronicles--tripartite-identity-pattern--overview.md) | The problem (conflated identifier roles discourage participation; Yahoo!'s e-mail-farming datum) and the three-component thesis. |
| [habitat-chronicles--tripartite-identity-pattern--account-identifier](../sections/habitat-chronicles--tripartite-identity-pattern--account-identifier.md) | The permanent, inert, random DB key with **no inherent public capabilities** — POLA applied to identity. |
| [habitat-chronicles--tripartite-identity-pattern--login-identifier](../sections/habitat-chronicles--tripartite-identity-pattern--login-identifier.md) | Name/password or federated **capability-based logins** (OpenID / OAuth / Facebook Connect); the four separation payoffs. |
| [habitat-chronicles--tripartite-identity-pattern--public-identifier](../sections/habitat-chronicles--tripartite-identity-pattern--public-identifier.md) | The non-unique, compound, mutable, **context-plural** social face; multiple personas per context. |
| [habitat-chronicles--tripartite-identity-pattern--iiw-critiques-and-scope](../sections/habitat-chronicles--tripartite-identity-pattern--iiw-critiques-and-scope.md) | The IIW key insight (no public identifier for session auth; **permission-bound session key**), local-not-global account IDs, and capability-based identifiers as out of scope. |

## See also

- [[object-capability]] — the model the pattern echoes at the identity layer: the account anchor holds **no ambient authority** (Property D) and grants nothing on presentation, while a federated login is a **capability-based** session credential; the RP's permission-bound session key is the capability, not the public name.
- [[confused-deputy]] — the failure mode the decomposition guards against: keeping the inert DB key distinct from capability-bearing identifiers (e-mail, readable URLs) stops a leaked handle from doubling as a designator *and* an authority the way ambient identity does.
- [[delegates-and-epithets]] — the Endo daemon's kindred **identity-relationship** model; both split a durable anchor from the context-carrying, delegable, verifiable face of an identity (agent-side epithets vs. user-side public identifier).
- [[habitat-unum]] — the sibling habitat-chronicles.com concept (Chip Morningstar's distributed-object pattern); same essay corpus, adjacent Electric-Communities / social-computing lineage.

## Common confusions

- **"The account identifier is the username."** No — the account identifier is a permanent, random, user-invisible DB key that is explicitly **not** a login name or a public name; conflating them is the exact anti-pattern the essay names.
- **"OpenID/OAuth logins replace the account identifier."** No — a federated capability-based login is a *login identifier* that authenticates a session; it is attached to the permanent account identifier underneath (and a single account may attach several such logins).
- **"A public identifier must be unique."** No — public identifiers are deliberately non-unique (thousands of John Smiths); uniqueness is the account identifier's job, not the social face's.
