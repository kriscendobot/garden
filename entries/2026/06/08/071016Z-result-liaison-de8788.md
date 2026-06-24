---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T07:10:16Z
dispatch_root: /home/kris/garden/dispatches/liaison--de8788
---

# Librarian cycle 218 (designs-lane) — familiar-chat-weblet-hosting ingested

Cycle 218 alternates back to designs-lane after cycle 217's chat-lane (@endo/errors). §Fifty-second consecutive designs-chat alternation cycle.

## Source

`endojs/endo-but-for-bots designs/familiar-chat-weblet-hosting.md` — 223 lines, Status **Not Started** (with Familiar-side infrastructure ready in sibling `familiar-localhttp-protocol`). Adds weblet-hosting affordance to the Familiar Chat UI.

## What landed

- **Section file**: `library/sections/endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations.md`.
- **Source page**: `library/sources/endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting.md`.
- **Sources/README.md**: new row inserted above the cycle 217 @endo/errors row.
- **Sections/README.md**: new section entry + Total bumped to "724 sections from 265 source documents".
- **keywords.md**: ~33 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-218`; last_drained_at updated to 2026-06-08.

## Borrowable patterns

- §Two-part-status (Done-Elsewhere + Remaining-Here) when a design §depends-on-predecessor-infrastructure-already-in-flight.
- §The-shape-of-the-Status-section-tracks-the-relationship-with-the-predecessor (cycle 216 parent-child via Predecessor section + cycle 218 sibling via two-part-Status).
- §ASCII-mockup-of-UI inside the design (sibling to cycle 214's ASCII tree diagram).
- §iframe-sandbox-attribute-as-confinement with §three-named-sandbox-permissions + §browser-iframe-as-the-confinement-substrate.
- §Four-step-weblet-install: create-guest → endow → install → register; §guest-as-the-unit-of-application-installation — §the-application-IS-the-guest.
- §Power-levels-as-selectable-options with §NONE-as-safe-default and §`@host`-explicitly-labeled-development/trusted-only.
- §Two-CapTP-transports with §named-trade-off-axes (universality vs performance); §primary-transport-and-stretch-goal-transport.
- §Three-chat-commands; §every-UI-action-also-has-a-command; §three-surfaces-for-the-same-action (UI + command + keyboard-shortcut, with the third deferred to a sibling design).
- §Atomicity-as-design-driver — §combined-create-guest-and-install-weblet-API.
- §Three-named-dependencies-with-named-reason-per-dependency.
- §Five-section-considerations (Security / Scaling / Test Plan / Compatibility / Upgrade).
- §Upgrade-Considerations-distinct-from-Compatibility-Considerations — §compatibility-names-what-keeps-working; §upgrade-names-what-the-user-needs-to-do.

## Meta-observations

- §Eighteenth-honest-design-evolution-record family member with a new shape: §two-design-documents-with-asymmetric-implementation-progress (sibling-Ready + this-Not-Started). Two distinct shapes for design-evolution-across-two-documents now in library:
  - Cycle 216: parent-Complete + child-Not-Started (via Predecessor section).
  - Cycle 218: sibling-Ready + this-Not-Started (via two-part Status).
- §Six-completed-Familiar-cluster-designs now in library: cycles 174 / 176 / 182 / 184 / 208 / 218.
- §Four-cycles-using-different-substrates-for-confinement: cycle 200 worker-rust-xs (XS Compartment) + cycle 212 outliner (SES Compartment) + cycle 196 endoclaw (capability framing) + cycle 218 (iframe sandbox).
- §Fifty-second consecutive designs-chat alternation, cycles 166-218.
- §Library-reaches-724-sections at cycle 218.
- Papers-lane blocked 112+ consecutive cycles.

## Next

Cycle 219 will be chat-lane (alternating from cycle 218's designs-lane). ScheduleWakeup for ~25 min.
