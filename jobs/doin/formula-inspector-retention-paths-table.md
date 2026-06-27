<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T07:29:28Z -->

# PLAN (follow-on): add a retention-paths table to the formula inspector

Maintainer: as a **follow-on to the formula inspector PR**, add a **table of all of the
formula's retention paths** to the formula inspector. Deferred plan; when promoted, design+build
it on `endojs/endo-but-for-bots` (bot identity, bot repo). Wear the **designer** then **builder**
role (a small design pass if the table layout warrants it, then implement).

## Context — the pieces this connects

- **Formula inspector**: PR **#440** (`feat(daemon,cli,chat): drop @info name hub for
  formula-inspector design`) implementing design **#439** (`design(chat): Value modal Formula
  view (card-flip back face)`) — the Chat Value modal's Formula view that inspects a formula.
  https://github.com/endojs/endo-but-for-bots/pull/440 · /pull/439
- **Retention-paths machinery**: PR **#284** (`feat(daemon,cli): retention-paths Phase 1 — host
  API + endo paths CLI`) — the daemon host API + `endo paths` CLI that computes a formula's
  retention paths. **Source the table's data from this API**; do not recompute the graph in the UI.
  https://github.com/endojs/endo-but-for-bots/pull/284

This is a **follow-on**: it does NOT block #440. It lands after #440 (the inspector) and #284 (the
retention-paths API) are available. Note that dependency in the PR.

## The feature

Add a **"Retention paths" table** to the formula inspector listing **all** paths by which the
inspected formula is retained — each row a path from a retaining root through the formula
reference graph to this formula, showing the formula-ids/petnames (and edge kind, where #284
exposes it) along the path. If the formula has many paths, make the table scannable (group/sort
sensibly, show the count, paginate or scroll). Empty state ("no retaining paths / unretained")
handled. Read-only display sourced from #284's host API / `endo paths`.

## Approach

- Confirm the shape #284's host API returns for retention paths and bind the inspector table to
  it. If #284 has not landed when this is promoted, surface that as the blocking dependency rather
  than reimplementing path computation.
- Keep it within the formula inspector's existing Value-modal Formula view (#439) — a new table
  section on that back face. Match the surrounding Chat UI (confined Preact, per #471).
- Tests for the table rendering (multiple paths, single path, none) against a fixture of the API
  response.
- End with the standard top-level **PR summary comment** (SHA + what was added + verification).

## Definition of done

The formula inspector shows a "Retention paths" table enumerating all of a formula's retention
paths, sourced from the #284 retention-paths host API, with sensible layout + empty/many states
and tests — on a PR against `endojs/endo-but-for-bots`. Report the PR number. If #284's API is
unavailable/insufficient, report the gap instead of duplicating the graph walk.

---
claim:
  host: endolinbot
  gardener: 63
  claimed_at: 2026-06-27T07:29:31Z
