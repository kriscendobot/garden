---
id: principle-of-least-authority
aliases: ["POLA", "principle of least authority", "least authority", "least-authority discipline", "principle of least privilege", "Saltzer-Schroeder least privilege", "need to do", "need-to-do basis"]
topics: [capability-theory, capability-security, patterns]
---

# principle-of-least-authority

The discipline that **every subject should hold the minimum authority required to fulfill its responsibilities** — neither more nor less. POLA is *not* about denying capabilities; it is about *granting* exactly the capabilities a task needs, at the moment the task requires them, no longer than the task lives. The four-paper Miller cluster (2003-2005) articulates POLA from four converging angles: Capability Myths Demolished as one of two practical advantages of object-capability systems (the other being confused-deputy avoidance); Paradigm Regained as the strict reading of information-hiding (POLA *is* information-hiding for authority instead of for knowledge); Structure of Authority as the discipline that makes nested attack-surface reduction load-bearing; Concurrency Among Strangers as the access-control companion to defensive correctness in mutually-suspicious concurrent systems. POLA is best understood through the *permission-vs-authority distinction* that Paradigm Regained §2 establishes: **least *permission*** asks what direct rights an arrangement gives a subject; **least *authority*** asks what effects a subject can *ultimately cause* by composing its permissions with the behavior of other subjects. The two readings differ by orders of magnitude. POLA is the *least-authority* reading; Saltzer-Schroeder's 1975 "principle of least privilege" left the question ambiguous, and the Endo / Agoric library convention is to read it as least *authority*.

## The strict reading

The architectural payoff is that **POLA is the strict reading of information hiding**. Parnas's 1972 *information hiding* says abstractions should hand out information only on a *need to know* basis. POLA adds that authority should be handed out only on a *need to do* basis. Modularity and security each require both. Structure of Authority's Table 1 enumerates ten software-engineering practices and shows each capability-discipline practice as the strict reading of its modularity counterpart:

- Information hiding → POLA
- Designation, need to know → Permission, need to do
- Avoid global variables → Forbid mutable static state
- Lexical naming → No global name spaces

A programmer already following good software-engineering discipline is most of the way toward capability discipline. The gap is *cultural* (accepting the strict reading is achievable) more than *technical*.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat](../sections/papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat.md) | The canonical permission-vs-authority distinction; the cp-vs-cat designation argument (first published form); §2 closing observation: "Permission is relative to a frame of reference. Authority is invariant." Saltzer-Schroeder's least-privilege ambiguity is named here. |
| [papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement.md) | §4.5 framing: "POLA simply adds that authority should be handed out only on a need-to-do basis." The lost-paradigm thesis — abstraction is the protection mechanism. |
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation.md) | The gateway-to-abuse framing; cp-vs-cat as the canonical designation argument (2004 reprise); information-hiding (need-to-know) and POLA (need-to-do) as two readings of the same modular discipline. |
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity.md) | Nested POLA multiplicatively reduces attack surface across recursive layers (organization → application → module → object). Table 1: "security as extreme modularity" — ten software-engineering practices mapped to their strict capability-discipline readings. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola.md) | §7.2 worked POLA example: the `statusGetter`/`statusSetter` facet split. POLA as the access-control discipline that lets multiple plans cooperate without interference. Defensive correctness + defensive consistency as the formal targets POLA serves. |
| [papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy](../sections/papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy.md) | Two practical advantages of object-capability systems: least-privilege operation (requires Property B + Property G) and confused-deputy avoidance (requires Property A + Property D). The original "true capability model is the object-capability model" terminology argument. |
| [papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker](../sections/papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker.md) | §4.4: "To render permission-only analysis useless, a threat model need not include either malice or accident; it need only include subjects following security best practices." Following POLA *is itself* a behavior that permission-only analysis cannot account for. |

## See also

- [[object-capability]] — the existing concept page. POLA is the *discipline*; object-capability is the *substrate* that lets the discipline be enforceable. POLA on an ACL substrate is achievable only as a convention; POLA on an object-capability substrate is enforceable by the model.
- [[caretaker-pattern]] — the canonical worked example of POLA at the object-method granularity: split one capability into action and control facets, grant only the action facet to the consumer.
- [[four-ways-to-acquire-references]] — the structural answer to *how* a subject can gain new authority while remaining under POLA. The four mechanisms (Introduction, Parenthood, Endowment, Initial Conditions) are POLA-compatible by construction.
- [[security-as-extreme-modularity]] — Structure of Authority's Table 1, which positions POLA as the *strict reading of information hiding*. POLA reads as a security discipline; the table reads as both that and the same thing as good engineering discipline taken to its strict form.
- [[revocation-by-withdrawal]] — POLA at the *temporal* dimension. POLA at-grant-time is necessary but not sufficient; revocation completes POLA over the lifecycle of an authority grant.

## Common confusions

- **"POLA is just least privilege."** Saltzer-Schroeder's "principle of least privilege" (1975) is ambiguous between least *permission* and least *authority*. Paradigm Regained §2 makes the ambiguity explicit and chooses least authority as the architecturally useful reading; Endo / Agoric library convention follows that choice. POLA-as-least-authority is the strict form; POLA-as-least-permission is a weaker reading that misses the behavioral-abstraction dimension entirely.
- **"POLA means denying capabilities."** No. POLA is about *granting* capabilities precisely matched to need. The applet stance (no authority, no functionality) is *not* POLA; it is the trivial corner case POLA aims to avoid. Cooperative-and-safe is the POLA goal; isolated-and-useless is the failure mode.
- **"POLA is about minimum permission, period."** The cp-vs-cat lesson shows two systems with the same *effect* and orders-of-magnitude-different *least authority*. POLA is the discipline of choosing the *cat-style* designation pattern over the *cp-style* one — so the system enforces less authority for the same functionality.
- **"POLA is achievable only with kernel changes."** Paradigm Regained's §4.5 + Structure of Authority's Table 1 + Concurrency Among Strangers' §7.2 all show POLA achievable in pure object-capability systems with no separate access-control mechanisms. The discipline is achievable at the language level (Hardened JavaScript via SES + Endo) without OS-level support.
- **"Permission-only analysis can verify POLA compliance."** Paradigm Regained §4.4: permission-only analysis is rendered useless by best practices — *following POLA is itself a behavior that permission-only analysis cannot account for*. POLA verification must include behavioral reasoning about the access-mediating abstractions (Caretakers, factories, filtering facets).
- **"POLA is a sufficient condition for security."** POLA is the access-control discipline; defensive correctness and defensive consistency (Concurrency Among Strangers §6-7) are concurrency-control disciplines; the *-properties (Paradigm Regained §5.2) are information-flow disciplines. Each addresses a different attack surface. A system that practices POLA *and* defensive correctness *and* arena terms-of-entry is much more secure than one that practices only one.
