---
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/index.html
source_mirror_url: http://www.caplet.com/security/taxonomy/grant-match/grant-matcher.html
source_effective_url: https://erights.github.io/erights-org-website/elib/equality/grant-matcher/index.html
source_fetched_via: mirror
source_content_sha256: d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58
source_authors: [Mark S. Miller]
source_date: 2000-01-01
retrieved: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
section_count: 6
status: current
notes: "Mark Miller's *The Grant Matcher Puzzle*, the root page of the E *equality* taxonomy on erights.org (also mirrored at caplet.com as *Identity Untangled: The Grant Matcher Puzzle*, credited 'by Mark Miller, with many thanks to Norm Hardy and E. Dean Tribble'). Fetched 2026-06-27 from the erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses connections from the sandbox, so the mirror — which serves the original site paths verbatim — is the fetch substitute). The mirror bytes are byte-identical to the prior Internet-Archive `id_` capture (content SHA-256 unchanged), so this is a provenance refresh, not a re-ingest. The page is undated; source_date is an approximation to the E / erights equality-taxonomy era (late 1990s–early 2000s, contemporaneous with the Java facet / Facade-pattern references in the text). Idempotency anchor is `source_content_sha256`, not a git SHA."
---

Mark Miller's *The Grant Matcher Puzzle* is the foundational motivating problem for **object-identity and equality primitives** in pure object-capability systems, and the root page of the E *equality* taxonomy. It poses a concrete scenario — a Grant Matcher that matches two donors' grants to a common charity — that forces two questions a distributed capability system must answer: can a party determine whether two object references designate the *same* object without consulting the objects, and having so determined, can it *reliably transport* value to that destination without being defeated by a capability-layer man-in-the-middle. The page introduces the three rules of capability computation (the third — that the reference Bob receives must be "as good a reference to Carol… as far as Alice is concerned" — being the heart of the puzzle), sets up the Grant Matcher / Alice / Dana / KEQD roles under the principle of least authority, walks the "Alice Gets Greedy" transparent-forwarder attack that defeats a message-only equality protocol, and shows how an address-equality *EQ* primitive resolves it. It is the historical reason a distributed ocap system needs a carefully designed pass-invariant equality primitive and a reliable handoff transport.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--miller-grant-matcher-puzzle--overview.md) | capability-theory, capability-security | current |
| [capability-foundations](../sections/web--miller-grant-matcher-puzzle--capability-foundations.md) | capability-theory, capability-security | current |
| [setting-up-the-puzzle](../sections/web--miller-grant-matcher-puzzle--setting-up-the-puzzle.md) | capability-security, capability-theory | current |
| [when-it-works](../sections/web--miller-grant-matcher-puzzle--when-it-works.md) | capability-theory, marshal | current |
| [alice-gets-greedy](../sections/web--miller-grant-matcher-puzzle--alice-gets-greedy.md) | capability-theory, marshal, captp | current |
| [how-eq-makes-a-difference](../sections/web--miller-grant-matcher-puzzle--how-eq-makes-a-difference.md) | capability-theory, marshal | current |
