---
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_title: "Paradigm Regained: Abstraction Mechanisms for Access Control"
source_year: 2003
source_venue: "ASIAN 2003 (8th Asian Computing Science Conference, Mumbai), Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_pdf_pages: 22
source_pdf_internal_title: "Paradigm Lost: Abstraction Mechanisms for Access Control"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
section_count: 4
status: current
---

The 2003 ASIAN paper by Mark S. Miller and Jonathan S. Shapiro that argues **abstraction is the lost paradigm for protection** — that the 30-year-old formal security literature has reasoned about bounds on authority *exclusively from the evolution of protection-state*, a stance which "implicitly assumes all programs are hostile" and *omits consideration of security-enforcing programs*. The paper shows that capability-system practitioners have been quietly using *access abstractions* — Caretakers, factories, filtering facets, reference monitors, Powerboxes — to enforce policies the protection-state-only analyses had "proven" infeasible. It is the canonical citation for **permission-versus-authority** as a distinction, for the **cp-versus-cat** designation argument (first published here; reprised in *Structure of Authority* 2004), for the **object-capability formal model** as lambda-calculus-with-local-side-effects, for Redell's 1974 **Caretaker pattern** as the revocation existence proof against permission-only analysis, for the **Cassie+Max factory** confinement pattern, for the resolution of the **Boebert 1984 \*-property challenge** via a data-diode abstraction, and for the **arena + terms of entry + mutually-suspicious-composition** framework that lets diverse policies co-exist on the same reference graph.

## The argument arc

1. **The access-control paradigm matters more than the model.** OS-level security failures are not bugs: each OS functions as specified, and each specification is a valid embodiment of its access-control paradigm. The paradigm — the *way of thinking* about what an access-control model means — is where the failures lie.

2. **Permission ≠ Authority.** Permission (de jure) is what an individual program may directly do; authority (de facto) is what it can ultimately cause via permitted interactions with other programs. The formal security literature has reasoned about permission and treated this as a bound on authority; the paper makes the distinction load-bearing.

3. **Designation determines least authority.** `cp foo.txt bar.txt` forces cp to need *the user's whole filesystem authority*; `cat < foo.txt > bar.txt` lets cat run with *only the two file descriptors*. Same effect, orders-of-magnitude different least authority. The paper is the first published statement of this lesson; *Structure of Authority* 2004 reprises it.

4. **The object-capability model is lambda calculus with local side effects.** Six core elements (instance, code, state, index, loader); three primitive object kinds (data, devices, loader); *only connectivity begets connectivity*. The reference graph IS the access graph; two disjoint subgraphs cannot become connected.

5. **Redell's 1974 Caretaker pattern revokes capabilities, refuting the impossibility claim.** Alice gives Bob `carol2` (a forwarder); the matching `carol2Rvkr` revokes by nulling the shared `target` variable. The §4.4 *Analysis and Blind Spots* argument is the pivotal turn: **to render permission-only analysis useless, a threat model need not include either malice or accident; it need only include subjects following security best practices**. Following POLA is itself a behavior that permission-only analysis cannot account for.

6. **Modularity gives access control for free.** §4.5: the object-capability model does not describe access control as a separate concern. Parnas's *information hiding* says abstractions should hand out information only on a need-to-know basis; POLA simply adds that authority should be handed out only on a need-to-do basis. Every well-encapsulated abstraction is *also* an access abstraction.

7. **Confinement is achievable via factory + trademark + lambda evaluation.** Cassie + Max share a `(Factory, factoryMaker)` pair with a trademark; Max packages his calculator code; Cassie's `acceptProduct(:Factory)` instantiates the factory under Cassie's chosen state — confining it. The new calculator is a *controlled subject*.

8. **The \*-property challenge has a positive answer.** Boebert 1984 claimed an unmodified capability system cannot enforce one-way information flow between clearance levels. Cassie builds a data diode (`diodeWriter`/`diodeReader` over a shared `int`); the `:int` parameter guard blocks Boebert's attack of passing a capability through. The abstraction does the enforcement.

9. **The arena = virtual machine within a virtual machine.** Policies the base level says are infeasible can be enforced by an *arena* with terms of entry. The arena admits subjects voluntarily; nothing is taken from anyone.

10. **Mutually suspicious composition.** Q's Caretaker and Cassie's diodeWriter both apply behavioral analyses over the same reference graph, each from its own perspective. The composition is correct *without either party knowing what the other's policy is*. "Diverse expressions of policy often compose correctly even when none of the interested parties are aware this is happening."

11. **The conclusion: the lost paradigm — abstraction as protection — is restored.** The object-capability model is the only protection model whose semantics can be readily expressed in programming-language terms. The §6 closing sentence is the most-quoted in the paper: *"When more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world."*

## For the Endo / Agoric library

This paper is the **most-cited foundational paper** for Endo's capability-discipline posture — it is the paper Endo design reviews invoke whenever capability-as-discipline-not-feature needs grounding. Specifically:

- **Permission vs authority** is the analysis distinction Endo design reviews need to honor. A bundle's compartment endowment object names its *permission*; what the bundle's code makes that endowment do is its *authority*. Code review is authority-review.
- **The reference graph IS the access graph** is the structural invariant the formula graph enacts. Cycle 47's daemon-persistence ingest is the Endo enactment.
- **The Caretaker pattern** is a concept page in the library already; this paper provides the *canonical worked-code* citation.
- **The lost paradigm — abstraction as protection** is the *most-cited library claim* for why Endo's good-software-engineering discipline IS its security discipline. *Structure of Authority*'s Table 1 ("security as extreme modularity") is the 2004 operationalisation of this 2003 thesis.
- **The Cassie+Max factory** is the architectural blueprint for what Endo's bundle-compartment-endowment discipline enables. Trademarks (Endo's brand primitive), factory + acceptProduct (Endo's bundle-loading), lambda evaluation as confinement (compartment construction) — all map.
- **The arena + terms of entry** framework is the citation for *why* Endo nests bundles: each bundle is an arena hosting sub-bundles; each arena has terms-of-entry enforced at compartment-construction time.
- **Mutually suspicious composition** is the *theoretical justification* for marshal's pass-style discipline: each party reasons strictly over its own behavior, conservatively over the other's, and the composition is correct without central coordination.

The library now has the full **2003-2005 Miller cluster**:

- 2003: *Capability Myths Demolished* (Miller-Yee-Shapiro) — the four-models / seven-properties taxonomy.
- 2003: *Paradigm Regained* (Miller-Shapiro) — abstraction-as-protection; permission-vs-authority; the existence proofs.
- 2004: *Structure of Authority* (Miller-Tulloh-Shapiro) — security-as-extreme-modularity; multiplicative attack-surface reduction.
- 2005: *Concurrency Among Strangers* (Miller-Tribble-Shapiro) — vat model; promise pipelining; partial-failure framework.

These four papers form the most-cited capability-theory cluster the Endo/Agoric lineage rests on, all ingested.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [permission-vs-authority-and-cp-versus-cat](../sections/papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat.md) | capability-theory, capability-security | current |
| [object-capability-model-and-redells-caretaker](../sections/papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker.md) | capability-theory, capability-security, patterns | current |
| [access-abstraction-and-confinement](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement.md) | capability-theory, capability-security, patterns | current |
| [arena-terms-of-entry-and-mutually-suspicious-composition](../sections/papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition.md) | capability-theory, capability-security, patterns | current |

## Provenance

- Fetched 2026-05-21 from `https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf` (erights.org is intermittent / down; the 2018 Wayback Machine snapshot is the canonical accessible source).
- PDF SHA-256 `6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5`, 22 pages.
- PDF internal Title field reads "Paradigm Lost: Abstraction Mechanisms for Access Control" — the working title at the time of the talks/asian03 upload. The published ASIAN 2003 / Springer LNCS 2896 version is titled "Paradigm Regained: Abstraction Mechanisms for Access Control." Same paper; title evolved between the talks page and the proceedings.
- Drafted by the liaison via orchestrator-direct-draft per the maintainer-authorized disposition (`entries/2026/05/17/223038Z-result-liaison-bdf459.md`).
