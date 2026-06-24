---
title: Abstract
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

§5.3 introduces the **arena** abstraction. Policies like the *-properties are generally assumed to be enforced *on a system as a whole* by a sys-admin or security officer; in a capability system, this is a matter of *initial conditions*. But once the system is running, an owner who later wants to impose policy faces a problem: Alice meeting Bob, an uncontrolled subject, cannot enforce a policy that *removes* prior rights from Bob — that would violate Bob's security. Instead, Alice sets up an **arena** — Lampson's "controlled environment" — with initial conditions she determines, governed by her rules, over which she is the sys-admin. If her rules can be enforced on uncontrolled subjects, she can admit Bob onto her arena as a player. The discipline is **terms of entry**: "Please leave your cellphones at the door." A prospective participant provides a player (here, `calcFactory`) representing his interests within the arena, where the player can pass the security check at the gate. No rights are taken from anyone; participation is voluntary. The arena technique corresponds to **meta-linguistic abstraction** — an arena is a virtual machine built within a virtual machine [Abelson86, Safra86]. §5.4 — **Mutually suspicious composition** — answers the next natural question: when diverse interests build diverse abstractions to express diverse co-existing policies, how do these extensions interact? Q builds a gizmo + a Caretaker so he can revoke gizmo's access to *his* `diodeWriter`. Q's policy relies on Q's Caretaker. Cassie's policy relies on her `diodeWriter`. *Neither needs to know about the other.* The §5.4 closing observation: "diverse expressions of policy often compose correctly even when none of the interested parties are aware this is happening." §6 closes the paper: **the lost paradigm — abstraction as protection — is restored**. The object-capability model is the only protection model whose semantics can be readily expressed in programming-language terms (approximately, *lambda calculus with local side effects*), providing a common semantic framework for reasoning about permission and program behavior together. The paper's last sentence: *"The object-capability paradigm, with its pervasive, fine-grained, and extensible support for the principle of least authority, enables mutually suspicious interests to cooperate more intimately while being less vulnerable to each other. When more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world."*
