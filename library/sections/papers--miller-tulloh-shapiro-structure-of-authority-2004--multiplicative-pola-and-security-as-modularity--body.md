---
title: Body
source: "The Structure of Authority: Why Security Is Not a Separable Concern (MOZ 2004, LNAI 3389)"
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_paper_pages: "15-18 (§3.5 Nested TCBs, §3.6 Subcontracting, §3.7 Legacy, §3.8 Multiplicative Reduction, §4 Conclusions)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity
---

### §3.5 Nested TCBs follow the spawning tree

The nesting of subsystems within each other (Simon's hierarchy) corresponds to a *spawning tree*: at each level, the TCB of that subsystem creates the initial population of sub-subsystems within it, and endows each with their initial portion of the authority granted to the parent as a whole. The organization decides what Alan's responsibilities are; Alan's account is configured with the initial authorities appropriate to those responsibilities. Doug uses CapDesk to endow CapMail with access to his SMTP server *by static configuration*. CapMail's main() module grants this access to its imported SMTP module. A lambda expression with a free variable `c` evaluates to a closure whose binding for `c` is provided by its creation context.

The §3.5 structural insight: *the spawning tree has Simon's hierarchic structure*. This means **mostly-static approaches to POLA — such as policy files — may succeed at mirroring this structure** at the initial-conditions level, even though the system as a whole must support dynamic POLA via Introduction (the §3.4 first way). Static configuration is not the wrong tool; it is the right tool *only for the initial-conditions slice* of the access graph. The rest of the system needs dynamic mechanisms.

### §3.6 Subcontracting forms dynamic networks of authority

Among the already-instantiated components, the paper observes a *network of subcontracting relationships* whose topology dynamically changes as components make requests of each other. Examples:

- Barb finds she needs to collaborate with Alan.
- Doug selects `killer.xls` in an open-file dialog box.
- Object A passes a reference to object C as an argument in a message to object B.

In all these cases, *by following capability discipline*, the least authority the subcontractor needs to perform a request can often be painlessly conveyed *along with the designations* that such requests must already carry. The argument turns the security cost of POLA on its head: the access-graph adjustments needed to allow the subcontractor to do its job are often **identical to the adjustments already made to the reference graph for purely functional reasons**. There is no extra security-bookkeeping; designation IS authority transfer.

This is the §1.1 cat lesson recast as a general architectural principle. cat's least-authority story works because the *file descriptor passed via < and >* is simultaneously the *designation* of what to copy and the *authority* to read/write it. Generalize that pattern to all subcontracting relationships, and authority allocation becomes a *side effect* of doing functional work — not a separate bookkeeping discipline.

### §3.7 Legacy limits POLA, but can be managed incrementally

Among the subsystems within each system, the paper acknowledges that one must engineer for peaceful *co-existence* between POLA-disciplined components and legacy components. Only such co-existence enables non-legacy systems to be adopted incrementally — the alternative (rewrite everything at once) is operationally impossible for any real system.

For legacy components, POLA can and must be practiced separately. The paper's example: Polaris restricts the authority available to `killer.xls` without modifying the spreadsheet itself, Excel itself, or WindowsXP. POLA is imposed *at the boundary*. The acknowledged limit: one cannot enable the legacy component to *further practice POLA* with the portion of authority it grants to others or to its sub-components. The legacy boundary is the inner limit of POLA discipline; nothing finer-grained can be enforced inside.

The §3.7 incremental-adoption framing is the paper's only concession to operational pragmatism, and it is a careful one: incremental adoption *works* because each legacy component replaced extends POLA's reach one node further into the spawning tree, and the multiplicative attack-surface reduction of §3.8 means each replacement compounds the prior gains. There is no all-or-nothing pressure.

### §3.8 Nested POLA multiplicatively reduces attack surface

The cross-hatching within the non-legacy boxes in the four-level figures — such as the `~alan` row — represents the paper's *abstract* claim that exposure was further reduced by practicing POLA within those boxes. The §3.8 framing makes the claim concrete via the fine structure shown in the non-legacy boxes that were zoomed into (such as the `~doug` box):

> Whatever fraction of the attack surface we removed at each level by practicing POLA — these effects compose to create a *multiplicative reduction* in our overall exposure. Secure languages used according to capability discipline can extend POLA to a much finer grain than is normally sought. By spanning a large enough range of scales, the remaining attack surface resembles the area of a fractal shape which has been recursively hollowed out.

The paper concedes that *quantifying* this multiplicative claim is largely inaccessible (the knowledge needed to weight attack-surface cells is not available in practice). But the *structural* claim is testable in principle, and the architectural prescription follows from it: build systems that span a *large range of scales* of POLA enforcement, because the multiplicative effect *requires* nesting depth to produce significant reduction. A single level of POLA is not the architectural payoff; the payoff is recursive POLA from organization down to language-level objects.

### Table 1 — Security as extreme modularity

The paper's most-quoted contribution is a single 10-row table that lines up *good software engineering* practices against *capability discipline* practices and shows each as the strict reading of the other:

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

The paper's framing: every right-column entry is just the *strict* form of the left-column entry. "Information hiding" is what software engineering already endorses on a need-to-know basis; POLA is the same discipline on a need-to-do basis. Mutable global state is already discouraged by good software engineering for reasons of testability and maintainability; capability discipline raises that from "discouraged" to "forbidden" because mutable global state IS ambient authority. Lexical naming is preferred by software engineering for reasons of readability and scoping; capability discipline raises that to "no global name spaces at all" because global name spaces are also ambient designation, which is also ambient authority.

The architectural claim is that **a programmer who already follows good software-engineering discipline is most of the way toward capability discipline**. They just have to take each practice to its strict reading and stop accepting "in practice we can't" excuses where the language permits the strict form. Object-capability languages remove the language-level barriers to strict adherence.

### §4 Conclusions

To build useful and usable systems, software engineers build sparse-but-capable *dynamic structures of knowledge*. The systems most successful at supporting these structures — object, lambda, and concurrent logic languages — exhibit a curious similarity in their *logic of designation*. Patterns of abstraction and modularity divide knowledge and then use these designators to compose divided knowledge to useful effect. Software-engineering discipline judges design patterns *partially by their support for the principle of information hiding* — by the sparseness of the knowledge structures they build from these designators.

The paper closes by claiming the dual:

> To build useful, usable, and safe general-purpose systems, we must leverage these impressive successes to provide correspondingly sparse-but-capable dynamic *structures of authority*. Only authority structures aligned with these knowledge structures can both provide the authority needed for use while narrowly limiting the excess of authority available for abuse. To structure authority in this way, we need "merely" make a natural change to our foundations, and a corresponding natural change to our software engineering discipline.

Capability discipline judges design patterns by their support for the principle of *least authority* — by the sparseness of the authority structures they build from these permissions. Not only is this change needed for safety; it also *increases* the modularity needed to provide ever greater functionality. The paper's penultimate sentence positions the work modestly: this is a proof-of-concept system consisting of *E*, *CapDesk*, and *Polaris* that explains an integrated approach for using object-capability foundations to build general-purpose systems "simultaneously safer, more functional, more modular, and more usable than is normally thought possible."
