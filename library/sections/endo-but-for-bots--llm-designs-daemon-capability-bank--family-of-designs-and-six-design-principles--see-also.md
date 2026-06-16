---
title: See also
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

- [[daemon]] (topic) — the endo daemon architecture; the Capability Bank extends the daemon's capability mechanism to OS-level resources.
- [[capability-security]] (topic) — the canonical capability-discipline this design family embodies.
- `endo-but-for-bots--llm-designs-daemon-capability-persona--*` (already ingested) — one of the two Drafts in the §Capability Categories table; the *Delegates / epithets* design that addresses ASI09 Human-Agent Trust Exploitation via mandatory AI disclosure.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — names *daemon-capability-bank* as an *audit-trail beneficiary*; commands-as-messages gives the bank a built-in observability surface.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — names *daemon-capability-bank* as *future capability-grant-delivery mechanism*; value messages could carry capability grants.
- `papers--miller-capability-myths-demolished-2003--*` — Miller's foundational *capability-security-vs-ACL* arguments; cited [4] is Miller's *Robust Composition* PhD which expands these arguments.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--*` — the eventual-send/vat model that the Endo daemon implements; the runtime substrate this design family runs on.
