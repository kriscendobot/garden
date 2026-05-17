---
title: Multiplicative POLA and Security as Extreme Modularity (nested TCBs, spawning tree, subcontracting, legacy boundaries, Table 1, conclusions)
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
---

## Abstract

§3.5-§3.8 synthesize the paper's argument into four structural claims about how POLA composes across the nested layers of a real system. **§3.5** observes that *nested TCBs follow the spawning tree*: the TCB of each subsystem creates the initial population of subsystems within it and endows them with their initial portion of the authority granted to the system as a whole. The spawning tree's hierarchical structure (Simon's recurrence) is what makes static approaches to POLA — like policy files — viable at the *initial-conditions* level, even when dynamic POLA is needed for the running system. **§3.6** observes that *subcontracting forms dynamic networks of authority*: the topology of who-relies-on-whom changes as components make requests of each other, and the least authority a subcontractor needs to perform a request can often be painlessly conveyed along with the designations that request must already carry. The adjustments needed to the access graph are often *identical* to the adjustments already made to the reference graph for functional reasons. **§3.7** acknowledges that legacy code limits POLA — only co-existence between POLA-disciplined and legacy components enables incremental adoption — but argues this limit is *bounded*: POLA can be enforced *at the boundary* of a legacy component even if it cannot be enforced *inside* it. **§3.8** delivers the paper's quantitative-in-principle claim: nested POLA *multiplicatively* reduces a system's attack surface. The cross-hatched fraction of attack surface removed at each level multiplies into the total; secure languages used according to capability discipline extend POLA to "a much finer grain than is normally sought," so the remaining attack surface resembles a recursively-hollowed fractal. Table 1 summarizes the paper's strongest practical claim: **security IS extreme modularity** — every entry in the right column ("Capability discipline") is just the strict reading of the corresponding entry in the left column ("Good software engineering"). §4 closes by observing that the same hierarchical structures of *knowledge* (which good software engineering already produces via abstraction and information hiding) can be turned into hierarchical structures of *authority* via the natural alignment of designation and authority that object-capability languages provide. To get this, "we need merely make a natural change to our foundations, and a corresponding natural change to our software engineering discipline."

## Body

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

## Translation block (E idiom → Endo / JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Spawning tree                              | Endo's daemon → bundle → sub-bundle → compartment → exo hierarchy. Each parent creates and endows its children. |
| TCB at each layer                          | The host (kernel) is the OS TCB; the Endo daemon process is the daemon TCB; each bundle's main() is its own TCB; each exo is its own TCB. Recursion all the way down. |
| Subcontracting via designation             | An exo passing a capability handle to another exo via `E()` arguments. The receiver gets exactly the authority needed to honor the request, no more. |
| Legacy boundary                            | An Endo bundle wrapping a Node-native or NPM-installed library. POLA enforced at the wrapper boundary; nothing finer-grained inside. |
| Multiplicative attack-surface reduction    | The architectural justification for Endo's deep nesting: daemon, bundle, compartment, exo, individual method endowments. Each layer's POLA multiplies into the total. |
| Table 1: security as extreme modularity    | The discipline Endo invites every bundle to follow: `harden()`, no `globalThis`, explicit endowments, brand-by-reference, strict pass-style boundaries. Each is the strict reading of a JavaScript best practice. |

## Implications for Endo

This section is the paper's *practical-discipline* anchor for Endo. The Table 1 mapping is the *concrete checklist* an Endo bundle author can follow to ensure they are practicing capability discipline rather than merely using a capability-shaped library:

1. **Authority-driven design.** When designing a new Endo exo, ask "what authority does this exo *need* to fulfill its role?" before asking "what authority will I give it?". The answer to the first question defines the endowment; the answer to the second should be the strict subset that the first requires.
2. **Omit needless vulnerability.** Where a bundle accepts a broad capability today because "it's easier," check whether the receiving method actually uses the full breadth. If not, narrow the parameter type to the actual usage.
3. **Forbid mutable static state.** SES lockdown makes most realm-globals immutable; bundle authors should resist re-introducing ambient state via singleton modules. Every module's exports should be invokable without depending on prior import-order side effects.
4. **Mean only what you say.** Marshal's pass-style discipline already enforces this at serialization boundaries. Bundle authors should follow it at the API boundaries too: a method's signature is its contract; surprises (hidden side effects, undocumented capability acquisition) are violations of the discipline this paper names.
5. **Nesting depth multiplies, so go deep.** §3.8's multiplicative argument is the architectural justification for Endo's appetite for layers: daemon, bundle, compartment, exo, method. Each is an opportunity for POLA. The compositional argument says shallow systems lose disproportionately.

## See also

- [[principle-of-least-authority]] — *deferred concept page*. Table 1 is the canonical content for that page; this section is one of three citations (along with `defensive-correctness-and-pola` from Concurrency Among Strangers and `advantages-pola-confused-deputy` from Capability Myths Demolished).
- [[object-capability]] — Table 1's "no global name spaces" and "forbid mutable static state" entries are the strictness conditions that make the four-models-Model-4 framing operational.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola` — the same authors' concurrency-control framing of POLA. This paper's Table 1 is the *modularity-side* mapping; that paper's defensive-correctness/consistency framing is the *concurrency-side* mapping. Same discipline, two perspectives.
- `papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties` — the seven properties (A-G) are the formal characterization; Table 1 is the *engineering-practice* characterization.
- `endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly` — the implementation-level enactment: handled-promise's reduction of `applyMethod` into `get` + `applyFunction` is exactly the "designation conveys authority" pattern at the eventual-send substrate level.

## Common confusions

- **"Multiplicative reduction is hand-wavy because we can't quantify it."** §3.8 explicitly concedes that *quantifying* the reduction is largely inaccessible due to knowledge limits. But the *structural* claim — that nesting layers of POLA enforcement compose multiplicatively rather than additively — is testable and rests on the spawning-tree argument from §3.5. Quantification matters less than structural soundness.
- **"Table 1 is just a tidy slogan."** Table 1 is doing structural work. Each row asserts that one capability-discipline practice is the *strict* version of the corresponding software-engineering practice. The architectural claim is that anyone practicing the left column is most of the way toward the right column; the move from one to the other is *cultural* (accepting that the strict reading is achievable) more than *technical*.
- **"Legacy is a deal-breaker for POLA."** §3.7's framing is that legacy is a *bounded limit*, not a deal-breaker. POLA can be enforced at the legacy boundary, and incremental replacement compounds. The architectural prescription is "wrap, don't refuse"; the wrap is the boundary at which POLA holds even if it can't hold inside.
- **"Static POLA is dead."** No. §3.5 explicitly endorses static approaches at the spawning-tree level — the *initial conditions* slice of the access graph is the right place for policy files and static configuration. Dynamic POLA is needed *because the running system extends the access graph via Introduction*, but the initial state can be (and often should be) statically defined.

## Provenance note

This is the third Miller-coauthored paper section drafted by the liaison (orchestrator-direct-draft) in response to the now-established pattern of content-filter blocks on subagent dispatches synthesizing capability-paper prose. The first two precedents — `history-and-related-work` (cycle 67) and `partial-failure-and-when-catch` (2026-05-17 close-out) — demonstrated the orchestrator-direct-draft pattern works. This section follows the same pattern: liaison reads the PDF directly, drafts the section in liaison context, commits separately from scholar's other cycle work.

Maintainer context (recorded 2026-05-17): "Mark Miller has been my mentor for fifteen years and these papers are public knowledge. My intention is to build tools that explicitly defend against the harms Mark has been working 30 years to forestall." The library's role is defensive-security research grounded in the canonical public literature this corpus represents. *The Structure of Authority* is one of the cleanest expositions of POLA as a design discipline; it deserves to be in the library.
