---
title: The Confinement Myth (Model 4 and access-controlled delegation)
source: Capability Myths Demolished (SRL2003-02)
source_kind: paper
source_authors: [Mark S. Miller, Ka-Ping Yee, Jonathan Shapiro]
source_year: 2003
source_venue: JHU SRL Technical Report SRL2003-02
source_url: https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf
source_pdf_sha256: b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
---

## Abstract

The Confinement Myth claims "capability systems cannot limit the propagation of authority." The paper's reply rests on a single observation about Model 4 (Object Capabilities): **a capability can travel from Alice to Bob only along a capability Alice already holds for Bob**. If Alice has no capability to Bob, no capability Alice holds can be delegated to him, because there is no channel. Confinement of a set of objects is therefore decidable by graph connectivity: "the subgraph containing the set of objects is not connected to the rest of the object graph." The paper also examines Boebert's 1984 argument (the strongest historical version of the myth) and shows that in *partitioned* or *type-enforced* capability systems (KeyKOS, W7, EROS, E), Boebert's *-Property attack fails because capabilities and data are distinguished — Alice cannot smuggle a capability through a data channel.

## Body

### The 1988 KeyKOS counter-example

The myth was already empirically refuted in 1988 by Karger, who acknowledged: "KeyKOS achieves confinement by a mechanism called *factories*. Essentially, a factory is a mechanism for creating new instances of protected subsystems." The paper observes "It is unfortunate that the Confinement Myth continues to scare people away from capabilities so long after KeyKOS succeeded in confining programs."

### Delegation in object capabilities

The paper's Figure 5 shows Alice delegating a capability `foo` (which points to Carol) by sending it as a message to Bob. The send itself requires a capability from Alice to Bob — "messages may only travel along a capability." So:

> In order for Alice to authorize Bob to access Carol, Alice must herself be authorized to access *both* Bob and Carol. The requirement that capability transfer makes confinement possible, since no capability transfer can introduce a new connection between two objects that were not already connected by some path. Confinement of authorities within a set of objects can be determined simply by observing that the subgraph containing the set of objects is not connected to the rest of the object graph.

The paper continues with a concrete confinement example: "Suppose, for example, we decide not to trust Bob. To prevent Alice from delegating to Bob, we simply refrain from giving Alice access to Bob. No subgraph of co-operating objects can delegate to Bob if Bob is not reachable from that subgraph to begin with. This simple insight is the basis for many capability-based confinement systems."

### The Wallach/Balfanz/Dean/Felten objection

A widely-cited 1997 paper on Java security made a subtler version of the claim: "two programs which can communicate object references can share their capabilities without system mediation." The paper's reply: "this slightly different error... correctly acknowledges that the ability to communicate object references is *necessary* for two programs to share their capabilities. However, it appears to overlook the possibility that such an ability to communicate object references might be unavailable or restricted." That ability is precisely what an object-capability system controls.

### Boebert's 1984 *-Property attack and its limits

Boebert's 1984 argument (the strongest historical version of the myth) constructed an attack: Alice holds a Write-Low capability and writes it into a Low segment; Bob reads the Write-Low capability out of the Low segment; Bob then uses the Write-Low capability to write information from High into Low — violating the *-Property. Figures 7-9 of the paper diagram this attack against an "unmodified capability machine".

The paper's reply: "Boebert's example assumes that subjects can transmit capabilities anywhere they can transmit data, which is not the case in most capability systems." In *partitioned* or *type-enforced* capability systems — explicitly listing KeyKOS [9], W7 [19], EROS [21], and **E** [4] — "capabilities and data are distinguished by the kernel or runtime. Reading and writing capabilities are necessarily distinguishable operations from reading and writing data." Figure 10 redoes the diagram with separate capability-read / capability-write authorities and shows the *-Property is enforced.

The paper formalizes this kernel-level distinction as needed for **Property F: Access-Controlled Delegation Channels** — "is an access relationship between two subjects X and Y required in order for X to pass an authority to Y?" Object-capability systems hold Property F; password-capability systems (like Amoeba [17]) do not.

A separate misunderstanding cited by Gong — "a capability is just a bit string [and] can propagate in many ways without the detection of the kernel or the server" — applies *only* to **password capability systems** (those where capabilities are unforgeable only because they are unguessable bit strings). Object-capability systems do not store capabilities as guessable / pass-by-data bit strings, so this whole class of attack is structurally absent.

### Final reply

"Moreover, it has been formally verified [Shapiro & Weber 2000] that any capability system enforcing independent controls on data transfer and capability transfer can enforce both confinement and the *-Property."

## Translation

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| capability transfer | passing a Presence / exo by reference via `E()` (eventual-send) or by structured-clone in marshal |
| pass capability anywhere data goes | not how Endo works: marshal distinguishes pass-style at the wire; a `passStyle: 'remotable'` value crosses as a remote slot, not as the bytes of its identifier |
| factory (KeyKOS) | Endo's compartment-bound constructor pattern: a confined factory exo with no ambient authority that vends instances downstream |
| partitioned capability system | Endo's marshal layer: data goes via `passStyle` enumerated transit (copyRecord, copyArray, smallcaps strings); capability goes via `passStyle: 'remotable'` with an *out-of-band* slot table the wire format references symbolically |
| *-Property | Bell-LaPadula multi-level security write-up restriction; not a primary Endo concept, but relevant when reasoning about cross-trust-level delegation in agent / connector / persona designs |

## Implications for Endo

The paper's core argument — *capabilities can travel only along capabilities* — is the upstream justification for Endo's most distinctive design property: that **a compartment with no incoming or outgoing references is structurally unable to receive or transmit capability**. The `inert worker` lifecycle in the Endo daemon depends on this: a compartment born with only the capabilities its formula prescribes can hold no others, because there is no surface through which a new capability could arrive.

For the cross-peer GC and retention-accumulator designs the library already indexes, the paper's confinement argument is what makes it *meaningful* to reason about reference graphs as the unit of GC: if reference X is not reachable from the agent's pet-store via any chain of held references, X is confined out of that agent's authority, and the daemon may collect it.

The paper's Property F is the formal name for the discipline Endo's `@endo/marshal` enforces: a `passStyle: 'remotable'` value is not transmittable as bytes (its slot-side identity lives in the slots-table, not on the wire), so a malicious peer cannot smuggle a remote reference through a smallcaps string field.

## Common confusions

- **"Capability systems can't confine because Bob can read the capability bytes."** Holds only for *password capability* systems (Amoeba-style, where unforgeability is bit-string-entropy). Object-capability systems (KeyKOS, EROS, E, Endo's marshal) do not represent a held capability as readable data bytes; the bit pattern in the C-list is private to the kernel / VM / runtime. This is Property F: kernel-enforced distinction between capability and data transmission.
- **"Boebert proved confinement is impossible."** Boebert's 1984 argument proved confinement is impossible *in an unmodified capability machine where subjects can transmit capabilities anywhere they can transmit data*. The premise has not held in actual practice since at least KeyKOS, and never holds in any object-capability system.

## See also

- [[cohort-destruction]] — the per-cohort reference subgraph that the paper's confinement argument tells us is well-defined.
- [[revocation-by-withdrawal]] — the revocation half of the same graph-reasoning argument.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 4-7; SHA-256 `b6a3e04e60d7`.
