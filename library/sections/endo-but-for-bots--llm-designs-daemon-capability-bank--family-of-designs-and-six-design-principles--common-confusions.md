---
title: Common confusions
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
parent: endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles
---

- **"`Daemon Capability Bank` is a single design — why is it called a family?"** It is *not a single design*. The §Capability Categories table names *nine* sibling design documents, each a separate file with its own implementation. The doc *here* is the *meta-design* that establishes shared principles; per-category designs implement them.
- **"Not Started means nothing has been done."** The meta-design itself is *written*; two per-category designs are *Draft* (Filesystem, Persona); seven are *Planned*. *Not Started* in the table header reflects that *no implementation has begun* — the design phase is partial; the implementation phase hasn't started.
- **"Denylists are essential — `~/.ssh` must always be denied."** The §discipline rejects this framing. A capability-shaped design *literally cannot name `~/.ssh`* because the capability is rooted elsewhere. Denylists exist as a *safety net* for capability-granting mistakes, not as the primary confinement.
- **"`help()` text is just documentation."** It is *executable documentation for an LLM*. The §discipline: the LLM reads `help()` at runtime to learn how to use the capability. The text *is the spec* the LLM consults — no separate doc.
- **"`M.interface()` guards are runtime checks; they don't help with LLM correctness."** They do — the guard *rejects structurally invalid calls before any handler runs*. A capability with a strict interface guard *cannot be misused* in ways the guard catches. The §discipline: *the more specific the shape, the more the LLM's correctness is enforced by the guard*.
- **"The OWASP coverage table is just claims — the design hasn't verified them."** The table is *the design's claim about what threats it addresses*. Implementation verification is per-category; the meta-design is the *coverage map* that lets a reader audit *which threats are addressed*.
- **"The 6 Design Principles overlap — recursive attenuation and structural confinement say the same thing."** They name *distinct aspects*. Recursive attenuation is about *narrowing-by-sub-capability*; structural confinement is about *unnameable-out-of-scope-resources*. They're consistent but not identical.
- **"AIShellJack 84% attack rate is just one paper's claim."** The design cites it alongside *IDEsaster's 100%-vulnerable claim* and the *OWASP Top 10*. The §discipline is *multiple-source-corroborated-evidence*, not single-paper reliance.
- **"`Capabilities are objects, not configurations` is just rhetoric."** It is *the canonical ocap-vs-ACL distinction* expressed as a design principle. A FileSystem-service-with-config is configurable; a Directory-capability-rooted-at-path is structural. The §distinction is operationalizable: *can the guest name resources outside its scope? If yes, configuration; if no, capability.*
- **"`Existing Endo patterns` (principle 6) is just an implementation note."** It is the §don't-reinvent-parallel-abstractions discipline. Each category could invent its own *capability shape*; reusing the directory shape across categories lets LLMs transfer learning across categories (a model that knows how to use a filesystem Directory can use a git Directory or a credential Directory).
