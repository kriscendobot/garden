---
gate: orchestrated
orchestrated_by: daemon-store-family-build
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-21T23:24:40Z
---

role: builder

# Build Phase 6: human surfaces (CLI + WUI) for the persistent stores (design Phase 6)

Repo: endojs/endo-but-for-bots. Implement **Phase 6**: the human-facing command
vocabulary specified in the design's § CLI and WUI command vocabulary, on top of
the store family from Phases 1-4.

Scope (see design § CLI and WUI command vocabulary, § Phased Phase 6):
- the `mkmap` / `mkset` / `mkweakmap` / `mkweakset` constructors (siblings of
  `mkdir` / `mkhost`);
- the `endo map <name> ...` / `endo set <name> ...` (and weak) verb groups
  mapping each interface method to a CLI verb; weak variants omit enumeration;
- typed key/value encodings `--json` / `--justin` / `@pet-name` over a TOTAL,
  NON-EVALUATING decoder (no raw `eval` for keys, per the design decision);
- the chat client's **Store Space** WUI mirroring the same verbs.
- `--shon` is GATED on vendoring a SHON decoder (Known Gaps): do NOT add it in
  this phase unless the SHON decoder has landed; JSON / Justin / `@pet-name` need
  no new dependency. If SHON is still ungated, ship without `--shon` and note it.

## Tests
CLI verb round-trips against a live daemon for map + set (and weak) kinds; the
non-evaluating decoder rejects code-bearing input; WUI Store Space smoke test.

## Base / stacking (stacked-PR build)

Use skills/stacked-pr-build: because each phase depends on the code the prior
phase adds, do NOT branch off a bare `llm` for phases 2+. Branch off the PRIOR
phase's head branch so your worktree already contains its store substrate, and
open your DRAFT PR with that prior branch as the base (a stacked PR). Phase 1
branches off `llm`. If a prior phase has already merged to `llm` by the time you
start, rebase onto `llm` instead and base the PR on `llm`. Always
`git fetch` + rebase before you begin (skills/rebase-before-followup).

Open a DRAFT PR; the build auto-runs the gauntlet (clean -> panel -> fix-loop ->
un-draft). Keep the PR scoped to THIS phase only. Do NOT add an `@agoric/*`
dependency; reuse `@endo/patterns` / `@endo/exo` / the daemon's own marshal
substrate. Run `yarn lint` and the daemon package tests locally before pushing
(garden memory "Endo local test bin shims" for the PATH shims). If the design
proves insufficient for this phase, STOP and surface to the maintainer rather
than guessing — the orchestration halts on a child failure.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-59
issue_url: https://github.com/kriskowal/garden/issues/59
submitter: dckc
----- END ISSUE NOTE -----

Design authority for the full detail and file:line grounding:
`packages/daemon/designs/daemon-persistent-stores.md` (merged from PR #809).
READ THE RELEVANT PHASE SECTION FIRST. When the PR is green and un-drafted,
comment the outcome (link the PR) on https://github.com/kriskowal/garden/issues/59.
