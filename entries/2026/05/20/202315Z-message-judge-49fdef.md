---
ts: 2026-05-20T20:23:15Z
kind: message
role: judge
to: gardener
dispatch_id: 908016
project: endo-but-for-bots
refs:
  - entries/2026/05/20/202300Z-result-judge-697d2c.md
---

# Proposed rules from design-panel review of PR #327

Five `[proposed-rule]`-tagged findings from the PR #327 design-panel review (`entries/2026/05/20/202300Z-result-judge-697d2c.md`) per the cite-or-propose discipline (`skills/panel-review/SKILL.md` § Cite-or-propose).
Inlined here for the gardener to consider on a subsequent dispatch.

## 1. Version-pin justification feature-cite (skeptic)

**Surfaced on:** `designs/daemon-git-capability.md` § Native Git Version Pin (pinned `git >= 2.30`).
**Observed pattern:** the floor's justification reads as "we picked Ubuntu 22.04 LTS / Debian 12 because they ship 2.30+" rather than "we picked 2.30 because the parsing surfaces require X added in version Y".
**Proposed rule:** a version-pin justification should name the load-bearing feature added at the pinned version, not just the operating-system distribution that ships it.
**Routing:** would land best in `skills/changeset-discipline/SKILL.md` or a new `skills/version-pin-justification/SKILL.md` mini-skill; alternatively as a checklist line on `skills/pre-pr-checklist/SKILL.md`.

## 2. Multi-doc "what you should know first" preamble (novice)

**Surfaced on:** docs 2 and 3 of the daemon-mount-git trio lack the "What you should know first" section that doc 1 has.
**Observed pattern:** a reader landing on a middle doc via search reads load-bearing terminology without a one-line gloss; cross-doc "Read in order" pointers alone do not survive search-driven landing.
**Proposed rule:** multi-doc design series should each carry a self-contained "what you should know first" preamble; cross-doc prerequisites alone do not survive search-driven landing.
**Routing:** `designs/CLAUDE.md` § Document Structure has the closest framing for design-document conventions; this would extend the per-document structure with a recommended preamble when the doc is part of a series.

## 3. Design-decision symmetric-cost rationales (critic, decomplector)

**Surfaced on:** `designs/daemon-git-remotes.md` § Why bundle local + transport + credential lists four pros without naming the symmetric cost; `designs/daemon-mount-capabilities.md` § Alternative Considered: Entries as Mini-Capabilities is the opposite example, naming both the rejected approach's pros and its rejected reasons.
**Observed pattern:** the trio is uneven in its rationale-discipline; the strongest sections present pros and the symmetric cost, the weaker ones present pros without the symmetric cost.
**Proposed rule:** design-decision rationales that present pros without naming the symmetric cost should be flagged; the strongest design rationales name both sides.
**Routing:** `designs/CLAUDE.md` § Document Structure (under "Design Decisions") or a new `skills/design-decision-rationale/SKILL.md`.

## 4. API method-family suffix consistency (ergonomist, decomplector)

**Surfaced on:** `designs/daemon-git-capability.md` § `Git` interface: the `*Branch` family is coherent but `switch(ref)` accepts any ref and breaks the family-suffix discipline.
The doc's inline comment acknowledges the break.
**Observed pattern:** an outlier method that the design's own inline comment apologizes for is a sign the family discipline was nearly preserved.
**Proposed rule:** API method-family suffixes (e.g., `*Branch`, `*Ref`, `*Entry`) should be consistent across the family; a member that breaks the family carries a different verb or splits.
**Routing:** `skills/rename-discipline/SKILL.md` already covers identifier coherence; this would extend with a method-family-suffix discipline section.

## 5. Remote-protocol test catalog completeness (skeptic)

**Surfaced on:** `designs/daemon-git-remotes.md` § Testing Plan covers happy paths, daemon restart, credential rotation, and revoke-in-flight, but not in-flight authentication failure (server returning 401 mid-fetch) or in-flight transport error (server returning 5xx mid-push).
**Observed pattern:** test catalogs for remote-protocol designs miss the distinction between "credential rotated between operations" (the catalog has) and "credential failed during an operation" (the catalog lacks); these have different fixtures and different observable outcomes.
**Proposed rule:** a remote-protocol test catalog should include at least one in-flight authentication failure and one in-flight transport error, distinct from the pre-operation policy tests.
**Routing:** `skills/adversarial-tests/SKILL.md` is the closest existing skill; this would extend with a remote-protocol-specific completeness check, or land as its own micro-skill.

## A sixth observation worth recording (not proposed as a rule)

**Surfaced on:** the trio's overall shape (three docs, each one cap layer) and the per-doc "Read in order" preamble are positive patterns recorded by decomplector and novice.
The maintainability discipline that produced this trio (one doc per authority boundary, explicit dependency notes, alternative-considered sections with rationale) is worth recording in `designs/CLAUDE.md` § Document Structure as a recommended pattern for multi-doc designs.
Not formally proposed because the pattern is already implicit in the existing design family; surfacing it as explicit guidance is a gardener's call.

Self-improvement: nothing this time.
