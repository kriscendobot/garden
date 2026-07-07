The job is complete. Draft PR #629 is open, and the licensing decision is surfaced to both the PR description and the maintainer inbox.

---

## Completion report

**Task:** Translate Mark Miller's "Distributed Confinement" into an Endo docs page on the `endojs/endo-but-for-bots` fork.

**Source identified:** *Distributed Capability Confinement* by Mark S. Miller and Melora Svoboda (an observation of Norm Hardy's), `https://erights.org/elib/capability/dist-confine.html`. Fetched via `fetch-source.sh` (erights.github.io mirror, since erights.org refuses the sandbox); provenance SHA-256 `6d7ed3c3…5718ac` recorded. A short conceptual essay (~1,000 words), not a code-heavy piece.

**What I did:**
- Authored `docs/distributed-confinement.md` — an **original faithful exposition** of the argument (not a verbatim copy), matching the repo's TypeDoc house style (`title/group/category` frontmatter; category **Concepts**).
- Registered it in `typedoc.json` `projectDocuments` (after `message-passing.md`) so it appears in site nav.
- Applied the translation conventions with every substitution flagged inline and in a *Translation notes* table: **Java instances → Hardened JavaScript**, **Pluribus / "comm system" → OCapN**, **E "presence" → OCapN remote presence**. Redrew the source Figure 1 GIF as an **original Mermaid diagram** (the plugin is already enabled). Omitted the source's empty author-placeholder section rather than fabricate it; dropped dead erights links.
- Committed under bot identity, pushed `docs-distributed-confinement` to the fork, opened **draft PR #629**: https://github.com/endojs/endo-but-for-bots/pull/629

**Provenance/licensing surfaced:** The source page dedicates Miller's text to the public domain, but that does not clearly cover co-author **Melora Svoboda's** contribution or the **figure image** — which is why I wrote an original re-exposition and an original diagram. This decision is raised in the PR description **and** sent to the maintainer inbox as a blocker before the PR leaves draft.

**Coordination:** Messaged peer `design-endo-thesis-translation` asking whether a conventions/structure decision has landed (no reply during this run); category and figure-tooling choices are flagged as judgment calls to reconcile if that design differs.

**Follow-ups / open items:**
1. Maintainer must decide on the Svoboda/image licensing question before un-drafting.
2. Reconcile the Concepts category + Mermaid figure choice with `design-endo-thesis-translation` once it lands.
3. `yarn docs` (typedoc) was not run — the monorepo has no installed `node_modules` in the sandbox and a full build is disproportionate for a markdown + one-line JSON change; fork CI should exercise the docs build. JSON validated, frontmatter conforms, internal links resolve.

Scope respected: fork PR only, not ferried upstream.
