# Garden bulletin

_As of 2026-07-21T17:13:45Z_

## Latest

A gardener consolidated the maintainer inbox — [199 unread entries folded into ~30 open decisions across 13 topics](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260721T171232Z-297e3f.md), each original acknowledged, nothing deleted. The headline asks: the entire `@endo/exo-google-sheets` tree has been dammed 11 days behind a single stale `CHANGES_REQUESTED` on [endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/pull/621) (addressed and re-panelled green); several M2/M3 shims are built, green, and merge-gated — [#259](https://github.com/endojs/endo-but-for-bots/pull/259) (text-codecs), [#705](https://github.com/endojs/endo-but-for-bots/pull/705)/[#707](https://github.com/endojs/endo-but-for-bots/pull/707) (git remote-push), [#694](https://github.com/endojs/endo-but-for-bots/pull/694) (Docker self-host); and the SturdyRef lanes remain held on four arbitration calls. On the settled side, the CAS-registry stack [#802](https://github.com/endojs/endo-but-for-bots/pull/802)/[#805](https://github.com/endojs/endo-but-for-bots/pull/805)/[#812](https://github.com/endojs/endo-but-for-bots/pull/812) all merged, and a weave stripped three unrelated commits off [#719](https://github.com/endojs/endo-but-for-bots/pull/719) to leave a clean ses-only URL shim. Two infra items want a human hand: the deployed roots on both hosts still need a physical drain-and-clean after the native-git and xs2rust press leaks (guard already landed on `main2`), and deploys have been stalled since 07-17 now that the remote is fixed.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/pull/621) — design: refine endoclaw-oauth as the connector credential foundation (settle first-mint flow) (waiting 1d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 2d)
- [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) — feat(daemon): EndoRegistry capability and required @registry host name (waiting 3d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 4d)
- [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) — feat(pass-style): narrow byteArray to plain frozen Uint8Array (waiting 4d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 4d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 7d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 19d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 22d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260721T171232Z-297e3f` — from consolidate-maintainer-inbox-omnibus, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260721T171232Z-297e3f.md)

> from: gardener:consolidate-maintainer-inbox-omnibus
> subject: Maintainer inbox omnibus — 199 entries consolidated by topic
>
> **Maintainer inbox omnibus.**
> `omnibus-digest: maintainer-inbox`
> Consolidated **199** unread entries → **~30 open items across 13 topics**. Every original was acknowledged (moved to `inbox/maintainer/read/`); the entries below are only what still wants your attention, deduped and grouped. Duplicated status nudges (daily standups, hourly press re-sends, watchdog overrun notices, self-heal blips, poison parks) were folded into one line each. Nothing was deleted.
>
> Resolved-since-posting (verified live, no action): [[endojs/endo-but-for-bots#585](https://github.com/endojs/endo-but-for-bots/issues/585)]([https://github.com/endojs/endo-but-for-bots/pull/585](https://github.com/endojs/endo-but-for-bots/pull/585)) (content-store powers) MERGED; [[endojs/endo-but-for-bots#661](https://github.com/endojs/endo-but-for-bots/issues/661)]([https://github.com/endojs/endo-but-for-bots/pull/661](https://github.com/endojs/endo-but-for-bots/pull/661)) (confined-HTTP agent tool) MERGED; the CAS-registry stack [[endojs/endo-but-for-bots#802](https://github.com/endojs/endo-but-for-bots/issues/802)]([https://github.com/endojs/endo-but-for-bots/pull/802](https://github.com/endojs/endo-but-for-bots/pull/802)) / [[endojs/endo-but-for-bots#805](https://github.com/endojs/endo-but-for-bots/issues/805)]([https://github.com/endojs/endo-but-for-bots/pull/805](https://github.com/endojs/endo-but-for-bots/pull/805)) / [[endojs/endo-but-for-bots#812](https://github.com/endojs/endo-but-for-bots/issues/812)]([https://github.com/endojs/endo-but-for-bots/pull/812](https://github.com/endojs/endo-but-for-bots/pull/812)) all MERGED (so the pr802-conduct hold and the "approve [endojs/endo-but-for-bots#805](https://github.com/endojs/endo-but-for-bots/issues/805)" ask are moot); the upstream-master→`llm` merge landed via [[endojs/endo-but-for-bots#773](https://github.com/endojs/endo-but-for-bots/issues/773)]([https://github.com/endojs/endo-but-for-bots/pull/773](https://github.com/endojs/endo-but-for-bots/pull/773)).
>
> ---
>
> ## 1. Google Sheets / endoclaw-OAuth (esheets) — 11 days stalled on one review
>
> The whole `@endo/exo-google-sheets` tree is dammed behind a single review. Reported daily 2026-07-16 through 2026-07-21 (seven standups, identical ask).
>
> - **Re-review + approve [[endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621)]([https://github.com/endojs/endo-but-for-bots/pull/621](https://github.com/endojs/endo-but-for-bots/pull/621))** (refine endoclaw-oauth, caretaker-attenuation) — OPEN, non-draft, CI green, but `reviewDecision` is a stale `CHANGES_REQUESTED` from 2026-07-10; the revision was addressed, re-panelled green, and re-requested 2026-07-17. **Or** (b) authorize building the OAuth exo now on the already-merged base design `endoclaw-oauth.md`, landing [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/issues/621)'s refinements later. Nothing downstream (OAuth exo, `@endo/google-sheets`, `@endo/exo-google-sheets`) exists on `llm` until one of these.
>
> ## 2. SturdyRef — all lanes held on your arbitration since 2026-07-15
>
> One consolidated nudge, re-sent hourly then daily (four re-sends, plus liaison follow-ups). The driver holds all pushes to keep review shapes clean; any one answer unblocks a lane.
>
> - **Shim placement:** [[endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737)]([https://github.com/endojs/endo-but-for-bots/pull/737](https://github.com/endojs/endo-but-for-bots/pull/737)) (embedded in pass-style, single squashed commit) versus [[endojs/endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/issues/774)]([https://github.com/endojs/endo-but-for-bots/pull/774](https://github.com/endojs/endo-but-for-bots/pull/774)) (standalone `@endo/sturdyref`). Both CI-green; [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737) is `CHANGES_REQUESTED`, [endojs/endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/issues/774) unreviewed.
> - **Marshal rank-prefix pick:** A/`q` versus B/`t` versus C/`w` (re-surfaced at [pull/737#issuecomment-4994276944]([https://github.com/endojs/endo-but-for-bots/pull/737](https://github.com/endojs/endo-but-for-bots/pull/737)#issuecomment-4994276944)).
> - **Stack-collapse preference:** fold [[endojs/endo-but-for-bots#541](https://github.com/endojs/endo-but-for-bots/issues/541)]([https://github.com/endojs/endo-but-for-bots/pull/541](https://github.com/endojs/endo-but-for-bots/pull/541)) plus the bridge cuts ([[endojs/endo-but-for-bots#698](https://github.com/endojs/endo-but-for-bots/issues/698)]([https://github.com/endojs/endo-but-for-bots/pull/698](https://github.com/endojs/endo-but-for-bots/pull/698)) → [[endojs/endo-but-for-bots#700](https://github.com/endojs/endo-but-for-bots/issues/700)]([https://github.com/endojs/endo-but-for-bots/pull/700](https://github.com/endojs/endo-but-for-bots/pull/700))) into [endojs/endo-but-for-bots#737](https://github.com/endojs/endo-but-for-bots/issues/737), or restack onto its branch.
> - **Design re-reviews** you marked `CHANGES_REQUESTED` (all addressed the same hour): [[endojs/endo-but-for-bots#695](https://github.com/endojs/endo-but-for-bots/issues/695)]([https://github.com/endojs/endo-but-for-bots/pull/695](https://github.com/endojs/endo-but-for-bots/pull/695)) (agent provide/accept), [[endojs/endo-but-for-bots#697](https://github.com/endojs/endo-but-for-bots/issues/697)]([https://github.com/endojs/endo-but-for-bots/pull/697](https://github.com/endojs/endo-but-for-bots/pull/697)) (cross-peer bridge), [[endojs/endo-but-for-bots#539](https://github.com/endojs/endo-but-for-bots/issues/539)]([https://github.com/endojs/endo-but-for-bots/pull/539](https://github.com/endojs/endo-but-for-bots/pull/539)) (closely-held enlivenment).
>
> ## 3. Milestone M2 (Project Hygiene) — two vetted shims, merge-gated
>
> Reported ~12 times by the foreman. Both designs built and mergeable; only merge authority plus two hygiene calls remain.
>
> - **Text codecs shim [[endojs/endo-but-for-bots#259](https://github.com/endojs/endo-but-for-bots/issues/259)]([https://github.com/endojs/endo-but-for-bots/pull/259](https://github.com/endojs/endo-but-for-bots/pull/259))** — OPEN, non-draft, CLEAN, green. Merge it. Note: a builder found an errant direct-to-`master` push `536f82d18` (design-nonconformant, never gauntleted) and recommends `git revert 536f82d18` before merging.
> - **URL shim — pick one and close the other:** [[endojs/endo-but-for-bots#719](https://github.com/endojs/endo-but-for-bots/issues/719)]([https://github.com/endojs/endo-but-for-bots/pull/719](https://github.com/endojs/endo-but-for-bots/pull/719)) (`%URL%`/`%SharedURL%` split) versus [[endojs/endo-but-for-bots#263](https://github.com/endojs/endo-but-for-bots/issues/263)]([https://github.com/endojs/endo-but-for-bots/pull/263](https://github.com/endojs/endo-but-for-bots/pull/263)) (universal-permits). [endojs/endo-but-for-bots#719](https://github.com/endojs/endo-but-for-bots/issues/719) currently carries three unrelated commits (`fix(cbor)` + `fix(ci)`) and is `UNSTABLE`/`CHANGES_REQUESTED` — decide: retcon it to ses-only, or promote the builder's ready clean ses-only rebuild.
>
> ## 4. Milestone M3 (Remote Access + Coding Capabilities) — merge-gated
>
> Reported ~6 times by the foreman. [[endojs/endo-but-for-bots#661](https://github.com/endojs/endo-but-for-bots/issues/661)]([https://github.com/endojs/endo-but-for-bots/pull/661](https://github.com/endojs/endo-but-for-bots/pull/661)) is now merged; the rest is green-and-gated.
>
> - **Merge [[endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705)]([https://github.com/endojs/endo-but-for-bots/pull/705](https://github.com/endojs/endo-but-for-bots/pull/705))** (git remote-push Phase 1) — the original merge directive (liaison message 2026-07-17) went unread. Then **weave + merge [[endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707)]([https://github.com/endojs/endo-but-for-bots/pull/707](https://github.com/endojs/endo-but-for-bots/pull/707))** (worked-loop, the M3 exit criterion; OPEN, CLEAN).
> - **Merge [[endojs/endo-but-for-bots#694](https://github.com/endojs/endo-but-for-bots/issues/694)]([https://github.com/endojs/endo-but-for-bots/pull/694](https://github.com/endojs/endo-but-for-bots/pull/694))** (Docker self-host + remote gateway) — green and un-drafted ~9 days.
> - Parked poisoned gauntlets for [endojs/endo-but-for-bots#694](https://github.com/endojs/endo-but-for-bots/issues/694) and [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) sit at `gate: go-ahead` in `jobs/plan/`; promoting the merges above supersedes them.
>
> ## 5. exo-zip [endojs/endo-but-for-bots#160](https://github.com/endojs/endo-but-for-bots/issues/160) — one design call
>
> - **[[endojs/endo-but-for-bots#160](https://github.com/endojs/endo-but-for-bots/issues/160)]([https://github.com/endojs/endo-but-for-bots/pull/160](https://github.com/endojs/endo-but-for-bots/pull/160))** (`feat/exo-zip-package`): a shepherd drove CI green except 9 tests, one root cause. Decision: OK to retire exo-unzip's documented base64-concat "no mid-stream padding" guarantee and adopt the platform byte-reader protocol (**Option A**, recommended — it is why `ReadableBlobInterface` exists), or keep the base64-concat contract via a bespoke interface (Option B)? The parked `endojs-endo-but-for-bots-pr160-fixer` will proceed with Option A once promoted.
>
> ## 6. endo-daemon data-plane press — finish line reached, wind-down pending
>
> - The arc's finish line is met (design [[endojs/endo-but-for-bots#662](https://github.com/endojs/endo-but-for-bots/issues/662)]([https://github.com/endojs/endo-but-for-bots/pull/662](https://github.com/endojs/endo-but-for-bots/pull/662)) + implementation through [[endojs/endo-but-for-bots#792](https://github.com/endojs/endo-but-for-bots/issues/792)]([https://github.com/endojs/endo-but-for-bots/pull/792](https://github.com/endojs/endo-but-for-bots/pull/792)), and [endojs/endo-but-for-bots#585](https://github.com/endojs/endo-but-for-bots/issues/585) now merged). Evidence: [[kriskowal/garden#50](https://github.com/kriskowal/garden/issues/50) comment]([https://github.com/kriskowal/garden/issues/50](https://github.com/kriskowal/garden/issues/50)#issuecomment-5013536728). **Decision: reply "wind it down"** so the liaison removes the 6-hourly `schedules/endo-daemon-data-plane-press.md`; otherwise it keeps re-verifying. Residual: [[endojs/endo-but-for-bots#797](https://github.com/endojs/endo-but-for-bots/issues/797)]([https://github.com/endojs/endo-but-for-bots/pull/797](https://github.com/endojs/endo-but-for-bots/pull/797)) (Git-over-HTTP back-plane design, DRAFT) belongs to the git-integration arc.
>
> ## 7. Upstream integration follow-ups
>
> - **ESLint 10 flat-config migration:** the upstream master merge deliberately stopped just before it (whole-repo reformat, Node 22.12 minimum, mocha→`node:test`, ~63 errors on one package alone). Post a dedicated "adopt upstream ESLint 10 flat config on `llm`" job **only when you want it** — it is a multi-cycle re-lint, not a merge.
> - **Browser-tests coverage gap:** `browser-test.yml` filters on base `[master]`, so PRs retargeted to `master-<sha>` reflections silently skip Browser Tests (confirmed on [[endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475)]([https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475))). Want the fork's filter widened to `[master, 'master-*']` (a one-line fork-local divergence), or accept the loss?
> - **[[endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475)]([https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475))** (byte-array) — CI green, awaiting your + erights re-review.
>
> ## 8. minion.town / MCP-endo-guest — one ~15-minute human action ([[kriskowal/garden#58](https://github.com/kriskowal/garden/issues/58)]([https://github.com/kriskowal/garden/issues/58](https://github.com/kriskowal/garden/issues/58)))
>
> Reported hourly for many cycles; genuinely maintainer-only. Pick a lane:
>
> - **(A)** Run **Gate 1 V2–V5** in a browser: add `https://minion.town/mcp` as a claude.ai custom connector, complete the GitHub-federated Cognito login, and capture the `redirect_uri` value(s) Claude presents (needed permanently — Cognito has no DCR endpoint). Record V2–V5 on the issue. **Or (B)** authorize building the Gate 2/3 GuestControl transplant ahead of Gate 1 (unit-validated against an in-memory backend, live validation sequenced later — the §10.4 discipline you already accepted; zero production risk). Default with no reply: keep the review cadence, no gate-jump.
> - **iroh lane:** [[kriscendobot/minion.town#12](https://github.com/kriscendobot/minion.town/issues/12)]([https://github.com/kriscendobot/minion.town/pull/12](https://github.com/kriscendobot/minion.town/pull/12)) design (an `ocapn-cbor-quic-iroh` validation lane, no inbound port needed). Queue the follow-up orchestration (rebase [[endojs/endo-but-for-bots#777](https://github.com/endojs/endo-but-for-bots/issues/777)]([https://github.com/endojs/endo-but-for-bots/pull/777](https://github.com/endojs/endo-but-for-bots/pull/777)) → merge → author boot script → stand up the live lane), or hold for your review of the design first?
>
> ## 9. OCapN-over-Noise — one exposure decision
>
> - M1–M5 all proven live (cross-host wss and local TCP+CBOR). **Decision: open a non-443 TCP port on minion.town's security group** for the cross-host TCP+CBOR demo (widens attack surface; Noise IK still gates sessions), **or accept local-TCP + cross-host-wss as the goal met?** The press substance is complete; its parked poison copies are safe to remove.
>
> ## 10. finbot ([kriscendobot/finbot](https://github.com/kriscendobot/finbot)) — standing gates + a security finding
>
> Progress reported every 6 hours (~15 cycles); the model track advanced steadily and needs no decision. Open items:
>
> - **Live execution is blocked** on explicit paper-wallet/test-net authorization **and** a chosen CapTP transport — the standing gate carried through every cycle.
> - **Transport for `spawnSigningWorker`:** Unix socket versus TCP; persistent worker versus spawn-fresh (`designs/cap-attenuation.md`, Process boundary).
> - **Default policy flip:** should `significanceAlpha` become the default for the live auto-family forecaster path? It changes proposal hashes and needs a re-baselined fixture.
> - **Security review flag ([[kriscendobot/finbot#1](https://github.com/kriscendobot/finbot/issues/1)]([https://github.com/kriscendobot/finbot/pull/1](https://github.com/kriscendobot/finbot/pull/1)), now merged):** the "real SES compartment attenuator" framing **overstates** what landed — no `Compartment` is constructed, `attenuated.globals` is discarded, and tool filtering is fail-open on empty capabilities. No live-funds escape today (subagents are stubs), but before any live executor: correct the docstring claims, wire an actual Compartment runner, and make tool vending fail-closed.
>
> ## 11. xs2rust-endor engine port ([[endojs/endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/issues/600)]([https://github.com/endojs/endo-but-for-bots/pull/600](https://github.com/endojs/endo-but-for-bots/pull/600))) — needs a dedicated builder
>
> The hourly press cannot make code progress — every timeboxed dispatch exhausts on assessment and is reaped at the wall (this drove the bulk of the watchdog/poison noise below). To finish:
>
> - **Assign a dedicated builder** (not the hourly press) who can work iteratively across dispatches on: **Bar 2** (`test:rust` green — blocked on non-generatable boot bundles `ses_boot.js` and friends) and **Bar 3** (test262 parity — 19 failures, likely some C-XS oracle bugs rather than endor bugs).
> - **Host-gating call:** the stage-10 live-CapTP diagnosis reproduces only on the **leader** host `endolin-garden2`; follower claims misroute. Confirm whether to re-post that diagnosis host-pinned to garden2.
>
> ## 12. Fleet health / infra — one real cleanup, the rest self-healed
>
> - **Deployed-root corruption (self-healed; physical cleanup still needs a human/liaison):** two jobs escaped into the deployed root's git — a native-git test fixture (07-17, left the root on a fake `feature` branch, ran a stale tree four days) and an xs2rust press (07-21, rewrote `remote.origin.url` to endo-but-for-bots, breaking the bus host-wide). Origin/refs restored; the durable guard landed on `main2` (`a0cd3eae13`, `journal_remote()` now refuses a foreign origin). **Remaining:** drain and physically clean the deployed roots on **endolin-garden2** and **endolin-garden** (off the fixture branch, delete fixture branches, sweep ~150 `tmp/native-git-*` and press-log dirs) per `context/operations/deploy.md`; posted as board job `fix-garden-root-test-leak-cleanup`. A project-side fix (native-git tests should use `$TMPDIR`, not `./tmp`) is still open in endo-but-for-bots.
> - **Deploys stalled since 07-17** (root at `374deede65`, `origin/main2` ahead) — worth confirming a deliberate deploy now that the remote is fixed.
> - **Recurring, durable signal:** the hourly `xs2rust-endor-press` and several presses **deterministically overrun** the 2400s handler budget every cycle. The fix is to split them into claim-sized stages or run detached — see topic 11. All the individual watchdog/self-heal/poison notices were transient or point here.
> - **comment-watcher defect:** a "Shepherd." directive on [[endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/issues/671)]([https://github.com/endojs/endo-but-for-bots/pull/671](https://github.com/endojs/endo-but-for-bots/pull/671)) was silently swallowed by a tada-dedup collision (PR sat conflicting three days); durable fix parked as `fix-comment-watcher-verb-directive-tada-dedup`.
>
> ## 13. Housekeeping decisions (low urgency)
>
> - **Access request:** @kumavis interacted with the issue inbox on [[kriskowal/garden#51](https://github.com/kriskowal/garden/issues/51)]([https://github.com/kriskowal/garden/issues/51](https://github.com/kriskowal/garden/issues/51)#issuecomment-5021654884) but is not on the maintainer allowlist, so it was dropped. Run `scripts/jobs/add-maintainer.sh kumavis` if you want them to drive by issue, then ask them to re-post (this one was already dropped).
> - **Reconstruct/retire master-mirror PRs — all blocked, recommend closing:** the four `reconstruct-ebfb` jobs ([[endojs/endo-but-for-bots#545](https://github.com/endojs/endo-but-for-bots/issues/545)]([https://github.com/endojs/endo-but-for-bots/pull/545](https://github.com/endojs/endo-but-for-bots/pull/545)), [[endojs/endo-but-for-bots#69](https://github.com/endojs/endo-but-for-bots/issues/69)]([https://github.com/endojs/endo-but-for-bots/pull/69](https://github.com/endojs/endo-but-for-bots/pull/69)), [[endojs/endo-but-for-bots#720](https://github.com/endojs/endo-but-for-bots/issues/720)]([https://github.com/endojs/endo-but-for-bots/pull/720](https://github.com/endojs/endo-but-for-bots/pull/720))) rebase to an empty diff (their merges are already ancestors of master); and [[endojs/endo-but-for-bots#251](https://github.com/endojs/endo-but-for-bots/issues/251)]([https://github.com/endojs/endo-but-for-bots/pull/251](https://github.com/endojs/endo-but-for-bots/pull/251)) is superseded upstream (recommend close). Branch-protection on the fork's `master` needs a repository-admin `gh api PUT` (the bot token was invalid) — `audit-garden-endo-master-recreation` supplied the exact command.
> - **Parked builder experiments** (`gate: go-ahead`, no urgency): npm and pnpm migration experiments (`migrate-endo-but-for-bots-master-to-npm` / `-pnpm`), `build-kebab-case-lint-wildcard-test262`, and the Phase-1 durable-MapStore build `build-daemon-mapstore-gh59` ([[kriskowal/garden#59](https://github.com/kriskowal/garden/issues/59)]([https://github.com/kriskowal/garden/issues/59](https://github.com/kriskowal/garden/issues/59))) — the last is real feature work that overran its handler budget and should be split rather than dropped.
> - **Research pointer (FYI):** a scholar ingested the RQGM paper ([arxiv 2606.26294](https://arxiv.org/abs/2606.26294)) proposing evaluation-epochs / panel-calibration; a design spec already landed (`1c9f29fefd`). No action unless you want to pilot it.
>
> ---
>
> *Full originals for every folded entry remain under `inbox/maintainer/read/`.*


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 79.4M | $908.28 _(notional, rate-card)_ | no quota set |
| Codex | 454.3M _(+524.4M cached)_ | n/a _(ChatGPT plan — no per-token $; plan-metered)_ | no quota set |

## Board
### todo (0)
(none)

### doin (1)
- [`xs2rust-endor-press-20260721-165010`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260721-165010.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (3152)
- [`consolidate-maintainer-inbox-omnibus`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/consolidate-maintainer-inbox-omnibus.md) — Completion report
- [`minion-town-agenda-review-20260721-165010`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-agenda-review-20260721-165010.md) — Completion report
- [`weave-endo-but-for-bots-pr719-drop-unrelated-commits`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/weave-endo-but-for-bots-pr719-drop-unrelated-commits.md) — The weave is complete and verified. Final state confirmed: PR #719 is now a c...
- [`orch-conduct-endor-npm-805-812`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/orch-conduct-endor-npm-805-812.md) — orchestration orch-conduct-endor-npm-805-812 — complete
- [`conduct-ebfb-812-relres`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/conduct-ebfb-812-relres.md) — Completion report
- … and 3147 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-daemon-mapstore-gh59`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-mapstore-gh59.md) — _normal_ · Build Phase 1: durable MapStore in the endo pet daemon (closes kriskowal/gard...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ebfb-124-resume-rebase-review-fixups`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-resume-rebase-review-fixups.md) — _normal_ · ---
- [`ebfb-124-sqlite-iterate-streaming`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-iterate-streaming.md) — _normal_ · ---
- [`ebfb-124-sqlite-pragma-simple`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-pragma-simple.md) — _normal_ · ---
- [`ebfb-124-sqlite-shutdown-checkpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-shutdown-checkpoint.md) — _normal_ · ---
- [`endo-vfs-parity-press-20260717-182002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-vfs-parity-press-20260717-182002.md) — _normal_ · Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endojs-endo-but-for-bots-pr124-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr124-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr160-fixer`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr160-fixer.md) — _normal_ · fixer (shepherd→fixer auto-chain) on endojs/endo-but-for-bots PR #160
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr704-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr704-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr763-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`endojs-endo-but-for-bots-pr809-review-2f33af27`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-2f33af27.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #809
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`ocapn-noise-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260717-000503.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260717-182002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260717-182002.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260719-003513`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260719-003513.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-endo-but-for-bots-pr626-stack-surgery-eval`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval.md) — _normal_ · Weave endojs/endo-but-for-bots PR #626 (Phase-5 stack-surgery eval) onto llm
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer
- [`xs2rust-endor-press-20260720-022510`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-022510.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-123515`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-123515.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-145005`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-145005.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-172003`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-172003.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-192031`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-192031.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-203502`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-203502.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-215002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-215002.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-230516`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-230516.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-002001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-002001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-022003`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-022003.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-043501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-043501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-053503`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-053503.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-063505`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-063505.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-100501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-100501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-122001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-122001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-143501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-143501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-stage10p-fresh-env-sweep`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-stage10p-fresh-env-sweep.md) — _normal_ · Stage-10p child 3 (re-posted by s47 after the serial-halt sweep — spec unchan...

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-endo-inspect`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-endo-regexp-conservative-subset`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-regexp-conservative-subset.md) — awaiting `endojs/endo-but-for-bots#676` · Build: implement @endo/regexp — the conservative-regexp-subset linear matcher
- [`daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s48`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s48.md) — awaiting `xs2rust-endor-stage10p-fresh-env-sweep` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`registry-immutable-byte-array-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/671` · Immutable byte-array RegistryInterface follow-up
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-chrome-native-function-caller-arguments-repro kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-garden kriscendobot-minion.town kriscendobot-ocapn kriscendobot-vattr97 kriscendobot-ymax-e2e kriscendobot-ymax-stdio-mcp

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 10 gardeners
