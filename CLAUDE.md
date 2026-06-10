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
- `scripts/`: executable shell scripts for humans and systemd. Holds the driver (`scripts/driver/`), the per-feed activity watchers (`scripts/watcher/<feed>/`), the daemon-management wrappers (`scripts/daemons/`), and the templated systemd user units (`scripts/systemd/`). The split is strict: `roles/` and `skills/` hold no executables; `scripts/` holds no agent-only context fragments. See [designs/driver.md](designs/driver.md) for the rationale.
- `references/`: read-only shelves of roles and skills imported from other gardens. Browsed by the liaison when a user prompt has no obvious fit in the active library, never auto-loaded by subagents. See [references/README.md](references/README.md).

Files are named `AGENT.md` / `SKILL.md` / `COMMON.md` (not `CLAUDE.md`) on purpose: we do **not** want Claude Code to auto-load them into a subagent's context. They are loaded explicitly by the dispatched subagent.

## Dispatch contract

The liaison and steward dispatch subagents via the `Agent` tool. Every subagent gets its own per-dispatch worktree triple (a detached `garden/`, a detached `journal/`, and optionally a detached `project/`) under `dispatches/<role>--<short-id>/`. The triple is created by `skills/dispatch-worktree/dispatch-prepare.sh` immediately before the `Agent` invocation and torn down by `skills/dispatch-worktree/dispatch-teardown.sh` when the subagent returns. The directory name is kept short so deep project paths (UNIX sockets, build artifacts) stay within OS path limits; the full role / purpose / timestamp metadata lives in the matching `dispatch` journal entry. See [WORKTREES.md](WORKTREES.md) § Per-dispatch worktree triple for the full lifecycle and [skills/dispatch-worktree/SKILL.md](skills/dispatch-worktree/SKILL.md) for the procedural detail.

Work reaches the steward (or a driver lane via its role-specific job board) through one of two routes:

- **Job-board claim** (the 2026-05-18 default for work items). A producer posts a job to `journal/jobs/open/` via `skills/job-board/post-job.sh`; eligible consumers race to claim via `skills/job-board/claim-job.sh`. The git push to `origin/journal` is the serialization point; rejected claims back off without retry. Concurrent stewards across hosts and within one host are both honored. See [`journal/jobs/README.md`](journal/jobs/README.md) for the contract and [`skills/job-board/SKILL.md`](skills/job-board/SKILL.md) for the procedure.
- **Direct dispatch via `Agent`** (still the right shape for in-session liaison work and per-cycle steward scans). The liaison or steward prepares the worktree triple, writes a `dispatch` journal entry, invokes `Agent`, writes the `result`, and tears the dispatch root down.

The first route is producer-consumer (any eligible consumer claims) and survives `/clear` of the consumer between jobs because the per-job substance never enters the consumer's parent context. The second route is direct (the orchestrator runs the dispatch itself) and stays the right shape for the orchestrator's own per-cycle work.

The orchestrator's job per dispatch:

1. `DISPATCH_ROOT=$(skills/dispatch-worktree/dispatch-prepare.sh <role> <purpose-slug> [<owner>/<repo> <branch>])`.
2. Write a `dispatch` journal entry naming the role, repo (when applicable), task, `DISPATCH_ROOT`, and the model tier the dispatch will use (per `skills/model-selection/SKILL.md`, recorded as a `model:` field on the dispatch entry's frontmatter).
3. Invoke `Agent` with a prompt that names `DISPATCH_ROOT` explicitly, and pass the model tier from `skills/model-selection/SKILL.md` as the `model` parameter (the model that is adequate to the task; the table makes the choice canonical so it does not drift across thirty-plus role files).
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
  garden/   — detached worktree of garden's main branch (read roles/skills here)
  journal/  — detached worktree of garden's journal branch (write entries here)
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

## Current inventory

- Roles: `liaison`, `steward`, `monitor`, `review-queue`, `boatman`, `researcher`, `builder`, `assayer`, `cleaner`, `solicitor`, `barrister`, `justice`, `appellate`, `fixer`, `weaver`, `shepherd`, `conductor`, `designer`, `scout`, `botanist`, `major-general`, `gardener`, `evaluator`, `groom`, `investigator`, `journalist`, `librarian`, `scholar`, `timekeeper`. The prior `general-contractor` posture was retired 2026-06-03 per the maintainer's directive ("I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver."); its design-queue-walk + slot-refill function is reconstructed as a deterministic `garden-design-poller` systemd service per `skills/design-poller/SKILL.md`, which posts jobs that driver lanes claim. The `researcher` (added 2026-06-03) precedes every designer and builder dispatch by default: orchestrators (liaison, steward) dispatch it with the proposed downstream prompt, inline its `## Library and project references` section, and only then dispatch the actual designer or builder. See each orchestrator's *Researcher precedence on designer and builder dispatches* section. The prior single `judge` role split into three on 2026-05-21: `solicitor` (designer work; design panel), `barrister` (builder work; first code-panel round), `justice` (fixer work; code-panel re-runs); `roles/judge/AGENT.md` is retained as a redirect. The `appellate` lands the same day to appeal `follow-up` and `acknowledge` dispositions on small-and-in-context items into `summary-fix` before un-draft. Plus the jury-seat roles dispatched by the three judges: a code panel for source-touching PRs and a design panel for design-only PRs (paths under `<project>/designs/`). See each judge's role file under `roles/<solicitor|barrister|justice>/AGENT.md` for the panel composition; the orchestrator never dispatches a juror seat directly.
- Skills: `journal-sync`, `self-improvement`, `em-dash-style`, `relative-paths`, `no-latin-shorthand`, `agent-termination`, `rule-elision-test`, `inbox-drain`, `autonomous-loop-pacing`, `github-activity-poll`, `pr-ci-watch`, `review-queue-poll`, `rebase-before-followup`, `review-feedback-followup-commits`, `pr-review-thread-replies`, `pr-formation`, `pr-handoff`, `pr-creation-flow`, `pr-dependency-graph`, `pr-dependency-topo-sort`, `yarn-lock-separate-commit`, `pre-pr-checklist`, `regression-evidence`, `coverage-driven-testing`, `adversarial-tests`, `saboteur-adversarial-review`, `panel-review`, `ci-status-summary`, `ci-runtime-comparison`, `conflict-resolution`, `cherry-pick-followup`, `rebase-hygiene-audit`, `worktree-per-pr`, `process-documents`, `prompt-section-discovery`, `benchmark-comparative-report`, `verify-upstream-state-before-pinning`, `reactji-acknowledgment`, `changeset-discipline`, `rename-discipline`, `monitor-arming`, `context-library`, `journalism`, `dispatch-worktree`, `scheduling`, `velocity-recalibration`, `roadmap-projection`, `dependency-graph-maintenance`, `groom-open-questions`, `design-queue-drift-check`, `design-to-pr-pipeline`, `garden-ab-evaluation`, `merged-pr-feedback-watch`, `library-lookup`, `retcon`, `design-dependency-walk`, `stacked-pr-build`, `gap-revealing-build`, `at-mention-surveillance`, `job-board`, `pre-push-gates`, `node-lts-window-watch`, `panel-hints`, `frozen-base-branch`, `node-parity-test`, `test-title-spec-spelling`, `design-poller`, `model-selection`, `cleaner`, `gardener-inbox-error-reporting`, `driver-pr-creation-state-machine`, `driver-design-only-pr-workflow`, `driver-gardener-workflow`, `driver-librarian-workflow`, `prompt-on-failure-capture`, `activity-feed-watcher`. The driver workflow skills are the script-orchestrated PR-creation flow's agent context (per [designs/driver.md](designs/driver.md)); the executable counterparts live under `scripts/`. The `driver-gardener-workflow` and `driver-librarian-workflow` skills (added 2026-06-04) extend the driver pool to non-PR roles via role-prefixed lanes (`gardener-1`, `librarian-1`, etc.) per `designs/driver.md` § Role-prefixed lanes. Per-project monitor reaction skills (`monitor-endo`, `monitor-endo-but-for-bots`, `monitor-agoric-sdk`, `monitor-cosgov`, `monitor-garden`) live alongside but are configuration for the `monitor` role rather than independently reusable procedures. `monitor-garden` is the only one whose dispatched subagent runs as `liaison` rather than `monitor`; see that skill's *Dispatch role asymmetry* for why.

The `liaison` and `steward` are the two top-level orchestrator postures. When a user is in the loop (this terminal session), the liaison runs with excess authority and asks before acting. When the garden runs in the bot sandbox under safe bot credentials with no user present, the steward runs with bounded authority and may act on its own. Multiple stewards can run concurrently across hosts (and even within one host) and share work load via the journal's job board (`journal/jobs/`); the claim race resolves contention without a dedicated peer-role posture. Focused, parallelized PR-pipeline work that used to live in the retired `general-contractor` posture is now scripted: the `garden-design-poller` systemd service (per `skills/design-poller/SKILL.md`) walks the project's roadmap branch on a cadence and posts `build` jobs to the role-specific board, and driver lanes (per `designs/driver.md`) claim and advance them through the chain. The maintainer's framing on 2026-06-03: "I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver." See `roles/liaison/AGENT.md` § Posture and `roles/steward/AGENT.md` § Posture for the two-posture contract.
