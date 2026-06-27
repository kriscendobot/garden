# Garden bulletin

_As of 2026-06-27T05:06:37Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The endo-but-for-bots [#96](https://github.com/endojs/endo-but-for-bots/pull/96) review follow-up landed: the fix addressed all three of kriskowal's inline asks, but TS (`ts`/`mts`/`cts`) classification is wired through the override mechanism only — not the production default language maps — to protect the 12-known-failures invariant. A liaison message is parked asking kriskowal to confirm whether default (rather than override-only) TS classification was intended; that would be a follow-up before the PR is final. On the infrastructure side, a cluster of gardener-reliability jobs is in flight to treat offline/transient-connectivity conditions as tempfail-and-requeue rather than hard failures across `journal_fetch`/`sync_clone`, the gardener failure-capture path, and self-heal. One anomaly needs eyes: the `comment-watcher/kriskowal-garden` watcher has reported zero comments for 20 consecutive ticks despite real activity in kriskowal/garden since 2026-06-25 — the same signature as the 2026-06-24 comms outage, so jq/gh on endolinbot and the comment-source handler are worth checking.

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

- `20260627T045332Z-4a6e98` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T045332Z-4a6e98.md)

> On endojs/endo-but-for-bots PR #96 (report pr-ebfb-96-review-followup): the fix addressed all three inline asks but did NOT add ts/mts/cts to the production default language maps in `node-modules.js` — no TS parser ships by default, and adding them risked the 12-known-failures invariant. TS classification is handled only via the override mechanism (caller supplies TS language options + parsers), which the test exercises. Please confirm whether you intended default TS classification rather than override-only; if default is wanted, that's a follow-up change before the PR is final.

- `20260627T045929Z-eb7490` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T045929Z-eb7490.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 20 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.


## Board
### todo (0)
(none)

### doin (6)
- `cognito-mcp-metadata-bridge` — Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town
- `finish-ebfb-pr96-review-followup-20260625` — endo-but-for-bots #96 — address kriskowal's 2026-06-25T17:55Z CHANGES_REQUEST...
- `improve-classify-offline-as-tempfail-in-journal-fetch` — In scripts/jobs/common.sh, make journal_fetch/sync_clone distinguish a connec...
- `improve-gardener-classify-empty-output-nonzero-as-transient-requeue` — Both failed jobs (improve-classify-offline-as-tempfail-in-journal-fetch, impr...
- `improve-gardener-fold-report-and-rc-into-failure-capture` — In scripts/jobs/gardener.sh, the handler-failure branch (lines 75-103) escala...
- `improve-self-heal-treat-offline-as-clean-exit` — In scripts/jobs/self-heal-run.sh, treat the offline/transient-connectivity ca...

### tada (292)
- `finish-ebfb-pr96-ts-and-design-doc` — Completion report — finish-ebfb-pr96-ts-and-design-doc
- `pr-ebfb-96-review-followup` — Completion report — pr-ebfb-96-review-followup
- `scholar-library-index-sources-readme-20260627` — Worktree removed (the cwd error is just because my shell was inside it). Done.
- `scholar-library-index-concepts-readme-20260627` — Completion report
- `finbot-substrate-adapters` — Work complete and pushed. Here is my completion report.
- … and 287 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
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
