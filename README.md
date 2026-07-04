# Garden bulletin

_As of 2026-07-04T16:51:12Z_

## Latest

Two operational hazards dominate and both want a maintainer's eye. First, the SheetSync/Endo research for [issue #25](https://github.com/kriskowal/garden/issues/25) finished but the gardener **could not post its reply** — the job landed on raw host `endolin` (no `/.dockerenv`, no real `gh`), so the drafted comment is parked in the maintainer inbox for manual posting as kriscendobot. That same report flags gardener 15 on endolinbot2 running outside the container, and a companion message warns that `garden-journal-worktree-keeper` is logging a dangling gitdir to a stale `garden2/.git` and pruning live per-job `gardener-wt-*` worktrees out from under running gardeners here — the known "journal worktree severed" pattern, needing a `git worktree prune` + repair on this host before it corrupts an in-flight commit.

On the work front, the gauntlet completed on [endo-but-for-bots#604](https://github.com/endojs/endo-but-for-bots/pull/604), and a wave of review directives is now in flight across [#288](https://github.com/endojs/endo-but-for-bots/pull/288), [#442](https://github.com/endojs/endo-but-for-bots/pull/442), [#589](https://github.com/endojs/endo-but-for-bots/pull/589), [#592](https://github.com/endojs/endo-but-for-bots/pull/592), [#595](https://github.com/endojs/endo-but-for-bots/pull/595), and [#602](https://github.com/endojs/endo-but-for-bots/pull/602), with retrospectives queued for each. The `design-streamlined-onboarding` design is complete and **awaiting your review of its § 5 open questions** — especially Q2, the security-flavored auto-mode default; its four build jobs are gated on that decision, though phase 1 (launcher + image + guard hook) has already been claimed.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 2d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 5d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 8d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 18d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 43d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 43d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 45d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 44d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 52d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260704T164740Z-fa5477` — from gardener:issue-kriskowal-garden-25, reply_to `issue-kriskowal-garden-25` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T164740Z-fa5477.md)

> RE: issue kriskowal/garden#25 (https://github.com/kriskowal/garden/issues/25) — SheetSync/Endo research.
>
> I finished the research and wrote the reply, but I could NOT post it myself:
> this job landed on the raw host 'endolin' (no /.dockerenv, GARDEN=endolinbot2)
> where there is no real 'gh' binary behind the fleet gh wrapper (exit 127), so
> no GitHub API is reachable from this environment. Please post the comment below
> as kriscendobot on issue #25 (do NOT close it — the submitter closes it).
>
> Environment follow-up worth checking: gardener 15 on endolinbot2 appears to be
> running outside the container (host endolin), so its gh/issue-inbox actions can't
> reach GitHub. Other issue/PR jobs claimed there will hit the same wall.
>
> ----- BEGIN ISSUE #25 COMMENT (post verbatim) -----
> ## SheetSync in Endo: a plugin + ocaps sketch
>
> Researched SheetSync and the family of "bank → Google Sheets via Plaid" tools, then mapped the shape onto Endo. Summary of what SheetSync is, then how the same result decomposes into an Endo caplet driven by object capabilities, and where the real work would be.
>
> ### What SheetSync actually is
>
> SheetSync ([getsheetsync.com](https://getsheetsync.com), and the near-identical BankToSheets, SheetLink, BankSync) is a **Google Sheets add-on** that:
>
> 1. Links your bank accounts through **Plaid** (12,000+ institutions) from a sidebar inside the sheet.
> 2. Pulls historical + incremental transactions and balances.
> 3. Writes them straight into the spreadsheet, refreshing on a schedule — no CSV exports.
>
> The trust story, in Plaid's own model:
>
> - You never hand the app your bank password. **Plaid** holds the bank credentials. Plaid's browser flow (`Link`) returns a short-lived, single-use `public_token`, which the app exchanges (`/item/public_token/exchange`) for a long-lived `access_token`. That `access_token` is a **read-only bearer capability to one bank "Item"** — it can read transactions but cannot move money. The app then polls `/transactions/sync` (cursor-paginated, webhook-driven) for deltas.
> - SheetSync-the-service must **store that `access_token`** and also hold a **Google OAuth token** with a scope broad enough to write your sheet.
>
> So there are already two capability-ish bearer tokens in play. The weaknesses are the classic bearer-token weaknesses: they are **copyable secrets** (whoever reads the bytes wields them), the holder **cannot attenuate** them (an `access_token` is the whole Item, a Google scope is often broader than "this one sheet"), **revocation is coarse and remote**, and the app that holds them has **ambient authority** — its entire codebase (and supply chain) can use them however it likes. You are trusting SheetSync's servers, and every dependency they ship, with those two secrets.
>
> ### The Endo version: shrink the trusted core, hand out narrow object capabilities
>
> Endo already gives us exactly the decomposition this wants. The move is to stop treating "the app" as one ambient blob holding two secrets, and instead run the *application logic* as a **confined caplet** (the "plugin") that is handed only two **object capabilities** — one per resource — and nothing else. POLA by construction.
>
> **1. Two small, individually-audited connector caplets hold the real secrets.**
>
> Something must still speak HTTPS to Plaid and to Google and hold the actual bearer credentials — Endo doesn't make that vanish, it *relocates and shrinks* it. Author two minimal, trusted caplets the human authorizes once through the powerbox:
>
> - A **`plaid` connector** that owns the Plaid client-id/secret and the network endowment. Its job is the Link handshake and `/transactions/sync`. Crucially, when a link completes it does **not** return an `access_token` string — it mints and returns an **object**: an attenuated, read-only `item` facet whose only methods are `E(item).syncTransactions(cursor)` / `E(item).getBalances()`. The copyable secret stays inside the connector; the guest downstream holds an unforgeable reference, not bytes it can exfiltrate or replay.
> - A **`google-sheets` connector** that owns the Google OAuth token. From it the human mints a **single-sheet writer facet** scoped to exactly one spreadsheet + range: `E(sheet).appendRows(rows)`. This is attenuation — a broad OAuth scope wrapped once, then handed out narrow.
>
> These two caplets are the entire trusted computing base for credentials. They are small and change rarely, so they are auditable in a way a full add-on codebase is not.
>
> **2. The SheetSync caplet is confined and endowed with just those two facets.**
>
> The actual sync logic — the big, frequently-updated, least-trusted code, the "plugin" in the issue's terms — is an Endo caplet (a bundle you `endo install`, run in its own worker as a **guest**). At instantiation the host endows it with exactly:
>
> - `plaidItem` — the read-only Item facet,
> - `sheet` — the single-sheet writer facet,
> - `scheduler`/`clock` — to run the sync loop (optionally; or drive it from a Plaid webhook, see below).
>
> It gets **no network endowment, no filesystem, no other sheet, no other Item, no host powers.** Its complete attack surface is those three references. A malicious or supply-chain-compromised SheetSync caplet can, at worst, read transactions you had already made read-only and write them into the one sheet you chose. It cannot phone home, cannot touch your other spreadsheets, cannot move money, cannot enumerate your other bank Items. That is the whole point.
>
> **3. Naming, granting, and revocation are the human's, via the powerbox.**
>
> In Endo the human *host* grants capabilities under **petnames**. You'd `endo mkguest sheetsync`, then grant it `plaidItem` and `sheet` by petname. Because every grant is a caretaker/attenuating forwarder, **revocation is local and instant**: drop the facet and SheetSync is cut off from that bank or that sheet — no remote token-revocation dance, no trusting the vendor to honor it. Add a second bank? Mint a second `item` facet and grant it. Want to pause? Revoke the `scheduler`. The Endo daemon **persists** these object references across restarts, so "securely store the access_token" becomes "the daemon persists the object under its petname" — the secret is never marshalled back into app-reachable form.
>
> ### Sketch of the object graph
>
> ```
> host (you, via the powerbox / petnames)
>  ├─ plaid          (connector caplet; owns Plaid client-id+secret + net endowment)
>  │    └─ E(plaid).linkAccount()  ──►  item        // read-only facet, minted per bank
>  ├─ googleSheets   (connector caplet; owns Google OAuth token + net endowment)
>  │    └─ E(googleSheets).sheetFor(id, range)  ──►  sheet   // single-sheet writer facet
>  └─ sheetsync      (GUEST caplet — the "plugin", confined)
>         endowments: { plaidItem: item, sheet, clock }
>         loop:  const { added, cursor } = await E(plaidItem).syncTransactions(lastCursor);
>                await E(sheet).appendRows(added.map(toRow));
>                // holds no secret; can reach nothing but these two facets
> ```
>
> Everything crosses vat boundaries by `E()` eventual-send returning promises — the same discipline as the rest of Endo.
>
> ### Why this is strictly better than the add-on
>
> - **The TCB shrinks to two tiny connectors.** The large, churny application code runs with zero ambient authority. Supply-chain risk in the app is *contained*, not catastrophic.
> - **No copyable secret in the app.** Capabilities are unforgeable references, not replayable bytes.
> - **Attenuation is real and per-resource:** one bank Item, one sheet+range — not "all your sheets" and "the whole Item store".
> - **Revocation is local, instant, and per-capability.**
> - **Webhooks fit ocaps cleanly.** Plaid recommends event-driven `/transactions/sync` over polling. Model it as the SheetSync caplet passing an inbound callback capability to the `plaid` connector — `E(plaid).subscribe(handler)` where `handler` is a capability the guest owns. A callback *is* a capability; Endo makes that first-class.
>
> ### Where the real work is (honest caveats)
>
> Endo relocates trust; it doesn't erase it. The pieces that don't exist yet:
>
> - **A hardened HTTPS/network endowment** and the two **connector caplets** (Plaid, Google Sheets) would have to be built and reviewed — that's where the residual trust concentrates. The garden already has an [`oauth-use-case-patterns`](../skills/oauth-use-case-patterns/SKILL.md) skill covering least-privilege OAuth app/scope choice and short-lived-token rotation, directly relevant to the Google connector.
> - **Plaid Link is a browser/OAuth UX.** The linking handshake still needs a web view; Endo models only the *result* (the `item` capability minted when Link completes) as an ocap.
> - **Persistence + upgrade** of the connector caplets (durable secrets, token refresh) rides Endo's durable-object story and wants care.
>
> ### Recommended follow-up
>
> If you want the source material captured for the library, a **`scholar-ingest-source` job** over the Plaid Transactions/Link docs (`plaid.com/docs/transactions`, `plaid.com/docs/link`) and Endo's caplet/powerbox docs would give future roles a cited, abstract-routed reference to build the connectors from. I did not run the full library-ingestion pipeline in this pass (see the note in the completion report about the environment), so that ingestion is the clean next step.
>
> Sources: [getsheetsync.com](https://getsheetsync.com) · [Plaid Transactions docs](https://plaid.com/docs/transactions/) · [Plaid Link docs](https://plaid.com/docs/link/) · [Plaid Quickstart](https://plaid.com/docs/quickstart/)
> ----- END ISSUE #25 COMMENT -----

- `20260704T164910Z-d6a3a8` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T164910Z-d6a3a8.md)

> Design `designs/streamlined-onboarding.md` (from report `design-streamlined-onboarding`) awaits your review: please answer its § 5 open questions — especially Q2, the auto-mode default, which is a security-flavored decision. The four § 6 build jobs are gated on that review; once you decide, I'll post them as an orchestration.

- `20260704T164925Z-1cae48` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T164925Z-1cae48.md)

> Operational hazard on this host (endolinbot2), from report `design-streamlined-onboarding`: `garden-journal-worktree-keeper` logs a dangling gitdir reference to `/home/kris/garden2/.git/worktrees/journal` every tick, and live per-job `gardener-wt-*` worktree admin entries under `/home/kris/.git/worktrees/` are being pruned out from under running gardeners — which will corrupt any job that commits from its assigned worktree here. This is local garden-infra health (not a bot-repo PR), and matches the known "journal worktree severed" pattern; it needs a `git worktree prune` + journal-worktree repair on this host. Want me to run the repair now, or investigate the stale `garden2` gitdir reference first?

- `20260704T165042Z-b5ead1` — from gardener:endojs-endo-but-for-bots-pr288-review-330391eb, reply_to `endojs-endo-but-for-bots-pr288-review-330391eb` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T165042Z-b5ead1.md)

> (empty message)


## Board
### todo (0)
(none)

### doin (13)
- [`endojs-endo-but-for-bots-pr288-refresh`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr288-refresh.md) — refresh directive on endojs/endo-but-for-bots PR #288
- [`endojs-endo-but-for-bots-pr288-review-330391eb`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr288-review-330391eb.md) — Review directive on endojs/endo-but-for-bots PR #288
- [`endojs-endo-but-for-bots-pr442-review-61c65980`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-review-61c65980.md) — Review directive on endojs/endo-but-for-bots PR #442
- [`endojs-endo-but-for-bots-pr589-8f67c6ab`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr589-8f67c6ab.md) — attention directive on endojs/endo-but-for-bots PR #589
- [`endojs-endo-but-for-bots-pr592-review-da7fef5e`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr592-review-da7fef5e.md) — Review directive on endojs/endo-but-for-bots PR #592
- [`endojs-endo-but-for-bots-pr595-review-0a6137f6`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr595-review-0a6137f6.md) — Review directive on endojs/endo-but-for-bots PR #595
- [`endojs-endo-but-for-bots-pr602-review-ec2efb27`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr602-review-ec2efb27.md) — Review directive on endojs/endo-but-for-bots PR #602
- [`endojs-endo-but-for-bots-pr604-review-51a40148`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr604-review-51a40148.md) — Review directive on endojs/endo-but-for-bots PR #604
- [`endojs-endo-but-for-bots-pr604-review-f2d21a00`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr604-review-f2d21a00.md) — Review directive on endojs/endo-but-for-bots PR #604
- [`harden-garden-issue-inbox-journal-linkage`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/harden-garden-issue-inbox-journal-linkage.md) — Build: make garden-issue-inbox resilient to a severed journal linkage
- [`librarian-library-audit-20260704-165003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/librarian-library-audit-20260704-165003.md) — Librarian library audit
- [`onboarding-build-1-launcher-image-guard`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/onboarding-build-1-launcher-image-guard.md) — Build (phase 1/4): launcher + image + guard hook
- [`xs2rust-endor-build-stage3b-object-statics-intern`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3b-object-statics-intern.md) — Builder: stage-3b child 5/9 — global string→id intern table + Object statics/...

### tada (1134)
- [`issue-kriskowal-garden-25`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-kriskowal-garden-25.md) — Completion report — issue-kriskowal-garden-25
- [`mention-endojs-endo-but-for-bots-604-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-endojs-endo-but-for-bots-604-gauntlet.md) — Completion report — run the gauntlet #604 (endojs/endo-but-for-bots)
- [`issue-kriskowal-garden-24`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-kriskowal-garden-24.md) — Completion report — issue-kriskowal-garden-24: scholar study of MylesBorins/a...
- [`fix-journal-worktree-keeper-stale-registration`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/fix-journal-worktree-keeper-stale-registration.md) — Completion report
- [`design-streamlined-onboarding`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-streamlined-onboarding.md) — Completion report: design-streamlined-onboarding
- … and 1129 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...
- [`endojs-endo-but-for-bots-pr288-review-330391eb-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr288-review-330391eb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #288 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr592-review-da7fef5e-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-review-da7fef5e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #592 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr595-review-0a6137f6-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr595-review-0a6137f6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #595 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr442-review-61c65980-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr442-review-61c65980-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #442 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr602-review-ec2efb27-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr602-review-ec2efb27-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #602 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-86120b5a-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-86120b5a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-review-51a40148-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-review-51a40148-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-review-f2d21a00-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-review-f2d21a00-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s7`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s7.md) — awaiting `xs2rust-endor-build-stage3b` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
