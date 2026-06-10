---
title: "daemon-weblet-application.md — canonical template instantiation + five numbered deliverables at top + eight numbered Security Considerations + two named gateway isolation modes + additive template extension (five sections beyond the canonical seven) + named branch as prerequisite (kriskowal-zip-compression)"
source-slug: endo-but-for-bots--llm-designs-daemon-weblet-application
section-slug: canonical-template-instantiation-and-five-deliverables-at-top-and-eight-security-considerations-and-two-gateway-isolation-modes-and-additive-template-extension
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-weblet-application.md
source-repo: endojs/endo-but-for-bots
source-path: designs/daemon-weblet-application.md
source-author: Kris Kowal (prompted)
total-lines: 985
ingest-cycle: 275
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `daemon-weblet-application.md` — Weblet Applications from Zip Archives

A 985-line design (Status Not Started; Created 2026-02-25; Updated 2026-02-25) that **introduces additive template extension as a named deviation shape** — adds **five extra sections** beyond the canonical-template's seven (Security Considerations + Scaling Considerations + Test Plan + Compatibility Considerations + Upgrade Considerations).

§First-explicit-observation in library: **§the-design-adds-five-extra-sections-beyond-the-canonical-template — §the-template's-flexibility-clause-addresses-omission-not-extension + §additive-extension-IS-implicit-permission-rather-than-explicit + §the-cluster-now-has-three-named-template-deviation-shapes (subtractive-fragment + subtractive-guide + additive-extension)**.

§Three-cycles-with-template-deviation-in-the-cluster:
- **Cycle 263** — design-fragment (subtractive: no metadata table; in-flight).
- **Cycle 273** — guide (subtractive: no metadata table; comprehensive guide).
- **Cycle 275** — additive-extension (full template plus five extra sections; richer specification).

## §Five numbered deliverables at the top of the Problem Statement

Lines 22-36 carry §five-numbered-deliverables in the Problem Statement:

1. A **formula for a readable tree** — transitively read-only directory of blobs and sub-trees.
2. A **zip extraction operation** — decompresses a zip archive into readable-blob formulas.
3. A **formula for a weblet** — combining a readable tree with a powers reference.
4. **Gateway integration** — unified weblet server serves files from the readable tree.
5. **Chat and CLI verbs** — `mkweblet` + `open` commands to create the full chain.

§First-explicit-observation in library: **§five-numbered-deliverables-enumerated-at-the-top-of-the-Problem-Statement — §the-design-NAMES-the-five-deliverables-up-front + §the-reader-can-track-each-deliverable-through-the-design-sections + §the-cluster-has-cycle-269's-six-Phases-and-cycle-271's-five-Phases-and-now-cycle-275's-five-deliverables**.

§Three-cycles-with-numbered-deliverable-or-phase-lists-at-the-top (269 + 271 + 275); §the-discipline-IS-now-emergent.

## §Named branch as prerequisite — kriskowal-zip-compression

Lines 42-58 carry an §explicit-Prerequisites-section naming a branch (`kriskowal-zip-compression`) that must be merged before implementation begins.

§First-explicit-observation in library: **§explicit-Prerequisites-section-naming-required-merges-or-prior-work + §named-branch-as-prerequisite — §the-design-NAMES-not-just-the-prior-designs-but-also-the-named-git-branch-that-supplies-required-infrastructure (DEFLATE compression for zip)**.

§Three-named-features-of-the-kriskowal-zip-compression-branch:
1. §`zip/deflate` and `zip/inflate` using Web `CompressionStream` / `DecompressionStream` APIs.
2. §Updated `ZipWriter` and `ZipReader` with async `set()` / `get()` methods.
3. §CRC-32 integrity checking + backward compatibility.

§First-explicit-observation in library: **§the-Prerequisites-section-as-named-place-where-named-branches-of-the-source-repo-are-listed — §sibling-pattern to many engineering designs that name a feature-branch as a prerequisite + §the-cluster-makes-this-discipline-explicit**.

## §Two named gateway isolation modes — Mode A + Mode B

Lines 424-487 carry §two-named-gateway-isolation-modes with `A` and `B` labels:

- **Mode A: Virtual host on the unified server** — each weblet has a distinct hostname in the `Host` header (the access token).
- **Mode B: Dedicated port on 127.0.0.1** — each weblet has its own port.

§First-explicit-observation in library: **§two-named-gateway-isolation-modes-with-A-and-B-labels — §two-named-architectural-alternatives + §each-mode-IS-a-named-deployment-shape + §the-design-supports-both-not-just-one**.

§Both modes share the same security goal: §origin-isolation. §the-discipline-IS-modal-not-monolithic; §sibling-pattern to many systems with multiple deployment shapes (e.g., k8s deployment vs. statefulset).

## §Eight numbered Security Considerations — the richest Security section ingested

Lines 838-886 carry **eight numbered Security Considerations**:

1. **Readable trees are immutable** — prevents §time-of-check/time-of-use attacks.
2. **Path traversal prevention** — single-segment-name + multi-segment-lookup-chain via `E()`; §no-path-string-parsing-discipline.
3. **Content type inference is conservative** — unknown extensions → `application/octet-stream` (browsers won't execute as script); §inferred-by-extension-only-no-content-sniffing-to-avoid-MIME-confusion-attacks.
4. **Guest isolation** — `NONE` power level for fully sandboxed weblet.
5. **Chrome/weblet barrier** — close tab rendered by Chat's host frame above the iframe; prevents §UI-deception-attacks.
6. **MessagePort CapTP isolation** — MessagePort transferred from Chat to iframe; weblet cannot discover other weblets' ports.
7. **Origin isolation** — distinct hostname (Mode A) OR distinct port (Mode B); prevents §cross-weblet-cookie-localStorage-and-DOM-access.
8. **No ambient network access** — weblets have no inherent network capabilities; explicit-capability-grant-discipline.
9. **Zip bomb mitigation** — per-blob size limit + bounded by finite number of entries in the archive.

§First-explicit-observation in library: **§eight-numbered-Security-Considerations — the-richest-Security-section-cycle-ingested + §each-consideration-IS-a-named-attack-class-and-named-defense + §the-section-IS-the-design's-threat-model-record**.

§Sibling-pattern to cycle 269's eleven Design Decisions + cycle 271's ten Design Decisions; §three-cycles-with-numbered-rationale-sections-of-comparable-depth (269 + 271 + 275); §each-design-NAMES-its-attack-classes-and-defenses-as-numbered-items.

## §Three named attack classes named explicitly

The Security section names **three attack classes** by name:

1. **§time-of-check/time-of-use attacks** (line 843) — prevented by immutability.
2. **§MIME confusion attacks** (line 855) — prevented by extension-based inference.
3. **§UI deception attacks** (line 865) — prevented by chrome/weblet barrier.
4. **§cross-weblet cookie/localStorage/DOM access** (line 876) — prevented by origin-isolation.
5. **§zip bombs** (line 882) — prevented by per-blob size limit.

§First-explicit-observation in library: **§named-attack-classes-as-named-threat-model-vocabulary — §five-named-attack-classes (TOCTOU + MIME-confusion + UI-deception + cross-origin-DOM + zip-bomb) + §each-class-IS-a-named-named-threat-the-design-defends-against + §the-design-IS-an-explicit-threat-model**.

§Sibling-pattern to cycle 259's three-named-non-exposures (Page interface) and cycle 261's three-named-non-exposures (HttpClient) — but here the attacks are named as well as the defenses.

§First-explicit-observation in library: **§the-attacks-named-as-well-as-the-defenses-IS-the-discipline-of-an-explicit-threat-model — §sibling-pattern to many security-engineering conventions**.

## §"chrome/weblet barrier" — the named UI deception defense

Line 862-865:
> *Chrome/weblet barrier. The weblet close tab is rendered by Chat's host frame, above the iframe boundary. The weblet cannot obscure, relocate, or impersonate the close control. This prevents UI deception attacks where a weblet renders fake chrome to trick the user.*

§First-explicit-observation in library: **§the-chrome/weblet-barrier-as-named-UI-deception-defense — §the-close-tab-IS-rendered-by-the-host-frame-not-the-iframe + §the-weblet-cannot-obscure-relocate-or-impersonate-the-close-control + §the-discipline-IS-UI-trust-rooted-in-the-host-frame**.

§Three-named-things-the-weblet-cannot-do (obscure + relocate + impersonate); §the-discipline-IS-asymmetric: the-host-frame-CAN-render-above-the-iframe + the-iframe-CANNOT-render-above-the-host-frame.

§Sibling-pattern to OS-level window-manager conventions for trusted UI; §the-Chat-IS-the-trusted-window-manager-for-its-weblets.

## §"No ambient network access" — the fifth confinement-by-omission cycle

Line 878-880:
> *No ambient network access. Weblets served from readable trees have no inherent network capabilities. Network access requires an explicit capability grant through the guest's powers.*

§Sibling-pattern to:
- **Cycle 259** — Page interface non-exposures (cookies + localStorage + network requests).
- **Cycle 261** — HttpClient non-exposures (net.connect + dns.resolve + non-HTTP/HTTPS protocols).
- **Cycle 271** — XS-worker non-exposures (FD + stdout + controlling terminal + TTY + ANSI escapes).
- **Cycle 275** — Weblet non-exposures (no inherent network capabilities; explicit grant required).

§Four-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271 + 275); §the-discipline-IS-now-canonical-across-the-cluster.

§First-explicit-observation in library: **§four-cycles-with-named-non-exposures-as-design-feature-not-limitation — §the-discipline-IS-now-canonical-across-four-different-substrates (DOM + HTTP + XS-worker + weblet)**.

## §Two named formula types introduced — readable-tree + readable-tree-weblet

Lines 85-422 carry §two-named-formula-types:

1. **`readable-tree`** — a transitively read-only directory of blobs and sub-trees (lines 85-285).
2. **`readable-tree-weblet`** — a readable tree paired with a powers reference (lines 385-422).

§First-explicit-observation in library: **§two-named-formula-types-introduced-by-one-design — §the-design-introduces-a-substrate-formula-AND-its-application-formula + §the-pair-IS-substrate-and-application + §sibling-pattern to many engineering designs where one design ships two related new types**.

§Each-formula-type-has-its-own-set-of-sub-sections: §Formula-shape + §Incarnated-interface + §What-is-absent + §help()-text + §Relationship-to-EndoDirectory + §Relationship-to-the-capability-filesystem.

§First-explicit-observation in library: **§six-named-sub-sections-per-formula-type — §the-discipline-IS-uniform + §each-formula-type-IS-documented-with-the-same-six-aspects + §sibling-pattern to API-documentation conventions**.

§The-`#### What is absent` sub-section (lines 153-172 for readable-tree) is structurally interesting — §the-design-NAMES-what-the-formula-does-NOT-have; §sibling-pattern to cycle 259's §confinement-by-omission discipline.

§First-explicit-observation in library: **§a-`#### What is absent`-sub-section-as-named-design-discipline — §when-a-formula-type-has-deliberate-omissions, §a-dedicated-sub-section-names-them**.

## §Two named CapTP transports — MessagePort + WebSocket fallback

Lines 565-633 carry §two-named-CapTP-transports:

- **Primary**: MessagePort (iframe-to-host communication; transferred from Chat).
- **Fallback**: WebSocket (external browser; for weblets opened outside Chat).

§First-explicit-observation in library: **§two-named-CapTP-transports-with-primary-and-fallback-shape — §the-design-supports-both-the-iframe-case-and-the-external-browser-case + §the-discipline-IS-graceful-degradation**.

§Sibling-pattern to many systems with primary+fallback transports.

## §Chat and CLI verbs — three named verbs

Lines 634-795 introduce §three-named-CLI/Chat-verbs:

1. **`mkweblet`** (lines 641-704) — creates the full chain (handle + guest + content + weblet).
2. **`open`** (lines 705-774) — opens the weblet in an iframe.
3. **Host interface additions** (lines 776-795) — new methods on the host interface.

§the-verbs-IS-named-with-shell-friendly-conciseness (`mkweblet` not `make-weblet-application`); §the-discipline-IS-CLI-ergonomic + §the-cluster-has-similar-conciseness-discipline-elsewhere.

§First-explicit-observation in library: **§CLI-verb-naming-IS-shell-friendly-concise (`mkweblet` instead of `make-weblet-application`) — §sibling-pattern to UNIX conventions (`mkdir` not `make-directory`)**.

## §Four-row Affected packages list

Lines 814-826 carry §four-affected-packages list:

1. `packages/daemon` — new formula types + zip extraction.
2. `packages/daemon/src/web-server-node.js` — gateway static file serving.
3. `packages/cli` — `mkweblet` + `open` commands.
4. `packages/chat` — `/mkweblet` + `/open` commands + weblet pane.
5. `packages/zip` — dependency (needs `kriskowal-zip-compression` merge).

§First-explicit-observation in library: **§explicit-Affected-packages-section-listing-which-packages-must-change — §the-design-NAMES-the-implementation-blast-radius + §the-reader-can-estimate-effort-by-counting-packages + §sibling-pattern to many engineering-doc conventions**.

## §The `## Maybe` section — named place for tentative test items

Lines 950-957 (a sub-section of Test Plan) carry §the-Maybe-section — items the design author flags as possibly worth testing but not committed to.

§First-explicit-observation in library: **§the-`## Maybe`-section-as-named-place-for-tentative-test-items — §the-design-distinguishes-committed-test-items-from-tentative-items + §the-`## Maybe`-heading-IS-the-named-convention**.

§Sibling-pattern to many engineering-doc conventions for partial commitments; §the-section-IS-a-named-deferral-marker.

## §Cycle 275 first-explicit-observations roundup (twelve)

1. §the-design-adds-five-extra-sections-beyond-the-canonical-template (Security + Scaling + Test Plan + Compatibility + Upgrade).
2. §three-named-template-deviation-shapes (subtractive-fragment + subtractive-guide + additive-extension).
3. §five-numbered-deliverables-enumerated-at-the-top-of-the-Problem-Statement.
4. §explicit-Prerequisites-section-naming-required-merges-or-prior-work + §named-branch-as-prerequisite (kriskowal-zip-compression).
5. §two-named-gateway-isolation-modes-with-A-and-B-labels (virtual host on unified server + dedicated port on 127.0.0.1).
6. §eight-numbered-Security-Considerations — the richest Security section cycle-ingested.
7. §named-attack-classes-as-named-threat-model-vocabulary (TOCTOU + MIME-confusion + UI-deception + cross-origin-DOM + zip-bomb).
8. §the-attacks-named-as-well-as-the-defenses-IS-the-discipline-of-an-explicit-threat-model.
9. §the-chrome/weblet-barrier-as-named-UI-deception-defense.
10. §four-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271 + 275).
11. §two-named-formula-types-introduced-by-one-design (readable-tree + readable-tree-weblet).
12. §six-named-sub-sections-per-formula-type (Formula-shape + Incarnated-interface + What-is-absent + help() + Relationship-to-EndoDirectory + Relationship-to-the-capability-filesystem).

Plus: §a-`#### What is absent`-sub-section-as-named-design-discipline + §two-named-CapTP-transports-with-primary-and-fallback-shape + §CLI-verb-naming-IS-shell-friendly-concise (`mkweblet`) + §explicit-Affected-packages-section + §the-`## Maybe`-section-as-named-place-for-tentative-test-items.

## §Recurring meta-pattern counters bumped at cycle 275

- §**three-cycles-with-template-deviation-in-the-cluster** (263 subtractive-fragment + 273 subtractive-guide + 275 additive-extension).
- §**four-cycles-with-named-non-exposures-as-design-feature-not-limitation** (259 + 261 + 271 + 275).
- §**three-cycles-with-numbered-rationale-sections-of-comparable-depth** (269 eleven Design Decisions + 271 ten Design Decisions + 275 eight Security Considerations).
- §**three-cycles-with-numbered-deliverable-or-phase-lists-at-the-top** (269 + 271 + 275).
- §**eighteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (cycle 273's count + cycle 275 daemon-weblet-application).
- §**one-hundred-and-eighth consecutive designs-chat alternation cycles 166-250 + 252-275** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-additive-template-extension applies to the §game-engine-cluster:

- §**§game-engine-design with additional sections** — when a design's content warrants more than the canonical seven sections (Security + Scaling + Test Plan + Compatibility + Upgrade), the additive-extension shape IS the discipline.
- §**§five-numbered-deliverables at the top** for game-engine-feature designs.
- §**§explicit Prerequisites section** naming required game-rule branches or prior game-features.
- §**§named-branch-as-prerequisite** when a game-engine design depends on in-progress game-engine-branch work.
- §**§eight-numbered Security Considerations** for game-engine-protocol designs.
- §**§named attack classes** as the threat-model vocabulary (game-cheating + game-state-tampering + game-UI-deception + cross-player-state-access + game-bomb-mitigation).
- §**§chrome/game-rule-barrier** — game-rule rendering area distinct from game-engine chrome; prevents game-rule-UI-deception.
- §**§two-named-gateway-isolation-modes** for game-engine deployment (virtual-host + dedicated-port).
- §**§the-`#### What is absent`-sub-section** for naming what a game-engine-formula does NOT have.
- §**§the-`## Maybe`-section** for tentative game-rule test items.

## §Tier-1 borrowing

§the-design-adds-five-extra-sections-beyond-the-canonical-template + §three-named-template-deviation-shapes + §five-numbered-deliverables-at-top + §explicit-Prerequisites-section + §named-branch-as-prerequisite + §two-named-gateway-isolation-modes-with-A-and-B-labels + §eight-numbered-Security-Considerations + §named-attack-classes-as-named-threat-model-vocabulary + §the-attacks-named-as-well-as-the-defenses-IS-the-discipline-of-an-explicit-threat-model + §the-chrome/weblet-barrier-as-named-UI-deception-defense + §two-named-formula-types-introduced-by-one-design + §six-named-sub-sections-per-formula-type.

## §Tier-2 borrowing

§a-`#### What is absent`-sub-section + §two-named-CapTP-transports-with-primary-and-fallback-shape + §CLI-verb-naming-IS-shell-friendly-concise + §explicit-Affected-packages-section + §the-`## Maybe`-section.

## §Tier-3 borrowing

§three-cycles-with-template-deviation-in-the-cluster (263 + 273 + 275) + §four-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271 + 275) + §three-cycles-with-numbered-rationale-sections-of-comparable-depth (269 + 271 + 275) + §three-cycles-with-numbered-deliverable-or-phase-lists-at-the-top (269 + 271 + 275) + §eighteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §library-reaches-781-sections at cycle 275 + §one-hundred-and-eighth consecutive designs-chat alternation cycles 166-250 + 252-275.

## Pattern summary (tag-prefixed)

§Weblet-Applications-from-Zip-Archives + §the-design-adds-five-extra-sections-beyond-the-canonical-template (Security + Scaling + Test Plan + Compatibility + Upgrade) + §three-named-template-deviation-shapes (subtractive-fragment + subtractive-guide + additive-extension) + §five-numbered-deliverables-at-the-top-of-the-Problem-Statement + §explicit-Prerequisites-section + §named-branch-as-prerequisite (kriskowal-zip-compression) + §two-named-gateway-isolation-modes-with-A-and-B-labels + §eight-numbered-Security-Considerations + §named-attack-classes-as-named-threat-model-vocabulary (TOCTOU + MIME-confusion + UI-deception + cross-origin-DOM + zip-bomb) + §the-attacks-named-as-well-as-the-defenses + §the-chrome/weblet-barrier-as-named-UI-deception-defense + §four-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271 + 275) + §two-named-formula-types-introduced-by-one-design (readable-tree + readable-tree-weblet) + §six-named-sub-sections-per-formula-type + §the-`#### What is absent`-sub-section-as-named-design-discipline + §two-named-CapTP-transports-with-primary-and-fallback-shape + §CLI-verb-naming-IS-shell-friendly-concise (`mkweblet`) + §explicit-Affected-packages-section + §the-`## Maybe`-section-as-named-place-for-tentative-test-items + §three-cycles-with-template-deviation-in-the-cluster (263 + 273 + 275) + §three-cycles-with-numbered-rationale-sections-of-comparable-depth (269 + 271 + 275) + §three-cycles-with-numbered-deliverable-or-phase-lists-at-the-top (269 + 271 + 275).
