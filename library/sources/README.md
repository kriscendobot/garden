# Sources

Per-source-document inventory. Each row points to a `<source-slug>.md` file that lists the section files derived from that source, with provenance metadata (commit, date, authors, ingestion date).

The pilot batch (2026-05-13) covers three endo top-level / docs-level files. The rest of the endo corpus (~70 substantive markdown files: top-level, `docs/`, per-package READMEs, per-package `docs/` and `doc/` directories) is queued for future ingestion batches; the index will grow as those are filed.

## Ingested

| Source | Repo | Last-modified | Primary author | Sections | Status |
|--------|------|---------------|----------------|----------|--------|
| [AGENTS.md](endo--agents.md) | endojs/endo | 2026-03-21 | Turadg Aleahmad | 6 | current |
| [designs/daemon-persistence.md](endo--designs-daemon-persistence.md) | endojs/endo (PR #3121 draft, branch `kriskowal-doc-formula-persistence`) | 2026-03-08 | Kris Kowal | 7 | current (**unmerged draft PR**; thesis document for Formula Persistence — petname graph as persistence root; destruction by cohort + reconstruction on demand; revocation by withdrawal of constructor; four-tables coordinated retention) |
| [docs/security.md](endo--docs-security.md) | endojs/endo | 2025-09-25 | Kris Kowal | 3 | current |
| [docs/errors.md](endo--docs-errors.md) | endojs/endo | 2025-09-25 | Kris Kowal | 7 | current |
| [docs/lockdown.md](endo--docs-lockdown.md) | endojs/endo | 2025-09-25 | Kris Kowal | 15 | current |
| [docs/bugs.md](endo--docs-bugs.md) | endojs/endo | 2025-09-25 | Kris Kowal | 1 | current |
| [docs/get-started.md](endo--docs-get-started.md) | endojs/endo | 2025-12-04 | Kris Kowal | 6 | current |
| [docs/reference.md](endo--docs-reference.md) | endojs/endo | 2026-04-26 | Kris Kowal | 9 | current (overlaps docs/lockdown.md) |
| [packages/daemon/README.md](endo--pkg-daemon-readme.md) | endojs/endo | 2022-12-08 | Kris Kowal | 1 | current |
| [packages/marshal/README.md](endo--pkg-marshal-readme.md) | endojs/endo | 2024-02-05 | Richard Gibson + Kris Kowal | 7 | current |
| [packages/pass-style/README.md](endo--pkg-pass-style-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 11 | current |
| [packages/exo/README.md](endo--pkg-exo-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 11 | current |
| [packages/patterns/README.md](endo--pkg-patterns-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 10 | current |
| [packages/eventual-send/README.md](endo--pkg-eventual-send-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 14 | current |
| [packages/ses/README.md](endo--pkg-ses-readme.md) | endojs/endo | 2025-09-25 | Kris Kowal | 9 | current |
| [docs/message-passing.md](endo--docs-message-passing.md) | endojs/endo | 2026-01-04 | Kris Kowal | 9 | current |
| [docs/guide.md](endo--docs-guide.md) | endojs/endo | 2025-09-25 | Kris Kowal | 10 | current (multi-source overlaps) |
| [packages/captp/README.md](endo--pkg-captp-readme.md) | endojs/endo | 2022-01-13 | Kris Kowal | 4 | current |
| [packages/marshal/docs/smallcaps-cheatsheet.md](endo--pkg-marshal-docs-smallcaps-cheatsheet.md) | endojs/endo | 2026-02-02 | Mark S. Miller | 1 | current |
| [packages/pass-style/doc/copyArray-guarantees.md](endo--pkg-pass-style-doc-copyarray-guarantees.md) | endojs/endo | 2023-11-30 | Kris Kowal | 1 | current |
| [packages/pass-style/doc/copyRecord-guarantees.md](endo--pkg-pass-style-doc-copyrecord-guarantees.md) | endojs/endo | 2023-11-30 | Kris Kowal | 1 | current |
| [packages/pass-style/doc/enumerating-properties.md](endo--pkg-pass-style-doc-enumerating-properties.md) | endojs/endo | 2023-11-30 | Kris Kowal | 1 | current |
| [packages/patterns/docs/marshal-vs-patterns-level.md](endo--pkg-patterns-docs-marshal-vs-patterns-level.md) | endojs/endo | 2025-05-02 | Mark S. Miller | 3 | current |
| [packages/exo/docs/exo-taxonomy.md](endo--pkg-exo-docs-exo-taxonomy.md) | endojs/endo | 2023-01-27 | Mark S. Miller | 5 | current |
| [CONTRIBUTING.md](endo--contributing.md) | endojs/endo | 2026-01-08 | Kris Kowal | 6 | current |
| [draft-specifications/Model.md](ocapn--draft-specifications-model.md) | kriscendobot/ocapn | 2025-06-23 | Mark S. Miller | 11 | current (data-model overlap with pass-style/marshal flagged in per-section notes) |
| [draft-specifications/Notation.md](ocapn--draft-specifications-notation.md) | kriscendobot/ocapn | 2025-06-19 | Mark S. Miller | 4 | current (Record/Tagged terminology mismatch flagged) |
| [README.md](endo--readme.md) | endojs/endo | 2025-12-19 | Kris Kowal | 3 | current |
| [packages/lockdown/README.md](endo--pkg-lockdown-readme.md) | endojs/endo | 2022-12-08 | Kris Kowal | 1 | current |
| [packages/exo/docs/types.md](endo--pkg-exo-docs-types.md) | endojs/endo | 2024-11-04 | Kris Kowal | 1 | current |
| [draft-specifications/Locators.md](ocapn--draft-specifications-locators.md) | kriscendobot/ocapn | 2025-12-03 | Jessica Tallon | 5 | current (draft; sturdyref overlaps durable-Exo) |
| [draft-specifications/Netlayers.md](ocapn--draft-specifications-netlayers.md) | kriscendobot/ocapn | 2024-10-01 | Jessica Tallon | 4 | current (draft; overlaps endo netstring/noise/stream) |
| [packages/ses/docs/preparing-for-stabilize.md](endo--pkg-ses-docs-preparing-for-stabilize.md) | endojs/endo | 2025-01-18 | Mark S. Miller | 3 | current |
| [packages/ses-ava/README.md](endo--pkg-ses-ava-readme.md) | endojs/endo | 2025-10-29 | Richard Gibson | 3 | current |
| [packages/memoize/docs/memoize.md](endo--pkg-memoize-docs-memoize.md) | endojs/endo | 2026-01-27 | Mark S. Miller | 7 | current |
| [README.md](ocapn--readme.md) | kriscendobot/ocapn | 2025-07-10 | Jessica Tallon | 5 | current |
| [draft-specifications/CapTP Specification.md](ocapn--draft-specifications-captp.md) | kriscendobot/ocapn | 2026-03-12 | Jessica Tallon | 10 | current (largest source; ops and descs consolidated) |
| [packages/compartment-mapper/README.md](endo--pkg-compartment-mapper-readme.md) | endojs/endo | 2024-12-15 | Kris Kowal | 5 | current |
| [packages/bundle-source/README.md](endo--pkg-bundle-source-readme.md) | endojs/endo | 2025-08-02 | Richard Gibson | 7 | current |
| [packages/ses/docs/secure-coding-guide.md](endo--pkg-ses-docs-secure-coding-guide.md) | endojs/endo | 2023-08-26 | Mark S. Miller | 4 | current |
| [packages/promise-kit/README.md](endo--pkg-promise-kit-readme.md) | endojs/endo | 2024-06-20 | Mudassir Shabbir | 4 | current |
| [packages/stream/README.md](endo--pkg-stream-readme.md) | endojs/endo | 2022-01-21 | Kris Kowal | 4 | current |
| [packages/stream-node/README.md](endo--pkg-stream-node-readme.md) | endojs/endo | 2021-12-23 | Kris Kowal | 1 | current |
| [packages/netstring/README.md](endo--pkg-netstring-readme.md) | endojs/endo | 2021-04-26 | Kris Kowal | 1 | current |
| [packages/init/README.md](endo--pkg-init-readme.md) | endojs/endo | 2025-12-04 | Kris Kowal | 1 | current |
| [packages/far/README.md](endo--pkg-far-readme.md) | endojs/endo | 2023-01-28 | Ivan Leichtling | 1 | current |
| [packages/harden/README.md](endo--pkg-harden-readme.md) | endojs/endo | 2025-10-10 | Kris Kowal | 1 | current |
| [packages/errors/README.md](endo--pkg-errors-readme.md) | endojs/endo | 2025-12-04 | Kris Kowal | 1 | current |
| [packages/ocapn/README.md](endo--pkg-ocapn-readme.md) | endojs/endo | 2026-01-08 | Kris Kowal | 6 | current |
| [packages/ocapn-noise/README.md](endo--pkg-ocapn-noise-readme.md) | endojs/endo | 2025-12-31 | Kris Kowal | 2 | current |
| [packages/eslint-plugin/README.md](endo--pkg-eslint-plugin-readme.md) | endojs/endo | 2025-12-04 | Kris Kowal | 4 | current |
| [packages/import-bundle/README.md](endo--pkg-import-bundle-readme.md) | endojs/endo | 2025-03-06 | Kris Kowal | 4 | current |
| [packages/module-source/README.md](endo--pkg-module-source-readme.md) | endojs/endo | 2024-05-08 | Kris Kowal | 4 | current |
| [packages/evasive-transform/README.md](endo--pkg-evasive-transform-readme.md) | endojs/endo | 2026-02-25 | Zbyszek Tenerowicz | 3 | current |
| [packages/trampoline/README.md](endo--pkg-trampoline-readme.md) | endojs/endo | 2024-04-30 | Christopher Hiller | 5 | current |
| [docs/commit-hygiene.md](agoric-sdk--docs-commit-hygiene.md) | agoric/agoric-sdk | 2026-02-27 | Turadg Aleahmad | 5 | current |
| [docs/node-version.md](agoric-sdk--docs-node-version.md) | agoric/agoric-sdk | 2025-08-21 | Turadg Aleahmad | 2 | current |
| [docs/typescript.md](agoric-sdk--docs-typescript.md) | agoric/agoric-sdk | 2026-02-04 | Turadg Aleahmad | 7 | current (overlaps endo--agents--typescript-usage) |
| [docs/env.md](agoric-sdk--docs-env.md) | agoric/agoric-sdk | 2026-03-31 | Mark S. Miller | 2 | current (cross-references TRACK_TURNS and LOCKDOWN_* from endo) |
| [AGENTS.md](agoric-sdk--agents.md) | agoric/agoric-sdk | 2026-03-23 | Turadg Aleahmad | 8 | current (soft-flag overlap with endo--agents) |
| [CONTRIBUTING.md](agoric-sdk--contributing.md) | agoric/agoric-sdk | 2026-02-27 | Turadg Aleahmad | 4 | current |
| [SECURITY.md](agoric-sdk--security.md) | agoric/agoric-sdk | 2024-01-09 | Raphael Salas | 2 | current (same Agoric HackerOne process as endo--docs-security) |
| [README.md](agoric-sdk--readme.md) | agoric/agoric-sdk | 2026-03-25 | Michael FIG | 7 | current |
| [packages/README.md](agoric-sdk--packages-readme.md) | agoric/agoric-sdk | 2023-08-04 | Turadg Aleahmad | 1 | current |
| [implementation-guide/Implementation Guide.md](ocapn--implementation-guide.md) | kriscendobot/ocapn | 2026-03-12 | Jessica Tallon | 9 | current (canonical implementation walk-through complements the draft-specifications) |
| [packages/ERTP/README.md](agoric-sdk--pkg-ertp-readme.md) | agoric/agoric-sdk | 2023-01-27 | Mark S. Miller | 1 | current (small pointer-shaped README; primary content external) |
| [packages/SwingSet/README.md](agoric-sdk--pkg-swingset-readme.md) | agoric/agoric-sdk | 2025-10-25 | Richard Gibson | 6 | current |
| [packages/zoe/README.md](agoric-sdk--pkg-zoe-readme.md) | agoric/agoric-sdk | 2024-07-03 | Mark S. Miller | 4 | current |
| [packages/smart-wallet/README.md](agoric-sdk--pkg-smart-wallet-readme.md) | agoric/agoric-sdk | 2022-09-13 | Turadg Aleahmad | 4 | current (older; carries open `???` questions in Usage section) |
| [packages/async-flow/README.md](agoric-sdk--pkg-async-flow-readme.md) | agoric/agoric-sdk | 2024-05-19 | Mark S. Miller | 2 | current (may migrate to @endo/async-flow per header note) |
| [packages/async-flow/docs/async-flow-states.md](agoric-sdk--pkg-async-flow-docs-async-flow-states.md) | agoric/agoric-sdk | 2024-09-26 | Michael FIG | 1 | current (companion to async-flow README; the canonical activation-state-machine doc) |
| [packages/vat-data/README.md](agoric-sdk--pkg-vat-data-readme.md) | agoric/agoric-sdk | 2023-01-29 | Unknown | 2 | current (in-vat persistence + Exo prep) |
| [packages/swingset-liveslots/README.md](agoric-sdk--pkg-swingset-liveslots-readme.md) | agoric/agoric-sdk | 2023-11-28 | Unknown | 1 | stale (1-line stub; real content in SwingSet README + package docs/) |
| [packages/store/README.md](agoric-sdk--pkg-store-readme.md) | agoric/agoric-sdk | 2024-01-27 | Unknown | 1 | current (TODO REWRITE marker; pending migration to @endo/store) |
| [packages/base-zone/README.md](agoric-sdk--pkg-base-zone-readme.md) | agoric/agoric-sdk | 2024-01-27 | Unknown | 1 | current (pending migration to @endo/zone) |
| [packages/notifier/README.md](agoric-sdk--pkg-notifier-readme.md) | agoric/agoric-sdk | 2024-10-31 | Unknown | 6 | current (PublishKit/NotifierKit/SubscriptionKit) |
| [packages/internal/README.md](agoric-sdk--pkg-internal-readme.md) | agoric/agoric-sdk | 2025-09-16 | Unknown | 1 | current (perpetual-0.y.z policy) |
| [packages/orchestration/README.md](agoric-sdk--pkg-orchestration-readme.md) | agoric/agoric-sdk | 2024-07-18 | Unknown | 2 | current (cross-chain orchestration flow constraints) |
| [packages/cache/README.md](agoric-sdk--pkg-cache-readme.md) | agoric/agoric-sdk | 2022-08-10 | Unknown | 3 | current (Coordinator interface + transactional updates) |
| [packages/casting/README.md](agoric-sdk--pkg-casting-readme.md) | agoric/agoric-sdk | 2024-09-10 | Unknown | 4 | current (off-chain follower of ocap broadcasts) |
| [packages/inter-protocol/README.md](agoric-sdk--pkg-inter-protocol-readme.md) | agoric/agoric-sdk | 2024-06-11 | Unknown | 5 | current (IST stable-coin protocol: VaultFactory/VaultManager/Vault) |
| [packages/governance/README.md](agoric-sdk--pkg-governance-readme.md) | agoric/agoric-sdk | 2023-04-20 | Turadg Aleahmad | 6 | current (Electorates + VoteCounters + ElectionManagers; ContractGovernor + ParamManager + Governed Contracts) |
| [designs/CLAUDE.md](endo-but-for-bots--llm-designs-claude.md) | endojs/endo-but-for-bots (llm) | 2026-03-13 | Kris Kowal | 4 | current (design-doc agent conventions; metadata table, status taxonomy, 7-section template, progress tracking) |
| [designs/syrups.md](endo-but-for-bots--llm-designs-syrups.md) | endojs/endo-but-for-bots (llm) | 2026-05-06 | Kris Kowal | 1 | current (deprecation/consolidation note; consolidated with @endo/syrup-frame) |
| [designs/ocapn-network-transport-separation.md](endo-but-for-bots--llm-designs-ocapn-network-transport-separation.md) | endojs/endo-but-for-bots (llm) | 2026-02-28 | Kris Kowal | 4 | current (OCapN refactor: network/transport separation, OcapnNetwork interface returns Session not Connection) |
| [designs/cbors.md](endo-but-for-bots--llm-designs-cbors.md) | endojs/endo-but-for-bots (llm) | 2026-05-05 | Kriscendo Bot | 5 | current (CBOR byte-string framing; sibling of @endo/netstring and @endo/syrups) |
| [designs/ocapn-noise-network.md](endo-but-for-bots--llm-designs-ocapn-noise-network.md) | endojs/endo-but-for-bots (llm) | 2026-02-28 | Kris Kowal | 5 | current (OCapN-Noise as a proper network; transports + Noise XX handshake replaces op:start-session) |
| [designs/trust-on-first-bind.md](endo-but-for-bots--llm-designs-trust-on-first-bind.md) | endojs/endo-but-for-bots (llm) | 2026-05-10 | Kriscendo Bot | 6 | current (TOFU for capability policy bindings; state machine + 4 decision modes + audit trail) |
| [designs/README.md](endo-but-for-bots--llm-designs-readme.md) | endojs/endo-but-for-bots (llm) | 2026-05-09 | Kris Kowal | 5 | current (design-corpus master index; 7 milestones, calibration round, gantt; library captures shape not the 100+-row table) |
| [designs/retention-path-notation.md](endo-but-for-bots--llm-designs-retention-path-notation.md) | endojs/endo-but-for-bots (llm) | 2026-05-10 | Kriscendo Bot | 6 | current (daemon GC retention paths: typed model + bulk host method + CLI string notation + best-path selection) |
| [designs/hardened-url-shim.md](endo-but-for-bots--llm-designs-hardened-url-shim.md) | endojs/endo-but-for-bots (llm) | 2026-05-06 | Kriscendo Bot | 6 | current (URL + URLSearchParams as vetted SES shim; %URL%/%SharedURL% Date-style split; hidden iterator-prototype sampling; XS degrades) |
| [designs/daemon-content-store-gc.md](endo-but-for-bots--llm-designs-daemon-content-store-gc.md) | endojs/endo-but-for-bots (llm) | 2026-03-21 | Kris Kowal | 3 | current (Complete; sweep-time refcount for content-addressed blobs + scratch-mount directory cleanup) |
| [designs/daemon-retention-paths.md](endo-but-for-bots--llm-designs-daemon-retention-paths.md) | endojs/endo-but-for-bots (llm) | 2026-05-01 | Kris Kowal | 5 | current (per-target sibling of retention-path-notation; followRetentionPaths subscription + chat UI paths panel + disincarnate/reincarnate) |
| [designs/gateway-bearer-token-auth.md](endo-but-for-bots--llm-designs-gateway-bearer-token-auth.md) | endojs/endo-but-for-bots (llm) | 2026-03-07 | Kris Kowal | 3 | current (Implemented; agent ID as bearer token via CapTP; URL fragment; per-IP rate limiting; explicit ENDO_GATEWAY=remote opt-in) |
| [designs/daemon-cross-peer-gc.md](endo-but-for-bots--llm-designs-daemon-cross-peer-gc.md) | endojs/endo-but-for-bots (llm) | 2026-04-29 | Kris Kowal | 6 | current (cross-peer GC protocol; one-way retention set per peer per direction; retention-accumulator microtask coalescing; replaces abandoned bidirectional CRDT) |
| [designs/daemon-locator-terminology.md](endo-but-for-bots--llm-designs-daemon-locator-terminology.md) | endojs/endo-but-for-bots (llm) | 2026-03-17 | Kris Kowal | 5 | current (non-breaking rename Peer Key / Formula Address / Formula Key; new locator URL with inline `@`-hints; LOCAL_NODE sentinel; dehydrate/hydrate split) |
| [designs/daemon-256-bit-identifiers.md](endo-but-for-bots--llm-designs-daemon-256-bit-identifiers.md) | endojs/endo-but-for-bots (llm) | 2026-02-24 | Kris Kowal | 4 | current (Complete; migration from 512-bit to 256-bit identifiers; Ed25519 public key as node ID aligning with OCapN-Noise; CryptoPowers interface; per-agent keypair formulas; `@keypair` special name; 26 formula types enumerated; breaking — state purge required) |
| [designs/daemon-agent-network-identity.md](endo-but-for-bots--llm-designs-daemon-agent-network-identity.md) | endojs/endo-but-for-bots (llm) | 2026-03-18 | Kris Kowal | 4 | current (In Progress; followup to d256; 2/4 work items shipped via dlt — locator stamping + LOCAL_NODE; remaining items are per-agent NETS and EndoNetwork.registerAgentKey; **origin** of the LOCAL_NODE sentinel and the `0.0.0.0`-as-this-host analogy) |
| [designs/daemon-capability-persona.md](endo-but-for-bots--llm-designs-daemon-capability-persona.md) | endojs/endo-but-for-bots (llm) | 2026-02-24 | Kris Kowal | 5 | current (Not Started; internal title "Delegates and Epithets"; obligatory+verifiable+deniable epithets on Handles; daemon-enforced chain propagation; caretaker pattern Handle vs HandleControl; pass-invariant equality of Handles; AI delegate anti-impersonation invariant) |
| [designs/hardened-text-codecs-shim.md](endo-but-for-bots--llm-designs-hardened-text-codecs-shim.md) | endojs/endo-but-for-bots (llm) | 2026-05-04 | Kris Kowal | 3 | current (Not Started; sibling of hurl; TextEncoder/TextDecoder placed on universalPropertyNames; no iterator prototype + no ambient static = simpler than URL; 3 S-sized phases; enables "prefer Uint8Array over Buffer" convention) |
| [designs/base64-native-fallthrough.md](endo-but-for-bots--llm-designs-base64-native-fallthrough.md) | endojs/endo-but-for-bots (llm) | 2026-04-23 | Kris Kowal | 4 | current (Not Started; third member of vetted-shim family with hurl + htcs; **ponyfill** dispatching to TC39 native `Uint8Array.fromBase64`/`toBase64`; detect-and-capture-before-lockdown; option-bag mapping; `ENDO_BASE64_FORCE` env-var test gate; 9 design decisions; 3 S-sized phases; 6 known gaps) |
| [designs/chat-invariants.md](endo-but-for-bots--llm-designs-chat-invariants.md) | endojs/endo-but-for-bots (llm) | 2026-03-02 | Kris Kowal | 2 | current (Complete; **first chat-related ingest**; 6 MUST-hold invariants + 6 SHOULD principles for Familiar Chat keyboard-first UI; modeline completeness, keyboard-manual parity, escape consistency, autocomplete `(visible rows − 1)` paging) |
| [designs/chat-components.md](endo-but-for-bots--llm-designs-chat-components.md) | endojs/endo-but-for-bots (llm) | 2026-03-02 | Kris Kowal | 4 | current (Complete; architecture counterpart to chat-invariants; per-concern file layout; 9 component responsibilities; 3 message kinds; profile system with `/enter`+`/exit`; 13 CSS theme tokens; 7 security claims, 1 soft item flagged for revision: counter-proposal endowments) |
| [designs/chat-spaces-gutter.md](endo-but-for-bots--llm-designs-chat-spaces-gutter.md) | endojs/endo-but-for-bots (llm) | 2026-02-26 | Kris Kowal | 3 | current (Complete; introduces the *space* concept; left-edge 48px gutter of bookmarks into the capability graph; **no new daemon APIs** — rides on existing pet-store `write`/`list`/`lookup`/`remove`/`storeValue`; keyboard-manual parity `Cmd+1..9` + click; 3/6 future-enhancement items already shipped) |
| [designs/chat-spaces-home.md](endo-but-for-bots--llm-designs-chat-spaces-home.md) | endojs/endo-but-for-bots (llm) | 2026-03-02 | Kris Kowal | 2 | current (Complete; configurable Space 0 / Home; 4 indelible invariants + 2 configurable fields; `HOME_SPACE_DEFAULTS` merge-on-load + normalize-on-save; `data-menu-scope` attribute system; `showName`-parameterized modal reuse; shared icon-selector extraction; **Numbering Scheme table is aspirational** — source implements `Cmd+1` = home; investigation cycle 58) |
| [designs/chat-command-bar.md](endo-but-for-bots--llm-designs-chat-command-bar.md) | endojs/endo-but-for-bots (llm) | 2026-03-02 | Kris Kowal | 4 | current (Complete; **largest chat ingest so far** at 255 lines; 9 command-bar states each with modeline + keyboard table + manual-equivalent; value modal with 4 title shapes; 8 typed field types as the chat client's input vocabulary; single-path `.`-drilling and multi-path chip-composition autocomplete grammars; 9 command categories with ~20 commands; inline-hints-complement-modeline discipline; 3 known-gap categories) |

## Backlog (not yet ingested)

Roughly grouped by priority. The full file inventory was captured during the pilot survey; the lists below are summaries, not authoritative manifests.

**Top-level (0 remaining):** all 4 top-level documents ingested (AGENTS.md, CONTRIBUTING.md, README.md, SECURITY.md). SECURITY.md content overlaps `docs/security.md` and may need a contradiction check.

**`docs/` (0 remaining):** all 8 `docs/*.md` files ingested. `bugs.md`, `get-started.md`, `reference.md`, `message-passing.md`, and `guide.md` ingested on the /loop ticks of 2026-05-14; `lockdown.md` was ingested 2026-05-13 as the first scholar-cycle library task; `security.md` and `errors.md` from the original pilot.

**Package READMEs (39 remaining):** of the 47 packages under `packages/`, 8 are now ingested (`daemon`, `marshal`, `pass-style`, `exo`, `patterns`, `eventual-send`, `ses`, `captp`). 39 small-utility packages remain in the backlog.

**Package `docs/` and `doc/` (8 remaining):** ingested so far: `marshal/docs/smallcaps-cheatsheet.md`, `pass-style/doc/{copyArray,copyRecord,enumerating-properties}-guarantees.md`, `patterns/docs/marshal-vs-patterns-level.md`, `exo/docs/exo-taxonomy.md`. Remaining: `exo/docs/types.md`, `memoize/docs/memoize.md`, `ses/docs/{draft-standalone-spec,guide,preparing-for-stabilize,secure-coding-guide,ses-0.7}.md`.

**Package `docs/` and `doc/` (13):**
- `packages/exo/docs/`: `exo-taxonomy.md`, `types.md`.
- `packages/marshal/docs/smallcaps-cheatsheet.md`.
- `packages/memoize/docs/memoize.md`.
- `packages/pass-style/doc/`: `copyArray-guarantees.md`, `copyRecord-guarantees.md`, `enumerating-properties.md`.
- `packages/patterns/docs/marshal-vs-patterns-level.md`.
- `packages/ses/docs/`: `draft-standalone-spec.md`, `guide.md`, `preparing-for-stabilize.md`, `secure-coding-guide.md`, `ses-0.7.md`.

**Other:**
- `.changeset/*.md` (13 files): recent change descriptions; useful for "what landed when."
- `packages/ses/error-codes/*.md` (13 files): SES error-code reference; mechanical but useful.
- `rust/ocapn_noise/README.md`: small.
- `scripts/setup-agoric-bot.md`: small.

Auto-generated content not for ingestion:
- `CHANGELOG.md` files (47): one per package; per-package change history. Out-of-scope for the library; the upstream files remain the source of truth.

## Notes

- Some files have only one commit in `git log` (probably post-rename); their content date may predate the commit date. The pilot ingestion flagged these in per-source `notes:` fields. A future contradiction-check pass should compare pre- and post- rename content if the upstream history is recovered.
