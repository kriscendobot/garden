---
date: 2026-05-15T01:52:26Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--4f2ca4
cycle: 56
---

# Scholar cycle 56: chat-spaces-gutter (3 sections; introduces the *space* concept)

## Ingested

`endo-but-for-bots/llm/designs/chat-spaces-gutter.md` — **Complete**
upstream, 187 lines, created 2026-02-21 / updated 2026-02-26, Kris
Kowal. Same upstream commit as chat-invariants and chat-components
(`3b031592e5f97a86e317cb96f1b7c44abb4e41f9`, all three committed
together when `packages/chat/DESIGN.md` was split). No prior source-
index; fresh ingestion. Slug `chat-spaces-gutter` (continuing the
full-filename chat convention).

## Section files (3)

- `chat-spaces-gutter/motivation-and-architecture` — the multi-agent context-switch friction problem; spaces as bookmarks; **"No new daemon APIs"** as the structurally interesting property (the entire feature rides on existing pet-store primitives); 48px left-edge layout with `--gutter-width` CSS variable.
- `chat-spaces-gutter/space-model-and-persistence` — `SpaceConfig` typedef; pet-store-based CRUD via `write`/`list`/`lookup`/`remove`/`storeValue`. The *typed namespace over an untyped name-resolution primitive* discipline.
- `chat-spaces-gutter/interactions-keyboard-and-future` — 5 user interactions (click / right-click / + button / Cmd+1..9 / hover) implementing keyboard-manual parity; component factory API surface; visual design; 6-item future-enhancement roadmap with 3 items shipped during iteration (inline-strikethrough preserves the roadmap shape).

## Topic refreshes

- `chat-ui.md` — 3 new rows; 6 → 9.
- `agent-conventions.md` — 2 new rows (motivation-and-architecture for the *client-side convention over a complete daemon API* discipline; space-model-and-persistence for the *typed namespace over untyped pet-store* shape); 34 → 36.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row (chat-spaces-gutter).
- `sections/README.md` — new cycle-56 group; total **461 → 464**.
- `keywords.md` — 10 new entries (`chat spaces gutter`, `space (chat)`, `` `SpaceConfig` ``, `` `createSpacesGutter` ``, `client-side convention over a complete daemon API`, `typed namespace over untyped pet-store`, `Cmd+1..9`, `multi-agent context switching`, `profilePath`, `spaces gutter`).

## Cross-cluster cross-references woven in

The chat-spaces-gutter sections reference:

- The cycle-54 chat-invariants and cycle-55 chat-components sections (component-factory pattern, keyboard-manual parity, CSS variable extension).
- The cycle-49 dani design (`networks` field on `GuestFormula`) as the **inverse** structural case — dani *had* to extend the daemon's formula type; spaces-gutter *deliberately doesn't*. The contrast is what makes the *"No new daemon APIs"* claim load-bearing rather than incidental.
- The cycle-46 dcpg/persistence-and-graph for retention-side context on what happens to pet-name-removed value formulas.

## Notable: the "complete daemon API" discipline

The space-model-and-persistence section codifies a discipline that
the daemon's API supports without explicit naming: **a typed
namespace can be encoded over the daemon's untyped name-resolution
primitives** (`pet-store.write`, `list`, `lookup`, `remove`,
`storeValue`) without daemon changes. Spaces are one instance; the
same shape recurs for message storage, message-number bindings, and
host directory hierarchies. This is the *inverse* of designs that
expand the daemon's API surface (dani's `GuestFormula.networks`,
d256's `keypair` formula type) — knowing which side a feature lands
on is a daemon-vs-client design judgment that this design makes
explicit.

If a third chat or non-chat source uses the same client-side-
convention pattern, a `client-side-convention-over-daemon-api`
concept page may become warranted.

## Library state

- Sources: 103 → **104**
- Sections: 461 → **464**
- Topics: 26 (unchanged); 2 topic pages refreshed.
- Concepts: 20 (unchanged).
- Keywords: ~186 → ~196.
- Roles: 3 (unchanged).

## Notes for the next cycle

- **Chat backlog still ~17 files**: `chat-command-bar.md` (255 lines, the modeline-bearing component), `chat-edit-message-ui.md`, `chat-markdown-render.md`, `chat-spaces-home.md` + `chat-spaces-inbox.md` (sibling spaces designs referenced by this cycle), `chat-per-space-color-scheme.md`, `chat-test-coverage.md`, etc.
- **`chat-spaces-home.md`** is the natural next pick — chat-spaces-gutter explicitly references it as covering the home-space affordance, and it's a sibling design that completes the spaces story.
- **The *space* concept is now referenced from three sources** (chat-components mentions `spaces-gutter.js` and `add-space-modal.js`; chat-spaces-gutter defines it; future sources will use it). After chat-spaces-home lands, a `space` concept page becomes warranted.
- **Library-lookup caller-driven writeback** still pending.
