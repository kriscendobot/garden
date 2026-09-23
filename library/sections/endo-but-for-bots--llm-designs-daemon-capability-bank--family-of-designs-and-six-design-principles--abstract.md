---
title: Abstract
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

The §opening Problem block (lines 10-42) names AI coding agents (Claude Code, Cursor, Devin) as having *dangerous ambient authority* — filesystem, shell, network, git, credentials — that enables *data exfiltration, persistence, credential theft, and lateral movement*. The §threat framing cites the *OWASP Top 10 for Agentic Applications* [1] identifying *prompt injection leading to tool misuse* (ASI01 Agent Goal Hijack, ASI02 Tool Misuse & Exploitation), *overly broad tool permissions* (ASI03 Identity & Privilege Abuse), and *unexpected code execution* (ASI05) as primary attack surfaces. The §empirical evidence: Liu et al.'s *AIShellJack* framework demonstrated *attack success rates up to 84% against agentic coding editors* [2]; the *IDEsaster* vulnerability class found *100% of tested AI IDEs were vulnerable to prompt-injection-to-tool-abuse chains* [3]. The §solution framing names Endo's *object-capability model* [4] as well-suited: *guests default to zero authority (least-authority formula), capabilities are unforgeable references, and `makeExo() + M.interface()` guards enforce method-level contracts* [5]. The §gap: *Endo currently lacks a standard vocabulary of OS-level capabilities that plugins can grant and attenuate*. The LAL agent (`packages/lal/agent.js`) already operates as a guest with 26 tools for directory operations, mail, and eval proposals — but *none of these mediate host OS resources*. The §Capability Bank is therefore a *family of designs — one per resource category*. The §Capability Categories table (lines 49-59) names nine sibling designs: **Filesystem** (`daemon-capability-filesystem.md`, Draft), **Process execution** (Planned), **Network** (Planned), **Git operations** (Planned), **Environment variables** (Planned), **Credential store** (Planned), **User I/O** (Planned), **Timer / scheduling** (Planned), **Delegates / epithets** (`daemon-capability-persona.md`, Draft). The §Cross-cutting concerns (lines 61-66) name a *composition layer* — *bundle attenuated capabilities into named profiles for common roles (read-only developer, CI runner, data analyst, etc.)* — *deferred until the individual capability shapes are settled*. The §OWASP Agentic Top 10 coverage table (lines 68-79) maps eight ASI categories to *defending capabilities* (ASI01: all — interface guards reject structurally invalid calls regardless of LLM intent; ASI02: filesystem root confinement + process command allowlist + network host allowlist; ASI03: all — maker pattern restricts creation to HOST; ASI05: process command/argument guards + filesystem write confinement; ASI06: git hook denial prevents persistent instruction injection; ASI08: network rate limits + process concurrency limits + timer max-concurrent; ASI09: user-IO prompt controls + persona mandatory AI disclosure; ASI10: timer recurring denial + network C2 prevention + git push restrictions). The §LAL agent integration (lines 81-87) names the pattern: *the LAL agent can dynamically discover capabilities in its namespace and register namespaced tools* (e.g., `fs.readText`, `git.status`). The §Design Principles (lines 89-122) name six structurally important rules that every per-category design in the family must follow: (1) *Capabilities are objects, not configurations*; (2) *Recursive attenuation*; (3) *Caretaker separation*; (4) *Defense-in-depth deny patterns are optional*; (5) *LLM discoverability*; (6) *Existing Endo patterns*. The §References (lines 124-159) cite eight sources: OWASP Agentic Top 10, AIShellJack paper, IDEsaster covered in The Hacker News, Miller's *Object-Capability Model* / *Robust Composition*, Endo Hardened JavaScript documentation, OWASP Agentic Security Initiative, OWASP Agentic AI Threats and Mitigations v1.0.1, and OWASP Top 10 for LLM Applications 2025.
