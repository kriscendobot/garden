---
id: competence-vs-performance-modularity
aliases: ["competence vs performance modularity", "competence-vs-performance modularity", "competence modularity", "performance modularity", "safety and liveness vs efficiency", "what programs can do vs how efficiently they do it", "object-orientation modularizes competence", "markets modularize performance"]
topics: [capability-theory, capability-security, patterns]
---

# competence-vs-performance-modularity

The **structural distinction** Miller-Drexler 1988 §4.3 introduces between two orthogonal dimensions of program activity:

- **Competence** refers to *what a program can do* given sufficient resources — safety (what the program will not do) plus liveness (whether the program will eventually do what it is supposed to). The competence dimension is the natural concern of object-oriented programming and capability discipline.
- **Performance** refers to *the resources a program will use*, the efficiency with which it will use them, and the time it will take to produce results — issues that competence-analysis explicitly ignores.

The architectural payoff, summarized in the 1988 paper's Figure 4: **computational markets do for performance modularization what object-oriented programming does for competence modularization**. Object-orientation provides message-protocols as abstract interfaces for competence effects; computational markets provide prices as abstract interfaces for resource costs. The two disciplines are *orthogonal but composable*: a system can practice both, with each layer modularizing its own concerns without entanglement.

The library has been *implicitly* using this distinction for the entire decomposition-cycle history — security-as-extreme-modularity is the competence-side story; the agoric-system framing is the performance-side story — but the cycle-78 concept page makes the distinction *explicit*. The two dimensions correspond to two different kinds of modularity:

| | Formal Analysis | Modularity |
|---|---|---|
| **Competence**, Safety, Liveness | Semantics, Correctness proofs | Object-oriented programming, Message passing |
| **Performance**, Efficiency | Complexity theory, Proofs of response time | **Computational markets, Prices** |

A program's *competence interface* is its method protocol; a program's *performance interface* is its price function. Endo today modularizes competence well (exo + marshal + lockdown); performance modularization via prices is largely unrealized in Endo (Agoric SwingSet's meter discipline is the closest production enactment).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations.md) | **Canonical exposition.** §4.3 introduces the competence-vs-performance distinction and Figure 4. The thesis: "computational markets will aid modularization of performance issues, with prices serving as an abstract interface for resource costs." |
| [papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies](../sections/papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies.md) | §5 *Agents and strategies*: business agents are performance-domain delegates; subcontractors are competence-domain delegates. The distinction is operational at the §5.3.1 data-type-agent level (a lookup-table agent selects an *implementation* — a performance decision — while preserving the abstract *interface* — a competence invariant). |
| [papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems.md) | §I.6 Summary of Appendix I (issues × levels): correctness is the low-level competence concern; coherence is the high-level competence concern. Performance issues map analogously. |
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity.md) | Table 1 — security as extreme modularity — is the *competence-side* enactment of the 1988 thesis at the strict reading. Every right-column entry is a competence-modularity practice. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola.md) | Defensive correctness + defensive consistency are the competence-side concurrency-control disciplines. The 2005 paper does not address the performance-side; that remains the 1988 paper's domain. |
| [endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly](../sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) | The handled-promise reduction-into-get-plus-applyFunction is *competence-modular* — the reduction preserves message semantics while enabling implementation-level optimization. A performance-modularization layer would charge for the reduction; the Endo enactment does not yet. |
| [endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants](../sections/endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants.md) | The smallcaps encoding is competence-modular — it ensures byte-exact serialization across implementations. Performance considerations (encoding speed, message size) are handled separately. |

## See also

- [[security-as-extreme-modularity]] — the competence-side discipline operationalized in 2004's Table 1. Every entry there is a competence-modularity practice.
- [[agoric-system]] — the broader framing under which performance modularization via markets becomes operational.
- [[business-agent]] — performance-domain delegate; the §5 1988 paper's machinery for delegating performance decisions while preserving competence invariants.
- [[principle-of-least-authority]] — POLA is a *competence-side* discipline (it constrains *what* an object can do); the agoric-system performance-side analog would be *least resource consumption*.
- [[object-capability]] — the substrate that makes competence modularization possible. Performance modularization requires the substrate plus resource encapsulation (the §4.2 1988 paper's framing).
- [[smart-contract]] — contracts are competence-modular (the contract *terms* are the competence interface); their gas/meter cost is the performance modularization layer Agoric Zoe enacts.

## Common confusions

- **"Competence and performance are the same as safety and efficiency."** Close but more precise. *Competence* includes safety (what the program will not do) *and* liveness (whether the program will eventually do what it is supposed to); *performance* includes efficiency *plus* time-to-produce-results plus resource-consumption-profile. The §4.3 1988 framing is explicit on this split.
- **"Performance modularization eliminates the need for performance proofs."** No — §4.3's claim is that markets *modularize* performance concerns the same way OO modularizes competence concerns. *Within* a performance module, formal performance analysis (complexity theory, proofs of response time) still applies; *across* modules, prices serve as the abstract interface. Compositional reasoning replaces global reasoning.
- **"Endo modularizes performance."** Partially. Endo today modularizes competence well (exo + marshal + lockdown); the performance-modularization story is at best partial (Agoric SwingSet's meter-and-fuel discipline addresses one corner). The §4.3 thesis is unrealized at the @endo level; this is one of the clearest *gaps* in the contemporary Endo architecture.
- **"Object-orientation already addresses performance."** OO addresses *encapsulation* of performance characteristics (a class can hide its internal performance from clients), but does not modularize the *cross-class performance tradeoffs* — the §5.3.1 data-type-agent example demonstrates this gap. A lookup-table agent in an agoric system can switch implementations based on usage patterns; in pure OO, the choice of implementation is made once at instantiation and cannot adapt without re-instantiation.
- **"This is just a 1988 framing, not contemporary."** §4.3's framing is *more* relevant in contemporary systems: serverless / FaaS billing realizes the *charge-per-use* layer at coarse granularity; per-method metering in Agoric Zoe contracts realizes it at fine granularity; the §4.3 thesis is gradually being enacted at multiple scales. The library can cite this section whenever a design needs the structural framing for *why* performance and competence are orthogonal concerns.
- **"Competence subsumes performance."** No — competence ignores performance by definition. A program with terrible performance is still *competent* if it eventually produces correct results. The §4.3 distinction is what makes that observation operationally useful: competence-correct programs that are unusable in practice for performance reasons need a *separate* discipline to address.
