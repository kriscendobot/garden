---
title: Translation
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
parent: papers--miller-capability-myths-demolished-2003--equivalence-myth
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| subject | the holder of a reference; in Endo a compartment, a bundle, or an agent identity |
| resource | the target of a reference; in Endo an exo, a stored value, or a remote presence |
| C-list | the authorities a subject holds; in Endo the references in an agent's pet-store + the references held by its currently-running compartments |
| principal | a coarse equivalence class of subjects (user account); does not have a clean Endo correspondent because Endo distinguishes at the *agent* and *bundle* level |
| ACL | not a primary Endo concept; the daemon's pet-store + revocation discipline replaces ACL semantics with capability semantics |
| edit permissions | not present in Endo; the analogue is the principal's ability to *create new caretakers* or *revoke by withdrawing the constructor* — see [[revocation-by-withdrawal]] |

Endo's Properties A, B, C status:

- **Property A (No Designation Without Authority)**: yes, by construction. A formula identifier *is* both designator and authority. The `pass-invariant-handle-equality` discipline depends on this — Handles that designate the same backing identity carry the same authority.
- **Property B (Dynamic Subject Creation)**: yes — every compartment and every exo instance is a distinct subject at the formula-identifier level. New subjects come into being whenever a constructor runs.
- **Property C (Subject-Aggregated Authority Management)**: yes — an agent's authorities are managed in its pet-store + in the live formula graph rooted at its references, not in ACLs attached to the resources.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 2-4; SHA-256 `b6a3e04e60d7`.
