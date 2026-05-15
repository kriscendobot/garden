---
created: 2026-05-12
updated: 2026-05-13
author: liaison, gardener
---

# Garden journal

## Bulletin board

### Recent engagements ready for review

<!-- BEGIN recent-engagements -->
- Builder probed [endojs/endo-but-for-bots#138](https://github.com/endojs/endo-but-for-bots/pull/138) (OCapN/Daemon `@transports` design) → draft [endojs/endo-but-for-bots#262](https://github.com/endojs/endo-but-for-bots/pull/262) with **17 gaps surfaced** (cross-agent loopback distinguisher, listener policy site, Locator-vs-string discrimination, hint-policy DSL, signingKeys/`@keypair` collision, `Locator` exo absent, `EndoHost.listen()` absent, `packages/ocapn-noise-network/` absent, …). 8 skeleton items landed (formula registration, host plumbing, CLI verb), 12 abandoned at first ambiguity. First worked example of the new `probe #N` verb. PR · 2026-05-15T03:45:46Z · [`entries/2026/05/15/034546Z-result-builder-4a8df9.md`](entries/2026/05/15/034546Z-result-builder-4a8df9.md)
- Gardener encoded new skill [`gap-revealing-build`](../skills/gap-revealing-build/SKILL.md) + orchestrator verb **`probe #N`** (synonyms: *probe the design at #N*, *attempt #N to reveal gaps*) per maintainer directive on [endojs/endo-but-for-bots#138](https://github.com/endojs/endo-but-for-bots/pull/138). Distinct from `build #N`: produces a DRAFT PR whose body is the gap inventory; no judge / cleaner / un-draft chain runs. Builder dispatch `4a8df9` is the worked example, probing #138's OCapN/Daemon design. · 2026-05-15T03:39:41Z · [`entries/2026/05/15/033941Z-result-gardener-c9ded6.md`](entries/2026/05/15/033941Z-result-gardener-c9ded6.md)
- Boatman ferried `endojs/endo-but-for-bots#258` upstream as draft [endojs/endo#3264](https://github.com/endojs/endo/pull/3264) — `ci(ocapn-guile-interop): cache the Guix runtime store across runs`, iter III of the resilience series; bot-side #258 also rebased from llm → master, head `5b38857d5`. Cross-session work converged. PR · 2026-05-15T03:33:02Z · [`entries/2026/05/15/033302Z-result-liaison-2757e1.md`](entries/2026/05/15/033302Z-result-liaison-2757e1.md)
- Builder opened draft [endojs/endo-but-for-bots#261](https://github.com/endojs/endo-but-for-bots/pull/261) — Cut 1 of #206 devDep-cycle factoring (new `@endo/ses-test` package, 11 edges eliminated → zero non-trivial SCCs) — PR · 2026-05-15T03:30:20Z · [`entries/2026/05/15/033020Z-result-builder-d330ff.md`](entries/2026/05/15/033020Z-result-builder-d330ff.md)
- Builder opened draft [endojs/endo-but-for-bots#249](https://github.com/endojs/endo-but-for-bots/pull/249) — `design(ses,module-source): top-level-await proposal` (391 lines, leads with seventeen-row test262 fixture table) — PR · 2026-05-14T19:58:10Z · [`entries/2026/05/14/195810Z-result-builder-46ee5a.md`](entries/2026/05/14/195810Z-result-builder-46ee5a.md)
- Builder opened draft [endojs/endo-but-for-bots#248](https://github.com/endojs/endo-but-for-bots/pull/248) — `design(ses,module-source): import-attributes proposal` (411 lines; JSON modules v1, CSS/Wasm deferred) — PR · 2026-05-14T19:57:41Z · [`entries/2026/05/14/195741Z-result-builder-8c11f7.md`](entries/2026/05/14/195741Z-result-builder-8c11f7.md)
- Builder opened draft [endojs/endo-but-for-bots#247](https://github.com/endojs/endo-but-for-bots/pull/247) — Cut 5 of #206 devDep-cycle factoring (new `@endo/eventual-send-test` package) — PR · 2026-05-14T19:50:02Z · [`entries/2026/05/14/195002Z-result-builder-90af84.md`](entries/2026/05/14/195002Z-result-builder-90af84.md)
- Weaver rebased [endojs/endo-but-for-bots#240](https://github.com/endojs/endo-but-for-bots/pull/240) `feat/turbo-test-depends-on-build` onto current `origin/llm` (no conflicts; force-with-lease pushed) — PR · 2026-05-14T19:41:48Z · [`entries/2026/05/14/194148Z-result-weaver-91d238.md`](entries/2026/05/14/194148Z-result-weaver-91d238.md)
- Liaison closed re-ferry of `endojs/endo-but-for-bots#226` to upstream [endojs/endo#3255](https://github.com/endojs/endo/pull/3255) — alias-not-migrate reshape per turadg's r3229246963, force-pushed under kriskowal identity — PR · 2026-05-14T18:07:04Z · [`entries/2026/05/14/180704Z-result-liaison-3114c6.md`](entries/2026/05/14/180704Z-result-liaison-3114c6.md)
<!-- END recent-engagements -->

### Pending kriskowal reviews

<!-- BEGIN pending-kriskowal-reviews -->
### Endo master

#### Unclassified: endojs/endo

- [endojs/endo#1256](https://github.com/endojs/endo/pull/1256): fix(bundle-source): assert that the entrypoint exists at all (by @warner, updated 3y ago, draft)
- [endojs/endo#1967](https://github.com/endojs/endo/pull/1967): test(compartment-mapper): check for resistance to bundled... (by @naugtur, updated 2y ago, draft)
- [endojs/endo#2404](https://github.com/endojs/endo/pull/2404): support destructuring in harden-exports (by @turadg, updated 1y ago, draft)
- [endojs/endo#2673](https://github.com/endojs/endo/pull/2673): feat(non-trapping-shim): opt-in shim of the non-trapping ... (by @erights, updated 2mo ago)
- [endojs/endo#2701](https://github.com/endojs/endo/pull/2701): fix(pass-style): fix #2700 ignore more safe async_hook ex... (by @erights, updated 16d ago)
- [endojs/endo#2797](https://github.com/endojs/endo/pull/2797): fix(pass-style): avoid symbol-named methods (by @erights, updated 2mo ago)
- [endojs/endo#2916](https://github.com/endojs/endo/pull/2916): mermaid dep graph script improvements (by @boneskull, updated 24d ago)
- [endojs/endo#2952](https://github.com/endojs/endo/pull/2952): fix(ses): fix #2951 stronger sniffing for v8 (by @erights, updated 2mo ago)
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102): chore(ci): create custom CHANGELOG generator (by @boneskull, updated today)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110): refactor(error-console-internal): for use only by ses and... (by @erights, updated 1mo ago)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137): feat: support .ts runtime modules via erasable type syntax (by @turadg, updated today)

### Endo-but-for-bots llm

#### Milestone 1: Remote Access and Coding Capabilities

- [endojs/endo-but-for-bots#126](https://github.com/endojs/endo-but-for-bots/pull/126): ci: disable npm lifecycle scripts in workflows (re-opened... (by @kriscendobot, updated today)

#### Milestone 3: Weblets and Integrations

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101): feat(chat): voice input via Web Speech API (by @kriscendobot, updated 8d ago)
- [endojs/endo-but-for-bots#102](https://github.com/endojs/endo-but-for-bots/pull/102): design(chat): voice command parser (by @kriscendobot, updated 4d ago)

#### Milestone 4: UX Polish and Agent Tooling

- [endojs/endo-but-for-bots#179](https://github.com/endojs/endo-but-for-bots/pull/179): feat(daemon,chat): record host commands in chat transcrip... (by @kriscendobot, updated 4d ago)

#### Milestone 6: Rust Daemon (`endor`)

- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166): feat(endor): add rust/endor TUI skeleton (re-opened from ... (by @kriscendobot, updated 5d ago)

#### Unclassified: endojs/endo-but-for-bots

- [endojs/endo-but-for-bots#117](https://github.com/endojs/endo-but-for-bots/pull/117): design(daemon): NameHub interface unification (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#138](https://github.com/endojs/endo-but-for-bots/pull/138): design(ocapn): per-agent @transports for OCapN/Daemon int... (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#170](https://github.com/endojs/endo-but-for-bots/pull/170): feat(pass-style,marshal,eventual-send,captp): pass-style ... (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#174](https://github.com/endojs/endo-but-for-bots/pull/174): test: repro empty-{} rendering of Error reasons in discon... (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178): refactor(daemon): introduce locator scheme with @-delimit... (by @kriscendobot, updated 2d ago)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237): design: lal define-jessie tool with Blockly rendering (by @kriscendobot, updated today, draft)

### Remaining

#### Milestone 2: Networking

- [endojs/endo-but-for-bots#111](https://github.com/endojs/endo-but-for-bots/pull/111): feat(ocapn): CBOR codec, NonceLocator (#59 stack 1/3) (by @kriscendobot, updated 5d ago)
- [endojs/endo-but-for-bots#112](https://github.com/endojs/endo-but-for-bots/pull/112): feat(ocapn-noise): Noise IK netlayer (#59 stack 2/3) (by @kriscendobot, updated 6d ago)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113): test(ocapn-noise): integration + transport tests (#59 sta... (by @kriscendobot, updated 6d ago)

#### Unclassified: Agoric/agoric-sdk

- [Agoric/agoric-sdk#10190](https://github.com/Agoric/agoric-sdk/pull/10190): build(deps): bump anylogger from 0.21.0 to 1.0.11 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10196](https://github.com/Agoric/agoric-sdk/pull/10196): build(deps): bump axios from 1.6.8 to 1.7.7 in /a3p-integ... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10197](https://github.com/Agoric/agoric-sdk/pull/10197): build(deps): bump micromatch from 4.0.5 to 4.0.8 in /a3p-... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10198](https://github.com/Agoric/agoric-sdk/pull/10198): build(deps): bump rollup from 2.79.1 to 2.79.2 in /a3p-in... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10203](https://github.com/Agoric/agoric-sdk/pull/10203): build(deps): bump tar from 6.2.0 to 6.2.1 in /a3p-integra... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10204](https://github.com/Agoric/agoric-sdk/pull/10204): build(deps): bump ws from 7.5.9 to 7.5.10 in /a3p-integra... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10205](https://github.com/Agoric/agoric-sdk/pull/10205): build(deps): bump braces from 3.0.2 to 3.0.3 in /a3p-inte... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10321](https://github.com/Agoric/agoric-sdk/pull/10321): build(deps): bump http-proxy-middleware from 2.0.6 to 2.0.7 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10521](https://github.com/Agoric/agoric-sdk/pull/10521): build(deps): bump cross-spawn from 7.0.3 to 7.0.6 in /mul... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10522](https://github.com/Agoric/agoric-sdk/pull/10522): build(deps): bump cross-spawn from 7.0.3 to 7.0.6 in /a3p... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10531](https://github.com/Agoric/agoric-sdk/pull/10531): build(deps): bump cross-spawn from 6.0.5 to 6.0.6 in /a3p... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10795](https://github.com/Agoric/agoric-sdk/pull/10795): refactor: prepare for use of non-trapping integrity trait (by @erights, updated 8mo ago)
- [Agoric/agoric-sdk#10855](https://github.com/Agoric/agoric-sdk/pull/10855): feat: Classify trigger in contextualized slog sender (by @usmanmani1122, updated 11mo ago)
- [Agoric/agoric-sdk#10977](https://github.com/Agoric/agoric-sdk/pull/10977): chore: fix some function names in comment (by @finaltrip, updated 9mo ago)
- [Agoric/agoric-sdk#11023](https://github.com/Agoric/agoric-sdk/pull/11023): update NOTICE (by @rootdiae, updated 1y ago)
- [Agoric/agoric-sdk#11086](https://github.com/Agoric/agoric-sdk/pull/11086): chore: make function comments match function names (by @tiaoxizhan, updated 1y ago)
- [Agoric/agoric-sdk#11091](https://github.com/Agoric/agoric-sdk/pull/11091): chore(SwingSet): Remove URL from kernel compartment endow... (by @gibson042, updated 1y ago)
- [Agoric/agoric-sdk#11095](https://github.com/Agoric/agoric-sdk/pull/11095): chore: remove redundant words in comment (by @MarkDaveny, updated 1y ago)
- [Agoric/agoric-sdk#11107](https://github.com/Agoric/agoric-sdk/pull/11107): build(deps): bump @babel/runtime from 7.23.9 to 7.26.10 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11108](https://github.com/Agoric/agoric-sdk/pull/11108): build(deps): bump @babel/helpers from 7.23.9 to 7.26.10 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11112](https://github.com/Agoric/agoric-sdk/pull/11112): build(deps): bump golang.org/x/net from 0.18.0 to 0.36.0 ... (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11162](https://github.com/Agoric/agoric-sdk/pull/11162): refactor: use the built-in min to simplify the code (by @threehonor, updated 1y ago)
- [Agoric/agoric-sdk#11187](https://github.com/Agoric/agoric-sdk/pull/11187): build(deps): bump tar-fs from 2.1.1 to 2.1.2 in /a3p-inte... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11190](https://github.com/Agoric/agoric-sdk/pull/11190): build(deps): bump axios from 1.8.1 to 1.8.4 in /a3p-integ... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11262](https://github.com/Agoric/agoric-sdk/pull/11262): fix: template string parsing issue in JS expression (by @mdqst, updated 1y ago)
- [Agoric/agoric-sdk#11264](https://github.com/Agoric/agoric-sdk/pull/11264): build(deps): bump golang.org/x/crypto from 0.31.0 to 0.35... (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11268](https://github.com/Agoric/agoric-sdk/pull/11268): build(deps): bump http-proxy-middleware from 2.0.6 to 3.0.5 (by @dependabot[bot], updated 12mo ago)
- [Agoric/agoric-sdk#11290](https://github.com/Agoric/agoric-sdk/pull/11290): build(deps): bump golang.org/x/net from 0.33.0 to 0.38.0 ... (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11338](https://github.com/Agoric/agoric-sdk/pull/11338): fix: prepare for symbol flip (by @erights, updated 8mo ago, draft)
- [Agoric/agoric-sdk#11388](https://github.com/Agoric/agoric-sdk/pull/11388): build(deps): bump axios from 1.8.1 to 1.9.0 in /a3p-integ... (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11394](https://github.com/Agoric/agoric-sdk/pull/11394): remove ses-ava (by @turadg, updated 11mo ago, draft)
- [Agoric/agoric-sdk#11402](https://github.com/Agoric/agoric-sdk/pull/11402): Jorge/8863 refactor test tooling (by @Jorge-Lopes, updated 11mo ago)
- [Agoric/agoric-sdk#11413](https://github.com/Agoric/agoric-sdk/pull/11413): build(deps): bump github.com/opencontainers/runc from 1.2... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11432](https://github.com/Agoric/agoric-sdk/pull/11432): ci: bump golangci-lint-action to v8 (by @eeemmmmmm, updated 11mo ago)
- [Agoric/agoric-sdk#11447](https://github.com/Agoric/agoric-sdk/pull/11447): chore(acceptance): fix lint (by @mujahidkay, updated 11mo ago, draft)
- [Agoric/agoric-sdk#11473](https://github.com/Agoric/agoric-sdk/pull/11473): build(deps): bump brace-expansion from 1.1.11 to 1.1.12 i... (by @dependabot[bot], updated 10mo ago)
- [Agoric/agoric-sdk#11474](https://github.com/Agoric/agoric-sdk/pull/11474): build(deps): bump brace-expansion from 1.1.11 to 1.1.12 i... (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11493](https://github.com/Agoric/agoric-sdk/pull/11493): Fix Typos in Comments and Documentation (by @leopardracer, updated 11mo ago)
- [Agoric/agoric-sdk#11495](https://github.com/Agoric/agoric-sdk/pull/11495): fix: update broken example link for ENDO_DELIVERY_BREAKPO... (by @VolodymyrBg, updated 11mo ago)
- [Agoric/agoric-sdk#11568](https://github.com/Agoric/agoric-sdk/pull/11568): feat: import / export kernel DB should support compressed... (by @usmanmani1122, updated 10mo ago)
- [Agoric/agoric-sdk#11602](https://github.com/Agoric/agoric-sdk/pull/11602): build(deps): bump @opentelemetry/exporter-trace-otlp-http... (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11625](https://github.com/Agoric/agoric-sdk/pull/11625): build(deps): bump golang.org/x/oauth2 from 0.23.0 to 0.27... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11635](https://github.com/Agoric/agoric-sdk/pull/11635): build(deps): bump form-data from 2.5.2 to 2.5.5 (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11637](https://github.com/Agoric/agoric-sdk/pull/11637): build(deps): bump form-data from 4.0.2 to 4.0.4 in /a3p-i... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11653](https://github.com/Agoric/agoric-sdk/pull/11653): build(deps): bump form-data from 4.0.2 to 4.0.4 in /multi... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11738](https://github.com/Agoric/agoric-sdk/pull/11738): build(deps): bump tmp from 0.2.3 to 0.2.4 in /multichain-... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11794](https://github.com/Agoric/agoric-sdk/pull/11794): build(deps): bump sha.js from 2.4.11 to 2.4.12 in /multic... (by @dependabot[bot], updated 7mo ago)
- [Agoric/agoric-sdk#11985](https://github.com/Agoric/agoric-sdk/pull/11985): build(deps): bump tar-fs from 2.1.1 to 2.1.4 (by @dependabot[bot], updated 6mo ago)
- [Agoric/agoric-sdk#12036](https://github.com/Agoric/agoric-sdk/pull/12036): build(deps): bump axios from 1.10.0 to 1.12.2 in /a3p-int... (by @dependabot[bot], updated 6mo ago)
- [Agoric/agoric-sdk#12081](https://github.com/Agoric/agoric-sdk/pull/12081): ci (deployment): Ymax planner deployment testing (by @Muneeb147, updated 6mo ago, draft)
- [Agoric/agoric-sdk#12149](https://github.com/Agoric/agoric-sdk/pull/12149): restrict `.ts` runtime imports from dependencies (by @mhofman, updated 6mo ago, draft)

#### Unclassified: Agoric/dapp-agoric-basics

- [Agoric/dapp-agoric-basics#68](https://github.com/Agoric/dapp-agoric-basics/pull/68): chore: port sell contract to .ts (by @dckc, updated 1y ago, draft)

#### Unclassified: Agoric/dapp-offer-up

- [Agoric/dapp-offer-up#61](https://github.com/Agoric/dapp-offer-up/pull/61): fix: use limited publishBrandInfo power, not all of chain... (by @dckc, updated 2y ago, draft)

#### Unclassified: Agoric/documentation

- [Agoric/documentation#965](https://github.com/Agoric/documentation/pull/965): build: update dependencies to match dapp-offer-up (agoric... (by @dckc, updated 2y ago)

#### Unclassified: agoric-labs/dapp-stake-control

- [agoric-labs/dapp-stake-control#54](https://github.com/agoric-labs/dapp-stake-control/pull/54): chore: log boardId of instance in coreEval (by @dckc, updated 11mo ago)
- [agoric-labs/dapp-stake-control#55](https://github.com/agoric-labs/dapp-stake-control/pull/55): chore: punt on give.Retainer (by @dckc, updated 11mo ago)

#### Unclassified: endojs/Jessie

- [endojs/Jessie#127](https://github.com/endojs/Jessie/pull/127): Add Blockly visual programming tools for JSON, Justin, an... (by @Copilot, updated 2mo ago)

#### Unclassified: endojs/endo

- [endojs/endo#2675](https://github.com/endojs/endo/pull/2675): feat(ses,pass-style): use non-trapping integrity trait fo... (by @erights, updated 2mo ago)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073): feat(patterns): Add `M.choose` (by @gibson042, updated yesterday)

#### Unclassified: endojs/endo-but-for-bots

- [endojs/endo-but-for-bots#68](https://github.com/endojs/endo-but-for-bots/pull/68): docs(ses): document Compartment availability and OOM limi... (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#107](https://github.com/endojs/endo-but-for-bots/pull/107): feat(random): pure-rand v8 RandomGenerator adapter (#75 f... (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182): test(ses): isImmutableDataProperty regression for iOS Saf... (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186): feat(eventual-send): eager-shim/lazy-main delegate ponyfi... (by @kriscendobot, updated 2d ago)
- [endojs/endo-but-for-bots#226](https://github.com/endojs/endo-but-for-bots/pull/226): feat(eslint-plugin): migrate to eslint-plugin-import-x (by @kriscendobot, updated today)

#### Unclassified: endojs/playground

- [endojs/playground#14](https://github.com/endojs/playground/pull/14): feat: rock-paper-scissors (by @dckc, updated 2y ago)

#### Unclassified: ocapn/ocapn

- [ocapn/ocapn#51](https://github.com/ocapn/ocapn/pull/51): chore: exploring CBOR, protobuf (by @dckc, updated 2y ago, draft)
<!-- END pending-kriskowal-reviews -->

### PR backlog

<!-- BEGIN pr-backlog -->
#### Milestone 1: Remote Access and Coding Capabilities

- [endojs/endo-but-for-bots#134](https://github.com/endojs/endo-but-for-bots/pull/134): feat(docker,daemon): docker self-hosting, foreground daemon, CIDR gate, static files (re-opened from #47 under the bot) (waiting on: Endo Gateway concept maturation (per kriskowal 2026-05-13); DRAFT + CHANGES_REQUESTED)

#### Milestone 3: Weblets and Integrations

- [endojs/endo-but-for-bots#160](https://github.com/endojs/endo-but-for-bots/pull/160): feat(exo-zip,exo-unzip): split into write-side + read-side per kriskowal naming (closes #154) (waiting on: kriskowal to pick a name pair; CHANGES_REQUESTED)

#### Milestone 4: UX Polish and Agent Tooling

- [endojs/endo-but-for-bots#125](https://github.com/endojs/endo-but-for-bots/pull/125): feat(daemon): add editMessage and messageHistory (re-opened from #23 under the bot) (waiting on: fixer; MERGEABLE + CHANGES_REQUESTED)
- [endojs/endo-but-for-bots#151](https://github.com/endojs/endo-but-for-bots/pull/151): feat(cli): endo workers verb (extracted from #128, implements designs/workers-panel.md) (waiting on: fixer; CHANGES_REQUESTED)
- [endojs/endo-but-for-bots#179](https://github.com/endojs/endo-but-for-bots/pull/179): feat(daemon,chat): record host commands in chat transcript via commands-as-messages (re-opened from #45 under the bot) (waiting on: fixer; CHANGES_REQUESTED)

#### Unclassified: endojs/endo-but-for-bots

- [endojs/endo-but-for-bots#147](https://github.com/endojs/endo-but-for-bots/pull/147): feat(lal): add OpenRouter provider and share OpenAI Chat shape (waiting on: 0xpatrickdev's approval; APPROVED by kriskowal who deferred)
- [endojs/endo-but-for-bots#165](https://github.com/endojs/endo-but-for-bots/pull/165): design(cli,daemon): scheduled-send via reactor + schedule (PR #145 design revision) (waiting on: weaver, then fixer, then maintainer re-review; CONFLICTING + CHANGES_REQUESTED)
- [endojs/endo-but-for-bots#169](https://github.com/endojs/endo-but-for-bots/pull/169): design: pass-style promise (non-thenable; closes #168) (waiting on: weaver, then kriskowal to confirm Option A vs B; CONFLICTING + PENDING)
- [endojs/endo-but-for-bots#170](https://github.com/endojs/endo-but-for-bots/pull/170): feat(pass-style,marshal,eventual-send,captp): pass-style promise + HandledPromise.settle (per #169) (waiting on: kriskowal pick on #169 + kumavis follow-up; PENDING)
- [endojs/endo-but-for-bots#174](https://github.com/endojs/endo-but-for-bots/pull/174): test: repro empty-{} rendering of Error reasons in disconnect trap (#171) (waiting on: kriskowal review; PENDING)
- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178): refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting on: fixer; CHANGES_REQUESTED)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182): test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting on: kriskowal review; PENDING)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186): feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting on: fixer; CHANGES_REQUESTED)
- [endojs/endo-but-for-bots#203](https://github.com/endojs/endo-but-for-bots/issues/203) (issue): chat: integrate daemon editMessage / messageHistory in inbox and channel UIs (waiting on: designer)
- [endojs/endo-but-for-bots#205](https://github.com/endojs/endo-but-for-bots/issues/205) (issue): CI Latency Telemetry (waiting on: scout, or steward + comment authorization to land the prior baseline report)
<!-- END pr-backlog -->

### Awaits maintainer ferry

PRs synced + green on `endo-but-for-bots`'s master-base; ready for the maintainer to ferry upstream from another session (kriskowal-identity push required, not available from `endolinbot`).

- **[#244](https://github.com/endojs/endo-but-for-bots/pull/244) — `chore(eslint-plugin): require underscore-delimited groups in numeric literals`** (master-base mirror of #243, now synced with upstream [#3263](https://github.com/endojs/endo/pull/3263)). Reverse-ferry from upstream completed; bot-side reset to upstream's commit boundaries. Head `b583f9259`. CI converging. Per fixer [`024619Z-result-fixer-e72e0c.md`](entries/2026/05/15/024619Z-result-fixer-e72e0c.md). (Earlier green-state at `746beaf4` was the pre-reverse-ferry head; the maintainer's upstream edits are now absorbed.)
- **[#109](https://github.com/endojs/endo-but-for-bots/pull/109) — `feat(syrup-frame): syrup-frame package and opt-in framing for OCapN TCP-for-testing`**. Rebase on upstream master was a no-op (already atop `0ec70c6dd`); yarn.lock regenerated and amended into the third commit preserving the three-commit shape. Head `cfa440f2c`. **CI 28/28 SUCCESS** including `test-ocapn-guile-interop`. Per fixer [`024654Z-result-fixer-a80ce6.md`](entries/2026/05/15/024654Z-result-fixer-a80ce6.md). Note: a concurrent boatman dispatch from the maintainer's side is already in flight per the fixer's observation.
- **[#253](https://github.com/endojs/endo-but-for-bots/pull/253) — `chore: enforce general package uniformity across workspace`** (broader package-uniformity, now synced from upstream [#3258](https://github.com/endojs/endo/pull/3258)). Reverse-ferry: hard reset to upstream's `e98151eda` (the maintainer adopted the broader scope upstream; PR title now matches). CI converging. Per fixer [`025100Z-result-fixer-d43da1.md`](entries/2026/05/15/025100Z-result-fixer-d43da1.md).
- **[#75](https://github.com/endojs/endo-but-for-bots/pull/75) — `feat(random,chacha12)`** (synced from upstream [#3232](https://github.com/endojs/endo/pull/3232)). Reverse-ferry: rebase semantics — bot-side simplify-magic-multiplier commit preserved on top of upstream's `f87bf8425` (chacha20 stack absorbed). Final yarn.lock regenerated. Head `8eb479120`. CI converging. Per fixer [`025204Z-result-fixer-346b46.md`](entries/2026/05/15/025204Z-result-fixer-346b46.md).

### Awaits maintainer review

- **[endojs/endo-but-for-bots#226](https://github.com/endojs/endo-but-for-bots/pull/226) — `feat(eslint-plugin): migrate to eslint-plugin-import-x`.** turadg's feedback on the upstream mirror ([endojs/endo#3255](https://github.com/endojs/endo/pull/3255) comment `3229246963`) recommended aliasing `eslint-plugin-import-x` to `eslint-plugin-import` rather than the suppression edits the original PR carried. Fixer (dispatch `63f3ef`) checked the PR and found turadg's aliasing already applied (npm-alias in the dev catalog, force-pushed 2026-05-12); the remaining work surfaced 11 lint errors that import-x@4's stricter resolver caught (where the prior resolver silently failed). Two follow-up commits landed: `f38d828b7` (devDeps allowlist for `*.test-d.ts`, declare `tsd` in `packages/exo/package.json`, three intentional re-export disables) and `5ea8d7e72` (yarn.lock). Local `yarn lint`: 0 errors. CI in flight at fixer-end-time. Summary comment posted: [#226 issuecomment-4448213020](https://github.com/endojs/endo-but-for-bots/pull/226#issuecomment-4448213020). See [`entries/2026/05/14/062906Z-result-fixer-63f3ef.md`](entries/2026/05/14/062906Z-result-fixer-63f3ef.md). Clears on kriskowal review or maintainer redirect.

- **Two endo design drafts (sibling pair) — `exo-import` + `exo-npm-registry`.** Authored by designer dispatch `e3b1aa` (2026-05-14). Preserved in the journal so the dispatch root could be torn down: [`projects/endo/drafts/exo-import.md`](projects/endo/drafts/exo-import.md) (~15 KB; plug-and-play import using compartment-mapper primitives, Go-style version resolution, snapshot-strict, content-addressed cache) and [`projects/endo/drafts/exo-npm-registry.md`](projects/endo/drafts/exo-npm-registry.md) (~11 KB; daemon-side capture-and-vend for `(name, version) → readable-tree`). Both carry 11 combined *Open questions* the designer surfaced rather than picking; full list in the designer's result entry and reproduced verbatim in [`entries/2026/05/14/051353Z-result-designer-e3b1aa.md`](entries/2026/05/14/). Next step: maintainer triage of the open questions → builder dispatch lands the agreed shape on a fork branch of `endojs/endo`. Clears on builder dispatch.

### Unstarted designs

<!-- BEGIN unstarted-designs -->
Inventory as of 2026-05-15T01:30Z: **84 uncovered designs** on `endojs/endo-but-for-bots@llm` (out of 117 candidates total). Top 15 newest-first by last-modified-on-llm.

| Last-modified (UTC) | Design | Slug | One-line summary |
|---|---|---|---|
| 2026-05-12 | [`designs/retention-path-notation.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/retention-path-notation.md) | `retention-path-notation` | Typed `RetentionPath` + bulk `listRetentionPaths(targetIds)` host method (PR #151 reviewer gap). Status: Proposed. Design landed via #181. |
| 2026-05-12 | [`designs/endo-gateway.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endo-gateway.md) | `endo-gateway` | Split per-user Daemon and system-service Gateway (one host port, virtual-host OCapN to many users). Status: Proposed. Design landed via #199. |
| 2026-05-10 | [`designs/trust-on-first-bind.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/trust-on-first-bind.md) | `trust-on-first-bind` | TOFU-style pattern for capability policy bindings (HTTP allowlists, Browser exo, Shell, Mount). Status: Reference. Design landed via #164. |
| 2026-05-08 | [`designs/hardened-url-shim.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hardened-url-shim.md) | `hardened-url-shim` | Vetted shim taming `URL` / `URLSearchParams` (iterator-prototype leak, `createObjectURL` ambient authority). Status: Not Started. Design landed via #84. |
| 2026-05-08 | [`designs/hardened-text-codecs-shim.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hardened-text-codecs-shim.md) | `hardened-text-codecs-shim` | Vetted shim adding hardened `TextEncoder` / `TextDecoder` to `universalPropertyNames`. Status: Not Started. |
| 2026-05-07 | [`designs/filesystem-watchers.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/filesystem-watchers.md) | `filesystem-watchers` | Add `followNameChanges` / `followLocatorNameChanges` to `EndoMount` (parity with `EndoDirectory`). Status: Not Started. Design landed via #115. |
| 2026-05-07 | [`designs/familiar-unified-weblet-server.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/familiar-unified-weblet-server.md) | `familiar-unified-weblet-server` | Unified weblet server (Host-header virtual hosting on gateway port; Familiar via `localhttp://`, chat weblets per-port). Status: In Progress (partially implemented; under revision). |
| 2026-05-06 | [`designs/chat-slot-slash-commands.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-slot-slash-commands.md) | `chat-slot-slash-commands` | Slot-local `/`-prefixed slash commands fill request slots without minting pet names. Status: Proposed. Design landed via #103. |
| 2026-05-06 | [`designs/chat-edit-message-ui.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-edit-message-ui.md) | `chat-edit-message-ui` | Chat UI entry points (keybinding, hover button, slash command) to call `editMessage` from the local-user profile. Status: Not Started. Design landed via #88. |
| 2026-05-02 | [`designs/worker-rust-xs.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/worker-rust-xs.md) | `worker-rust-xs` | Replace Node.js worker with Rust + XS engine (native `Compartment`, no Node.js dependency). Status: Not Started. |
| 2026-05-02 | [`designs/endor-run-expanded.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endor-run-expanded.md) | `endor-run-expanded` | `endor run` accepts archives, directories, and entry points (Phases 1-2 landed; Phases 3-5 owed). Status: In Progress. |
| 2026-05-02 | [`designs/endor-npm-registry-proxy.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endor-npm-registry-proxy.md) | `endor-npm-registry-proxy` | CAS + SQLite registry-table backing `endor run entry.js` (Phases 1+3 landed; Phase 2 HTTP client owed). Status: In Progress. |
| 2026-05-02 | [`designs/daemon-xs-worker-snapshot.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md) | `daemon-xs-worker-snapshot` | XS heap snapshot/restore for worker suspend/resume (idle agents, checkpoints, fast spawn). Status: In Progress. |
| 2026-05-02 | [`designs/daemon-xs-worker-metering.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-metering.md) | `daemon-xs-worker-metering` | XS worker measurement / quota / rate-limiting (seven-phase implementation). Status: **Complete** (informational — needs tracking-PR cross-ref if any work remains). |
| 2026-05-02 | [`designs/daemon-xs-worker-debugger.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md) | `daemon-xs-worker-debugger` | Activate XS xsbug debugger in Rust build; hot-attach via worker bus envelopes; expose `Debugger` exo. Status: In Progress. |

Source of truth: `endojs/endo-but-for-bots@llm`. Coverage rule: a design is *covered* by an open-or-merged feat/fix/chore/mirror/test/refactor/ci/docs PR whose title, body, or `headRefName` references the canonical design path; merged design-landing PRs (head `design/<slug>*`) and closed-not-merged PRs do **not** cover. Inventory regenerated each cycle per [`skills/design-to-pr-pipeline/SKILL.md`](../skills/design-to-pr-pipeline/SKILL.md).
<!-- END unstarted-designs -->

### Awaits maintainer decision

- Two `endojs/endo-but-for-bots` workflows at 100% failure on master: `Deploy TypeDoc site with GitHub Pages` and `Release`; awaits triage. See [`entries/2026/05/13/004800Z-message-steward-f78473.md`](entries/2026/05/13/004800Z-message-steward-f78473.md).
- `timekeeper` role landed; awaits start signal. See [`entries/2026/05/13/054736Z-result-gardener-559c18.md`](entries/2026/05/13/054736Z-result-gardener-559c18.md).
- After PRs #109 (`syrup-frame`) and #111 (CBOR codec) land, dispatch a builder/fixer to update `designs/syrups.md` and `designs/cbors.md` on `endo-but-for-bots@llm` to reflect what actually shipped (including the new package names). Clears on the design-update PRs landing.
- **Three permission/infrastructure stalls in 18 hours** (steward observation): (a) `kriscendobot` OAuth token lacks `workflow` scope (#228 conductor); (b) `UpdatePullRequest` permission missing on `endojs/endo` for kriscendobot (#3256 title/body); (c) GitHub Actions check-suite creation stalled (#243, this row's first item). Steward proposes a credential-and-config sweep on the `kriscendobot` identity and the `endojs/endo-but-for-bots` Actions config. See [`entries/2026/05/14/134311Z-message-steward-9d5cf7.md`](entries/2026/05/14/134311Z-message-steward-9d5cf7.md). Clears when sweep lands.
- **endo#1967 mirror parked (Phase 2c — ambiguous)** — naugtur's 2-year-old policy-bypass test was replayed on `endo-but-for-bots:master` as branch [`test/policy-identifier-bypass`](https://github.com/endojs/endo-but-for-bots/tree/test/policy-identifier-bypass) (no PR opened). The 9 security-relevant sub-tests pass (the bypass appears fixed; likely by `5ff31f950 fix(compartment-mapper): guarantee stable paths` + `acbacba53` canonical-name work), but three workspace failures cloud the read: (1) the same `writeArchive`/`importArchive` sourcemap-count-mismatch naugtur kept his PR in draft for in 2024 is still firing; (2) `makeArchive`/`parseArchive`/`hashArchive consistency` reports extraneous `myattenuator-v1.0.0/index.js`; (3) `map-node-modules idempotent fixtures-policy` snapshot drift (`eve>alice` now appears). Two paths forward: refresh the test as Phase-2b regression coverage (regen snapshots, investigate the two archive failures), or decline and close upstream [#1967](https://github.com/endojs/endo/pull/1967) with a note that the bypass is no longer reproducible. See [`entries/2026/05/14/210310Z-result-builder-693645.md`](entries/2026/05/14/210310Z-result-builder-693645.md).
- **Close [endojs/endo#1256](https://github.com/endojs/endo/pull/1256) with a note** — the bug it addresses (`bundleSource` silently producing a bundle when the entrypoint does not exist, [issue #1206](https://github.com/endojs/endo/issues/1206)) is fixed at current master. Modern handling lives at [`packages/compartment-mapper/src/import-hook.js:727`](https://github.com/endojs/endo/blob/master/packages/compartment-mapper/src/import-hook.js#L727): the 2023 refactor `11940d916` split bundle-source's dispatcher into format-specific delegates that hand the entrypoint URL to `@endo/compartment-mapper`, whose `import-hook` exhausts a candidate list (`.js`, `.json`, `.node`, `index.*`) and fails closed — strictly more thorough than the PR's `assert(fs.existsSync(...))`. All four bundle-source formats (`endoZipBase64`, `endoScript`, `nestedEvaluate`, `getExport`) reject correctly. #1206 stays closed. See [`entries/2026/05/14/205826Z-result-builder-dd4563.md`](entries/2026/05/14/205826Z-result-builder-dd4563.md).

### Pre-staged authorizations

- **`endojs/endo-but-for-bots` is the garden's own repo (broad comment authorization).** The maintainer's framing on 2026-05-13: "you are generally authorized to post freely on endo-but-for-bots. It is yours." Every role the garden dispatches against this repository may post comments, reviews, review-comments, reactjis, and cross-references on its issues and PRs without per-action authorization in the dispatch prompt. Repo-scoped relaxation only; every other repository remains under the default per-action rule in `roles/COMMON.md` § External-repo etiquette. Destructive actions (force-pushes to protected branches, branch deletions, repository-setting changes) remain per-action. Detail recorded in [`projects/endo-but-for-bots/README.md`](projects/endo-but-for-bots/README.md) § Standing authorizations. Clearing: this row stays as a standing reminder; not self-clearing.

- **`kriscendobot` write access to `endojs/ocapn-test-suite`.** The maintainer granted the bot push access to the endojs fork of the OCapN test suite, with two constraints attached: the work starts from a specific upstream commit on `ocapn/ocapn-test-suite`, and no PR is to be opened against the OCapN-org upstream. The bot's pre-grant analysis on PR #109 referenced the pin in two comments, so the hash is recorded inline here to spare future agents the re-derivation.
  - Identity: `kriscendobot`.
  - Action: push branches and commits to `endojs/ocapn-test-suite`.
  - Baseline (Constraint A): start from `74db78f08a40efba1e2b975d809374ff0e7acf60` on `ocapn/ocapn-test-suite`. Origin of the pin: kriscendobot's investigation comments on PR #109 ([issuecomment-4427618615](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4427618615) and [issuecomment-4427633977](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4427633977)) anchor every "current state of the Python suite" claim on that commit (verified: it is `Merge pull request #35 ... pluralize-gc-ops`, dated 2026-02-25). The maintainer's grant comment ("Be sure to use the hash pinned from here as a baseline") refers back to those anchors. PR #109's own `baseRefOid` (`c2fc02eb8bf674389a8445ce785ff5eff36ed5aa`) and `headRefOid` (`4ffb3d84e50c35f330d90e7e600040944e789a3c`) are on `endojs/endo-but-for-bots` and are not the baseline; they are noted here only to rule them out.
  - No-upstream (Constraint B): do **not** open a PR against `ocapn/ocapn-test-suite`. Work stays on `endojs/ocapn-test-suite` only.
  - Source: [endojs/endo-but-for-bots#109#issuecomment-4436075344](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4436075344) (kriskowal, 2026-05-13T00:54:05Z); steward write-up at [`entries/2026/05/13/012400Z-result-steward-da0309.md`](entries/2026/05/13/012400Z-result-steward-da0309.md).
  - Clearing: the row stays until a future dispatch picks up the authorization and pushes the agreed branch. The dispatching liaison clears it at that future time.

### Scheduled engagements

- 2026-05-17: weekly `major-general` major-version sweep on `endojs/endo-but-for-bots`. See [`entries/2026/05/13/000100Z-message-steward-d95cb2.md`](entries/2026/05/13/000100Z-message-steward-d95cb2.md).
- 2026-05-20: refresh #205 CI latency report (steward); also serves as #121 post-merge evaluation. See [`entries/2026/05/13/004753Z-message-steward-1f0703.md`](entries/2026/05/13/004753Z-message-steward-1f0703.md).


## Ongoing work

### Active worktrees

Full index at [`worktrees/README.md`](worktrees/README.md). Currently active or reserved:

- `endolinbot`: 1 active standing monitor (`watch-endo-but-for-bots`) on `endojs/endo-but-for-bots`. The other four standing monitors (`watch-endo`, `watch-agoric-sdk`, `watch-cosgov`, `watch-garden`) were collected on 2026-05-13 per the monitoring safety constraint in `CLAUDE.md` § Monitoring safety constraint; their index entries are kept for the record and the filesystem worktrees survive on disk in case the constraint reverses.
- `kmkmbp2021`: 1 idle integration scratch worktree (`integrate--liaison--20260512-194515`), see the index.

### Open monitors

`endolinbot` runs 2 long-lived poll daemons via the steward's standing-monitors discipline (see `roles/steward/AGENT.md` § Standing monitors on the `main` branch). Cadences: `endo-but-for-bots` 30s, `review-queue` 120s. PIDs and logs in `/tmp/garden-monitor-*.{pid,log,err}` and `/tmp/garden-review-queue.{pid,log,err}`. The active set is constrained by the monitoring safety rule; re-enabling another monitor requires explicit maintainer authorization recorded in a journal `message` entry.

### Recent activity

For the flat chronological view, run `git log` on this branch or browse [`entries/`](entries/) by date.

## Maintenance

- **Bulletin items**: posted *and cleared* by agents via `skills/journal-sync/SKILL.md` (on the `main` branch). The steward typically clears items during its per-cycle close, by re-checking each item's underlying condition (was the PR reviewed? was the decision made? was the staged authorization forwarded?) and dropping items whose condition is resolved. The maintainer never edits the bulletin.
- **Ongoing work** sections are kept current by the steward (during its per-cycle close) and by the liaison (when it does worktree-manager work). Subagents do not update these sections directly; they post `message` entries to `entries/` that the orchestrator promotes here when warranted.
- **Schemas** for entries and for worktree index files live in `roles/COMMON.md` (on the `main` branch) and in [`worktrees/README.md`](worktrees/README.md) respectively.
