---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Garden journal

This is the orphan `journal` branch of `kriskowal/garden`. The garden's transcript and message bus lives here: append-only entries under [`entries/`](entries/), the cross-machine worktree index under [`worktrees/`](worktrees/), the terminated-agent archive under [`agents/`](agents/), and this file is the maintainer dashboard.

The schema for journal entries and the writing procedure live in `roles/COMMON.md` § The journal on the `main` branch.

## Bulletin board

Items here need a human maintainer's attention. Newest at top within each section. **Agents own the bulletin entirely: they post when something needs maintainer attention and they clear the item once they detect the underlying condition is resolved.** The maintainer never edits this section. Read it, then act in the natural place (review the PR on GitHub, comment on the issue, fix the deployment); the next steward cycle picks up the change and clears the bulletin item.

If a posted item lingers because its resolution is hard to detect automatically, that itself is worth flagging in the next agent's report or as a self-improvement update to the relevant skill.

### Awaits maintainer review

(none)

### Awaits maintainer decision

(none)

### Surplus authority discovered

The steward writes here when it finds itself able to do something its authority bounds forbid. See `roles/steward/AGENT.md` § Authority enforcement on the `main` branch.

(none)

### Pre-staged authorizations

The maintainer (or the liaison after maintainer confirmation) may pre-stage `identity_switch_authorized` for boatman handoffs and per-action cross-repo authorizations for any role. The steward forwards staged authorizations into the relevant dispatch prompt; entries here are cleared after the gated dispatch happens. See `roles/COMMON.md` § External-repo etiquette on the `main` branch.

(none)

### Scheduled engagements

Date-keyed work the steward should dispatch on or after the listed date. Each cycle's close should check this section; when today >= the date, dispatch the named role and clear the row when the engagement is fulfilled (the source-of-truth doc is then expected to carry forward the next date, if any). New rows enter when a role's source doc records a scheduled engagement.

- **2026-05-17** — weekly `major-general` enumeration sweep for direct-dependency major-version upgrades on `endojs/endo-but-for-bots`. Source: prior-garden `process/major-generalship.md`, mirrored at [`entries/2026/05/13/000100Z-message-steward-d95cb2.md`](entries/2026/05/13/000100Z-message-steward-d95cb2.md). The role is not active in this garden's library yet; if today is on or past the date and the role has not landed, surface the engagement to the liaison rather than dispatching.

### Pending kriskowal reviews

PRs across all visible repos where `kriskowal` is currently a requested reviewer. The [review-queue](../roles/review-queue/AGENT.md) role on the `main` branch rewrites the body of this section between the delimiters below whenever its daemon reports an ADD or REMOVE. Order is the three-tier rule documented in `roles/review-queue/AGENT.md` § Priority and ordering: (1) ball-back-in-your-court (kriskowal's prior `CHANGES_REQUESTED` followed by a push), (2) explicit re-request, (3) fresh request newest first, with draft PRs grouped at the bottom within each tier. The maintainer reviews the PR on GitHub; the next review-queue cycle picks up the resolution and removes the line.

<!-- BEGIN pending-kriskowal-reviews -->
- [endojs/endo#3150](https://github.com/endojs/endo/pull/3150): feat(compartment-mapper): new option additionalLocations for mapNod... (by @boneskull, updated today)
- [endojs/endo-but-for-bots#106](https://github.com/endojs/endo-but-for-bots/pull/106): feat(daemon): Browser exo with structural origin allowlist (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#117](https://github.com/endojs/endo-but-for-bots/pull/117): design(daemon): NameHub interface unification (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#68](https://github.com/endojs/endo-but-for-bots/pull/68): docs(ses): document Compartment availability and OOM limits (#2742) (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#174](https://github.com/endojs/endo-but-for-bots/pull/174): test: repro empty-{} rendering of Error reasons in disconnect trap ... (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182): test(ses): isImmutableDataProperty regression for iOS Safari fix (c... (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#170](https://github.com/endojs/endo-but-for-bots/pull/170): feat(pass-style,marshal,eventual-send,captp): pass-style promise + ... (by @kriscendobot, updated today)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073): feat(patterns): Add `M.choose` (by @gibson042, updated today)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186): feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178): refactor(daemon): introduce locator scheme with @-delimited connect... (by @kriscendobot, updated today)
- [endojs/endo-but-for-bots#107](https://github.com/endojs/endo-but-for-bots/pull/107): feat(random): pure-rand v8 RandomGenerator adapter (#75 follow-up) (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#165](https://github.com/endojs/endo-but-for-bots/pull/165): design(cli,daemon): scheduled-send via reactor + schedule (PR #145 ... (by @kriscendobot, updated yesterday)
- [endojs/endo-but-for-bots#179](https://github.com/endojs/endo-but-for-bots/pull/179): feat(daemon,chat): record host commands in chat transcript via comm... (by @kriscendobot, updated 2d ago)
- [endojs/endo-but-for-bots#151](https://github.com/endojs/endo-but-for-bots/pull/151): feat(cli): endo workers verb (extracted from #128, implements desig... (by @kriscendobot, updated 2d ago)
- [endojs/endo-but-for-bots#102](https://github.com/endojs/endo-but-for-bots/pull/102): design(chat): voice command parser (by @kriscendobot, updated 2d ago)
- [endojs/endo-but-for-bots#134](https://github.com/endojs/endo-but-for-bots/pull/134): feat(docker,daemon): docker self-hosting — foreground daemon, CIDR ... (by @kriscendobot, updated 2d ago)
- [endojs/endo-but-for-bots#126](https://github.com/endojs/endo-but-for-bots/pull/126): ci: disable npm lifecycle scripts in workflows (re-opened from #26 ... (by @kriscendobot, updated 3d ago)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166): feat(endor): add rust/endor TUI skeleton (re-opened from #31 under ... (by @kriscendobot, updated 3d ago)
- [endojs/endo-but-for-bots#128](https://github.com/endojs/endo-but-for-bots/pull/128): feat(cli): assorted CLI additions — workers, zip checkin/out, read-... (by @kriscendobot, updated 3d ago)
- [endojs/endo-but-for-bots#111](https://github.com/endojs/endo-but-for-bots/pull/111): feat(ocapn): CBOR codec, NonceLocator (#59 stack 1/3) (by @kriscendobot, updated 4d ago)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113): test(ocapn-noise): integration + transport tests (#59 stack 3/3) (by @kriscendobot, updated 4d ago)
- [endojs/endo-but-for-bots#112](https://github.com/endojs/endo-but-for-bots/pull/112): feat(ocapn-noise): Noise IK netlayer (#59 stack 2/3) (by @kriscendobot, updated 4d ago)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101): feat(chat): voice input via Web Speech API (by @kriscendobot, updated 6d ago)
- [endojs/endo#2701](https://github.com/endojs/endo/pull/2701): fix(pass-style): fix #2700 ignore more safe async_hook extra proper... (by @erights, updated 14d ago)
- [endojs/hardenedjs.org#2](https://github.com/endojs/hardenedjs.org/pull/2): Some tweaks to index (by @mhofman, updated 16d ago)
- [endojs/endo#2916](https://github.com/endojs/endo/pull/2916): mermaid dep graph script improvements (by @boneskull, updated 22d ago)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137): feat: support .ts runtime modules via erasable type syntax (by @turadg, updated 1mo ago)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110): refactor(error-console-internal): for use only by ses and @endo/errors (by @erights, updated 1mo ago)
- [endojs/Jessie#127](https://github.com/endojs/Jessie/pull/127): Add Blockly visual programming tools for JSON, Justin, and Jessie (by @Copilot, updated 1mo ago)
- [endojs/endo#2675](https://github.com/endojs/endo/pull/2675): feat(ses,pass-style): use non-trapping integrity trait for safety (by @erights, updated 2mo ago)
- [endojs/endo#2673](https://github.com/endojs/endo/pull/2673): feat(non-trapping-shim): opt-in shim of the non-trapping integrity ... (by @erights, updated 2mo ago)
- [endojs/endo#2797](https://github.com/endojs/endo/pull/2797): fix(pass-style): avoid symbol-named methods (by @erights, updated 2mo ago)
- [endojs/endo#2952](https://github.com/endojs/endo/pull/2952): fix(ses): fix #2951 stronger sniffing for v8 (by @erights, updated 2mo ago)
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102): chore(ci): create custom CHANGELOG generator (by @boneskull, updated 2mo ago)
- [endojs/endo#3084](https://github.com/endojs/endo/pull/3084): drop Node 18 (by @turadg, updated 2mo ago)
- [Agoric/agoric-sdk#12036](https://github.com/Agoric/agoric-sdk/pull/12036): build(deps): bump axios from 1.10.0 to 1.12.2 in /a3p-integration (by @dependabot[bot], updated 6mo ago)
- [Agoric/agoric-sdk#11985](https://github.com/Agoric/agoric-sdk/pull/11985): build(deps): bump tar-fs from 2.1.1 to 2.1.4 (by @dependabot[bot], updated 6mo ago)
- [Agoric/agoric-sdk#11794](https://github.com/Agoric/agoric-sdk/pull/11794): build(deps): bump sha.js from 2.4.11 to 2.4.12 in /multichain-testing (by @dependabot[bot], updated 7mo ago)
- [Agoric/agoric-sdk#10795](https://github.com/Agoric/agoric-sdk/pull/10795): refactor: prepare for use of non-trapping integrity trait (by @erights, updated 7mo ago)
- [Agoric/agoric-sdk#11738](https://github.com/Agoric/agoric-sdk/pull/11738): build(deps): bump tmp from 0.2.3 to 0.2.4 in /multichain-testing (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11625](https://github.com/Agoric/agoric-sdk/pull/11625): build(deps): bump golang.org/x/oauth2 from 0.23.0 to 0.27.0 in /gol... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11413](https://github.com/Agoric/agoric-sdk/pull/11413): build(deps): bump github.com/opencontainers/runc from 1.2.0-rc.2 to... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11653](https://github.com/Agoric/agoric-sdk/pull/11653): build(deps): bump form-data from 4.0.2 to 4.0.4 in /multichain-testing (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11637](https://github.com/Agoric/agoric-sdk/pull/11637): build(deps): bump form-data from 4.0.2 to 4.0.4 in /a3p-integration... (by @dependabot[bot], updated 8mo ago)
- [Agoric/agoric-sdk#11602](https://github.com/Agoric/agoric-sdk/pull/11602): build(deps): bump @opentelemetry/exporter-trace-otlp-http from 0.57... (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#10977](https://github.com/Agoric/agoric-sdk/pull/10977): chore: fix some function names in comment (by @finaltrip, updated 9mo ago)
- [agoric-labs/xsnap-pub#50](https://github.com/agoric-labs/xsnap-pub/pull/50): refactor: Improve and align Makefiles (by @gibson042, updated 9mo ago)
- [Agoric/agoric-sdk#11635](https://github.com/Agoric/agoric-sdk/pull/11635): build(deps): bump form-data from 2.5.2 to 2.5.5 (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11474](https://github.com/Agoric/agoric-sdk/pull/11474): build(deps): bump brace-expansion from 1.1.11 to 1.1.12 in /a3p-int... (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11388](https://github.com/Agoric/agoric-sdk/pull/11388): build(deps): bump axios from 1.8.1 to 1.9.0 in /a3p-integration/pro... (by @dependabot[bot], updated 9mo ago)
- [Agoric/agoric-sdk#11473](https://github.com/Agoric/agoric-sdk/pull/11473): build(deps): bump brace-expansion from 1.1.11 to 1.1.12 in /a3p-int... (by @dependabot[bot], updated 10mo ago)
- [Agoric/agoric-sdk#11568](https://github.com/Agoric/agoric-sdk/pull/11568): feat: import / export kernel DB should support compressed artifacts (by @usmanmani1122, updated 10mo ago)
- [Agoric/agoric-sdk#11495](https://github.com/Agoric/agoric-sdk/pull/11495): fix: update broken example link for ENDO_DELIVERY_BREAKPOINTS in docs (by @VolodymyrBg, updated 11mo ago)
- [Agoric/agoric-sdk#11493](https://github.com/Agoric/agoric-sdk/pull/11493): Fix Typos in Comments and Documentation (by @leopardracer, updated 11mo ago)
- [Agoric/agoric-sdk#10855](https://github.com/Agoric/agoric-sdk/pull/10855): feat: Classify trigger in contextualized slog sender (by @usmanmani1122, updated 11mo ago)
- [agoric-labs/dapp-stake-control#55](https://github.com/agoric-labs/dapp-stake-control/pull/55): chore: punt on give.Retainer (by @dckc, updated 11mo ago)
- [agoric-labs/dapp-stake-control#54](https://github.com/agoric-labs/dapp-stake-control/pull/54): chore: log boardId of instance in coreEval (by @dckc, updated 11mo ago)
- [Agoric/agoric-sdk#11402](https://github.com/Agoric/agoric-sdk/pull/11402): Jorge/8863 refactor test tooling (by @Jorge-Lopes, updated 11mo ago)
- [Agoric/agoric-sdk#11432](https://github.com/Agoric/agoric-sdk/pull/11432): ci: bump golangci-lint-action to v8 (by @eeemmmmmm, updated 11mo ago)
- [Agoric/agoric-sdk#11290](https://github.com/Agoric/agoric-sdk/pull/11290): build(deps): bump golang.org/x/net from 0.33.0 to 0.38.0 in /golang... (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11264](https://github.com/Agoric/agoric-sdk/pull/11264): build(deps): bump golang.org/x/crypto from 0.31.0 to 0.35.0 in /gol... (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11112](https://github.com/Agoric/agoric-sdk/pull/11112): build(deps): bump golang.org/x/net from 0.18.0 to 0.36.0 in /golang... (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11268](https://github.com/Agoric/agoric-sdk/pull/11268): build(deps): bump http-proxy-middleware from 2.0.6 to 3.0.5 (by @dependabot[bot], updated 11mo ago)
- [Agoric/agoric-sdk#11190](https://github.com/Agoric/agoric-sdk/pull/11190): build(deps): bump axios from 1.8.1 to 1.8.4 in /a3p-integration/pro... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11187](https://github.com/Agoric/agoric-sdk/pull/11187): build(deps): bump tar-fs from 2.1.1 to 2.1.2 in /a3p-integration (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11262](https://github.com/Agoric/agoric-sdk/pull/11262): fix: template string parsing issue in JS expression (by @mdqst, updated 1y ago)
- [Agoric/agoric-sdk#11108](https://github.com/Agoric/agoric-sdk/pull/11108): build(deps): bump @babel/helpers from 7.23.9 to 7.26.10 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11107](https://github.com/Agoric/agoric-sdk/pull/11107): build(deps): bump @babel/runtime from 7.23.9 to 7.26.10 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#11162](https://github.com/Agoric/agoric-sdk/pull/11162): refactor: use the built-in min to simplify the code (by @threehonor, updated 1y ago)
- [Agoric/agoric-sdk#11095](https://github.com/Agoric/agoric-sdk/pull/11095): chore: remove redundant words in comment (by @MarkDaveny, updated 1y ago)
- [Agoric/agoric-sdk#11091](https://github.com/Agoric/agoric-sdk/pull/11091): chore(SwingSet): Remove URL from kernel compartment endowments (by @gibson042, updated 1y ago)
- [Agoric/agoric-sdk#11086](https://github.com/Agoric/agoric-sdk/pull/11086): chore: make function comments match function names (by @tiaoxizhan, updated 1y ago)
- [Agoric/agoric-sdk#11023](https://github.com/Agoric/agoric-sdk/pull/11023): update NOTICE (by @rootdiae, updated 1y ago)
- [Agoric/agoric-sdk#10522](https://github.com/Agoric/agoric-sdk/pull/10522): build(deps): bump cross-spawn from 7.0.3 to 7.0.6 in /a3p-integration (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10521](https://github.com/Agoric/agoric-sdk/pull/10521): build(deps): bump cross-spawn from 7.0.3 to 7.0.6 in /multichain-te... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10531](https://github.com/Agoric/agoric-sdk/pull/10531): build(deps): bump cross-spawn from 6.0.5 to 6.0.6 in /a3p-integrati... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10321](https://github.com/Agoric/agoric-sdk/pull/10321): build(deps): bump http-proxy-middleware from 2.0.6 to 2.0.7 (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10205](https://github.com/Agoric/agoric-sdk/pull/10205): build(deps): bump braces from 3.0.2 to 3.0.3 in /a3p-integration/pr... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10204](https://github.com/Agoric/agoric-sdk/pull/10204): build(deps): bump ws from 7.5.9 to 7.5.10 in /a3p-integration/propo... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10203](https://github.com/Agoric/agoric-sdk/pull/10203): build(deps): bump tar from 6.2.0 to 6.2.1 in /a3p-integration/propo... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10198](https://github.com/Agoric/agoric-sdk/pull/10198): build(deps): bump rollup from 2.79.1 to 2.79.2 in /a3p-integration/... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10197](https://github.com/Agoric/agoric-sdk/pull/10197): build(deps): bump micromatch from 4.0.5 to 4.0.8 in /a3p-integratio... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10196](https://github.com/Agoric/agoric-sdk/pull/10196): build(deps): bump axios from 1.6.8 to 1.7.7 in /a3p-integration/pro... (by @dependabot[bot], updated 1y ago)
- [Agoric/agoric-sdk#10190](https://github.com/Agoric/agoric-sdk/pull/10190): build(deps): bump anylogger from 0.21.0 to 1.0.11 (by @dependabot[bot], updated 1y ago)
- [endojs/playground#14](https://github.com/endojs/playground/pull/14): feat: rock-paper-scissors (by @dckc, updated 2y ago)
- [Agoric/documentation#965](https://github.com/Agoric/documentation/pull/965): build: update dependencies to match dapp-offer-up (agoric-upgrade-13) (by @dckc, updated 2y ago)
- [uber-archive/idl#89](https://github.com/uber-archive/idl/pull/89): Prevent fetch calls on IDL files (by @peats-bond, updated 7y ago)
- [uber-archive/idl#90](https://github.com/uber-archive/idl/pull/90): Fix various lint errors (by @peats-bond, updated 8y ago)
- [endojs/endo-but-for-bots#138](https://github.com/endojs/endo-but-for-bots/pull/138): design(ocapn): per-agent @transports for OCapN/Daemon integration (... (by @kriscendobot, updated 4d ago, draft)
- [Agoric/agoric-sdk#12081](https://github.com/Agoric/agoric-sdk/pull/12081): ci (deployment): Ymax planner deployment testing (by @Muneeb147, updated 6mo ago, draft)
- [Agoric/agoric-sdk#12149](https://github.com/Agoric/agoric-sdk/pull/12149): restrict `.ts` runtime imports from dependencies (by @mhofman, updated 6mo ago, draft)
- [Agoric/agoric-sdk#11338](https://github.com/Agoric/agoric-sdk/pull/11338): fix: prepare for symbol flip (by @erights, updated 7mo ago, draft)
- [Agoric/agoric-sdk#11447](https://github.com/Agoric/agoric-sdk/pull/11447): chore(acceptance): fix lint (by @mujahidkay, updated 11mo ago, draft)
- [Agoric/agoric-sdk#11394](https://github.com/Agoric/agoric-sdk/pull/11394): remove ses-ava (by @turadg, updated 11mo ago, draft)
- [Agoric/dapp-agoric-basics#68](https://github.com/Agoric/dapp-agoric-basics/pull/68): chore: port sell contract to .ts (by @dckc, updated 1y ago, draft)
- [endojs/endo#2404](https://github.com/endojs/endo/pull/2404): support destructuring in harden-exports (by @turadg, updated 1y ago, draft)
- [Agoric/dapp-offer-up#61](https://github.com/Agoric/dapp-offer-up/pull/61): fix: use limited publishBrandInfo power, not all of chainStorage (by @dckc, updated 2y ago, draft)
- [endojs/endo#1967](https://github.com/endojs/endo/pull/1967): test(compartment-mapper): check for resistance to bundled dependenc... (by @naugtur, updated 2y ago, draft)
- [borkshop/js#1](https://github.com/borkshop/js/pull/1): WIP cube GL demo (by @jcorbin, updated 2y ago, draft)
- [ocapn/ocapn#51](https://github.com/ocapn/ocapn/pull/51): chore: exploring CBOR, protobuf (by @dckc, updated 2y ago, draft)
- [endojs/endo#1256](https://github.com/endojs/endo/pull/1256): fix(bundle-source): assert that the entrypoint exists at all (by @warner, updated 3y ago, draft)
<!-- END pending-kriskowal-reviews -->


## Ongoing work

### Active worktrees

Full index at [`worktrees/README.md`](worktrees/README.md). Currently active or reserved:

- `endolinbot`: 4 active standing monitors (`watch-endo`, `watch-endo-but-for-bots`, `watch-agoric-sdk`, `watch-cosgov`) on `endojs/endo`, `endojs/endo-but-for-bots`, `agoric/agoric-sdk`, `dcfoundation/cosmos-proposal-builder` respectively.
- `kmkmbp2021`: 1 idle integration scratch worktree (`integrate--liaison--20260512-194515`), see the index.

### Open monitors

`endolinbot` runs 5 long-lived poll daemons via the steward's standing-monitors discipline (see `roles/steward/AGENT.md` § Standing monitors on the `main` branch). Cadences: `endo` 60s, `endo-but-for-bots` 30s, `agoric-sdk` 60s, `cosgov` 60s, `review-queue` 120s. PIDs and logs in `/tmp/garden-monitor-*.{pid,log,err}` and `/tmp/garden-review-queue.{pid,log,err}`.

### Recent activity

For the flat chronological view, run `git log` on this branch or browse [`entries/`](entries/) by date.

## Maintenance

- **Bulletin items**: posted *and cleared* by agents via `skills/journal-sync/SKILL.md` (on the `main` branch). The steward typically clears items during its per-cycle close, by re-checking each item's underlying condition (was the PR reviewed? was the decision made? was the staged authorization forwarded?) and dropping items whose condition is resolved. The maintainer never edits the bulletin.
- **Ongoing work** sections are kept current by the steward (during its per-cycle close) and by the liaison (when it does worktree-manager work). Subagents do not update these sections directly; they post `message` entries to `entries/` that the orchestrator promotes here when warranted.
- **Schemas** for entries and for worktree index files live in `roles/COMMON.md` (on the `main` branch) and in [`worktrees/README.md`](worktrees/README.md) respectively.
