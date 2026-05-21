---
title: The Arena, Terms of Entry, Mutually Suspicious Composition, and the Lost-Paradigm Conclusion (virtual machine within a virtual machine; protection by abstraction)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "19-22 (§5.3 The Arena and Terms of Entry, §5.4 Mutually Suspicious Composition, §6 Conclusion)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
---

## Abstract

§5.3 introduces the **arena** abstraction. Policies like the *-properties are generally assumed to be enforced *on a system as a whole* by a sys-admin or security officer; in a capability system, this is a matter of *initial conditions*. But once the system is running, an owner who later wants to impose policy faces a problem: Alice meeting Bob, an uncontrolled subject, cannot enforce a policy that *removes* prior rights from Bob — that would violate Bob's security. Instead, Alice sets up an **arena** — Lampson's "controlled environment" — with initial conditions she determines, governed by her rules, over which she is the sys-admin. If her rules can be enforced on uncontrolled subjects, she can admit Bob onto her arena as a player. The discipline is **terms of entry**: "Please leave your cellphones at the door." A prospective participant provides a player (here, `calcFactory`) representing his interests within the arena, where the player can pass the security check at the gate. No rights are taken from anyone; participation is voluntary. The arena technique corresponds to **meta-linguistic abstraction** — an arena is a virtual machine built within a virtual machine [Abelson86, Safra86]. §5.4 — **Mutually suspicious composition** — answers the next natural question: when diverse interests build diverse abstractions to express diverse co-existing policies, how do these extensions interact? Q builds a gizmo + a Caretaker so he can revoke gizmo's access to *his* `diodeWriter`. Q's policy relies on Q's Caretaker. Cassie's policy relies on her `diodeWriter`. *Neither needs to know about the other.* The §5.4 closing observation: "diverse expressions of policy often compose correctly even when none of the interested parties are aware this is happening." §6 closes the paper: **the lost paradigm — abstraction as protection — is restored**. The object-capability model is the only protection model whose semantics can be readily expressed in programming-language terms (approximately, *lambda calculus with local side effects*), providing a common semantic framework for reasoning about permission and program behavior together. The paper's last sentence: *"The object-capability paradigm, with its pervasive, fine-grained, and extensible support for the principle of least authority, enables mutually suspicious interests to cooperate more intimately while being less vulnerable to each other. When more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world."*

## Body

### §5.3 The arena — initial conditions and terms of entry

The §5.3 opening returns to the problem the prior sections set up: policies like the *-properties are *generally assumed to govern a computer system as a whole, to be enforced in collaboration with a human sys-admin or security officer*. In a capability system, **this is a matter of initial conditions**. If the owner wants such a policy to govern the entire system, she can run such code when the system is first generated and when new users join.

But what happens *after the big bang*? Alice meets Bob, who is an *uncontrolled subject* to her. Alice can still enforce **additive** policies on Bob — she can give him revocable access to Carol and then revoke it. But she cannot enforce a policy on Bob that requires *removing prior rights* from Bob, because that would violate Bob's security.

The §5.3 reframe: instead of trying to impose policy on Bob's pre-existing world, Alice acts as **Lampson's "customer"** — she sets up an *arena* — Lampson's "controlled environment" — with initial conditions she determines, governed by her rules, over which she is the sys-admin. If her rules can be enforced on uncontrolled subjects, she can admit Bob onto her arena as a player. The discipline is **terms of entry**:

> "Please leave your cellphones at the door."

A prospective participant (Max in the §5 confinement example) provides a player (`calcFactory`) to represent his interests within the arena, where this player can pass the security check at the gate (here, `:Factory`). **No rights were taken away from anyone; participation was voluntary.**

The §5.3 structural payoff: the arena technique corresponds to **meta-linguistic abstraction** [Abelson86, Safra86] — *an arena is a virtual machine built within a virtual machine*. The resulting system can be described according to *either level of abstraction*: by the rules of the base level object-capability system, OR by the rules of the arena. The subjects built by the admitted factories are also subjects within the arena. **At the base level**, we would say Q has permission to send messages to `diodeWriter` and authority to send integers to Bond. **At the arena level of description**, we would say a data diode is a *primitive part of the arena's protection state*, and say Q has *permission* to send integers to Bond. Any base-level uncontrolled subjects admitted into the arena are **devices of the arena** — they have *mysterious connections to the arena's external world*.

The §5.3 closing argues this re-description is *not absolute possibility analysis but engineering quality analysis*. When the only inputs to a problem are data (here, code), any system capable of universal computation can solve any solvable problem; questions of absolute possibility become useless for comparisons. Language designers have learned to ask instead an engineering question: ***Is this a good machine on which to build other machines?***

The Cassie+Max arena: "How well did we do on Boebert's challenge? The code admitted was neither inspected nor transformed. Each arena level subject was also a base level subject. The behavior interposed by Cassie between the subjects was very thin. *Mostly, we reused the security properties of the base level object-capability system to build the security properties of our new arena level machine.*"

### §5.4 Mutually suspicious composition — diverse policies over the same graph

§5.4 names the next architectural question: "When mutually suspicious interests build a diversity of abstractions to express a diversity of co-existing policies, how do these extensions interact?"

The worked example, with the cast extended from §5.2-§5.3:

- Q builds a *gizmo* that might have bugs.
- Q creates a *Caretaker* (the §4.3 pattern) to give the gizmo revocable access to **Q's `diodeWriter`** (the one Cassie endowed Q with).
- Q's policy relies on the behavior of *Q's Caretaker* — but **not necessarily on the behavior of Cassie's `diodeWriter`**.
- To Cassie, Q's gizmo and Caretaker are part of Q's subgraph and indistinguishable from Q.
- Cassie's policy relies on the behavior of *her `diodeWriter`*, but **not on Q's Caretaker**.

The §5.4 architectural observation: **each does a partially behavioral analysis over the same graph, each from their own subjective perspective**. This scenario shows how **diverse expressions of policy often compose correctly even when none of the interested parties are aware this is happening**.

The composition discipline:

1. Cassie's analysis: *if Cassie's `diodeWriter` behaves as Cassie expects, then the *-property she relies on holds, regardless of what Q does with his diodeWriter reference downstream.*
2. Q's analysis: *if Q's Caretaker behaves as Q expects, then Q can revoke the gizmo's access to Q's diodeWriter reference whenever Q chooses, regardless of what Cassie has done elsewhere.*

Each analysis is **strict over its own behavioral assumptions** and **conservative over the other party's behavior** (treating it as arrangement-only). The two analyses *compose* because they operate over a single reference graph but make different behavioral commitments. The system as a whole satisfies *both* policies without either party knowing what the other's policy is.

### §6 Conclusion — the lost paradigm restored

The §6 opening is the structural payoff:

> Just as we should not expect a base programming language to provide us all the data types we need for computation, we should not expect a base access control system to provide us all the elements we need to express our protection policies. Both issues deserve the same kind of answer: We use the base to build abstractions, extending the vocabulary we use to express our solutions. In evaluating a protection model, one must examine how well it supports the extension of its own expressiveness by abstraction and composition.

The historical claim: "Security in computational systems emerges from the interaction between primitive protection mechanisms and the behavior of security-enforcing programs. As we have shown here, such programs are able to enforce restrictions on more general, untrusted programs by building on and abstracting more primitive protection mechanisms. **To our knowledge, the object-capability model is the only protection model whose semantics can be readily expressed in programming language terms** — approximately, *lambda calculus with local side effects*. This provides the necessary common semantic framework for reasoning about permission and program behavior together."

The §6 architectural claim about analyses:

> Analyses based on the evolution of protection state are conservative approximations. A successful verification demonstrating the enforcement of a policy using only the protection graph (as in [Shapiro00]) is *robust*, in the sense that it does *not* rely on the cooperative behavior of programs. Verification *failures* are *not* robust — they may indicate a failure in the protection model, but **they can also result from what might be called "failures of conservatism"** — failures in which the policy is enforceable but the verification model has been simplified in a way that prevents successful verification.

This is the formal explanation of §4.4's pivotal claim ("permission-only analysis is rendered useless by best practices") at the language-theoretic level: a verification model that examines only the protection state is *systematically biased toward false-failure*. Permission-only analyses incorrectly conclude *unsafe* when behavioral abstractions like the Caretaker would have enforced the property. *That* is the cost of choosing the wrong paradigm.

The §6 closing:

> By recognizing that program behavior can contribute towards access control, **a lost paradigm for protection — abstraction — is restored to us**, and a semantic basis for extensible protection is established. Diverse interests can each build abstractions to express their policies regarding new object types, new applications, new requirements, and each other, and these policies can co-exist and interact. This extensibility is well outside the scope of traditional access graph analyses.

The very last paragraph contains the paper's most-quoted sentence:

> The object-capability paradigm, with its pervasive, fine-grained, and extensible support for the principle of least authority, enables mutually suspicious interests to cooperate more intimately while being less vulnerable to each other. **When more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world.**

This is the paper's normative claim — not just a technical proposition but a *political* one about what kind of world capability discipline enables.

## Translation block (paper idiom → Endo / Hardened JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Arena (virtual machine within a virtual machine) | An Endo bundle nesting a compartment, possibly with its own sub-bundles. The Endo daemon itself is an arena for bundles; each bundle is an arena for its sub-exos. |
| Terms of entry                             | The compartment construction options + endowment object. The bundle's `Compartment(...)` invocation IS the terms-of-entry checkpoint. |
| Initial conditions                         | The bootstrap petname graph; the daemon's startup endowments. Cycle 47's daemon-persistence ingest names this. |
| Meta-linguistic abstraction                | An Endo bundle hosting a guest module via @endo/static-module-record + @endo/compartment-mapper. The guest sees one language; the host sees the substrate. |
| Mutually suspicious composition            | Two bundles, each holding capabilities they trust, message each other without either trusting the other's *implementation*. The marshal pass-style boundary is exactly this. |
| "Diverse policies over the same graph"     | Two distinct review disciplines (e.g. cleaner's coverage discipline, judge's panel) both applying to the same PR graph, each strict-over-its-own-concerns, conservative-over-everything-else. |
| "Mostly we reused the security properties of the base..." | The architectural justification for *not* adding new primitives to SES every time a new policy is wanted. Build the policy as an exo using existing primitives. |
| "Failures of conservatism" in verification | The failure mode of automated audits over Endo bundles: a static review that flags every endowment as "potentially dangerous" gives no information; the useful audit is *behavioral*. |

## Implications for Endo

The §5.3-§5.4 + §6 cluster is the *most ambitious* part of the paper for Endo, because it justifies several non-obvious architectural choices:

1. **Why Endo nests bundles rather than flatten authority.** Each bundle is an *arena* in §5.3's sense. The daemon hosts an arena; each bundle in that arena can host a sub-arena. The §3.5 *nested TCBs follow the spawning tree* result in *Structure of Authority* is the operational consequence of this section's *arena = virtual-machine-within-virtual-machine* framing.
2. **Why marshal pass-style boundaries are load-bearing.** §5.4's "mutually suspicious composition" depends on each party being able to reason about its own behavior without trusting the other's implementation. Marshal's pass-style discipline (pass-by-copy for data, pass-by-presence for capabilities) IS the operational substrate for this. The §5.4 framing makes explicit *why* this matters: without marshal's discipline, "diverse policies over the same graph" would require each party to inspect the other's code, which destroys the composition property.
3. **Why review disciplines in the garden compose rather than conflict.** The garden's gamut (cleaner → judge → fixer → ferry) has multiple review roles that *each apply strict-over-their-own-concern, conservative-over-everything-else*. The §5.4 framing is the *theoretical justification* for why this works: each role's review is a behavioral analysis over the same PR graph, from its own subjective perspective. The composition correctness emerges *without* each role needing to know what the others are checking.
4. **Why "failures of conservatism" matter for Endo automated review.** §6's diagnosis — verification failures are not robust because they may be failures of conservatism rather than failures of the protection model — is the citation for why Endo audits should be careful with arrangement-only checks. A reviewer (human or AI) that flags every cross-bundle reference as suspect is doing arrangement-only analysis. Useful reviews are *behavioral* — they reason about what the specific abstraction in question enforces.
5. **The normative claim is real.** §6's closing sentence — "when more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world" — is what the Endo / Agoric project is *for*. Library design reviews can cite this as the *why*, not just the *what*.

## See also

- [[principle-of-least-authority]] — deferred concept page. §6's closing is the *most-quoted* one-line POLA statement in the literature. Once the concept page is written, this section's closing sentence belongs as the page's epigraph.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity` — *Structure of Authority*'s nested-POLA-multiplies-attack-surface argument is the operational form of §5.3's *arena = virtual-machine-within-virtual-machine* framing. The 2004 paper *operationalizes* the 2003 paper's abstract arena claim.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — the 2005 paper's *vat is the minimum unit of persistence, migration, partial failure, resource control, defense* is the *concurrency-side* arena concept. This paper's *spatial-side* arena is its counterpart.
- `papers--maloyan-namiot-sleeper-channels-2026--provenance-gate-d2-and-soundness-theorem` — the 2026 Sleeper Channels paper's *closed action set C and mediation hooks H1-H10* is a 21-years-later operationalisation of §5.3's terms-of-entry / arena gate. The arxiv paper's *D2 gate* is structurally an arena's *terms-of-entry checkpoint*.
- [[caretaker-pattern]] — the existing concept page; the §5.4 mutually-suspicious example uses *Q's Caretaker* explicitly.

## Common confusions

- **"The arena is a sandbox."** Sandboxes are typically *all-or-nothing*: code is either inside the sandbox (subject to its rules) or outside. The §5.3 arena allows uncontrolled subjects in as *devices* with "mysterious connections to the arena's external world" — explicitly modeling the gap rather than refusing to admit external code at all. Endo's bundle-loading allows non-SES code in as a guest module with a curated endowment; the device framing is the right model.
- **"Mutually suspicious composition requires central coordination."** §5.4 explicitly argues the opposite: Cassie does not know about Q's Caretaker; Q does not know about Cassie's other arrangements. Each party's analysis is strict-over-its-own-behavior, conservative-over-everything-else. The composition is correct *without* central coordination.
- **"The lost paradigm is just `protection = encapsulation`."** §6 makes a more specific claim: *protection by abstraction* is a lost paradigm because the formal security literature for 30 years (1973-2003) reasoned about protection state in isolation from program behavior. The lost paradigm is the recognition that *program behavior contributes to protection* — that an abstraction's *enforcement* is part of the protection model.
- **"Failures of conservatism are bugs in the verifier."** They are bugs in the *verification model*, not in the verifier implementation. A verification model that ignores behavior cannot conclude that a Caretaker enforces revocation; the model is *systematically biased toward unsafe*. The fix is enriching the model, not patching the verifier.
- **"The arena and terms of entry are just a metaphor."** They are a metaphor *and* an architecture. Each Endo bundle's compartment-construction step IS the terms-of-entry checkpoint. The metaphor is operationally concrete.
