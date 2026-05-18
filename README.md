# Garden

A library of agent **roles** and **skills** for working across many forks of GitHub repositories, plus a **journal** that records what the garden has done.

## The journal

The journal lives on the orphan `journal` branch of this repo. It is the garden's transcript and message bus, append-only and machine-readable.

**[Browse the journal on GitHub](https://github.com/kriskowal/garden/tree/journal)**

The journal's [`README.md`](https://github.com/kriskowal/garden/blob/journal/README.md) is the maintainer dashboard: a bulletin board for items that need a human's attention plus a summary of ongoing work. Agents post and clear bulletin items as conditions arise and resolve; the maintainer reads the dashboard and acts in the upstream system.

## Layout

- [`roles/<role>/AGENT.md`](./roles/) — operating brief for one role. Each role file lists which skills it uses and any role-specific norms.
- [`skills/<skill>/SKILL.md`](./skills/) — self-contained playbooks for individual capabilities (purpose, inputs, procedure, outputs, state).
- [`CLAUDE.md`](./CLAUDE.md) — the garden's top-level orientation: layout, the dispatch contract, and a current inventory of roles and skills.
- [`WORKTREES.md`](./WORKTREES.md) — worktree lifecycle: the standing journal worktree, fork worktrees, and the per-dispatch worktree triple every subagent runs in.
- [`references/<source>/`](./references/) — read-only shelves of roles and skills imported from other gardens, browsed when no active role fits a new request.

Role and skill files use `AGENT.md` / `SKILL.md` / `COMMON.md` naming on purpose: Claude Code only auto-loads `CLAUDE.md`, so the root `CLAUDE.md` orients the orchestrator while role and skill files stay out of the auto-loaded set — each dispatched subagent reads only the files its role brief explicitly names.

## Design

### Roles and skills

A **role** is an actor's brief: what posture it runs in, what it is allowed to touch, what counts as done. The current set spans orchestrators (liaison, steward), per-PR roles (builder, cleaner, judge, the twelve juror seats, fixer, weaver, boatman, conductor), per-task roles (designer, scout, scholar, journalist, gardener, evaluator, others), and standing watchers (monitor, review-queue, timekeeper). Each role is one file; the role file is the only operating brief its subagent reads on dispatch.

A **skill** is a procedure: how to do a specific thing safely. Skills are reusable across roles. A role file says *I use `skills/pr-formation/SKILL.md` and `skills/changeset-discipline/SKILL.md`*; the skill body is the playbook. Splitting it this way means the rule for, say, how a changeset body should read is written once and cited from every role that authors one.

### Orchestrators and postures

Two top-level orchestrators dispatch every subagent:

- The **liaison** runs when a user is in the loop. It has excess authority because the user can intercept; it asks before taking hard-to-reverse actions. A typical liaison turn reads recent journal entries, drains its inbox, takes the user's direction, dispatches one or more subagents, and reports back.
- The **steward** runs in the bot sandbox under the bot identity with no user present. It has bounded authority: it advances work that is already authorized, drains its inbox, and surfaces anything it cannot act on as a bulletin item. The steward runs on a cycle (idle most of the time, active when there is work in the inbox or on the bulletin).

Both orchestrators share the same journal as memory. Multiple liaison instances can run concurrently on different hosts (one in a Docker container, one on a laptop) because they communicate exclusively through the journal as a message bus; no host has authoritative state the other lacks.

### The dispatch contract

Every subagent runs in a fresh per-dispatch worktree triple:

- `garden/` — detached worktree of the garden's `main` branch (reads role and skill files here).
- `journal/` — detached worktree of the garden's `journal` branch (writes its result and any inbox messages here).
- `project/` — when the work touches a forked repository, a detached worktree of that fork at the relevant branch.

The orchestrator prepares the triple, writes a `dispatch` journal entry naming the role and the dispatch root, invokes the `Agent` tool with a prompt that names the dispatch root explicitly, then tears the triple down on return after writing a `result` entry. Subagents commit and push in detached-HEAD style (`git push origin HEAD:<branch>`), which lets multiple dispatches push to the same upstream branch concurrently without competing for branch ownership. The full procedure lives in [`WORKTREES.md`](./WORKTREES.md) and [`skills/dispatch-worktree/SKILL.md`](./skills/dispatch-worktree/SKILL.md).

### The journal as message bus

The journal is an orphan branch that never merges with `main`. Every dispatch, result, message, and tick is a single markdown file under `journal/entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-<kind>-<role>-<short-id>.md` with YAML frontmatter that names the role, kind, and (for messages) the addressee. Subagents address each other and the orchestrator via `to:` in the frontmatter; a tiny inbox-drain monitor running at the orchestrator surfaces new entries on each cycle.

The journal's [`README.md`](https://github.com/kriskowal/garden/blob/journal/README.md) is the bulletin board: agents post rows when conditions surface (a PR needs a maintainer's decision, a workflow is failing, a design draft is ready for review), and agents clear rows when the underlying condition resolves. The maintainer reads the bulletin, never edits it.

The journal also carries longer-lived material: per-project READMEs and topic files under `journal/projects/`, a curated cross-cutting library under `journal/library/` (the scholar's domain), draft designs awaiting maintainer triage under `journal/projects/<project>/drafts/`, and worktree indexes under `journal/worktrees/`.

### PR-creation flow

The canonical chain for a garden-authored pull request, per [`skills/pr-creation-flow/SKILL.md`](./skills/pr-creation-flow/SKILL.md), is:

```
builder → cleaner → judge → fixer (loop) → judge un-drafts
```

Each stage is its own dispatch. The **builder** opens a draft PR and writes the production change. The **cleaner** stands between builder and jury: coverage pass plus dead-code deletion, all in tests. The **judge** is the panel's foreperson — it dispatches a seventeen-seat jury concurrently (assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator), requests a Copilot review on the same PR, aggregates the individual reports into one verdict, and submits the formal `gh pr review`. If the verdict has must-fix items, the **fixer** addresses them on the same branch and the judge re-dispatches the panel; the loop repeats until the panel surfaces no further in-scope complaints. The judge un-drafts the PR when the loop terminates, putting it in the maintainer's review queue.

This chain runs on garden-authored drafts on the bot's own forks (primarily [`endojs/endo-but-for-bots`](https://github.com/endojs/endo-but-for-bots)). The **boatman** ferries finished work upstream when the maintainer authorizes it, force-pushing the linearized diff under the maintainer's own identity onto the corresponding upstream PR branch (typically on [`endojs/endo`](https://github.com/endojs/endo)). Cross-repo etiquette and per-action authorization are spelled out in [`roles/COMMON.md`](./roles/COMMON.md).

### Identities

The garden uses two GitHub identities:

- **`kriscendobot`** is the default. Routine work (fork-side branches, draft PRs, comments on the bot's own repo, lint fixes, coverage passes) all happen as the bot.
- **`kriskowal`** is the maintainer's primary. The garden uses it only for upstream pushes that need to land under the maintainer's own name; every such use requires `identity_switch_authorized: true` in the dispatch brief, which only the liaison can originate.

### Meta-evolution

The garden's own roles and skills evolve too. The **gardener** is the role that authors and revises files under `roles/` and `skills/`. The [`self-improvement`](./skills/self-improvement/SKILL.md) skill is the canonical procedure for when a lesson becomes a rule: a single observation becomes a *Note from the field* in an existing file; a pattern that recurs across engagements warrants a new rule, and possibly a new skill or role. The gardener runs only when the liaison dispatches it (meta-evolution is outside the steward's authority bounds). A standing duty added 2026-05-14: the gardener also watches merged PRs for patterns the maintainer's feedback flags repeatedly, then encodes them into the library so future builds and reviews avoid the same complaint.

The [`references/`](./references/) directory holds read-only shelves of roles and skills imported from other gardens; the liaison browses them when a user request has no obvious fit in the active library, and the gardener may adopt and adapt entries into the live set.

## Not application code

The garden contains no application code, only the artifacts that let orchestrating agents dispatch focused subagents into worktrees of other repositories. Both `main` and `journal` are pushed directly to `origin`; no PR workflows are used for the garden's own repo.
