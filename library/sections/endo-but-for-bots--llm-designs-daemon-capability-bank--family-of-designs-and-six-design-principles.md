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
---

## Abstract

The §opening Problem block (lines 10-42) names AI coding agents (Claude Code, Cursor, Devin) as having *dangerous ambient authority* — filesystem, shell, network, git, credentials — that enables *data exfiltration, persistence, credential theft, and lateral movement*. The §threat framing cites the *OWASP Top 10 for Agentic Applications* [1] identifying *prompt injection leading to tool misuse* (ASI01 Agent Goal Hijack, ASI02 Tool Misuse & Exploitation), *overly broad tool permissions* (ASI03 Identity & Privilege Abuse), and *unexpected code execution* (ASI05) as primary attack surfaces. The §empirical evidence: Liu et al.'s *AIShellJack* framework demonstrated *attack success rates up to 84% against agentic coding editors* [2]; the *IDEsaster* vulnerability class found *100% of tested AI IDEs were vulnerable to prompt-injection-to-tool-abuse chains* [3]. The §solution framing names Endo's *object-capability model* [4] as well-suited: *guests default to zero authority (least-authority formula), capabilities are unforgeable references, and `makeExo() + M.interface()` guards enforce method-level contracts* [5]. The §gap: *Endo currently lacks a standard vocabulary of OS-level capabilities that plugins can grant and attenuate*. The LAL agent (`packages/lal/agent.js`) already operates as a guest with 26 tools for directory operations, mail, and eval proposals — but *none of these mediate host OS resources*. The §Capability Bank is therefore a *family of designs — one per resource category*. The §Capability Categories table (lines 49-59) names nine sibling designs: **Filesystem** (`daemon-capability-filesystem.md`, Draft), **Process execution** (Planned), **Network** (Planned), **Git operations** (Planned), **Environment variables** (Planned), **Credential store** (Planned), **User I/O** (Planned), **Timer / scheduling** (Planned), **Delegates / epithets** (`daemon-capability-persona.md`, Draft). The §Cross-cutting concerns (lines 61-66) name a *composition layer* — *bundle attenuated capabilities into named profiles for common roles (read-only developer, CI runner, data analyst, etc.)* — *deferred until the individual capability shapes are settled*. The §OWASP Agentic Top 10 coverage table (lines 68-79) maps eight ASI categories to *defending capabilities* (ASI01: all — interface guards reject structurally invalid calls regardless of LLM intent; ASI02: filesystem root confinement + process command allowlist + network host allowlist; ASI03: all — maker pattern restricts creation to HOST; ASI05: process command/argument guards + filesystem write confinement; ASI06: git hook denial prevents persistent instruction injection; ASI08: network rate limits + process concurrency limits + timer max-concurrent; ASI09: user-IO prompt controls + persona mandatory AI disclosure; ASI10: timer recurring denial + network C2 prevention + git push restrictions). The §LAL agent integration (lines 81-87) names the pattern: *the LAL agent can dynamically discover capabilities in its namespace and register namespaced tools* (e.g., `fs.readText`, `git.status`). The §Design Principles (lines 89-122) name six structurally important rules that every per-category design in the family must follow: (1) *Capabilities are objects, not configurations*; (2) *Recursive attenuation*; (3) *Caretaker separation*; (4) *Defense-in-depth deny patterns are optional*; (5) *LLM discoverability*; (6) *Existing Endo patterns*. The §References (lines 124-159) cite eight sources: OWASP Agentic Top 10, AIShellJack paper, IDEsaster covered in The Hacker News, Miller's *Object-Capability Model* / *Robust Composition*, Endo Hardened JavaScript documentation, OWASP Agentic Security Initiative, OWASP Agentic AI Threats and Mitigations v1.0.1, and OWASP Top 10 for LLM Applications 2025.

## Body

### §The dangerous-ambient-authority problem framing

The §opening lines (12-23):

> AI coding agents (Claude Code, Cursor, Devin, etc.) are granted dangerous ambient authority — filesystem access, shell execution, network, git, credentials — that enables data exfiltration, persistence, credential theft, and lateral movement.

The §five-resource enumeration names the attack surfaces:

- **Filesystem** — data exfiltration, credential theft (`~/.ssh`), config poisoning.
- **Shell execution** — arbitrary code execution, reverse shells.
- **Network** — C2 channels, SSRF, data exfiltration.
- **Git** — persistence via hooks, unauthorized pushes.
- **Credentials** — secret leakage, lateral movement.

The §threat-research evidence:

- **AIShellJack** (Liu et al., arXiv:2509.22040) — *attack success rates up to 84% against agentic coding editors*.
- **IDEsaster** — *30+ vulnerabilities in AI coding tools enabling data theft and RCE*; *100% of tested AI IDEs were vulnerable to prompt-injection-to-tool-abuse chains*.

The §framing discipline: *concrete empirical attack rates* + *named OWASP threat classifications*. The design isn't justifying capability-discipline in the abstract; it's responding to *documented attacks with documented success rates*. The §rationale-by-evidence shape is reusable for any security-motivated design.

### §The Endo-as-solution gap-naming

The §lines 25-32:

> Endo's object-capability model is well-suited to mediate these dangers: guests default to zero authority (least-authority formula), capabilities are unforgeable references, and `makeExo() + M.interface()` guards enforce method-level contracts. However, Endo currently lacks a standard vocabulary of OS-level capabilities that plugins can grant and attenuate.

The §two-part observation:

- **Endo has the substrate** — *zero default authority + unforgeable references + interface guards*. The mechanism for capability-mediated access *exists*.
- **Endo lacks the vocabulary** — *no standard OS-level capabilities*. The mechanism is unused at the OS-resource layer.

The §LAL-agent-as-witness:

> The LAL agent already operates as a guest with 26 tools for directory operations, mail, and eval proposals — but none of these mediate host OS resources.

The §discipline: *the LAL agent demonstrates Endo's capability mechanism works at the daemon layer; the gap is the OS-resource layer*. The Capability Bank fills that gap.

### §The family-of-designs structure

The §framing (lines 34-42):

> The Capability Bank is a family of designs — one per resource category — that extends Endo's capability discipline to the OS-level resources an AI agent might need. Each design should follow genuine ocap patterns: recursive attenuation (you narrow authority by handing out sub-capabilities, not by configuring deny-lists), caretaker separation (the controller that can revoke or restrict is a separate facet from the capability the guest holds), and structural confinement (a guest cannot name resources outside its granted scope because no path from its capabilities reaches them).

The §three-principle preview (recursive attenuation + caretaker separation + structural confinement) is expanded in the §Design Principles section below.

The §nine-category table (lines 49-59) names the family:

| Category | Design document | Threat addressed | Status |
|---|---|---|---|
| Filesystem | `daemon-capability-filesystem.md` | Credential theft, config poisoning, data exfiltration via file reads | Draft |
| Process execution | `daemon-capability-process.md` | Arbitrary code execution, reverse shells | Planned |
| Network | `daemon-capability-network.md` | Data exfiltration, C2 channels, SSRF | Planned |
| Git operations | `daemon-capability-git.md` | Persistence via hooks, unauthorized pushes | Planned |
| Environment variables | `daemon-capability-env.md` | Credential theft via env inspection | Planned |
| Credential store | `daemon-capability-credentials.md` | Secret leakage across tenants | Planned |
| User I/O | `daemon-capability-userio.md` | Clipboard harvesting, social engineering | Planned |
| Timer / scheduling | `daemon-capability-timer.md` | Autonomous persistent scheduling | Planned |
| Delegates / epithets | `daemon-capability-persona.md` | Impersonation, undisclosed AI activity, unverifiable delegation | Draft |

The §status enumeration: two Draft (Filesystem + Persona), seven Planned. The §discipline: *categories are ordered roughly by design complexity and implementation priority*. The maintainer prioritized Filesystem (most-common attack surface) and Persona (identity/impersonation; deeper conceptual work) as Drafts.

The §library cross-reference: the *Delegates / epithets* design (daemon-capability-persona) is already ingested in the library (cycles ingesting `daemon-capability-persona.md`); the family-overview here is the *parent design* that those per-category designs implement.

### §The cross-cutting composition-layer deferral

The §lines 63-66:

> Once individual capability designs are solid, a **composition layer** will bundle attenuated capabilities into named profiles for common roles (read-only developer, CI runner, data analyst, etc.). This is deferred until the individual capability shapes are settled.

The §honest-deferral discipline: *the composition layer is desirable but premature*. Without stable per-category capability shapes, the composition layer would have nothing stable to compose. The §rule: *settle the parts before designing the whole*.

The §named-role examples (read-only developer / CI runner / data analyst) sketch what the composition profiles will eventually look like, without committing to specific profile contents.

### §The OWASP-Agentic-Top-10 coverage table

The §lines 70-79 map eight ASI categories to defending capabilities:

| ASI category | Defending capabilities |
|---|---|
| ASI01 Agent Goal Hijack | All — interface guards reject structurally invalid calls regardless of LLM intent |
| ASI02 Tool Misuse & Exploitation | Filesystem (root confinement), Process (command allowlist), Network (host allowlist) |
| ASI03 Identity & Privilege Abuse | All — maker pattern restricts creation to HOST; guests hold attenuated instances |
| ASI05 Unexpected Code Execution | Process (command + argument guards), Filesystem (write confinement) |
| ASI06 Memory & Context Poisoning | Git (hook denial prevents persistent instruction injection) |
| ASI08 Cascading Failures | Network (rate limits), Process (concurrency limits), Timer (max concurrent) |
| ASI09 Human-Agent Trust Exploitation | User I/O (prompt controls, notification rate limits), Persona (mandatory AI disclosure) |
| ASI10 Rogue Agents | Timer (recurring denial), Network (C2 prevention), Git (push restrictions) |

The §two-row patterns:

- **`All — ...`** rows (ASI01, ASI03) — the discipline that *every* capability's structural-invariant defends, not a specific capability. ASI01 is defended by *interface guards rejecting structurally invalid calls regardless of LLM intent* — the M.interface() guard runs first; the LLM-generated argument is checked against the guard before any handler runs. ASI03 is defended by *the maker pattern restricts creation to HOST*; guests can only hold instances they were *granted*, not construct them themselves.
- **Specific-capability rows** (ASI02, ASI05, ASI06, ASI08, ASI09, ASI10) — the *concrete-defenses-per-threat* pattern. Each row names the specific capabilities that address the threat.

The §discipline: *the threat model is concrete and named*. The §coverage matrix lets a reader audit *which OWASP threats this family addresses and which it doesn't*.

### §The LAL agent integration sketch

The §lines 83-87:

> The LAL agent can dynamically discover capabilities in its namespace and register namespaced tools (e.g., `fs.readText`, `git.status`). The integration pattern will be specified in each capability's design document and summarized in a separate LAL integration document once the individual designs are stable.

The §two-step pattern:

1. **Dynamic discovery** — the LAL agent walks its namespace and finds capabilities (the daemon-side pet store).
2. **Namespaced tool registration** — each capability becomes a tool the LLM can call, prefixed by the namespace (e.g., `fs.readText` for filesystem, `git.status` for git ops).

The §namespacing discipline: *the prefix communicates the capability category* to the LLM. The agent's tool list is shaped by *what capabilities are in the agent's namespace*, not by hardcoded tool definitions. The §dynamic-discovery enables *capability changes without agent redeployment*.

The §design-document split: the *per-capability LAL integration* lives in each capability's design doc; the *cross-cutting LAL integration summary* is deferred to a separate document.

### §The six Design Principles

The §lines 89-122 name six structurally important rules. These are the *meta-discipline* that defines what makes a per-category design *capability-shaped* vs *configuration-shaped*.

**§(1) Capabilities are objects, not configurations**:

> A guest receives a `Directory` capability rooted at `/home/user/project` — it does not receive a "FileSystem service configured with roots and deny-globs." The guest cannot name `~/.ssh` because no method on its `Directory` returns a path to it.

The §canonical distinction between ocap and ACL:

- **Configuration approach** — the guest gets a *FileSystem service* and a *configuration* (roots + deny-globs). The service knows about *all paths* but rejects requests outside the allowed scope. *The guest can name paths it shouldn't reach* but the service refuses; the §rejection is *behavioral*.
- **Capability approach** — the guest gets a *Directory rooted at /home/user/project*. The Directory's methods can return *child Directories and Files* via paths *within the root*. *The guest literally cannot name `~/.ssh`* because no method on the Directory ever returns a reference to it; the §rejection is *structural*.

The §discipline: *structural confinement is stronger than behavioral confinement*. A configuration-based service is a defense; a capability-shaped service is *no offense even possible*.

**§(2) Recursive attenuation**:

> Authority narrows by handing out sub-capabilities. A `Directory` returns child `Directory` and `File` capabilities. You attenuate by granting a subdirectory, not by adding exclude patterns to a descriptor.

The §pattern: *narrower-power-via-narrower-capability*. If a guest needs access only to `/home/user/project/src/`, the host grants `Directory(/home/user/project/src/)` not `Directory(/home/user/project/)` *with an exclude-pattern*. The §rationale: the *narrower capability has no way to reach the broader scope*; an exclude-pattern adds *one more check* but doesn't eliminate the path.

**§(3) Caretaker separation**:

> The facet the guest holds (e.g., `File`) is separate from the facet the host holds for control (e.g., `FileControl`). The host can revoke or restrict without the guest's cooperation. The guest cannot discover or influence the controller.

The §two-facet split:

- **Guest holds the capability** — read/write/list facet, scoped to the guest's intended operations.
- **Host holds the control facet** — revoke, restrict, observe; *not exposed to the guest*.

The §discipline: *revocability is a property of the host's control facet, not the guest's capability facet*. The guest can be granted a capability that *might* be revoked at any time; the guest's API has no method to influence the revocation. The §pattern matches the Handle/HandleControl pair from `daemon-capability-persona`.

**§(4) Defense-in-depth deny patterns are optional**:

> Hardcoded denylists for sensitive paths, credential env vars, etc. are a secondary safety net, not the primary confinement mechanism. They catch mistakes in capability granting, not failures in the capability model itself.

The §two-layer model:

- **Primary** — *structural confinement via capability scope*. A Directory rooted at `/home/user/project` *literally cannot reach `~/.ssh`*.
- **Secondary** — *behavioral denylist for sensitive paths*. A denylist for `~/.ssh`/`*.pem`/`*.key`/etc. acts as a *safety net* that catches *accidental over-granting* (a host granting `Directory(/)` by mistake would still be caught by the denylist).

The §discipline: *the primary mechanism does the security work*; the secondary mechanism *catches mistakes*. A design that relies on denylists as the primary mechanism is *not capability-shaped*; a design that uses denylists as a backstop *is* capability-shaped.

**§(5) LLM discoverability**:

> Every capability exposes `help()` text written for an LLM encountering it cold, and `M.interface()` guards with maximally specific shapes (named fields, literal enumerations, descriptive remotable tags).

The §two-part LLM-affordance:

- **`help()` text** — written for *an LLM encountering it cold*, not for a human reading documentation. The text says *what the capability does, how to invoke it, what shapes to pass, what to expect back*. The §discipline: an LLM should be able to use the capability *correctly on first encounter* by reading the help text.
- **Maximally-specific `M.interface()` guards** — *named fields, literal enumerations, descriptive remotable tags*. The shape itself is documentation for the LLM. A guard like `M.string()` is too loose; a guard like `M.or('text', 'binary', 'auto')` for a content-encoding parameter is *self-documenting*.

The §discipline: *the capability's surface is the LLM's documentation*. There's no separate prose doc the LLM needs to consult; the interface guards + help text *are* the spec.

**§(6) Existing Endo patterns**:

> Designs should build on Endo's existing directory capability (`packages/daemon/src/directory.js`), the virtual filesystem design sketch (`docs/virtual-filesystem-design.md`), and the guest/host power model rather than introducing parallel abstractions.

The §don't-reinvent discipline. Endo already has *directory capabilities* (the file-system-shaped abstraction); per-category capability designs should *reuse* the directory shape rather than inventing parallel structures.

The §three named references:

- **`packages/daemon/src/directory.js`** — the existing directory capability implementation.
- **`docs/virtual-filesystem-design.md`** — the design sketch for VFS extensions.
- **The guest/host power model** — the canonical capability-shape (zero-power guests + per-grant additions).

The §discipline: *the per-category designs should look like extensions of existing patterns*, not parallel inventions. Reusing the directory shape *across multiple capability categories* (e.g., a `Directory`-shaped capability for git repos, for environment variables, for credential stores) lets the LLM transfer learning across categories.

### §The eight-citation References block

The §References (lines 124-159) cite eight sources spanning OWASP, academic papers, security journalism, and Endo documentation:

- **[1]** OWASP Top 10 for Agentic Applications for 2026 (Dec 2025).
- **[2]** Liu et al., *Your AI, My Shell: Demystifying Prompt Injection Attacks on Agentic AI Coding Editors* (arXiv:2509.22040, Sep 2025).
- **[3]** A. Marzouk (MaccariTA), *IDEsaster: 30+ Vulnerabilities in AI Coding Tools Enabling Data Theft and RCE* (Dec 2025, via The Hacker News).
- **[4]** M. S. Miller, *Object-Capability Model* (Robust Composition PhD, JHU, 2006).
- **[5]** Endo project, *Hardened JavaScript (SES)* documentation.
- **[6]** OWASP Agentic Security Initiative.
- **[7]** OWASP Agentic AI — Threats and Mitigations v1.0.1 (2025).
- **[8]** OWASP Top 10 for Large Language Model Applications 2025.

The §citation discipline: *the design's claims are backed by named sources with URLs*. The §maintainer reading the design can follow the citations to verify the threat-model claims (84% attack rate, 100% IDE vulnerability) and the conceptual framing (Miller's ocap model).

The §three-OWASP-citation cluster ([1], [6], [7], [8]) and the two-empirical-research citations ([2], [3]) document *both the standard and the research* — the design isn't proposing new threats; it's responding to threats *already documented by the security community*.

## Connection to the wider library

This section is the **canonical *meta-design-for-a-family-of-designs* worked example**. Four threads:

1. **The family-of-designs meta-structure** — instead of one monolithic design, a *category table* names nine sibling designs that share a discipline. The meta-design establishes principles; per-category designs implement them. Reusable for any *related-but-distinct designs* that share common architecture.

2. **The capabilities-are-objects-not-configurations canonical distinction** — the §rationale for *why ocap is structurally different from ACL*. The guest *literally cannot name* the resource; the rejection is structural, not behavioral. This is *the* foundational ocap claim, articulated as a design principle.

3. **The OWASP-coverage matrix shape** — the *threat-by-defending-capability* table is the canonical *security-design-coverage* shape. Each row makes the claim *which capability addresses this threat in what way* explicit. Reusable for any design that addresses a *standard threat-classification*.

4. **The defense-in-depth-deny-patterns-are-optional layering** — denylists as *secondary safety net for mistakes in capability granting*, not primary confinement. The §discipline keeps the primary mechanism *structural-not-behavioral* while allowing for *belt-and-suspenders* error catching.

The §sister-design-pointers — this design names two existing drafts (`daemon-capability-filesystem` and `daemon-capability-persona`); the library has ingested `daemon-capability-persona` extensively. The §family-overview here is the *parent context* for those per-category designs.

The §cross-cycle complement: cycle 101's `daemon-commands-as-messages` named `daemon-capability-bank` as the *audit-trail beneficiary* (commands-as-messages would give the bank a built-in observability surface). Cycle 103's `daemon-value-message` named it as *future capability-grant-delivery mechanism*. Cycle 105 (this ingest) is the *bank itself*, completing the design-graph triangle.

## Translation block (design idiom → contemporary practice)

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

## See also

- [[daemon]] (topic) — the endo daemon architecture; the Capability Bank extends the daemon's capability mechanism to OS-level resources.
- [[capability-security]] (topic) — the canonical capability-discipline this design family embodies.
- `endo-but-for-bots--llm-designs-daemon-capability-persona--*` (already ingested) — one of the two Drafts in the §Capability Categories table; the *Delegates / epithets* design that addresses ASI09 Human-Agent Trust Exploitation via mandatory AI disclosure.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — names *daemon-capability-bank* as an *audit-trail beneficiary*; commands-as-messages gives the bank a built-in observability surface.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — names *daemon-capability-bank* as *future capability-grant-delivery mechanism*; value messages could carry capability grants.
- `papers--miller-capability-myths-demolished-2003--*` — Miller's foundational *capability-security-vs-ACL* arguments; cited [4] is Miller's *Robust Composition* PhD which expands these arguments.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--*` — the eventual-send/vat model that the Endo daemon implements; the runtime substrate this design family runs on.

## Common confusions

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
