---
title: "familiar-chat-weblet-hosting — §two-part-status + §iframe-sandbox-confinement + §four-step-weblet-install + §two-CapTP-transports + §five-section-considerations"
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
---

# familiar-chat-weblet-hosting — Chat becomes a weblet host

A 223-line **Not Started** design (created 2026-02-14, updated 2026-02-26). Adds weblet-hosting affordance to the Familiar Chat UI: install, instantiate, and interact with confined weblet applications from within Chat — each with its own guest profile (identity, pet store, mailbox).

## §The-two-part-status

The opening §Status section has §two-part-shape:

> **Not yet implemented.** The Familiar-side infrastructure is ready (see `familiar-localhttp-protocol`):
> - `localhttp://` protocol handler serves weblet content with CSP confinement.
> - Navigation guard and exfiltration defenses are in place.
> - `preload.js` exposes `onSecurityWarnings` for the security warning banner.
>
> **Remaining work (all in `packages/chat/`):**
> - Weblet hosting panel UI...
> - MessagePort bridge...
> [...]

§Borrowable-pattern: §two-part-status (§Done-Elsewhere + §Remaining-Here) when a design §depends-on-predecessor-infrastructure-already-in-flight. §This-is-different-from-cycle-216's §Predecessor-section in §lal-transcript-memory-management — cycle 216 named §five-pieces-of-existing-infrastructure as inherited substrate; cycle 218 names §three-pieces-ready in a sibling design plus §five-pieces-remaining in this design's scope. §The-pattern-is-the-same-but-the-arrangement-is-different: §sibling-design-has-infrastructure-ready + §this-design-implements-the-consumer.

§Two-shapes-for-naming-predecessor-state:
1. cycle 216: §Predecessor section + §Existing-Infrastructure bullet list (parent-child relationship; parent is Complete; child is Not Started).
2. cycle 218: §Status section split into §Ready-in-sibling-design + §Remaining-here (peer relationship; sibling is Ready-but-not-this-design; this design is Not Started).

§Borrowable: §the-shape-of-the-Status-section-tracks-the-relationship-with-the-predecessor.

## §ASCII-mockup-of-UI

```
┌──────────────┬──────────────────────────────────┐
│  Inventory   │                                  │
│  ──────────  │                                  │
│  Handles     │                                  │
│  Hubs        │        Weblet iframe             │
│  Everything  │    (localhttp://<id>/ or         │
│              │     http://<id>.localhost:port/) │
│  Inbox       │                                  │
│  ──────────  │                                  │
│  Messages... │                                  │
│              │                                  │
│  Chat input  │                                  │
└──────────────┴──────────────────────────────────┘
```

§ASCII-mockup-of-the-target-UI inside the design. §Borrowable-pattern: §the-ASCII-mockup-shows-the-target-shape; §the-iframe-src-format is shown inline with §two-named-options (localhttp:// in Familiar OR http://<id>.localhost:port/ in development) — §two-environments-with-different-URL-conventions.

§Sibling to cycle 214's §ASCII-tree-diagram of branching transcripts — both designs §use-ASCII-for-shape-illustration.

## §iframe-sandbox-attribute-as-confinement

```html
<iframe
  src="localhttp://<weblet-id>/"
  sandbox="allow-scripts allow-same-origin allow-forms"
  allow="clipboard-write"
></iframe>
```

§Three-named-sandbox-permissions: `allow-scripts` / `allow-same-origin` / `allow-forms`. §One-named-allow-permission: `clipboard-write`. §The-iframe-boundary-enforces-confinement.

§Borrowable-pattern: §browser-iframe-as-the-confinement-substrate. §Sibling to:
- cycle 200 worker-rust-xs: §engine-level-confinement-via-XS-native-Compartment (different substrate, same purpose).
- cycle 212 outliner-design-doc: §custom-attenuation-code-in-SES-Compartment (different layer, same purpose).
- cycle 196 endoclaw: §ambient-vs-object-capability (the framing within which confinement happens).

§Four-cycles-using-different-substrates-for-confinement (200/212/196/218): XS native Compartment / SES Compartment / capability framing / iframe sandbox. §The-discipline-is-the-same-across-substrates.

## §weblet-profiles-guest-plus-handle (the §four-step-install)

```
1. Create a guest for the weblet:
   E(host).provideGuest(handlePetName, { agentName: webletAgentName })
2. Endow the guest with capabilities the user selects.
3. Install the weblet in the guest's worker.
4. Register the weblet with the unified server under the guest's handle identifier.
```

§Each-weblet-has-four-things:
- Its own pet store.
- Its own mailbox.
- Its own handle.
- Only the capabilities the host user explicitly granted.

§Borrowable-pattern: §guest-as-the-unit-of-application-installation — §the-application-IS-the-guest. §Sibling to cycle 210 lal-fae-form-provisioning's §inbox-as-durable-config-store; both designs use §existing-Endo-primitives-(guest + provideGuest + endow) as the §application-installation-substrate.

## §Power-levels-as-selectable-options

```
- `NONE`   — no endowments (pure sandboxed UI).
- `@endo`  — access to the Endo network (can look up capabilities by name).
- `@host`  — full host powers (development/trusted apps only).
- Custom   — select specific pet names to endow.
```

§Four-named-power-levels with §named-purpose-per-level. §The-`NONE`-power-level-is-the-safe-default (named explicitly in Security Considerations).

§Borrowable-pattern: §power-as-a-selectable-shape-with-safe-default + §custom-option-for-fine-grained-control + §development-mode-with-full-powers-named-as-such (§`@host`-is-explicitly-labeled-development/trusted-only). §Sibling to cycle 208 familiar-bundled-agents' §The-Powers-Problem-with-three-option-analysis; both designs §grapple-with-the-question-of-how-much-authority-to-grant-an-installed-application.

## §Two-CapTP-transports (WebSocket + MessagePort)

The design proposes §two-named-transports for the weblet's CapTP connection:

1. **WebSocket** (universal): weblet JS opens WebSocket to virtual host URL; unified server routes to weblet's connection handler.
2. **MessagePort** (Familiar-specific, more performant): Chat's main frame creates `MessageChannel`; one port transferred to weblet iframe via `postMessage`; CapTP runs over the `MessagePort` directly.

§The-design-names-MessagePort-as-a-stretch-goal:

> This is a stretch goal. The WebSocket approach works universally (including when weblets are opened in external browser tabs), while the MessagePort approach is Familiar-specific and more performant.

§Borrowable-pattern: §primary-transport-and-stretch-goal-transport with §the-stretch-goal-is-environment-specific-and-more-performant. §The-universal-transport-works-everywhere-but-pays-the-overhead; §the-specific-transport-is-cheaper-but-narrower-in-applicability. §Two-axes-of-trade-off-named-explicitly: §universality vs §performance.

§Borrowable-pattern: §when-a-design-proposes-two-transports-with-trade-offs, §name-the-trade-off-explicitly-and-mark-one-as-stretch.

## §Chat-commands surface

```
/install <bundle-name> [--as <weblet-name>] [--powers <level>]
/open <weblet-name>
/close
```

§Three-named-commands with §named-options for `/install`. §The-command-line-surface-is-the-other-way-to-do-what-the-UI-can-do. §Borrowable-pattern: §every-UI-action-also-has-a-command for §scripted-or-power-user-flows.

§Sibling to cycle 212 outliner-design-doc's §Meta+J-keyboard-shortcut (which is the third way to invoke an action). §Three-surfaces-for-the-same-action: UI-button + command + keyboard-shortcut. §Cycle-218-shows-two-of-the-three.

## §Affected-packages section

```
- `packages/chat`    — weblet panel UI, install flow, iframe hosting, commands
- `packages/daemon`  — may need a combined "create guest + install weblet" API
                       for atomicity
```

§Borrowable-pattern: §Affected-Packages-section with §named-reason-per-package. §The-daemon-change-is-named-as-tentative ("may need"); §the-chat-change-is-named-as-definite.

§Note-the-atomicity-concern: §combined-create-guest-and-install-weblet-API-for-atomicity. §Borrowable-pattern: §atomicity-as-a-design-driver — §two-steps-that-must-succeed-or-fail-together belong in §a-combined-API. §Sibling to cycle 162 daemon-Ken-protocol's §atomic-checkpoint and cycle 203 cache-map's §don't-establish-entry-until-prior-steps-succeed.

## §Three-named-dependencies

```
- familiar-gateway-migration       — weblets connect via the daemon gateway.
- familiar-unified-weblet-server   — weblets are served from a single port.
- inventory-grouping-by-type       — weblets benefit from being grouped in the inventory.
```

§Three-sibling-designs-as-named-dependencies. §Each-dependency-has-a-named-reason for the dependency.

§Borrowable-pattern: §dependencies-section-with-named-reason-per-dependency. §Sibling to cycle 217's @endo/errors §enumerate-required-methods-and-tolerate-missing-ones — both designs §enumerate-and-name-each-dependency.

## §Five-section-considerations

The design has §five-distinct-Considerations-sections:

1. **Security Considerations** (six bullet items): iframe-sandboxed; can't access Chat's DOM; capabilities-only-by-explicit-grant; `localhttp://`-origin-isolation; can't navigate top-level window.
2. **Scaling Considerations** (two bullet items): renderer-process-per-iframe → memory; daemon-worker-lifecycle-already-managed.
3. **Test Plan** (five bullets): install + verify guest powers + CapTP + isolation + UI test.
4. **Compatibility Considerations**: existing functionality preserved; per-port weblets work in unified-server without changes.
5. **Upgrade Considerations**: pre-existing CLI-installed weblets need reinstall to get guest-profile affordances.

§Five-section-considerations-shape — §a-rich-design-document-pattern. §Borrowable-pattern: §each-Considerations-section-names-a-different-concern + §a-design-with-multiple-stakeholders-needs-multiple-sections.

§The-Upgrade-Considerations-section is particularly notable:

> Weblets installed before this change (via CLI) won't have guest profiles. They'll appear as regular capabilities in the inventory without the weblet affordances. Users can reinstall them through Chat to get the full experience.

§Borrowable-pattern: §when-a-new-design-creates-a-new-shape-for-old-data, §name-the-migration-path-explicitly. §`Upgrade-Considerations`-as-a-distinct-section-from-`Compatibility-Considerations`: compatibility names §what-keeps-working; upgrade names §what-the-user-needs-to-do-to-get-the-new-features.

## §Eighteenth-honest-design-evolution-record family member (with a new shape)

§The-`familiar-localhttp-protocol`-is-Ready and §the-Chat-side-is-Not-Started — the §evolution-is-visible-via-the-two-part-status. §Two-design-documents-with-asymmetric-implementation-progress. §Sibling to cycle 216's §design-evolution-visible-across-two-documents (where cycle 214 was Complete and cycle 216 was Not Started).

§Two-different-shapes-for-design-evolution-across-two-documents:
- Cycle 216: §Parent-Complete + §Child-Not-Started (parent-child via Predecessor).
- Cycle 218: §Sibling-Ready + §This-Not-Started (siblings via shared infrastructure).

§The-pattern-grows-to-eighteen-shapes.

## §Six-completed-Familiar-cluster-designs in library after cycle 218

| Cycle | Design | Status |
|-------|--------|--------|
| 174 | familiar-electron-shell | shipped |
| 176 | familiar-daemon-bundling | shipped |
| 182 | familiar-gateway-migration | shipped |
| 184 | familiar-unified-weblet-server | shipped |
| 208 | familiar-bundled-agents | shipped |
| 218 | familiar-chat-weblet-hosting | Not Started (Familiar-side infrastructure ready) |

§Six-design-cluster for §the-Familiar-feature.

## Related material in the library

- **familiar-localhttp-protocol** (not yet ingested): §sibling-with-ready-infrastructure named explicitly in the §Status section.
- **familiar-unified-weblet-server** (cycle 184): §sibling at the network-layer.
- **familiar-gateway-migration** (cycle 182): §sibling at the connection-routing-layer.
- **familiar-bundled-agents** (cycle 208): §sibling at the agent-installation-layer; §The-Powers-Problem-with-three-option-analysis from cycle 208 informs cycle 218's §power-levels-as-selectable-options.
- **familiar-daemon-bundling** (cycle 176): §sibling at the daemon-packaging-layer.
- **familiar-electron-shell** (cycle 174): §sibling at the Electron-host-layer.
- **cycle 210 lal-fae-form-provisioning**: §guest-as-the-unit-of-installation sibling.
- **cycle 212 outliner-design-doc**: §`Meta+J`-keyboard-shortcut + §reference-scoping-no-upward-traversal siblings (this design's iframe-sandbox is the §browser-substrate analog).
- **cycle 196 endoclaw**: §ambient-vs-object-capability framing.
- **cycle 200 worker-rust-xs**: §engine-level-confinement-via-XS-native-Compartment sibling at the §confinement-substrate-comparison.
- **cycle 162 daemon-Ken-protocol + cycle 203 cache-map**: §atomicity-as-design-driver siblings.

## §Library-reaches-724-sections at cycle 218 (designs-lane familiar-chat-weblet-hosting).

## §Fifty-second consecutive designs-chat alternation cycle 166-218.
