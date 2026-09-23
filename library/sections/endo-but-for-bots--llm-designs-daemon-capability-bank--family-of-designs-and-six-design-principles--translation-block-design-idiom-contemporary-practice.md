---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `dangerous ambient authority` | The *no-default-authority* discipline; AI agents start with zero authority and receive specific capabilities. |
| `attack success rates up to 84%` (AIShellJack) | The *evidence-based-threat-framing* discipline; cite empirical attack research, not abstract worries. |
| `family of designs — one per resource category` | The *meta-design-for-related-designs* shape; one design establishes shared principles; sibling designs implement them. |
| `Capabilities are objects, not configurations` | The *structural-vs-behavioral confinement* canonical distinction. |
| `The guest cannot name `~/.ssh` because no method on its `Directory` returns a path to it` | The *cannot-name-the-resource* invariant; ocap's foundational property. |
| `Recursive attenuation. Authority narrows by handing out sub-capabilities, not by adding exclude patterns` | The *narrower-power-via-narrower-capability* idiom. |
| `Caretaker separation. The host can revoke or restrict without the guest's cooperation` | The *two-facet-control-vs-capability* split. |
| `Defense-in-depth deny patterns are optional` | The *primary-structural-secondary-behavioral* two-layer model. |
| `LLM discoverability. Every capability exposes help() text written for an LLM encountering it cold` | The *interface-is-the-documentation-for-the-LLM* discipline. |
| `M.interface() guards with maximally specific shapes` | The *self-documenting-shapes* discipline; named fields + literal enumerations + descriptive tags. |
| `Existing Endo patterns. Designs should build on Endo's existing directory capability` | The *don't-reinvent-existing-shapes* discipline. |
| OWASP-coverage matrix (8 rows × N defending capabilities) | The *threat-model-coverage* table shape. |
