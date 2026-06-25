# Garden bulletin

_As of 2026-06-25T17:48:36Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

Freshest off the line: [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) opened the new `@endo/pubsub` package (Sink/Spring async linked list, with "changes" and "latest" variants) and is parked for review after only a couple of hours. Recently completed work landed banner fixes on [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) and stood up the deterministic garden-mirror-closer service. Still in flight: the endo mirror/shepherd for [endo#3254](https://github.com/endojs/endo/pull/3254) (browser-test hardening) is waiting on CI, and the scholar's library ingest of kriskowal/cask is on cycle 15. Otherwise the board is quiet — no new posts or completions resolved this tick.

## Parked for maintainer feedback

- [Agoric/agoric-sdk#10190](https://github.com/Agoric/agoric-sdk/pull/10190) — build(deps): bump anylogger from 0.21.0 to 1.0.11 (waiting 597d)
- [Agoric/agoric-sdk#10196](https://github.com/Agoric/agoric-sdk/pull/10196) — build(deps): bump axios from 1.6.8 to 1.7.7 in /a3p-integration/proposals/s:stake-bld (waiting 593d)
- [Agoric/agoric-sdk#10197](https://github.com/Agoric/agoric-sdk/pull/10197) — build(deps): bump micromatch from 4.0.5 to 4.0.8 in /a3p-integration/proposals/s:stake-bld (waiting 593d)
- [Agoric/agoric-sdk#10198](https://github.com/Agoric/agoric-sdk/pull/10198) — build(deps): bump rollup from 2.79.1 to 2.79.2 in /a3p-integration/proposals/s:stake-bld (waiting 593d)
- [Agoric/agoric-sdk#10203](https://github.com/Agoric/agoric-sdk/pull/10203) — build(deps): bump tar from 6.2.0 to 6.2.1 in /a3p-integration/proposals/s:stake-bld (waiting 593d)
- [Agoric/agoric-sdk#10204](https://github.com/Agoric/agoric-sdk/pull/10204) — build(deps): bump ws from 7.5.9 to 7.5.10 in /a3p-integration/proposals/s:stake-bld (waiting 593d)
- [Agoric/agoric-sdk#10205](https://github.com/Agoric/agoric-sdk/pull/10205) — build(deps): bump braces from 3.0.2 to 3.0.3 in /a3p-integration/proposals/s:stake-bld (waiting 593d)
- [Agoric/agoric-sdk#10321](https://github.com/Agoric/agoric-sdk/pull/10321) — build(deps): bump http-proxy-middleware from 2.0.6 to 2.0.7 (waiting 575d)
- [Agoric/agoric-sdk#10521](https://github.com/Agoric/agoric-sdk/pull/10521) — build(deps): bump cross-spawn from 7.0.3 to 7.0.6 in /multichain-testing (waiting 542d)
- [Agoric/agoric-sdk#10522](https://github.com/Agoric/agoric-sdk/pull/10522) — build(deps): bump cross-spawn from 7.0.3 to 7.0.6 in /a3p-integration (waiting 542d)
- [Agoric/agoric-sdk#10531](https://github.com/Agoric/agoric-sdk/pull/10531) — build(deps): bump cross-spawn from 6.0.5 to 6.0.6 in /a3p-integration/proposals/n:upgrade-next (waiting 551d)
- [Agoric/agoric-sdk#10795](https://github.com/Agoric/agoric-sdk/pull/10795) — refactor: prepare for use of non-trapping integrity trait (waiting 282d)
- [Agoric/agoric-sdk#10855](https://github.com/Agoric/agoric-sdk/pull/10855) — feat: Classify trigger in contextualized slog sender (waiting 378d)
- [Agoric/agoric-sdk#10977](https://github.com/Agoric/agoric-sdk/pull/10977) — chore: fix some function names in comment (waiting 329d)
- [Agoric/agoric-sdk#11023](https://github.com/Agoric/agoric-sdk/pull/11023) — update NOTICE (waiting 490d)
- [Agoric/agoric-sdk#11086](https://github.com/Agoric/agoric-sdk/pull/11086) — chore: make function comments match function names (waiting 476d)
- [Agoric/agoric-sdk#11091](https://github.com/Agoric/agoric-sdk/pull/11091) — chore(SwingSet): Remove URL from kernel compartment endowments (waiting 474d)
- [Agoric/agoric-sdk#11095](https://github.com/Agoric/agoric-sdk/pull/11095) — chore: remove redundant words in comment (waiting 474d)
- [Agoric/agoric-sdk#11107](https://github.com/Agoric/agoric-sdk/pull/11107) — build(deps): bump @babel/runtime from 7.23.9 to 7.26.10 (waiting 436d)
- [Agoric/agoric-sdk#11108](https://github.com/Agoric/agoric-sdk/pull/11108) — build(deps): bump @babel/helpers from 7.23.9 to 7.26.10 (waiting 436d)
- [Agoric/agoric-sdk#11112](https://github.com/Agoric/agoric-sdk/pull/11112) — build(deps): bump golang.org/x/net from 0.18.0 to 0.36.0 in /golang/cosmos/e2e_test (waiting 397d)
- [Agoric/agoric-sdk#11162](https://github.com/Agoric/agoric-sdk/pull/11162) — refactor: use the built-in min to simplify the code (waiting 457d)
- [Agoric/agoric-sdk#11187](https://github.com/Agoric/agoric-sdk/pull/11187) — build(deps): bump tar-fs from 2.1.1 to 2.1.2 in /a3p-integration (waiting 421d)
- [Agoric/agoric-sdk#11190](https://github.com/Agoric/agoric-sdk/pull/11190) — build(deps): bump axios from 1.8.1 to 1.8.4 in /a3p-integration/proposals/g:gtm-fast-usdc (waiting 412d)
- [Agoric/agoric-sdk#11262](https://github.com/Agoric/agoric-sdk/pull/11262) — fix: template string parsing issue in JS expression (waiting 435d)
- [Agoric/agoric-sdk#11264](https://github.com/Agoric/agoric-sdk/pull/11264) — build(deps): bump golang.org/x/crypto from 0.31.0 to 0.35.0 in /golang/cosmos (waiting 397d)
- [Agoric/agoric-sdk#11268](https://github.com/Agoric/agoric-sdk/pull/11268) — build(deps): bump http-proxy-middleware from 2.0.6 to 3.0.5 (waiting 402d)
- [Agoric/agoric-sdk#11290](https://github.com/Agoric/agoric-sdk/pull/11290) — build(deps): bump golang.org/x/net from 0.33.0 to 0.38.0 in /golang/cosmos (waiting 397d)
- [Agoric/agoric-sdk#11388](https://github.com/Agoric/agoric-sdk/pull/11388) — build(deps): bump axios from 1.8.1 to 1.9.0 in /a3p-integration/proposals/f:fast-usdc-cctp (waiting 341d)
- [Agoric/agoric-sdk#11402](https://github.com/Agoric/agoric-sdk/pull/11402) — Jorge/8863 refactor test tooling (waiting 385d)
- [Agoric/agoric-sdk#11413](https://github.com/Agoric/agoric-sdk/pull/11413) — build(deps): bump github.com/opencontainers/runc from 1.2.0-rc.2 to 1.2.0-rc.3 in /golang/cosmos (waiting 296d)
- [Agoric/agoric-sdk#11432](https://github.com/Agoric/agoric-sdk/pull/11432) — ci: bump golangci-lint-action to v8 (waiting 387d)
- [Agoric/agoric-sdk#11473](https://github.com/Agoric/agoric-sdk/pull/11473) — build(deps): bump brace-expansion from 1.1.11 to 1.1.12 in /a3p-integration (waiting 344d)
- [Agoric/agoric-sdk#11474](https://github.com/Agoric/agoric-sdk/pull/11474) — build(deps): bump brace-expansion from 1.1.11 to 1.1.12 in /a3p-integration/proposals/f:fast-usdc-cctp (waiting 341d)
- [Agoric/agoric-sdk#11493](https://github.com/Agoric/agoric-sdk/pull/11493) — Fix Typos in Comments and Documentation (waiting 374d)
- [Agoric/agoric-sdk#11495](https://github.com/Agoric/agoric-sdk/pull/11495) — fix: update broken example link for ENDO_DELIVERY_BREAKPOINTS in docs (waiting 374d)
- [Agoric/agoric-sdk#11568](https://github.com/Agoric/agoric-sdk/pull/11568) — feat: import / export kernel DB should support compressed artifacts (waiting 353d)
- [Agoric/agoric-sdk#11602](https://github.com/Agoric/agoric-sdk/pull/11602) — build(deps): bump @opentelemetry/exporter-trace-otlp-http from 0.57.1 to 0.203.0 (waiting 314d)
- [Agoric/agoric-sdk#11625](https://github.com/Agoric/agoric-sdk/pull/11625) — build(deps): bump golang.org/x/oauth2 from 0.23.0 to 0.27.0 in /golang/cosmos (waiting 296d)
- [Agoric/agoric-sdk#11635](https://github.com/Agoric/agoric-sdk/pull/11635) — build(deps): bump form-data from 2.5.2 to 2.5.5 (waiting 338d)
- [Agoric/agoric-sdk#11637](https://github.com/Agoric/agoric-sdk/pull/11637) — build(deps): bump form-data from 4.0.2 to 4.0.4 in /a3p-integration/proposals/f:fast-usdc-cctp (waiting 307d)
- [Agoric/agoric-sdk#11653](https://github.com/Agoric/agoric-sdk/pull/11653) — build(deps): bump form-data from 4.0.2 to 4.0.4 in /multichain-testing (waiting 306d)
- [Agoric/agoric-sdk#11738](https://github.com/Agoric/agoric-sdk/pull/11738) — build(deps): bump tmp from 0.2.3 to 0.2.4 in /multichain-testing (waiting 287d)
- [Agoric/agoric-sdk#11794](https://github.com/Agoric/agoric-sdk/pull/11794) — build(deps): bump sha.js from 2.4.11 to 2.4.12 in /multichain-testing (waiting 274d)
- [Agoric/agoric-sdk#11985](https://github.com/Agoric/agoric-sdk/pull/11985) — build(deps): bump tar-fs from 2.1.1 to 2.1.4 (waiting 233d)
- [Agoric/agoric-sdk#12036](https://github.com/Agoric/agoric-sdk/pull/12036) — build(deps): bump axios from 1.10.0 to 1.12.2 in /a3p-integration (waiting 233d)
- [Agoric/agoric-sdk#12742](https://github.com/Agoric/agoric-sdk/pull/12742) — build: bump Yarn to 4.17 and install tracked git hooks (waiting 7d)
- [Agoric/documentation#965](https://github.com/Agoric/documentation/pull/965) — build: update dependencies to match dapp-offer-up (agoric-upgrade-13) (waiting 867d)
- [agoric-labs/dapp-stake-control#54](https://github.com/agoric-labs/dapp-stake-control/pull/54) — chore: log boardId of instance in coreEval (waiting 379d)
- [agoric-labs/dapp-stake-control#55](https://github.com/agoric-labs/dapp-stake-control/pull/55) — chore: punt on give.Retainer (waiting 379d)
- [endojs/Jessie#127](https://github.com/endojs/Jessie/pull/127) — Add Blockly visual programming tools for JSON, Justin, and Jessie (waiting 102d)
- [endojs/endo#2673](https://github.com/endojs/endo/pull/2673) — feat(non-trapping-shim): opt-in shim of the non-trapping integrity trait (waiting 117d)
- [endojs/endo#2675](https://github.com/endojs/endo/pull/2675) — feat(ses,pass-style): use non-trapping integrity trait for safety (waiting 117d)
- [endojs/endo#2701](https://github.com/endojs/endo/pull/2701) — fix(pass-style): fix #2700 ignore more safe async_hook extra properties (waiting 58d)
- [endojs/endo#2797](https://github.com/endojs/endo/pull/2797) — fix(pass-style): avoid symbol-named methods (waiting 118d)
- [endojs/endo#2952](https://github.com/endojs/endo/pull/2952) — fix(ses): fix #2951 stronger sniffing for v8 (waiting 118d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 43d)
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102) — chore(ci): create custom CHANGELOG generator (waiting 42d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 80d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo#3254](https://github.com/endojs/endo/pull/3254) — chore: harden browser-test installation (waiting 2d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#112](https://github.com/endojs/endo-but-for-bots/pull/112) — feat(ocapn-noise): Noise IK netlayer (#59 stack 2/3) (waiting 48d)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113) — test(ocapn-noise): integration + transport tests (#59 stack 3/3) (waiting 48d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 47d)
- [endojs/endo-but-for-bots#170](https://github.com/endojs/endo-but-for-bots/pull/170) — feat(pass-style,marshal,eventual-send,captp): pass-style promise + HandledPromise.settle (per #169) (waiting 43d)
- [endojs/endo-but-for-bots#174](https://github.com/endojs/endo-but-for-bots/pull/174) — test: repro empty-{} rendering of Error reasons in disconnect trap (#171) (waiting 43d)
- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 44d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 34d)
- [endojs/endo-but-for-bots#231](https://github.com/endojs/endo-but-for-bots/pull/231) — design(familiar): MVR release plan (closes #229) (waiting 24d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 41d)
- [endojs/endo-but-for-bots#249](https://github.com/endojs/endo-but-for-bots/pull/249) — design(ses,module-source): top-level-await proposal (leads with the test suite) (waiting 41d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 36d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 35d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 35d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1d)
- [endojs/endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) — feat(daemon-cas): extract CAS surface into @endo/daemon-cas (waiting 1d)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 2h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/playground#14](https://github.com/endojs/playground/pull/14) — feat: rock-paper-scissors (waiting 789d)
- [uber-archive/idl#89](https://github.com/uber-archive/idl/pull/89) — Prevent fetch calls on IDL files (waiting 2943d)
- [uber-archive/idl#90](https://github.com/uber-archive/idl/pull/90) — Fix various lint errors (waiting 2966d)
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (2)
- `bulletin-restructure-latest-top-parked-prs` — Restructure the bulletin: lead with "Latest" (claude summary + PR links), dro...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (136)
- `fix-ebfb-pr503-banners-and-set` — Completion report — fix-ebfb-pr503-banners-and-set
- `address-review-garden-pr4` — The worktree was removed (the earlier error was just the shell's cwd being de...
- `endojs-endo-but-for-bots-pr503-7822ef8a` — Completion report — job endojs-endo-but-for-bots-pr503-7822ef8a
- `build-mirror-closer-service` — Completion report — build-mirror-closer-service
- `mirror-and-shepherd-endo-3254` — Waiting for CI. The background poll on PR #530's matrix will notify me when i...
- … and 131 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
