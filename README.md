# Garden bulletin

_As of 2026-06-26T07:53:29Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

A gardener just claimed [`ebfb-remove-tmp-dir-gitignore`](https://github.com/endojs/endo-but-for-bots) — removing a stray top-level `.tmp` directory from endo-but-for-bots and gitignoring it — the only job currently in flight. The board is otherwise drained (no `todo`), on the heels of a busy stretch: [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) was conducted to merge, [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) finished a retcon (now waiting on CI before any follow-up), and the finbot LLM-role-dispatch and additional-instruments tasks both completed. Nothing new is parked for review, but the queue of maintainer-authorization holds is growing — `cognito-mcp-metadata-bridge`, `synth-and-deploy-minion-town-aws`, and the exported-literals hardening follow-up all await a go-ahead before the foreman can promote them.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 2h)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 11h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 35d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 35d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 36d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (1)
- `ebfb-remove-tmp-dir-gitignore` — Remove the top-level .tmp directory from endo-but-for-bots and gitignore it

### tada (262)
- `endojs-endo-but-for-bots-pr442-retcon-feedback` — Nothing actionable until CI settles. I'll resume when the background poller (...
- `endojs-endo-but-for-bots-pr442-retcon` — Completion report: endojs-endo-but-for-bots-pr442-retcon
- `endojs-endo-but-for-bots-pr513-conduct` — Completion report — endojs/endo-but-for-bots PR #513 (conduct/merge)
- `finbot-llm-role-dispatch` — What I did
- `finbot-additional-instruments` — Completion report: finbot-additional-instruments
- … and 257 more

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
- `finbot-substrate-adapters` — _normal_ · GOAL: executor signing adapters for real substrates (ymax Path A / Path C)
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans
- `endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers` — _low_ · Revisit: reusable file/crypto powers for the @endo/daemon-cas tests

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
