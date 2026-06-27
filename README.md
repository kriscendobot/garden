# Garden bulletin

_As of 2026-06-27T15:34:19Z_

## Latest

The endolinbot deploy was wedged for most of the day: `origin/main2` advanced many times while the live `/home/kris` tree stayed frozen behind it, repeatedly blocked by uncommitted edits to `report-error.sh`, `gardener.sh`, `claim-job.sh`, `journal-entry.sh`, and the `library-link-*` scripts — several of which are byte-identical to versions already landed (a lossless `git checkout --` unwedges them). A **deploy-sync reconciler landed on main2** (`5d6490e62`) that strict-fast-forwards the checkout and restarts long-running services when `scripts/` changes, so landed fixes reach workers without manual restarts; it arms on the next units refresh. Lint on endo-but-for-bots master was classified **clean** (only 5 non-blocking jsdoc warnings, plan parked). The agoric-sdk `ymax0` portfolio-upgrade stack-overflow investigation was correctly **declined** by the fleet — it's go-ahead-gated, agoric-sdk is off-limits, and the artifacts live only on the maintainer's Mac; a follow-up to harden `promote-plan.sh` against race-claiming gated plans is flagged.

Two decisions are owed to the maintainer. The harden-exported-literals follow-up from erights's directive on [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) (now merged) needs scope: narrow (two evasive-transform exports) vs. repo-wide, and base branch `llm` vs. `master`. Separately, the `formula-inspector-retention-paths-table` plan is blocked until [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284) gets the rebase-and-gamut you requested back on 2026-05-21. Note also the recurring comment-watcher "0 comments for N ticks" anomaly alerts are the false-positive inactivity reports already slated for removal.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 11d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 37d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 36d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 38d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 37d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

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

- `20260627T082148Z-6fd4ed` — from gardener:ingest-ocap-library-sections, reply_to `ingest-ocap-library-sections` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T082148Z-6fd4ed.md)

> Scholar ingest — six ocap library sections (job ingest-ocap-library-sections, gardener 93):
>
> Synthesis: the six requested topics already had their authoritative SOURCES ingested in the library; the gap was the concept-layer synthesis tying them together. Landed a distributed-ocap concept cluster on journal2 (commit dc5d328e):
>
> - three-party-handoff — OCapN CapTP § Third Party Handoffs (Gifter/Receiver/Exporter, signed gift/handoff certificates); the Granovetter operator across sessions.
> - sturdyref — OCapN Locators § Sturdyref (Peer Locator + swiss-num) + Concurrency Among Strangers §9.2; the durable/offline reference, Initial-Conditions made persistent.
> - distributed-confinement — Paradigm Regained §5 (Cassie/Max factory, data diode, non-discretionary) + the Confinement Myth; confinement across vats.
> - eventual-send — @endo/eventual-send (E()/HandledPromise) + CAS vat/event-loop; umbrella over promise-pipelining and handler-protocol.
> - grant-matcher-puzzle ("grant matching") — Mark Miller's erights.org equality puzzle. This is the one with NO in-corpus source: erights.org/caplet.com were unreachable (ECONNREFUSED). Page is flagged draft/external-lineage; follow-on scholar-ingest-grant-matcher-puzzle parked (deferred) to ingest the source when erights.org is reachable.
>
> Cross-linked the three pre-existing concepts (granovetter-operator, pass-invariant-handle-equality, promise-pipelining) bidirectionally; the six interlock exactly as predicted (handoff↔grant-matching↔sturdyref↔eventual-send↔confinement; pass-invariant equality underlies all). Also parked scholar-ingest-passable-equality (low) to broaden equality beyond the Handle-side instance.
>
> Topic whose source I could not locate: grant matching (erights.org down) — concept written from a web-search summary, honestly flagged, source-ingest deferred.

- `20260627T083851Z-f3bf86` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T083851Z-f3bf86.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 3ab9074bca91f72f0de738e5b25e172aa7ea138e but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/gardener.sh
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T084057Z-24e458` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T084057Z-24e458.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 6a6e21b36cc9faaf868923e1e3af83fc7ebefa36 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/gardener.sh
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T084458Z-2eff00` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T084458Z-2eff00.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 6a6e21b36cc9faaf868923e1e3af83fc7ebefa36 but the live tree is stuck at 2e3372fbe4610f81fd6cc56e8c69d3640fd34a27: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/claim-job.sh
>  M scripts/jobs/gardener.sh
>  M skills/gardener-inbox-error-reporting/report-error.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T090109Z-b8fee9` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T090109Z-b8fee9.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 180 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T094618Z-cf40de` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T094618Z-cf40de.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to ec4b0494c272c87bfae9c7dc9623491e92677067 but the live tree is stuck at cb3c2e0d73dec05f4ce5cb60f83db42d7e9a2397: fast-forward refused (an untracked file collides with an incoming tracked path).
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.

- `20260627T100134Z-2f9b1a` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T100134Z-2f9b1a.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 220 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T101532Z-649994` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T101532Z-649994.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 89e5db9fb287f6b1a6296708ab892c91623c83f6 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: fast-forward refused (an untracked file collides with an incoming tracked path).
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.

- `20260627T110207Z-3896f2` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T110207Z-3896f2.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 260 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T111122Z-225c6a` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T111122Z-225c6a.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 7899b55e7f3429bfd333fdaa1292cae268430585 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: fast-forward refused (an untracked file collides with an incoming tracked path).
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.

- `20260627T113955Z-e8613c` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T113955Z-e8613c.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 7899b55e7f3429bfd333fdaa1292cae268430585 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/library-link-check.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T114242Z-b09365` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T114242Z-b09365.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to c043b4ba0787a08047673fe514f4f4eae75ba176 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T114447Z-a4fa48` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T114447Z-a4fa48.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to f0b93d637cb56a186aabcd4120f2b925eac1b76f but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T120202Z-99ffce` — from gardener:classify-lint-endo-master, reply_to `classify-lint-endo-master` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T120202Z-99ffce.md)

> Lint classification — endo master (endo-but-for-bots master @364d69ba1).
>
> FINDING: master lint is CLEAN. CI's `yarn lint` gate (prettier + root eslint + shellcheck) is fully green; per-package eslint across 49 packages and spot-checked tsc are clean too. There are NO lint ERROR classes to fix.
>
> The only findings are 5 jsdoc WARNINGS (do not fail CI), in 2 rule-classes:
>   - jsdoc/require-param ×4 (packages/daemon) — autofixable
>   - jsdoc/check-tag-names ×1 (compartment-mapper, @remarks tag) — needs judgment
>
> Posted ONE deferred/low plan covering both: `fix-lint-jsdoc-warnings-endo-master` (consolidated rather than two near-empty per-rule plans, since both are tiny jsdoc warnings). Promote it if you want the warnings cleared.
>
> Note: bot master is 64 commits AHEAD of upstream endo (legitimately merged bot-fork PRs) and 8 behind; I did NOT force-sync to upstream — the ahead commits are real work, not drift.

- `20260627T120229Z-1abe89` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T120229Z-1abe89.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 300 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T120942Z-ede624` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T120942Z-ede624.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to f0b93d637cb56a186aabcd4120f2b925eac1b76f but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/journal-entry.sh
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T121142Z-2c161a` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T121142Z-2c161a.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 1665456ea03ccf26d784f20a5105e748c2630aa9 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/journal-entry.sh
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T122423Z-3d9c8a` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T122423Z-3d9c8a.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 310dfcece33a6ebf0da0b5787ca92d6874783998 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/journal-entry.sh
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T122629Z-fc8eb0` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T122629Z-fc8eb0.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 97110365b7b920268eb046a75ceccfa7cb9d6746 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/journal-entry.sh
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T123905Z-ee2b02` — from gardener:endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers, reply_to `endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T123905Z-ee2b02.md)

> Revisit of PR #442 deferred plan (reusable file/crypto powers for @endo/daemon-cas tests) — concluded: intrinsic duplication, no change.
>
> Survey result:
> - The only API-exact match for the four-method ContentStoreFilePowers / ContentStoreCryptoPowers is @endo/daemon's makeFilePowers({fs,path}) + makeCryptoPowers(crypto) in daemon-node-powers.js (a superset of both contracts). BUT @endo/daemon has @endo/daemon-cas as a runtime dependency (the point of the #442 extraction), so a daemon-cas test depending on @endo/daemon — even devDep — inverts the extraction and creates a workspace cycle. Architecturally disallowed.
> - @endo/platform (a real daemon-cas dep) exposes makeLocalBlob/makeLocalTree (a higher-level blob/tree CAS abstraction), not the four-method powers shape, and no array->async-iterable helper. Not narrowable without a wrapper as large as the inline shim.
> - @endo/stream exports only queue/stream/pipe primitives — no array->async-iterable helper (trigger #1 does not hold).
> - content-store.test.js is the ONLY workspace file constructing this powers shim (trigger #2 does not hold). asAsyncIterable-style inline generators in other tests (chat, exo-stream, ocapn-noise) are each local 4-6 line generators, no shared helper.
>
> Both re-arm triggers stay armed; the plan re-fires if @endo/stream gains a real array->async-iterable helper, or a second test reaches for the same real-fs/crypto powers shim. Optional low-risk improvement if you want it folded into #442: a one-line comment by the inline shim noting the identical @endo/daemon powers are intentionally not reused because daemon depends on daemon-cas. I left the PR branch untouched since it is under active review.

- `20260627T125202Z-44b78c` — from gardener:endo-but-for-bots-harden-exported-literals-followup, reply_to `endo-but-for-bots-harden-exported-literals-followup` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T125202Z-44b78c.md)

> # Scope decision needed: "harden exported function literals" follow-up (endo-but-for-bots)
>
> Origin: erights bullet 4 on endojs/endo-but-for-bots#474 — "agreed, not in this
> PR. Please start a separate PR with that change... Attn @kriskowal". The job is
> gated on you scoping its breadth before any cross-repo PR opens.
>
> What I verified (read-only) today:
>
> - **#474 is MERGED** (into `master`, 2026-06-26): "retire function-keyword in
>   favor of arrow/method syntax per erights review". No open PR on endo-but-for-bots
>   or endo covers the harden follow-up.
> - **The literal form differs by branch** — this matters for how the change is
>   written and which base to target:
>   - Default/working branch `llm`: `evadeCensorSync`/`evadeCensor` are still
>     un-hardened **function declarations** (index.js:65 / :129).
>   - `master` (post-#474): the arrow-const form erights reviewed (his ref was
>     index.js:91).
> - A real `@endo/harden-exports` eslint rule exists in the repo (#474 touched it),
>   so a repo-wide pass would lean on / interact with it.
> - Note: the parked job spec described the evasive-transform exports as
>   "un-hardened arrow consts" — that's only true on `master`; on the `llm` default
>   they're function declarations. So the base branch choice changes the diff shape.
>
> Decision I need from you (two axes):
>
> 1. **Breadth** — (a) **narrow**: harden only the two evasive-transform exports
>    (`evadeCensorSync`, `evadeCensor`); or (b) **repo-wide**: harden every exported
>    function literal, driven by/aligned with the `@endo/harden-exports` rule
>    (designer-first; larger blast radius). erights authorized (a) and framed (b) as
>    the better trailing form.
> 2. **Base branch** — target `llm` (default) or `master`?
>
> On your answer I'll dispatch a builder (narrow) or designer→builder (repo-wide) to
> open a DRAFT PR with that scope and run the gamut. Authorization to open the
> cross-repo PR is already carried by erights's directive; only breadth + base are
> owed.

- `20260627T130256Z-0f8641` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T130256Z-0f8641.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 340 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T134205Z-c2943c` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T134205Z-c2943c.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 68f699cc8c53924f34a3c883a4d960aa7a8f4809 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/journal-entry.sh
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T140312Z-ac103b` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T140312Z-ac103b.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 380 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T141343Z-5acb7a` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T141343Z-5acb7a.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 3ed55eec32a5a16a039feca35f0307fadbc7ef00 but the live tree is stuck at fe1034b7615f11ce875dc5b672adbea2b796dc15: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/journal-entry.sh
>  M scripts/jobs/library-link-check.sh
>  M scripts/jobs/library-link-scan.sh
>  M scripts/jobs/test/library-link-check-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T150334Z-79820a` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T150334Z-79820a.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 420 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.

- `20260627T153338Z-f3cc46` — from gardener:investigate-beta3-ymax0-portfolio-upgrade-stack-overflow, reply_to `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T153338Z-f3cc46.md)

> Gate/scope stop: bot gardener 73 (endolinbot) claimed go-ahead-gated job
> 'investigate-beta3-ymax0-portfolio-upgrade-stack-overflow' but is declining to run it.
>
> Three independent reasons it cannot/must not run on the bot fleet:
> 1. SCOPE: the brief targets agoric-sdk, which is off-limits for autonomous garden work
>    (standing directive: "we must not and cannot do anything for agoric-sdk").
> 2. GATE: the brief itself says go-ahead gated, "run only on explicit maintainer
>    authorization, by the maintainer or a maintainer-supervised session. NOT bot-fleet work."
>    It carries gate=go-ahead but was promoted to todo/ at 15:32:04Z and auto-claimed by the
>    fleet 4s later (15:32:08Z).
> 3. ARTIFACTS ABSENT: every input lives on your Mac (/Users/kris/agoric-sdk @ ymax-v0.3.2606-beta3,
>    beta2.js/beta3.js, the slog crash JSON in ~/Downloads). None exist on endolinbot; only a
>    stray /home/kris/bundle-ymax0.json is here, which is insufficient. The work is physically
>    impossible on this host.
>
> No agoric-sdk investigation was performed. ACTION NEEDED: re-engage this brief in a
> maintainer-supervised session on your Mac where the artifacts live (it is a real, valuable
> investigation — XS native-stack overflow during the ymax0 portfolio vat upgrade, prime mover
> commit 3952deecd4 "sync Endo to latest including ses 2.x"). The board entry is being marked
> done so the fleet stops re-claiming it; the brief content is preserved in this message and the
> plan history so its intent is not lost.
>
> Possible garden-infra follow-up: tighten promote-plan.sh / the promotion path so a gate=go-ahead
> plan cannot land in todo/ on a bot host without a maintainer-supervised marker, since the fleet
> will race-claim anything in todo/ within seconds.


## Board
### todo (0)
(none)

### doin (4)
- [`comment-watcher-no-inactivity-anomaly`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/comment-watcher-no-inactivity-anomaly.md) — Comment-watcher: stop reporting human inactivity as an anomaly; make blindnes...
- [`land-journal-entry-hardening`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/land-journal-entry-hardening.md) — Land the journal-entry.sh hardening (preserve a gardener's stashed WIP)
- [`rename-killswitch-to-draining-marker`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/rename-killswitch-to-draining-marker.md) — Rename the killswitch to a mundane "draining" marker (existence-meaningful + ...
- [`watchman-resolve-wedge-autonomously`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/watchman-resolve-wedge-autonomously.md) — Watchman: resolve dirty-tree wedges AUTONOMOUSLY (no maintainer escalation)

### tada (364)
- [`investigate-beta3-ymax0-portfolio-upgrade-stack-overflow`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-beta3-ymax0-portfolio-upgrade-stack-overflow.md) — Completion report
- [`improve-library-source-drift-scan`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-library-source-drift-scan.md) — Completion report: improve-library-source-drift-scan
- [`deadmail-20260627T151020Z-5f405e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260627T151020Z-5f405e.md) — Completion report — deadmail-20260627T151020Z-5f405e (intent of cognito-mcp-m...
- [`scholar-refresh-marshal-rankorder-encodepassable`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-refresh-marshal-rankorder-encodepassable.md) — Completion report — scholar-refresh-marshal-rankorder-encodepassable
- [`scholar-library-cycle-20260627-145422`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-145422.md) — Completion report — scholar-library-cycle-20260627-145422
- … and 359 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · fix-lint: jsdoc warnings on endo master (the only lint findings)
- [`scholar-ingest-ocap-kernel-comment-fragments`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments.md) — _low_ · PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
