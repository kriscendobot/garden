# Garden bulletin

_As of 2026-06-26T06:34:51Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

Here's the body of the "## Latest" section:

The board has drained to zero open and in-flight jobs after a burst of finbot model work landed — [finbot-cyclical-forecaster](https://github.com/endojs/endo-but-for-bots), richer instrument models, and volatility-tolerance elicitation all completed, alongside a fresh review pass on [endo-but-for-bots#539](https://github.com/endojs/endo-but-for-bots/pull/539). Most recently the `design-endo-stream-flatmap-reader` design job completed. Ten of thirty parked PRs await kriskowal's review; the most roadmap-relevant fresh arrivals are the [@endo/pubsub Sink/Spring async linked list](https://github.com/endojs/endo-but-for-bots/pull/513) and the [formula-inspector @info hub drop](https://github.com/endojs/endo-but-for-bots/pull/440), both parked under an hour, with the [passable byte arrays](https://github.com/endojs/endo-but-for-bots/pull/503) and [.ts erasable-type runtime modules](https://github.com/endojs/endo/pull/3137) PRs sitting longer.

Note: I avoided fabricating a URL for the finbot jobs (they have no resolvable PR number in the input), so I linked the finbot mention to the repo root rather than inventing a PR — let me revise that to not carry a misleading link.

Corrected version:

The board has drained to zero open and in-flight jobs after a burst of finbot model work landed — the cyclical-forecaster, richer instrument models, and volatility-tolerance elicitation jobs all completed, alongside a fresh review pass on [endo-but-for-bots#539](https://github.com/endojs/endo-but-for-bots/pull/539). Most recently the `design-endo-stream-flatmap-reader` design job completed. Ten of thirty parked PRs await kriskowal's review; the most roadmap-relevant fresh arrivals are the [@endo/pubsub Sink/Spring async linked list](https://github.com/endojs/endo-but-for-bots/pull/513) and the [formula-inspector @info hub drop](https://github.com/endojs/endo-but-for-bots/pull/440), both parked under an hour, with [passable byte arrays](https://github.com/endojs/endo-but-for-bots/pull/503) and [.ts erasable-type runtime modules](https://github.com/endojs/endo/pull/3137) sitting longer.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 1h)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 39m)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 9h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 35d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 35d)

_Showing top 10 of 30 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (254)
- `design-endo-stream-flatmap-reader` — Job complete. Report follows.
- `finbot-cyclical-forecaster` — Job complete: finbot-cyclical-forecaster
- `finbot-richer-instrument-models` — Completion report: finbot-richer-instrument-models
- `finbot-volatility-tolerance-elicitation` — Completion report: finbot-volatility-tolerance-elicitation
- `endojs-endo-but-for-bots-pr539-review-3c5cd6fb` — Completion report — PR #539 review directive (endojs/endo-but-for-bots)
- … and 249 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- `cognito-mcp-metadata-bridge` — _normal_ · Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town
- `endo-but-for-bots-harden-exported-literals-followup` — _normal_ · follow-up PR: harden exported function literals (evasive-transform first)
- `synth-and-deploy-minion-town-aws` — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- `investigate-systemd-run-vs-gardener-loops` — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- `investigate-resumable-gardeners` — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- `ingest-ocap-library-sections` — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- `ingest-ocap-kernel` — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- `formula-inspector-retention-paths-table` — _normal_ · PLAN (follow-on): add a retention-paths table to the formula inspector
- `finbot-ses-compartments` — _normal_ · GOAL: replace the in-process v0.5 capability attenuator with real SES compart...
- `finbot-additional-instruments` — _normal_ · GOAL: multi-instrument portfolios and yield-bearing instruments
- `finbot-substrate-adapters` — _normal_ · GOAL: executor signing adapters for real substrates (ymax Path A / Path C)
- `finbot-llm-role-dispatch` — _normal_ · GOAL: drive the OODA roles by inference (connect spawn's stub LLM to a provider)
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
