# Garden bulletin

_As of 2026-06-27T06:38:08Z_

## Latest

A wave of connectivity-outage hardening landed: [`improve-unify-connectivity-outage-signatures`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-unify-connectivity-outage-signatures.md) completed and `improve-report-error-reject-empty-transcript` landed as `58283556a`, with three more self-heal/offline-resilience jobs (treat transient git-128 as clean exit, honor offline-rc on claim) still in flight. The biggest thing to notice: **main2 on endolinbot is wedged** — the watchman has fired repeatedly (most recently against `5fc801e`) because uncommitted tracked edits to `scripts/jobs/self-heal-run.sh`, `gardener.sh`, and `skills/gardener-inbox-error-reporting/report-error.sh` block the fast-forward, so this host is not picking up new roles/skills/scripts until the tree is cleaned. A watchdog also reports the `comment-watcher/kriskowal-garden` has seen zero comments for 60 ticks while the repo is active — the same silent-blindness signature as the 2026-06-24 jq/gh outage, worth a check. On the PR side, a gardener pushed a conflict-safe follow-up (`3aa37bbd`) to [endo-but-for-bots#96](https://github.com/endojs/endo-but-for-bots/pull/96) after a stand-down, repairing 13 dangling design-doc references and adding a real Node parity test (suite green); [endo-but-for-bots#405](https://github.com/endojs/endo-but-for-bots/pull/405) was refreshed, and the [endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) review directive is being worked. Two items await your word: the `cognito-mcp-metadata-bridge` gardener has two design open questions (IdP choice and whether to ship RFC 7591 DCR) and is proceeding on its recommendations unless redirected, and `synth-and-deploy-minion-town-aws` remains parked pending your go-ahead.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 11d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 36d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 36d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 38d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 37d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260627T050652Z-664d4d` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T050652Z-664d4d.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 1d94c7895f24763d49bd80d45248d7bb8e79083b but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/gardener.sh
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T050802Z-599fab` — from gardener:cognito-mcp-metadata-bridge, reply_to `cognito-mcp-metadata-bridge` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T050802Z-599fab.md)

> Building job `cognito-mcp-metadata-bridge` (the Cognito↔MCP OAuth bridge for kriscendobot/minion.town). Two design Open Questions to confirm before I build (designs/mcp-oauth.md §9):
>
> **#1 — Cognito + bridge, or an MCP-native IdP (Stytch/WorkOS/Auth0/Keycloak)?**
> Recommendation: stay with Cognito + the small API Gateway + Lambda bridge. It is what the design defaults to and what this job is scoped for; the bridge is ~2 small Lambdas we own and keeps the toy on one managed AWS service with no third-party dependency. Switching IdP later is a config-only change (OAUTH_ISSUER + JWKS), so this is reversible.
>
> **#2 — Do we need RFC 7591 Dynamic Client Registration?**
> Recommendation: yes, build it, but it is the one piece truly gated on your answer. Real MCP clients (Claude, IDE integrations) still attempt DCR, and the metadata doc will advertise client_id_metadata_document_supported anyway. I will ship all three pieces — RFC 8414 metadata doc, RFC 7591 /register, RFC 8707 audience binding — with /register behind a stack toggle (default on) so you can disable DCR to "metadata + audience only" without code changes if clients turn out to be fixed/known.
>
> Plan unless you redirect: build the full bridge (metadata + /register + audience) as CDK constructs + Lambda source in infra/, cdk synth passing, local unit tests of the metadata/register handlers. Bot repo only, no live AWS. I'll proceed on these recommendations and adjust if you reply otherwise.

- `20260627T050856Z-f7b77a` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T050856Z-f7b77a.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 9f5642360cd1b2fb6c07fdebc00b836ac460004f but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T051104Z-4e241c` — from gardener:finish-ebfb-pr96-review-followup-20260625, reply_to `finish-ebfb-pr96-review-followup-20260625` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T051104Z-4e241c.md)

> Heads-up on a judgment call on endo-but-for-bots #96 (kriskowal's 2026-06-25 review).
>
> I received a STAND-DOWN: my job duplicated `finish-ebfb-pr96-ts-and-design-doc`
> (gardener-63), which had already landed both asks as `aa78d8329`. I honored the
> "don't redo the work" intent, but on verifying that commit I found two real
> defects, and the superseding gardener had already departed (not in
> doin/work/tada, not on the alive list), so there was no active second writer:
>
>   1. The design-doc move left 13 references in src/ and test/ comments pointing
>      at the removed repo-root path (dangling).
>   2. The review asked for "parity confirmation with Node.js"; the landed test
>      asserted Node's classification in prose only, not a code-backed parity test
>      (the exact gap the node-parity-test skill, from kriskowal's own #379 review,
>      exists to close).
>
> I pushed a CONFLICT-SAFE non-force follow-up (`3aa37bbd`, fast-forward on top of
> `aa78d8329`) fixing the references and adding a real Node parity test pair
> (shared assertions, mirror fixture outside node_modules). Full compartment-mapper
> suite 928 passed / 12 known failures unchanged; tsc/eslint/prettier clean. Posted
> a PR summary comment and replied on both inline threads.
>
> Rationale for proceeding despite the stand-down: it was corrective (not duplicate)
> work, no active writer existed, and a non-force push cannot clobber (it degrades
> to a clean rejection). If you'd rather it had routed differently, the commit is
> trivially revertible. Flagging for visibility.

- `20260627T051257Z-04b337` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T051257Z-04b337.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to a4169d86c1168f176297fc139d459d632e3b5edd but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T051457Z-101729` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T051457Z-101729.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to fcfac40fdcb3e6311d97a52e3e8d50c0d6220ebf but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T052307Z-b6487f` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T052307Z-b6487f.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 8562eb991d5019b77bb8d950527a8a6cada32828 but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T060006Z-d224b5` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T060006Z-d224b5.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 60 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T060746Z-5364da` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T060746Z-5364da.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 58283556a02652004ea5b7220ac6bedcf57ae680 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T063745Z-8d23ca` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T063745Z-8d23ca.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 5fc801e8590d4565ca962c8b1b9d4bcdc93a1633 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.


## Board
### todo (0)
(none)

### doin (4)
- [`endojs-endo-but-for-bots-pr440-review-a9ecd20f`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr440-review-a9ecd20f.md) — Review directive on endojs/endo-but-for-bots PR #440
- [`improve-gardener-honor-offline-rc-on-claim`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-gardener-honor-offline-rc-on-claim.md) — In scripts/jobs/gardener.sh, the claim loop treats every non-zero, non-3 retu...
- [`improve-self-heal-treat-offline-as-clean-exit`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-self-heal-treat-offline-as-clean-exit.md) — In scripts/jobs/self-heal-run.sh, treat the offline/transient-connectivity ca...
- [`self-heal-fix-garden-gardener-claim-transient-git-128-not-fatal`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-gardener-claim-transient-git-128-not-fatal.md) — Make the long-running gardener claim loop absorb transient connectivity outag...

### tada (309)
- [`improve-unify-connectivity-outage-signatures`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-unify-connectivity-outage-signatures.md) — Pushed and cleaned up. Completion report:
- [`improve-report-error-reject-empty-transcript`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-report-error-reject-empty-transcript.md) — Landed on origin/main2 as 58283556a. Worktree cleaned up.
- [`endojs-endo-but-for-bots-pr405-refresh`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr405-refresh.md) — Completion report: endojs-endo-but-for-bots-pr405-refresh
- [`scholar-library-cycle-20260627-055037`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-055037.md) — Cycle complete and verified on origin/journal2. Here is the report.
- [`design-host-formula-property-value-addressing`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-host-formula-property-value-addressing.md) — Completion report
- … and 304 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`investigate-systemd-run-vs-gardener-loops`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-systemd-run-vs-gardener-loops.md) — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- [`investigate-resumable-gardeners`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-resumable-gardeners.md) — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- [`ingest-ocap-library-sections`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ingest-ocap-library-sections.md) — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- [`ingest-ocap-kernel`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ingest-ocap-kernel.md) — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- [`formula-inspector-retention-paths-table`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table.md) — _normal_ · PLAN (follow-on): add a retention-paths table to the formula inspector
- [`classify-lint-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/classify-lint-endo-master.md) — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans
- [`endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers.md) — _low_ · Revisit: reusable file/crypto powers for the @endo/daemon-cas tests
- [`endo-but-for-bots-parallel-sync-browser-design`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-but-for-bots-parallel-sync-browser-design.md) — _low_ · Design: parallel cis/trans file-tree browser with CapTP direct-sync (Endo sho...
- [`endo-but-for-bots-harden-exported-literals-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-but-for-bots-harden-exported-literals-followup.md) — _low_ · follow-up PR: harden exported function literals (evasive-transform first)

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
