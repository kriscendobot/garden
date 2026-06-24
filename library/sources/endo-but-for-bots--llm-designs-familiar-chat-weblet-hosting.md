---
title: "familiar-chat-weblet-hosting — Chat becomes a weblet host with iframe-sandbox confinement and guest-as-unit-of-installation"
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
total-lines: 223
status: Not Started (Familiar-side infrastructure ready in sibling familiar-localhttp-protocol)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
---

# familiar-chat-weblet-hosting.md

A 223-line **Not Started** design adding weblet-hosting affordance to the Familiar Chat UI. Users can install, instantiate, and interact with confined weblet applications from within Chat — each with its own guest profile (identity, pet store, mailbox).

## Key design moves

- **§Two-part-status** — §Done-Elsewhere (familiar-localhttp-protocol Ready) + §Remaining-Here (five bullets in packages/chat/).
- **§ASCII-mockup-of-UI** showing sidebar + iframe panel.
- **§iframe-sandbox-attribute-as-confinement** with §three-named-sandbox-permissions + §one-named-allow.
- **§Four-step-weblet-install**: create-guest → endow → install → register.
- **§Power-levels-as-selectable-options**: NONE / @endo / @host / Custom with §NONE-as-safe-default.
- **§Two-CapTP-transports**: WebSocket (universal) + MessagePort (Familiar-specific, stretch goal, more performant) with §named-trade-off-axes (universality vs performance).
- **§Three-chat-commands** (`/install` / `/open` / `/close`) as §every-UI-action-also-has-a-command.
- **§Affected-Packages** section with §named-reason-per-package + §atomicity-as-design-driver for the combined create-guest-and-install API.
- **§Three-named-dependencies** on sibling designs.
- **§Five-section-considerations**: Security / Scaling / Test Plan / Compatibility / Upgrade — each names a different concern.
- **§Upgrade-Considerations distinct from Compatibility-Considerations** — compatibility names §what-keeps-working; upgrade names §what-the-user-needs-to-do.
- **§Eighteenth honest-design-evolution-record family member** with §two-design-documents-with-asymmetric-implementation-progress shape.
- **§Six-completed-Familiar-cluster-designs** in library after cycle 218.

## Section files

- [§two-part-status + §iframe-sandbox-confinement + §four-step-weblet-install + §two-CapTP-transports + §five-section-considerations](../sections/endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations.md) — full design ingest.

## Ingest scope

Cycle 218 (designs-lane): full ingest of the 223-line design as one section. §Sixth-member of the Familiar cluster (174 + 176 + 182 + 184 + 208 + 218).
