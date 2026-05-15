---
title: Abstract and Introduction
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

The three myths the paper addresses, and the framing it adopts to dismantle them:

1. **The Equivalence Myth.** "Access control list systems and capability systems are formally equivalent." This myth "obscures the benefits of capabilities as compared to access control lists."
2. **The Confinement Myth.** "Capability systems cannot enforce confinement."
3. **The Irrevocability Myth.** "Capability-based access cannot be revoked."

The paper's claim: "the Confinement Myth and the Irrevocability Myth lead people to see problems with capabilities that do not actually exist." To dispel them, the authors "examine three different models that have been used to describe capabilities, and define a set of seven security properties that capture the distinctions among them." Their argument concludes that "pure capability systems have significant advantages over access control list systems: capabilities provide much better support for least-privilege operation and for avoiding confused deputy problems."

## Introduction

The paper situates its work as a corrective to a chain of papers over the preceding 20 years (citations [2], [3], [7], [24] in the original) that propagated the second and third myths "despite formal results [22] and practical systems [1, 9, 18, 21] demonstrating that they can do these supposedly impossible things." The authors identify the root cause as terminological: "the term *capability* has come to be portrayed as referring to several very different security models." The paper distinguishes them by name:

- **Model 1: ACLs as Columns** — the column-wise reading of Lampson's access matrix.
- **Model 2: Capabilities as Rows** — the row-wise reading of the same matrix.
- **Model 3: Capabilities as Keys** — the "unforgeable copyable keys" analogy.
- **Model 4: Object Capabilities** — the model most actual capability systems implement (KeyKOS, EROS, E, etc.).

The Equivalence Myth is refuted by showing Models 1 and 2 are distinguishable along *dynamic* properties of authority (the access matrix is a static snapshot; the rules that update it are where the model lives). The Confinement and Irrevocability Myths are refuted by reasoning in the context of Model 4 (the object-capability model), where the standard counter-arguments succeed.

The paper closes by tracing both myths' advantages back to two practical operating concerns: the **principle of least privilege** (citation [20] is Saltzer & Schroeder, 1975) and the **confused deputy problem** (citation [10] is Hardy, 1988). The body of the paper organizes around demonstrating that object-capability systems satisfy the property combinations needed to address these concerns, while ACL systems do not.

## Translation

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| capability | a reference (in Endo: an exo, a Presence, a Handle, a formula identifier — capability is the umbrella term) |
| subject | a holder of a reference; in Endo a compartment, a vat-like bundle, or an agent |
| resource | a capability target; in Endo an exo, a remote object, a stored value |
| authority | the permissions a subject has by virtue of holding a reference; in Endo "the methods you can invoke on a reference" |
| access matrix | the static snapshot of authorities a system holds; Endo's `formulaGraph` is the dynamic analogue, evolving via construction and revocation |
| object | reserved by the paper for OO-language objects (state + behaviour); Endo overloads this term in `passStyle` and exo |

The paper's *capability* corresponds to what later E / Endo writing calls a **reference** (when emphasizing the wire-level value) or an **exo** (when emphasizing the state + methods at the resource end). The paper uses *object* in the OO-language sense; do not confuse with Endo's `passStyle` *object* (a record with own enumerable string-keyed properties).

## Sections that follow

The paper's argument runs:

1. The Equivalence Myth (Section: equivalence-myth) — refuted via Properties A, B, C.
2. The Confinement Myth (Section: confinement-myth) — refuted via the requirement that capability transmission itself requires a capability.
3. The Irrevocability Myth (Section: irrevocability-myth) — refuted via the forwarder/revoker pattern.
4. The four models compared on seven properties (Section: four-models-and-seven-properties) — the summary table.
5. Object-capability advantages (Section: advantages-pola-confused-deputy) — least-privilege operation and confused-deputy avoidance.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 1-2; SHA-256 `b6a3e04e60d7`.
