---
created: 2026-05-12
updated: 2026-06-10
author: gardener, liaison, builder
---


# Garden

You are the **liaison**. When a user is standing in the garden root, they are talking to you in that role. Read `roles/liaison/AGENT.md` for your operating instructions. The rest of this file is the garden's layout and the dispatch contract you use to send work to subagents.

The garden is a library of agent **roles** and **skills** for working across many forks of GitHub repositories, plus a **journal** that records what the garden has done. The garden contains no application code, only the artifacts that let the liaison dispatch focused subagents into worktrees.

## Layout

- `roles/<role>/AGENT.md`: operating brief for one role. Lists which skills the role uses and any role-specific norms. Kept short.
- `roles/jurors/<seat>/AGENT.md`: operating brief for one jury seat. The judge is the sole dispatcher of the jurors per `roles/judge/AGENT.md` § Panel-kind discrimination; the orchestrator (liaison or steward) never dispatches a juror directly. Jurors live in a subdirectory so the top-level `roles/` index reads as the set of orchestrator-dispatchable roles.
- `roles/COMMON.md`: standing instructions every dispatched subagent reads first.
- `skills/<skill>/SKILL.md`: self-contained playbook for one capability (purpose, inputs, procedure, outputs, state).
- `journal/`: a git worktree of this repo on the orphan branch `journal`. Holds the garden's transcript and acts as the **two-channel message bus** between agents: a per-role inbox (`journal/inboxes/<host>/<role>.md`; drained via `skills/inbox-drain/SKILL.md`) for directed communication, and a **job board** (`journal/jobs/`; contract at [`journal/jobs/README.md`](journal/jobs/README.md); skill at [`skills/job-board/SKILL.md`](skills/job-board/SKILL.md)) for work items that any eligible consumer can race to claim via git push as the serialization point. See [WORKTREES.md](WORKTREES.md) for the worktree shapes.
- `worktrees/<owner>-<repo>.git/`: bare clones of upstream forks.
- `worktrees/<owner>-<repo>/<name>/`: fork worktrees the garden is currently working in. Naming and lifecycle in [WORKTREES.md](WORKTREES.md).
- `scripts/`: executable shell scripts for humans and systemd. Holds the per-feed activity watchers (`scripts/watcher/<feed>/`), the daemon-management wrappers (`scripts/daemons/`), the job-system logic (`scripts/jobs/`), and the templated systemd user units (`scripts/systemd/`). The split is strict: `roles/` and `skills/` hold no executables; `scripts/` holds no agent-only context fragments.
- `references/`: read-only shelves of roles and skills imported from other gardens. Browsed by the liaison when a user prompt has no obvious fit in the active library, never auto-loaded by subagents. See [references/README.md](references/README.md).

Files are named `AGENT.md` / `SKILL.md` / `COMMON.md` (not `CLAUDE.md`) on purpose: we do **not** want Claude Code to auto-load them into a subagent's context. They are loaded explicitly by the dispatched subagent.

## Dispatch contract

The liaison and steward dispatch subagents via the `Agent` tool. Every subagent gets its own per-dispatch worktree triple (a detached `garden/`, a detached `journal/`, and optionally a detached `project/`) under `dispatches/<role>--<short-id>/`. The triple is created by `skills/dispatch-worktree/dispatch-prepare.sh` immediately before the `Agent` invocation and torn down by `skills/dispatch-worktree/dispatch-teardown.sh` when the subagent returns. The directory name is kept short so deep project paths (UNIX sockets, build artifacts) stay within OS path limits; the full role / purpose / timestamp metadata lives in the matching `dispatch` journal entry. See [WORKTREES.md](WORKTREES.md) § Per-dispatch worktree triple for the full lifecycle and [skills/dispatch-worktree/SKILL.md](skills/dispatch-worktree/SKILL.md) for the procedural detail.

Work reaches the steward (or a gardener via its role-specific job board) through one of two routes:

- **Job-board claim** (the 2026-05-18 default for work items). A producer posts a job to `journal/jobs/open/` via `skills/job-board/post-job.sh`; eligible consumers race to claim via `skills/job-board/claim-job.sh`. The git push to `origin/journal` is the serialization point; rejected claims back off without retry. Concurrent stewards across hosts and within one host are both honored. See [`journal/jobs/README.md`](journal/jobs/README.md) for the contract and [`skills/job-board/SKILL.md`](skills/job-board/SKILL.md) for the procedure.
- **Direct dispatch via `Agent`** (still the right shape for in-session liaison work and per-cycle steward scans). The liaison or steward prepares the worktree triple, writes a `dispatch` journal entry, invokes `Agent`, writes the `result`, and tears the dispatch root down.

The first route is producer-consumer (any eligible consumer claims) and survives `/clear` of the consumer between jobs because the per-job substance never enters the consumer's parent context. The second route is direct (the orchestrator runs the dispatch itself) and stays the right shape for the orchestrator's own per-cycle work.

The orchestrator's job per dispatch:

1. `DISPATCH_ROOT=$(skills/dispatch-worktree/dispatch-prepare.sh <role> <purpose-slug> [<owner>/<repo> <branch>])`.
2. Write a `dispatch` journal entry naming the role, repo (when applicable), task, `DISPATCH_ROOT`, and the model tier the dispatch will use (per `skills/model-selection/SKILL.md`, recorded as a `model:` field on the dispatch entry's frontmatter).
3. Invoke `Agent` with a prompt that names `DISPATCH_ROOT` explicitly, and pass the model tier from `skills/model-selection/SKILL.md` as the `model` parameter (the standing policy pins `designer` to Fable and `builder` to the latest Opus; every other role rides the fleet default. The same skill is the canonical map the scripted-fleet path follows via `role_default_model`/`resolve_model_tier` in `scripts/jobs/common.sh`, so the choice does not drift between the two paths).
4. On return, write a `result` journal entry and `skills/dispatch-worktree/dispatch-teardown.sh "$DISPATCH_ROOT"`.

The dispatch prompt itself should:

1. Name the role.
2. Name `DISPATCH_ROOT` (absolute, under `<garden-root>/dispatches/...`).
3. Name the upstream repo (`owner/name`) when applicable.
4. State the task in one or two sentences.
5. Tell the subagent to read `garden/roles/COMMON.md` and then `garden/roles/<role>/AGENT.md` (or `garden/roles/jurors/<seat>/AGENT.md` for a jury seat) first, and to load skills only on demand.

Roles never inline skill bodies; they reference them by path. Skills are read just-in-time. The orchestrator rarely reads a skill body; it trusts the role to know which playbook to consult.

### Dispatch prompt template

```
You are a subagent operating as role=<role>
in dispatch-root=<absolute path>, repo=<owner/name>.

Your dispatch root contains a worktree triple:
  garden/   — detached worktree of garden's dev branch, main2 (read roles/skills here)
  journal/  — detached worktree of garden's journal branch, journal2 (write entries here)
  project/  — (when applicable) detached worktree of <owner/name> at <branch>

Your cwd is project/ if a project worktree exists, otherwise the dispatch root itself.

Read these in order, then act:
  1. garden/roles/COMMON.md                                            (standing instructions)
  2. garden/roles/<role>/AGENT.md, or
     garden/roles/jurors/<seat>/AGENT.md for a jury seat                (your role)
  3. skills referenced by your role, only as you need them.

Commit and push in detached-HEAD style: `git push origin HEAD:<branch>`.

Task: <one or two sentences>.
Report: <what to return to the orchestrator>. The orchestrator tears down your dispatch root on return.
```

For long-lived monitoring or recurring work, dispatch via `/loop` or a cron routine; each invocation receives a fresh dispatch root, runs one tick, and exits. Standing state that must survive across ticks (bash poll daemons' ETag and last-seen-id caches) lives outside the dispatch root, in the long-lived standing worktrees documented in WORKTREES.md § Standing exceptions. Every tick that journals is still recorded in the journal.

### Orchestrator vocabulary

The maintainer speaks to the orchestrators (liaison and steward) in shorthand. The full categorized tables live on the role files (`roles/liaison/AGENT.md` § Vocabulary and `roles/steward/AGENT.md` § Vocabulary). The glossary below names the most common direct-dispatch verbs and the one compound chain idiom both orchestrators honor.

| Phrase                                                          | What it means                                                                                                                  |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **the gamut** / **run the gamut on #N**                         | the PR-creation-flow chain end to end (`skills/pr-creation-flow/SKILL.md`). Reads PR #N's next-stage-owed and dispatches the chain's stages sequentially until termination (judge un-drafts). The liaison runs the gamut in one engagement; the steward's per-cycle PR-creation-flow scan is the autonomous form. |
| **ferry #N** (canonical) / **carry #N upstream**                | dispatch [boatman](roles/boatman/AGENT.md). Requires `identity_switch_authorized: true`. *Ferry* is the maintainer's preferred verb (reaffirmed 2026-05-14). |
| **shepherd #N**                                                 | dispatch [shepherd](roles/shepherd/AGENT.md) to drive CI to green.                                                              |
| **judge #N** / **panel #N**                                     | dispatch [judge](roles/judge/AGENT.md) (panel + fixer-loop; un-drafts on termination).                                          |
| **build #N**                                                    | dispatch [builder](roles/builder/AGENT.md).                                                                                     |
| **probe #N**                                                    | dispatch [builder](roles/builder/AGENT.md) under [`skills/gap-revealing-build/SKILL.md`](skills/gap-revealing-build/SKILL.md). Deliverable is a structured gap report on a tentative design; PR opens DRAFT and stays draft (no cleaner / judge / fixer / un-draft chain follows). Distinct from *build #N* (mergeable feature PR running the full gamut). |
| **design X** / **propose X** / **spec X**                       | dispatch [designer](roles/designer/AGENT.md).                                                                                   |
| **fix #N**                                                      | dispatch [fixer](roles/fixer/AGENT.md).                                                                                         |
| **retcon #N**                                                   | dispatch [fixer](roles/fixer/AGENT.md) to reset branch + restage per-package, separate `chore: Update yarn.lock`, implementation+tests combined; net diff invariant ([`skills/retcon/SKILL.md`](skills/retcon/SKILL.md)). |
| **weave #N** / **rebase #N**                                    | dispatch [weaver](roles/weaver/AGENT.md).                                                                                       |
| **merge #N**                                                    | dispatch [conductor](roles/conductor/AGENT.md).                                                                                 |

The role files carry the full table including compound chain idioms (*mirror #N*, *carry feedback from #N*, *wrap up #N*, *retcon and ferry #N*), garden-meta phrases (*encode this*, *carve a role for X*; liaison-only), bulletin and journal phrases (liaison-only), authorization shapes (liaison-only), and negation patterns (*don't X*, *never X*; both orchestrators).

### Boatman dispatches and host preconditions

Boatman dispatches must be issued from the host that holds the kriskowal credentials (`kmkmbp2021` as of 2026-05-14). A liaison on `endolinbot` refuses to originate a boatman dispatch and asks the user to re-issue from the credentialed host; the bot identity does not have kriskowal credentials and cannot ferry upstream. The boatman's own *Host preconditions* norm (`roles/boatman/AGENT.md` § Operating norms) is the second line of defense: a boatman that finds itself on the wrong host stops at the precondition check and surfaces the gap rather than pushing under the bot identity. See `journal/projects/endo/README.md` § Identity and credentials for where the credentials live and why; widening the bot host's blast radius by landing kriskowal credentials there is a separate decision with security implications.

## Adding a role

Create `roles/<name>/AGENT.md`. Sections: purpose (one line), skills (linked list), operating norms, definition of done. Role files do not repeat anything in `roles/COMMON.md`.

## Adding a skill

Create `skills/<name>/SKILL.md`. Sections: purpose, inputs, state (if any), procedure, output shape, notes.

## Conventions

- **No PR workflows for the garden's own repo.** The garden is a meta library, not application code. Both `main` and `journal` are pushed directly to `origin` (`github.com/kriskowal/garden`); we do not generally open pull requests against ourselves. PR workflows are reserved for fork worktrees of *other* repos, where the [boatman](roles/boatman/AGENT.md) ferries work upstream.
- The `journal` branch is orphan; it never merges with `main`, and PR comparisons against `main` are meaningless. GitHub will sometimes offer a "create PR for journal" link after a push; ignore it.

## Host environment

The garden lives in the bot user's home directory; that directory is what `<garden-root>` refers to throughout this document and the dispatch template. Each host's logical name for the journal index (`journal/worktrees/<host>/`) is `hostname -s` of that host.

Each host configures its bot identity once in the garden repo's local git config:

```sh
git -C <garden-root> config user.name  <bot-login>     # e.g. kriscendobot, endolinbot
git -C <garden-root> config user.email <bot-email>
```

`skills/dispatch-worktree/dispatch-prepare.sh` reads those values and pins them into each dispatch sub-worktree's local config so subagent commits cannot drift to the parent shell's global identity (which on a maintainer's host is the maintainer's name, reserved for upstream pushes via the boatman). The boatman overrides the pin at commit time when its dispatch carries `identity_switch_authorized: true`; every other role's commits carry the bot identity.

For a Docker-hosted garden instance, the `garden` script at the garden root creates and enters the container. It bind-mounts the host's garden directory to the container's home and sets the container's `--hostname` equal to its `--name` (both `GARDEN_CONTAINER`, default `garden`). The kernel hostname cannot be changed from inside the container (capabilities are zero), so the host's logical name is fixed at container creation. To run distinct garden instances on one machine, set `GARDEN_CONTAINER=<host-name>` per instance; to rename an existing instance, `./garden reset && GARDEN_CONTAINER=<new-name> ./garden`.

## Monitoring safety constraint

Standing-monitor daemons feed event bodies, comment text, and pull-request descriptions into the LLM's context on every wake. Only repositories whose comments and pull requests are gated against untrusted contributors are safe to monitor; anything else exposes the steward and its subordinates to text that an untrusted actor can write, which is a prompt-injection hazard for any role that reads a daemon tail or follows a `NEW` line to its source. As of 2026-05-13 only `endojs/endo-but-for-bots` meets this bar in the garden's active set, and the review-queue daemon (which polls kriskowal's pending-review set against trusted GitHub state, not arbitrary repo bodies) is safe by construction. Re-enabling another monitor requires explicit maintainer authorization recorded in a journal `message` entry, after which the role-author (typically the gardener) lands the standing-monitor row in `roles/steward/AGENT.md` and the dormant-banner removal in the per-project skill. This is a standing constraint, not a one-time decision; the gardener and any future role-author respects it on every dispatch that touches monitoring.

The constraint covers both **event-level** surveillance (the standing-monitor daemons whose `NEW` lines surface in the steward's daemon-log tail Monitor) and **content-level** surveillance (the parent-context @-mention Monitor per `skills/at-mention-surveillance/SKILL.md`, which scans comment bodies on the same set of safe-to-monitor repos). Both surfaces pull external text into the LLM's context; widening either to a new repo follows the same maintainer-authorization shape.

**Sender-gated exception — the GitHub-wide @-mention watcher.** `scripts/jobs/mention-watcher.sh` (single instance, `garden-mention-watcher`) watches **all of GitHub** for @kriscendobot mentions, which the repo-gating rule above cannot cover. It is safe GitHub-wide only because of a substitute defense: a **deterministic sender-trust gate** that runs in plain code with **no LLM, before any mention text reaches a job, a reactji, or `claude -p`**. A mention is dropped unless its author is on the journal allowlist (`trusted-senders/allowlist`) or a current member of the **endojs**/**Agoric** org (read-only `gh api orgs/<org>/members/<login>` check). Untrusted senders are logged and discarded, never triaged. This is the maintainer-authorized widening recorded in a journal `message` entry the day it was armed; the sender-trust gate, not repo-gating, is the prompt-injection defense. Confirming a sender is an Agoric contributor is a read-only trust check and does **not** authorize any upstream interaction with `agoric/agoric-sdk` (comments, reviews, issue/PR opens or closes, or issue/PR links). Experimentation on the `kriscendobot/agoric-sdk` fork is permitted (maintainer directive, 2026-06-28, issue #9; see `roles/COMMON.md` § External-repo etiquette, *Project scope: agoric/agoric-sdk*); upstream `agoric/agoric-sdk` stays comment-and-link-free.

**Sender-gated exception — the issue inbox.** `scripts/jobs/issue-inbox-watcher.sh` (single instance, `garden-issue-inbox`) watches the garden's **own** GitHub repo's **issues + issue-comments** so a maintainer can drive the garden by filing/commenting on an issue and get replies as issue comments. The garden's repo is public, so repo-gating cannot make it safe; the defense is the same shape as the @-mention watcher's — a **deterministic maintainer-trust gate** that runs in plain code with **no LLM, before any issue/comment text reaches a job, a message, or `claude -p`**. The gate here is **stricter**: **allowlist-only, no org-membership fallback** (driving the garden is more powerful than commenting on a watched PR). An issue/comment is dropped unless its author is in the journal `maintainers/allowlist`. The watched repo (`config/garden-repo`) and the maintainer set are **per-instance journal state**, and the watcher is **inert** until both exist — so writing them (`set-garden-repo.sh` / `add-maintainer.sh`) is the deliberate per-instance arming act, and enabling the unit is harmless. This request is the maintainer-authorized widening, recorded in a journal `message` entry the day it was armed. Design: [`designs/issue-inbox.md`](designs/issue-inbox.md); consumer contract: [`skills/issue-inbox/SKILL.md`](skills/issue-inbox/SKILL.md).

## Current inventory

- Roles: `liaison`, `steward`, `monitor`, `review-queue`, `boatman`, `researcher`, `builder`, `assayer`, `cleaner`, `solicitor`, `barrister`, `justice`, `appellate`, `fixer`, `weaver`, `shepherd`, `conductor`, `designer`, `web-designer`, `web-builder`, `scout`, `botanist`, `major-general`, `gardener`, `orchestrator`, `evaluator`, `groom`, `investigator`, `journalist`, `librarian`, `scholar`, `timekeeper`. The `orchestrator` (added 2026-07-02) is the multi-part-job decomposition posture: a producer parks ordered child sub-jobs (gate `orchestrated`) and records one orchestration job; the deterministic `orchestrate.sh` watcher sequences the children into `todo/` (serial default | parallel) and watches them to completion, applying a halt/continue failure policy. See § Orchestrating a multi-part job and `skills/orchestration/SKILL.md`. The `web-designer` and `web-builder` (added 2026-06-28, issue #12) are the web-frontend variants of `designer` / `builder`, chosen by the triager (or the panel's kind discrimination) when a job's nature is web frontend; see `roles/triager/AGENT.md` § Web-frontend variant selection. The prior `general-contractor` posture was retired 2026-06-03 per the maintainer's directive ("I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver."); its design-queue-walk + slot-refill function is reconstructed as a deterministic design-queue poller per `skills/design-poller/SKILL.md`, which posts jobs that the gardener pool claims. The `researcher` (added 2026-06-03) precedes every designer and builder dispatch by default: orchestrators (liaison, steward) dispatch it with the proposed downstream prompt, inline its `## Library and project references` section, and only then dispatch the actual designer or builder. See each orchestrator's *Researcher precedence on designer and builder dispatches* section. The prior single `judge` role split into three on 2026-05-21: `solicitor` (designer work; design panel), `barrister` (builder work; first code-panel round), `justice` (fixer work; code-panel re-runs); `roles/judge/AGENT.md` is retained as a redirect. The `appellate` lands the same day to appeal `follow-up` and `acknowledge` dispositions on small-and-in-context items into `summary-fix` before un-draft. Plus the jury-seat roles dispatched by the three judges: a code panel for source-touching PRs and a design panel for design-only PRs (paths under `<project>/designs/`). See each judge's role file under `roles/<solicitor|barrister|justice>/AGENT.md` for the panel composition; the orchestrator never dispatches a juror seat directly.
- Skills: `journal-sync`, `self-improvement`, `em-dash-style`, `relative-paths`, `no-latin-shorthand`, `agent-termination`, `rule-elision-test`, `inbox-drain`, `autonomous-loop-pacing`, `github-activity-poll`, `pr-ci-watch`, `review-queue-poll`, `rebase-before-followup`, `review-feedback-followup-commits`, `pr-review-thread-replies`, `pr-completion-summary-comment`, `pr-formation`, `pr-handoff`, `pr-creation-flow`, `pr-dependency-graph`, `pr-dependency-topo-sort`, `yarn-lock-separate-commit`, `pre-pr-checklist`, `regression-evidence`, `coverage-driven-testing`, `adversarial-tests`, `saboteur-adversarial-review`, `panel-review`, `ci-status-summary`, `ci-runtime-comparison`, `conflict-resolution`, `cherry-pick-followup`, `rebase-hygiene-audit`, `worktree-per-pr`, `process-documents`, `prompt-section-discovery`, `benchmark-comparative-report`, `verify-upstream-state-before-pinning`, `reactji-acknowledgment`, `changeset-discipline`, `rename-discipline`, `monitor-arming`, `context-library`, `journalism`, `dispatch-worktree`, `scheduling`, `velocity-recalibration`, `roadmap-projection`, `dependency-graph-maintenance`, `groom-open-questions`, `design-queue-drift-check`, `design-to-pr-pipeline`, `garden-ab-evaluation`, `merged-pr-feedback-watch`, `library-lookup`, `retcon`, `design-dependency-walk`, `stacked-pr-build`, `gap-revealing-build`, `at-mention-surveillance`, `job-board`, `issue-inbox`, `pre-push-gates`, `node-lts-window-watch`, `panel-hints`, `frozen-base-branch`, `node-parity-test`, `test-title-spec-spelling`, `no-comment-banners`, `design-poller`, `model-selection`, `cleaner`, `gardener-inbox-error-reporting`, `prompt-on-failure-capture`, `activity-feed-watcher`, `ci-failure-classification-loop`, `local-verify`, `emoji-favicon`, `css-intrinsic-and-content-sizing`, `supports-feature-query-progressive-enhancement`, `css-design-tokens-and-theming`, `css-anchor-positioning-and-flip-fallbacks`, `native-customizable-form-control-styling`, `agoric-chain-snapshot`, `orchestration`, `xs-debugging`, `slog-debugging`. The `xs-debugging` and `slog-debugging` skills (added 2026-07-03, issue #22) roll the kriskowal/garden#9 discoveries up as reusable debugging methodology: `xs-debugging` is the cross-project XS engine envelope (value-stack width-not-depth overflow diagnosis, symbolicating a native crash into JS frames, the targeted `flatMap`->loop rewrite versus the coarse taller-`stackCount` lever with its lockstep-cutover determinism constraint), spanning both agoric-sdk (the swingset xsnap worker) and endojs (endo's XS builds and the `xs2rust-endor` port); `slog-debugging` is the swingset slog / flight-recorder reading procedure (preserve `flight-recorder.bin` before teardown, grep the `Stack meter exceeded` / `#error` / exit-12 delivery record, anchor to the failing delivery). Both are reached through the new **fixer sub-roles** (`roles/fixer/subroles/{agoric-sdk,endojs}.md`, selection contract in `roles/fixer/subroles/README.md`): a sub-role is an additive, project-keyed specialization the base fixer reads *in addition to* its brief when the job's repo matches, grouping its skills by dimension (the first dimension being debugging). The `orchestration` skill (added 2026-07-02) is the multi-part-job decomposition pattern: park ordered child sub-jobs (gate `orchestrated`, via `post-plan.sh --orchestrated`), record one orchestration (`post-orchestration.sh`), and let the deterministic `orchestrate.sh` watcher sequence the children into `todo/` (serial default | parallel) and watch them to completion with a halt/continue failure policy; built on the same promote-when-the-board-reaches-a-state substrate as `blocked_on`/`unblock.sh`. The `agoric-chain-snapshot` skill (added 2026-06-30, job `kriskowal-garden-pr9-469d82c6`) is the procedure for capturing a real Agoric mainnet swing-store (via `scripts/agoric/fetch-polkachu-snapshot.sh`, with a gitignored per-host cache, a `provenance.json` sidecar, and a multi-host socialization path) and feeding it to inquisitor to reproduce and verify the `hex.js` `flatMap`->loop fix for the ymax0 v320 70->71 XS value-stack overflow on kriskowal/garden#9; its § *Installing the bundle first* records the mainnet-validation-tree (`a3p-integration/`) bundle-publishing examples (`MsgInstallBundle` via `@agoric/client-utils` `installBundle`, the `g:ymax1` contract-control proposal, and `contract-control.contract.js` `install`/`upgrade`) and maps the on-chain publish->install->contract-control-upgrade sequence onto the inquisitor offline repro. The `emoji-favicon` skill (added 2026-06-28, issue #12) is the asset-free emoji-as-favicon web-design technique used by the `web-designer` / `web-builder` roles. The five `css-*` / `supports-*` / `native-*` web-frontend skills (the first three added 2026-06-29, job `author-web-designer-css-skills`; `css-anchor-positioning-and-flip-fallbacks`, added 2026-06-29, job `author-css-anchor-positioning-and-flip-fallbacks`; `native-customizable-form-control-styling`, added 2026-06-29, job `author-native-customizable-form-control-styling-skill`) are the web-frontend techniques used by the same roles: `calc-size()` intrinsic-size clamping, `@supports` progressive enhancement, `:root` design-token theming, `anchor()`/`position-area`/`position-try-fallbacks` popover anchoring with `flip-*` overflow fallbacks, and styling the native `<select>` via `appearance: base-select` and its part pseudo-elements (over a `<div>`/JS widget, behind an `@supports` classic-select fallback), authored from scholar proposals grounded in the `web--goldilocks-select-height` essay, the MDN/CSSWG anchor-positioning references, the MDN customizable-select guide, and the garden's own chat color-schemes design. Per-project monitor reaction skills (`monitor-endo`, `monitor-endo-but-for-bots`, `monitor-agoric-sdk`, `monitor-cosgov`, `monitor-garden`) live alongside but are configuration for the `monitor` role rather than independently reusable procedures. `monitor-garden` is the only one whose dispatched subagent runs as `liaison` rather than `monitor`; see that skill's *Dispatch role asymmetry* for why.

The `liaison` and `steward` are the two top-level orchestrator postures. When a user is in the loop (this terminal session), the liaison runs with excess authority and asks before acting. When the garden runs in the bot sandbox under safe bot credentials with no user present, the steward runs with bounded authority and may act on its own. Multiple stewards can run concurrently across hosts (and even within one host) and share work load via the journal's job board (`journal/jobs/`); the claim race resolves contention without a dedicated peer-role posture. Focused, parallelized PR-pipeline work that used to live in the retired `general-contractor` posture is now scripted: a design-queue poller walks the project's roadmap branch on a cadence and posts `build` jobs to the role-specific board, and the gardener pool claims and advances them through the chain. The maintainer's framing on 2026-06-03: "I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver." (The driver was itself superseded by the v2 gardener fleet and removed 2026-06-29; see `designs/v1-migration-manifest.md`.) See `roles/liaison/AGENT.md` § Posture and `roles/steward/AGENT.md` § Posture for the two-posture contract.

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

Set-up (any producer — the liaison, a gardener, the steward posture):
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
