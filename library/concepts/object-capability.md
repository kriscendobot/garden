---
id: object-capability
aliases: ["object capability", "object-capability", "ocap", "object-capability model", "Model 4 object capabilities", "pure capability"]
topics: [capability-theory, capability-security]
---

# object-capability

The "true" capability model per Miller-Yee-Shapiro 2003: a capability is an **unforgeable reference to an object** where the reference is simultaneously the designator (it names the resource) and the authority (it conveys permission to invoke the resource's methods). The model is distinguished from three other things often called "capabilities":

- **Model 1: ACLs as columns** — Lampson's access matrix read by column; the dominant Unix-style model.
- **Model 2: Capabilities as rows** — Lampson's access matrix read by row; a *misreading* of capability that lacks composability.
- **Model 3: Capabilities as keys** — the *unforgeable copyable keys* analogy; a misreading that separates subject and resource into distinct type categories.
- **Model 4: Object capabilities** — what KeyKOS, EROS, E, and the Endo daemon actually implement.

Object capabilities hold all seven Miller-Yee-Shapiro security properties: **A** No Designation Without Authority, **B** Dynamic Subject Creation, **C** Subject-Aggregated Authority Management, **D** No Ambient Authority, **E** Composability of Authorities, **F** Access-Controlled Delegation Channels, **G** Dynamic Resource Creation. Models 2 and 3 hold proper subsets, which is why the Confinement and Irrevocability Myths *seem* true in those models — they *are* true there. Model 4 holds enough properties that both myths fail.

The Endo daemon is a Model 4 system. The library's `capability-security` topic catalogs Endo-side sections that put the model into practice; this concept page is for the *term-of-art definition* itself.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers/capmyths/abstract-and-introduction](../sections/papers--miller-capability-myths-demolished-2003--abstract-and-introduction.md) | The four models named and the paper's claim that Model 4 is the model implemented capability systems realize. |
| [papers/capmyths/four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) | The full property table comparing all four models; Model 4 holds all seven properties. |
| [papers/capmyths/advantages-pola-confused-deputy](../sections/papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy.md) | The closing terminology argument: "the 'true' capability model is the object-capability model." |
| [endo--readme--core-concepts](../sections/endo--readme--core-concepts.md) | Endo-side definition of capability + object + reference (the practitioner's vocabulary). |
| [endo--docs-security--overview](../sections/endo--docs-security--overview.md) | Endo's framing of capability discipline at the security-doc level. |
| [endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise](../sections/endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise.md) | Boundary enforcement at the eventual-send shim: an untrusted promise `p` could attack the shim via `p.then`; the `isSafePromise` predicate guards. The residual reentrancy gap (the predicate itself reads `p`'s properties) is a JS-standard limitation Endo cannot close locally — a worked example of where the object-capability model meets the limits of the host language. |
| [what-are-capabilities/what-a-capability-is](../sections/habitat-chronicles--what-are-capabilities--what-a-capability-is.md) | Plain-language ocap-model definition: a reference to an object is a capability; ocap = OOP + unforgeable references + strong encapsulation; creation/transfer/endowment. |
| [what-are-capabilities/the-idea](../sections/habitat-chronicles--what-are-capabilities--designation-and-authority-the-idea.md) | The ACL-vs-ocap contrast at the intuitive level: don't separate designation from authority; a capability (file handle) fixes the confused-deputy flaw of ambient authority. |
| [habitat-chronicles--tripartite-identity-pattern--account-identifier](../sections/habitat-chronicles--tripartite-identity-pattern--account-identifier.md) | Identity-layer echo of Property D (No Ambient Authority): the permanent account anchor is inert with **no inherent public capabilities**, so the value that names the account confers nothing on presentation. |
| [habitat-chronicles--tripartite-identity-pattern--login-identifier](../sections/habitat-chronicles--tripartite-identity-pattern--login-identifier.md) | Federated logins (OpenID / OAuth / Facebook Connect) named as **capability-based identities** — a delegated session-establishing capability adopted from an external provider rather than a shared secret. |
| [papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign](../sections/papers--shi-spatiotemporal-composability-2026--boundaries-security-and-codesign.md) | Cordis (Shi et al. 2026) §6.3 independently arrives at capability-based access control: dependency injection = capability request, context proxy = mediator, authority by reference-possession not ambient authority. |
| [cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference](../sections/cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference.md) | Landau's behavioral definition: a capability is what it does under a message, not an object reference; equality and the incidental data byte follow. |
| [cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus](../sections/cap-talk-2000-2001--two-threads-of-capability-thinking-os-vs-lambda-calculus.md) | Miller's two-threads history placing the object-capability model in the lambda-calculus/Actors lineage rather than the OS access-matrix one. |
| [cap-talk-2002-2003--normal-users-can-construct-least-authority](../sections/cap-talk-2002-2003--normal-users-can-construct-least-authority.md) | Matrix-model precursor to Models 1-4: object capabilities let ordinary subjects create and attenuate authority without admin power. |
| [cap-talk-2002-2003--li-gong-keykos-and-capability-myths](../sections/cap-talk-2002-2003--li-gong-keykos-and-capability-myths.md) | Direct drafting context for Capability Myths Demolished and its insistence that implemented KeyKOS belongs in the model. |
| [cap-talk-2002-2003--single-use-capabilities-systems](../sections/cap-talk-2002-2003--single-use-capabilities-systems.md) | Resume capabilities and constructed one-shot objects show that an object capability can carry consume-on-use behavior. |
| [cap-talk-2002-2003--single-use-capability-object-in-e](../sections/cap-talk-2002-2003--single-use-capability-object-in-e.md) | An E wrapper attenuates any target to one invocation by consuming its reference before forwarding. |
| [cap-talk-2002-2003--auditing-capability-systems](../sections/cap-talk-2002-2003--auditing-capability-systems.md) | Auditing the reference graph exposes the tension between graph-wide observability and least authority. |
| [cap-talk-2002-2003--programming-with-capabilities-without-ownership](../sections/cap-talk-2002-2003--programming-with-capabilities-without-ownership.md) | Exclusive ownership dissolves into explicit customer, maintenance, reclamation, and debugging capabilities. |
| [managed-language-object-references-as-capabilities](../sections/cap-talk-2009-2012--managed-language-object-references-as-capabilities.md) | Managed-language object references are capabilities when unforgeability and explicit connectivity are enforced. |
| [nacl-descriptors-confinement-not-capabilities](../sections/cap-talk-2009-2012--nacl-descriptors-confinement-not-capabilities.md) | Distinguishes capability semantics from a sandbox's generic descriptor representation. |
| [object-oriented-security-naming](../sections/cap-talk-2009-2012--object-oriented-security-naming.md) | Varda's thesis that ocap security is a special case of object-oriented design, and the never-settled dispute over renaming it 'object-oriented security'. |
| [safe-language-defined-and-ocap](../sections/cap-talk-2009-2012--safe-language-defined-and-ocap.md) | An ocap language must guarantee safety of exactly the abstractions that preserve ocap invariants (unforgeable references, scopes, no ambient authority). |

## See also

- [[caretaker-pattern]] — the canonical Model-4-enabling pattern; possible only because Model 4 has Property E (composability).
- [[revocation-by-withdrawal]] — the Endo-specific revocation mechanism; structurally distinct from caretaker-style revocation but presupposes the object-capability model.
- [[cohort-destruction]] — partition response that depends on Model 4's dynamic subject creation (Property B).
- [[pass-invariant-handle-equality]] — Endo-side enforcement of Property A (No Designation Without Authority) at the Handle layer.
- [[distributed-confinement]] — confinement is achievable *only* in the Model-4 object-capability model; the *Confinement Myth* is the canonical proof that Models 2 and 3 cannot confine while Model 4 can.
- [[eventual-send]] — the capability-safe operation over a Model-4 reference: the only thing you can do with a reference is send it messages, and the only way it reaches a new holder is as a message argument.
- [[capability-chain]] — dialog-db's typed-Rust realization of attenuated object-capability delegation (`Subject → Attenuation → Policy → Effect` ability paths), serializable to offline UCAN tokens.
- [[confused-deputy]] — the failure mode the object-capability model eliminates: separating designation from authority leaves a deputy holding ambient authority it cannot wield selectively. Properties A (No Designation Without Authority) and D (No Ambient Authority) are precisely its cure.

## Common confusions

- **"POSIX capabilities are an object-capability system."** No — POSIX 1003.1e capabilities are roughly capabilities-as-rows (Model 2) without Property G (dynamic resource creation). They lack composability and access-controlled delegation. They are a different thing that unfortunately shares a name; see [four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) for the property comparison.
- **"Capability = unforgeable bit string."** Holds only for *password capability* systems (Amoeba-style). Object capabilities are unforgeable because the runtime / kernel mediates them; the bit pattern in the C-list is not readable as data. This distinction matters for confinement; see [confinement-myth](../sections/papers--miller-capability-myths-demolished-2003--confinement-myth.md).
- **"Object-capability and capability-based security are different things."** They are the same thing in current practice. The term *object-capability* is preferred when one wants to be precise about *which* capability model (to distinguish from Models 1, 2, 3); plain *capability* in modern usage usually means Model 4.
