---
title: The Object-Capability Model and Redell's 1974 Caretaker Pattern (formal model; pointMaker; revocation as behavioral abstraction; the permission-only blind spot)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "7-14 (§4 The Object-Capability Paradigm, including §4.1 Model, §4.2 A Taste of E, §4.3 Redell's Caretaker, §4.4 Analysis and Blind Spots)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
---

## Abstract

§4 presents the **object-capability model** in its formal lambda-calculus-with-local-side-effects form. The model has six core elements (instance, code, state, index, loader) and three kinds of primitive objects (data, devices, loader). A *reference* indivisibly combines the designation of an object, the permission to access it, and the means to access it. The crucial structural rule is **only connectivity begets connectivity** — two disjoint subgraphs cannot become connected because no one can introduce them; connectivity is bequeathed transitively via message-passing or constructor endowment. §4.2 illustrates with a `pointMaker` E-language example showing how nested object definitions can be transformed into explicit `loader.load(code, ["x" => x, "y" => y])` calls — the linking happens only by virtue of these associations, *only connectivity begets connectivity*. §4.3 walks Redell's 1974 **Caretaker pattern** as the canonical existence proof against the impossibility claim "capabilities cannot revoke": Alice constructs a `caretakerMaker` that builds a `[caretaker, revoker]` pair sharing an assignable `target` variable; Alice gives Bob the caretaker (a forwarding object) and retains the revoker (which sets `target := null`). Bob holds the same designation throughout; what changes is the *behavior* the caretaker dispatches to. §4.4 — *Analysis and Blind Spots* — names the deep failure of permission-only analysis: by Chander-Dean-Mitchell's permission-only analysis [Chander01], Bob *was never given permission to access Carol*, so there was no access to Carol to be revoked; Bob was given permission to access `carol2` (the caretaker), and he still has it. Permission analysis renders the Caretaker pattern *invisible*. The paper's pivotal counter-claim: *to render permission-only analysis useless, a threat model need not include either malice or accident; it need only include subjects following security best practices*. Following POLA *is itself* a behavior that permission-only analysis cannot account for.

## Body

### §4 The object-capability paradigm — references, computation, only-connectivity-begets-connectivity

The opening: in the object model of computation [Goldberg76, Hewitt73], there is no distinction between subjects and objects. A non-primitive object (an *instance*) is a combination of code and state, where state is a mutable collection of *references* to objects. The *computational system* is the dynamic reference graph of objects.

The **object-capability model uses the reference graph *as* the access graph**, requiring that objects can interact *only* by sending messages on references. To get from objects to object-capabilities, the paper says, "we need merely prohibit certain primitive abilities which are not part of the object model anyway, but which the object model by itself doesn't require us to prohibit — such as forged pointers, direct access to another's private state, and mutable static state." C++'s cast-int-to-pointer is in the object model but not in the object-capability model. Smalltalk and Java *fall outside* the object-capability model because their mutable static state lets objects interact outside the reference graph.

Whereas the *functionality* of an object program depends only on the abilities its substrate provides, the *security* of an object-capability program depends on **underlying inabilities as well**. In a graph of mutually suspicious objects, one object's correctness depends not only on what the rules say it can do, but also on what the rules say its potential adversaries cannot do.

### §4.1 The formal model — primitives, instances, the loader

Table 1 of the paper aligns three vocabularies — Model, Capability OS, Object Language:

| Model term | Capability OS | Object Language |
| ---------- | ------------- | --------------- |
| instance   | process, domain | instance, closure |
| code       | non-kernel program + literal data | lambda expression, class file, method table |
| state      | address space + c-list (capability list) | environment, instance variable frame |
| index      | virtual memory address, c-list index | lexical name, variable offset, argument position |
| loader     | domain creator, `exec` | `eval`, ClassLoader |

The static state of the reference graph is composed of:

- An **object** is either a *primitive* or an *instance*.
- An **instance** is code + state; an instance *of* the behavior described by its code.
- An **instance's state** is a mutable map from indexes to references.
- A **reference** provides access to an object, *indivisibly combining designation of the object, the permission to access it, and the means to access it*.
- A **capability** is a reference to non-data.
- **Code** describes how a receiving instance reacts to an incoming message.
- An **index** is some form of data used by code to indicate which addressable reference to use, or where in state to store one.

Message passing and object creation dynamically change the graph's connectivity. Alice can cause effects on the world outside herself only by sending messages to objects directly accessible to her; arguments include further references to directly-accessible objects. Bob is affected by the world outside himself only by receiving messages from those with access to him.

Three kinds of primitive objects are distinguished:

1. **Data**. Numbers, strings — access to data is *knowledge-limited* rather than permission-limited. If Alice can compute the integer she wants, she can have it. Data is immutable, so a reference to data and the data itself need not be distinguished.
2. **Devices**. The boundary between the *computational system* (objects of potential interest) and the *external world*. A non-device object can only affect the external world by sending a message to an accessible output device. A non-device object can only be affected from the external world by receiving a message from an input device that has access to it.
3. **Loader**. Makes new instances. The creation request has two arguments: *code* (describing the new instance's behavior) and *an index → reference map* providing all the instance's initial state. A loader must ensure that the new instance's behavior cannot violate the rules of the model. A loader returns *the only reference* to the new instance.

The §4 closing rule: **only connectivity begets connectivity** — all access must derive from previous access. Two disjoint subgraphs cannot become connected, as no one can introduce them. Arrangement-based analysis of bounds on permission proceeds by *graph reachability arguments*. Overt causation, carried only by messages, flows only along permitted pathways, so reachability arguments also bound authority and causality. The transparency of garbage collection relies on the same property.

### §4.2 A taste of E — `pointMaker` and the loader transformation

The paper presents a `pointMaker` E example:

```
def pointMaker {
    to make(x :int, y :int) :any {
        def point {
            to getX() :int { return x }
            to getY() :int { return y }
            to add(otherPt) :any {
                return pointMaker.make(x.add(otherPt.getX()),
                                      y.add(otherPt.getY()))
            }
        }
        return point
    }
}
```

The nested definition of `point` uses `x` and `y` freely — these are its instance variables, forming its state. The state *maps from indexes "x" and "y" to the associated values from point's creation context*.

The paper then shows the **explicit loader transformation**:

```
def pointMaker {
    to make(x :int, y :int) :any {
        def point := loader.load("def point {...}",
                                 ["x" => x, "y" => y])
        return point
    }
}
```

The expression `["x" => x, "y" => y]` builds a map of index ⇒ reference associations. "All 'linking' happens only by virtue of these associations — *only connectivity begets connectivity*."

The loader transformation, applied recursively, would unnest all object definitions. Nested object definitions better explain instantiation in object languages; the loader better explains process or domain creation in operating systems. In E, almost-always-use object definitions, but use the loader below to achieve *confinement* — to be addressed in §5.

### §4.3 Redell's 1974 Caretaker pattern — the revocation existence proof

The opening of §4.3 names the problem: "When Alice says `bob.foo(carol)`, she gives Bob unconditional, full, and perpetual access to Carol. Given the purpose of Alice's message to Bob, such access may dangerously exceed least authority. In order to practice POLA, Alice might need to somehow restrict the rights she grants to Bob. For example, she might want to ensure she can revoke access at a later time. But in a capability system, capabilities themselves are the only representation of permission, and they provide only unconditional, full, perpetual access to the objects they designate."

The pull-quote (Chander, Dean, Mitchell 2001): *"Capability systems modeled as unforgeable references present the other extreme, where delegation is trivial, and revocation is infeasible."*

The paper's answer is Redell's 1974 pattern (a slight simplification):

```
def caretakerMaker {
    to make(var target) :any {
        def caretaker {
            match [verb :String, args :any[]] {
                E.call(target, verb, args)
            }
        }
        def revoker {
            to revoke() :void {
                target := null
            }
        }
        return [caretaker, revoker]
    }
}
```

Instead of `bob.foo(carol)`, Alice says:

```
def [carol2, carol2Rvkr] := caretakerMaker.make(carol)
bob.foo(carol2)
```

The **Caretaker `carol2`** transparently forwards messages it receives to `target`'s current value. The **Revoker `carol2Rvkr`** changes what that current value is. Alice can later revoke her grant to Bob by `carol2Rvkr.revoke()`.

The mechanism: `var` in E means the variable can be reassigned (the opposite of Java's `final`). The scope of `target`'s definition contains both `caretaker` and `revoker`; both use `target` freely, so they *share access to the same assignable target variable* (which is therefore a separate object).

When Bob invokes `carol2`, thinking he's invoking the kind of thing Carol is: an object definition contains methods and an optional `match` clause defining a matcher. If an incoming message doesn't match any of the methods, it is given to the matcher. `verb` is bound to the message name (`"add"`), `args` to the argument list (`[3]`). Messages are sent generically using `E.call(...)`, much like Smalltalk's `perform:`, Java's reflection, or Scheme's `apply`.

The Caretaker provides a **temporal restriction of authority**. Similar patterns provide other restrictions, such as *filtering facets* that let only certain messages through. Even in systems not designed to support access abstraction, *many simple patterns happen naturally* — under Unix, Alice might provide a filtering facet as a process reading a socket Bob can write; the facet process would access Carol using Alice's permissions.

### §4.4 Analysis and blind spots — why permission-only analysis renders the Caretaker invisible

Given Redell's 1974 existence proof, the paper asks what to make of subsequent arguments that revocation is *infeasible* in capability systems. "Of those who made this impossibility claim, as far as we are aware, none pointed to a flaw in Redell's reasoning."

The diagnosis: the key is the difference between permission and authority analysis.

By Chander-Dean-Mitchell's permission-only analysis [Chander01]: **Bob was never given permission to access Carol**, so there was no access to Carol to be revoked. Bob was given permission to access `carol2` (the Caretaker), and he still has it. **No permissions were revoked.**

Karger-Herbert 1984 had identified the underlying issue: "A security officer investigating an incident needs to know who has access to a compromised object." Karger-Herbert proposed giving the security officer a list of all subjects permitted to access Carol. That list will not include Bob's access to Carol, since this indirect access is represented only by the system's protection state taken together with the *behavior of objects playing by the rules*. Within their system, Alice — by restricting the authority given to Bob *as she should* — has **inadvertently thwarted the security officer's ability to get a meaningful answer to his query**.

The paper's pivotal turn:

> *To render permission-only analysis useless, a threat model need not include either malice or accident; it need only include subjects following security best practices.*

This is the strongest possible critique of arrangement-only analysis. Following POLA *is itself* a behavior that permission-only analysis cannot account for. An arrangement-only bound would include the possibility of the Caretaker giving Bob direct access to Carol — *precisely what the Caretaker was constructed not to do*. Only by reasoning about *behaviors* can Alice see that the Caretaker is a "smart reference."

Just as `pointMaker` extends our vocabulary of data types, raising the abstraction level at which we express solutions, *so does the Caretaker extend our vocabulary for expressing access control*. Alice (or her programmer) should use *arrangement-only* analysis for reasoning about what potential adversaries may do. But Alice also interacts with many objects, like the Caretaker, *because she has some confidence she understands their actual behavior*.

## Translation block (paper idiom → Endo / Hardened JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Object-capability model (lambda + local side effects) | The compartment + exo + lockdown discipline; SES is the substrate that *adds the inabilities* to JS. |
| `loader.load(code, ["x" => x, ...])`       | A compartment's `Compartment(...)` constructor with explicit endowments; or a bundle's compartment-init endowment object. |
| Caretaker pattern (`carol2`, `carol2Rvkr`) | An exo wrapping a target reference; a separate revoker exo holding the assignable variable. The library's `caretaker-pattern` concept. |
| Filtering facet                            | An exo exposing a narrower method surface than the underlying target; the *attenuation* discipline. |
| `var` (mutable variable shared across closures) | Plain JavaScript `let` inside a shared lexical scope. |
| Matcher / `E.call(target, verb, args)`     | Generic `Reflect.apply` on a proxy / membrane; the @endo/exo class with method-name dispatch. |
| Forged pointers, mutable static state (the *inabilities*) | SES lockdown freezes the realm; `harden()` deep-freezes objects; no `globalThis` mutation. |

## Implications for Endo

The §4 model + the §4.3 Caretaker pattern are *foundational* to Endo's whole posture, and §4.4's analysis-and-blind-spots argument is the most-cited library citation for why Endo design reviews cannot rely on arrangement-only reasoning:

1. **The reference graph is the access graph.** Endo's formula graph is its enactment of *the reference graph as the access graph*. Cycle 47's daemon-persistence ingest names this: persistence by traversal from petname roots. The §4 framing is the structural justification.
2. **Loader-style explicit endowment.** Endo's bundle-compartment endowment object IS `loader.load(code, [...index ⇒ reference...])`. Every bundle's compartment is born under this discipline; "all linking happens only by virtue of these associations."
3. **Caretaker pattern is a library concept.** The existing `caretaker-pattern` concept page (anchored from Capability Myths Demolished's irrevocability-myth section and Concurrency Among Strangers' POLA section) gains a *third* canonical citation here, with the §4.3 worked code as the canonical implementation.
4. **Design reviews must reason about authority, not just permission.** The §4.4 *to render permission-only analysis useless...* claim is the deepest reason design reviews of Endo bundles need to be authority-reviews, not just structural-permission audits. A reviewer who only checks "what does this exo's endowment hold?" misses every Caretaker-style attenuation; they need to ask "what authority does this exo *ultimately mediate*?"
5. **JavaScript almost falls outside the model.** §4's parenthetical that "Smalltalk and Java fall outside the object-capability model because their mutable static variables enable objects to interact outside the reference graph" applies equally to plain JavaScript. *SES is the lockdown discipline that puts JavaScript inside the object-capability model* — by freezing intrinsics and forbidding mutable global state.

## See also

- [[caretaker-pattern]] — the existing concept page; this section is the *canonical worked-code* citation. Cycle 66's notes also surface the handled-promise.js implementation-rationale parallel.
- [[principle-of-least-authority]] — deferred concept page. §4.4 is the citation that motivates *why* POLA needs to be the discipline — because permission-only analysis is structurally inadequate.
- [[four-ways-to-acquire-references]] — deferred concept page. §4.2's `loader.load(code, [...x ⇒ x, y ⇒ y])` is the *Endowment* mechanism in `papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority` enumerated form.
- `papers--miller-capability-myths-demolished-2003--irrevocability-myth` — the companion paper's framing of the same Redell-1974 result; CMD's *Property E (Composability)* is the formal characterisation.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority` — the four-ways enumeration; Endowment is the §4.2 transformation rule.

## Common confusions

- **"Capabilities can't revoke."** §4.3 + §4.4 are the canonical refutation. Capabilities-as-bare-references cannot revoke, but Redell's 1974 *Caretaker pattern* — a behavioral abstraction *built from* capabilities — does revoke. The infeasibility-of-revocation literature relies on permission-only analysis that the Caretaker is invisible to.
- **"Behavioral analysis is too hard."** Per §4.4: "Alice should use arrangement-only analysis for reasoning about what potential adversaries may do. But Alice also interacts with many objects, like the Caretaker, *because she has some confidence she understands their actual behavior*." Behavioral analysis is *targeted* — applied to the small set of trusted behavioral abstractions in any given design, not to every untrusted subject.
- **"The Caretaker requires `var`. JavaScript has `var`, so we're fine."** Conceptually right but watch the encapsulation: in E, `var target` is *encapsulated by* the enclosing `caretakerMaker.make` scope. In JavaScript, the equivalent is `let target` inside the constructor closure — not a free `var target` at module top level (which would be shared across all Caretaker instances and would leak between bundles).
- **"`E.call(target, verb, args)` is dangerous because it's generic dispatch."** It is generic dispatch, but Bob *cannot reach `target` directly* — he can only message `carol2`, which calls `E.call(target, ...)` *internally*. The genericity is *internal to the Caretaker*; the discipline is that Bob's authority is bounded by what the Caretaker chooses to forward.
