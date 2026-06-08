---
title: §Assets-should-outlive-execution-paths (separate-asset-holding-from-execution-machinery) + §EIP-1167-minimal-proxy-Remote-Accounts with §deterministic-address-derivation-from-factory-plus-implementation-plus-portfolio-account + §race-tolerant-idempotent-provisioning + §replaceable-control-paths via authenticated-routers + §three-state-router-authorization-state-machine (Unknown / Vetted / Authorized) with §two-factor-mechanism (EVM-multisig-vets + Ymax-orchestration-via-existing-authorized-router-authorizes) + §compromise-of-single-router-does-not-authorize-new-control-path security argument + §deposits-as-intents via Permit2-signed-transfers + §self-dispatch-pattern with §msg.sender==address(this)-check + §two-benefits-of-self-dispatch (error-catching-as-event-not-revert + block-explorer-readability-as-decoded-function-call-not-opaque-bytes) + §calldata-rewrite-replacing-txId-with-authenticated-source-address (same length encoding) + §resolvers-as-bounded-fact-reporters (one bit success/failed not arbitrary state) + §finality-checks-before-settlement + §return-path-independent-of-outgoing-transport + §CREATE2-vs-CREATE3-distinction (CREATE2 for permissionless implementation; CREATE3 for permissioned per-chain-init-data) + §compromise-of-deployment-key-doesn't-alter-contract-behavior + §Atredis-audit-with-three-informational-findings + §five-mermaid-diagrams — Ymax EVM Remote Accounts
source: agoric-labs/agoric-to-axelar-local agoric-docs/ymax-evm-remote-accounts.md
source-slug: agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts
ingest-cycle: 214 (user-requested side-ingest alongside designs-lane)
ingest-date: 2026-06-07
lane: user-requested
status: published with §independent-audit (Atredis Partners; zero critical/high/medium/low; three informational findings; one fixed)
author: Agoric Labs
related:
  - endo-but-for-bots--llm-designs-daemon-cas-management (content-addressed-storage sibling-discipline at different layer)
  - endo-but-for-bots--llm-designs-endor-run-expanded (cycle 202; root-hash-printed-to-stderr / hash-as-stable-handle sibling)
  - endo-but-for-bots--llm-designs-endoclaw (cycle 196; §ambient-vs-object-capability sibling)
  - endo-but-for-bots--llm-designs-worker-rust-xs (cycle 200; §host-compartment-vs-guest-compartment-split sibling — both designs §isolate-guest-code-from-host-authority)
  - endo-but-for-bots--llm-designs-lal-fae-form-provisioning (cycle 210; §existing-user-action-as-consent-mechanism sibling)
  - endo-but-for-bots--llm-designs-familiar-bundled-agents (cycle 208; §The-Powers-Problem-with-three-option-analysis sibling)
  - endo-but-for-bots--llm-designs-outliner-design-doc (cycle 212; §reference-scoping-no-upward-traversal sibling — both designs §confine-authority)
keywords:
  - assets-should-outlive-execution-paths
  - stable-asset-containers-for-cross-chain-portfolio-orchestration
  - per-portfolio-Remote-Account-contracts (vs shared omnibus account)
  - EIP-1167-minimal-proxy
  - deterministic-address-derivation (factory + implementation + portfolio account)
  - race-tolerant-idempotent-provisioning
  - replaceable-control-paths
  - three-state-router-authorization-state-machine (Unknown / Vetted / Authorized)
  - two-factor-authorization (EVM-multisig-vets + Ymax-via-existing-authorized-router-authorizes)
  - compromise-of-single-router-does-not-authorize-new-control-path
  - confused-deputy-defense
  - deposits-as-intents via Permit2-signed-transfers
  - factory-principal-check (only Ymax orchestration can spend)
  - self-dispatch-pattern
  - msg.sender == address(this) check
  - two-benefits-of-self-dispatch (error-catching-as-event + block-explorer-readability)
  - calldata-rewrite-replacing-txId-with-authenticated-source-address (same length encoding)
  - resolvers-as-bounded-fact-reporters (one bit success/failed not arbitrary state)
  - finality-checks-before-settlement (defends against chain reorgs + relayer retries)
  - return-path-independent-of-outgoing-transport
  - CREATE2-vs-CREATE3-distinction
  - permissionless-CREATE2 for implementation
  - permissioned-CREATE3 for router and factory (per-chain init data)
  - compromise-of-deployment-key-doesn't-alter-contract-behavior
  - Atredis-Partners-audit (zero critical/high/medium/low; three informational findings)
  - five-mermaid-diagrams in document
  - OperationResult event common format
  - SubcallOutOfGas revert
  - future-multiple-concurrent-interaction-paths including direct EVM user wallet behind timelock
  - cycle 214 user-requested side-ingest
  - first-Agoric-Labs-design ingested
---

# agoric-labs/agoric-to-axelar-local ymax-evm-remote-accounts — §assets-should-outlive-execution-paths + §three-state-router-authorization + §self-dispatch + §resolvers-as-bounded-fact-reporters

## Source

- `agoric-labs/agoric-to-axelar-local agoric-docs/ymax-evm-remote-accounts.md`
- Status: §published with §independent-audit (Atredis Partners 2026 Ymax Agoric Solidity Contract Assessment; zero critical/high/medium/low; three informational findings; one fixed in router implementation)
- Author: Agoric Labs
- Ingest: cycle 214 user-requested side-ingest (2026-06-07) alongside the designs-lane lal-reply-chain-transcripts ingest

## Single most structurally interesting move

§Assets-should-outlive-execution-paths — §the-key-architectural-choice: §separate-the-contracts-that-hold-assets-from-the-machinery-used-to-operate-them. §The-asset-holding-side-needs-to-be-boring-and-durable. §The-execution-side has §different-pressures (cross-chain messaging providers change; instruction formats evolve; new ways of interacting with EVM accounts may become useful). §Those-changes-should-be-applicable-to-existing-portfolio-accounts, §rather-than-requiring-every-portfolio-to-move-assets-into-a-new-account.

§The-Remote-Account is §a-stable-object. §Everything-else in the system is organized around §safely-creating-those-accounts, §sending-authenticated-instructions-to-them, and §observing-the-results-of-those-instructions.

§Borrowable-pattern: §assets-should-outlive-execution-paths as §the-canonical-architectural-discipline for §any-system-where-the-asset-substrate-needs-stability-but-the-control-machinery-needs-evolvability.

## §Three-named-properties preserved in the user intent flow

> - The user's assets remain segregated from other users' assets.
> - The system does not take custody through a shared omnibus account.
> - The user does not need to manually operate accounts on every destination chain.

§Three-numbered-properties with §explicit-user-facing-value. §Sibling-pattern to cycle 196 endoclaw's §three-named-attacks paired with §three-structural-defenses and cycle 200 worker-rust-xs's §three-numbered-problems.

§Borrowable-pattern: §three-named-properties-preserved as §the-canonical-Problem-section-shape.

## §EIP-1167 minimal-proxy Remote Accounts with §deterministic address derivation

> Remote Accounts are deployed as EIP-1167 minimal proxy contracts, allowing each account to reuse a shared implementation while still having its own address.

§Three-input-deterministic-derivation:
1. §Remote-Account-factory-address (§namespaces Remote Accounts to a specific Ymax contract instance).
2. §Immutable-Remote-Account-implementation-address.
3. §Ymax-portfolio-Agoric-account-address (§separates one portfolio's assets from another's).

§The-factory-is-the-root-contract for the Ymax instance. §The-portfolio-account-address identifies the per-portfolio asset container within that system.

§Borrowable-pattern: §deterministic-address-derivation-from-multiple-identities as §the-canonical-shape for §cross-system-identity-anchoring. Sibling to cycle 200 retention-path-notation's §best-path-selection-rule and cycle 209 path-compare's §Shortlex-ordering — different domains, same §multi-tier-identity-anchoring discipline.

## §Race-tolerant idempotent provisioning

> Deterministic derivation supports race-tolerant, idempotent provisioning: the same portfolio for the same Ymax instance on the same EVM chain always maps to the same Remote Account address. The system can safely check whether the account already exists, deploy it using the Remote Account factory if needed, and independently start moving assets to computed deposit destinations.

§Race-tolerant-idempotent-provisioning enables §moving-assets-and-creating-accounts-in-parallel without coordination. §The-deterministic-address-IS-the-coordination-primitive.

§Borrowable-pattern: §race-tolerant-idempotent-provisioning via §deterministic-derivation for §concurrent-systems-where-the-name-IS-the-rendezvous.

§Sibling-pattern to cycle 210 lal-fae-form-provisioning's §inbox-as-durable-config-store with §provideGuest-is-idempotent — both designs §use-idempotent-provisioning-with-a-deterministic-name.

## §Routers — authenticated instruction delivery (not dumb pipes)

> The router is not just a dumb pipe to Remote Accounts. It exposes high-level instructions that the Ymax orchestration contract uses to provision accounts, process deposits, execute account operations, and administer router authorization.

§The-router-is-the-replaceable-control-path. §Remote-Accounts-do-not-embed-or-trust-a-single-cross-chain-messaging-path-directly.

§The-messaging-layer-or-router-itself-must-ensure-that-messages-are-authentic-non-replayable-and-tied-to-the-correct-source-account. §This-avoids-confused-deputy-problems where a router could be tricked into executing instructions from an impostor.

§Borrowable-pattern: §confused-deputy-defense at §the-messaging-layer + §authentication-as-router-precondition.

§Sibling-pattern to cycle 196 endoclaw's §object-capability-vs-ambient-authority and cycle 212 outliner-design-doc's §reference-scoping-no-upward-traversal. §All-three-designs §confine-authority-at-each-layer.

## §Three-state Router Authorization state machine

§Three-named-states with §named-transitions:

```
Unknown → vetRouter (EVM multisig) → Vetted
Vetted → authorizeRouter (Ymax via other authorized router) → Authorized
Authorized → deauthorizeRouter (Ymax via other authorized router) → Vetted
Vetted → unvetRouter (EVM multisig) → Unknown
```

§Two-factor-mechanism: §EVM-multisig-must-vet (code approval) + §Ymax-orchestration-via-existing-authorized-router-must-authorize (operational approval). §Two-different-authorities-coordinate-to-add-a-router.

§The-critical-security-property: §compromise-of-a-single-router-or-cross-chain-messaging-system-should-not-by-itself-authorize-a-completely-new-control-path-for-all-Remote-Accounts.

§Borrowable-pattern: §two-factor-state-machine-for-control-path-authorization where §each-state-transition-requires-a-different-authority.

§Sibling-pattern to cycle 208 familiar-bundled-agents's §The-Powers-Problem-with-three-option-analysis — both designs §carefully-stage-the-authority-transitions. §Cycle-208 is at the agent-bootstrap layer; §cycle-214-ymax is at the cross-chain-router-authorization layer.

## §Compromise-of-single-router argument

> An already authorized router remains highly privileged, so router code and messaging authentication are still critical trust boundaries.

§Honest-disclosure: §an-already-authorized-router-is-still-highly-privileged. §The-two-factor-mechanism-defends-against-rogue-additions but §not-against-already-authorized-routers-going-bad.

§Borrowable-pattern: §honest-disclosure-of-residual-trust-boundaries even after a §two-factor-defense.

§Sibling-pattern to cycle 197 panic's §default-erroneous-exit + no-ambient-normal-exit asymmetry with §"no-further-loss-in-security"-historical-note — both designs §name-the-trade-off-explicitly.

## §Future multiple concurrent interaction paths

> In the future, this model can support multiple concurrent interaction paths, potentially including direct EVM user wallet access behind a timelock, without changing where assets are held.

§Forward-looking-statement: §the-router-abstraction supports §future-direct-EVM-wallet-access (behind a timelock).

§Borrowable-pattern: §forward-looking-statement-naming-the-future-flexibility for §designs-that-build-room-for-extension.

§Sibling-pattern to cycle 204 weblet-next's §Note-on-the-Next-Rendition and cycle 198 patterns-diagnostic-feedback's §future-helpers-named-not-shipped.

## §Deposits as intents via Permit2 signed transfers

> Deposits are intents processed as a router instruction rather than as separate token transfers.

§Permit2-spender = router. §The-router's-EVM-address-can-represent-that-Ymax-instance when a user signs a Permit2 authorization.

§Factory-principal-check: §the-router-enforces-that-a-deposit-instruction-can-only-come-from-the-factory-principal (the Agoric Ymax contract instance associated with the factory).

§This-prevents §an-attacker-from-taking-a-permit-intended-for-the-Ymax-system-and-redirecting-funds-into-an-unrelated-Remote-Account. §The-factory's-deterministic-address-computation anchors §the-deposit-to-the-portfolio-account-designated-by-the-authenticated-Ymax-instruction.

§Borrowable-pattern: §permit-as-intent + §factory-principal-check for §authorization-routing where §the-permit-target-is-the-system-not-the-individual-account.

## §Self-dispatch pattern with §msg.sender == address(this) check

> Processing of authenticated cross-chain messages in the router revolves around an important trick: a self-dispatch pattern. Instructions are encoded as calldata, and the target methods, while public on the router, verify that they were called by the router itself.

§The-target-methods-are-public-but-check-msg.sender-==-address(this). §This-creates-§two-benefits:

1. **§Error-catching-as-event-not-revert** — if a message is valid but execution fails, the router records the failure in the result event rather than reverting the entire transaction, §allowing-the-messaging-layer-to-mark-the-delivery-as-consumed-so-it-cannot-be-retried-later.
2. **§Block-explorer-readability** — because the dispatched instruction is encoded as normal EVM calldata, §it-makes-the-transaction-easier-to-inspect-in-block-explorers. The instruction can be decoded as a function call instead of appearing only as an opaque bytes payload.

§Borrowable-pattern: §self-dispatch-pattern with §msg.sender-==-address(this)-check for §two-named-benefits (error-isolation-via-event-not-revert + block-explorer-readability-via-decoded-function-call).

§Sibling-pattern to cycle 203 cache-map's §don't-establish-entry-until-prior-steps-succeed — both designs §isolate-failure-from-broader-state-changes.

## §Calldata rewrite: txId replaced by authenticated source address (same length)

> However, a plain self-dispatch of the encoded instruction would lose a crucial piece of information: the sender of the instruction. This is where the common format becomes relevant. The txId is only used by the transport side of the router to report the outcome of the instruction as an event, and serves no operational purpose for instruction processors. So its encoding is defined to have the same length as the source address, and before dispatching, the router replaces it in the encoded calldata with the authenticated source address.

§Calldata-rewrite-as-information-injection. §The-txId-and-source-address-are-defined-to-have-the-same-length so §the-replacement-is-zero-overhead. §The-result: §the-instruction-processor-receives-the-authenticated-source-address as a §normal-calldata-argument.

§Borrowable-pattern: §calldata-rewrite-replacing-routing-field-with-authenticated-source where §the-two-fields-share-the-same-encoding-length.

§This-is-an-elegant-design-move. §It-converts §an-out-of-band-authentication-result into §an-in-band-argument that §the-self-dispatched-function-can-validate-naturally.

## §Resolvers as bounded fact reporters

> Importantly, resolvers are not trusted to report arbitrary EVM state. They are trusted only to submit one bounded fact back to the Agoric chain: whether a specific routed instruction settled as successful or failed.

§Resolvers-are-bounded-trust: §they-report-one-bit-per-instruction (success/failed) §not-arbitrary-state. §This-keeps-the-return-path-independent-of-the-outgoing-cross-chain-messaging-transport.

§Failed-events-and-reverted-transactions-are-confirmed-with-finality-checks-before-settlement-is-reported. §Transient-chain-reorgs-or-relayer-retries-do-not-prematurely-fail-an-orchestration-step-that-ultimately-succeeds.

§Borrowable-pattern: §resolvers-as-bounded-fact-reporters + §finality-checks-before-settlement for §systems-where-the-return-path-is-not-trusted-with-arbitrary-state.

§Sibling-pattern to cycle 162 daemon-Ken-protocol's §atomic-checkpoint and cycle 197 panic's §prepare-commit-transactional-pattern — three designs at three different layers using §all-or-none-discipline.

## §Return path independent of outgoing transport

> The system does not require the same cross-chain provider to carry both the command and the result.

§Borrowable-pattern: §decoupled-command-and-result-transports for §multi-transport-cross-chain-systems.

## §CREATE2 vs CREATE3 distinction — deployment model

> - the Remote Account implementation is deployed deterministically using permissionless CREATE2;
> - the Axelar router requires per-chain initialization data, such as the Axelar gateway address, so it is deployed deterministically using permissioned CREATE3;
> - the Remote Account factory currently uses the same initialization data on all chains. Some of that data, especially the initial multisig vetting authority, may differ on future chains, so the factory is also deployed using permissioned CREATE3.

§Three-named-deployment-modes with §named-rationale:

| Contract | Deployment | Why |
| --- | --- | --- |
| Remote Account implementation | Permissionless CREATE2 | No per-chain init data; address is purely a function of bytecode + salt |
| Axelar router | Permissioned CREATE3 | Per-chain init data (Axelar gateway address); CREATE3 decouples address from init data |
| Remote Account factory | Permissioned CREATE3 | Currently uniform init data, but future chains may differ (e.g., initial multisig); CREATE3 future-proofs |

§Compromise-of-deployment-key-doesn't-alter-deployed-contract-behavior. §It-can-only-interfere-with-the-goal-of-achieving-consistent-cross-chain-addresses.

§Borrowable-pattern: §CREATE2-vs-CREATE3-distinction for §deterministic-deployment with §named-per-chain-init-data-handling.

## §OperationResult event common format

§Common-format for all instructions received by the router: §txId + §expected-target-account-address (corresponding to the source Agoric account). §The-messaging-provider-is-responsible-for-authenticating-the-sender and (since the router does not verify txId uniqueness) §preventing-replays.

§Routed instruction lifecycle:
1. §Authenticated-cross-chain-message-arrives with §sourceAddress + §encoded-instruction.
2. §Validate-message (check instruction selector; decode common fields).
3. §Patch-calldata (insert authenticated sourceAddress, replacing txId).
4. §Self-dispatch the patched calldata.
5. §Instruction-checks (msg.sender == address(this); source matches expected target).
6. §Perform-operation.
7. §Emit-OperationResult (txId + success/failure) OR §revert-as-SubcallOutOfGas.

§Borrowable-pattern: §common-format-with-txId-for-event-reporting-and-target-address-for-sender-authentication.

## §Atredis audit with three informational findings

> The Remote Account system was independently audited by Atredis Partners as part of the 2026 Ymax Agoric Solidity contract assessment.
>
> Atredis reported no critical, high, medium, or low severity findings. The report included three informational findings. Two highlighted the importance of consistent source-address formatting expectations across routers and factories. The third identified a logic bug in the router's out-of-gas heuristic handling.

§Independent-audit-with-zero-non-informational-findings. §Three-informational-findings each named:
1. Consistent source-address formatting expectations across routers (1).
2. Consistent source-address formatting expectations across factories (2).
3. Logic bug in router's out-of-gas heuristic handling (3 — fixed in router implementation).

§Borrowable-pattern: §independent-audit-section-with-named-findings + §fix-status-per-finding.

§Sibling-pattern to cycle 196 endoclaw's §status-matrix-with-named-equivalents and cycle 200 endo-posix-sandbox's §five-cross-phase-invariants-test-discipline.

## §Five-mermaid-diagrams in document

§Five-mermaid-diagrams in this document — §a-density-high-by-library-standards:
1. Orchestrated flow for user opening a portfolio (User → UI → Agoric → Base RA → Ethereum RA → Compound).
2. Factory-portfolio mapping (Ymax instance → Portfolio A/B → Remote Account proxies A/B; CREATE2 clone salted by portfolio account).
3. Authorized instruction flow (Ymax → cross-chain messaging → EVM router → Remote Account; replaceable control path).
4. Router authorization state machine (Unknown → Vetted → Authorized; two-factor transitions).
5. Routed instruction lifecycle (authenticated message → validate → patch calldata → self-dispatch → process → emit OperationResult or revert).

§Borrowable-pattern: §five-mermaid-diagrams as §the-visual-explanation-density for §multi-layer-architectures.

§Sibling-pattern to cycle 209 path-compare's §multiple-mermaid-diagrams-with-worked-examples — cycle 209 has 4 diagrams for §algorithm-tiers; cycle 214-ymax has 5 diagrams for §system-architecture-layers.

## §Borrowable patterns (tier-1)

1. **§Assets-should-outlive-execution-paths** — separate-asset-holding-contracts from execution-machinery; asset side is boring and durable, execution side is replaceable.
2. **§Three-named-properties-preserved** as §canonical-Problem-section-shape.
3. **§EIP-1167-minimal-proxy** for §per-instance-addresses-sharing-implementation.
4. **§Deterministic-address-derivation-from-multiple-identities** (factory + implementation + portfolio account) — multi-tier identity anchoring.
5. **§Race-tolerant-idempotent-provisioning** via §the-deterministic-address-IS-the-coordination-primitive.
6. **§Routers-as-authenticated-instruction-delivery (not dumb pipes)** with §confused-deputy-defense.
7. **§Three-state-router-authorization-state-machine** (Unknown / Vetted / Authorized) with §two-factor-mechanism (different-authority-per-transition).
8. **§Honest-disclosure-of-residual-trust-boundaries** — an already-authorized router is still highly privileged.
9. **§Forward-looking-statement-naming-the-future-flexibility** — direct EVM wallet access behind a timelock.
10. **§Permit2-as-intent + §factory-principal-check** for §authorization-routing where §the-permit-target-is-the-system-not-the-individual-account.
11. **§Self-dispatch-pattern with §msg.sender == address(this)** for §two-named-benefits (error-isolation-via-event-not-revert + block-explorer-readability).
12. **§Calldata-rewrite-replacing-routing-field-with-authenticated-source** when §the-two-fields-share-the-same-encoding-length.
13. **§Resolvers-as-bounded-fact-reporters** (one bit per instruction, not arbitrary state) + §finality-checks-before-settlement.
14. **§Decoupled-command-and-result-transports** for multi-transport cross-chain systems.
15. **§CREATE2-vs-CREATE3-distinction** with §named-per-chain-init-data-handling.
16. **§Compromise-of-deployment-key-doesn't-alter-deployed-contract-behavior** — security argument for permissioned deployment.
17. **§OperationResult event common format** with §txId-for-event-reporting + §target-address-for-sender-authentication.
18. **§Independent-audit-section-with-named-findings** + §fix-status-per-finding.
19. **§Five-mermaid-diagrams** as §visual-explanation-density for multi-layer architectures.
20. **§Routed instruction lifecycle** with §seven-named-steps (validate → patch → self-dispatch → checks → perform → emit-or-revert).
21. **§The-factory-IS-the-mediator** — Remote Accounts statically defer to factory for router checks; factory maintains authorization state.
22. **§Atomic-authorization-of-existing-accounts-to-new-router** — controlled upgrade without per-account migration.

## §Synthesis-target

Slot machine library §stable-game-state-containers-with-replaceable-control-paths:

- §Assets-should-outlive-execution-paths borrowable directly: §game-state-containers (per-player balance, history) should be §stable-objects with §replaceable-engines (rule-set updates, new game modes).
- §Deterministic-address-derivation borrowable for §game-state-anchored-to-player-identity + §game-instance-namespace.
- §Three-state-router-authorization borrowable for §game-rule-upgrade-paths (Unknown → Vetted → Authorized).
- §Two-factor-mechanism borrowable for §authority-staging-with-different-keys (e.g., dev-team-vets + game-operator-via-existing-rule-set-authorizes).
- §Self-dispatch-pattern borrowable for §game-action-isolation (failed-action-as-event-not-game-state-revert).
- §Resolvers-as-bounded-fact-reporters borrowable for §game-outcome-reporting that §doesn't-trust-arbitrary-state.
- §Permit2-as-intent borrowable for §player-signed-bet-intents that §the-game-engine-spends-as-the-permit-spender.

## §First Agoric Labs design ingested

§Library-protocol-note: §this-is-the-first-ingest-from-an-agoric-labs-repository (vs the previously-ingested endo and endo-but-for-bots repositories). §The-shape-is-distinctive: §EVM-side architectural documentation describing §the-Agoric-Solidity-cross-chain-orchestration-system.

§The-document-is-user-requested (not part of the librarian-loop rotation). §Ingested-alongside cycle 214's designs-lane lal-reply-chain-transcripts as §a-side-ingest.

§The-discipline-of-the-document is §canonical-cross-chain-orchestration-architecture and §borrowable-patterns from §a-different-domain (EVM/Solidity/cross-chain) that nonetheless §rhymes-with-many-Endo-disciplines (object-capability / confused-deputy / two-factor-staging / deterministic-naming / honest-design-evolution).

§Many-sibling-references to existing library cycles — the §rhyme is strong. §Confirmation that §the-discipline-of-good-architecture-design transcends §specific-substrate-technologies.
