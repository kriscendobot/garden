# Garden bulletin

_As of 2026-06-26T01:27:04Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The [endo-but-for-bots#510](https://github.com/endojs/endo-but-for-bots/pull/510) sturdy-refs endor-syscall-retention design landed: a gardener resolved kriskowal's APPROVED review, folded in the per-OCapN-instance clarification, ran the build job green, and merged it — but flagged one decision for you. #510 merged onto its frozen base `llm-65b0abe` (186 commits behind live `llm`), which its sibling build [endo-but-for-bots#521](https://github.com/endojs/endo-but-for-bots/pull/521) still shares, so the design is on the snapshot but not yet on live `llm`; the gardener held off rebasing the shared base unilaterally and is asking whether to forward the content now (a stack-wide weave) or wait for #521 and the rest of the stack to land together. The root cause — `ci-wait-merge.sh` skipping the conductor's step-2 frozen-base unfreeze — is now queued as a spine fix, alongside `fix-ci-wait-merge-gh-path` (the gh-tool-path bug behind [endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178)'s silent conductor failure) and `garden-harden-producer-clone-lock`. Elsewhere, [endo-but-for-bots#532](https://github.com/endojs/endo-but-for-bots/pull/532) is parked on CI under shepherd/conductor poll, and a fresh attention directive on [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) was just claimed.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 40m)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 34d)

_Showing top 10 of 30 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260626T012656Z-8a244a` — from gardener:endojs-endo-but-for-bots-pr510-review-93293593, reply_to `endojs-endo-but-for-bots-pr510-review-93293593` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260626T012656Z-8a244a.md)

> PR #510 (design: sturdy-refs endor-syscall retention) — review resolved & merged.
>
> Resolved kriskowal's APPROVED review: folded the per-OCapN-instance
> clarification into the design (a2ea6f0ba), posted the build job
> (ebfb-build-sturdyrefs-endor-syscall-retention), CI green, merged via
> the conductor spine.
>
> ONE FLAG for your call (no action taken — stack coordination):
> #510 merged onto its base llm-65b0abe, a FROZEN snapshot that is 186
> commits behind live `llm` (5 ahead = the sturdy-refs stack). The
> sibling build #521 shares this same frozen base and is still OPEN, so
> the design content is now on llm-65b0abe but NOT on live `llm`. The
> conductor spine (ci-wait-merge.sh) merged directly without the
> role-brief's step-2 unfreeze-to-llm. Since unfreezing #510 alone would
> fork it off the shared stack base #521 still sits on, I did not
> rebase the shared base unilaterally. Do you want the sturdy-refs
> content forwarded to live `llm` now (a weave of the whole stack), or
> left on llm-65b0abe until #521 + the stack land together?
>
> Separately: ci-wait-merge.sh not doing the conductor step-2 frozen-base
> unfreeze may strand content on stale snapshots in general — worth a
> spine fix if the unfreeze is meant to be automatic. I can post that as
> a garden-infra job if you confirm the intended behavior.


## Board
### todo (0)
(none)

### doin (7)
- `continue-sturdyref-510-endor-syscall` — Continue #510 (sturdyref + endor-syscall retention) per maintainer decision; ...
- `ebfb-build-sturdyrefs-endor-syscall-retention` — Build: SturdyRefs endor-syscall retention slice (design #510)
- `endojs-endo-but-for-bots-pr474-53ff69c3` — attention directive on endojs/endo-but-for-bots PR #474
- `endojs-endo-but-for-bots-pr474-ae279555` — attention directive on endojs/endo-but-for-bots PR #474
- `endojs-endo-but-for-bots-pr510-review-93293593` — Review directive on endojs/endo-but-for-bots PR #510
- `fix-ci-wait-merge-gh-path` — Fix the gh-tool-path bug in ci-wait-merge.sh (root cause of #178's silent con...
- `garden-harden-producer-clone-lock` — Harden producer-clone locking so a crashed post-plan/post-job can't wedge the...

### tada (202)
- `complete-finbot-as-designed` — Completion report: complete-finbot-as-designed
- `design-mcp-oauth-aws-minion-town` — Job complete: design-mcp-oauth-aws-minion-town
- `harden-conductor-ci-wait-complete-merge` — Completion report: harden-conductor-ci-wait-complete-merge
- `endojs-endo-but-for-bots-pr532-shepherd` — Waiting on CI. The background poller (bk06xiv1m) will re-invoke me the moment...
- `endojs-endo-but-for-bots-pr532-conduct` — Inbox is empty. The background CI poll (bs3izgx4m) will notify me when PR #53...
- … and 197 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- `cognito-mcp-metadata-bridge` — _normal_ · Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town
- `synth-and-deploy-minion-town-aws` — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- `finbot-loop-daemon-wiring` — _high_ · GOAL: wire the driving loop + standing daemons to run the in-process pipeline
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
