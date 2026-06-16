---
title: The §problem framing that names AI coding agents (Claude Code, Cursor, Devin) as having *dangerous ambient authority* — filesystem / shell / network / git / credentials — and connects to the *OWASP Top 10 for Agentic Applications* (ASI01 Agent Goal Hijack + ASI02 Tool Misuse + ASI03 Identity & Privilege Abuse + ASI05 Unexpected Code Execution) plus the empirical research (Liu et al. AIShellJack 84% attack success rate; IDEsaster 100%-vulnerable AI IDEs); the §family-of-designs structure — the Capability Bank is *not* one design but *nine related designs* (filesystem / process / network / git / env vars / credentials / user-IO / timer / delegates-personas), each its own design document, each its own resource category, each its own threat-addressed; the §OWASP-Top-10-coverage table mapping eight ASI categories to defending capabilities; the §LAL-agent-integration pattern — guest dynamically discovers capabilities in its namespace and registers namespaced tools (e.g., `fs.readText`, `git.status`); the §six Design Principles that make a design *capability-shaped* vs *configuration-shaped*: (1) *capabilities are objects, not configurations* — a guest receives a Directory capability rooted at `/home/user/project`, not a *FileSystem service configured with roots and deny-globs*; (2) *recursive attenuation* — authority narrows by handing out sub-capabilities, not by adding exclude patterns; (3) *caretaker separation* — guest holds File facet, host holds FileControl facet; controller is separate from capability; (4) *defense-in-depth deny patterns are optional* — denylists are a secondary safety net, not the primary confinement mechanism; (5) *LLM discoverability* — every capability exposes `help()` text written for an LLM encountering it cold + maximally-specific `M.interface()` guards; (6) *Existing Endo patterns* — build on the existing directory capability + virtual-filesystem-design sketch + guest/host power model rather than introducing parallel abstractions
source: designs/daemon-capability-bank.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-02-24
source_authors: [Kris Kowal (prompted)]
source_lines: "1-159 (full file)"
topics: [daemon, capability-security]
status: current
notes: |
  Twenty-fourth endo-but-for-bots design ingest. **Status: Not
  Started.** The 159-line design is the *meta-design* for the
  *Capability Bank* — a family of *nine related designs*, one per
  OS-level resource category (filesystem, process, network, git,
  env, credentials, userio, timer, persona). The doc itself is
  small but structurally load-bearing: it establishes the *six
  design principles* that every per-category design in the family
  must follow, and connects the family to the *OWASP Top 10 for
  Agentic Applications* + empirical security research (AIShellJack
  84% attack rate; IDEsaster 100%-vulnerable AI IDEs). Three
  structurally interesting ideas: (1) the *family-of-designs*
  meta-structure — instead of one monolithic design, a *category
  table* names nine sibling designs that share a discipline;
  (2) the *capabilities are objects, not configurations*
  discipline — *a guest receives a Directory rooted at
  /home/user/project — it does not receive a 'FileSystem service
  configured with roots and deny-globs'* (the §canonical-distinction
  between ocap and ACL); (3) the *defense-in-depth deny patterns
  are optional* discipline — denylists are *secondary safety
  net*, not the *primary* confinement; they catch mistakes in
  capability granting, not failures in the capability model.
  
  Pairs structurally with cycle 101's daemon-commands-as-messages
  (which names daemon-capability-bank as an *audit-trail
  beneficiary*) and cycle 103's daemon-value-message (which names
  daemon-capability-bank as *future capability-grant-delivery
  mechanism*). The Capability Bank is the *consumer* of those
  reply-primitive designs. Single-section cohesion-honest ingest
  (like cycles 95, 100, 101, 103, 104).
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--abstract.md)
- [Body](endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles--common-confusions.md)
