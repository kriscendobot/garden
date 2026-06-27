---
id: distributed-confinement
aliases: ["distributed confinement", "confinement", "confinement problem", "the confinement problem", "controlled subject", "uncontrolled subject", "non-discretionary capabilities", "Lampson confinement", "calculator confinement", "confinement across vats", "confinement myth"]
topics: [capability-security, capability-theory, captp, hardened-javascript]
---

# distributed-confinement

**Confinement** is Lampson's 1973 problem: a customer wants to run a possibly
untrustworthy service over the customer's own data, confident the service
*cannot leak* that data back to its author or anywhere the customer did not
authorize. **Distributed confinement** is the same guarantee when the confined
subject runs across a distributed object-capability system — SES/Hardened
JavaScript object isolation *within* a vat, plus CapTP *between* vats — so the
confined subject's only channels to the outside world are the capabilities its
customer chose to endow it with, whether those reach a sibling object in the
same compartment or a remote object across a session.

Miller-Shapiro's *Paradigm Regained* §5 gives the canonical capability
solution. Cassie (customer) wants to run Max's (manufacturer's) calculator over
her financial data. Using a `[Factory, factoryMaker]` pair, *Max supplies the
code and Cassie supplies the state*: `factory.new(state)` does
`loader.load(code, state)`, and inspection of the factory shows its state holds
**only data and no capabilities — no access to the world outside itself**.
Cassie can thus verify she is *the only state-providing parent*, making each
calculator a **controlled subject** — born into an environment she controls.
The crucial property is **non-discretionariness**: object-capability systems
have *no principals*, so "even if Alice creates Carol, Alice may only authorize
Bob to access Carol if Alice has authority to access Bob." Confinement holds
*because* capabilities are non-discretionary, refuting the long-repeated
Lampson/Boebert claim that capabilities cannot confine. The deeper lesson
(the *Confinement Myth* of *Capability Myths Demolished*): the myth is *true*
in the weaker capability models (rows / keys) but *false* in the object-
capability model (Model 4), where confinement is achievable. Distributing the
subject does not weaken the result: a controlled subject endowed with no
outward CapTP references has no remote leak channel either, and what
authority it *is* given (a data diode, an attenuating Caretaker) bounds both
its local and its distributed reach by the *behavior* of those abstractions,
not merely by their arrangement.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers/paradigm-regained/access-abstraction-and-confinement (body)](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement--body.md) | **Canonical solution.** Lampson's confinement problem; the Cassie/Max `[Factory, factoryMaker]` pattern (Max's code + Cassie's state, state is data-only); controlled vs uncontrolled subjects; §5.1 non-discretionary model (no principals); §5.2 the data-diode enforcing the *-properties against Boebert's attack — *behavior, not arrangement*, does the confining. |
| [papers/paradigm-regained/access-abstraction-and-confinement (abstract)](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement--abstract.md) | The section's framing: access abstraction as the lost paradigm; confinement as an *abstraction* built from capability primitives. |
| [papers/paradigm-regained/access-abstraction-and-confinement (common confusions)](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement--common-confusions.md) | The disambiguations: discretionary vs non-discretionary, why "capabilities can't confine" keeps being re-asserted. |
| [papers/capmyths/confinement-myth](../sections/papers--miller-capability-myths-demolished-2003--confinement-myth.md) | The *Confinement Myth*: true in capabilities-as-rows / -as-keys (Models 2/3), false in object-capabilities (Model 4); why the myth persists by reasoning in the wrong model. |
| [papers/capmyths/four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) | Property A / D / F are the design conditions a confining arrangement relies on; Model 4 holds all seven, which is *why* confinement becomes achievable. |

## See also

- [[object-capability]] — the substrate. Confinement is achievable only in the Model-4 object-capability model; the *Confinement Myth* is the canonical demonstration that the weaker models cannot.
- [[four-ways-to-acquire-references]] — confinement *depends on* the four-ways constraint: a controlled subject leaks only via references it was *endowed* with (Endowment) or *introduced* to (Introduction), and Cassie can enumerate exactly those because no fifth ambient-authority channel exists.
- [[vat-and-compartment]] — the distributed unit. Within a vat, a compartment confines; across vats, CapTP's lack of ambient inter-vat authority extends the same guarantee — a confined subject has no remote channel it was not handed.
- [[caretaker-pattern]] — the attenuation primitive a customer uses to grant a *bounded* outward channel to a confined subject without granting full authority.
- [[principle-of-least-authority]] — confinement is the extreme of POLA: the confined subject is endowed with the *minimum* outward authority (often none beyond a one-way data diode).
- [[security-as-extreme-modularity]] — the §4.5 reading that every well-encapsulated abstraction is *already* an access abstraction; confinement is that observation pushed to a security boundary.

## Common confusions

- **"Capabilities are discretionary, so they can't confine."** This is the myth. Object-capability systems have *no principals*; the substitution of "subject" for "principal" makes them *non-discretionary*, and §5.1 shows confinement follows. The claim is true only of the weaker (rows/keys) models.
- **"Confinement means the subject is sandboxed with no capabilities."** A confined subject may hold capabilities — just *only* those its customer chose to endow. The data-diode example gives the subject a real channel that is provably one-way for data and zero-way for capabilities. Confinement bounds the channels, it does not forbid them.
- **"Distribution breaks confinement (the network is a leak)."** Only if the subject is handed an outward CapTP reference. A controlled subject endowed with no remote references has no remote leak channel; CapTP grants no ambient inter-vat authority, so the same controlled-subject argument extends across sessions.
- **"It's the kernel/base model that enforces the *-property."** No — §5.2's resolution is that the *abstraction* (the factory + the data diode) enforces; the unmodified base model plus an abstraction built from it are *jointly* what confines. Examining only the arrangement supports Boebert's attack; examining the *behavior* of the diode reveals the tighter bound.
