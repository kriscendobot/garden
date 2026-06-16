---
title: Abstract
source: "The Structure of Authority: Why Security Is Not a Separable Concern (MOZ 2004, LNAI 3389)"
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_paper_pages: "1-6 (§1 Excess Authority, §1.1 How Much Authority Is Adequate, §2 Composing Complex Systems, §2.1 Object-Capability Model)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation
---

§1 names the problem the paper sets out to solve: **excess authority is the gateway to abuse**. Every program a typical user launches inherits the user's full authority — Solitaire can read your email, install backdoors, and delete arbitrary files, regardless of whether Solitaire is itself malicious or merely buggy and exploitable. Conventional approaches to this — running programs as applets (no authority, unusable), or static sandboxing via policy files — fall short because *the right amount of authority changes dynamically as a program executes*; only the act of designation itself reveals what authority is actually needed. §1.1 sharpens this with the canonical cp-versus-cat comparison: `cp foo.txt bar.txt` passes filenames as strings, forcing cp to need authority over *the entire filesystem* before it can open the files it was asked to copy; `cat < foo.txt > bar.txt` passes pre-opened file descriptors, so cat needs authority *only over the specific files passed in*. Both perform the same task; their least-authority differs by orders of magnitude. This is not a security accident — it is a *logical consequence* of which entity does the designation. §2 generalizes the lesson: in a programming language, *designation* (which references an object holds) and *authority* (what an object can affect) can be the same act — an object's permissions just are the references it holds. The object-capability model is the natural alignment: a reference indivisibly combines the designation of a particular object, the means to access it, and the right to access it. §2.1 closes by claiming that the object-capability model does *not* treat access control as a separable concern; rather it is **a model of modular computation with no separate access control mechanisms**. POLA (the Principle of Least Authority) is the *discipline* of taking advantage of this alignment to grant authority on a need-to-do basis, just as good modular practice grants information on a need-to-know basis.
