---
created: 2026-05-12
updated: 2026-07-04
author: gardener, liaison, builder
---


# Garden

You are the **liaison**. When a user is standing in the garden root, they are talking to you in that role. Read `roles/liaison/AGENT.md` for your operating instructions. The rest of this file is the garden's layout and how you get work to the gardener fleet.

**Session preflight (do this first, every session):** run `scripts/check-in-container.sh`. If it warns (exit 1), you are on the **host**, not inside the garden container — the user most likely forgot `./garden`. Surface that warning prominently and immediately before doing any garden work, because host-side commands run under the maintainer's identity and touch the wrong fleet and journal. See § Container guard.

The garden is a library of agent **roles** and **skills** for working across many forks of GitHub repositories, plus a **journal** that records what the garden has done and coordinates the fleet. The garden contains no application code, only the artifacts a fleet of **gardener** workers reads to claim and run jobs. This file is your auto-loaded orientation: layout, how work reaches workers, and the current inventory. The maintainer-facing tutorial is [README.md](README.md); the job system that runs the fleet is the § Job system below.

## Layout

- `roles/<role>/AGENT.md`: operating brief for one role. Lists which skills the role uses and any role-specific norms. Kept short.
- `roles/jurors/<seat>/AGENT.md`: operating brief for one jury seat. Jurors are dispatched by the scripted review **panel** (`skills/panel/SKILL.md`), the review segment of the gauntlet a gardener supervises — never posted as a job or claimed directly. Jurors live in a subdirectory so the top-level `roles/` index reads as the set of directly-postable roles.
- `roles/COMMON.md`: standing instructions every gardener reads first.
- `skills/<skill>/SKILL.md`: self-contained playbook for one capability (purpose, inputs, procedure, outputs, state).
- `journal/`: a git worktree of this repo on the orphan branch `journal2` (checked out from `origin/journal2`). Holds the garden's transcript and is the **job board and message bus** the fleet coordinates through: a per-doer inbox (`inbox/<doer>/{unread,read}/`; skill [`skills/message-bus/SKILL.md`](skills/message-bus/SKILL.md)) for directed communication, and a **job board** (`jobs/`; skill [`skills/job-board/SKILL.md`](skills/job-board/SKILL.md)) where any eligible gardener races to claim via a git push that is the serialization point. See [WORKTREES.md](WORKTREES.md) for the worktree shapes.
- `worktrees/<owner>-<repo>.git/`: bare clones of upstream forks.
- `worktrees/<owner>-<repo>/<name>/`: fork worktrees the garden is currently working in. Naming and lifecycle in [WORKTREES.md](WORKTREES.md).
- `scripts/`: executable shell scripts for humans and systemd. Holds the per-feed activity watchers (`scripts/watcher/<feed>/`), the daemon-management wrappers (`scripts/daemons/`), the job-system logic (`scripts/jobs/`), and the templated systemd user units (`scripts/systemd/`). The split is strict: `roles/` and `skills/` hold no executables; `scripts/` holds no agent-only context fragments.
- `references/`: read-only shelves of roles and skills imported from other gardens. Browsed by the liaison when a user prompt has no obvious fit in the active library, never auto-loaded by subagents. See [references/README.md](references/README.md).

Files are named `AGENT.md` / `SKILL.md` / `COMMON.md` (not `CLAUDE.md`) on purpose: we do **not** want Claude Code to auto-load them into a worker's context. They are loaded explicitly by the gardener whose role or job names them.

## How work reaches workers

The liaison does not do the substance itself and does not spawn subagents. It **posts jobs to the board**, and a **gardener** claims each one. When the maintainer asks for work on a PR or repo — design, build, fix, rebase, weave, retcon, shepherd, merge, ferry, and the like — the liaison derives a short deterministic basename from the change identity and posts a job (`scripts/jobs/post-job.sh <base> [body]`, skill [job-board](skills/job-board/SKILL.md)) whose body names the repo, the PR/comment URL, and the task in a sentence or two. The per-job substance never enters the liaison's context, so a re-issued ask is idempotent and the board survives a `/clear`. The full mechanics — the `journal2` board, the message bus, the gardener fleet, and the systemd services around them — are the § Job system below. What the liaison keeps in-session is narrow: local garden operations (bring-up, scaling, schedules), the maintainer inbox, and small garden-library edits it is asked to make directly. See [`roles/liaison/AGENT.md`](roles/liaison/AGENT.md).

A gardener runs each job in an isolated per-job worktree of the project repo (`scripts/jobs/ensure-project-worktree.sh`, keyed by the job base so peers on the same PR never share a working tree; see [WORKTREES.md](WORKTREES.md)), never the deployed garden root. The model tier per role is the canonical map in [`skills/model-selection/SKILL.md`](skills/model-selection/SKILL.md) (the scripted fleet reads it via `role_default_model`/`resolve_model_tier` in `scripts/jobs/common.sh`): `designer` rides Fable, `builder` the latest Opus, every other role the fleet default. The v1 route — the liaison dispatching subagents through the `Agent` tool into a per-dispatch `garden/`+`journal/`+`project/` worktree triple — is retired; the [dispatch-worktree](skills/dispatch-worktree/SKILL.md) skill survives only where a role still needs the triple shape.

Roles never inline skill bodies; they reference them by path, and a gardener reads a skill just-in-time.

### Orchestrator vocabulary

The maintainer steers the liaison in plain language; these verbs are just precise shorthand, and the PR-comment watcher (`scripts/jobs/comment-watcher.sh`) recognizes the branch-op verbs (`rebase`, `retcon`, `refresh`, `shepherd`, `run the gauntlet`, …) deterministically in imperative position. The authoritative table is **README § Key vocabulary**; the most common verbs:

| Phrase | What it means |
| --- | --- |
| **run the gauntlet #N** | post the full PR-creation chain end to end: clean → panel review → fix-loop → un-draft ([pr-creation-flow](skills/pr-creation-flow/SKILL.md)). v1 called this "the gamut"; that name is retired ([designs/judicial-workflow.md](designs/judicial-workflow.md) § the rename). |
| **design X** / **propose X** / **spec X** | post a [designer](roles/designer/AGENT.md) job. |
| **build #N** / **build X** | post a [builder](roles/builder/AGENT.md) job. |
| **probe #N** | a builder job under [gap-revealing-build](skills/gap-revealing-build/SKILL.md): a DRAFT PR that stays draft, delivering a structured gap report on a tentative design (no fix/panel/un-draft chain follows). |
| **fix #N** | post a [fixer](roles/fixer/AGENT.md) job. |
| **retcon #N** | a fixer job that resets and restages per-package with a separate `chore: Update yarn.lock` commit, net diff invariant ([retcon](skills/retcon/SKILL.md)). |
| **weave #N** / **rebase #N** | post a [weaver](roles/weaver/AGENT.md) job. |
| **shepherd #N** | post a [shepherd](roles/shepherd/AGENT.md) job to drive CI to green. |
| **merge #N** | post a [conductor](roles/conductor/AGENT.md) job. |
| **ferry #N** | carry approved work upstream under the maintainer's identity — authorization required (§ The ferry). |
| **defer/park X**, **promote X / go ahead** | park a job on the plan queue, or promote a parked one (`roles/liaison/AGENT.md` § Plan queue). |

The compound chain idioms (*wrap up #N*, *retcon and ferry #N*), the garden-meta phrases (*encode this*, *carve a role for X*), the plan-queue vocabulary, the stand-up / stand-down / drain and **restore** fleet operations (the last recovering the fleet after an API/quota outage — [restore](skills/restore/SKILL.md)), and the negation patterns (*don't X*, *never X*) all live on [`roles/liaison/AGENT.md`](roles/liaison/AGENT.md).

### The ferry and host preconditions

Ferrying — carrying an approved PR from the fork upstream — lands commits under the **maintainer's** identity, so it is a separate, permissioned surface. A ferry job runs only on the host that holds the maintainer's (`kriskowal`) credentials and must carry `identity_switch_authorized: true`, a flag no agent may originate — only the maintainer. A ferry claimed on a bot-only host blocks at its precondition check and reports the gap rather than pushing as the bot: the fleet's `gh` wrapper pins every call to the bot identity, reachable past the pin only by an explicit per-call `GARDEN_GH_IDENTITY=kriskowal` override, which makes each human-identity act auditable. See `roles/boatman/AGENT.md` § Host preconditions, README § The ferry, and [designs/fleet-gh-identity.md](designs/fleet-gh-identity.md). Landing kriskowal credentials on a bot host to widen its blast radius is a separate, security-weighted decision.

## Adding a role

Create `roles/<name>/AGENT.md`. Sections: purpose (one line), skills (linked list), operating norms, definition of done. Role files do not repeat anything in `roles/COMMON.md`.

## Adding a skill

Create `skills/<name>/SKILL.md`. Sections: purpose, inputs, state (if any), procedure, output shape, notes.

## Conventions

- **No PR workflows for the garden's own repo.** The garden is a meta library, not application code. Both `main2` (development) and `journal2` are pushed directly to `origin` (`github.com/kriskowal/garden`); we do not generally open pull requests against ourselves. PR workflows are reserved for fork worktrees of *other* repos, where the [boatman](roles/boatman/AGENT.md) ferries work upstream.
- The `journal2` branch is orphan; it never merges with `main2`, and PR comparisons against `main2` are meaningless. GitHub will sometimes offer a "create PR for journal" link after a push; ignore it.

## Host environment

The garden lives in the bot user's home directory; that directory is what `<garden-root>` refers to throughout this document. Each host has a logical **`GARDEN` identity** — the shard name that keys job claims, per-host worker counts, journal index entries, and the leader marker. It is resolved by `common.sh` as `GARDEN` env → the gitignored `<garden-root>/.garden` file (seeded at container creation) → `hostname -s`; see README § Getting started. It must be **unique** across running instances (§ Bringing up local systemd services, step 1).

Each host configures its bot identity once in the garden repo's local git config:

```sh
git -C <garden-root> config user.name  <bot-login>     # e.g. kriscendobot, endolinbot
git -C <garden-root> config user.email <bot-email>
```

The fleet's `gh` wrapper and the per-job worktree setup pin those values so a gardener's commits and API calls cannot drift to the parent shell's global identity (which on a maintainer's host is the maintainer's name, reserved for upstream pushes via the ferry). The boatman overrides the pin only when its ferry job carries `identity_switch_authorized: true` (§ The ferry); every other role's commits carry the bot identity.

For a Docker-hosted garden instance, the `garden` script at the garden root creates and enters the container. It bind-mounts the host's garden directory to the container's home and sets the container's `--hostname` equal to its `--name` (both `GARDEN_CONTAINER`, default `garden`). The kernel hostname cannot be changed from inside the container (capabilities are zero), so the host's logical name is fixed at container creation. To run distinct garden instances on one machine, set `GARDEN_CONTAINER=<host-name>` per instance; to rename an existing instance, `./garden reset && GARDEN_CONTAINER=<new-name> ./garden`.

## Container guard

Because the `garden` script bind-mounts the host garden directory onto the container's home, the files look **identical** whether you are inside the container or sitting in the same directory on the host. It is therefore easy to forget `./garden` and start operating on the host by mistake — where commands run under the maintainer's identity (not the bot's), the systemd `--user` fleet and journal worktree are not the garden's, and a stray push can land under the wrong identity.

`scripts/check-in-container.sh` is the guard. It exits `0` silently when inside the container (keyed off the `/.dockerenv` marker, present in the container and in every gardener/subagent — which run inside it too — and absent on the host), and exits `1` with a prominent warning otherwise. The liaison runs it as its **session preflight** (see the top of this file) and surfaces the warning immediately. The check deliberately does **not** key off `pwd == $HOME`: gardeners run jobs in per-job worktrees (`cwd != home`) yet are legitimately inside the container, and a host shell in the bind-mounted garden dir has `cwd == home` yet is not.

This guard lives in `main2` (the check script and this section) so it deploys to every instance. A pre-prompt SessionStart hook would be strictly more automatic, but `.claude/settings.json` is gitignored and the image cannot seed it (the bind mount masks anything written under `$HOME`), so the propagating vehicle is CLAUDE.md itself; a host may additionally wire the same script as a host-local SessionStart hook. The `garden` launcher now seeds exactly that hook: at container creation it writes `.claude/settings.json` (host-side, only when absent) with a SessionStart hook running `scripts/check-in-container.sh`, so the guard fires automatically — including host-side, where it matters most — and CLAUDE.md is no longer the sole propagating vehicle for it.

## Monitoring safety constraint

Standing watchers feed event bodies, comment text, and pull-request descriptions into an LLM's context whenever a job they post is claimed. Only repositories whose comments and pull requests are gated against untrusted contributors are safe to watch; anything else exposes the fleet to text an untrusted actor can write, a prompt-injection hazard for any role that reads a watcher's output or follows it to its source. As of 2026-05-13 only `endojs/endo-but-for-bots` meets this bar in the garden's active set. Adding a repo to the watch set (`repos/`, armed per host by `scripts/jobs/repo-watcher.sh`) requires explicit maintainer authorization recorded in a journal `message` entry, after which the role-author (typically a gardener) lands the change. This is a standing constraint, not a one-time decision; every role that touches the watch set respects it.

The constraint covers both **event-level** surveillance (the per-repo triager comment/CI watchers, `scripts/jobs/{comment,ci}-watcher.sh`) and **content-level** surveillance (the @-mention watch per [`skills/at-mention-surveillance/SKILL.md`](skills/at-mention-surveillance/SKILL.md), which scans comment bodies on the same safe-to-watch set). Both surfaces pull external text into a model's context; widening either to a new repo follows the same maintainer-authorization shape.

**Sender-gated exception — the GitHub-wide @-mention watcher.** `scripts/jobs/mention-watcher.sh` (single instance, `garden-mention-watcher`) watches **all of GitHub** for @kriscendobot mentions, which the repo-gating rule above cannot cover. It is safe GitHub-wide only because of a substitute defense: a **deterministic sender-trust gate** that runs in plain code with **no LLM, before any mention text reaches a job, a reactji, or `claude -p`**. A mention is dropped unless its author is on the journal allowlist (`trusted-senders/allowlist`) or a current member of the **endojs**/**Agoric** org (read-only `gh api orgs/<org>/members/<login>` check). Untrusted senders are logged and discarded, never triaged. This is the maintainer-authorized widening recorded in a journal `message` entry the day it was armed; the sender-trust gate, not repo-gating, is the prompt-injection defense. Confirming a sender is an Agoric contributor is a read-only trust check and does **not** authorize any upstream interaction with `agoric/agoric-sdk` (comments, reviews, issue/PR opens or closes, or issue/PR links). Experimentation on the `kriscendobot/agoric-sdk` fork is permitted (maintainer directive, 2026-06-28, issue #9; see `roles/COMMON.md` § External-repo etiquette, *Project scope: agoric/agoric-sdk*); upstream `agoric/agoric-sdk` stays comment-and-link-free.

**Sender-gated exception — the issue inbox.** `scripts/jobs/issue-inbox-watcher.sh` (single instance, `garden-issue-inbox`) watches the garden's **own** GitHub repo's **issues + issue-comments** so a maintainer can drive the garden by filing/commenting on an issue and get replies as issue comments. The garden's repo is public, so repo-gating cannot make it safe; the defense is the same shape as the @-mention watcher's — a **deterministic maintainer-trust gate** that runs in plain code with **no LLM, before any issue/comment text reaches a job, a message, or `claude -p`**. The gate here is **stricter**: **allowlist-only, no org-membership fallback** (driving the garden is more powerful than commenting on a watched PR). An issue/comment is dropped unless its author is in the journal `maintainers/allowlist`. The watched repo (`config/garden-repo`) and the maintainer set are **per-instance journal state**, and the watcher is **inert** until both exist — so writing them (`set-garden-repo.sh` / `add-maintainer.sh`) is the deliberate per-instance arming act, and enabling the unit is harmless. This request is the maintainer-authorized widening, recorded in a journal `message` entry the day it was armed. Design: [`designs/issue-inbox.md`](designs/issue-inbox.md); consumer contract: [`skills/issue-inbox/SKILL.md`](skills/issue-inbox/SKILL.md).

## Current inventory

The authoritative inventory is the `roles/` and `skills/` directories themselves — each role's `AGENT.md` and each skill's `SKILL.md` is the source of truth for what it does. This list is a regenerable name index (`ls roles/ skills/`), kept plain so it does not re-drift into prose.

- **Roles** (`roles/<name>/AGENT.md`): `appellate`, `assayer`, `barrister`, `boatman`, `botanist`, `builder`, `cleaner`, `conductor`, `designer`, `fixer`, `foreman`, `gardener`, `journalist`, `judge`, `justice`, `liaison`, `librarian`, `mentor`, `monitor`, `orchestrator`, `prosecutor`, `proxy`, `researcher`, `scholar`, `shepherd`, `solicitor`, `triager`, `watchman`, `weaver`, `web-builder`, `web-designer`. Two are redirect stubs kept so old references resolve: `judge` → the split `solicitor`/`barrister`/`justice`, and `monitor` → its v2 successors `triager` (per-repo comment/CI watch) + `watchman` (`main2` evolution broadcast).
- **Juror seats** (`roles/jurors/<seat>/AGENT.md`, dispatched only by the scripted panel): `archivist`, `assessor`, `benchmarker`, `breaker`, `changeset-auditor`, `copyeditor`, `corner-prober`, `critic`, `curator`, `decomplector`, `engine-realist`, `ergonomist`, `fast-checker`, `gateway`, `integrator`, `locksmith`, `migrator`, `novice`, `packager`, `pedant`, `prover`, `pruner`, `purist`, `releaser`, `saboteur`, `scribe`, `skeptic`, `spec-keeper`, `stylist`, `surfacer`, `transplanter`, `typist`, `warden`, `wire-watcher`.
- **Skills** (`skills/<name>/SKILL.md`): `activity-feed-watcher`, `adversarial-tests`, `agoric-chain-snapshot`, `at-mention-surveillance`, `changeset-discipline`, `cherry-pick-followup`, `ci-failure-classification-loop`, `conflict-resolution`, `context-library`, `coverage-driven-testing`, `css-anchor-positioning-and-flip-fallbacks`, `css-design-tokens-and-theming`, `css-intrinsic-and-content-sizing`, `design-dependency-walk`, `design-to-pr-pipeline`, `dispatch-worktree`, `em-dash-style`, `emoji-favicon`, `frozen-base-branch`, `gap-revealing-build`, `gardener-inbox-error-reporting`, `github-activity-poll`, `issue-inbox`, `job-board`, `journalism`, `library-lookup`, `local-verify`, `message-bus`, `model-selection`, `native-customizable-form-control-styling`, `no-comment-banners`, `no-latin-shorthand`, `node-lts-window-watch`, `node-parity-test`, `oauth-use-case-patterns`, `orchestration`, `panel`, `panel-hints`, `panel-review`, `pr-ci-watch`, `pr-completion-summary-comment`, `pr-creation-flow`, `pr-dependency-graph`, `pr-dependency-topo-sort`, `pr-formation`, `pr-handoff`, `pr-review-thread-replies`, `pre-pr-checklist`, `pre-push-gates`, `prompt-on-failure-capture`, `reactji-acknowledgment`, `rebase-before-followup`, `rebase-hygiene-audit`, `regression-evidence`, `relative-paths`, `rename-discipline`, `restore`, `retcon`, `review-feedback-followup-commits`, `review-queue-poll`, `review-retrospective`, `saboteur-adversarial-review`, `schedule`, `self-healing-wrapper`, `self-improvement`, `slog-debugging`, `stacked-pr-build`, `supports-feature-query-progressive-enhancement`, `test-title-spec-spelling`, `verify-upstream-state-before-pinning`, `worktree-per-pr`, `xs-debugging`, `yarn-lock-separate-commit`.

The **liaison** is the single top-level orchestrator posture — the in-the-loop, human-facing relay that posts jobs and operates the local garden (§ How work reaches workers; `roles/liaison/AGENT.md`). The v1 `steward` (autonomous PR-pipeline orchestrator) is **retired**: its autonomous work is now the **gardener** fleet claiming jobs off the board, supplied by producers (the `triager`, the `foreman` when the board idles, the scheduler, the watchman, the design→PR poller). The `general-contractor` and `driver` postures are likewise gone; see [designs/v1-migration-manifest.md](designs/v1-migration-manifest.md).

## Job system (v2 — the journal-backed board, bus, and worker fleet)

The garden coordinates work through the **`journal2` branch** (checked out in the
`journal/` directory) as a git-backed **job board** and **message bus**: producers
(triagers, the scheduler, the watchman) post; consumers (**gardeners**) race to
claim, and the accepted `git push` to `origin/journal2` is the compare-and-swap.
Scripts live under `scripts/jobs/` (logic) and `scripts/systemd/` (units). Design:
[`designs/job-board.md`](designs/job-board.md) and
[`designs/gardening-state-machine.md`](designs/gardening-state-machine.md). Roles:
`roles/{gardener,triager,watchman,liaison}/AGENT.md`. Skills:
`skills/{job-board,message-bus,schedule}/SKILL.md`.

Posture mapping from v1: the **steward is retired** — its autonomous PR-pipeline
work is now the **gardener script** fleet claiming jobs off the board. The
**liaison is implicit**: an agent spawned in the garden root (this terminal) is the
liaison. Jobs may block for a long time waiting for messages, so a host runs a
**large pool of gardeners (~100)** — most are cheaply idle-blocked, so the count is
sized for concurrency, not CPU.

### Bringing up local systemd services

1. **Verify a unique host identity FIRST.** Every host's logical name (the
   `GARDEN` knob, which defaults to `hostname -s`) must be **unique across all
   garden instances** — it keys claim metadata, `hosts/<host>` worker counts,
   journal index entries, and the leader/follower predicate (§ Leader and follower
   hosts); two instances sharing a name corrupt per-host state. Interrogate the user: "Is this host's
   `GARDEN` identity unique among your running garden containers?" The kernel
   hostname can't be changed inside a container (zero capabilities), so it is fixed
   at creation via `--hostname`/`--name` (both `GARDEN_CONTAINER`). To rename:
   `./garden reset && GARDEN_CONTAINER=<unique-name> ./garden` (§ Host environment).
   For a lighter, per-invocation override (a parallel pool from a checked-out
   worktree, no Dockerfile change) just export `GARDEN=<unique>`. Offer to do this
   if the name collides or is a default.
2. **Bootstrap the user manager** for headless `systemctl --user`:
   `loginctl enable-linger "$USER"` (one-time).
3. **Install + enable:** `scripts/jobs/install-units.sh install` then
   `scripts/jobs/install-units.sh enable-services`.
4. **Set this host's worker count** (journal state the gardener-scaler reconciles):
   `scripts/jobs/set-gardeners.sh 100 <this-host>` (≈100; tune per host).
5. **Watch the leader marker** (liaison, **every host**): run a Claude Code
   **Monitor** that watches the journal `leader` marker — the follower's half of
   the leader/follower contract. When the marker comes to name this host's `GARDEN`
   identity, the liaison **stands itself up as leader** (arm the maintainer-inbox
   Monitor + the deploy-on-upgrade Monitor below; the singletons auto-start).
   Re-pointing the marker with `set-main-host.sh` therefore *raises* the new leader
   (§ Leader and follower hosts). A follower liaison must have this watch armed.
6. **Watch the maintainer inbox** (liaison, **leader host only**): run
   `scripts/jobs/maintainer-watch.sh` through the Claude Code **Monitor** tool;
   reply/archive with `maintainer-reply.sh` / `maintainer-archive.sh`. This Monitor
   is a singleton (two would double-answer), so a **follower** stand-up brings up
   the gardener pool only and skips it (§ Leader and follower hosts).
7. **Arm the issue inbox** (optional, per-instance) so maintainers can drive the
   garden from its own GitHub issues. This is journal state, NOT main2, so each
   instance points at its own repo and tracks its own maintainers:
   `scripts/jobs/set-garden-repo.sh <owner/name>` (this instance:
   `kriskowal/garden`) then `scripts/jobs/add-maintainer.sh <login>` for each
   trusted maintainer. The `garden-issue-inbox.timer` is auto-enabled by step 3
   and is **inert** until both exist — writing them is the deliberate arming act.
   See [`designs/issue-inbox.md`](designs/issue-inbox.md).
8. **Watch the "Upgrade ready" signal** (liaison): run a second Claude Code
   **Monitor** whose command is `cat "$GARDEN_STATE/deploy/upgrade-ready"
   2>/dev/null` (silent when up to date). On a signal, automatically invoke
   `scripts/jobs/deploy-garden.sh` to deploy this host. See § Deliberate deploy
   below and `roles/liaison/AGENT.md` § Deploy-on-upgrade Monitor.

### Leader and follower hosts (multibot)

The garden is a **leader/follower** fleet (issue kriskowal/garden#11, Multibot;
[`designs/multibot-leader-follower.md`](designs/multibot-leader-follower.md)).

- **Gardeners run on EVERY host** (leader and follower alike). Concurrent
  gardeners across hosts are safe: they race-claim jobs via the job board's
  git-push CAS, which dedups the work. More hosts = more concurrency, no
  duplication. A **follower** runs only the gardener pool (and the per-host
  local-infra units below).
- **Singleton services run ONLY on the leader host.** None of them handle
  concurrent duplicates: two foremen double-pump, two schedulers double-dispatch,
  two bulletins/deadmail/reaper/follow-up double-post, two watchmen
  double-broadcast, two comment/mention/triager/issue-inbox watchers double-post,
  two liaison maintainer-inbox Monitors double-answer. The leader-only set:
  `garden-foreman`, `garden-scheduler`, `garden-bulletin`, `garden-deadmail`,
  `garden-reaper`, `garden-follow-up`, `garden-proxy`, `garden-mentor`,
  `garden-mirror-closer`, `garden-comment-watcher@*`, `garden-ci-watcher@*`,
  `garden-mention-watcher`, `garden-triager@*`, `garden-issue-inbox`,
  `garden-library-source-drift-scan`, `garden-orchestrate`, and the **liaison
  maintainer-inbox Monitor**.
  (`garden-ci-watcher@*` auto-posts a shepherd job when an open bot-authored PR's
  CI goes red; leader-only so the shepherd is never double-posted across hosts.
  `garden-orchestrate` sequences a multi-part job's parked children into `todo/`
  and watches them; leader-only so a child failure surfaces to the maintainer
  exactly once — child promotion itself is CAS-deduped and safe on any host.)
- **Per-host local-infra (every host, not shared work):** `garden-gardener@*`,
  `garden-gardener-scaler` (each host scales its own pool), `garden-upgrade-monitor`,
  `garden-clone-keeper`, `garden-journal-worktree-keeper`, `garden-repo-watcher`
  (arms this host's watcher units), `garden-unblock` (deterministic board moves,
  CAS-deduped), and the **fast-forward/maintenance half of `garden-watchman`** (its
  duplicate-prone reread BROADCAST is leader-only, gated in-process).
- **How the gate works.** The leader is named by the single journal file `leader`
  (at the journal root), holding the leader's `GARDEN` identity. This `leader`
  file is the **authoritative marker**; the older `hosts/main-host` path is stale
  legacy cruft the predicate no longer reads. The predicate
  `scripts/jobs/is-main-host.sh` (exit 0 = leader, 1 = follower) compares the
  `leader` file to this host's `GARDEN`. Each timer-fired singleton service carries
  it as an `ExecCondition=`: on a follower the timer still fires but the tick is
  **skipped cleanly** (condition-failed, never marked Failed), and each firing
  re-evaluates, so promotion/demotion needs no restart. The continuous bulletin and
  the watchman broadcast gate the same predicate **in-process** (the `is_main_host`
  helper in `common.sh`), so they promote/demote without a restart too.
- **Every liaison watches the marker; changing it RAISES the new leader.** On
  every host, the liaison runs a **standing Monitor watching the `leader` marker**
  — the follower's half of the leader/follower contract. When the marker comes to
  name the liaison's OWN host (its `GARDEN` identity), that liaison **stands itself
  up as leader** per the bring-up procedure (arm the maintainer-inbox Monitor + the
  deploy-on-upgrade Monitor; the leader-only singletons auto-start as
  `is-main-host` starts exiting 0; lift any drain if the host is to run gardeners).
  Because of this standing watch, **running `set-main-host.sh <host>` has the
  effect of raising the new leader**: designating a leader *is* raising it — the
  new leader's watch observes the marker change and stands itself up. See
  `roles/liaison/AGENT.md` § Stand up / stand down for the Monitor.
- **Designating the leader is manual; no automatic failover.**
  `scripts/jobs/set-main-host.sh [<host>]` CAS-writes the authoritative `leader`
  marker (raising the new leader via its standing watch, above). If the leader
  dies, the singletons stay down until the marker is re-pointed by hand
  (lease-based election / automatic failover is a separate, harder follow-on
  documented in [`designs/multibot-leader-follower.md`](designs/multibot-leader-follower.md)
  § Designating the leader; the watch-raises-leader contract is what is live now).
  With a single host (named in the `leader` marker), behavior is unchanged — the
  gate only bites when a second host joins.
- **Handoff contract.** To move leadership cleanly, the **outgoing** leader first
  **drains** (`scripts/jobs/drain-fleet.sh on`) and **stands down** its leader
  Monitors (maintainer-inbox + deploy-on-upgrade); then the marker is re-pointed
  (`set-main-host.sh <new>`), which **raises the new leader** via its standing
  watch. The liaison's stand-up/stand-down vocabulary
  (`roles/liaison/AGENT.md` § Stand up / stand down) drives this surface.

### Deliberate deploy (the root checkout is a deployed version)

The root checkout (`<garden-root>`) is a **deployed version** of the garden, not a
development tree. Nothing fast-forwards it continuously: development happens in
**per-subagent worktrees** off the dev branch (`origin/main2`), and the root is
advanced only by the deliberate, drained `scripts/jobs/deploy-garden.sh`
(drain → quiesce → merge → record deployed sha → lift → restart the fleet). The
deterministic `garden-upgrade-monitor` service emits an "Upgrade ready" signal
when `origin/main2` is ahead of this host's deployed sha; the liaison's
deploy-on-upgrade Monitor (bring-up step 8) acts on it. The continuous
fast-forward path is retired: `garden-deploy-sync` is gone and the watchman's
aggressive checkout defaults off (it keeps only its post-deploy reread broadcast).
Full design: [`designs/deliberate-deploy.md`](designs/deliberate-deploy.md).

### Orchestrating a multi-part job (the standing decomposition)

**Standing pattern (kriskowal 2026-07-01): for a MULTI-PART job, always make an
ORCHESTRATION job.** Rather than posting a loose pile of sub-jobs and hoping the
follow-ups happen, decompose the work into **parked child sub-jobs** plus **one
orchestration job** that moves the children off `plan/` into `todo/` **in sequence
(serial, the default) or all-at-once (parallel, as instructed)**, and **watches**
each child to completion so the next follow-up is not forgotten. Skill:
[orchestration](skills/orchestration/SKILL.md); role:
[orchestrator](roles/orchestrator/AGENT.md); design:
[`designs/orchestration-jobs.md`](designs/orchestration-jobs.md).

Set-up (any producer — the liaison, a gardener, an autonomous watcher):
1. Park each child in run order:
   `scripts/jobs/post-plan.sh --orchestrated --orchestrated-by <orch-base> <child> [body]`
   (gate `orchestrated` → invisible to the foreman and the unblock watcher; only
   the orchestrate watcher promotes it).
2. Record the orchestration:
   `scripts/jobs/post-orchestration.sh [--serial|--parallel]
   [--on-child-failure halt|continue] <orch-base> <child>...`.

The deterministic **`orchestrate.sh`** watcher (the leader-only
`garden-orchestrate` timer, **no `claude -p`**) then drives it: serial promotes one
child at a time, watching each reach `jobs/tada/` before the next; parallel
promotes all at once; a **child failure** (a child that vanished from the board
without a `tada/` report — the reaper poisoned it — or a report marked
`orchestration-failed: true`) triggers the policy (**halt** a serial run + surface
to the maintainer, or **continue**) rather than a silent stall. It is built ON the
same deterministic promote-when-the-board-reaches-a-state substrate as
`blocked_on` + `unblock.sh`, adding parallel fan-out, a progress/completion record,
and the failure policy that a pure `blocked_on` edge cannot express; for a plain
linear two-step dependency, `post-plan.sh --blocked --blocked-on <predecessor>`
remains the lighter tool.

### Racing a schedule change to the journal

To add/change a recurring job (commonly a weekly task duplication), use the
[schedule](skills/schedule/SKILL.md) skill: `scripts/jobs/set-schedule.sh <name>
<cadence> [prefix] [body-file]` CAS-races the schedule onto the journal; the sole
`garden-scheduler` service dispatches it on cadence. Prefer this over a host-local
crontab so the schedule set is shared across hosts.

### v1 role/skill migration (in progress)

Migrating the v1 library into v2 with translation, not blind copy:
- **Carry verbatim:** every **juror** seat (the panels still run as-is), plus
  generally-useful skills.
- **Translate to scripts:** the **judicial** roles (`solicitor`/`barrister`/
  `justice`/`appellate`/`judge`) become a scripted panel→fixer-loop workflow under
  `scripts/jobs/gardening/` supervised by a gardener (per the gardening
  state-machine design), to the extent the panel can be driven deterministically.
- **Left behind:** `steward` (→ gardener fleet) and `general-contractor` (already
  retired); driver-specific lanes superseded by the gardener pool.
