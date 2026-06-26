# Garden bulletin

_As of 2026-06-26T01:36:25Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The sturdy-refs/endor-syscall retention design [endo-but-for-bots#510](https://github.com/endojs/endo-but-for-bots/pull/510) merged after its APPROVED review was resolved, but it landed onto the frozen snapshot base `llm-65b0abe` (186 commits behind live `llm`) rather than being unfrozen — so the design content is stranded on the stale base alongside its still-open sibling build [endo-but-for-bots#521](https://github.com/endojs/endo-but-for-bots/pull/521), and the gardener has explicitly deferred to the maintainer on whether to weave the whole stack forward to live `llm`. Because #510 merged and its branch was deleted seconds after the continuation job was claimed, the follow-on design work opened instead as a fresh draft, [endo-but-for-bots#539](https://github.com/endojs/endo-but-for-bots/pull/539), which promotes proactive per-turn `deleteExport` to a requirement and demotes `FinalizationRegistry` to an optional leak detector; it awaits a go-ahead to run the gamut. Two items want a maintainer call: a flagged typo on #521 (`getStudyRefLocator` → `getSturdyRefLocator` across source/exports/tests, fixer-fixable on request), and a possible spine bug — `ci-wait-merge.sh` skips the conductor's step-2 frozen-base unfreeze, which may strand content on stale snapshots generally. The build job for the retention slice is in flight, and `garden-harden-producer-clone-lock` is being worked to keep a crashed post from wedging future job posts.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4h)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 50m)
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

### doin (5)
- `continue-sturdyref-510-endor-syscall` — Continue #510 (sturdyref + endor-syscall retention) per maintainer decision; ...
- `ebfb-build-sturdyrefs-endor-syscall-retention` — Build: SturdyRefs endor-syscall retention slice (design #510)
- `endojs-endo-but-for-bots-pr442-rebase` — rebase directive on endojs/endo-but-for-bots PR #442
- `endojs-endo-but-for-bots-pr474-53ff69c3` — attention directive on endojs/endo-but-for-bots PR #474
- `garden-harden-producer-clone-lock` — Harden producer-clone locking so a crashed post-plan/post-job can't wedge the...

### tada (205)
- `fix-ci-wait-merge-gh-path` — Completion report — fix-ci-wait-merge-gh-path
- `endojs-endo-but-for-bots-pr474-ae279555` — Completion report
- `endojs-endo-but-for-bots-pr510-review-93293593` — Completion report: endojs-endo-but-for-bots-pr510-review-93293593
- `complete-finbot-as-designed` — Completion report: complete-finbot-as-designed
- `design-mcp-oauth-aws-minion-town` — Job complete: design-mcp-oauth-aws-minion-town
- … and 200 more

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
