---
title: Access Abstraction and Confinement (modularity gives access control for free; Cassie's factory + factoryMaker; the *-property challenge solved with a data diode)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "14-19 (§4.5 Access Abstraction, §5 Confinement, §5.1 Non-Discretionary Model, §5.2 The *-Properties)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
---

## Abstract

§4.5 names the **lost paradigm**: the object-capability model does not describe access control as a separate concern to be bolted on. It is a *model of modular computation with no separate access-control mechanisms*. All its support for access control "is well enough motivated by the pursuit of abstraction and modularity." Parnas's *information hiding* (1972) says abstractions should hand out information only on a *need-to-know* basis; POLA simply adds that authority should be handed out only on a *need-to-do* basis. Modularity and security each require both. §5 takes up Lampson's 1973 **confinement problem**: how to run an untrusted program in a controlled environment so it cannot leak its inputs. Cassie (the customer) and Max (the manufacturer) share a `[Factory, factoryMaker]` pair built with a *trademark* (FactoryStamp); Max packages his calculator code with `factoryMaker.make("...code...")`; Cassie's `acceptProduct(calcFactory)` instantiates the factory under Cassie's chosen state, confining it. §5.1 argues the resulting model is **non-discretionary**: in object-capability systems, even if Alice creates Carol, Alice may still only authorize Bob to access Carol if Alice has authority to access Bob — there are no principals with unconditional permission over what they create. §5.2 walks the **\*-property challenge** (Boebert 1984): the claim that an unmodified capability system cannot enforce one-way communication between subjects with different clearance levels. Cassie builds Q (a calculator over `diodeWriter`) and Bond (a calculator over `diodeReader`) connected through an assignable `diode` integer variable; Boebert's attack — Q sending a capability as an argument to `diodeWriter.write(val)` — fails because the `:int` guard on the `write` method rejects non-integer arguments. The *abstraction* enforces the property; the unmodified base model is *not* what enforces it. The paper's structural claim: this is *how* object-capability systems compose protection — through abstraction built on the base, not through new primitives.

## Body

### §4.5 Access abstraction — the lost paradigm

The §4.5 opening states the architectural claim plainly:

> The object-capability model does not describe access control as a separate concern, to be bolted on to computation organized by other means. Rather it is a model of modular computation with no separate access control mechanisms. All its support for access control is well enough motivated by the pursuit of abstraction and modularity.

Parnas's *information hiding* [Parnas72] says abstractions should hand out information only on a *need-to-know* basis. **POLA simply adds that authority should be handed out only on a *need-to-do* basis.** Modularity and security each require both.

The historical observation: the object-capability paradigm was *in the air by 1967* [Wilkes79, Fabry74] and *well established by 1973* [Redell74, Hewitt73, Morris73, Wulf74, Wulf81]. It adds the observation that "the abstraction mechanisms provided by the base model are not just for procedural, data, and control abstractions, but also for *access abstractions*, such as Redell's Caretaker."

Access abstraction is **pervasive in actual capability practice**:

- **Filtering facets** (the §4.3 §4.4 patterns).
- **Unprivileged transparent remote messaging systems** [Donnelley76, Sansom86, Doorn96, Miller00].
- **Reference monitors** [Rajunas89].
- **Transfer, escrow, and trade of exclusive rights** [Miller96, Miller00] (the precursor of *Capability-based Financial Instruments*, which is in the Agoric paper mirror but not yet ingested into the library).
- **The Powerbox** [Wagner02, Stiegler02] — the GUI-mediated capability granting pattern that the chat-cluster's *space picker* enacts at a coarser granularity.

The closing observation of §4.5: "Further, every non-security-oriented abstraction that usefully encapsulates its internal state provides, in effect, restricted authority to that internal state, as mediated by the logic of the abstraction." Every well-encapsulated class is *also* an access abstraction whether the class designer thought of it that way or not.

The §4.5 closing risk-bound argument: the base system is also a security-enforcing system, providing abstractions for controlling access. When *all* code is either trusted or untrusted, one can only extend the expressiveness of a protection system *by adding code to the base*, making everyone fully vulnerable to its possible misbehavior. By contrast, **only Alice relies on the behavior of her Caretaker**, and only to limit authority flowing between Bob and Carol. The risks to everyone — even Alice — from the Caretaker's misbehavior are limited because the Caretaker itself has limited authority. Alice can often bound her risk even from bugs in her own security-enforcing programs.

### §5 The confinement problem — Cassie, Max, and the calculator

Lampson 1973 named *the confinement problem* (epigraph quote): "a program can create a controlled environment within which another, possibly untrustworthy, program can be run safely... call the first program a customer and the second a service... [the service] may leak... the input data which the customer gives it. We will call the problem of constraining a service [from leaking data] the **confinement problem**."

The paper's domain example: Cassie (the customer) might want to use Max's (the manufacturer's) calculator with her financial data, confident the calculator cannot leak the data back to Max.

The setup: Cassie and Max have mutual access to a `[Factory, factoryMaker]` pair created by:

```
def [Factory, factoryMaker] := {
    interface Factory guards FactoryStamp {...}
    def factoryMaker {
        to make(code :String) :Factory {
            def factory implements FactoryStamp {
                to new(state) :any {
                    return loader.load(code, state)
                }
            }
            return factory
        }
    }
    [Factory, factoryMaker]
}
```

`interface .. guards` evaluates to a `(trademark guard, stamp)` pair representing a new *trademark*, similar in purpose to an interface type. This syntax also defines variables `Factory` and `FactoryStamp`. The `FactoryStamp` marks instances of `factory` — and nothing else — as carrying this trademark. The `Factory` guard appears in soft type declarations like `:Factory` to ensure only objects carrying this trademark may pass.

Cassie *trusts* that this pair behaves according to this code — "object-capability systems which provide trademarking primitively [Wulf81, Hardy85, Shapiro99, Yee03] are still within our model" (such trademarking can be *implemented* in DVH and the paper's model, so it's a derivation rather than an extension).

Max packages his calculator program:

```
def calculatorFactory := factoryMaker.make("...code...")
cassie.acceptProduct(calculatorFactory)
```

Cassie's `acceptProduct(calcFactory :Factory) :void` uses the `:Factory` declaration to ensure she receives only an instance of the above `factory` definition. **Inspection of the factory code shows that a factory's state contains only data** (here, a String) **and no capabilities — no access to the world outside itself.** Cassie can therefore use the factory to make as many live calculators as she wants, confident that each calculator has *only that access beyond itself that Cassie authorizes*. They cannot even talk to each other unless Cassie allows them to.

The structural point: with lambda evaluation, a new subject's code and state both come from the same parent. To solve the confinement problem, *we combine code from Max with state from Cassie* to give birth to a new calculator, *and we enable Cassie to verify that she is the only state-providing parent*. The new calculator is a **controlled subject** — one Cassie knows is born into an environment controlled by her. By contrast, if Max introduces Cassie to an already-instantiated calculation service, Cassie would not be able to tell whether it has prior connectivity, making it an *uncontrolled subject*.

### §5.1 A non-discretionary model

Capabilities are normally thought to be *discretionary* — and to be unable to enforce confinement. The §5.1 confinement logic above relies on the **non-discretionary** nature of object-capabilities.

Saltzer-Schroeder's quote (emphasis in original): "Our discussion... rested on an unstated assumption: the principal that creates a file or other object in a computer system has *unquestioned authority to authorize access to it by other principals*. We may characterize this control pattern as **discretionary**."

The paper's response: *object-capability systems have no principals*. A human user, together with his shell and "home directory" of references, participates in effect as just another subject. With the substitution of "subject" for "principal," the §5.1 claim is: *by this definition, object-capabilities are not discretionary*. In DVH and most actual capability system implementations, **even if Alice creates Carol, Alice may still only authorize Bob to access Carol if Alice has authority to access Bob**. If capabilities were discretionary, they would indeed be unable to enforce confinement. To illustrate the power of confinement, the next section uses it to enforce the *-properties.

### §5.2 The *-property challenge — Boebert 1984 and Cassie's diode

The §5.2 setup names the claim and the historical context. Boebert 1984 [Boebert84] claimed that an unmodified capability machine cannot enforce the *-property or solve the confinement problem. Briefly, the *-properties allow lower-clearance subjects to *communicate to* higher-clearance subjects but prohibit communication in the reverse direction. KeySafe [Rajunas89] is a concrete enforcing-design for the *-properties on KeyKOS. Despite Boebert's later acknowledgment that his 1984 paper "remains, no more than an offhand remark... the historical significance of the paper is that it prompted the writing of [Kain87]," claims that capabilities cannot enforce the *-properties continue [Gong89, Kain87, Wallach97, Saraswat03], citing Boebert84 as their support.

The paper's resolution: extending the confinement example, Cassie accepts a `calcFactory` from Max with this `acceptProduct`:

```
to acceptProduct(calcFactory :Factory) :void {
    var diode :int := 0
    def diodeWriter {
        to write(val :int) :void { diode := val }
    }
    def diodeReader {
        to read() :int { return diode }
    }
    def q    := calcFactory.new(["writeUp" => diodeWriter, ...])
    def bond := calcFactory.new(["readDown" => diodeReader, ...])
    ...
}
```

Cassie creates two calculators to serve as Q and Bond. She builds a **data diode** by defining a `diodeWriter`, a `diodeReader`, and an assignable `diode` variable they share. She gives Q and Bond access to each other *only through the data diode*.

Applied to Cassie's arrangement, Boebert's attack would start by observing that Q can send a *capability* as an argument in a message to `diodeWriter` — but `diodeWriter.write(val :int)` has a `:int` guard on its parameter. An arrangement-only bound on permissions or authority *supports Boebert's case* — the data diode might introduce *this argument* to Bond. **Only by examining the behavior of the data diode can we see the tighter bounds it was built to enforce.** The data diode transmits *data (here, integers) in only one direction* and *capabilities in neither*. Q cannot even read what he just wrote.

The architectural point: Cassie relies on the behavior of the factory and data diode *abstractions* to enforce the *-properties and prevent Boebert's attack. The abstraction does the enforcement; the unmodified base model is not what enforces the *-property. The capability paradigm's primitives *plus* an abstraction built from them are jointly what enforces.

## Translation block (paper idiom → Endo / Hardened JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Trademark / `FactoryStamp`                 | Endo's @endo/marshal *brand* primitive; @endo/exo class shape declarations. Both implement *type-by-fiat* — the holder of the stamp can mark; the holder of the guard can verify. |
| Factory pattern                            | A bundle's `make*` entry point that constructs sub-exos with attenuated authority. |
| Cassie's `acceptProduct(:Factory)` guard   | Type-guarded exo method on the receiving side; rejects any value not carrying the brand. |
| `loader.load(code, [...endowments])`       | `Compartment(globals, modules, options)` constructor with explicit endowments. The bundle's compartment-init is exactly this pattern. |
| Data diode (`diodeWriter` / `diodeReader`) | A pair of exos exposing complementary `write` and `read` methods sharing closed-over mutable state, with input guards enforcing the data-only invariant. |
| `:int` parameter guard                     | @endo/patterns matcher applied as a method-guard; @endo/exo's interface declaration with shape constraints. |
| "Cassie can verify she is the only state-providing parent" | The Endo bundle endowment discipline: the endowment object is built by the parent at compartment-construction time; the child compartment has no other authority unless the parent's endowment objects re-export. |

## Implications for Endo

These sections are the *theoretical anchors* for several Endo primitives often taken for granted as engineering choices:

1. **Brand / trademark is a foundational primitive, not a convenience.** Endo's @endo/marshal brand mechanism IS the FactoryStamp pattern. The §5 confinement argument *depends* on brands working; without them Cassie cannot verify the calcFactory she received from Max is actually a factory and not a back-channel.
2. **Modularity gives access control for free.** §4.5's claim is the *most-cited* library citation for why Endo's good-software-engineering discipline IS its security discipline. The hardener, the lockdown, the marshal pass-style: each is a strict reading of an existing JS practice (deep-freeze; no ambient state; explicit serialization boundaries).
3. **Confinement is achievable in JavaScript.** The §5 Cassie+Max confinement is exactly what an Endo bundle does when it loads a guest module into a compartment with a curated endowment object. The Endo daemon's bundle-loading is the production enactment of `cassie.acceptProduct(calcFactory)`.
4. **Object-capabilities are non-discretionary.** §5.1 is the citation for why Endo's *creator does not own creation* — when an exo constructs a child exo, the constructor's parent does not automatically gain authority to the child. Authority flows by *Endowment* and *Introduction* (the four-ways enumeration), not by parenthood-implies-rights.
5. **The *-property challenge has a positive answer.** §5.2's Cassie-diode example shows that capability-based systems *can* enforce one-way information flow, contradicting a 30-year-old impossibility folklore. Endo can build the analogous one-way channel using a pair of exos with shape-guarded methods over a shared closed-over variable. The library can cite this whenever Endo work needs to defend against the "capabilities can't do MLS" objection.

## See also

- [[caretaker-pattern]] — the existing concept page. The factory + factoryMaker pattern is structurally identical at one abstraction level up: caretaker mediates *one* target, factory mediates *one* code-and-state-template.
- [[principle-of-least-authority]] — deferred concept page. §4.5's "POLA simply adds that authority should be handed out only on a need-to-do basis" is the canonical one-line statement.
- [[four-ways-to-acquire-references]] — deferred concept page. §5's Cassie-confines-Max example demonstrates the *Endowment* mechanism in its purest form: state from Cassie, code from Max, instance is born already-endowed.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity` — the §4.5 "modularity gives access control for free" thesis is the seed of *Structure of Authority*'s Table 1 ("security as extreme modularity").
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola` — Concurrency Among Strangers' "defensive correctness despite arbitrary client behavior" is the partial-failure-side companion to this section's *-property argument.

## Common confusions

- **"Capability systems can't enforce *-properties."** §5.2 is the canonical refutation. The unmodified base model cannot; the base model *plus* a behavioral abstraction (Cassie's diode) can. The 30-year-old impossibility folklore relies on permission-only analysis.
- **"Confinement requires kernel-level enforcement."** No — §5's Cassie+Max example uses only Dennis-van-Horn 1966 primitives. The kernel role is filled by the *trademark* primitive and the *loader*; everything else is built from those.
- **"`:int` parameter guards are just static typing."** They are static typing *and* they are access control. Cassie's `:int` guard on `diodeWriter.write` is what blocks Boebert's attack of passing a capability through. Type-guard-as-access-control is the §5.2 lesson.
- **"Capabilities are discretionary because the creator chose who got the first reference."** §5.1 refines this: the creator chose, yes, but the creator could only authorize that handoff if the creator had authority to message the recipient. There are no *principals* with unconditional authority over what they create. Endo inherits this: parent bundle cannot reach into child bundle's compartment except via references explicitly passed.
- **"The lost paradigm is just object-orientation."** §4.5's *abstraction as a protection mechanism* is more than OO. OO gives you encapsulation; the lost paradigm gives you the recognition that **encapsulation IS access control** — that abstraction mechanisms *are* the protection mechanisms.
