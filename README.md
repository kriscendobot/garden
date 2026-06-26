# Garden bulletin

_As of 2026-06-26T05:06:50Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

[endo-but-for-bots#297](https://github.com/endojs/endo-but-for-bots/pull/297) just landed its review directive and moved to done. Two jobs are now in flight: a rebase directive on [endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) and a fresh attention directive on [endo-but-for-bots#539](https://github.com/endojs/endo-but-for-bots/pull/539). The sturdyref continuation needs a maintainer call: [#510](https://github.com/endojs/endo-but-for-bots/pull/510) merged ~17s after its job was claimed and its head branch was deleted, so the design continues as DRAFT successor [#539](https://github.com/endojs/endo-but-for-bots/pull/539) off the stacked `llm-65b0abe` base — awaiting your word to run it through the gamut and un-draft (#511 marked deferred). Separately, the gardener flagged a typo in your [#521](https://github.com/endojs/endo-but-for-bots/pull/521): the exported `getStudyRefLocator` is missing an `r` and should be `getSturdyRefLocator` across source, exports, and tests — offered as a fixer rename pending your go-ahead.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 4h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 4h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 8h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 3d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 35d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 35d)

_Showing top 10 of 30 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260626T013612Z-6a7140` — from gardener:continue-sturdyref-510-endor-syscall, reply_to `continue-sturdyref-510-endor-syscall` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260626T013612Z-6a7140.md)

> Sturdyref job (continue #510, defer #511) — done, with one deviation to flag.
>
> #510 had already MERGED (into llm-65b0abe at 95ecf86) ~17s after I claimed the job, and its head branch was deleted — so "push to #510" wasn't possible. I continued the design as a successor DRAFT PR off the same base:
>
>   #539 — design(sturdy-refs/endor): continue #510
>   https://github.com/endojs/endo-but-for-bots/pull/539  head 333249e8
>
> Folded in: proactive per-turn deleteExport promoted to a REQUIREMENT (both retention paths now GC-timing-independent), FinalizationRegistry demoted to an optional off-by-default leak detector, the local-only-at-the-boundary rule, and a flexible optional `type` hint on the SturdyRef. OCapN-instance-specificity + inert-data-box framing were already folded pre-merge (a2ea6f0ba); reaffirmed. #511 marked deferred with a note. Pointer comment left on merged #510.
>
> #521 typo (your PR): the exported symbol is getStudyRefLocator ("Study", missing the r) — should be getSturdyRefLocator, across source/exports/tests. Flagged on #521; I can push a rename if you want it.
>
> Two things for your call: (a) #539 is a draft off the stacked base llm-65b0abe — happy to run it through the gamut / un-draft on your word; (b) want the #521 rename done by a fixer?


## Board
### todo (0)
(none)

### doin (2)
- `endojs-endo-but-for-bots-pr379-rebase` — rebase directive on endojs/endo-but-for-bots PR #379
- `endojs-endo-but-for-bots-pr539-6364bb7d` — attention directive on endojs/endo-but-for-bots PR #539

### tada (236)
- `endojs-endo-but-for-bots-pr297-17268b2c` — What the directive asked
- `finbot-loop-daemon-wiring` — Completion report — finbot-loop-daemon-wiring
- `self-heal-fix-garden-design-poller-orphan-superseded-unit` — Retired the orphan garden-design-poller unit end to end. All three job items ...
- `fix-enable-services-timer-coverage` — Completion report
- `self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-source-section3-unguarded-pipefail` — Completion report
- … and 231 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- `cognito-mcp-metadata-bridge` — _normal_ · Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town
- `endo-but-for-bots-harden-exported-literals-followup` — _normal_ · follow-up PR: harden exported function literals (evasive-transform first)
- `synth-and-deploy-minion-town-aws` — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- `finbot-richer-forecasting` — _high_ · GOAL: richer ensemble forecasting + the visual histogram projection
- `investigate-systemd-run-vs-gardener-loops` — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- `investigate-resumable-gardeners` — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- `ingest-ocap-library-sections` — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- `ingest-ocap-kernel` — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- `formula-inspector-retention-paths-table` — _normal_ · PLAN (follow-on): add a retention-paths table to the formula inspector
- `design-endo-stream-flatmap-reader` — _normal_ · PLAN: @endo/stream flatMapReader — 1-to-many reader transform (flatten a stre...
- `finbot-ses-compartments` — _normal_ · GOAL: replace the in-process v0.5 capability attenuator with real SES compart...
- `finbot-additional-instruments` — _normal_ · GOAL: multi-instrument portfolios and yield-bearing instruments
- `finbot-substrate-adapters` — _normal_ · GOAL: executor signing adapters for real substrates (ymax Path A / Path C)
- `finbot-llm-role-dispatch` — _normal_ · GOAL: drive the OODA roles by inference (connect spawn's stub LLM to a provider)
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
