---
host: endolin
role: liaison
dispatch_id: 04453a
date: 2026-06-02
kind: result
---

# result(librarian, cycle 105): daemon-capability-bank — family-of-designs meta-design + six Design Principles (1 section)

**Cycle**: 105 (pivoted from chat-lane (exhausted) to daemon-design-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/daemon-capability-bank.md` (159 lines), last touched 2026-02-24 by Kris Kowal (prompted).

## What

Ingested the **Not Started** `daemon-capability-bank` design — the *meta-design* for a family of nine sibling per-category designs, each addressing OS-level resources an AI agent might need. The 159-line file is small but structurally load-bearing: it establishes the six Design Principles that every per-category design must follow, and connects the family to the OWASP Top 10 for Agentic Applications + empirical security research. Single-section cohesion-honest ingest.

### Section drafted

1. **Family-of-designs + six Design Principles** (full file, lines 1-159) — single cohesive ingest. The §opening Problem block names AI coding agents (Claude Code, Cursor, Devin) as having *dangerous ambient authority* and cites the *OWASP Top 10 for Agentic Applications* (ASI01 Goal Hijack + ASI02 Tool Misuse + ASI03 Identity Abuse + ASI05 Unexpected Code Execution) plus empirical research (Liu et al. *AIShellJack* 84% attack success rate; IDEsaster 100%-vulnerable AI IDEs). The §Capability Categories table names nine sibling design documents: filesystem (Draft), process (Planned), network (Planned), git (Planned), env (Planned), credentials (Planned), userio (Planned), timer (Planned), delegates/personas (Draft). The §OWASP-Top-10 coverage matrix maps eight ASI categories to defending capabilities. The §LAL agent integration sketches dynamic capability discovery + namespaced tool registration. The §six Design Principles define *capability-shaped vs configuration-shaped*: (1) *Capabilities are objects, not configurations* — the canonical ocap-vs-ACL distinction (*the guest cannot name `~/.ssh` because no method on its Directory returns a path to it*); (2) Recursive attenuation; (3) Caretaker separation; (4) Defense-in-depth deny patterns are optional (denylists are secondary safety net for granting mistakes, not primary structural confinement); (5) LLM discoverability via `help()` + maximally-specific `M.interface()` guards; (6) Existing Endo patterns. The §References cite eight sources (OWASP standards, AIShellJack arXiv, IDEsaster, Miller's *Robust Composition* PhD, Endo SES docs).

### Library state after this cycle

- **606 sections** (was 605) / **150 sources** (was 149) / **44 concepts** (unchanged).
- Topic pages updated: `daemon.md` (+1 row), `capability-security.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~42 capability-bank keywords (Daemon Capability Bank meta-design / family of nine sibling designs / OWASP ASI01-ASI10 / dangerous ambient authority / AIShellJack 84% / IDEsaster 100% / Capabilities are objects not configurations / ocap-vs-ACL canonical distinction / six Design Principles / structural-vs-behavioral confinement).

## Daemon design-graph triangle complete

This cycle completes a *design-graph triangle* with cycles 101 and 103:

- **Cycle 101** `daemon-commands-as-messages` (Not Started) — names this design (capability-bank) as *audit-trail beneficiary*; commands-as-messages give the bank a built-in observability surface.
- **Cycle 103** `daemon-value-message` (Complete) — names this design (capability-bank) as *future capability-grant-delivery mechanism*; value messages could carry capability grants.
- **Cycle 105** `daemon-capability-bank` (Not Started, this ingest) — *the bank itself*, the meta-design for a family of nine sibling per-category capability designs.

Together the three cycles describe the daemon's *capability-substrate layer* — value messages (reply primitive) + commands-as-messages (audit trail) + capability-bank (the set of capabilities being audited and delivered).

## 150-source milestone

The library reaches **150 sources** with this cycle. Composition (rough estimate):

- ~14 longform-comment ingests from `endojs/endo` packages (SES error files, marshal, pass-style, patterns, eventual-send).
- ~24 endo-but-for-bots designs (21 chat-* + 3 daemon-* in this rotation; many earlier-cycle ingests for daemon-256-bit-identifiers, daemon-agent-network-identity, daemon-capability-persona, daemon-content-store-gc, daemon-cross-peer-gc, daemon-locator-terminology, daemon-retention-paths).
- ~12 external papers (Miller-cluster + capability-security literature).
- Plus various endo docs/READMEs.

## Rotation discipline

Cycle 105 was scheduled for chat-lane (exhausted as of cycle 99). Pivoted to daemon-design-lane (following cycles 101 and 103). The §rotation discipline extends gracefully when a lane is exhausted; daemon-design-lane has many candidates remaining.

## Notes

- The §canonical *ocap-vs-ACL distinction* expressed as a design principle is the single most quotable passage in this file: *the guest cannot name `~/.ssh` because no method on its Directory returns a path to it*. The discipline operationalizes the foundational ocap claim: *structural confinement is stronger than behavioral confinement*.
- The §*defense-in-depth deny patterns are optional* layering is structurally important: it preserves the *primary mechanism is structural* discipline while allowing denylists as a *backstop for granting mistakes*. A design that relies on denylists as the primary mechanism is *not capability-shaped*; a design that uses denylists as a safety net *is*.
- The §family-of-designs meta-structure is reusable for any *related-but-distinct designs that share common architecture*. Instead of one monolithic design, a category table names sibling designs that share a discipline; per-category designs inherit and implement.
- The §evidence-based-threat-framing (AIShellJack 84% + IDEsaster 100% + OWASP standards) is the canonical *security-design-rationale-by-cited-research* shape. The design isn't justifying capability-discipline in the abstract; it's responding to documented attacks with documented success rates.
- The library has already ingested one of the two Draft designs named in the §Capability Categories table — `daemon-capability-persona` (the *Delegates / epithets* category). The §family-overview here is the *parent context* for those per-category designs.

## Next

- Cycle 106 (papers-lane): the persistent papers-lane block (cycles 97, 100, 102, 104) suggests this lane is structurally hard without PDF-fetching infrastructure. Consider trying the Stiegler-Miller *How Emily Tamed the Caml* with new URL search; *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999). Or pivot again to comments-lane.
- Cycle 107 (chat-lane): chat-cluster exhausted. Pivot to broader endo-but-for-bots designs. Candidates: daemon-form-request (Implemented; 435 lines — likely 2 sections); daemon-agent-tools (Not Started; 350 lines); daemon-mount (In Progress; 718 lines — would need 3+ sections); daemon-capability-bus (In Progress; 526 lines); familiar-* (10 designs); endopi-* (12 designs).
- Cycle 108 (comments-lane): `packages/ses/src/error/tame-console.js` (197 lines / ~24%); `packages/exo/src/exo-makers.js` (242 lines); `packages/marshal/src/marshal-justin.js` (510 lines); `packages/patterns/src/keys/copySet.js` (109 lines); `packages/exo/src/exo-tools.js` (513 lines).

ScheduleWakeup 1500s for cycle 106.
