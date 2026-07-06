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

## See also

- [[caretaker-pattern]] — the canonical Model-4-enabling pattern; possible only because Model 4 has Property E (composability).
- [[revocation-by-withdrawal]] — the Endo-specific revocation mechanism; structurally distinct from caretaker-style revocation but presupposes the object-capability model.
- [[cohort-destruction]] — partition response that depends on Model 4's dynamic subject creation (Property B).
- [[pass-invariant-handle-equality]] — Endo-side enforcement of Property A (No Designation Without Authority) at the Handle layer.
- [[distributed-confinement]] — confinement is achievable *only* in the Model-4 object-capability model; the *Confinement Myth* is the canonical proof that Models 2 and 3 cannot confine while Model 4 can.
- [[eventual-send]] — the capability-safe operation over a Model-4 reference: the only thing you can do with a reference is send it messages, and the only way it reaches a new holder is as a message argument.
- [[capability-chain]] — dialog-db's typed-Rust realization of attenuated object-capability delegation (`Subject → Attenuation → Policy → Effect` ability paths), serializable to offline UCAN tokens.

## Common confusions

- **"POSIX capabilities are an object-capability system."** No — POSIX 1003.1e capabilities are roughly capabilities-as-rows (Model 2) without Property G (dynamic resource creation). They lack composability and access-controlled delegation. They are a different thing that unfortunately shares a name; see [four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) for the property comparison.
- **"Capability = unforgeable bit string."** Holds only for *password capability* systems (Amoeba-style). Object capabilities are unforgeable because the runtime / kernel mediates them; the bit pattern in the C-list is not readable as data. This distinction matters for confinement; see [confinement-myth](../sections/papers--miller-capability-myths-demolished-2003--confinement-myth.md).
- **"Object-capability and capability-based security are different things."** They are the same thing in current practice. The term *object-capability* is preferred when one wants to be precise about *which* capability model (to distinguish from Models 1, 2, 3); plain *capability* in modern usage usually means Model 4.
