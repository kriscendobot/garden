---
source_kind: paper
source_authors: [Mark S. Miller, Ka-Ping Yee, Jonathan Shapiro]
source_title: Capability Myths Demolished
source_year: 2003
source_venue: Johns Hopkins University Systems Research Laboratory Technical Report SRL2003-02
source_url: https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf
source_pdf_sha256: b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42
source_pdf_pages: 15
source_mirror_url: https://papers.agoric.com/assets/pdf/papers/capability-myths-demolished.pdf
ingested: 2026-05-15
ingested_by: scholar
section_count: 6
status: current
---

A 2003 JHU SRL technical report by Mark S. Miller, Ka-Ping Yee, and Jonathan Shapiro that confronts three then-widely-circulated misconceptions about capability-based security: the **Equivalence Myth** (ACL systems and capability systems are formally equivalent), the **Confinement Myth** (capability systems cannot enforce confinement), and the **Irrevocability Myth** (capability-based access cannot be revoked). The paper names four distinct capability models (Model 1: ACLs as columns; Model 2: capabilities as rows; Model 3: capabilities as keys; Model 4: object capabilities) and a vocabulary of seven security properties (A: No Designation Without Authority; B: Dynamic Subject Creation; C: Subject-Aggregated Authority Management; D: No Ambient Authority; E: Composability of Authorities; F: Access-Controlled Delegation Channels; G: Dynamic Resource Creation). Models 2 and 3 are intermediate misconceptions; the paper argues the "true" capability model is **object capabilities** (Model 4), under which all three myths fail. The two practical advantages the property vocabulary lets the authors articulate are **least-privilege operation** (requires Properties B and G) and **avoiding confused-deputy problems** (Properties A and D together produce *unconfusable deputies*). This is the canonical reference for the object-capability framing that underpins Endo's eventual-send, the Endo daemon's revocation-by-withdrawal mechanism, and the principle-of-least-authority discipline running through `agoric-sdk` orchestration flows.

The paper is short (~15 PDF pages, two-column journal layout, ~9,800 words of prose) and reads as the canonical citation when an Endo design needs to ground a capability-security claim in an upstream argument rather than restate it. Several library concepts already indexed trace directly to specific arguments in this paper:

- `cohort-destruction` and `revocation-by-withdrawal` build on the **forwarder/revoker** pattern (Property F + composability) described under *The Irrevocability Myth* (Section: irrevocability-myth).
- `pass-invariant-handle-equality` and the broader Endo `Handle` discipline build on Property A (*No Designation Without Authority*) (Section: equivalence-myth).
- `caretaker-pattern` is the broader name in the Endo lineage for the same forwarder/revoker decomposition; this paper is the *origin* citation (Section: irrevocability-myth + Section: four-models-and-seven-properties).
- Property D (*No Ambient Authority*) is the formal name for what Endo agents enforce by making all power-bearing references arrive via explicit parameter rather than from a sandbox global (Section: advantages-pola-confused-deputy).

The paper's vocabulary is in the **E vat-language** lineage: terms like *subject* and *resource* read naturally to capability-security veterans but may need translation for readers coming from Endo's exo / E() / formula-graph surface. Per-section *Translation* blocks bridge the idiom where the paper's argument structure intersects an Endo concept the library already names.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [abstract-and-introduction](../sections/papers--miller-capability-myths-demolished-2003--abstract-and-introduction.md) | capability-security, capability-theory | current |
| [equivalence-myth](../sections/papers--miller-capability-myths-demolished-2003--equivalence-myth.md) | capability-security, capability-theory | current |
| [confinement-myth](../sections/papers--miller-capability-myths-demolished-2003--confinement-myth.md) | capability-security, capability-theory | current |
| [irrevocability-myth](../sections/papers--miller-capability-myths-demolished-2003--irrevocability-myth.md) | capability-security, capability-theory, patterns | current |
| [four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) | capability-security, capability-theory | current |
| [advantages-pola-confused-deputy](../sections/papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy.md) | capability-security, capability-theory, patterns | current |

## Acknowledged contributors

The acknowledgements section names "Darius Bacon, Sue Butler, Tyler Close, Hal Finney, Bill Frantz, Norm Hardy, Chris Hibbert, Alan Karp, Ben Laurie, Terry Stanley, Marc Stiegler, E. Dean Tribble, Bill Tulloh, and Zooko" — a roll-call of capability-security practitioners whose names recur across the Endo / Agoric / OCapN literature.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) at SHA-256 `b6a3e04e60d7`.
