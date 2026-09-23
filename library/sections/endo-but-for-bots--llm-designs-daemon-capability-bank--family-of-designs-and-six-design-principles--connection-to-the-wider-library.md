---
title: Connection to the wider library
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

This section is the **canonical *meta-design-for-a-family-of-designs* worked example**. Four threads:

1. **The family-of-designs meta-structure** — instead of one monolithic design, a *category table* names nine sibling designs that share a discipline. The meta-design establishes principles; per-category designs implement them. Reusable for any *related-but-distinct designs* that share common architecture.

2. **The capabilities-are-objects-not-configurations canonical distinction** — the §rationale for *why ocap is structurally different from ACL*. The guest *literally cannot name* the resource; the rejection is structural, not behavioral. This is *the* foundational ocap claim, articulated as a design principle.

3. **The OWASP-coverage matrix shape** — the *threat-by-defending-capability* table is the canonical *security-design-coverage* shape. Each row makes the claim *which capability addresses this threat in what way* explicit. Reusable for any design that addresses a *standard threat-classification*.

4. **The defense-in-depth-deny-patterns-are-optional layering** — denylists as *secondary safety net for mistakes in capability granting*, not primary confinement. The §discipline keeps the primary mechanism *structural-not-behavioral* while allowing for *belt-and-suspenders* error catching.

The §sister-design-pointers — this design names two existing drafts (`daemon-capability-filesystem` and `daemon-capability-persona`); the library has ingested `daemon-capability-persona` extensively. The §family-overview here is the *parent context* for those per-category designs.

The §cross-cycle complement: cycle 101's `daemon-commands-as-messages` named `daemon-capability-bank` as the *audit-trail beneficiary* (commands-as-messages would give the bank a built-in observability surface). Cycle 103's `daemon-value-message` named it as *future capability-grant-delivery mechanism*. Cycle 105 (this ingest) is the *bank itself*, completing the design-graph triangle.
