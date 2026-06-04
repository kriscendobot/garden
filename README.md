# Garden

A library of agent **roles** and **skills** for working across many forks of GitHub repositories, plus a **journal** that records what the garden has done.

## A walkthrough for a new maintainer

The garden is built around a small number of maintainer touch points: you describe what you want, review what the bot produces, and approve when it's right. Between each touch point the garden runs a chain of dispatched agents automatically. The five steps below cover the canonical flow from "I have an idea" through "the implementation merged upstream." Each section names what you do, what prompt to use, and what the garden does between your interactions.

The walkthrough assumes you are working against `endojs/endo-but-for-bots` (the garden's primary project). Other projects have similar shapes; the per-project README under `journal/projects/<slug>/` calls out the differences.

### 0. Open a session in the garden root

Start a `claude` session with the garden root (this directory) as the working directory. The session enters the **liaison** posture by default — the user-in-the-loop orchestrator. Anything you type is the liaison's input.

```
$ cd ~/garden
$ claude
```

The liaison reads recent journal activity at session start so it knows the state of any in-flight PRs, the steward's most recent cycle, and the bulletin board. You do not need to brief the liaison on what has happened recently; it surfaces what is relevant.

### 1. Prompt the first design

You describe the idea you want a design for. Keep it short — one or two sentences naming the feature, the project area, and any constraints you already have in mind.

```
Please design a way for the daemon to serve weblet content from CAS.
```

What happens between your prompt and the design PR landing in your review queue:

1. The liaison composes the proposed designer dispatch prompt from your sentence, naming the project and the design slug it picks.
2. The liaison dispatches a **researcher** first (per the standing precedence rule). The researcher walks `journal/library/` and the project's existing designs and returns a `## Library and project references` section listing concept pages, source pages, and adjacent designs the designer should consult. The liaison inlines that section into the designer dispatch prompt before the next step. The researcher takes about one to three minutes.
3. The liaison dispatches a **designer**. The designer reads the curated references first, drafts a self-contained design document at `designs/<slug>.md` on the project's roadmap branch (today `llm` on `endojs/endo-but-for-bots`), and opens the design as a DRAFT pull request.
4. A **solicitor** (the design-panel judge) dispatches a seven-seat panel against the draft. The panel reviews and the solicitor aggregates findings into a formal PR review.
5. If the panel raises in-scope concerns, the fixer-on-design loop runs until the panel is clean. The **appellate** considers whether any deferred items should be promoted before un-drafting. The solicitor un-drafts the PR.
6. The bulletin row for the new design PR appears on the journal's [`README.md`](https://github.com/kriskowal/garden/blob/journal/README.md), in the *Pending kriskowal reviews* section. You will see the PR in your GitHub review queue.

You do not need to babysit the chain. Subsequent steps are triggered by the steward's per-cycle scan or the standing monitors; you can close your `claude` session and pick up later.

### 2. Provide design review

You review the design on GitHub. The pull request is on `endojs/endo-but-for-bots` (or whichever project the design targets); review on the GitHub web interface or via the `gh` CLI. Three review shapes are recognized:

- **Inline comments + COMMENTED review** with substantive asks. Phrases like *"please rename"*, *"I would like…"*, *"this should be"* are read as actionable.
- **CHANGES_REQUESTED review**. The standard "fix these things before I approve" shape.
- **Inline discussion** without a formal review submission. The garden surfaces these too; they read as "consider this" rather than "address before approval."

What happens between your review and the revised PR being ready for re-review:

1. A standing daemon polls the repo and surfaces your review as a `PullRequestReviewEvent` to the steward's Monitor within ~30 seconds.
2. The steward dispatches a **designer** with your inline comments inlined in the dispatch brief (per the *Maintainer-feedback response* discipline). The designer is the same role that drafted the design originally; the feedback shape is the same role applied to addressing comments.
3. The designer addresses each inline comment, posts threaded replies citing the addressing commit SHAs, updates the design document, and re-requests review.
4. The PR re-appears in your review queue with the new commits and the threaded replies.

You can loop on this as many times as the design needs. The steward owns this dispatch regardless of who originally opened the PR; you do not need to re-ask.

### 3. Approve the design

You click **Approve** on the GitHub PR.

What happens between your approval and the implementation PR landing in your review queue:

1. The steward's standing daemon surfaces the `APPROVED` state. The steward inspects CI; if green (or the only red is a known operational flake the steward has classified), it dispatches a **conductor**.
2. The conductor merges the PR onto the project's roadmap branch (today `llm` on `endojs/endo-but-for-bots`). The design is now part of the project's roadmap, queued for implementation.
3. The **design-poller** systemd service (per [`skills/design-poller/SKILL.md`](./skills/design-poller/SKILL.md)) walks the roadmap branch on a cadence, classifies the new design as *ready to build* via the eligibility filter, and posts a `build` job to the role-specific job board. (Today the steward's per-cycle design-to-PR-pipeline scan does this work; the poller is the deterministic-infrastructure replacement landing now.)
4. A **builder** dispatch is composed against the design. As with the designer, a **researcher** dispatch runs first and the references are inlined.
5. The builder drafts the implementation on a separate PR against the project's implementation branch (today `master` on the bot fork). The PR opens DRAFT.
6. The PR enters the source-touching chain: **cleaner** runs first (coverage pass, dead-code deletion, formatting), then **barrister** (the first-round code panel; twenty-six juror seats). Findings the panel marks as `must-fix-loop` go to a **fixer**; the fixer addresses, the **justice** re-runs the panel, the loop continues until the panel is clean. The **appellate** considers promotions; the panel's terminating judge un-drafts.
7. The implementation PR appears in your review queue.

The split between the design PR (on `llm`) and the implementation PR (on `master`, for the bot fork) is deliberate: the design records the agreed approach; the implementation lands the code. The two are reviewed and merged separately.

### 4. Provide implementation review

You review the implementation on GitHub, same shape as the design review. Inline comments, CHANGES_REQUESTED, or discussion all work.

What happens between your review and the revised implementation being ready for re-review:

1. The steward's Monitor surfaces your review.
2. The steward dispatches a **fixer** with your inline comments inlined (the source-touching analog of step 2's designer-with-feedback). The fixer is the canonical surgical-fix role: it addresses each comment, replies on the inline threads, and re-requests review.
3. If the fix's effect on CI is non-trivial, the steward dispatches a **shepherd** alongside the fixer to drive CI back to green. Known operational flakes are classified and re-run automatically; deeper issues escalate via the shepherd → fixer auto-chain.
4. The PR re-appears in your review queue.

As with design review, you can loop as many times as the implementation needs.

### 5. Approve implementation

You click **Approve** on the GitHub PR.

What happens between your approval and the work being merged (and, for forks, ferried upstream):

1. The steward sees `APPROVED` plus green CI and dispatches a **conductor**.
2. The conductor merges the PR onto the project's implementation branch. The work is now part of the project's bot-fork history.
3. For projects with an upstream you want to land on (e.g. `endojs/endo`), you say *"ferry #N"* or *"carry #N upstream"* in a `claude` session. This dispatches a **boatman** which switches identity to your primary (the garden's `kriskowal` identity), reshapes the commits per the upstream's convention, and force-pushes onto the upstream PR branch under your name. The upstream PR opens (or updates) with the work attributed to you. *Ferry* is the maintainer's preferred verb; see [`roles/boatman/AGENT.md`](./roles/boatman/AGENT.md) for the full procedure.
4. For projects without a separate upstream (e.g. the garden itself), the merge to the bot-fork branch is the terminal state.

You can pause at any point. The chain resumes wherever you left off the next time the steward's cycle fires or the next event from a standing monitor surfaces.

### Where to push back when the automation is wrong

The walkthrough above is the happy path. When the automation does the wrong thing, three escalations work:

- **Pause a specific lane.** Set `paused: true` on `journal/drivers/<host>/<lane>.md` to quiesce an autonomous lane (a future driver-pool feature; today the equivalent is to TaskStop the steward's session). The autonomous work stops; the bulletin still tracks what is pending.
- **Override a dispatch.** Tell the liaison in your session: *"don't dispatch X"*, *"close #N"*, *"that classification is wrong, please redo as Y."* The liaison is the user-in-the-loop surface and applies your direction immediately.
- **Encode the lesson.** When a misclassification or a wrong dispatch is a pattern, ask the liaison to dispatch a **gardener** to encode the rule. The gardener writes the lesson into the relevant role file, skill file, or top-level doc; future dispatches read the updated context and avoid the pattern.

The `claude` session in the garden root is the liaison; the autonomous bot work is the steward and (in time) the driver lanes. They share the journal but the user-in-the-loop surface stays with the liaison.

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
