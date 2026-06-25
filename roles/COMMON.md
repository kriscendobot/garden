---
created: 2026-05-12
updated: 2026-06-25
author: gardener, liaison
---

# Subagent standing instructions

These apply to every dispatched subagent regardless of role. Read this first, then your role file at `roles/<role>/AGENT.md`. Then load skills only as you need them.

The §_Improving your role and skills_ section below is common to **every** role including the liaison; the per-dispatch sections (cwd, worktree triple, journal write path) only apply to subagents the orchestrator dispatched via the `Agent` tool, not to the orchestrator's own turn.

## Your dispatch root

Every subagent runs from a per-dispatch worktree triple created by the orchestrator immediately before the `Agent` invocation:

```
<dispatch-root>/
  garden/    # detached worktree of garden's `main` branch; read roles/skills here
  journal/   # detached worktree of garden's `journal` branch; write entries here
  project/   # (when applicable) detached worktree of the upstream fork@branch
```

The dispatch prompt names `<dispatch-root>` explicitly. Your cwd is `project/` if a project worktree exists, otherwise the dispatch root itself. Use `garden/` for read-only role and skill consultation. Use `journal/` for journal commits. Do not write into `garden/`; meta-evolution is the liaison's job and happens in the orchestrator's own checkout, not under a dispatch root.

All three sub-worktrees are detached HEAD. Commits go to `HEAD`; pushes use `git push origin HEAD:<branch>`. See `garden/skills/journal-sync/SKILL.md` for the journal-side details and `garden/WORKTREES.md` § Per-dispatch worktree triple for the full lifecycle.

Each sub-worktree's git identity is pinned to the bot at prepare time, so any commit you make (in `garden/`, `journal/`, or `project/`) carries the bot identity by default. Do not edit the worktree's `user.name` / `user.email`. Only the boatman is authorized to override the pin, and does so per-commit via `git -c user.name=... -c user.email=...` when its dispatch carries `identity_switch_authorized: true`. Every other role's commits are bot-identity commits. See `garden/skills/dispatch-worktree/SKILL.md` § Identity pinning for the mechanism.

When you finish, the orchestrator runs `skills/dispatch-worktree/dispatch-teardown.sh` on your dispatch root. Do not delete the worktrees yourself.

## Improving your role and skills

The final task of every engagement, common to every role including the liaison. Follow `garden/skills/self-improvement/SKILL.md` for what to look for, where to route the lesson, the threshold rules, and the one-line report format. The skill is canonical: do not embed self-improvement details in role files.

The subagent does not commit role or skill changes itself; structural lessons go to a `message` entry addressed to `liaison`, which lands the change on `main` in its own checkout. The reason the subagent cannot land them is that its `garden/` worktree is detached and ephemeral: any commit it makes there is torn down with the dispatch.

## Style

Three prose-style rules apply to every document you author or edit in the garden, including journal entry bodies. All are skills:

- `garden/skills/em-dash-style/SKILL.md`: avoid em-dashes in prose; rewrite as period, parentheses, or colon.
- `garden/skills/relative-paths/SKILL.md`: paths within one document tree are relative; absolute paths are reserved for the cross-tree case (a document instructing an agent in another tree, as this file does for subagents reading it from a dispatch-root copy of `garden/`).
- `garden/skills/no-latin-shorthand/SKILL.md`: avoid Latin shorthand (`cf.`, `i.e.`, `e.g.`, `etc.`, `et al.`, `vs.`, `viz.`, `ad hoc`) in bot-authored prose; use the English equivalent.

Vendored content under `references/<source>/` is exempt from all three: references are read-only snapshots.

## Document frontmatter

Every persistent document in the garden (role files, skill files, top-level docs) carries YAML frontmatter at the top with creation, last-updated, and author fields:

```yaml
---
created: 2026-05-12          # ISO date the document was first written
updated: 2026-05-12          # ISO date of the most recent meaningful edit
author: liaison              # role that last meaningfully revised it; comma-separated for joint work
---
```

When you edit a document, update `updated`. If your authorship changes the document's center of gravity, prepend yourself to `author`. Trivial fixes (typos, link repair) do not warrant an authorship change.

The journal does **not** use this frontmatter. Entries already carry `ts:` and `role:`, and they are append-only so `updated` is moot.

## Monitoring safety constraint

Standing-monitor daemons feed event bodies, comment text, and pull-request descriptions into the LLM's context on every wake. Only repositories whose comments and pull requests are gated against untrusted contributors are safe to monitor; anything else exposes the role on the receiving end to text an untrusted actor can write, which is a prompt-injection hazard. As of 2026-05-13 only `endojs/endo-but-for-bots` meets this bar in the active set, and the review-queue daemon (polling kriskowal's pending-review set against trusted GitHub state) is safe by construction. Re-enabling another monitor requires explicit maintainer authorization recorded in a journal `message` entry; until that authorization is on record, the role-author leaves the dormant-banner skills as documentation only and does not propose adding standing-monitor rows. This is a standing constraint, not a one-time decision. See `CLAUDE.md` § Monitoring safety constraint for the same rule with the orchestrator's framing.

## External-repo etiquette

A subagent dispatched into a fork worktree must not initiate, on issues or pull requests in *any* repository, any of:

- Comments, reviews, or review-comments
- Reactjis
- Cross-references (`Closes endojs/endo#123`, `cc @user` mentions, "Related to ..." text in PR/issue bodies or commit messages)
- Issue or PR opens, edits, or closes

Exception: the job that dispatched you explicitly authorizes the action. Such authorizations originate with the maintainer. They reach a job either through the **liaison** (the human-facing relay) after user confirmation, or through a journal `message` / inbox entry; in both cases the authorization is carried into the job's body or the doer's inbox at claim time. No autonomous role originates a cross-repo authorization on its own.

The boatman is the documented exception by role: opening the upstream PR and cross-linking it with the source garden PR is inherent to its job, and the boatman's dispatch is itself gated on `identity_switch_authorized: true` from a maintainer. That single authorization implicitly covers the cross-link. Other roles need a per-action authorization in their dispatch prompt.

Per-role notes for the active library, expressed as the *kind* of per-action authorization a job must carry (and which the doer never originates on its own):

- **fixer**: a maintainer's `CHANGES_REQUESTED` (or substantive `COMMENTED`) review implies the fixer will push to the PR branch and post a top-level summary citing each addressing SHA. The push itself is implicit in the job; the per-action authorization the job carries covers (a) replying on each inline thread, (b) `gh api .../requested_reviewers` re-request after CI is green, and (c) the top-level summary comment.
- **weaver**: pushing the rebased force-with-lease is implicit in a "rebase PR <N>" job. Posting a follow-up comment on the PR (e.g., explaining a non-trivial conflict resolution) requires a separate per-action authorization in the job.
- **shepherd**: a CI-fix push is implicit. Posting a green-run-URL comment to the PR after the shepherd's own push lands and CI converges is a per-action authorization the job must carry.
- **conductor**: issuing `gh pr merge --merge` (or `--auto --merge`) is implicit in a "drain the merge queue" job. Posting a merge-context comment (a stall reason, an "unblocked downstream" note) is a per-action authorization.
- **designer**: opening a fork-side PR to land a `designs/<slug>.md` is implicit when the job authorizes it. Replying on inline review comments and posting top-level summaries on a maintainer-reviewed design PR are per-action authorizations.
- **scout**: posting the benchmark report as a PR comment is a per-action authorization. The scout's default deliverable is a journal `result` entry; the PR-comment posting is a separate carried authorization.
- **botanist**: posting the verdict (MERGE-NOW / EMBARGO / REJECT) as a PR comment is a per-action authorization. Closing a REJECT'd Dependabot PR via `gh pr close` is a separate authorization the job must carry when staged.
- **major-general**: opening the adoption PR is implicit when the job authorizes it. Opening a DEFER's tracking issue is a per-action authorization, as is any comment on a closed Dependabot PR explaining why the major-general's adoption supersedes it.

**Standing communication norm: the completion summary comment.** Whenever a role pushes work to a PR in response to a maintainer directive, a review, or feedback, and commenting on that repo is authorized (the job carries the authorization, or the repo's standing authorization covers it, as `endojs/endo-but-for-bots` does per `journal/projects/endo-but-for-bots/README.md` § Standing authorizations), the role **must** post a top-level summary comment in addition to any inline thread replies. The summary names the head SHA, what changed (mapped to addressing SHAs), what was declined and why, and the verification status (tests / lint / types). Inline-only replies and silent pushes are not enough: the PR conversation should carry a human-readable acknowledgment of the work. This applies fleet-wide to every PR-touching role (fixer, builder, weaver, shepherd, conductor, botanist, designer, scout, major-general). The shape is written once in `skills/pr-completion-summary-comment/SKILL.md`. When commenting is **not** authorized on a given repo, the summary goes in the completion report for the orchestrator to post; it is relocated, never skipped. Source: maintainer feedback on PR #474 (2026-06-25), where a fixer posted inline replies and pushed the fix but no after-the-fact summary, and the maintainer expected one ("I expect feedback on the PR in general").

These authorizations originate with the maintainer (typically through the liaison after user confirmation, or through a journal `message` / inbox entry), and are carried into the job's body or the doer's inbox at claim time. No autonomous role originates a new cross-repo authorization; it acts only on the authorization the job carries.

Why: the garden runs across many forks. Without this rule, agents would reflexively cross-link "for context" and create noise across upstream issue trackers. The discipline keeps the garden's bot-side activity invisible to upstream contributors who did not opt in.

## Authority structure of upstream projects

Default technical authority on any repo the garden touches rests with that repo's maintainer. Some projects have non-default-authority actors: senior contributors whose review or comment on a topic-matching PR carries maintainer-equivalent (or greater) weight on the technical question, even though the garden's authorization chain still routes through the project's maintainer. The canonical place to record an actor's name, the topics that scope their authority, and the practical in-scope vs. out-of-scope rule is the **project README** in the journal (`journal/projects/<slug>/README.md`), not this file and not a role file. Per-project monitor reaction skills (`skills/monitor-<slug>/SKILL.md`) consult that section when deciding whether to surface a senior contributor's event on a topic-matching PR.

The endo project README (`journal/projects/endo/README.md` § Authority structure) is the prototype: erights is named as the senior contributor; the topic list is enumerated; the practical rule states what changes (how the garden reads the technical content) and what does not (the authorization chain to act on it). Future per-project READMEs may adopt the same shape for other actors.

## Project context

Project specifics (repo URLs, fork ownership, account/credential conventions, project-specific preferences) live in the **journal**, not in role or skill files. The garden's role/skill layer is project-agnostic and stays small; per-project facts accumulate as `message` entries with a `project:` slug.

To find what the garden knows about a project, grep the journal's entries for the project slug. From your dispatch root:

```sh
grep -rl '^project: <slug>' journal/entries/
```

The most recent matching entry is the current source of truth; older entries are history.

## Library

The journal carries a cross-cutting reference library at `journal/library/` distilled from upstream design documents and READMEs. When your work touches a domain term you do not already understand — a code symbol, a proper name, a phrase from a design — consult the library before guessing. The library has three indexing axes:

- `journal/library/sources/` — by provenance (which upstream document said this).
- `journal/library/topics/` — by broad subject taxonomy.
- `journal/library/keywords.md` + `journal/library/concepts/` — by *the specific term you are looking up*.

Use the `garden/skills/library-lookup/SKILL.md` skill rather than reading these by eye. The skill grep-resolves the term, walks to the right concept page, opens the relevant section files, and (this is the part that compounds) *indexes on the fly* — adds a shortcut to `keywords.md`, prunes a distraction on a concept page, or drafts a missing concept — so the next reader's search succeeds where yours did not or succeeds faster than yours did. Every dispatched role uses the same skill; index improvements made by one role's caller benefit every subsequent caller in every other role.

## Where things are

- Your dispatch root: in the dispatch prompt; `pwd` reports the project subworktree (or the dispatch root if there is none).
- Garden `main` checkout (read-only for you): `<dispatch-root>/garden/`.
- Journal worktree (write entries here): `<dispatch-root>/journal/`.
- Project worktree (when applicable, code lives here): `<dispatch-root>/project/`.
- Worktree management doc (`WORKTREES.md`) and the role/skill library are inside `garden/`; follow links from this file's relative paths.

## The journal

The journal is the garden's transcript and message bus. It is a worktree of the garden repo on an orphan branch. Its history is independent of `main`, so journal commits never enter PRs or pollute code-side blame.

The journal's top-level `README.md` is the maintainer dashboard: a bulletin board for items needing maintainer attention (PRs ready for review, decisions, surplus authority, pre-staged authorizations) and a summary of ongoing work (active worktrees, open monitors). Agents own the bulletin entirely: they post when an item arises and they clear it once the underlying condition is resolved (typically when a gardener closes out the job that resolved it). The maintainer reads the bulletin and acts in the upstream system; agents detect the action and clear. See `journal/README.md` (in your dispatch root) for the current structure.

The journal also archives terminated long-living subagents under `agents/`, indexed by date / role / subject matter for future consultation. The dispatcher writes a termination report per `garden/skills/agent-termination/SKILL.md` when a long-living subagent ends; future agents (or the user) consult the archive by grepping the report frontmatter. See `journal/agents/README.md` for browse recipes.

### Entry layout

```
journal/entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-<kind>-<role>-<short-id>.md
```

- `<HHMMSS>Z`: UTC time of day, zero-padded.
- `<short-id>`: 6 hex chars, random or from your session id. Makes filename collisions effectively impossible across concurrent agents.

### Entry shape

```markdown
---
ts: 2026-05-12T14:23:45Z
kind: tick                          # dispatch | tick | message | result | worktree
role: monitor                       # role producing the entry
worktree: worktrees/anthropics-claude-code/watch-main--monitor--20260512-142345
repo: anthropics/claude-code        # upstream, when applicable
project: endo                       # optional, short slug; lets agents grep entries by project
to: "*"                             # for messages: target role, or "*" for broadcast
refs:
  - entries/2026/05/12/142200Z-dispatch-liaison-a7f2c1.md
---

<one paragraph or short structured body>
```

The `project:` field is optional but recommended whenever an entry is about a specific project. Search by `grep -l '^project: <slug>' ...` to recover all entries for a project. Project slugs are short kebab-case names that match the canonical upstream repo name (e.g. `endo`, `agoric-sdk`), not the fork owner.

The `worktree:` field, when present, names the project worktree the entry is about. For per-dispatch project worktrees this is the dispatch-root-relative path; for standing worktrees (the monitor watch dirs) it is the long-lived `worktrees/<owner>-<repo>/<name>/` path.

### Writing an entry

Follow `garden/skills/journal-sync/SKILL.md`. It handles the detached-HEAD fetch/rebase/push retry loop. Do not roll your own; concurrent appends across orchestrator turns and parallel dispatches are subtle and the skill is the single source of truth.

### Reading recent entries

From your dispatch root:

- Overview: `git -C journal log --since='1 hour ago' --pretty='%h %s'`.
- Messages addressed to your role: `grep -rl 'to: <your-role>\|to: "\*"' journal/entries/$(date -u +%Y/%m/%d)/`.
- A specific prior entry referenced from your dispatch: read the path verbatim.

## Worktree conventions (summary)

Full doc in `garden/WORKTREES.md`. Minimum you need to know:

- Your per-dispatch worktree triple is ephemeral; do not store anything you need to survive the dispatch outside the journal.
- For project worktrees, role-private high-frequency state (polling caches, scratch files) lives inside the worktree under `.garden/` (e.g., `.garden-monitor/<repo>/`) and is never committed to the upstream branch. Per-dispatch project worktrees are torn down between dispatches; the only reason to write there is the dispatch's own work, not durable state.
- The standing-monitor exception: a small number of long-lived `worktrees/<owner>-<repo>/watch-<slug>--monitor--<ts>/` checkouts persist across dispatches because their `.garden-monitor/<repo>/` state is owned by a bash daemon that runs continuously. These are referenced by the daemon, not by you; do not write to them from an LLM dispatch.
- Do not rename, move, or remove any worktree. Lifecycle is the orchestrator's job; per-dispatch teardown happens via `skills/dispatch-worktree/dispatch-teardown.sh` when you return.

If you are dispatched into a long-lived project worktree (a standing monitor, an integrate scratch), the orchestrator names it in your dispatch prompt as the project worktree and you treat it normally. The worktree's authoritative journal index lives at:

```
journal/worktrees/$(hostname -s)/<worktree-basename>.md
```

Read it on start to learn your purpose, role, repo, branch, and any PRs you are bound to. Update `last_heartbeat` and `status` there per the lifecycle in `journal/worktrees/README.md`; the journal-sync skill handles the commit and push.

## Reporting

When done with a one-shot task, write a `result` entry to the journal **and** return a concise summary in your final message. The journal is durable; your final message is convenience for whoever dispatched you. Both end with a one-line `Self-improvement: ...` per `garden/skills/self-improvement/SKILL.md` (or `Self-improvement: nothing this time.`).

When you are interrupted or hit a blocker you cannot resolve, write a `message` entry addressed to `liaison` describing what you tried and what you need.

## House style

The garden's standing style rules. Every dispatched agent follows these on every document it authors or edits, including journal entry bodies and inbox messages. Each is a skill; read it when you need the detail.

- `garden/skills/em-dash-style/SKILL.md`: avoid em-dashes in prose; rewrite as a period, parentheses, or a colon.
- `garden/skills/relative-paths/SKILL.md`: paths within one document tree are relative; absolute paths are reserved for the cross-tree case (a document instructing an agent in another tree, as this file does for subagents reading it from a dispatch-root copy of `garden/`).
- `garden/skills/no-latin-shorthand/SKILL.md`: avoid Latin shorthand (`cf.`, `i.e.`, `e.g.`, `etc.`, `et al.`, `vs.`, `viz.`, `ad hoc`) in bot-authored prose; use the English equivalent.
- `garden/skills/test-title-spec-spelling/SKILL.md`: when a test title names a spec-defined surface, spell it exactly as the specification does.

Vendored content under `references/<source>/` is exempt from all of these: references are read-only snapshots. The first three rules are also summarized in § Style above, which the existing prose-style references point at; this section is the consolidated index of all four standing-style skills.
