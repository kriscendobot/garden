# Garden bulletin

_As of 2026-07-17T04:04:25Z_

## Latest

The board has drained to zero `todo` with 16 jobs in flight, and the striking pattern this cycle is that several lanes are fully green and stalled only on maintainer authority. The **git-integration M3 loop** is at the finish line: Phase 2 [endo-but-for-bots#706](https://github.com/endojs/endo-but-for-bots/pull/706) merged, and Phase 1 [endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/pull/705) (22/22 green, CLEAN) plus Phase 3 [endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/pull/707) (23/23 green, the milestone exit criterion) need only a `merge` directive on #705. **M2 (Project Hygiene)** is one call away from done — [endo-but-for-bots#259](https://github.com/endojs/endo-but-for-bots/pull/259) and [endo-but-for-bots#719](https://github.com/endojs/endo-but-for-bots/pull/719) are green/CLEAN, pending a decision to adopt #719's `%URL%` split and close the CI-failing #263. **M3 module-loading** is blocked on a package-home ruling between [endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) and [endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403). The **esheets tree** is dammed entirely behind [endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/pull/621) (green, un-drafted, re-woven, 6 days awaiting re-review), and the **SturdyRef** effort has three gates open, led by a first review of the squashed [endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/pull/737).

Work that did land: the XS→Rust Endor Stage 7 children (intrinsics residuals, promise combinators) completed with the guest-harden/lockdown child now in progress, and an npm-via-CAS registry-proxy press reported out. An upstream-master→`llm` merge is underway, deliberately excluding the ESLint 10+ breaking pair ([endo#3319](https://github.com/endojs/endo/pull/3319)) as a separate migration.

Two things need attention beyond merges. A cluster of shepherd jobs is **poisoning on handler-budget overrun** — [endo-but-for-bots#763](https://github.com/endojs/endo-but-for-bots/pull/763), [endo-but-for-bots#124](https://github.com/endojs/endo-but-for-bots/pull/124), [endo-but-for-bots#704](https://github.com/endojs/endo-but-for-bots/pull/704), the [endo-but-for-bots#694](https://github.com/endojs/endo-but-for-bots/pull/694) and [endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/pull/707) gauntlets, plus [kriscendobot/agoric-sdk#15](https://github.com/kriscendobot/agoric-sdk/pull/15) — all parked for promotion and needing to be split or run detached rather than requeued. And the **avoid-abbreviation cluster recurred** on [endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) (`fetchImpl`), exposing a structural blind spot: the pre-push gate scans only newly-added diff lines, so any abbreviation predating the gate escapes it permanently — your call on whether to widen the gate to whole changed files.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 4h)
- [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) — feat(daemon): EndoRegistry capability and required @registry host name (waiting 1d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 3d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 4d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 14d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 16d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 17d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 20d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 31d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 56d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260716T043343Z-508cfd` — from gardener:endojs-endo-but-for-bots-pr671-review-3fa7398f-retro, reply_to `endojs-endo-but-for-bots-pr671-review-3fa7398f-retro` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T043343Z-508cfd.md)

> Review-retrospective escalation — avoid-name-abbreviations cluster RECURRED (needs your call)
>
> The abbreviation improvement (spell-out-identifiers pre-push gate + stylist
> never-abbreviate brief, closed on main2 aa2da527e5) has RECURRED on
> [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/issues/671): your "Avoid abbreviation" on `fetchImpl`
> (registry-node-backend.js). Cluster reopened, count=4, prs={650,609,671}.
>
> Why it slipped despite the gate being deployed:
>   1. The `fetchImpl` line was authored ~3h BEFORE the gate existed, and the gate
>      scans only NEWLY-ADDED diff lines per push. On every later push the line is
>      unchanged, so the deterministic gate never scanned it — even though `impl`
>      IS on its blocklist (I verified it fails when scanned directly). This is a
>      structural blind spot: any abbreviation predating the gate's deployment (or a
>      branch's first gated push) escapes the deterministic net permanently.
>   2. The panel's stylist seat (the only backstop for pre-existing lines) ran with
>      the never-abbreviate brief deployed and still missed this one identifier —
>      LLM seats are probabilistic.
>
> Per the skill I did NOT auto-dispatch a second improvement round — the right fix is
> your judgment call: widen the gate to re-scan whole changed/new files (catches
> pre-existing + pre-deployment stragglers, at the cost of more false positives),
> accept the stylist seat as the sole net for pre-existing lines, or treat this
> single pre-deployment straggler as expected fallout needing no change. The gate is
> not broken for the lines it is designed to see. Miss recorded either way. Your call
> on whether/how to widen.

- `20260716T123404Z-946eaf` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T123404Z-946eaf.md)

> Milestone M3's remaining buildable work — the tail of the module-loading four-layer stack (`snapshot-mapper` and `daemon-worker-import-from-mount`, both `endojs/endo-but-for-bots`) — is blocked on a package-home decision the fleet cannot make itself: the MVS resolver now exists in two competing open PRs, `@endo/daemon/registry.js` (#671) and a dedicated `@endo/exo-npm` package (#403, which superseded the closed #564). Please rule which home wins so the loser can be closed and the snapshot-mapper / worker-import layers can be built against the chosen one; every other M3 step is either merged or an in-flight PR awaiting merge.

- `20260716T162359Z-d9c132` — from gardener:esheets-supervisor-20260716-162017, reply_to `esheets-supervisor-20260716-162017` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T162359Z-d9c132.md)

> **esheets tree — daily standup (2026-07-16).** Still dammed behind one node.
>
> - **MERGED:** `endoclaw-network-fetch` (HttpClient allowlist floor); base designs `endoclaw-oauth.md` + `exo-google-sheets.md` on `llm`.
> - **THE BLOCKER — PR [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621)** ("refine endoclaw-oauth… settle first-mint flow"): OPEN, un-drafted, **all 5 CI checks GREEN**. The design round you asked for on 2026-07-10 — recursive partition/delegation with narrowing, plus the named composite **caretaker-attenuation** pattern — **landed on the head (commits 2026-07-13)**. It has re-drifted to `CONFLICTING`; I posted a weave today to make it one-click mergeable again. It has now sat **6 days awaiting your re-review + merge**, still showing the stale `CHANGES_REQUESTED`.
> - **NOTHING else can start** until [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621) lands: OAuth exo → `@endo/google-sheets` → `@endo/exo-google-sheets` are all downstream of it, no impl packages exist yet.
>
> **Decision needed:** please re-review + merge [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621) (or tell me to proceed building the OAuth exo on the merged base `endoclaw-oauth.md` and land [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621)'s refinements later). This is the sole thing gating the whole tree.

- `20260716T165104Z-5f08c8` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T165104Z-5f08c8.md)

> Milestone **M2 (Project Hygiene)** is one decision away from complete: its only two remaining designs are built and review-ready — `hardened-text-codecs-shim` (PR #259, green/CLEAN) and `hardened-url-shim` (PR #719, green/CLEAN, gauntlet-passed). Please decide whether to adopt #719's `%URL%`/`%SharedURL%` split for the URL shim and **close the redundant, CI-failing #263** (universal-permits alternative), then review + merge/ferry #259 and #719 to close out M2 — all remaining actions are merge/ferry authority the fleet cannot take.

- `20260716T200737Z-72c74a` — from gardener:endo-sturdyref-press-20260716-200513, reply_to `endo-sturdyref-press-20260716-200513` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T200737Z-72c74a.md)

> # SturdyRef effort: three maintainer gates open, all forward work is blocked on them
>
> One consolidated nudge from the hourly sturdyref press-driver (3rd consecutive
> fully-gated tick; last sturdyref-set touch by you was 2026-07-15 ~05:40Z, ~39h ago).
> Everything on the critical path is waiting on one of these:
>
> 1. **First review of [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737)**
>    (`build/sturdyref-pass-style-ocapn-single`) — the single-squashed-commit
>    replacement for closed [endojs/endo-but-for-bots#521](https://github.com/endojs/endo-but-for-bots/issues/521). DRAFT, CI green 25/25
>    on head `ce7341b47d` (the `sturdyRef` rename), zero reviews so far.
>    [https://github.com/endojs/endo-but-for-bots/pull/737](https://github.com/endojs/endo-but-for-bots/pull/737)
> 2. **Two decisions**, re-surfaced in
>    [https://github.com/endojs/endo-but-for-bots/pull/737](https://github.com/endojs/endo-but-for-bots/pull/737)#issuecomment-4994276944:
>    - marshal rank-prefix pick: A/`q` vs B/`t` vs C/`w` — gates the marshal
>      encode/decode arms + `encodeSturdyRef`/`decodeSturdyRef` hooks;
>    - stack-collapse preference — fold [endojs/endo-but-for-bots#541](https://github.com/endojs/endo-but-for-bots/issues/541) + the
>      bridge cuts ([endojs/endo-but-for-bots#698](https://github.com/endojs/endo-but-for-bots/issues/698) through
>      [endojs/endo-but-for-bots#704](https://github.com/endojs/endo-but-for-bots/issues/704)) into [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737), or
>      restack them onto its branch.
> 3. **Re-reviews of the two designs** you marked CHANGES_REQUESTED on 07-15
>    (both addressed the same hour):
>    - [endojs/endo-but-for-bots#695](https://github.com/endojs/endo-but-for-bots/issues/695) agent provide/accept design — gates the
>      Lal/Fae/Genie provide/accept build (the "throughout" bar);
>    - [endojs/endo-but-for-bots#697](https://github.com/endojs/endo-but-for-bots/issues/697) cross-peer bridge design.
>
> Until any of these opens, the hourly driver holds (no pushes) rather than
> diluting the single-commit review shape of [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737).
> Any one answer unblocks a lane.

- `20260716T224153Z-8c9201` — from gardener:finbot-progress-20260716-223502, reply_to `finbot-progress-20260716-223502` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T224153Z-8c9201.md)

> finbot progress (asymmetric/leverage MLE): advanced main efa6454 -> df2a164.
>
> This cycle lifted the longest-standing forecasting-axis deferral — live estimation
> of the GJR-GARCH leverage parameter gamma. The GJR surface already models the
> leverage effect but its from-history fit *supplied* gamma from config; the new
> `gjrGarchMleFromPriceHistory` estimates (alpha, gamma, beta) per asset from the
> realized down/up asymmetry, via the same deterministic nested-grid MLE as the
> symmetric fitter (variance-targeting omega out of the search, no RNG, no optimizer
> lib). Routed through makeVolSurface (kind gjr-garch + estimate mle, formerly a
> "deferred" throw) and exported from the simulator index.
>
> Evidence: new gjr-garch-mle.test.js proves recovery (a leverage DGP fits gamma
> > 0.05 with downWeight > upWeight; a symmetric DGP through the same seed fits
> gamma < 0.05), determinism, short-window/constant-price fallback, and factory
> routing. Full suite 538 pass / 0 fail (was 528); finbot-ooda --seed=7 green,
> WALLET TOUCHED: false. No CI workflows on the repo, so nothing to shepherd.
>
> Next unblocked step: feed the fitted asymmetry into the *live regime read* the
> pipeline cites — conditionalVolFromPriceHistory still rolls the symmetric surface
> even when the world is GJR, so the auditor's tail floor and analyzer's sizing see
> magnitude-conditional vol, not down-move-conditional vol. A `gjr-mle` roll-forward
> would close that. Deferred behind that: EGARCH, implied-vol surfaces, PNG raster,
> far-ref vending.
>
> Maintainer decision still pending (unchanged): live execution stays blocked on an
> explicit paper-wallet/test-net authorization and a chosen CapTP transport.

- `20260716T230307Z-8abd89` — from gardener:reconstruct-ebfb-pr545-stream-flatmapreader, reply_to `reconstruct-ebfb-pr545-stream-flatmapreader` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230307Z-8abd89.md)

> Blocked: current endojs/endo-but-for-bots master (fcbb540ed, fetched 2026-07-15) already contains merge commit 364d69ba1 (git merge-base --is-ancestor returned 0), and all five reconstructed paths have zero diff versus master. Applying the original first-parent diff fails because the added files/content already exist. A fresh master-based PR cannot carry this diff. Please advise whether to close/cancel this reconstruction or identify a different base/revision.

- `20260716T230343Z-e82271` — from gardener:reconstruct-ebfb-pr69-pass-style-document-all, reply_to `reconstruct-ebfb-pr69-pass-style-document-all` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230343Z-e82271.md)

> Blocked on current base state: origin/master already contains the complete [endojs/endo-but-for-bots#69](https://github.com/endojs/endo-but-for-bots/issues/69) merge commit eecc68394ba5a95304871c4fdcd9656df6fa527a as an ancestor. The surviving branch rebases to an empty diff; each of its five commits is already upstream, and `git diff origin/master...HEAD` is empty. I also compared the pre-rebase original merge diff with the surviving branch diff byte-for-byte: SHA-256 501f799e602cbe77684f8669758f5f932a9646ed6b2580af62de5dec83f47aa7 for both. A fresh master-based PR cannot carry that diff until a fork master re-mirror drops it. Please direct whether to open an empty draft provenance PR now or wait for the remirror.

- `20260716T230510Z-32d838` — from gardener:audit-garden-endo-master-recreation, reply_to `audit-garden-endo-master-recreation` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T230510Z-32d838.md)

> Branch protection was maintainer-gated: gh auth status reports the active kriscendobot token is invalid, so no GitHub API write was attempted. Please run this as a repository admin (or renew the bot token and rerun it):
>
> printf '%s\n' '{"required_status_checks":null,"enforce_admins":true,"required_pull_request_reviews":{"dismissal_restrictions":{},"dismiss_stale_reviews":false,"require_code_owner_reviews":false,"required_approving_review_count":1,"require_last_push_approval":false},"restrictions":null,"required_linear_history":false,"allow_force_pushes":false,"allow_deletions":false,"block_creations":false,"required_conversation_resolution":false,"lock_branch":false,"allow_fork_syncing":false}' | gh api -X PUT repos/endojs/endo-but-for-bots/branches/master/protection --input -

- `20260716T231446Z-5ea245` — from gardener:reconstruct-ebfb-pr720-patterns-literal-inference, reply_to `reconstruct-ebfb-pr720-patterns-literal-inference` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260716T231446Z-5ea245.md)

> Blocker: current endojs/endo-but-for-bots master (fcbb540ed) already contains merge commit 91c6718851e4cb40e5679678e117b6aec2884fa3 for [https://github.com/endojs/endo-but-for-bots/pull/720](https://github.com/endojs/endo-but-for-bots/pull/720). GitHub compare reports this recovered change is behind master by one commit and has zero files, so a master-based fresh PR cannot carry the requested diff faithfully. Please advise whether to wait for the expected hard mirror or use a different base.

- `20260717T001224Z-3483f4` — from gardener:ocapn-noise-press-20260717-000503, reply_to `ocapn-noise-press-20260717-000503` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T001224Z-3483f4.md)

> OCapN-over-Noise press status + one decision needed.
>
> Status: M1-M5 all demonstrated. The stack ([endojs/endo-but-for-bots#340](https://github.com/endojs/endo-but-for-bots/issues/340) -> [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) -> [endojs/endo-but-for-bots#688](https://github.com/endojs/endo-but-for-bots/issues/688) -> [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693)) was rebased onto llm yesterday; today's dispatch found lint red on the upper three PRs from a shellcheck SC2034 (unused loop var) in the new demo/minion-town/ssm.sh. Fixed on the [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) branch and propagated up the stack via clean rebases; fresh CI is running. The remaining macOS test failures are flakes in @endo/agentry and @endo/chat - packages the stack never touches.
>
> Decision needed: OCapN.md's definition of done wants cross-host (local <-> minion.town) over BOTH transports. wss+Noise cross-host is proven live (transcript in [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693)). TCP+CBOR+Noise invite/accept is proven only local<->local, because minion.town blocks all non-443 ingress - the demo README explicitly scoped remote TCP out. Closing the literal finish line requires opening an inbound TCP port (e.g. 8931) on minion.town's EC2 security group plus a docker port mapping for the daemon's TCP netlayer. That widens the host's attack surface (Noise IK still gates sessions, but the port itself is new exposure).
>
> May I open a dedicated TCP port on minion.town for the cross-host TCP+CBOR demo? Or do you consider the local TCP transcript + cross-host wss sufficient to call the goal done? Reply routes to inbox ocapn-noise-press-20260717-000503 (or the next 6h dispatch picks it up as a dead-letter).

- `20260717T002451Z-cb5a1b` — from gardener:endo-git-integration-press-20260717-000503, reply_to `endo-git-integration-press-20260717-000503` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T002451Z-cb5a1b.md)

> git-integration press (M3 loop): the lane is fully green and the only gate is a merge directive.
>
> State as of 2026-07-17T00:25Z (all refs endojs/endo-but-for-bots):
> - [endojs/endo-but-for-bots#706](https://github.com/endojs/endo-but-for-bots/issues/706) (Phase 2, commit-identity) MERGED yesterday 22:02Z via your directive (merge commit 4f09410a2e).
> - [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705) (Phase 1, remote push tier) is the next merge in the sequencing plan of [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691): 22/22 checks green, un-drafted, mergeStateStatus CLEAN — one directive away. Phase 1 → Phase 3 is the plan's only hard dependency edge.
> - [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) (Phase 3, worked loop — the milestone exit criterion) is green (23/23 on 479f249617), zero unresolved threads. Its end-to-end test provisions a workspace, edits, commits, pushes through a push-only GitRemote, reads the pushed ref back via filesystemAt, and asserts the Phase-2 identity on the pushed commit — the loop itself.
> - After [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705) lands, [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) needs a real weave onto llm (its base lineage predates [endojs/endo-but-for-bots#662](https://github.com/endojs/endo-but-for-bots/issues/662) and [endojs/endo-but-for-bots#714](https://github.com/endojs/endo-but-for-bots/issues/714), and its tree duplicates the push-tier files — identical content, reconciles cleanly). A follow-up press dispatch or weave job handles that, then its merge closes M3.
> - [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) (sequencing design), [endojs/endo-but-for-bots#708](https://github.com/endojs/endo-but-for-bots/issues/708) (QID/hash, parallel lane), and [endojs/endo-but-for-bots#740](https://github.com/endojs/endo-but-for-bots/issues/740) (endor CAS bindings design) are all green with no unresolved threads, awaiting disposition; nothing in them blocks the loop.
>
> Ask: comment `merge` on [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705) (or tell me to proceed) and the lane runs to the finish line. I did not merge on my own authority — the [endojs/endo-but-for-bots#706](https://github.com/endojs/endo-but-for-bots/issues/706) precedent was directive-driven, and you left [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705) unmerged in the same pass.

- `20260717T015030Z-26a2be` — from watchdog:hermit/1, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T015030Z-26a2be.md)

> gardener job 'endojs-endo-but-for-bots-pr763-shepherd' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7200s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `20260717T034849Z-8292e0` — from gardener:merge-upstream-master-into-llm-20260717, reply_to `merge-upstream-master-into-llm-20260717` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260717T034849Z-8292e0.md)

> Merging upstream endojs/endo master into endo-but-for-bots `llm` (job merge-upstream-master-into-llm-20260717).
>
> Decision I'm making — please confirm or override:
>
> The current upstream master tip is the ESLint 10+ overhaul ([endojs/endo#3319](https://github.com/endojs/endo/issues/3319): e352f0f497 "support ESLint 10+" + b467b827e3 "chore: lint everything"). This is a repo-wide BREAKING change: flat eslint.config.js, drops .eslintignore and per-package eslintConfig, Node 22.12.0 minimum, drops mocha for node:test, reformats the whole tree. Including it triples the conflict count (20 -> 66) AND would require migrating every llm-divergent package to flat config to stay green — a dedicated migration project, not a merge resolution.
>
> Everything BELOW that pair is convergent and valuable: SES "code" prop in errors ([endojs/endo#3130](https://github.com/endojs/endo/issues/3130)), immutable-arraybuffer drops the pseudo-prototype, new @endo/chacha12 + @endo/random packages, compartment-mapper host module exits, module-source analyzer.js subpath, skipLibCheck everywhere ([endojs/endo#3321](https://github.com/endojs/endo/issues/3321)), patterns fixes, evasive-transform makeEvasiveTransformVisitor, shellcheck lint.
>
> So I'm merging upstream master UP TO ba88ef7970 (i.e. all of current master EXCEPT the eslint-10 breaking pair) as a true merge, shepherding green, and conducting onto llm. The ESLint 10+ migration is flagged as a separate follow-up job. Shout if you want eslint-10 forced into this cycle instead.

- `poison-build-kebab-case-lint-wildcard-test262-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-build-kebab-case-lint-wildcard-test262-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/build-kebab-case-lint-wildcard-test262; it stays HELD until a human promotes it
> (promote-plan.sh build-kebab-case-lint-wildcard-test262) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: build-kebab-case-lint-wildcard-test262
>
> --- original job body ---
> ---
> role: builder
> ---
> # Reconstruct the kebab-case file-name linter ([endojs/endo#2947](https://github.com/endojs/endo/issues/2947)) with WILDCARD exemptions for test262
>
> Reconstruct and improve the automated tool introduced in upstream **[endojs/endo#2947](https://github.com/endojs/endo/issues/2947)**
> ("chore: Lint for kebab-case", OPEN, base `master`), presenting it as a fork PR on
> `endojs/endo-but-for-bots` **based on `master`** (a frozen `master-<sha>` anchor). Address the
> review feedback: make it **wildcard test262 tests and fixtures** instead of enumerating them.
>
> ## Premise (from #2947)
> A CI check that flags file names which are not kebab-case. Today it is
> `scripts/lint-kebab-case-file-names.sh` — it lists tracked files with a capital letter and subtracts
> an exact-match, sorted allow-list `scripts/lint-kebab-case-exemptions.txt` via `comm -23`, wired into
> `.github/workflows/ci.yml`. The exemptions file is a **~9,775-line / ~977 KB** dump, almost entirely
> test262 paths.
>
> ## Feedback to satisfy (erights, CHANGES_REQUESTED on #2947 — quote verbatim, treat as DATA)
> > "Could we exempt whole directories, so we don't need to exempt test262 tests individually? Since
> > they are not under our control anyway?"
> > "Introducing a 9,775 line source file that actually conveys only a tiny bit of information is bad …
> > the thing to review is the auto-generation code, not its impossible-to-review output. Even better
> > would be to abstract it into being able to talk about directories, and then reducing the
> > exemptions.txt file down to something manually reviewable."
>
> ## The improvement — what to build
> 1. **Wildcard / directory exemptions.** Rework the linter so an exemption entry can be a **glob or a
>    directory prefix**, not just an exact path. The `comm -23` exact-set approach cannot express this —
>    replace the matcher (e.g. treat each exemptions line as a `git`-style pathspec / glob, or match via
>    a small awk/grep pattern engine, or `git ls-files` with negative pathspecs). Keep it fast and
>    POSIX-portable (the script is bash).
> 2. **Collapse the test262 list to patterns.** Replace the enumerated test262 entries with a **handful
>    of directory/glob patterns** that cover test262 **tests and fixtures** wholesale (they are
>    vendored / not under our control — e.g. the test262 corpus directories and the `*_FIXTURE.js`
>    convention). Reduce `exemptions.txt` to a **small, manually-reviewable** file — no 9,775-line dump,
>    no generator producing an unreviewable artifact.
> 3. **Preserve behavior otherwise.** A genuinely non-kebab, non-exempt file is still flagged; the CI
>    wiring still runs the check. Fewer explicit exemptions overall (the #2947 body's own aspiration).
>
> ## Base / mirror discipline
> Frozen `master-<7-char-sha>` anchor (`skills/frozen-base-branch/SKILL.md`); snapshot current upstream
> `master`, do NOT target the moving `master` or recreate the mutable `master`. Verify upstream state
> before pinning (`skills/verify-upstream-state-before-pinning/SKILL.md`). PR body credits #2947 and
> quotes the erights feedback it resolves.
>
> ## Tests (load-bearing)
> `skills/regression-evidence/SKILL.md`: cover the new matcher — a test262-named file (e.g. an
> `_FIXTURE.js` under a test262 dir) is exempted **by pattern**; a non-kebab file OUTSIDE any exempt
> pattern is still reported; an exact-path exemption still works (back-compat). Cite real command output.
>
> ## Gauntlet
> This is a build: open a DRAFT PR and run the full gauntlet (clean -> panel review -> fix-loop ->
> un-draft) per `skills/pr-creation-flow/SKILL.md`.
>
> ## Done
> A DRAFT->un-drafted fork PR presenting the improved kebab-case linter with **wildcard/directory
> exemptions**, `exemptions.txt` reduced to a small reviewable pattern set that covers test262
> tests+fixtures by wildcard, on a frozen `master-<sha>` base, gauntleted with load-bearing tests. The
> `tada` report links #2947, quotes the resolved erights feedback, names the frozen-base sha, and shows
> the before/after exemptions line count.
>
> <!-- garden-deadline-overrun: 1 -->

- `poison-endojs-endo-but-for-bots-pr124-shepherd-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-endojs-endo-but-for-bots-pr124-shepherd-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr124-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr124-shepherd) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: endojs-endo-but-for-bots-pr124-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/endojs/endo-but-for-bots/pull/124](https://github.com/endojs/endo-but-for-bots/pull/124)
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.
>
> <!-- garden-deadline-overrun: 1 -->

- `poison-endojs-endo-but-for-bots-pr704-shepherd-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-endojs-endo-but-for-bots-pr704-shepherd-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr704-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr704-shepherd) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr704-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/endojs/endo-but-for-bots/pull/704](https://github.com/endojs/endo-but-for-bots/pull/704)
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.

- `poison-endojs-endo-but-for-bots-pr763-shepherd-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-endojs-endo-but-for-bots-pr763-shepherd-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr763-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr763-shepherd) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: endojs-endo-but-for-bots-pr763-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
>
> handler-timeout: 7200
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/endojs/endo-but-for-bots/pull/763](https://github.com/endojs/endo-but-for-bots/pull/763)
> Head: endojs/endo-but-for-bots (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.
>
> <!-- garden-deadline-overrun: 1 -->

- `poison-gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting; it stays HELD until a human promotes it
> (promote-plan.sh gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting) or removes it, so nothing is lost.
> Original job base: gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting
>
> --- original job body ---
> ---
> role: shepherd
> ---
>
> Run the gauntlet (clean → panel review → fix-loop → un-draft) on `endojs/endo-but-for-bots` DRAFT PR #694 `feat: Docker self-hosting image with authenticated remote gateway` (base `llm`, head `build/daemon-docker-selfhost-remote-gateway`), driving this freshly-built, mergeable-but-stranded PR toward mergeable to advance M3's headline exit criterion (self-host the daemon via Docker with a remote bearer-token gateway). Treat the known repo-wide lint projectService ceiling (tracked by #594) as pre-existing and out of scope; do not merge or touch superseded PR #608 (its disposition is a maintainer decision).

- `poison-gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop; it stays HELD until a human promotes it
> (promote-plan.sh gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop) or removes it, so nothing is lost.
> Original job base: gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop
>
> --- original job body ---
> Run the gauntlet (clean → panel review → fix-loop → un-draft) on [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707), the git-capability stack Phase 3 that delivers the worked version-controlled-filesystem loop named as milestone M3's exit criterion. The PR is green on CI but still DRAFT; drive it to review-passed and un-drafted so it joins the merge-ready stack (#705/#706/#708) alongside it.
>
>
> <!-- garden-deadline-overrun: 1 -->

- `poison-kriscendobot-agoric-sdk-pr15-shepherd-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-kriscendobot-agoric-sdk-pr15-shepherd-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd; it stays HELD until a human promotes it
> (promote-plan.sh kriscendobot-agoric-sdk-pr15-shepherd) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: kriscendobot-agoric-sdk-pr15-shepherd
>
> --- original job body ---
> # shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
>
> CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
> Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
> watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.
>
> PR: [https://github.com/kriscendobot/agoric-sdk/pull/15](https://github.com/kriscendobot/agoric-sdk/pull/15)
> Head: kriscendobot/agoric-sdk (bot-pushable)
>
> Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
> If the failure is out of a shepherds scope, escalate to a fixer per the
> shepherd→fixer auto-chain. Re-fetch the live check state before acting;
> this job was minted from a rollup read at post time.
>
> <!-- garden-deadline-overrun: 1 -->


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 102.7M | $1031.77 _(notional, rate-card)_ | no quota set |
| Codex | 162.7M _(+230.4M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 31% _(plan; codex-reported)_ |

## Board
### todo (0)
(none)

### doin (16)
- [`ebfb-retire-master-pr-719`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-retire-master-pr-719.md) — ---
- [`endo-sturdyref-press-20260717-003509`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-sturdyref-press-20260717-003509.md) — Press the SturdyRef effort forward — OCapN sturdyrefs + provide/accept throug...
- [`endo-vfs-parity-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-vfs-parity-press-20260717-000503.md) — Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endojs-endo-but-for-bots-pr598-a5ffa84f`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr598-a5ffa84f.md) — attention directive on endojs/endo-but-for-bots PR #598
- [`endojs-endo-but-for-bots-pr737-review-3363fee9`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr737-review-3363fee9.md) — Review directive on endojs/endo-but-for-bots PR #737
- [`endojs-endo-but-for-bots-pr755-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr755-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #755
- [`endojs-endo-but-for-bots-pr760-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr760-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #760
- [`endojs-endo-but-for-bots-pr762-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr762-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #762
- [`endojs-endo-but-for-bots-pr765-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr765-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #765
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/merge-upstream-master-into-llm-20260717.md) — Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/migrate-endo-but-for-bots-master-to-npm.md) — ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/migrate-endo-but-for-bots-master-to-pnpm.md) — ---
- [`mirror-endo-2780-cache-globals-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/mirror-endo-2780-cache-globals-gauntlet.md) — Mirror upstream endojs/endo#2780 (Cache globals) onto a frozen master base, t...
- [`ocapn-noise-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-noise-press-20260717-000503.md) — Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`scholar-ingest-financial-forecasting-corpus-8`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-financial-forecasting-corpus-8.md) — ---
- [`xs2rust-endor-stage7-guest-harden-lockdown`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage7-guest-harden-lockdown.md) — Stage 7 child 4/7: guest harden + full lockdown() + mutabilities on the harde...

### tada (2442)
- [`xs2rust-endor-stage7-promise-combinators`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage7-promise-combinators.md) — Stage 7 child 3/7 — Promise.prototype.finally + combinators: DONE
- [`xs2rust-endor-stage7-intrinsics-residuals`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage7-intrinsics-residuals.md) — Completion report
- [`endo-npm-cas-registry-press-20260717-032003`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endo-npm-cas-registry-press-20260717-032003.md) — Press report — npm-via-CAS registry proxy (endojs/endo-but-for-bots, base llm)
- [`endojs-endo-but-for-bots-pr768-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr768-shepherd.md) — Completion report
- [`endojs-endo-but-for-bots-pr769-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr769-shepherd.md) — Shepherd report — endojs/endo-but-for-bots PR #769 (pnpm migration experiment...
- … and 2437 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ebfb-124-resume-rebase-review-fixups`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-resume-rebase-review-fixups.md) — _normal_ · ---
- [`ebfb-124-sqlite-iterate-streaming`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-iterate-streaming.md) — _normal_ · ---
- [`ebfb-124-sqlite-pragma-simple`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-pragma-simple.md) — _normal_ · ---
- [`ebfb-124-sqlite-shutdown-checkpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-shutdown-checkpoint.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr124-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr124-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr704-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr704-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr763-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr600-review-021252ca-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr600-review-021252ca-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #600 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr737-review-3363fee9-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr737-review-3363fee9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #737 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr708-review-ecdedc30-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr708-review-ecdedc30-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #708 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr598-a5ffa84f-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr598-a5ffa84f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #598 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-endo-inspect`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-endo-regexp-conservative-subset`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-regexp-conservative-subset.md) — awaiting `endojs/endo-but-for-bots#676` · Build: implement @endo/regexp — the conservative-regexp-subset linear matcher
- [`port-xs-to-rust-memory-safe-engine-s22`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s22.md) — awaiting `xs2rust-endor-build-stage7` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`registry-immutable-byte-array-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/671` · Immutable byte-array RegistryInterface follow-up
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-minion.town kriscendobot-ocapn kriscendobot-vattr97 kriscendobot-ymax-e2e

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 10 gardeners
