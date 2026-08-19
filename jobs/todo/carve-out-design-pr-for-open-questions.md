---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Carve out: a garden-infra design that needs feedback gets a review PR, not a blind land

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR for the mechanical edit itself (CLAUDE.md § Conventions).

## The grounding incident

`design-muse-worker-kind` landed `designs/muse-worker-kind.md` directly on
`main2` (commit `d2a970ae8b`) with **six open questions the maintainer must
decide** (beta access/ToS, pricing tier, credential mechanism, base URL,
wire model id, agentic tool-calling support) — a real, undecided design fork,
not settled documentation. The maintainer had no review surface: no diff to
comment on, no thread to answer inline, just a landed file to read cold. A
retroactive PR was created by hand
(https://github.com/kriscendobot/garden/pull/74, based on the commit before
the design landed) so inline review could happen at all -- after the fact,
by request, rather than by design.

## The rule

**A design landed on the garden's own repo whose content carries open
questions needing maintainer feedback must be presented as a PR, not landed
bare.** This is a carve-out from the general "no PR workflows for the
garden's own repo" convention (CLAUDE.md § Conventions), not a reversal of
it: a design with no open questions (an accepted plan, an implementation
write-up, documentation of an already-agreed direction -- most garden design
docs that already land this way) still lands bare, direct-to-`main2`, same
as always. The trigger is specifically **unresolved, maintainer-facing open
questions**, not "is this a design doc."

## What to change

- **`roles/designer/AGENT.md` § Operating norms.** The existing line "Output
  is the bare file only where the garden has no fork it may push to" needs
  the carve-out stated explicitly: for the garden's own repo specifically,
  a design carrying a non-empty `## Open questions` (or equivalent) section
  lands as a PR — base a snapshot branch at the commit immediately before
  the design would otherwise land, head a branch carrying just the design
  commit(s), same mechanics [`frozen-base-branch`](skills/frozen-base-branch/SKILL.md)
  already uses for the `agoric/agoric-sdk` no-roadmap-branch carve-out (this
  is the same shape, reused, not a new mechanism). A design with an *empty*
  or absent open-questions section still lands bare.
- **`CLAUDE.md` § Conventions.** Add the carve-out note next to the existing
  "we do not generally open pull requests against ourselves" statement, so
  it's not just buried in the designer role file -- a reader of the
  top-level convention should see the exception stated where the rule is.
- **Do not stage the design-panel gauntlet for this PR class.** A design PR
  in this repo is a **review surface for the maintainer's open questions**,
  not a pending merge blocked on panel convergence -- the content is
  usually already landed on `main2` by the time (or same time as) the PR
  exists (per the recommended mechanics above), so `assert-design-pr-gauntlet.sh`'s
  design-only-diff auto-stage must not fire for this specific class. Name
  exactly how the designer marks a PR as this class (a PR-body convention,
  a title prefix, or similar) so the gauntlet-staging logic can reliably
  distinguish it from an ordinary fork-repo design PR that DOES want a
  panel.
- **Land bare-vs-PR is decided at design-completion time**, not retroactively
  by the maintainer noticing after the fact -- the designer role itself
  checks for open questions before landing and picks the right path,
  matching the same "decide correctly the first time, don't rely on a human
  to catch it" spirit as today's `assert-followup-posted-gate` job.

## Acceptance

- `roles/designer/AGENT.md` and `CLAUDE.md` both state the carve-out
  consistently (one canonical statement, cross-linked, not duplicated in
  conflicting words).
- A concrete worked example or test fixture: a design body containing a
  non-trivial `## Open questions` section lands as base-snapshot + PR;
  one with an empty/absent section lands bare, direct-to-`main2` -- same as
  today.
- Report cites `design-muse-worker-kind` / PR #74 as the grounding example.
