# Garden bulletin

_As of 2026-06-27T04:38:46Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The bulletin loop spun up its midnight-Pacific batch — a [daily progress summary](https://github.com/endojs/endo-but-for-bots), a [dependabotany recheck](https://github.com/endojs/endo-but-for-bots) on endo-but-for-bots, a librarian audit, and an hourly scholar cycle all claimed within the same minute. The substantive thread is [endo-but-for-bots#96](https://github.com/endojs/endo-but-for-bots/pull/96): three overlapping jobs are now in flight to clear kriskowal's 2026-06-25T17:55Z CHANGES_REQUESTED — the TypeScript and design-doc asks plus the broader review follow-up. Two fresh attention directives landed on [endo-but-for-bots#543](https://github.com/endojs/endo-but-for-bots/pull/543). On the infra side, two self-improvement jobs were claimed to make the garden treat offline/transient connectivity as a clean tempfail rather than an error — one in `scripts/jobs/common.sh`'s journal fetch path, one in self-heal — following the recent connectivity-outage lessons. A run of dead-lettered messages from 06-25/06-26 cleared into done.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 23h)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 19h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 11d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 36d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 36d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 37d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (15)
- `daily-progress-summary-20260627-043531` — Daily midnight Pacific progress summary
- `deadmail-20260625T164749Z-5d8697` — Dead-lettered message — pick up its intent
- `deadmail-20260625T170305Z-ce5467` — Dead-lettered message — pick up its intent
- `dependabotany-recheck-endo-but-for-bots-20260627-043542` — Daily dependabotany recheck: endojs/endo-but-for-bots
- `endojs-endo-but-for-bots-pr543-a5b9ce6a` — attention directive on endojs/endo-but-for-bots PR #543
- `endojs-endo-but-for-bots-pr543-d40c7324` — attention directive on endojs/endo-but-for-bots PR #543
- `finbot-substrate-adapters` — GOAL: executor signing adapters for real substrates (ymax Path A / Path C)
- `finish-ebfb-pr96-review-followup-20260625` — endo-but-for-bots #96 — address kriskowal's 2026-06-25T17:55Z CHANGES_REQUEST...
- `finish-ebfb-pr96-ts-and-design-doc` — endo-but-for-bots #96 — address the two remaining 17:55Z review asks
- `improve-classify-offline-as-tempfail-in-journal-fetch` — In scripts/jobs/common.sh, make journal_fetch/sync_clone distinguish a connec...
- `improve-self-heal-treat-offline-as-clean-exit` — In scripts/jobs/self-heal-run.sh, treat the offline/transient-connectivity ca...
- `librarian-library-audit-20260627-043554` — Librarian library audit
- `pr-ebfb-96-review-followup` — endojs/endo-but-for-bots PR #96 — finish the two open CHANGES_REQUESTED revie...
- `reaper-continue` — If I understand correctly, the garden’s reaper service attempts to recover wo...
- `scholar-library-cycle-20260627-043618` — Hourly scholar library cycle

### tada (278)
- `deadmail-20260626T013640Z-c6dcd4` — The dead-lettered message's intent has already been fully enacted by the weav...
- `deadmail-20260625T170300Z-1c0a4d` — Completion report — dead-letter pickup deadmail-20260625T170300Z-1c0a4d
- `deadmail-20260626T012143Z-ea8f47` — Completion report — job deadmail-20260626T012143Z-ea8f47
- `deadmail-20260625T171700Z-c188cf` — Completion report — job deadmail-20260625T171700Z-c188cf
- `deadmail-20260625T210243Z-cade8f` — The landed state is fully intact and verified. Writing my completion report.
- … and 273 more

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
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans
- `endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers` — _low_ · Revisit: reusable file/crypto powers for the @endo/daemon-cas tests

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
