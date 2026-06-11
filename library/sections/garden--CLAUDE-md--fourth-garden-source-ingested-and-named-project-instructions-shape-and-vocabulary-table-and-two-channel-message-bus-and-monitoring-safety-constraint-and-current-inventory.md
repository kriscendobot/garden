---
title: "kriskowal/garden/CLAUDE.md — fourth garden source ingested; the named-project-instructions shape; the named-vocabulary-table with ten dispatch verbs; the named-two-channel-message-bus (per-role-inbox + job-board); the named-monitoring-safety-constraint as named-prompt-injection-defense; the named-current-inventory shape"
section-slug: garden--CLAUDE-md--fourth-garden-source-ingested-and-named-project-instructions-shape-and-vocabulary-table-and-two-channel-message-bus-and-monitoring-safety-constraint-and-current-inventory
source-slug: garden--CLAUDE-md
url: https://github.com/kriskowal/garden/blob/main/CLAUDE.md
authors: [Endo project (collective; the garden's named-role-as-author convention; current-frontmatter authors = gardener + liaison + builder)]
status: (no explicit metadata table; YAML frontmatter declares created/updated/author)
ingest-cycle: 299
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 146
---

# `kriskowal/garden/CLAUDE.md` (current live version)

A 146-line document — the garden's project instructions read by every Claude Code session at the garden root. **The fourth garden source ingested** (after cycle 281 designs/driver.md, cycle 297 WORKTREES.md, cycle 298 scripts pair). **§four-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299). **§the-named-four-shapes-of-garden-self-documentation** (proposed-design + standing-reference + implementation-source + project-instructions).

## §the-named-project-instructions-shape (first-explicit-observation)

The file IS named `CLAUDE.md` (not AGENT.md or SKILL.md). **§the-named-Claude-Code-auto-load-convention**: Claude Code auto-loads `CLAUDE.md` files into the agent's context; that's *exactly* what the garden wants at the root (liaison gets the project instructions) but NOT what it wants for roles/skills (subagents should load those explicitly).

The file's own line 26 names this: *"Files are named `AGENT.md` / `SKILL.md` / `COMMON.md` (not `CLAUDE.md`) on purpose: we do **not** want Claude Code to auto-load them into a subagent's context."* **§the-named-naming-convention-IS-the-named-discipline-against-auto-load**.

§the-named-discriminating-via-filename: which files get auto-loaded by Claude Code vs which get loaded explicitly IS named *by the filename extension* (`CLAUDE.md` auto + `AGENT.md` explicit).

## §the-`---` YAML frontmatter with named-multi-author-attribution (first-explicit-observation)

```yaml
---
created: 2026-05-12
updated: 2026-06-10
author: gardener, liaison, builder
---
```

**§the-named-multi-role-author-attribution-extends-cycle-281's-pattern**: cycle 281 noted multi-author (gardener + fixer + designer); cycle 297 noted single-author (liaison); cycle 299 confirms multi-role is the canonical shape. **§three-cycles-with-named-role-as-author-shape** (281 + 297 + 299).

§the-named-author-list-has-changed-since-cycle-281: cycle 281's author list was gardener+fixer+designer; cycle 299's IS gardener+liaison+builder. **§the-named-author-list-evolves-with-the-document**.

## §the-named-snapshot-vs-live-CLAUDE-md (first-explicit-observation)

Cycle 297's WORKTREES.md was read from a *May 2026 snapshot* worktree; the corresponding CLAUDE.md in that snapshot (97 lines) IS distinct from the *current live version* (146 lines). **§the-named-source-evolution-via-monitor-worktree**: the standing monitor worktree captures a snapshot; the live garden directory has the current state. **§the-named-two-versions-of-the-same-file-coexist-in-the-garden's-filesystem**.

§the-named-49-line-delta from May to June 2026: ~33% growth driven by (per the file content):
- Addition of the §vocabulary-table (~17 lines)
- Addition of the §Boatman-dispatches-and-host-preconditions section
- Addition of the §Monitoring-safety-constraint section
- Expansion of the §Current-inventory list (more roles + skills)

**§the-named-organic-growth-of-project-instructions**: the file IS not designed to stay short; it grows as the project's vocabulary IS articulated.

## §the-named-vocabulary-table (first-explicit-observation)

A 9-row Markdown table named `### Orchestrator vocabulary` listing direct-dispatch verbs:

| Phrase | What it means |
|---|---|
| **the gamut** / **run the gamut on #N** | the PR-creation-flow chain end to end |
| **ferry #N** / **carry #N upstream** | dispatch boatman |
| **shepherd #N** | dispatch shepherd |
| **judge #N** / **panel #N** | dispatch judge |
| **build #N** | dispatch builder |
| **probe #N** | dispatch builder under gap-revealing-build |
| **design X** / **propose X** / **spec X** | dispatch designer |
| **fix #N** | dispatch fixer |
| **retcon #N** | dispatch fixer for net-diff-invariant reset |
| **weave #N** / **rebase #N** | dispatch weaver |
| **merge #N** | dispatch conductor |

**§the-named-shorthand-vocabulary-table-IS-the-named-DSL-for-orchestrator-instructions** (first-explicit-observation): the maintainer doesn't say "dispatch the boatman to ferry PR #123 upstream"; they say "ferry #N". The table IS the *named domain-specific language* the maintainer + orchestrator share.

§eleven-named-direct-dispatch-verbs (counting variants as one verb). §the-named-multi-verb-rows ("the gamut / run the gamut on #N"; "ferry #N / carry #N upstream") — the verb has *multiple equivalent phrasings*.

§the-named-`#N`-IS-the-PR-number convention: every PR-related verb takes `#N` as its argument. **§the-named-canonical-argument-shape-IS-`#N`-for-pull-requests**.

§the-named-disambiguation: "ferry" IS *the maintainer's preferred verb (reaffirmed 2026-05-14)" — naming WHICH verb in a multi-verb set IS the canonical form.

## §the-named-two-channel-message-bus (first-explicit-observation)

> "Holds the garden's transcript and acts as the **two-channel message bus** between agents: a per-role inbox (`journal/inboxes/<host>/<role>.md`; drained via `skills/inbox-drain/SKILL.md`) for directed communication, and a **job board** (`journal/jobs/`; contract at [`journal/jobs/README.md`](journal/jobs/README.md); skill at [`skills/job-board/SKILL.md`](skills/job-board/SKILL.md)) for work items that any eligible consumer can race to claim via git push as the serialization point."

**§two-named-channels-in-the-message-bus**: per-role-inbox + job-board. **§the-named-two-channel-shape**: inbox IS *directed* (one named recipient); job-board IS *broadcast-with-race* (any eligible consumer).

§the-named-git-push-as-the-serialization-point: the race-to-claim resolves via the remote's git-push-ordering, not via an explicit lock. **§the-named-git-as-the-coordination-primitive** — sibling-pattern to cycle 297's §the-named-detached-HEAD-eliminates-the-branch-singleton-contention; both patterns offload coordination to git's own primitives.

§the-named-concurrent-stewards-across-hosts-and-within-one-host-are-both-honored: §the-named-no-coordination-required-beyond-git.

## §the-named-job-board-claim-race as named-coordination-shape (first-explicit-observation)

> "A producer posts a job to `journal/jobs/open/` via `skills/job-board/post-job.sh`; eligible consumers race to claim via `skills/job-board/claim-job.sh`. The git push to `origin/journal` is the serialization point; rejected claims back off without retry."

**§the-named-producer-consumer-pattern-via-git**: posting + claiming. **§the-named-back-off-without-retry**: if your push IS rejected, you give up + move on. **§the-named-no-retry-no-deadlock**: rejected claims don't queue up; they just disappear.

§the-named-`/clear`-survival-property: "survives `/clear` of the consumer between jobs because the per-job substance never enters the consumer's parent context." **§the-named-context-window-decoupling-via-job-board**.

## §the-named-Boatman-host-preconditions (first-explicit-observation)

> "Boatman dispatches must be issued from the host that holds the kriskowal credentials (`kmkmbp2021` as of 2026-05-14). A liaison on `endolinbot` refuses to originate a boatman dispatch and asks the user to re-issue from the credentialed host; the bot identity does not have kriskowal credentials and cannot ferry upstream."

**§the-named-host-precondition-IS-the-named-credential-gating-discipline**. **§the-named-second-line-of-defense**: the boatman's own *Host preconditions* norm IS the *second* check; the orchestrator IS the first.

§the-named-credentials-locality-IS-a-named-security-property: kriskowal credentials only live on `kmkmbp2021`; other hosts cannot ferry upstream by construction.

§the-named-blast-radius-warning: "widening the bot host's blast radius by landing kriskowal credentials there is a separate decision with security implications." **§the-named-deliberate-credential-isolation IS the named security-by-default**.

## §the-named-monitoring-safety-constraint (first-explicit-observation)

> "Only repositories whose comments and pull requests are gated against untrusted contributors are safe to monitor; anything else exposes the steward and its subordinates to text that an untrusted actor can write, which is a prompt-injection hazard for any role that reads a daemon tail or follows a `NEW` line to its source."

**§the-named-prompt-injection-as-named-cross-cutting-hazard**: the document explicitly names *prompt injection* as the named risk model. **§the-named-LLM-context-as-named-attack-surface**.

§the-named-allowlist-discipline: "As of 2026-05-13 only `endojs/endo-but-for-bots` meets this bar in the garden's active set". **§the-named-explicit-allowlist**: only-one-repo on the named allowlist; everything else IS disallowed by default.

§the-named-two-surface-monitoring-constraint: §event-level surveillance (daemons reading `NEW` lines) + §content-level surveillance (parent-context @-mention monitor). **§two-named-surveillance-surfaces with the-named-same-safety-constraint applied to both**.

§the-named-explicit-maintainer-authorization-required-for-additions: §the-named-process-for-widening-the-allowlist. **§the-named-defensive-default-with-explicit-opt-in**.

## §the-named-current-inventory shape (first-explicit-observation)

The file ends with `## Current inventory` listing every role and every skill. **§the-named-inventory-as-the-named-self-index**: the project instructions list EVERY role + skill by name.

§the-named-meta-discipline: the project instructions IS its own index. The maintainer/agent can grep CLAUDE.md to find every named-thing-the-garden-knows-about.

§the-named-narrative-around-the-inventory: each addition + retirement IS named in prose. The `general-contractor` was *retired 2026-06-03*; the `researcher` was *added 2026-06-03*; the prior single `judge` *split into three on 2026-05-21*. **§the-named-versioned-role-set** IS narrated in the inventory, not just listed.

§the-named-jury-seat-roles-are-NOT-orchestrator-dispatchable: the inventory names twenty-nine roles + clarifies "the orchestrator never dispatches a juror seat directly". **§the-named-meta-distinction-between-orchestrator-dispatchable-and-internal**.

§the-named-twenty-nine-roles + ~75-skills as a sized cluster: §the-named-large-named-vocabulary.

## §the-named-references-shelf (first-explicit-observation)

> "`references/`: read-only shelves of roles and skills imported from other gardens. Browsed by the liaison when a user prompt has no obvious fit in the active library, never auto-loaded by subagents."

**§the-named-foreign-shelves IS-distinct-from-active-library**: the garden imports + names *external* artifacts as references, but doesn't auto-use them. **§the-named-browse-on-demand-discipline**.

§the-named-read-only-IS-a-named-constraint: references can't be edited (would mean we're authoring something foreign).

## §the-named-monitor-garden-IS-the-named-asymmetric-monitor (first-explicit-observation)

> "Per-project monitor reaction skills (`monitor-endo`, `monitor-endo-but-for-bots`, `monitor-agoric-sdk`, `monitor-cosgov`, `monitor-garden`) live alongside but are configuration for the `monitor` role rather than independently reusable procedures. `monitor-garden` is the only one whose dispatched subagent runs as `liaison` rather than `monitor`; see that skill's *Dispatch role asymmetry* for why."

**§the-named-asymmetric-role-dispatch**: most monitor-X skills dispatch a `monitor`; `monitor-garden` dispatches a `liaison`. **§the-named-meta-monitor-IS-itself-the-orchestrator**.

§the-named-self-monitoring-discipline: monitoring the garden ITSELF IS done by the liaison (the role that *owns* the garden), not by the generic monitor role. **§the-named-self-reflexive-shape**.

## §the-named-two-route-work-distribution (first-explicit-observation)

> "Work reaches the steward (or a driver lane via its role-specific job board) through one of two routes: Job-board claim (the 2026-05-18 default for work items) [or] Direct dispatch via `Agent` (still the right shape for in-session liaison work and per-cycle steward scans)."

**§two-named-work-distribution-routes**: job-board-claim (producer-consumer) + direct-dispatch-via-Agent (orchestrator-runs). **§the-named-two-routes-honor-different-purposes**.

§the-named-default-with-named-exception: job-board IS the *default for work items*; direct-dispatch IS still right for in-session liaison work + per-cycle steward scans.

§the-named-dated-default-discipline: "the 2026-05-18 default". §the-named-date-of-the-default IS the named historical-anchor.

## §the-named-named-model-tier-discipline (first-explicit-observation)

> "Invoke `Agent` with a prompt that names `DISPATCH_ROOT` explicitly, and pass the model tier from `skills/model-selection/SKILL.md` as the `model` parameter (the model that is adequate to the task; the table makes the choice canonical so it does not drift across thirty-plus role files)."

**§the-named-model-selection-IS-a-named-skill**: not inlined per-role; named centralized. **§the-named-canonical-choice-IS-a-named-anti-drift-mechanism**.

§the-named-thirty-plus-role-files: the count IS named explicitly. **§the-named-DRY-discipline-via-named-central-table**.

## Patterns from prior cycles, reaffirmed

- **§four-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299).
- **§the-named-four-shapes-of-garden-self-documentation** (proposed-design 281 + standing-reference 297 + implementation-source 298 + project-instructions 299).
- **§three-cycles-with-named-role-as-author-shape** — cycle 281 multi-author + cycle 297 single-author + cycle 299 multi-author (gardener + liaison + builder).
- **§the-named-detached-HEAD-discipline IS-extended-by-cycle-299's-job-board-claim-race**: both leverage git's own coordination primitives.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-named-project-instructions-shape + §the-named-Claude-Code-auto-load-convention + §the-named-naming-convention-IS-the-named-discipline-against-auto-load + §the-named-discriminating-via-filename + §the-`---`-YAML-frontmatter-with-named-multi-author-attribution + §the-named-author-list-evolves-with-the-document + §the-named-snapshot-vs-live-CLAUDE-md + §the-named-source-evolution-via-monitor-worktree + §the-named-two-versions-of-the-same-file-coexist-in-the-garden's-filesystem + §the-named-organic-growth-of-project-instructions + §the-named-vocabulary-table + §the-named-shorthand-vocabulary-table-IS-the-named-DSL-for-orchestrator-instructions + §eleven-named-direct-dispatch-verbs + §the-named-multi-verb-rows + §the-named-`#N`-IS-the-PR-number-convention + §the-named-canonical-argument-shape-IS-`#N`-for-pull-requests + §the-named-disambiguation-of-preferred-verbs + §the-named-two-channel-message-bus (per-role-inbox + job-board) + §two-named-channels-in-the-message-bus + §the-named-git-push-as-the-serialization-point + §the-named-git-as-the-coordination-primitive + §the-named-no-coordination-required-beyond-git + §the-named-job-board-claim-race + §the-named-producer-consumer-pattern-via-git + §the-named-back-off-without-retry + §the-named-no-retry-no-deadlock + §the-named-`/clear`-survival-property + §the-named-context-window-decoupling-via-job-board + §the-named-Boatman-host-preconditions + §the-named-second-line-of-defense + §the-named-credentials-locality-IS-a-named-security-property + §the-named-blast-radius-warning + §the-named-deliberate-credential-isolation + §the-named-monitoring-safety-constraint + §the-named-prompt-injection-as-named-cross-cutting-hazard + §the-named-LLM-context-as-named-attack-surface + §the-named-allowlist-discipline + §the-named-explicit-allowlist + §two-named-surveillance-surfaces + §the-named-explicit-maintainer-authorization-required-for-additions + §the-named-defensive-default-with-explicit-opt-in + §the-named-current-inventory-shape + §the-named-inventory-as-the-named-self-index + §the-named-narrative-around-the-inventory + §the-named-versioned-role-set + §the-named-jury-seat-roles-are-NOT-orchestrator-dispatchable + §the-named-meta-distinction-between-orchestrator-dispatchable-and-internal + §the-named-references-shelf + §the-named-foreign-shelves-IS-distinct-from-active-library + §the-named-browse-on-demand-discipline + §the-named-read-only-IS-a-named-constraint + §the-named-monitor-garden-IS-the-named-asymmetric-monitor + §the-named-self-monitoring-discipline + §the-named-self-reflexive-shape + §the-named-two-route-work-distribution + §two-named-work-distribution-routes + §the-named-default-with-named-exception + §the-named-dated-default-discipline + §the-named-model-selection-IS-a-named-skill + §the-named-canonical-choice-IS-a-named-anti-drift-mechanism + §the-named-thirty-plus-role-files + §the-named-DRY-discipline-via-named-central-table — all sixty-two first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §four-cycles-with-garden-repo-source-ingest (281 + 297 + 298 + 299) + §the-named-four-shapes-of-garden-self-documentation + §three-cycles-with-named-role-as-author-shape (281 + 297 + 299) + §the-named-git-as-the-coordination-primitive generalizes cycle 297's §the-named-detached-HEAD-eliminates-the-branch-singleton-contention.
- **Tier 3 (multi-cycle pattern recognition)**: §the-named-meta-document-IS-the-named-Claude-Code-auto-load-handle + §two-named-instances-of-leveraging-git-as-coordination (cycle 297 + cycle 299) + §the-named-large-named-vocabulary (~29 roles + ~75 skills).

## Synthesis target

Slot machine library `@game/CLAUDE.md`: YAML frontmatter with multi-role authors; named-project-instructions shape (auto-loaded by Claude Code at the project root); named-vocabulary-table with direct-dispatch verbs (e.g., "spin", "settle", "payout", "rollback") as a named-DSL; named-two-channel message bus (per-table inbox + global tournament job-board with git-push-as-serialization); named-host-precondition for upstream-credential operations; named-monitoring-safety-constraint naming prompt-injection as the threat-model; named-allowlist of safe-to-monitor game-tables; named-current-inventory as named-self-index; named-references-shelf for borrowed game-engine patterns; named-asymmetric-role-dispatch for meta-monitoring; named-two-route-work-distribution (job-board default + direct-dispatch for in-session); named-model-tier-selection via named-skill (anti-drift via central table).

## Single most structurally interesting move

**§the-named-two-channel-message-bus** combined with **§the-named-git-push-as-the-serialization-point** — the journal acts as the named *message bus* between agents, with two named channels: a per-role inbox (directed) and a job board (broadcast-with-race). The race-to-claim resolves via the remote's `git push origin journal` ordering, not via an explicit lock or queue server. **§the-named-git-as-the-coordination-primitive**.

This extends cycle 297's **§the-named-detached-HEAD-eliminates-the-branch-singleton-contention** to a broader pattern: the garden uses git's built-in primitives (atomic ref updates, push-rejection-on-non-fast-forward) for *all* its concurrency control. There IS no Redis, no PostgreSQL, no Kafka, no message-queue service. **§the-named-coordination-via-git-only-discipline**.

The pattern generalizes to any orchestration system that already has a shared git repo: free coordination primitive via the remote. Push success IS atomic; push rejection IS the "back-off" signal; the journal branch IS the durable record. §two-named-instances-of-leveraging-git-as-coordination across cycles (297 + 299).

§the-named-no-additional-infrastructure-required-discipline: the garden runs on bash + git + Claude Code. The two-channel message bus runs on the same git infrastructure that holds the journal. §the-named-zero-dependency-coordination.
