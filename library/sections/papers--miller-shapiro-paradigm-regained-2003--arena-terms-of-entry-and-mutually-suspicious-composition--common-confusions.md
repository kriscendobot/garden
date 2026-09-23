---
title: Common confusions
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
parent: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition
---

- **"The arena is a sandbox."** Sandboxes are typically *all-or-nothing*: code is either inside the sandbox (subject to its rules) or outside. The §5.3 arena allows uncontrolled subjects in as *devices* with "mysterious connections to the arena's external world" — explicitly modeling the gap rather than refusing to admit external code at all. Endo's bundle-loading allows non-SES code in as a guest module with a curated endowment; the device framing is the right model.
- **"Mutually suspicious composition requires central coordination."** §5.4 explicitly argues the opposite: Cassie does not know about Q's Caretaker; Q does not know about Cassie's other arrangements. Each party's analysis is strict-over-its-own-behavior, conservative-over-everything-else. The composition is correct *without* central coordination.
- **"The lost paradigm is just `protection = encapsulation`."** §6 makes a more specific claim: *protection by abstraction* is a lost paradigm because the formal security literature for 30 years (1973-2003) reasoned about protection state in isolation from program behavior. The lost paradigm is the recognition that *program behavior contributes to protection* — that an abstraction's *enforcement* is part of the protection model.
- **"Failures of conservatism are bugs in the verifier."** They are bugs in the *verification model*, not in the verifier implementation. A verification model that ignores behavior cannot conclude that a Caretaker enforces revocation; the model is *systematically biased toward unsafe*. The fix is enriching the model, not patching the verifier.
- **"The arena and terms of entry are just a metaphor."** They are a metaphor *and* an architecture. Each Endo bundle's compartment-construction step IS the terms-of-entry checkpoint. The metaphor is operationally concrete.
