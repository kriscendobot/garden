---
title: "garden/roles/COMMON.md — the named-standing-subagent-instructions shape; sixth garden source ingest; §six-cycles-with-garden-repo-source-ingest; §six-named-shapes-of-garden-self-documentation; §the-named-explicit-load-vs-auto-load (CLAUDE.md auto-loaded by Claude Code vs COMMON.md explicit-loaded by dispatch prompt); §two-named-statements-of-the-same-monitoring-safety-constraint (CLAUDE.md orchestrator framing + COMMON.md subagent framing); §the-named-three-prose-style-rules-as-skills (em-dash-style + relative-paths + no-latin-shorthand); §the-named-external-repo-etiquette with default-deny + per-role authorization table; §the-named-three-stage-authorization-pipeline (originate + record + inline); §the-named-library-IS-three-indexing-axes (sources + topics + keywords/concepts); §the-named-index-on-the-fly-IS-the-compounding-property; §the-named-result-entry-AND-final-message dual-channel reporting; §the-named-mandatory-`Self-improvement:`-one-line"
section-slug: garden--roles-COMMON-md--sixth-garden-source-and-standing-subagent-instructions-and-explicit-load-vs-auto-load
source-slug: garden--roles-COMMON-md
url: https://github.com/kriskowal/garden/blob/main/roles/COMMON.md
authors: [Endo project (collective; current-frontmatter = gardener + liaison)]
repo: kriskowal/garden
path: roles/COMMON.md
total-lines: 204
ingest-cycle: 301
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `garden/roles/COMMON.md` (sixth garden source ingest)

A 204-line document — the standing instructions every dispatched subagent reads first. **The sixth garden source ingested**. **§six-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md + 298 dispatch-prepare/teardown pair + 299 CLAUDE.md + 300 daemons start/stop/config-example + 301 roles/COMMON.md). **§six-named-shapes-of-garden-self-documentation** (proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions). The garden-meta cluster IS now the library's largest single-repo cluster at six sources.

## Key moves

- **§the-named-standing-subagent-instructions-shape** (first-explicit-observation): COMMON.md IS the "standing instructions every dispatched subagent reads first" — distinct from CLAUDE.md (which IS the orchestrator's project-instructions auto-loaded by Claude Code) and from per-role AGENT.md files (which are role-specific). **§the-named-three-named-tiers-of-subagent-context**: standing (COMMON.md) + role (AGENT.md) + on-demand (skills/<skill>/SKILL.md). The dispatch prompt names all three: "Read these in order, then act: 1. garden/roles/COMMON.md ... 2. garden/roles/<role>/AGENT.md ... 3. skills referenced by your role, only as you need them."

§the-named-tiered-context-loading-IS-named-progressive-disclosure: cheap-to-load standing instructions first, then narrower role context, then load skills only when the work needs them. **§the-named-on-demand-skill-loading**.

- **§the-named-explicit-load-vs-auto-load** (first-explicit-observation):

The garden has **two distinct mechanisms** for "load this first":
1. **Auto-load** — `CLAUDE.md` (filename matches Claude Code's auto-load convention; Claude Code does it without dispatcher intervention).
2. **Explicit-load** — `COMMON.md` / `AGENT.md` / `SKILL.md` (filenames deliberately do NOT match the auto-load convention; the dispatch prompt explicitly names them as Read targets).

**§the-named-naming-discipline-against-auto-load** (extends cycle 299): cycle 299 named the discipline ("Files are named `AGENT.md` / `SKILL.md` / `COMMON.md` (not `CLAUDE.md`) on purpose: we do **not** want Claude Code to auto-load them"); cycle 301 IS the named-implementation-side of that discipline. **§the-named-discipline-design-and-instance-pair-across-two-cycles** (299 names the rule; 301 IS the document that the rule shapes).

§two-named-shapes-of-load-first-instructions: auto-load (Claude Code's job) + explicit-load (the dispatcher's job). **§the-named-distinction-between-the-runtime's-load-mechanism-and-the-dispatcher's-load-mechanism**.

- **§the-named-subagent-vs-orchestrator-distinction-at-the-document-level** (first-explicit-observation):

```
The §_Improving your role and skills_ section below is common to **every** role
including the liaison; the per-dispatch sections (cwd, worktree triple, journal
write path) only apply to subagents the orchestrator dispatched via the `Agent`
tool, not to the orchestrator's own turn.
```

**§the-named-section-applicability-distinction**: the document explicitly distinguishes "applies to every role including the liaison" sections from "applies only to subagents" sections. **§the-named-self-aware-applicability-marker**.

§the-named-orchestrator-vs-subagent-binary: the document IS read by both (the liaison reads it as an orchestrator; dispatched subagents read it as subagents); a single document with named-internal-applicability-distinctions serves both.

- **§the-named-three-prose-style-rules-as-skills** (first-explicit-observation):

```
- garden/skills/em-dash-style/SKILL.md
- garden/skills/relative-paths/SKILL.md
- garden/skills/no-latin-shorthand/SKILL.md
```

**§the-named-prose-style-IS-named-skill-not-inline-norm**: prose-style rules are encoded as skills (named, versioned, separately-loadable), not as inline paragraphs in COMMON.md. **§the-named-discipline-of-keeping-COMMON.md-small** — even the most universal rules are externalized to skills.

§the-named-three-rules-named-in-one-place: em-dash-style + relative-paths + no-latin-shorthand. **§the-named-three-universal-skills** that apply to every document the bot authors. The rule itself is short ("Three prose-style rules apply to every document you author or edit in the garden, including journal entry bodies. All are skills:"); the substance lives in the linked skill files.

- **§the-named-vendored-content-exemption** (first-explicit-observation):

```
Vendored content under `references/<source>/` is exempt from all three:
references are read-only snapshots.
```

**§the-named-vendored-exempt-from-bot-style-rules**: external snapshots are not rewritten to match the garden's prose style. **§the-named-explicit-exempt-discipline**: the rule names the exemption upfront rather than letting it become a recurring ad-hoc question. **§the-named-snapshot-IS-read-only-shape**.

- **§the-named-document-frontmatter-IS-three-named-fields** (first-explicit-observation):

```yaml
---
created: 2026-05-12          # ISO date the document was first written
updated: 2026-05-12          # ISO date of the most recent meaningful edit
author: liaison              # role that last meaningfully revised it
---
```

**§the-named-three-named-frontmatter-fields**: created + updated + author. **§the-named-author-IS-named-role-not-person** (extends cycle 299's named-role-as-author-shape into a fourth cycle: 281 + 297 + 299 + 301). **§four-cycles-with-named-role-as-author-shape**.

§the-named-trivial-fixes-do-NOT-warrant-an-authorship-change: "Trivial fixes (typos, link repair) do not warrant an authorship change." **§the-named-threshold-for-authorship-bump-IS-named-explicitly**. **§the-named-meaningful-edit-discipline**.

§the-named-journal-does-NOT-use-this-frontmatter: "Entries already carry `ts:` and `role:`, and they are append-only so `updated` is moot." **§the-named-journal-IS-its-own-frontmatter-shape**. **§two-named-frontmatter-shapes-in-the-garden** (persistent-doc-shape + journal-entry-shape).

- **§two-named-statements-of-the-same-monitoring-safety-constraint** (first-explicit-observation):

The monitoring safety constraint IS stated **twice**: once in CLAUDE.md (cycle 299; orchestrator's framing) and once in roles/COMMON.md (cycle 301; subagent's framing). The document itself names this: "See `CLAUDE.md` § Monitoring safety constraint for the same rule with the orchestrator's framing."

**§the-named-same-constraint-stated-from-two-named-perspectives**: orchestrator IS the gatekeeper for enabling new monitors; subagent IS the LLM whose context-window IS the attack surface; the rule is identical but the audience-framing differs.

**§the-named-DRY-discipline-IS-violated-deliberately-for-safety-critical-rules**: most garden documents avoid duplication via cross-reference; the monitoring safety constraint deliberately appears in both files. **§the-named-redundancy-IS-the-named-anti-miss-discipline** for safety-critical rules — stated in both places so neither orchestrator nor subagent can plausibly claim "I didn't see it".

§two-cycles-with-named-monitoring-safety-constraint (cycle 299 in CLAUDE.md + cycle 301 in COMMON.md): same constraint, two ingest cycles. **§the-named-cross-cycle-constraint-recurrence**.

- **§the-named-external-repo-etiquette** (first-explicit-observation):

```
A subagent dispatched into a fork worktree must not initiate, on issues or
pull requests in *any* repository, any of:

- Comments, reviews, or review-comments
- Reactjis
- Cross-references (`Closes endojs/endo#123`, `cc @user` mentions, ...)
- Issue or PR opens, edits, or closes

Exception: the dispatch prompt explicitly authorizes the action.
```

**§the-named-default-deny-on-external-repo-actions**: the subagent's default IS to NOT touch upstream issue trackers; explicit authorization in the dispatch prompt IS required. **§the-named-deny-by-default-allow-by-explicit-authorization**.

§the-named-broad-default-deny-list: comments + reviews + review-comments + reactjis + cross-references + issue/PR opens/edits/closes. **§the-named-comprehensive-coverage-of-side-channels**.

§the-named-Why-section-naming-the-rationale: "Why: the garden runs across many forks. Without this rule, agents would reflexively cross-link 'for context' and create noise across upstream issue trackers." **§the-named-rule-WITH-named-rationale-paragraph** — the document names the rule AND the reason. **§the-named-rationale-prevents-rule-rot**.

- **§the-named-per-role-authorization-table** (first-explicit-observation): the document lists eight roles (fixer + weaver + shepherd + conductor + designer + scout + botanist + major-general) and for each names:
  - what's "implicit in the dispatch" (covered by the dispatch's own framing),
  - what needs "per-action authorization the steward forwards" (separate explicit authorization).

**§the-named-implicit-vs-per-action-authorization-distinction**: a binary classification per role-action pair.

§the-named-eight-named-roles-with-named-authorization-shapes: each row IS a named-implicit-set + named-per-action-set. **§the-named-fine-grained-authorization-discipline**.

§the-named-implicit-IS-named-dispatch-shape-determined: the role's dispatch framing inherently includes some actions (e.g., the fixer's push to the PR branch is implicit in "fix #N"); separate per-action authorizations are needed for adjacent actions (the inline-thread replies + the re-request after CI is green + the top-level summary comment).

- **§the-named-boatman-exception** (first-explicit-observation):

```
The boatman is the documented exception by role: opening the upstream PR and
cross-linking it with the source garden PR is inherent to its job, and the
boatman's dispatch is itself gated on `identity_switch_authorized: true` from
a maintainer. That single authorization implicitly covers the cross-link.
```

**§the-named-single-authorization-covers-cross-link**: the boatman's `identity_switch_authorized: true` IS itself the per-action authorization for the cross-link. **§the-named-one-named-flag-IS-the-named-broad-authorization**.

§the-named-boatman-IS-the-only-role-with-the-cross-repo-write-default-allow: every other role's dispatch defaults to default-deny on external repos; the boatman defaults to default-allow (within the scope of its single authorized cross-link).

- **§the-named-three-stage-authorization-pipeline** (first-explicit-observation):

```
These authorizations originate with the maintainer (typically via the liaison
after user confirmation), are recorded in the bulletin's *Pre-staged
authorizations* section or in a journal `message` entry to the steward, and
the steward inlines them into the dispatch prompt at fire time. The steward
never originates a new authorization; it forwards.
```

**§the-named-originate-record-inline-pipeline** (three named stages): originate (maintainer) → record (bulletin or message entry) → inline (steward at fire time). **§the-named-asymmetric-authorization-origination** — the steward forwards but never originates.

§the-named-authorization-IS-named-paper-trail: every per-action authorization leaves a record in the bulletin or journal. **§the-named-auditable-authorization-discipline**.

§the-named-fire-time-inlining: the steward inlines the authorization into the dispatch prompt at dispatch time (not at record time). **§the-named-late-binding-of-authorization** — the authorization IS recorded in advance but applied at the moment of the dispatch.

- **§the-named-named-authority-structure** (first-explicit-observation):

```
Default technical authority on any repo the garden touches rests with that
repo's maintainer. Some projects have non-default-authority actors: senior
contributors whose review or comment on a topic-matching PR carries
maintainer-equivalent (or greater) weight on the technical question, even
though the garden's authorization chain still routes through the project's
maintainer.
```

**§the-named-senior-contributor-IS-named-non-default-authority-actor**: a senior contributor's technical weight on a topic-matching PR IS named-greater-than-default, but the authorization chain still routes through the maintainer. **§the-named-technical-authority-vs-authorization-chain-distinction**.

§the-named-canonical-place-for-actor-name-IS-the-project-README: actor name + scope topics + practical rule live in `journal/projects/<slug>/README.md`. **§the-named-project-README-IS-the-named-actor-registry**. **§the-named-data-not-in-roles-or-skills-IS-named-locality-discipline**.

§the-named-endo-prototype: erights named as the senior contributor on endo. **§the-named-prototype-pattern-shape** (named-prototype-IS-the-named-example-shape-for-future-projects).

- **§the-named-project-specifics-live-in-the-journal-not-in-roles-or-skills** (first-explicit-observation):

```
Project specifics (repo URLs, fork ownership, account/credential conventions,
project-specific preferences) live in the **journal**, not in role or skill
files. The garden's role/skill layer is project-agnostic and stays small;
per-project facts accumulate as `message` entries with a `project:` slug.
```

**§the-named-three-named-tiers-of-information-locality**: project-agnostic (roles + skills) + project-specific (journal) + per-dispatch (dispatch prompt). **§the-named-locality-shape-determines-the-storage-tier**.

§the-named-grep-recipe-IS-named-self-service-API: "grep -rl '^project: <slug>' journal/entries/" IS the named-find-recipe. **§the-named-recipe-WITH-named-grep-flags**.

§the-named-most-recent-matching-entry-IS-the-current-source-of-truth: "older entries are history." **§the-named-append-only-with-most-recent-wins-semantics**.

- **§the-named-library-IS-three-indexing-axes** (first-explicit-observation):

```
- journal/library/sources/    — by provenance (which upstream document)
- journal/library/topics/     — by broad subject taxonomy
- journal/library/keywords.md + journal/library/concepts/  — by the specific term
```

**§the-named-three-named-indexing-axes**: provenance + taxonomy + term-lookup. **§the-named-multi-axis-knowledge-graph**.

§the-named-the-librarian-IS-self-described: the librarian's own work product (which IS what's being ingested across cycles 282-301) is itself indexed via this three-axis shape. **§the-named-self-referential-shape-of-the-library** — the library catalogues itself.

- **§the-named-skill-rather-than-read-by-eye** (first-explicit-observation):

```
Use the garden/skills/library-lookup/SKILL.md skill rather than reading these
by eye. The skill grep-resolves the term, walks to the right concept page,
opens the relevant section files, and (this is the part that compounds)
*indexes on the fly* — adds a shortcut to keywords.md, prunes a distraction
on a concept page, or drafts a missing concept — so the next reader's search
succeeds where yours did not or succeeds faster than yours did.
```

**§the-named-skill-mediated-access-discipline**: the library IS accessed via a named skill, not via direct read. **§the-named-named-uniform-access-discipline**.

§the-named-index-on-the-fly-IS-the-compounding-property: the library-lookup skill adds shortcuts, prunes distractions, drafts missing concepts as it goes. **§the-named-index-improvements-by-one-role-benefit-every-subsequent-caller-in-every-other-role**. **§the-named-compounding-knowledge-graph**.

§the-named-self-improving-knowledge-graph: each access IS an opportunity to improve the graph. **§the-named-access-IS-a-named-improvement-opportunity**.

- **§the-named-orphan-branch-journal** (first-explicit-observation):

```
The journal is the garden's transcript and message bus. It is a worktree of
the garden repo on an orphan branch. Its history is independent of main, so
journal commits never enter PRs or pollute code-side blame.
```

**§the-named-orphan-branch-IS-the-named-history-isolation-mechanism**: orphan branches in git have no shared ancestors with other branches; a merge between them would be a degenerate combine-all-files merge. **§the-named-orphan-IS-the-named-deliberate-isolation**.

§the-named-isolation-discipline: journal-IS-distinct-from-main; commits to one never appear in the other's history. **§the-named-history-cleanliness-IS-named-orphan-branch-property**.

- **§the-named-bulletin-IS-the-maintainer-dashboard** (first-explicit-observation):

```
The journal's top-level README.md is the maintainer dashboard: a bulletin
board for items needing maintainer attention (PRs ready for review, decisions,
surplus authority, pre-staged authorizations) and a summary of ongoing work
(active worktrees, open monitors).
```

**§the-named-journal-README-IS-the-bulletin**: a single document serves as the dashboard. **§the-named-single-pane-of-glass**.

§the-named-agents-own-the-bulletin-entirely: "they post when an item arises and they clear it once the underlying condition is resolved (typically during the steward's per-cycle close)." **§the-named-bulletin-lifecycle-IS-named-post-then-clear**. **§the-named-self-clearing-shape**.

§the-named-maintainer-acts-and-agents-detect-and-clear: the maintainer reads the bulletin and acts in the upstream system; agents detect the action and clear. **§the-named-action-IS-out-of-band-detection-IS-in-band**.

- **§the-named-journal-archives-terminated-long-living-subagents** (first-explicit-observation):

```
The journal also archives terminated long-living subagents under agents/,
indexed by date / role / subject matter for future consultation.
```

**§the-named-agent-archive-IS-named-by-three-axes** (date + role + subject). **§the-named-grep-recipe-for-the-archive** (consult by grepping report frontmatter).

§the-named-skill-named-agent-termination: the termination-report writing IS encoded as a named skill (`skills/agent-termination/SKILL.md`). **§two-cycles-with-named-skill-for-meta-procedure** (e.g., journal-sync + agent-termination).

- **§the-named-entry-layout-IS-named-six-component-filename** (first-explicit-observation):

```
journal/entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-<kind>-<role>-<short-id>.md
```

**§the-named-six-named-components**: YYYY + MM + DD + HHMMSS + kind + role + short-id (plus the implicit `.md` extension). **§the-named-hierarchical-by-date + named-filename-by-time-kind-role-id**.

§the-named-short-id-IS-6-hex-chars: "random or from your session id. Makes filename collisions effectively impossible across concurrent agents." **§three-cycles-with-6-hex-short-id-discipline** (297 named the format + 298 implemented it via `openssl rand -hex 3` + 301 names its purpose as collision-avoidance-across-concurrent-agents). **§the-named-6-hex-IS-cross-document-consistent**.

§the-named-collision-avoidance-IS-the-named-purpose: 16,777,216 values; the named-birthday-bound for collisions is at ~4,096 concurrent entries; effectively impossible for the garden's scale. **§the-named-collision-IS-effectively-impossible** is named-precise-not-marketing.

- **§the-named-five-named-entry-kinds** (first-explicit-observation): dispatch + tick + message + result + worktree. The document names the canonical set of `kind:` field values. **§the-named-discrete-finite-state-set**.

§the-named-five-discrete-entry-kinds: the journal IS structured around these five kinds. **§the-named-kind-IS-named-named-relationship-class**.

- **§the-named-broadcast-to-IS-the-asterisk** (first-explicit-observation): `to: "*"` IS the broadcast target; a role name IS a directed message. **§the-named-asterisk-IS-the-broadcast-marker**. **§the-named-string-overload-shape** (the `to:` field accepts either a role name or `"*"`).

§the-named-grep-recipe-for-messages-to-your-role: `grep -rl 'to: <your-role>\|to: "\*"' journal/entries/$(date -u +%Y/%m/%d)/` — the document names the recipe. **§the-named-OR-grep-pattern-for-both-directed-and-broadcast**.

- **§the-named-project-field-IS-optional-but-recommended** (first-explicit-observation): "enables `grep -l '^project: <slug>' ...` to recover all entries for a project." **§the-named-grep-by-frontmatter-discipline**.

§the-named-project-slug-IS-kebab-case-upstream-not-fork-owner: "endo, agoric-sdk", NOT the fork owner. **§the-named-canonical-upstream-name-IS-the-slug**. **§the-named-disambiguation-discipline** (the fork owner can vary across hosts; the upstream name does not).

- **§the-named-worktree-field-IS-named-by-shape** (first-explicit-observation): per-dispatch project worktrees: dispatch-root-relative; standing worktrees (monitor watch dirs): long-lived `worktrees/<owner>-<repo>/<name>/` path. **§the-named-distinct-worktree-path-shapes-for-distinct-worktree-lifetimes**.

§two-named-worktree-path-shapes: ephemeral (dispatch-root-relative) + standing (long-lived absolute-style). **§the-named-path-shape-encodes-lifetime**.

- **§the-named-journal-sync-skill-IS-the-named-anti-divergence-mechanism** (first-explicit-observation):

```
Follow garden/skills/journal-sync/SKILL.md. It handles the detached-HEAD
fetch/rebase/push retry loop. Do not roll your own; concurrent appends across
orchestrator turns and parallel dispatches are subtle and the skill is the
single source of truth.
```

**§the-named-DO-NOT-roll-your-own-concurrent-append**: explicit anti-pattern naming. **§the-named-canonical-skill-IS-the-named-single-source-of-truth**.

§the-named-concurrent-appends-IS-named-subtle: the named-difficulty IS named-acknowledged. **§the-named-honest-difficulty-claim** vs the more common "it's simple, just push".

- **§the-named-three-named-reading-recipes** (first-explicit-observation):

```
- Overview: git -C journal log --since='1 hour ago' --pretty='%h %s'
- Messages addressed to your role: grep -rl 'to: <your-role>\|to: "\*"' ...
- A specific prior entry referenced from your dispatch: read the path verbatim
```

**§three-named-distinct-reading-recipes** (overview + role-directed + specific-path). **§the-named-recipe-per-query-shape**.

§the-named-grep-recipe-IS-named-with-named-flags: the recipes name the flags (`--since`, `-rl`, `--pretty='%h %s'`). **§the-named-explicit-flag-discipline**.

- **§the-named-worktree-triple-IS-ephemeral** (first-explicit-observation):

```
Your per-dispatch worktree triple is ephemeral; do not store anything you
need to survive the dispatch outside the journal.
```

**§the-named-ephemeral-worktree-discipline**. **§the-named-only-journal-survives-dispatch-teardown**.

§the-named-`.garden-monitor/`-naming-discipline: role-private high-frequency state (polling caches, scratch files) lives in `.garden-monitor/<repo>/`, never committed to upstream. **§the-named-dot-prefix-IS-named-untracked-state**.

- **§the-named-standing-monitor-exception** (first-explicit-observation):

```
The standing-monitor exception: a small number of long-lived
worktrees/<owner>-<repo>/watch-<slug>--monitor--<ts>/ checkouts persist across
dispatches because their .garden-monitor/<repo>/ state is owned by a bash
daemon that runs continuously. These are referenced by the daemon, not by you;
do not write to them from an LLM dispatch.
```

**§the-named-daemon-owned-state-survives-dispatch-teardown**: the named-exception-IS-the-named-bash-daemon-not-the-LLM. **§the-named-LLM-vs-daemon-ownership-distinction**.

§two-cycles-with-named-standing-exception (297 WORKTREES.md named the exception + 301 COMMON.md restates it from the subagent's perspective). **§the-named-cross-document-standing-exception**.

- **§the-named-do-not-rename-move-or-remove-worktree** (first-explicit-observation):

```
Do not rename, move, or remove any worktree. Lifecycle is the orchestrator's
job; per-dispatch teardown happens via skills/dispatch-worktree/dispatch-teardown.sh
when you return.
```

**§the-named-do-not-modify-worktree-shape-from-subagent**. **§the-named-orchestrator-owns-the-worktree-lifecycle**.

- **§the-named-journal-worktrees-host-index** (first-explicit-observation):

```
journal/worktrees/$(hostname -s)/<worktree-basename>.md
```

**§the-named-per-host-worktree-index**: each host has its own worktree-index directory. **§the-named-hostname-as-the-index-key**.

§the-named-`last_heartbeat`-and-`status`-update-discipline: "Read it on start to learn your purpose, role, repo, branch, and any PRs you are bound to. Update last_heartbeat and status there per the lifecycle in journal/worktrees/README.md." **§the-named-heartbeat-IS-named-liveness-marker**.

- **§the-named-result-entry-AND-final-message** (first-explicit-observation):

```
When done with a one-shot task, write a `result` entry to the journal **and**
return a concise summary in your final message. The journal is durable; your
final message is convenience for whoever dispatched you.
```

**§the-named-dual-channel-reporting**: journal-as-durable + final-message-as-convenience. **§the-named-two-named-reporting-channels**.

§the-named-durable-vs-convenience-distinction: the journal IS the long-term record; the final message IS the immediate signal. **§the-named-temporal-asymmetry-of-the-two-channels**.

- **§the-named-mandatory-`Self-improvement:`-one-line** (first-explicit-observation):

```
Both end with a one-line `Self-improvement: ...` per
garden/skills/self-improvement/SKILL.md (or `Self-improvement: nothing this
time.`).
```

**§the-named-mandatory-meta-improvement-line**: every result entry AND every final message ends with the Self-improvement line. **§the-named-explicit-named-null-shape** ("Self-improvement: nothing this time."). **§the-named-mandatory-field-with-explicit-null**.

§the-named-meta-improvement-discipline: every engagement IS an opportunity to surface a structural lesson. **§the-named-continuous-improvement-discipline**.

- **§the-named-message-on-interruption-or-blocker** (first-explicit-observation):

```
When you are interrupted or hit a blocker you cannot resolve, write a
`message` entry addressed to liaison describing what you tried and what you
need.
```

**§the-named-blocker-escalation-path**: the named-escalation-target IS the liaison. **§the-named-mid-dispatch-escalation-shape**.

§the-named-named-tried-vs-named-need: the message must describe BOTH what the subagent tried AND what it needs. **§the-named-failure-message-IS-named-tried-plus-need-pair**.

- **§the-named-cycle-301-IS-the-named-sixth-garden-source-and-the-third-cycle-of-the-second-hundred-after-300-milestone** (first-explicit-observation): the librarian work continues immediately after the named-three-hundredth-cycle-milestone (cycle 300). **§the-named-post-milestone-continuation**: there IS no pause after 300; the cadence continues. **§the-named-cadence-IS-the-named-unbroken-discipline**.

## Cross-cycle pattern accumulation

- **§six-cycles-with-garden-repo-source-ingest**: 281 + 297 + 298 + 299 + 300 + 301.
- **§six-named-shapes-of-garden-self-documentation**: proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions.
- **§two-named-shapes-of-load-first-instructions**: auto-load (CLAUDE.md) + explicit-load (COMMON.md / AGENT.md / SKILL.md).
- **§four-cycles-with-named-role-as-author-shape**: 281 + 297 + 299 + 301 (now COMMON.md too: `author: gardener, liaison`).
- **§two-cycles-with-named-`---` YAML-frontmatter-with-three-fields**: 299 CLAUDE.md + 301 COMMON.md (created + updated + author).
- **§two-named-statements-of-the-same-monitoring-safety-constraint**: 299 CLAUDE.md (orchestrator framing) + 301 COMMON.md (subagent framing).
- **§three-cycles-with-6-hex-short-id-discipline**: 297 named the format + 298 implemented it via `openssl rand -hex 3` + 301 names its purpose as collision-avoidance-across-concurrent-agents.
- **§two-cycles-with-named-standing-exception**: 297 WORKTREES.md + 301 COMMON.md.
- **§two-named-frontmatter-shapes-in-the-garden**: persistent-doc-shape (created + updated + author) + journal-entry-shape (ts + kind + role + worktree + repo + project + to + refs).
- **§the-named-six-cycle-bridge**: 296 (cluster-bridge end) + 297 (WORKTREES.md) + 298 (scripts pair) + 299 (CLAUDE.md) + 300 (daemons triple) + 301 (COMMON.md). The largest single-repo cluster in the library.
- **§two-cycles-with-named-skill-mediated-access**: cycle 299 named monitoring + cycle 301 named library-lookup as the canonical access discipline.
- **§the-named-discipline-design-and-instance-pair-across-two-cycles**: 299 names the auto-load-avoidance discipline; 301 IS the document that the rule shapes.

## Notes

- Cycle 301 IS the **first cycle after CYCLE-MILESTONE-300**; the cadence continues unbroken into the next hundred.
- The six-cycle garden-meta cluster (281+297+298+299+300+301) IS now the library's largest single-repo cluster.
- Four of the six garden ingests are now documentation files; one IS implementation source (298 dispatch-prepare/teardown); one IS operational daemon control (300 daemons). **§the-named-six-into-four-doc-and-one-source-and-one-operational split**.
- COMMON.md IS the **subagent's framing** of standing instructions; CLAUDE.md IS the **orchestrator's framing**; AGENT.md files are **role-specific framings**. **§the-named-three-tiered-document-by-audience-shape**.
- The monitoring safety constraint IS the only rule deliberately duplicated across CLAUDE.md and COMMON.md. The duplication IS named-deliberate-anti-miss-discipline for safety-critical rules. **§the-named-DRY-IS-violated-deliberately**.
- The named-library-IS-three-indexing-axes (sources + topics + keywords/concepts) IS the architecture the librarian's own cycles 282-301 work product instantiates. **§the-named-COMMON.md-describes-the-shape-of-the-very-work-its-current-ingest-cycle-extends**. **§the-named-self-referential-shape**.
