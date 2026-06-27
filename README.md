# Garden bulletin

_As of 2026-06-27T08:10:08Z_

## Latest

The standout item for the maintainer: **endolinbot's `main2` deploy is wedged and has been all morning.** A redundant uncommitted edit (now `skills/gardener-inbox-error-reporting/report-error.sh`, byte-identical to what's already on `origin/main2`) blocks the fast-forward, so the live tree is stuck ~6 commits behind while landed fixes pile up unreachable; `git -C /home/kris checkout -- <file>` is lossless and unwedges it. Those landed-but-undeployed fixes are exactly the ones that matter: a deploy-sync reconciler (`5d6490e62`) that auto-advances the checkout and restarts services on `scripts/` changes (inert until the next units refresh arms it), and a sync-clone transient-fetch classification fix (`ba38a1372`) that stops gardeners crash-looping on transient git 128s.

Separately, the comment-watcher for `kriskowal/garden` has now reported zero comments for 140 consecutive ticks despite the repo being active since 2026-06-25 — the same silent-blindness signature as the 2026-06-24 jq/gh outage, worth checking.

On the PR side, a gardener pushed a conflict-safe corrective follow-up (`3aa37bbd`) to [endo-but-for-bots#96](https://github.com/endojs/endo-but-for-bots/pull/96), fixing 13 dangling doc references and adding a real Node parity test after finding the superseding commit had left both gaps. The `formula-inspector-retention-paths-table` job is **blocked** on [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284) (the `listRetentionPaths` host API), which has been stalled since 2026-05-21 awaiting the requested rebase-and-gamut and currently has 4 failing checks. Scholar landed its sixth MetaMask/ocap-kernel ingest (the kernel-guide) and is now mid-claim on a six-section ocap library backfill. Two items await maintainer go-ahead: the `cognito-mcp-metadata-bridge` build (two design open questions, gardener proceeding on its recommendations unless redirected) and `synth-and-deploy-minion-town-aws`.

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

- `20260627T065011Z-dd98d0` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T065011Z-dd98d0.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to f26a5e7a1981eead367f8628c72d89582f22c148 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T065233Z-93ff77` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T065233Z-93ff77.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to bd65630d12a51f77d6e0bdaae723eac7d0092217 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T070019Z-cf49fc` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T070019Z-cf49fc.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 100 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T071028Z-d3cf33` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T071028Z-d3cf33.md)

> self-heal: garden-gardener exited rc=1 with no scoped fix. Capture: aa06bfa333e088a3ceb27279e19eeb3e822b0fb5 (git -C /home/kris/.garden-state/self-heal/journal cat-file -p aa06bfa333e088a3ceb27279e19eeb3e822b0fb5). Diagnosis: ## Diagnosis
>
> **No fix job to post — the code fix already landed and a deploy job for the recurrence is already in flight.**
>
> The failure signature is `FATAL: claim failed (rc=128)` → exit 1 → systemd restart. The crash came with **no preceding claim log** (no "offline", no "fetch failed", no "lost claim race"), meaning `claim-job.sh` died under `set -euo pipefail` on an unguarded git op during the claim's `sync_clone` — a transient connectivity/DNS blip surfacing as a raw git 128. The old `gardener.sh` loop treated any non-0/non-3 claim rc as a hard `die`, so a self-resolving network blip crash-looped the worker.
>
> That is **already fixed on `origin/main2`**. The running unit at `/home/kris` is **4 commits behind** `origin/main2`, and exactly those 4 commits are the fix chain:
> - `5

- `20260627T071117Z-7b6901` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T071117Z-7b6901.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 0c8b861c8c377b5b50a50fc6feca2a2148ab128a but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T072213Z-857dde` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T072213Z-857dde.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 5d6490e62a7ff78f28c3d6253e823636f4bcf46a but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T072235Z-b12c9f` — from gardener:improve-deploy-sync-fleet-onto-landed-fixes, reply_to `improve-deploy-sync-fleet-onto-landed-fixes` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T072235Z-b12c9f.md)

> deploy-sync reconciler landed on main2 (5d6490e62): advances the checkout by a strict clean fast-forward and restarts the long-running services (gardeners between-claims via a busy marker, plus bulletin/driver/watcher) when scripts/ changes, so landed fixes reach running workers without a manual restart.
>
> Two bringup notes:
> 1. It is INERT until armed. garden-deploy-sync.timer auto-enables on the next 'install-units.sh install && enable-services' (it is in the derived enable-set), so a routine units refresh arms it; no special step.
> 2. The live /home/kris tree is currently dirty-wedged: 'skills/gardener-inbox-error-reporting/report-error.sh' is modified in the working copy, and its content is BYTE-IDENTICAL to origin/main2's committed version (a redundant uncommitted edit duplicating an already-landed fix). git refuses the fast-forward while it is dirty, so BOTH the watchman and deploy-sync skip the advance (the checkout is now 6 behind). 'git -C /home/kris checkout -- skills/gardener-inbox-error-reporting/report-error.sh' is lossless (content already on origin) and unwedges the deploy. I did not touch the shared live tree from a gardener job.

- `20260627T073148Z-d2f9fb` — from gardener:formula-inspector-retention-paths-table, reply_to `formula-inspector-retention-paths-table` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T073148Z-d2f9fb.md)

> Job `formula-inspector-retention-paths-table` is BLOCKED on its data source and I'm reporting the gap (not reimplementing the graph walk, per the plan's own instruction).
>
> Why blocked:
> - The table must source its data from #284 (`listRetentionPaths` host API). #284 is still OPEN and NOT on base `llm`.
> - #284 is stalled since 2026-05-21: you asked "Please rebase and run the gamut again" — that rebase/re-gamut never happened, and it currently has 4 failing CI checks (22/26 green). Not mergeable as-is.
> - Building the table now would require either binding to a non-existent host method (CI can't pass on `llm`) or duplicating the graph walk in the UI — which the plan explicitly forbids.
>
> Good news (the follow-on is ready the moment #284 lands):
> - #284 exposes the right shape over the captp `HostInterface`: `listRetentionPaths(locator) -> Promise<RetentionPath[]>` and `followRetentionPaths(locator) -> AsyncIterator<RetentionPathDelta>`. Each `RetentionPath` is segments with `{ groupMembers, referencedBy, labels }` (pet edges => `pet:<name>`, root segment `type:"root"`) — exactly a table's rows. The chat UI can reach it because it's on the host captp interface, not CLI-only.
> - The inspector back-face to extend is `packages/spaces-util/src/formula-view.js` (#440, merged into `llm` 2026-06-27).
>
> Recommended unblock: land #284 first (the rebase + gamut you already requested), then re-promote this plan from `jobs/plan/` to `todo/`. I can take the #284 rebase-and-gamut as a separate job if you want — say the word and I'll post it.

- `20260627T074543Z-a87313` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T074543Z-a87313.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to ba38a137284e63ff9e8ec360f9119c84ae0da0a7 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T075134Z-f5bbc7` — from gardener:ingest-ocap-kernel, reply_to `ingest-ocap-kernel` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T075134Z-f5bbc7.md)

> Library: ingested MetaMask/ocap-kernel `docs/kernel-guide.md` (the 689-line host-app developer
> guide) — the **sixth ocap-kernel ingest** and the most direct source yet for the kernel/vat model.
> 11 sections + a synthesizing [[ocap-kernel]] concept, cross-linked to the garden's ocap corpus.
>
> Synthesis — how MetaMask's kernel (an external SwingSet-lineage sibling, distinct from @endo)
> relates to our material:
> - Shared substrate: `E()` is imported straight from `@endo/eventual-send`; exos wrap `@endo/exo`
>   `makeExo`.
> - Signature divergences (flagged honestly per section): kref/vref/rref/eref four-scope reference
>   name-space vs Endo's single formula identifier; first-class `kernel.revoke(kref)` vs Endo's
>   compositional caretaker/membrane revocation; kernel services registered-by-name + access-checked
>   at subcluster launch vs Endo powers through the formula graph; `Far()` forbidden in favor of
>   `makeDefaultExo`.
> - Six-sections ocap cross-links wired: distributed confinement (vat endowment allowlists),
>   three-party hand-off (bootstrap-as-introducer; bidirectional links into granovetter-operator +
>   four-ways-to-acquire-references), eventual send, sturdyrefs (baggage-stored cross-vat refs).
>
> Deferred follow-on plans parked: `scholar-ingest-ocap-kernel-usage` (docs/usage.md) and
> `scholar-ingest-ocap-kernel-packages` (per-package READMEs + kernel-internals comment fragments).

- `20260627T075803Z-d1b426` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T075803Z-d1b426.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 3ab9074bca91f72f0de738e5b25e172aa7ea138e but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T080041Z-e5e019` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T080041Z-e5e019.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 140 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.


## Board
### todo (0)
(none)

### doin (1)
- [`ingest-ocap-library-sections`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ingest-ocap-library-sections.md) — PLAN: scholar — ingest sources for six missing ocap library sections

### tada (322)
- [`scholar-library-cycle-20260627-075113`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-075113.md) — Completion report — scholar-library-cycle-20260627-075113
- [`self-heal-fix-garden-follow-up-handler-swallows-claude-error`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-follow-up-handler-swallows-claude-error.md) — Completion report
- [`ingest-ocap-kernel`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ingest-ocap-kernel.md) — Completion report — ingest-ocap-kernel (scholar)
- [`improve-sync-clone-transient-fetch-classification`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-sync-clone-transient-fetch-classification.md) — Done. Committed ba38a1372 to origin/main2; full test suite green (171/0); wor...
- [`formula-inspector-retention-paths-table`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/formula-inspector-retention-paths-table.md) — Completion report: formula-inspector-retention-paths-table
- … and 317 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`investigate-systemd-run-vs-gardener-loops`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-systemd-run-vs-gardener-loops.md) — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- [`investigate-resumable-gardeners`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-resumable-gardeners.md) — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- [`scholar-ingest-ocap-kernel-usage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-usage.md) — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel docs/usage.md
- [`classify-lint-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/classify-lint-endo-master.md) — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans
- [`endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers.md) — _low_ · Revisit: reusable file/crypto powers for the @endo/daemon-cas tests
- [`endo-but-for-bots-parallel-sync-browser-design`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-but-for-bots-parallel-sync-browser-design.md) — _low_ · Design: parallel cis/trans file-tree browser with CapTP direct-sync (Endo sho...
- [`endo-but-for-bots-harden-exported-literals-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-but-for-bots-harden-exported-literals-followup.md) — _low_ · follow-up PR: harden exported function literals (evasive-transform first)
- [`scholar-ingest-ocap-kernel-packages`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-packages.md) — _low_ · PLAN: scholar — ingest MetaMask/ocap-kernel packages + code-comment fragments

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
