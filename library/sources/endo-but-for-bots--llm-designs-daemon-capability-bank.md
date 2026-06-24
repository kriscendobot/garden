---
source: designs/daemon-capability-bank.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-02-24
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-fourth endo-but-for-bots design ingest. **Status: Not
  Started.** The 159-line design is the *meta-design* for the
  *Capability Bank* — a family of *nine related per-category
  designs* (filesystem, process, network, git, env, credentials,
  userio, timer, persona) one per OS-level resource category.
  The doc is small but structurally load-bearing: it establishes
  the *six design principles* that every per-category design in
  the family must follow, and connects the family to the *OWASP
  Top 10 for Agentic Applications* + empirical security research
  (AIShellJack 84% attack rate; IDEsaster 100%-vulnerable AI IDEs).
  Three structurally interesting ideas: (1) the *family-of-designs*
  meta-structure — instead of one monolithic design, a *category
  table* names nine sibling designs that share a discipline;
  (2) the *capabilities are objects, not configurations*
  discipline — *a guest receives a Directory rooted at
  /home/user/project — it does not receive a 'FileSystem service
  configured with roots and deny-globs'* (the canonical
  distinction between ocap and ACL — *the guest cannot name
  `~/.ssh` because no method on its `Directory` returns a path
  to it*); (3) the *defense-in-depth deny patterns are optional*
  layering — denylists are *secondary safety net* for capability-
  granting mistakes, not the *primary structural* confinement.
  
  Pairs structurally with cycle 101's daemon-commands-as-messages
  (which names this design as an *audit-trail beneficiary*) and
  cycle 103's daemon-value-message (which names this design as
  *future capability-grant-delivery mechanism*). The Capability
  Bank is the *consumer* of those reply-primitive designs. Single-
  section cohesion-honest ingest.
  
  Topic-classification note: this is the first daemon source in
  the library that I tag with `capability-security` alongside
  `daemon` because the design's load-bearing content is the
  *ocap-vs-ACL canonical distinction* + six capability-discipline
  principles, which sits more centrally in the capability-security
  topic than the typical daemon-design.
---

> Abstract: `designs/daemon-capability-bank.md` is the meta-design
> for the *Capability Bank* — a family of nine sibling designs,
> one per OS-level resource category (filesystem, process,
> network, git, environment variables, credentials, user I/O,
> timer, delegates/personas). The opening *Problem* names AI
> coding agents (Claude Code, Cursor, Devin) as having
> *dangerous ambient authority* and cites the *OWASP Top 10 for
> Agentic Applications* (ASI01 Goal Hijack + ASI02 Tool Misuse +
> ASI03 Identity Abuse + ASI05 Unexpected Code Execution) plus
> empirical attack research (Liu et al. AIShellJack *84% attack
> success rate*; IDEsaster *100% of tested AI IDEs vulnerable*).
> The §Endo-as-solution gap-naming: Endo has the substrate
> (zero-default-authority + unforgeable references + interface
> guards) but lacks the OS-level capability vocabulary. The
> §Capability Categories table names nine sibling design
> documents with status (Filesystem and Persona are Draft; the
> rest Planned) and threat-addressed. The §OWASP-Top-10 coverage
> table maps eight ASI categories to defending capabilities. The
> §LAL agent integration sketches dynamic discovery + namespaced
> tool registration. The §six Design Principles define what makes
> a design *capability-shaped* vs *configuration-shaped*: (1)
> *Capabilities are objects, not configurations* — the canonical
> ocap-vs-ACL distinction; (2) *Recursive attenuation* — narrow
> by sub-capability, not exclude-pattern; (3) *Caretaker
> separation* — guest holds the capability, host holds the
> control facet; (4) *Defense-in-depth deny patterns are
> optional* — denylists are a secondary safety net for granting
> mistakes; (5) *LLM discoverability* — every capability exposes
> `help()` text written for an LLM cold + maximally-specific
> `M.interface()` guards; (6) *Existing Endo patterns* — reuse
> the directory capability shape, don't introduce parallel
> abstractions. The §References cite eight sources spanning OWASP
> standards, AIShellJack arXiv paper, IDEsaster, Miller's
> *Robust Composition* PhD, Endo SES documentation, and OWASP
> Agentic Security Initiative.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [family-of-designs-and-six-design-principles](../sections/endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles.md) | daemon, capability-security | current |

The 159-line file is honestly one cohesive argument-cluster — the *meta-design* for a family of nine sibling designs, with shared problem-framing, category enumeration, OWASP coverage, integration sketch, six design principles, and references. Single-section ingest preserves the document's unified structure; the apparent six-subsection decomposition (Problem / Categories / Cross-cutting / OWASP / LAL / Principles / References) is one coherent argument with retrospective tables and citations.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-02-24 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 159 lines.
- **Twenty-fourth endo-but-for-bots design ingest**. Pairs structurally with cycle 101's `daemon-commands-as-messages` (which names this design as an *audit-trail beneficiary*) and cycle 103's `daemon-value-message` (which names this design as *future capability-grant-delivery mechanism*).
- The library has already ingested one of the two Draft designs named in the §Capability Categories table — `daemon-capability-persona` (the *Delegates / epithets* category) — via earlier cycles' ingests. The §family-overview here is the *parent context* for those per-category designs.
- Cycle 105 was scheduled for chat-lane but chat-cluster is exhausted; pivoted to daemon-design-lane (following cycles 101 and 103's precedent).
- Single-section cohesion-honest count. The 159-line file is *one meta-design* with shared principles for a family of nine sibling designs. Forcing a multi-section split would create artificial divisions between the problem-narrative and the six-principle framework that addresses it.
