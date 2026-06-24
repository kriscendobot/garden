---
title: "weblet-next — removed-feature-preservation-document for the deleted weblet implementation"
source-slug: endo-but-for-bots--llm-designs-weblet-next
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/weblet-next.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/weblet-next.md
total-lines: 454
status: Reference (2026-03-24; removed-feature-preservation-document)
ingest-cycle: 204
ingest-date: 2026-06-06
lane: designs
---

# weblet-next.md

A 454-line **Reference** design (2026-03-24) preserving the §removed-implementation of the weblet feature. §A-design-document-as-archaeology with §named-purpose: "intended as a reference for anyone rebuilding this functionality". Forward-looking successor designs: `daemon-weblet-application.md`, `familiar-unified-weblet-server.md`, `familiar-chat-weblet-hosting.md`.

## A new design genre

§Removed-feature-preservation-document — distinct from typical design genres:
- §Proposal: design before implementation.
- §Reference (inventory): captured at landing for comparison/context.
- §In Progress: design alongside implementation.
- §Reference (pre-emptive supersedes): cycle 200 retention-path-notation.
- §Reference (post-removal archaeology): **this cycle's shape**.

§The-implementation-existed-and-was-deleted; the design captures §what-was for §reconstruction.

## Key design moves

- **§Removed-Files table with 8 files** each having §a-named-role (web-server-node.js / web-server-node-powers.js / web-page.js / interfaces/web.js / serve-private-port-http.js (marked "dead code") / cli/commands/install.js / cli/commands/open.js / cli/demo/cat.js ~1065-line permission management UI).
- **§Architecture-Overview-with-four-layers**: CLI (`endo install`, `endo open`) / Special formula (`@apps`) / Unified server (`web-server-node.js`) / Browser bootstrap (`web-page.js`).
- **§Nine Detailed Component Descriptions** with uniform template: Entry / Handler / Arguments / Flow / Code-snippets.
- **§Seven Patterns Worth Preserving** — each with §reusable-shape:
  1. §The `specials` extension point (mechanism preserved; `@apps` content removed).
  2. §CapTP over WebSocket (map-writer / map-reader composition).
  3. §Hostname-based dispatch (single HTTP server multiplexes via `{respond, connect}` per host).
  4. §Access token derivation (first 32 chars of formula ID; deterministic-unforgeable-token-without-additional-state).
  5. §Rate limiting (per-key next-allowed timestamp with lazy sweeping).
  6. §Connection lifecycle tracking (Promise.race between transport-close and CapTP-close).
  7. §Browser endowment collection (collectPropsAndBind: prototype-chain-traversal + method-binding + Compartment-conflict-exclusion).
- **§Note on the Next Rendition** — `@webs` as directory of pet-named web applications; readable-tree as content-addressed static content; future routing/dynamic-content named without commitment.
- **§Prompt-section preserves the removal instruction** verbatim — three named tasks: remove + leave-design + capture-detailed-description.
- **§Distinguishing extension-point from extension-content** — `@apps`-content removed; `specials`-mechanism preserved (defaults to `{}` in `makeDaemon`).
- **§Honest self-critique in design archaeology** — the design questions its own preserved patterns ("the new design should consider whether hostname-only isolation eliminates the need for explicit tokens").

## The Note-on-the-Next-Rendition shape

> The next iteration may use a special named `@webs` — a directory where each entry is a registered local HTTP web application, keyed by pet name. Each entry would combine some powers with a readable filesystem, producing a served web application. The filesystem should probably be restricted to a `readable-tree` so that the content address can be passed to a static file server.

§Forward-looking-without-commitment. §`@webs` proposed; §readable-tree-as-content-addressed-static-content named; §static-and-dynamic-routing-rules + §dynamic-content as §future-direction with §first-pass-static-serving-from-a-readable-tree as §sufficient-MVP.

## Convergence on content-addressed storage

§Cycle-204's-Note-on-the-Next-Rendition (readable-tree for static content) joins §cycle-202-endor-run-expanded's-root-hash-printed-to-stderr (CAS-content-addressing) and §cycle-178-daemon-xs-worker-snapshot's-CAS-streaming-snapshot — three cycles converging on §content-addressed-storage as the §substrate-for-stateless-or-quasi-stateless-services in the endor family.

## Ingest scope

Cycle 204 (designs-lane): full ingest of the 454-line design as one section. Cohesion-honest single-section because §the-document-is-structurally-one-archaeological-record with §uniform-component-descriptions and §seven-named-patterns.

## Related material in the library

- **`daemon-weblet-application.md`** (forward-looking successor; not yet ingested in this librarian session).
- **`familiar-unified-weblet-server.md`** (forward-looking successor; not yet ingested).
- **`familiar-chat-weblet-hosting.md`** (forward-looking successor; not yet ingested).
- **cycle 202 endo-but-for-bots--llm-designs-endor-run-expanded**: §root-hash-printed-to-stderr (CAS-content-addressing) sibling; readable-tree-as-content-addressed-static-content kinship.
- **cycle 178 endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot**: §CAS-streaming-snapshot sibling-pattern at different layer (worker-state vs static-content).
- **cycle 200 endo-but-for-bots--llm-designs-worker-rust-xs**: §Prompt-section-preserves-discard-prior-design-narrative sibling pattern at different evolution stage.
- **cycle 192 endo-but-for-bots--llm-designs-daemon-engo-supervisor**: §implicit-supersedes-lesson-learned sibling — both designs are §unrealized in different shapes (192 never shipped; 204 shipped and was removed).
- **cycle 196 endo-but-for-bots--llm-designs-endoclaw**: §Reference-status sibling — both are inventory documents, different purposes (196 is comparison; 204 is archaeology).
- **cycle 200 endo-but-for-bots--llm-designs-retention-path-notation**: §Reference-status-at-landing sibling — both are Reference for different reasons (200 is pre-emptive-supersedes; 204 is post-removal-archaeology).
- **cycle 105 daemon-capability-bank** (Design Principle 1: capabilities are objects, not configurations) — sibling to §the-`specials`-extension-point.
- **cycle 175 endo--packages-harden-make-selector**: §race-to-install-at-well-known-slot sibling — both derive stable identifiers from structure not from allocation.
- **cycle 156 endo--packages-eventual-send-finalize-js**: §weak-value-map-GC sibling — both designs track resources so cleanup is deterministic.
- **cycle 161 daemon-capability-filesystem**: §three-layer-architecture sibling — both designs provide host API to a Compartment with confinement discipline.

## Eight removed files

| File | Role |
|------|------|
| `packages/daemon/src/web-server-node.js` | Unified HTTP/WebSocket server and weblet factory |
| `packages/daemon/src/web-server-node-powers.js` | HTTP server powers (port binding, WebSocket upgrade) |
| `packages/daemon/src/web-page.js` | Browser-side bootstrap (CapTP client, bundle executor) |
| `packages/daemon/src/interfaces/web.js` | `WebPageControllerInterface` Exo interface |
| `packages/daemon/src/serve-private-port-http.js` | Alternate private-port HTTP server (dead code) |
| `packages/cli/src/commands/install.js` | CLI handler for `endo install` |
| `packages/cli/src/commands/open.js` | CLI handler for `endo open` |
| `packages/cli/demo/cat.js` | Demo weblet (permission management UI, ~1065 lines) |

The `@apps` special formula was removed from `daemon-node.js`. The `specials` mechanism in `makeDaemon` was preserved (defaults to `{}`).
