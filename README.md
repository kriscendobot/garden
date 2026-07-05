# Garden bulletin

_As of 2026-07-05T17:37:51Z_

## Latest

The clone-keeper self-heal landed: [`improve-ensure-clone-partial-dir-selfheal`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-ensure-clone-partial-dir-selfheal.md) pushed cleanly to main2, hardening `ensure-clone` against partial-directory states. The item needing your eyes: the gap-revealing probe on [endo-but-for-bots#595](https://github.com/endojs/endo-but-for-bots/pull/595) (sanctioned `unredactError` SES API) is substantively **complete and verified by real execution** — start-compartment-only exposure confirmed under real `lockdown()`, five design gaps surfaced with Gap 4 (return shape) named as the keystone — but publishing the DRAFT is **blocked on credentials**: the job ran on endolinbot2, which has no bot `gh` token, and the only key present authenticates as kriskowal, so the gardener declined to push under a maintainer identity it wasn't authorized to use. The proxy has escalated this to your inbox as a credential/identity decision beyond its authority; the branch, SHAs, and full PR body are staged and ready to open. Five fix/build jobs remain in flight (the ebfb#592 watchdir fixer, the ebfb#442 review fix, the Fable scripts review, onboarding phase 4, and the xs2rust stage-3b builder), and the board is otherwise drained to zero todo.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 5d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 6d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 9d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 20d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 44d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 44d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 46d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 45d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 53d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260704T170858Z-0fbe2f` — from gardener:endojs-endo-but-for-bots-pr595-probe-unredact-error, reply_to `endojs-endo-but-for-bots-pr595-probe-unredact-error` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T170858Z-0fbe2f.md)

> # probe #595 unredactError — work COMPLETE, PUBLISH BLOCKED (no bot GitHub credentials on this host)
>
> **Job:** endojs-endo-but-for-bots-pr595-probe-unredact-error (host endolinbot2).
>
> The substantive probe is done and verified by real execution. I cannot open
> the DRAFT PR from this host, so I am surfacing rather than falsely completing.
>
> ## Publish blocker (needs your action)
>
> This host has **no `gh` CLI and no bot GitHub token** (no `~/.config/gh/hosts.yml`,
> no `GH_TOKEN`, the fleet `gh` wrapper reports "no real gh found"). An HTTPS push
> fails with "could not read Username". The **only** credential present is an SSH
> key that authenticates as **kriskowal** (`ssh -T git@github.com` → "Hi kriskowal!").
> Opening a PR through it would be an unauthorized maintainer-identity action;
> this job carries no `identity_switch_authorized: true` and I am not the boatman,
> so I did not use it.
>
> To land the draft PR, either: (a) provision an endolinbot/kriscendobot token +
> `gh` on a host and re-run this job there, or (b) open it yourself from the ready
> material below.
>
> ## Ready to publish
> - **Branch (committed, in the stable job worktree):** `probe/unredact-error-595`
> - **Base:** `designs/captp-error-identification`  (design PR #595 head)
> - **Head SHA:** d5884cecbc5b8bfeb018d77e7963b4690f61f147
> - **Base SHA:** bd5640531d85dc40abbbe3ceaafac2776c5495ea
> - **Commits:** `feat(ses): prototype sanctioned unredactError…` +
>   `refactor(daemon): prefer sanctioned unredactError…`
> - **Full draft-PR title + four-section body:** pasted below (also at
>   `scratch/pr-body-unredact-error-595.md`). Open with `--draft`; keep draft.
> - Push command once a bot token exists (from the job worktree):
>   `git push origin probe/unredact-error-595` then
>   `gh pr create --draft --base designs/captp-error-identification --head probe/unredact-error-595 --title "<first line below>" --body-file scratch/pr-body-unredact-error-595.md`
>
> ## Verified (real execution, not inspection)
> - Composition: `defineUnredactError` renders template args + unredacted stack +
>   cause chain + notes to a string — isolated smoke test, 5/5 checks pass.
> - Hard constraint: under real `lockdown()`, start compartment exposes
>   `unredactError`; a child `Compartment` sees `undefined` for it (and for
>   `getStackString` and the ses-ava symbol). PROPAGATION-PASS.
>
> ## 5 gaps surfaced (full detail in the PR body below)
> 1. API name — `unredactError` fits the string form, not the shared primitive.
> 2. Start-compartment-only exposure — design names the constraint, not the
>    mechanism; SES already offers two (convention-symbol vs permitted intrinsic).
> 3. Coupling map — `@endo/ses-ava` needs the causal-console *factory*, so it
>    cannot migrate onto a string API; daemon migrated but loses TraceRecord shape.
> 4. Signature/return shape — string vs structured vs factory; three consumers
>    pull three ways (Open Question 1, the keystone).
> 5. One-shot consumption — the handler's `take*` accessors are destructive; first
>    renderer wins, later renderers see redacted output (design is silent on this).
>
> =====================================================================
> FULL DRAFT-PR TITLE + BODY (paste as-is):
> =====================================================================
>
> feat(ses): sanctioned `unredactError` start-compartment API (gap-revealing prototype of #595)
>
> Gap-revealing prototype for the design in
> `designs/unredacted-stack-sanctioned-ses-api.md` (PR #595), probing the
> maintainer's directive on review
> [4629038402](https://github.com/endojs/endo-but-for-bots/pull/595#pullrequestreview-4629038402).
> Base: `designs/captp-error-identification`. This PR is a discussion artifact
> and stays DRAFT; it is not for merge.
>
> Skeleton verified by real execution (not inspection):
> - Composition: `defineUnredactError` renders hidden message-template args,
>   the unredacted stack, the cause chain, and `note(err, ...)` annotations to a
>   string (isolated smoke test against a stub `loggedErrorHandler`, 5/5 checks
>   pass).
> - Hard constraint (start-compartment-only): under real `lockdown()`, the start
>   compartment exposes `unredactError`; a child `Compartment` sees `undefined`
>   for it (and for `getStackString` and the ses-ava symbol). PROPAGATION-PASS.
>
> ## Gaps surfaced
>
> ### Gap 1: API name — `unredactError` fits the string form but not the primitive
>
> **Where in the design.** Open Question 1 (lines 84-86) and § 2 (lines 55-66);
> maintainer's suggested name from review 4629038402.
>
> **Verbatim quote.** > "consider `unredactError` for the API name" (review
> 4629038402) and > "`ses` grow (or bless) such an API — e.g. a
> start-compartment-only `getErrorDiagnostic(err)` / public causal-console
> factory".
>
> **What's needed to implement.** The name presumes the export is
> `err -> string`. But the primitive the consumers actually share is the
> causal-console factory (Gap 4), and `unredactError` reads poorly as a name for
> a factory. The name cannot be settled until the return shape is (Gap 4).
>
> **Candidate resolutions.**
> - **A.** Keep `unredactError(err) -> string` as the sanctioned surface; name
>   the factory (if also exported) separately. Trade-off: two names, two exports.
> - **B.** Make the factory the sanctioned primitive under a factory-shaped name;
>   `unredactError` becomes a thin string helper. Trade-off: the maintainer's
>   preferred name demotes to a convenience.
> - **C.** Adopt `unredactError` for the string form only and do not export a
>   factory (ses-ava keeps its symbol). Trade-off: the ses-ava symbol survives,
>   which § 2 wanted to retire.
>
> **Maintainer's call:** design revision (name follows the Gap 4 shape decision).
>
> ### Gap 2: Start-compartment-only exposure — the design names the constraint, not the mechanism
>
> **Where in the design.** § 2 (lines 55-66) and the specific request (lines
> 74-80).
>
> **Verbatim quote.** > "a **first-class, supported SES export** ... a
> start-compartment-only `getErrorDiagnostic(err)`".
>
> **What's needed to implement.** SES already offers two distinct mechanisms for
> start-compartment-only exposure, and the design picks neither:
> - **(A) convention-symbol on the start global** — a direct assignment to the
>   start compartment's `globalThis` under a registered symbol, exactly as
>   `console-shim.js` installs `MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA`.
>   Child compartment globals are rebuilt from `sharedGlobalPropertyNames` /
>   `universalPropertyNames` (`setGlobalObjectMutableProperties`,
>   `compartment.js:400`) and never copy the parent's own properties, so the
>   value is unreachable from any `new Compartment()`. This prototype uses (A).
> - **(B) permitted intrinsic** — register `%InitialUnredactError%` in
>   `permits.js` and list it in `initialGlobalPropertyNames` (not
>   `sharedGlobalPropertyNames`), exactly as `getStackString` is placed
>   (`permits.js:162`). Then it is a permit-audited, named global rather than a
>   convention symbol.
>
> **Verified by execution.** Child `Compartment` view was
> `{unredact:"undefined", getStackString:"undefined", sesAva:"undefined"}` under
> real lockdown, confirming (A) enforces the constraint.
>
> **Candidate resolutions.**
> - **A.** Convention-symbol (this prototype). Trade-off: not in the permit
>   tables, so it is invisible to permit audits and to anything that reasons
>   about the global surface from permits.
> - **B.** Permitted intrinsic like `getStackString`. Trade-off: touches the
>   intrinsics collector and permit machinery; heavier change, but the principled
>   home for a first-class supported export.
>
> **Maintainer's call:** design revision (this is the SES-surface decision that
> is @erights' to steer; the design should name A or B).
>
> ### Gap 3: Coupling map — one consumer (ses-ava) cannot migrate onto a string API
>
> **Where in the design.** § 2 (lines 55-66), Open Question 2 (lines 87-88).
>
> **Verbatim quote.** > "both `@endo/ses-ava` and this daemon consumer migrate
> onto it, retiring the shared symbol hack."
>
> **What's needed to implement.** Walking each consumer that depends on
> unredacting errors today:
> - **`assert` / `@endo/errors`** — the *producers* of redaction; they own
>   `loggedErrorHandler` (the hidden message-args, notes, and unredacted stack).
>   No migration: `unredactError` is *built on* their handler. Coupling: the
>   sanctioned export must be defined after `assert` installs the handler (this
>   prototype wires the shim after `assert-shim.js` in `index.js`).
> - **Causal console (the SES `console`)** — already renders unredacted in the
>   start compartment via the same `loggedErrorHandler`. No migration;
>   `unredactError` is a sibling that buffers to a string instead of to a base
>   console, so the two renderings stay identical by sharing
>   `defineCausalConsoleFromLogger`.
> - **`@endo/ses-ava`** — needs the causal-console *factory* (a `VirtualConsole`
>   it drives so `console.error(err)` flows into AVA's `t.log`), NOT a string.
>   It cannot migrate onto `unredactError(err) -> string`. Retiring the ses-ava
>   symbol (Open Question 2) therefore requires the sanctioned export to be, or
>   to also expose, the factory — see Gap 4.
> - **Distributed traces (daemon `unredacted-stack.js` / `TraceRecord`)** —
>   migrated in this prototype: the daemon feature-tests the sanctioned symbol
>   first, then the legacy ses-ava symbol, then `getStackString`, then
>   `err.stack`. But `TraceRecord` has *separate* `stack`, `annotations`, and
>   `causes` fields, while `unredactError` returns one flat string the daemon
>   dumps into `stack`. A structured return would let the daemon populate those
>   fields (Gap 4).
>
> **Candidate resolutions.**
> - **A.** Sanctioned export is the factory; ses-ava, the causal console, and a
>   string helper all derive from it. Trade-off: consumers do a little assembly,
>   but one primitive serves all and the symbol truly retires.
> - **B.** Export both a factory and `unredactError(err) -> string`. Trade-off:
>   two supported surfaces to co-maintain.
> - **C.** Export only the string form; ses-ava keeps its symbol. Trade-off:
>   Open Question 2's "retire the symbol" goal is not met.
>
> **Maintainer's call:** needs broader review (@erights) for the ses-ava
> factory-vs-string conflict; the daemon dispatch order is implementation-time.
>
> ### Gap 4: Signature and return shape — three consumers pull three ways
>
> **Where in the design.** Open Question 1 (lines 84-86).
>
> **Verbatim quote.** > "Exact signature of the sanctioned unredacted-diagnostic
> SES export — @erights to steer. This is the gating upstream dependency."
>
> **What's needed to implement.** The load-bearing return-shape choice, with each
> consumer's pull:
> - **Rendered string** (this prototype) — right for a human operator and
>   `endo trace`; lossy for the daemon; unusable for ses-ava.
> - **Structured record** (`{ messageArgs, stack, notes, causes }`) — right for
>   the daemon's `TraceRecord`; needs a separate renderer for humans; still not
>   the console shape ses-ava wants.
> - **Causal-console factory** (`logger -> VirtualConsole`) — right for ses-ava;
>   the daemon and the string helper derive from it (as the daemon does today).
> Sync-vs-async: unredaction reads local `WeakMap` state synchronously; no async
> is needed, and the prototype is sync. Single-error-vs-log: `unredactError(err)`
> renders one error; the factory renders arbitrary console arg lists.
>
> **Candidate resolutions.**
> - **A.** String-only convenience over a private factory. Trade-off: simplest
>   surface, but ses-ava cannot use it and the daemon loses structure.
> - **B.** Factory as the primitive plus a string helper. Trade-off: serves all
>   three; two exports.
> - **C.** Structured record plus a renderer. Trade-off: best for the daemon;
>   extra shape for humans and still no console for ses-ava.
>
> **Maintainer's call:** design revision (@erights; this is Open Question 1 and
> gates everything downstream).
>
> ### Gap 5: One-shot consumption — the handler's `take` semantics are destructive
>
> **Where in the design.** Not addressed anywhere in the design.
>
> **Verbatim quote.** (design is silent — this gap surfaced only from contact
> with code: `assert.js:458-460` `takeMessageLogArgs` calls
> `weakmapDelete(hiddenMessageLogArgs, error)`, and the causal console at
> `console.js:331-339` renders via the destructive `takeMessageLogArgs` /
> `takeNoteLogArgsArray`).
>
> **What's needed to implement.** Unredaction is destructive: whichever renderer
> touches an error *first* consumes its hidden message-args and notes; every
> later renderer (the causal console, ses-ava, a second `unredactError` call)
> sees the redacted remainder. A sanctioned `unredactError` makes this a
> first-class supported concern. Example: if the daemon calls `unredactError` at
> `marshalSaveError` time, a later `console.error(err)` in the same start
> compartment renders without the annotations the daemon already took.
>
> **Candidate resolutions.**
> - **A.** Document `unredactError` as one-shot (matching today's causal-console
>   behavior) and say so in the API contract. Trade-off: cheap; leaves a
>   foot-gun for the daemon-plus-console case.
> - **B.** Build `unredactError` on the *non-destructive* `getMessageLogArgs`
>   peek (`assert.js:457`) plus a non-taking notes accessor, so it never strips
>   context. Trade-off: needs a peek variant for notes (only `takeNoteLogArgsArray`
>   exists today); a repeatable read, but diverges from the causal console.
> - **C.** Leave the semantics as-is and let each consumer coordinate.
>   Trade-off: coupling leaks back to consumers, the opposite of § 1's intent.
>
> **Maintainer's call:** design revision plus broader review (@erights).
>
> ## Skeleton implemented
>
> - `packages/ses/src/error/unredact-error.js` — `defineUnredactError(loggedErrorHandler)`
>   returning `unredactError(err) -> string`, built on the existing
>   `defineCausalConsoleFromLogger`. Renders template args + unredacted stack +
>   cause chain + notes. Composition smoke-tested (5/5 checks) against a stub
>   handler; syntax-checked with `node --check`.
> - `packages/ses/src/unredact-error-shim.js` — installs `unredactError` on the
>   start compartment global under `Symbol.for('UNREDACT_ERROR_KEY_FOR_START_COMPARTMENT')`,
>   mirroring `console-shim.js`. Start-compartment-only exposure verified by real
>   `lockdown()` + child-`Compartment` probe (PROPAGATION-PASS).
> - `packages/ses/index.js`, `packages/ses/src-xs/index.js` — load the shim after
>   `console-shim.js`.
> - `packages/daemon/src/unredacted-stack.js` — the distributed-trace consumer
>   migrates onto the sanctioned symbol (feature-tested first, legacy ses-ava
>   symbol / `getStackString` / `err.stack` as ordered fallbacks);
>   `hasUnredactedStackHook` now also reports the sanctioned hook. Syntax-checked.
>
> Two commits, one per package (ses, daemon); no dependency changes, so no
> `yarn.lock` commit.
>
> ## Skeleton not implemented
>
> - **`@endo/ses-ava` migration off the shared symbol** — abandoned at Gap 3 /
>   Gap 4: ses-ava needs the causal-console factory, which the string-shaped
>   `unredactError` prototype does not export. Blocked on the return-shape
>   decision.
> - **Permitted-intrinsic exposure (`%InitialUnredactError%`)** — abandoned at
>   Gap 2 (candidate B): the prototype uses the convention-symbol path; the
>   permit-table path is the alternative the design must choose between.
> - **Structured `TraceRecord` population** — abandoned at Gap 3 / Gap 4: with a
>   flat-string return the daemon still dumps everything into `stack` rather than
>   splitting `annotations` / `causes`.
> - **The upstream `endojs/endo` issue** to actually grow this SES export
>   (design § 2, lines 65-66) — out of scope for this fork prototype; named as
>   the gating upstream dependency.
> - **Non-smoke tests** — per gap-revealing-build, the prototype is not
>   regression-tested; a real build must pin the contract once the shape is
>   final.
>
> ## Recommendations to design author
>
> Resolve **before** implementation can proceed (design revisions, @erights'
> call): **Gap 4** (return shape) is the keystone — it gates the API name
> (Gap 1), the ses-ava migration and symbol retirement (Gap 3, Open Question 2),
> and whether the daemon can populate structured `TraceRecord` fields. **Gap 2**
> (exposure mechanism: convention-symbol vs permitted intrinsic) is an
> independent SES-surface decision the design should name explicitly. **Gap 5**
> (destructive one-shot `take` semantics) is a correctness hazard the design does
> not currently mention and should address in the API contract.
>
> Resolvable **at implementation time** once the shape is authorized: the daemon
> feature-test dispatch order (sanctioned-first is this prototype's choice), the
> migration-window coexistence of the sanctioned and legacy ses-ava surfaces, and
> the human-readable string formatting details.
>
> The strongest positive signal from contact with code: the *mechanism* the hard
> constraint needs already exists and works — start-compartment-only exposure is
> enforced by SES's existing child-global rebuild, verified here under real
> lockdown. The design's genuine open work is entirely in the API's *shape*
> (Gaps 1, 3, 4, 5), not in whether SES can host a start-compartment-only export
> at all.

- `20260705T172123Z-71ff80` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T172123Z-71ff80.md)

> awaiting maintainer — beyond proxy authority: gardener endojs-endo-but-for-bots-pr595-probe-unredact-error, msgid 20260704T170858Z-0fbe2f.md — Publishing is blocked only on a credential/identity decision — opening the PR needs bot credentials this host lacks, and the sole alternative is a maintainer-identity (kriskowal SSH) switch, which is reserved and security-weighted; the substantive probe is already complete, so there is no direction/experimentation call for the proxy to make.


## Board
### todo (0)
(none)

### doin (5)
- [`ebfb-592-watchdir-crossplatform-fixer`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-592-watchdir-crossplatform-fixer.md) — Fix directive: address kriskowal CHANGES_REQUESTED review on endojs/endo-but-...
- [`endojs-endo-but-for-bots-pr442-fix-review-4629047816`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-fix-review-4629047816.md) — Fix: address kriskowal CHANGES_REQUESTED review on endojs/endo-but-for-bots P...
- [`fable-review-fix-garden-scripts`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/fable-review-fix-garden-scripts.md) — Fable: review the garden's scripts, serially fix discovered issues, push main2
- [`onboarding-build-4-readme-claudemd-slim`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/onboarding-build-4-readme-claudemd-slim.md) — Build (phase 4/4): slim README.md and CLAUDE.md to the residues
- [`xs2rust-endor-build-stage3b-object-statics-intern`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3b-object-statics-intern.md) — Builder: stage-3b child 5/9 — global string→id intern table + Object statics/...

### tada (1157)
- [`improve-ensure-clone-partial-dir-selfheal`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-ensure-clone-partial-dir-selfheal.md) — Pushed cleanly to main2. Job complete.
- [`design-leader-follower-determinism`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-leader-follower-determinism.md) — Completion report: design-leader-follower-determinism
- [`endojs-endo-but-for-bots-pr595-probe-unredact-error`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr595-probe-unredact-error.md) — Completion report (resumed job — verified complete)
- [`onboarding-build-3-vocab-tutorial-wiring`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/onboarding-build-3-vocab-tutorial-wiring.md) — Completion report
- [`issue-kriskowal-garden-26`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-kriskowal-garden-26.md) — Completion report
- … and 1152 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`endojs-endo-but-for-bots-pr288-review-330391eb-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr288-review-330391eb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #288 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr442-review-61c65980-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr442-review-61c65980-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #442 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr592-review-da7fef5e-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-review-da7fef5e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #592 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr595-review-0a6137f6-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr595-review-0a6137f6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #595 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr602-review-ec2efb27-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr602-review-ec2efb27-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #602 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-86120b5a-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-86120b5a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-review-51a40148-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-review-51a40148-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-review-f2d21a00-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-review-f2d21a00-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s7`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s7.md) — awaiting `xs2rust-endor-build-stage3b` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
