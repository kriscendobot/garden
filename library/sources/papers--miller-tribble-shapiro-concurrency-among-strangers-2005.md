---
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_title: "Concurrency Among Strangers: Programming in E as Plan Coordination"
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705, pages 195-229"
source_url: https://link.springer.com/chapter/10.1007/11580850_12
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
source_pdf_pages: 35
source_mirror_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
ingested: 2026-05-15
ingested_by: scholar
section_count: 7
status: current
---

The canonical 2005 paper by Mark S. Miller, E. Dean Tribble, and Jonathan Shapiro that introduces the **communicating event-loop (vat) model**, **promise pipelining**, **broken-reference contagion**, **offline capabilities (`captp://...` / sturdyref)**, and the **when-catch** expression as a coherent concurrency-control architecture, framed as *plan coordination* among mutually-suspicious strangers. Originally presented at TGC 2005 (Springer LNCS 3705); this is the paper modern Endo / Agoric / OCapN designs cite when they need to ground an eventual-send claim, a turn-isolation claim, or a partial-failure claim in upstream literature.

The argument arc is **single example, many lenses**. The paper uses one running example — a `statusHolder` implementing the listener pattern — and walks it through six successive coordination challenges: sequential plan interference, shared-state concurrency hazards, single-thread event-loop concurrency, network distribution, malicious-client defense, and partial failure. Each lens motivates one piece of the E model:

- The **sequential statusHolder** in Java exhibits *plan interference* (abort-the-wrong-plan, nested-subscription, nested-publication) even with no concurrency at all.
- The **shared-state statusHolder** with `synchronized` introduces *deadlock* and *race conditions*; "Multi-Threaded Hell" is unavoidable in the conventional paradigm.
- The **E statusHolder** with `<-` (eventual-send) eliminates the sequential hazards *and* the concurrent ones by deferring listener notification to a later turn.
- A vat is "a heap of objects + a thread of control + a pending-delivery queue", and is "the minimum unit of persistence, migration, partial failure, resource control, and defense from denial of service".
- **Near / eventual / broken** reference states form a Harel-statechart partition. Near references carry both immediate-calls and eventual-sends; eventual references carry only eventual-sends; broken references carry neither.
- **Promise pipelining** lets `x <- a() <- c(y <- b())` stream three messages in one network trip; *broken-promise contagion* propagates exceptions through dependency chains without terminating control flow (inspired by signaling-vs-non-signaling NaNs in floating point).
- **Defensive correctness** and **defensive consistency** are the formal targets; *POLA* (Principle of Least Authority) is the access-control discipline that lets multiple plans cooperate without interference.
- **Offline capabilities** (the `captp://...` URI form and the encapsulated `SturdyRef` object) carry a vat's public-key fingerprint + TCP/IP location hints + a *swiss number* — letting connectivity be re-established after partition.
- The **when-catch** expression "turns data-flow back into control-flow": `when (promise) -> { /* resolved case */ } catch ex { /* broken case */ }`. Used together with `asyncAnd` to combine independent validity checks in a toy reselling example.

The paper closes with a history (Smalltalk → Actors → Vulcan → Joule → Original-E → E) and a related-work tour (group membership / Paxos, Croquet/TeaTime, Web-Calculus, Oz-E, Twisted Python).

For the Endo / Agoric library, this paper is the **upstream citation** for:

- `[[eventual-send]]` (the `<-` operator and its Endo `E()` equivalent).
- `[[vat-and-compartment]]` (new concept this cycle; vat → Endo's compartment + bundle isolation unit).
- `[[promise-pipelining]]` (new concept this cycle; the streaming optimization at the core of `E()`-chains' latency profile).
- `[[caretaker-pattern]]` (the statusGetter/statusSetter split in §7.2 is a worked POLA example using exactly the F+R facet split this paper's companion *Capability Myths Demolished* (2003) formalizes).
- `[[delegates-and-epithets]]` (the per-vat keypair model in §9.2 is the cryptographic substrate Endo's per-agent-keypair design later extends).
- `[[four-tables-coordinated-retention]]` (the *unguessable swiss-number* mechanism in §9.2 is the upstream pattern Endo's formula-id unguessability inherits).

Several Endo concepts have *no direct upstream* in this paper (formula-graph, retention-accumulator, cohort-destruction) — they are Endo's later additions to the vat model — but the paper's vat / near-reference / persistence-by-traversal framing is the foundation those additions extend.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [abstract-and-introduction](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--abstract-and-introduction.md) | capability-theory, eventual-send | current |
| [why-not-shared-state-concurrency](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--why-not-shared-state-concurrency.md) | capability-theory, eventual-send | current |
| [vat-and-event-loop-model](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) | capability-theory, eventual-send, compartments | current |
| [defensive-correctness-and-pola](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola.md) | capability-theory, capability-security, patterns | current |
| [promise-pipelining](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining.md) | capability-theory, eventual-send | current (cycle 67) |
| [history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) | capability-theory | current (cycle 67) |
| [partial-failure-and-when-catch](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch.md) | capability-theory, eventual-send, persistence | current (2026-05-17, orchestrator-direct-draft after 3rd subagent filter event on capability-paper synthesis) |

The paper is now fully ingested. Section 6 was drafted by the liaison directly from the PDF on 2026-05-17 after a third consecutive filter block (cycle 70's attempt on a different Miller paper) confirmed the pattern: subagent prose-synthesis of active-adversary capability-theory framing trips the content filter; the orchestrator path doesn't. Maintainer-authorized this disposition for filter-sensitive Miller papers going forward.

## Acknowledged contributors

The acknowledgements thank "Darius Bacon, Dan Bornstein, John Corbett, Bill Frantz, Ian Grigg, Jim Hopwood, Piotr Kaminski, Alan Karp, Matej Kosik, Jon Leonard, Kevin Reid, Michael Sperber, Fred Spiessens, Terry Stanley, Marc Stiegler, Bill Tulloh, Bryce 'Zooko' Wilcox-O'Hearn, Steve Witham, and the e-lang and cap-talk communities. We thank Terry Stanley for suggesting the listener pattern and purchase-order examples. We are especially grateful to Ka-Ping Yee and David Hopwood for a wide variety of assistance." Ka-Ping Yee also drew Figures 2-5.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) at SHA-256 `4ff0c5bd07e1`.
