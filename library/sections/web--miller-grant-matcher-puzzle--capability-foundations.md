---
title: "Capability Foundations: the three rules, and the third as the heart of the puzzle"
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/index.html
source_content_sha256: d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

The fundamental step of capability computation, stated as three rules over three objects — Alice, Bob, and Carol — where initially Alice holds a capability to both Bob and Carol and the other two hold none. The first rule grounds *discretionary* security (Alice voluntarily passes access), the second grounds *mandatory* security and confinement (capabilities travel only on paths existing capabilities provide), and the **third rule is the heart of the Grant Matcher Puzzle**: the access to Carol that Bob receives must be **as good a reference to Carol as the reference Alice passed, as far as Alice is concerned** — "the 'Carol' that Bob gets must be the 'Carol' that Alice meant."

Shown here is the fundamental step of capability computation. Alice, Bob, and Carol are three separate objects. In the initial conditions Alice holds an object reference — or *capability* — to both Bob and Carol, and neither hold a capability to the other two.

- **The first rule of capabilities** is that one object, here Bob, can only get access to another object, here Carol, if the first creates the second (not shown), or if someone — here, Alice — who validly has access to Carol voluntarily passes a copy of this access to Bob. In order for Alice to give Bob access to Carol, Alice must already have access to Carol, and Alice must choose to give out this access. By *voluntary* we mean: were a different program substituted for Alice but placed in the same exact external environment, that program would be able to choose not to give access to Carol. This is the basis for **discretionary security** in capability systems.

- **The second rule** is that capabilities may only travel on paths provided by existing capabilities. In order for Alice to give Bob access to Carol, Alice also requires access to Bob. Even if Alice is coded to attempt to give this access to Bob, she cannot if there is no capability pathway of willing intermediaries leading from Alice to Bob. This is the basis for **mandatory security** in capability systems, especially *confinement*.

- **The third rule** is that the access to Carol that Bob gets must be *as good a reference to Carol as the reference Alice passed, as far as Alice is concerned*. The "Carol" that Bob gets must be the "Carol" that Alice meant.

The subtleties in making this last issue precise are the heart of the Grant Matcher Puzzle. *Matching Distributed Grants* explains how to avoid the capability equivalent of a **man-in-the-middle attack**, otherwise a danger in a distributed cryptographic capability system.

Source: [The Grant Matcher Puzzle](https://erights.org/elib/equality/grant-matcher/index.html) § Capability Foundations, Mark S. Miller, erights.org; fetched 2026-06-27 via the erights.github.io GitHub Pages mirror, content SHA-256 `d25136c9` (byte-identical to the prior Internet-Archive capture).
