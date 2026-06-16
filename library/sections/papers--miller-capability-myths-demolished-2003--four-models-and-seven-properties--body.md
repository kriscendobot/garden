---
title: Body
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
parent: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties
---

### The capabilities-as-keys model (Model 3)

The paper introduces Model 3 with the analogy "capabilities are like copyable, unforgeable keys (or copyable, unforgeable tickets) in the real world." The key analogy is widely used in informal capability writing, but the paper shows it diverges from object capabilities in two specific ways.

**Keys vs Rows: Ambient Authority.** In the keys model, exercising an authority requires *selecting* a key — picking it from the keyring, fitting it to a lock. In the row model (and in actual ACL systems via `chmod`-style invocations like `open(filename)`), the user does not select an authority; the system uses whatever authority applies. The paper coins the term **ambient authority**: "authority that is exercised, but not selected, by its user." Unix filesystem permissions are the canonical example: `open("/etc/passwd")` does not require the caller to choose a credential; the call merely succeeds or fails. The paper formalizes the absence of this as **Property D: No Ambient Authority** — "must subjects select which authority to use when performing an access?"

**Keys vs Objects: Composability of Authorities.** In the keys model, subjects (key holders) and resources (locks) are distinct type categories. A key is not a lock; a lock is not a key. Authorization (giving someone a key) and access (using a key) are therefore distinct operations on values of distinct types. In the object-capability model, "every subject is a resource, and every resource is conceptually a subject. ... Consequently, access and authorization can be unified." The paper formalizes this as **Property E: Composability of Authorities** — "are resources also subjects?" Composability is what makes the forwarder/revoker construction possible (see Section: irrevocability-myth): the forwarder F is simultaneously a resource (Bob sends to it) and a subject (it sends to Carol).

**Keys vs Objects: Access-Controlled Delegation Channels.** In the keys model, "subjects authorize subjects (the wide arrow on the left), whereas subjects access resources (the wide arrow carrying the operation name *read*), and these are two distinct kinds of action." But in the object-capability model, *delegating a capability to Bob is itself a message-send to Bob*, and that send requires a capability from Alice to Bob. The paper formalizes this as **Property F: Access-Controlled Delegation Channels** — "is an access relationship between two subjects X and Y required in order for X to pass an authority to Y?"

### The seven properties

The paper's Figure 13 (mid-paper, summarizing the model comparison) and Figure 15 (end-of-paper, extending to real-world systems) tabulate the seven properties:

| Property | Test | M1 ACL | M2 row | M3 key | M4 object |
|---|---|---|---|---|---|
| **A** No Designation Without Authority | Does designating a resource always convey its authority? | no | unspecified | no | yes |
| **B** Dynamic Subject Creation | Can subjects dynamically create new subjects? | no (in practice) | yes (in practice) | yes | yes |
| **C** Subject-Aggregated Authority Management | Is the power to edit authorities aggregated by subject? | no (in practice) | yes (in practice) | yes | yes |
| **D** No Ambient Authority | Must subjects select which authority to use? | no | no | yes | yes |
| **E** Composability of Authorities | Are resources also subjects? | unspecified | unspecified | no | yes |
| **F** Access-Controlled Delegation Channels | Is X→Y access required for X to pass an authority to Y? | unspecified | unspecified | no | yes |
| **G** Dynamic Resource Creation | Can resources be created and destroyed dynamically? | yes | yes | no | yes |

Property G is named only in the systems-in-practice section, where the paper observes that the POSIX 1003.1e "POSIX capabilities" mechanism — sometimes cited as a capability system — actually fits the capabilities-as-rows model in most respects but **lacks Property G** because the set of POSIX capability flags is finite and fixed.

### The myth consequences

Figure 15's bottom rows derive consequence summaries from the property scores:

- **Irrevocability Myth** is true for systems that hold Property B but not Property E. Model 2 (capabilities-as-rows), Model 3 (capabilities-as-keys), POSIX capabilities, and SPKI all fall in this region — they have Dynamic Subject Creation but lack Composability, so the forwarder/revoker construction is unavailable.
- **Delegation Myth** (capabilities propagate ungoverned) is true for systems that hold B but not F. Again Models 2, 3, and SPKI; the paper marks POSIX capabilities as "unclear" because POSIX-1003.1e doesn't fully specify the delegation channel.
- **Confused Deputy Problems** the paper marks danger (red) for ACL and Model 1 / Model 2; *better* for Model 3 / SPKI; *best* for Model 4 / object capabilities.
- **Least Privilege Operation** is *infeasible* without B and G together — so neither plain Unix filesystem (no B) nor POSIX capabilities (no G) can support least privilege; everything to their right can.

### Why Models 2 and 3 exist

The paper's diagnosis of where the myths come from: people teach capability systems via the *capabilities-as-rows* visualization (Model 2) or the *capabilities-as-keys* metaphor (Model 3). Both are pedagogically convenient but lack Property E (composability) and Property F (access-controlled delegation). Reasoning from Model 2 or Model 3 produces correct-but-irrelevant conclusions: yes, *in those models*, revocation is hard and confinement is hard. But Model 4 — the model that actual implemented capability systems (KeyKOS, EROS, E) realize — is not those models.

> Our story... shows that the Confinement Myth and the Irrevocability Myth both contain true statements within such a model, so we believe this model is a likely contributor to the propagation of these myths.

The paper's broader contribution is therefore as much pedagogical as theoretical: by giving the four models distinct names and the seven properties a vocabulary, it lets future authors say "the system you are describing is Model 3, not Model 4; the Irrevocability Myth applies to Model 3 because it lacks Property E; my system is Model 4 and the myth does not apply."

### Systems-in-practice tour

The closing comparison tabulates eight real systems / mechanisms against the seven properties:

- **Unix filesystems, Unix with `setfacl`, NT ACL** — pure Model 1. All seven properties fail or hold only as ACL-defining-rule trivia. Confused deputy danger; least privilege infeasible.
- **POSIX capabilities (1003.1e)** — capabilities-as-rows in shape; lacks G (dynamic resource creation). Cannot support least privilege.
- **SPKI** — capabilities-as-keys in shape. Has B, C, D, G; lacks A (designators are not bound to authorities in transit), E (no composability), F (delegation channel not access-controlled). Confined-deputy *better* than ACL but not *best*.
- **Unix file descriptors** — close to object capabilities but limited; pipes give some composability but not full Model 4 expressiveness.
- **Pure capability systems** (KeyKOS, EROS, E, etc.) — Model 4 in full. All seven properties hold. Best on every consequence.

The paper closes the systems tour with: "A large number of capability systems in the history of security research have all seven of the security properties we have mentioned, and thus fit Model 4."

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 8-11 (Figures 13, 15); SHA-256 `b6a3e04e60d7`.
