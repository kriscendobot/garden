---
id: security-as-extreme-modularity
aliases: ["security as extreme modularity", "security is extreme modularity", "Table 1", "Structure of Authority Table 1", "capability discipline as strict modularity", "modularity gives access control for free", "abstraction as protection"]
topics: [capability-theory, capability-security, patterns]
---

# security-as-extreme-modularity

The claim that **every capability-discipline practice is the strict reading of a software-engineering practice**. Good software-engineering discipline (information hiding, avoiding global variables, lexical naming, encapsulating mutable state, validating inputs, designing for responsibility) and capability discipline (POLA, no ambient authority, no global namespaces, forbidding mutable static state, validating inputs at trust boundaries, designing for authority) are *not* parallel concerns to be balanced. They are the *same discipline* taken to two different stringencies: software-engineering pursues sparse-but-capable *knowledge structures*; capability discipline pursues sparse-but-capable *authority structures* over those same designators. Paradigm Regained 2003 §4.5 names the underlying thesis: "the object-capability model does not describe access control as a separate concern, to be bolted on... rather it is a model of modular computation with no separate access control mechanisms." Structure of Authority 2004 *operationalizes* the thesis into Table 1: a ten-row checklist where each capability-discipline practice is named as the strict form of an existing software-engineering one.

## Table 1 — the canonical ten rows

| Good software engineering    | Capability discipline                  |
| ---------------------------- | -------------------------------------- |
| Responsibility-driven design | Authority-driven design                |
| Omit needless coupling       | Omit needless vulnerability            |
| `assert(...)` preconditions  | Validate inputs                        |
| Information hiding           | Principle of Least Authority           |
| Designation, need to know    | Permission, need to do                 |
| Lexical naming               | No global name spaces                  |
| Avoid global variables       | Forbid mutable static state            |
| Procedural, data, control... | ...and access abstractions             |
| Patterns and frameworks      | Patterns of safe cooperation           |
| Say what you mean            | Mean only what you say                 |

Each right-column entry is just the *strict* reading of the left. "Avoid global variables" is already a best practice; capability discipline raises it from "discouraged" to "forbidden" because mutable global state IS ambient authority. "Information hiding" already endorses need-to-know; POLA adds the parallel need-to-do for authority. "Patterns and frameworks" already encourages reusable design; capability discipline names the *specific* patterns (Caretaker, factory + factoryMaker, Powerbox, attenuating-facet) that compose for safe cooperation.

## The architectural payoff

The thesis carries three structural claims:

1. **No discipline is added by adopting capability discipline.** A programmer already following good software-engineering practice is *most of the way* toward capability discipline. The gap is *cultural* (accepting the strict reading is achievable) more than *technical*.
2. **Modularity gives access control for free.** Every well-encapsulated abstraction is *also* an access abstraction whether the designer thought of it that way or not. Filtering facets, reference monitors, the Caretaker pattern, the Powerbox — all are abstractions whose modularity-side-effect is access control.
3. **Multiplicative attack-surface reduction across nested layers.** Structure of Authority §3.5-§3.8: nested TCBs follow the spawning tree; POLA at each layer multiplies into a recursive attack-surface reduction. The architectural prescription that follows is to build systems that *span a large range of scales* of POLA enforcement, because the multiplicative effect *requires* nesting depth.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity.md) | **The canonical exposition.** Table 1 with all ten rows; the multiplicative attack-surface reduction argument from §3.5-§3.8; the §4 conclusion: "to structure authority in this way, we need *merely* make a natural change to our foundations, and a corresponding natural change to our software engineering discipline." |
| [papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement.md) | §4.5: "the object-capability model does not describe access control as a separate concern... it is a model of modular computation with no separate access control mechanisms." The **2003 thesis** that Table 1 operationalizes in 2004. Every well-encapsulated abstraction is *also* an access abstraction. |
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority.md) | Simon's hierarchy + Hayek's local knowledge as the structural justification: knowledge in well-engineered systems exhibits fractal locality, and authority must follow knowledge to remain enforceable. The four-ways enumeration is the operational constraint on how authority can propagate while remaining under POLA. |
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation.md) | The 2004 reprise of the cp-vs-cat designation lesson, framed via Parnas's information-hiding and POLA-as-its-strict-reading. The §2.1 closing positions security as inseparable from modularity. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola.md) | §6 framing of defensive consistency as the formal target of POLA + modular composition. The thesis applies at the concurrency-control side: defensive consistency *is* modularity-under-concurrency taken to its strict form. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) | The five-precursor E lineage (Smalltalk → Actors → Vulcan → Joule → Original-E → E) is the *historical demonstration* that each precursor's modularity contribution became a security contribution. The historical anchor for the thesis. |
| [papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy](../sections/papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy.md) | The two practical advantages framing (least-privilege operation, confused-deputy avoidance) is Table 1's *operational* counterpart: each advantage names a software-engineering practice (POLA, parameter-not-import authority transfer) that becomes a security property under capability discipline. Table 1's 2004 enumeration is the systematization of this 2003 sketch. |
| [papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) | Properties B (Each Process is a Subject) and G (Dynamic Subject Creation) are the substrate that makes "forbid mutable static state" achievable at the OS / language-runtime layer: without per-process subject identity and dynamic subject creation, "mutable static state" is unavoidable. The 2003 paper names the substrate; Table 1 names the discipline the substrate enables. |
| [endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state](../sections/endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md) | **Worked example of a recorded breach.** `passStyleMemo` is exactly the Table 1 "forbid mutable static state" forbidden construct; the in-code comment names the breach, justifies it (performance), and records the open proxy-observability TODO. Reading this section is reading what a *recorded* Table-1 breach looks like in production capability-discipline code. |

## See also

- [[principle-of-least-authority]] — POLA reads as a security discipline; Table 1 reads as the same thing as good engineering discipline taken to its strict form. The two concept pages are mutually-reinforcing entries into the same thesis.
- [[object-capability]] — the substrate that lets the thesis hold. ACL systems treat access control as a separable concern (because they have to: the ACL is *separate* from the modular code); object-capability systems do not, because the reference graph *is* the access graph.
- [[four-ways-to-acquire-references]] — the structural answer to *how* authority can propagate without violating the thesis. The four mechanisms are POLA-compatible by construction.
- [[caretaker-pattern]] — the canonical worked example of Table 1's "patterns of safe cooperation" row. A modular pattern (forwarder + revoker) whose modularity-side-effect is access control.
- [[smallcaps-encoding]] — Endo's serialization wire format embodies Table 1's "say what you mean / mean only what you say" row: the encoding is deterministic and validating at the boundary, so the wire form *is* the contract.

## Common confusions

- **"This is just OO with security stickers."** OO gives you encapsulation; the thesis gives you the recognition that *encapsulation IS access control*. The shift is conceptual: every abstraction is *already* an access abstraction; the designer just has to *see* it that way and choose accordingly. The thesis is not a new technique on top of OO; it is a new way to read what OO was already doing.
- **"The Table 1 mapping is just a slogan."** Table 1 is doing structural work. Each row is a *testable* claim: "if you practice the left-hand discipline strictly, you have the right-hand security property." Counter-examples are diagnostic — they expose a place where the engineering discipline was *not* practiced to its strict form.
- **"Modularity gives access control for free, so I don't need to think about security."** Modularity gives access control *to the extent* you practice modularity *strictly*. The thesis says the gap between best practice and capability discipline is *cultural*, not technical; closing the gap still requires the cultural shift to the strict reading. "Avoid global variables" is not the same discipline as "forbid mutable static state" until you accept the strict form.
- **"This makes security analysis trivial."** It makes security analysis *the same as* modularity analysis. That is not trivial — it is the *transfer* of the difficulty from a separate access-control review to the same code review the team already does. The benefit is that you no longer have a *separate* concern; the cost is that the existing concern now bears a heavier load.
- **"Multiplicative attack-surface reduction is too vague to be useful."** Structure of Authority §3.8 concedes that *quantifying* the reduction is largely inaccessible (knowledge limits). The *structural* claim — that nesting layers of POLA enforcement compose multiplicatively rather than additively — is testable, and rests on the §3.5 spawning-tree argument. Quantification matters less than structural soundness; the architectural prescription (build deep, not flat) is the actionable consequence.
- **"`Forbid mutable static state` is impossible in JavaScript."** SES's `lockdown()` is what makes Table 1's row achievable in Hardened JavaScript: freezing intrinsics removes the substrate for mutable static state. Endo's compartment discipline maintains the property across guest modules. The discipline is achievable; it requires the substrate to support it.
