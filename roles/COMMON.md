---
created: 2026-05-12
updated: 2026-08-06
author: gardener, liaison
---

# Subagent standing instructions

These apply to every dispatched subagent regardless of role. Read this first, then your role file at `roles/<role>/AGENT.md`. Then load skills only as you need them.

The §_Improving your role and skills_ section below is common to **every** role including the liaison; the per-dispatch sections (cwd, worktree triple, journal write path) only apply to subagents the orchestrator dispatched via the `Agent` tool, not to the orchestrator's own turn.

## Your dispatch root

Every subagent runs from a per-dispatch worktree triple created by the orchestrator immediately before the `Agent` invocation:

```
<dispatch-root>/
  garden/    # detached worktree of garden's dev branch (`main2`); read roles/skills here
  journal/   # detached worktree of garden's journal branch (`journal2`); write entries here
  project/   # (when applicable) detached worktree of the upstream fork@branch
```

The dispatch prompt names `<dispatch-root>` explicitly. Your cwd is `project/` if a project worktree exists, otherwise the dispatch root itself. Use `garden/` for read-only role and skill consultation. Use `journal/` for journal commits. Do not write into `garden/`; meta-evolution is the liaison's job and happens in the orchestrator's own checkout, not under a dispatch root.

All three sub-worktrees are detached HEAD. Commits go to `HEAD`; pushes use `git push origin HEAD:<branch>`. For journal appends, do not hand-roll the CAS loop: post via `scripts/jobs/journal-entry.sh` (§ Writing an entry), which implements the add-only fetch/rebase/push-retry against `journal2`. See `garden/WORKTREES.md` § Per-dispatch worktree triple for the full lifecycle.

Each sub-worktree's git identity is pinned to the bot at prepare time, so any commit you make (in `garden/`, `journal/`, or `project/`) carries the bot identity by default. Do not edit the worktree's `user.name` / `user.email`. Only the boatman is authorized to override the pin, and does so per-commit via `git -c user.name=... -c user.email=...` when its dispatch carries `identity_switch_authorized: true`. Every other role's commits are bot-identity commits. See `garden/skills/dispatch-worktree/SKILL.md` § Identity pinning for the mechanism.

When you finish, the orchestrator runs `skills/dispatch-worktree/dispatch-teardown.sh` on your dispatch root. Do not delete the worktrees yourself.

## Improving your role and skills

The final task of every engagement, common to every role including the liaison. Follow `garden/skills/self-improvement/SKILL.md` for what to look for, where to route the lesson, the threshold rules, and the one-line report format. The skill is canonical: do not embed self-improvement details in role files.

The subagent does not commit role or skill changes itself; structural lessons go to a `message` entry addressed to `liaison`, which lands the change on the dev branch (`main2`) in its own checkout. The reason the subagent cannot land them is that its `garden/` worktree is detached and ephemeral: any commit it makes there is torn down with the dispatch.

## Style

The garden's standing style rules apply to every document you author or edit, including journal entry bodies and inbox messages. The consolidated index lives in § House style at the end of this file: read it there rather than re-listing here, so the set is stated in one place and cannot drift out of sync. Vendored content under `references/<source>/` is exempt from all of them: references are read-only snapshots.

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

**Provenance footer — do not hand-write it.** Every PR/issue comment the fleet posts to GitHub is automatically suffixed with a small-text provenance footer (model · harness · deployed garden sha, hyperlinked) by the fleet's `gh` wrapper (`scripts/jobs/bin/gh` → `scripts/jobs/comment-provenance.sh`). This is enforced at the single PATH chokepoint every `gh` call passes through, so you never add it yourself: writing the footer into a comment body by hand is redundant (the wrapper recognizes an existing footer and does not double it, but it is wasted effort and easy to malform). Write your comment bodies as plain content; the footer appears on `gh pr comment` / `gh issue comment`, `gh pr review`, and inline review comments / replies posted via `gh api`. Reactions and non-comment `gh` calls are untouched. Maintainer directive, kriskowal 2026-07-28.

**Maintainer-authority actors.** "The maintainer" in this section is not only kriskowal. **erights** (GitHub `erights`, Mark S. Miller) holds full maintainer authority across the garden: a directive from erights authorizes a garden action exactly as a kriskowal directive does, including the **lifecycle / maintainer-level actions** the standing comment-relaxations do not cover on their own — closing a pull request, withdraw-and-open-fresh, design dispositions. When a gardener receives such a directive from erights (e.g. on `endojs/endo-but-for-bots`), the directive **is** the authorization: act on it directly. Do **not** re-route an erights lifecycle directive elsewhere for a separate authorization — that re-routing is the exact defect this rule removes (a gardener routed erights' "withdraw all three and open fresh" to the inbox because closing PRs exceeds the comment/reactji scope; erights' directive already authorized the close). erights is on `journal2:maintainers/allowlist` for this reason. **Boundary — authority ≠ credentials.** This authority does not confer upstream credentials. It does **not** let the bot act on **upstream `endojs/endo`** (no closing, merging, or commenting on `endojs/endo` PRs — e.g. a kriskowal-authored `endojs/endo#NNNN` stays untouched); upstream `endojs/endo` actions remain with kriskowal and the boatman identity-switch path, regardless of who issued the directive. The full-authority elevation governs *who can authorize a bot action on a repo the bot can already act on*, not *which repos the bot has credentials for*. Maintainer directive, 2026-06-30 (kriskowal, on `endojs/endo-but-for-bots` PR #572: "erights has all the authority of a maintainer").

Why: the garden runs across many forks. Without this rule, agents would reflexively cross-link "for context" and create noise across upstream issue trackers. The discipline keeps the garden's bot-side activity invisible to upstream contributors who did not opt in.

**Text-reuse permission: erights' public texts.** erights (Mark S. Miller) grants the garden (`@kriscendobot`) standing permission to **reuse and adapt/derive-from any of his public texts**, on the sole condition that the garden **continues to make clear that an adaptation is *derived from* the original but *is not* the original**. His public texts include at least: his PhD thesis; all of `erights.org` not explicitly attributed to someone else; all of his published papers; and all of his public postings on GitHub. This governs the garden's **scholarship** — the scholar's ingestion of erights' papers, thesis, and writings into `journal/library/` as abstracted, derived material (`roles/scholar/AGENT.md`), and any other role that quotes or paraphrases his work — where the *derived-from-not-the-original* provenance is the operative condition, carried on the derived artifact (a source-index `source_url`/provenance line, an attribution note, or equivalent). For a case where even this condition is awkward, **ask erights** (he may extend permission further) rather than assuming. This is a **content-reuse license**, distinct from the maintainer-authority and credential axes above: it confers no new action-authorization and no credentials. Maintainer directive, 2026-07-08 (erights, on `endojs/endo-but-for-bots` issue [#632](https://github.com/endojs/endo-but-for-bots/issues/632)).

**Project scope: `agoric/agoric-sdk`.** Experimentation with `agoric/agoric-sdk` is **permitted** when it happens on the `kriscendobot/agoric-sdk` fork: clone, branch, build, test, run, and read-only analysis are all in scope, and the bot identity pushes to its own fork freely. What stays **forbidden** is any *upstream* interaction with `agoric/agoric-sdk`: no comments, reviews, reactjis, or review-comments; no opening, editing, or closing issues or pull requests upstream; no merges or closes; and no linking an issue or pull request to `agoric/agoric-sdk` (no `Closes agoric/agoric-sdk#N`, no `cc`/`@`-mention, no "Related to ..." cross-reference in a PR/issue body or a commit message, including from the bot fork). The general § External-repo etiquette rule already forbids upstream comments and cross-references everywhere; this carve-out states the one place the garden may act on its own (the fork) and reaffirms that upstream `agoric/agoric-sdk` remains comment-and-link-free. Maintainer directive, 2026-06-28 (kriskowal, on garden issue [#9](https://github.com/kriskowal/garden/issues/9)). This widens the prior blanket "agoric-sdk off-limits" posture to "fork experimentation permitted, upstream untouched"; it does **not** authorize an autonomous identity switch or upstream ferry, which remain maintainer-gated.

## Communicating with the maintainer

When your work is scoped to an issue or a pull request, every reply you send the maintainer goes **on that issue or pull request, as a comment**. That is the only channel for issue-scoped or PR-scoped communication. Prefer an **inline review comment** anchored to the specific line of code, or an inline comment on the relevant line of a design document, so the maintainer reads your answer in the exact place the question arose (`skills/pr-review-thread-replies/SKILL.md`). Anchoring each point to its line is the difference between a reply the maintainer can act on without hunting and one they have to reconstruct.

When the work as a whole needs an acknowledgment, add **one top-level summary comment** alongside the inline replies, per the completion-summary norm above and `skills/pr-completion-summary-comment/SKILL.md`: head SHA, what changed (mapped to addressing commits), what was declined and why, and the verification status (tests, lint, types). The inline replies anchor each point; the summary ties them together. Inline-only replies and silent pushes are not enough.

Never route issue-scoped or PR-scoped feedback to the maintainer anywhere but the issue or pull request itself. If commenting on the repository is not yet authorized (per § External-repo etiquette), hold the reply in your completion report so the orchestrator posts it on the issue or pull request; the destination is still that thread, relocated and never skipped, never moved off the issue or pull request. The inter-agent message bus (a journal `message` entry to a peer role, a directed inbox note to another living agent) is a separate facility for agent-to-agent coordination and is unaffected by this rule; it is never a substitute for replying to the maintainer on the issue or pull request.

## Authority structure of upstream projects

Default technical authority on any repo the garden touches rests with that repo's maintainer. Some projects have non-default-authority actors: senior contributors whose review or comment on a topic-matching PR carries maintainer-equivalent (or greater) weight on the technical question, even though the garden's authorization chain still routes through the project's maintainer. The canonical place to record an actor's name, the topics that scope their authority, and the practical in-scope vs. out-of-scope rule is the **project README** in the journal (`journal/projects/<slug>/README.md`), not this file and not a role file. Per-project monitor reaction skills (`skills/monitor-<slug>/SKILL.md`) consult that section when deciding whether to surface a senior contributor's event on a topic-matching PR.

The endo project README (`journal/projects/endo/README.md` § Authority structure) is the prototype: erights is named as the senior contributor; the topic list is enumerated; the practical rule states what changes (how the garden reads the technical content) and what does not (the authorization chain to act on it). Future per-project READMEs may adopt the same shape for other actors.

Note the two axes do not conflict. This section's topic-scoping governs the **technical weight** the garden gives erights' *reviews* on the upstream `endojs/endo` (the reading axis). The **authorization** axis is separate and is settled in § External-repo etiquette → *Maintainer-authority actors*: erights holds full maintainer authority to *authorize* a garden action (including PR-close / withdraw-and-open-fresh) on a repo the bot can already act on, exactly as kriskowal does. The credential boundary there still applies — full authorization power never reaches across to give the bot upstream `endojs/endo` credentials.

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
- Garden dev-branch (`main2`) checkout (read-only for you): `<dispatch-root>/garden/`.
- Journal worktree (write entries here): `<dispatch-root>/journal/`.
- Project worktree (when applicable, code lives here): `<dispatch-root>/project/`.
- Worktree management doc (`WORKTREES.md`) and the role/skill library are inside `garden/`; follow links from this file's relative paths.

## The journal

The journal is the garden's transcript and message bus. It is a worktree of the garden repo on an orphan branch (`journal2`). Its history is independent of the dev branch (`main2`), so journal commits never enter PRs or pollute code-side blame.

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

Post the entry with `scripts/jobs/journal-entry.sh <kind> [body-file]` (kind is `progress`, `result`, `message`, …; body from the file, else stdin). It handles the add-only compare-and-swap — fetch/rebase/push with resync-and-retry on a rejected push — so you never hand-roll the detached-HEAD loop. Do not roll your own; concurrent appends across parallel gardeners are subtle and this script is the single source of truth. Use `skills/journalism/SKILL.md` only for *reading* the journal, and `skills/message-bus/SKILL.md` for directed messages.

**Re-posting the same entry is a no-op, not a second entry.** The journal is append-only, so posting one report twice used to leave two permanent copies that every consumer scanning new entries (the bulletin, the journalist, the mentor tick) then counted twice. The script now suppresses it for you: before committing, it scans the entries recently landed on `origin/journal2` and, if one has the same `kind`, `role` and host and a **byte-identical body** (frontmatter — including the `at:` stamp — excluded from the comparison), it logs `duplicate of <path>, not posting` and exits 0 without writing. The window is 15 minutes (`GARDEN_ENTRY_DUP_WINDOW`, seconds; `0` disables). So you never have to remember whether you already posted — just post. When an identical body genuinely *is* a distinct event (a periodic heartbeat), pass `--allow-duplicate`.

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

### Per-subagent worktrees (the hard rule) and scratch discipline

**The root checkout (`<garden-root>`) is read-only for development.** It is a *deployed* version of the garden, advanced only by the deliberate, drained `scripts/jobs/deploy-garden.sh` ([deliberate-deploy](../designs/deliberate-deploy.md)) — never edited in place. Every gardener or subagent doing **any** development, **including garden-infra work on `main2` itself**, works in its **own** git worktree off the dev branch, so concurrent workers never collide and the root tree is never dirtied. This is the hard rule, not a preference: the isolated-worktree path is the *only* path. A garden-infra job that edits the root tree directly is a defect.

The launch paths enforce this mechanically, so the rule holds even when a prompt forgets it. A gardener's default `claude -p` handler (`scripts/jobs/handlers/gardener-claude.sh`) runs with its cwd **already set** to a fresh per-job worktree off `origin/$GARDEN_MAIN_BRANCH` (stable per job base, reused on a reaper-requeue resume, torn down on completion); the Agent-tool dispatch path gives the same guarantee via its worktree triple (`skills/dispatch-worktree/dispatch-prepare.sh`). So a `claude -p` gardener job is **already inside** its own worktree and should develop there in its cwd, never reaching for the root tree. The manual `git worktree add` shape below is for a **shell/script** job (a non-`claude` handler) that must create its own isolated worktree.

```sh
# the one correct shape for a garden-infra (main2) job:
git -C <garden-root> fetch origin main2
git worktree add --detach "$(scratch_dir infra-<slug>)" origin/main2
# develop, explicit-pathspec commit, then push HEAD:main2 via a rebase CAS loop
```

**Never create scratch files or ad-hoc worktrees in the live garden tree root.** A scratch dir or worktree at the root pollutes `git status` and dirties the deployed tree, which blocks a deploy's clean merge. Use the dedicated, gitignored scratch tree instead:

- `GARDEN_SCRATCH` (defaults to `<garden-root>/scratch`, gitignored as `/scratch/`) is the one place for ephemeral job scratch and ad-hoc worktrees.
- `scripts/jobs/common.sh` provides the helpers: `scratch_dir <base>` makes and echoes a fresh private `$GARDEN_SCRATCH/<base>-<short-rand>/`; `scratch_cleanup <dir>` removes it (deregistering it first if it is a git worktree). Source `common.sh` and call `scratch_dir "<job-slug>"` to get your path; `scratch_cleanup` it when done.
- A shell job that needs an isolated worktree off `origin/main2` (garden-infra discipline) adds it under `$GARDEN_SCRATCH/`, not at the garden root: `git worktree add --detach "$(scratch_dir infra-<slug>)" origin/main2`.
- The reaper runs a scratch janitor that GCs `$GARDEN_SCRATCH/*` entries left untouched for `GARDEN_SCRATCH_GC_AGE` hours (default 24), so a job that dies mid-flight self-cleans. Still call `scratch_cleanup` yourself; the janitor is only a backstop.
- **`/tmp` is not merely untidy — on garden hosts it is mounted `noexec`.** A generated helper script written under `/tmp` (or `$TMPDIR` when it points there) cannot be run: `chmod 755` succeeds and the invocation then fails with `Permission denied`, which surfaces only in a redirected log and reads like a permissions bug rather than a mount option. So this is an *execution* constraint, not just scratch hygiene: any script you generate and then execute must live under `GARDEN_SCRATCH`, or be invoked as `bash <path>` (which needs no exec bit and ignores `noexec`). Committed in-repo test stubs exist for exactly this reason — a `/tmp` heredoc helper a test `exec`s is a defect on these hosts.

If you are dispatched into a long-lived project worktree (a standing monitor, an integrate scratch), the orchestrator names it in your dispatch prompt as the project worktree and you treat it normally. The worktree's authoritative journal index lives at:

```
journal/worktrees/$(hostname -s)/<worktree-basename>.md
```

Read it on start to learn your purpose, role, repo, branch, and any PRs you are bound to. Update `last_heartbeat` and `status` there per the lifecycle in `journal/worktrees/README.md`; `scripts/jobs/journal-worktree-keeper.sh` owns the worktree-status commit and push.

## Reporting

When done with a one-shot task, write a `result` entry to the journal **and** return a concise summary in your final message. The journal is durable; your final message is convenience for whoever dispatched you. Both end with a one-line `Self-improvement: ...` per `garden/skills/self-improvement/SKILL.md` (or `Self-improvement: nothing this time.`).

**A "verified" claim requires real-execution evidence.** Never write "verified" (nor "confirmed working", "passes", "works", "all criteria met") in a report, a PR comment, a commit message, or a completion summary unless you actually ran the thing and observed the result, and you cite that evidence: the command you ran and its output, the test that passed, or the observation you made. Reading the implementation and reasoning that it *should* work is not verification. It is a design argument, and you label it as one. **UI and browser acceptance criteria require an actual browser run:** launch the app, run the command, and observe the rendered DOM (a screenshot, or a precise description of what did and did not render). A passing unit test or a code inspection does **not** satisfy a UI acceptance criterion, because the criterion is about what the user sees on screen. When you could not run it, write **"not verified"** and say why. An honest "not verified" costs a follow-up; a false "verified" costs the maintainer's trust and time. Source: `endojs/endo-but-for-bots` #58 (2026-07-01), where the garden reported three UI acceptance criteria "verified" from code inspection, and the maintainer then opened Chrome and found only one of the three actually rendered.

**A CI lint/test failure is a defect in our automation, not just a PR to fix.** Treat any red lint or test check in CI as a failure of our tooling to *anticipate* it. Three standing points: (a) every lint and test CI runs **must** be run locally before pushing (`garden/skills/local-verify/SKILL.md`, `garden/skills/pre-push-gates/SKILL.md`): a red CI run means we failed to run it first; (b) a red CI check is therefore a defect in our automation to close, not merely a PR fix; (c) a local-pass/CI-fail **discrepancy** is itself an environment-parity defect to diagnose and close (add the missing check to `local-verify`, or fix the environment divergence), never worked around with a one-off green push. When you green a PR after a CI failure `local-verify` should have caught, also close the gap so the same class cannot recur (`garden/skills/ci-failure-classification-loop/SKILL.md`).

When you are interrupted or hit a blocker you cannot resolve, write a `message` entry addressed to `liaison` describing what you tried and what you need.

## House style

The garden's standing style rules. Every dispatched agent follows these on every document it authors or edits, including journal entry bodies and inbox messages. Each is a skill; read it when you need the detail.

- `garden/skills/em-dash-style/SKILL.md`: avoid em-dashes in prose; rewrite as a period, parentheses, or a colon.
- `garden/skills/relative-paths/SKILL.md`: paths within one document tree are relative; absolute paths are reserved for the cross-tree case (a document instructing an agent in another tree, as this file does for subagents reading it from a dispatch-root copy of `garden/`).
- `garden/skills/no-latin-shorthand/SKILL.md`: avoid Latin shorthand (`cf.`, `i.e.`, `e.g.`, `etc.`, `et al.`, `vs.`, `viz.`, `ad hoc`) in bot-authored prose; use the English equivalent.
- `garden/skills/typist-friendly-code-points/SKILL.md`: avoid code points that are difficult for a typist to produce (`→`, `…`, curly quotes, `≤` and kin); type the ASCII spelling (`->`, `...`, straight quotes, `<=`).
- `garden/skills/test-title-spec-spelling/SKILL.md`: when a test title names a spec-defined surface, spell it exactly as the specification does.
- `garden/skills/url-path-math/SKILL.md`: in Endo JavaScript modules, use `new URL(...)` for module-relative path math and convert to a native path only at the API boundary that requires one.
- `garden/skills/fully-qualified-github-urls/SKILL.md`: in GitHub-rendered text (issue/PR comments, reviews), every reference to a repo, commit, or site is a fully-qualified `https://` URL, never `owner/repo` / bare-SHA / bare-host shorthand. This is a GitHub-communication rule, distinct from `relative-paths` (which keeps links *inside* a document tree relative).
- `garden/skills/gricean-maxims/SKILL.md`: be concise; optimize for the reader's attention. Apply Grice's four maxims (Quantity, Quality, Relation, Manner) to every communication (completion reports, PR comments, review replies, journal bodies, bus messages) and to the prose you land in a project repo (code comments, design documents, commit bodies). Unlike the mechanical rules above, these are judgment calls, so the skill makes them operational with do/don't pairs. The sharpest one to internalize is **empty emphasis**. Do not tell the reader that something matters ("load-bearing rather than incidental", "note that this is subtle", "importantly"); show what it buys and let them conclude it. Such a phrase is padding when the surrounding text already shows the importance, and an unevidenced claim when it does not. The maxims govern **how** something is said, never **whether** a required disclosure (a completion-summary element, an inline-reply anchor, the `tada` contract) is made.

Vendored content under `references/<source>/` is exempt from all of these: references are read-only snapshots. This section is the single consolidated index of all standing-style skills; § Style near the top of this file defers here rather than re-listing them.
