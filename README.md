# Garden bulletin

_As of 2026-06-27T16:04:31Z_

## Latest

The deploy-sync reconciler landed on main2 (commit `5d6490e62`): it now fast-forwards the live checkout and restarts long-running services when `scripts/` changes, so landed fixes reach running workers without a manual restart. The catch is that endolinbot's own deploy has been **wedged all day** — the watchman fired a steady stream of dirty-tree alarms as origin/main2 advanced through ~20 commits while the live tree stayed frozen, blocked first by redundant uncommitted edits (one byte-identical to origin's committed `report-error.sh`) and later by untracked-file collisions. A gardener flagged a lossless `git checkout --` unwedge; until the tree is clean this host won't pick up new roles, skills, or scripts.

The beta3 ymax0 portfolio-upgrade "stack overflow" investigation [completed](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-beta3-ymax0-portfolio-upgrade-stack-overflow.md): a primary-source bundle diff ruled out two of three candidates (harden is iterative; `passStyleOf` catches cycles and throws) and corrected the brief's premise — beta3 also carries the Auto-Features contract change, so a "pin Endo back" bisection alone can't attribute the regression. The decisive XS stack-trace experiment needs the agoric toolchain, which the bot host lacks.

Two items are parked on **your decision**: the harden-exported-literals follow-up from [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) (merged) needs breadth (narrow vs repo-wide) and base branch (`llm` vs `master`) before a cross-repo PR opens; and the formula-inspector retention-paths table is blocked on #284's stalled rebase-and-gamut. Lower-stakes: endo master lint is clean (only 5 jsdoc warnings), and scholar landed ocap-kernel and distributed-ocap concept clusters. Note the comment-watcher anomaly reports are the known inactivity false-positives — a fix job (`comment-watcher-no-inactivity-anomaly`) is in flight.

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

- `20260627T160307Z-0bd3f9` — from gardener:investigate-beta3-ymax0-portfolio-upgrade-stack-overflow, reply_to `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T160307Z-0bd3f9.md)

> # Root-cause analysis: beta3 ymax0 portfolio-contract upgrade "stack overflow"
>
> Investigator: gardener (endolinbot), fork-scope authorization 2026-06-27.
> Method: primary-source diff of the two contract bundles (`beta2.js` working /
> `beta3.js` crashing) from the maintainer's gist, plus GitHub-API regression-window
> confirmation. The XS swingset repro could NOT be run in this environment (no agoric
> build toolchain / xsnap on the bot host; the fork is not checked out here). What
> follows is an evidence-backed narrowing and a decisive next-experiment plan, not a
> verified fix.
>
> ## Bundle provenance (verified)
> - `beta2.js` 1,129,924 B / 35,131 lines; `beta3.js` 1,139,323 B / 35,447 lines —
>   byte-exact to the brief.
> - String-literal diff (rename-noise normalized): 414 added / 395 removed literals,
>   ~99% pure minifier-rename churn.
>
> ## Regression window (CONFIRMED, GitHub API, no clone)
> - `repos/kriscendobot/agoric-sdk/compare/3952deecd4...9d518832d4` →
>   `status: ahead, ahead_by: 142, behind_by: 0, merge_base = 3952deecd4`.
>   So **`3952deecd4` ("chore(deps): sync Endo to latest including ses 2.x") is a true
>   ancestor of beta3 `9d518832d4`** and present on the fork. Brief fact #1 ✓.
>
> ## What the bundle diff actually shows (the core result)
>
> I walked every recursive path that runs on the `startVat` durable-exo rehydration
> route and compared beta2 (SES 1.14) against beta3 (SES 2.x):
>
> | Path | beta2 → beta3 | Verdict |
> |------|---------------|---------|
> | **`harden`** | Classic iterative work-list in BOTH (`a()` enqueues into set `n`; `d()=Z0(n,c)` drains BFS). beta3 adds only the `Symbol.for("harden")` / `@harden` wrapper indirection. | **Not recursive → ruled OUT** (brief candidate #2). |
> | **`passStyleOf` core** | Same `c→d` dispatcher; same persistent memo WeakMap; **same explicit cycle guard** (`Pass-by-copy data cannot be cyclic`). 2.x splits the per-style validator into `confirmCanBeValid` + `assertRestValid`, but `confirmCanBeValid` returns *before* `assertRestValid` descends — breadth, not depth. | Recursion depth-per-level **unchanged**. |
> | **pattern matcher registry** | 27 kinds → 28 kinds; the only addition is the **leaf** `match:promise` (payload `{label}`, no sub-pattern recursion). All combinators (`and/or/not/arrayOf/splitRecord/recordOf/mapOf/setOf/…`) byte-identical. | Combinator recursion **unchanged**. |
> | **`copyRecord`/`byteArray` helpers** | `confirmCanBeValid:(e,t)=>FC(e,t)&&keys(e).every(r=>KC(e,r,e[r],t))` — structurally identical to beta2's `canBeValid` form. | **Unchanged**. |
> | **orchestration async-flow membrane/replay** | Structural markers identical (`hostFlow=1, replay=32, bijection=9, membrane=4, makeGuest/Host=19, unwrap/wrap=23` in BOTH). | **Unchanged** (my first read flagged "new flow literals" — that was rename-noise; retracted). |
>
> Two of the brief's three candidates fall to direct evidence:
> - **Candidate #2 (SES 2.x harden over a deep/cyclic graph): RULED OUT** — harden is
>   iterative in both bundles; it cannot overflow the native stack by recursion.
> - **Candidate #3 (a true new cycle from the Endo bump): RULED OUT for any
>   pass-by-copy data** — `passStyleOf` detects cycles and *throws a clear error*
>   (`Pass-by-copy data cannot be cyclic`); it does not silently recurse to overflow.
>   (A cycle in a non-copy / remotable graph that no guard traverses is not excluded,
>   but nothing in the bundle points there.)
> - **Candidate #1 (passStyleOf / patterns over interface guards): right LOCUS, but the
>   bump did NOT deepen it.** Every recursive shape on that path is preserved 1.14→2.x.
>
> ## The premise correction (most actionable finding)
>
> The brief states "the Endo bump is the only runtime/hardening change between the
> bundles." **That is not true of this bundle pair.** beta3 also carries a contract
> change: the `OpenPortfolioWithAutoFeatures` / Auto-Features work (#12761) — Auto-Features
> literal count 21→26, OpenPortfolio 18→21. (Durable-kind count = 12 and interfaceGuard
> count = 13 are unchanged, so no *new* kinds, but the guard *contents* moved.)
>
> Consequence: a "pin Endo back and re-test" bisection alone cannot attribute the
> regression, because the contract guards/data also changed. The overflow is **depth-
> driven** (cycles are caught; harden is iterative), so the live question is *whose*
> depth grew — Endo's per-level frame cost, or the contract's guard/data nesting.
>
> ## Most-probable mechanism (consistent with all evidence)
>
> Native-stack exhaustion in the `passStyleOf` / patterns `checkMatches` (or marshal
> `unserialize`) recursion while rehydrating the portfolio contract's **interface guards
> and durable data at `startVat`** (last syscalls `vom.dkind.15/16/17` → `getBundle`
> match guard/kind re-establishment). It overflows XS's shallow native stack but not
> V8's deep one — exactly the env-dependence the brief notes. The trigger is **NOT** a
> new SES-2.x recursion (none is visible); it is a depth already near XS's margin pushed
> over by either (a) a sub-minification per-level frame increase in the Endo refactor, or
> (b) the Auto-Features guard/data depth increase in beta3 — likely (b), or (a)+(b).
>
> ## Decisive next experiment (must run where the toolchain + fork live)
>
> 1. **Capture the frame.** Build `kriscendobot/agoric-sdk@9d518832d4`; drive the v320
>    portfolio-vat upgrade (incarnation 70→71) under `packages/swingset`+`xsnap` with an
>    XS stack dump on overflow. The repeating frame cycle *names the exact function* —
>    this is the one missing fact the minified bundles cannot give.
> 2. **Attribute it (clean bisection).** From the same fork commit, pin ONLY the Endo
>    deps (`ses`, `@endo/pass-style`, `@endo/patterns`, `@endo/marshal`, `@endo/exo`)
>    back to beta2's versions with the **contract source unchanged**, and re-run:
>    - still overflows → it is the **contract/Auto-Features depth**, not Endo;
>    - stops overflowing → it is **Endo**; the step-1 trace names the helper.
> 3. **Confirm env-dependence.** Same upgrade on Node/V8 should pass (deep stack); and
>    beta2 deps should pass on XS — both as controls.
>
> ## Fix decision tree
> - **If contract-attributed:** flatten the portfolio interface-guard / durable schema
>   nesting (collapse nested `M.splitRecord`/`M.and`/`M.arrayOf` chains; shorten the
>   deepest durable key/record path) so depth drops below XS's limit. Fork-side fix in
>   `packages/portfolio-contract`.
> - **If Endo-attributed:** the step-1 trace names the helper; reduce its frames-per-level
>   (e.g. convert a hot recursive walk to an explicit work-list, as `harden` already is)
>   and file an upstream-Endo bug with the minimal XS repro (deliverable, NOT an upstream
>   push).
> - **Last resort only:** raise the XS native stack limit — mitigation, not root cause.
>
> ## Honest boundary
> Naming the single exact recursive frame and shipping a verified fix both require the
> XS stack trace from step 1, which needs the agoric build toolchain + fork checkout on
> a host that has them (the maintainer's machine or a provisioned fork CI). This was not
> runnable on the bot host. Everything above (rule-outs, regression window, premise
> correction, mechanism, experiment plan) is derived from primary sources and is ready
> to hand to that repro session.

- `20260627T160416Z-edee59` — from watchdog:comment-watcher/kriskowal-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T160416Z-edee59.md)

> ANOMALY: comment-watcher/kriskowal-garden found 0 comments for 452 consecutive ticks, but kriskowal/garden IS active (a comment exists since 2026-06-25T20:56:24Z). The watcher may be silently blind — check jq/gh on endolinbot and the comment-source handler. This is the 2026-06-24 outage signature.


## Board
### todo (0)
(none)

### doin (3)
- [`comment-watcher-no-inactivity-anomaly`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/comment-watcher-no-inactivity-anomaly.md) — Comment-watcher: stop reporting human inactivity as an anomaly; make blindnes...
- [`land-journal-entry-hardening`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/land-journal-entry-hardening.md) — Land the journal-entry.sh hardening (preserve a gardener's stashed WIP)
- [`rename-killswitch-to-draining-marker`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/rename-killswitch-to-draining-marker.md) — Rename the killswitch to a mundane "draining" marker (existence-meaningful + ...

### tada (366)
- [`investigate-beta3-ymax0-portfolio-upgrade-stack-overflow`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-beta3-ymax0-portfolio-upgrade-stack-overflow.md) — Completion report
- [`scholar-library-cycle-20260627-155443`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260627-155443.md) — I should not call complete-job.sh myself — the gardener wrapper completes the...
- [`watchman-resolve-wedge-autonomously`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/watchman-resolve-wedge-autonomously.md) — Completion report — watchman-resolve-wedge-autonomously
- [`improve-library-source-drift-scan`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-library-source-drift-scan.md) — Completion report: improve-library-source-drift-scan
- [`deadmail-20260627T151020Z-5f405e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260627T151020Z-5f405e.md) — Completion report — deadmail-20260627T151020Z-5f405e (intent of cognito-mcp-m...
- … and 361 more

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
