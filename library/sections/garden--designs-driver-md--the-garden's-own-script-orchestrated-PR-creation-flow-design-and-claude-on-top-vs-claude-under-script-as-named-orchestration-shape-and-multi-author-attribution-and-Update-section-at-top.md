---
title: "garden/designs/driver.md — the garden's own script-orchestrated PR-creation flow design + claude-on-top vs claude-under-script as named orchestration shape + multi-author attribution + Update section at top + the garden's design-doc format distinct from endo-but-for-bots + seven named job kinds + scripts/ top-level directory convention"
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `garden/designs/driver.md` — the garden's own architectural design

A 691-line **garden-internal design** for the script-orchestrated PR-creation flow. **The first design from the garden's own repository ingested.** Status: **Proposed** (second Proposed instance observed after cycle 279); Created 2026-05-29; Updated 2026-06-04; Authors: gardener + fixer + designer.

§First-explicit-observation in library: **§the-first-design-from-the-garden's-own-repository-ingested — §the-library-now-includes-a-design-from-the-host-meta-repository-not-just-the-projects-the-garden-serves + §two-cycles-with-meta-ingest (cycle 265's endo-but-for-bots `designs/CLAUDE.md` was metalanguage about endo-but-for-bots designs; cycle 281's garden `designs/driver.md` is the garden's own self-design)**.

## §The garden's design-doc format distinct from endo-but-for-bots

The garden's metadata table differs from the endo-but-for-bots template (cycle 265's CLAUDE.md spec):

```
| Created | 2026-05-29 |
| Updated | 2026-06-04 |
| Author  | gardener, fixer, designer |
| Status  | Proposed   |
```

§Compared to endo-but-for-bots's:
```
| **Created** | YYYY-MM-DD |
| **Updated** | YYYY-MM-DD |
| **Author** | Name (prompted) |
| **Status** | Not Started |
```

§Three-named-differences-in-the-garden's-design-doc-format:
1. **Field names are NOT bold** — `| Created |` not `| **Created** |`.
2. **No `(prompted)` suffix on the Author** — the garden uses agent-role-names directly (gardener + fixer + designer).
3. **Multi-author named with comma-separated list** — three named roles as authors of a single document.

§First-explicit-observation in library: **§the-garden's-design-doc-format-IS-distinct-from-the-endo-but-for-bots-design-doc-format + §two-design-doc-format-conventions-now-observed (endo-but-for-bots + garden) + §the-cluster's-formats-IS-not-universal**.

§First-explicit-observation in library: **§multi-author-attribution-by-role-name-as-named-discipline — §the-garden-treats-roles-as-authors-not-just-as-agent-context-fragments + §three-named-roles (gardener + fixer + designer) authored this design + §the-attribution-IS-collective-not-individual**.

§Sibling-pattern to many open-source projects where commits are co-authored — but here the attribution IS at the design-doc level not the commit level; §the-roles-are-the-authors-the-PR-mechanism-IS-the-attribution-vehicle.

## §The Update section at top — named time-stamped amendment

Lines 8-18 carry a §named-Update-section before the canonical sections:

> *## Update — 2026-06-03 contractor retirement*
>
> *The `general-contractor` posture this design originally proposed to *preserve through the migration* (per the Migration plan and several § Architecture references below) was **retired** on 2026-06-03 per the maintainer's directive: "I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver."*

§First-explicit-observation in library: **§the-`## Update — YYYY-MM-DD <topic>`-section-at-top-as-named-time-stamped-amendment — §the-design's-Status-IS-Proposed-AND-already-has-a-named-amendment + §the-amendment-IS-explicit-not-a-rewrite + §the-content-after-the-amendment-says-"the rest of the design stands"-naming-which-parts-survive-and-which-don't**.

§The-amendment-cites-the-maintainer's-directive-verbatim — §First-explicit-observation in library: **§maintainer-directive-cited-verbatim-as-named-evidence-of-change — §the-quote-IS-rendered-as-a-named-source + §the-design-document-IS-its-own-changelog**.

§Sibling-pattern to cycle 279's §the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected — §three-cycles-with-design-acknowledging-its-own-evolution (269 Chat-becoming-the-debugger-of-last-resort + 279 cli-edit-framing-correction-via-PR-#162 + 281 contractor-retirement-via-maintainer-directive).

§First-explicit-observation in library: **§three-cycles-with-design-acknowledging-its-own-evolution-within-the-document — §the-evolution-IS-named-explicitly + §the-named-cause-(reviewer + maintainer-directive)-IS-cited + §the-document-IS-its-own-changelog**.

## §The "claude-on-top vs claude-under-script" framing

Lines 161-187 carry the §two-named-orchestration-shapes:

- **claude-on-top** — the steward and contractor wake on cron, run an LLM tick to scan state, and dispatch subagents via `Agent`. Every quiet cycle burns LLM tokens.
- **claude-under-script** — a bash script drives a state machine and delegates judgment-bearing substeps to claude via `claude -p`. Deterministic steps are no-LLM.

§First-explicit-observation in library: **§the-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-distinction — §two-named-orchestration-shapes-with-an-explicit-pivot-between-them + §the-design-NAMES-the-shapes-not-just-the-mechanisms + §the-shape-vocabulary-IS-the-design's-rhetorical-anchor**.

§Sibling-pattern to many systems-architecture distinctions (e.g., interpreter-on-top vs. compiler-under; declarative vs. imperative); §the-discipline-IS-name-the-shape-not-just-the-pattern.

§The-pivot-IS-not-just-implementation-it-IS-a-named-shape-change — §the-design-claims-an-architectural-inversion-not-a-refactor.

## §Three named observable costs from a single day

Lines 169-173 carry §three-named-observable-costs-from-2026-05-29:

1. **28-minute gap on PR #376** — kriskowal `COMMENTED` at 05:01:20Z; steward acted at 05:29Z.
2. **50-minute weaver hand-off on PR #357** — cycle-12 wake found the conflict; the contractor session was silent.
3. **5 consecutive quiet cycles** between 07:08Z and 09:43Z — each producing a 1-line `tick` entry confirming "state unchanged."

§First-explicit-observation in library: **§three-named-observable-costs-from-a-single-day-as-empirical-motivation — §the-design's-rationale-IS-grounded-in-named-PR-numbers-named-timestamps-and-named-cycle-numbers + §the-evidence-IS-from-one-named-day (2026-05-29) + §sibling-pattern to engineering documents that ground their motivation in specific observed incidents**.

§Three-cycles-with-empirical-evidence-grounding-the-design-rationale (267 README calibration-round-based-on-13-new-S-sized-PRs + 269 endor-tui Chat-becoming-debugger-empirical-observation + 281 driver three-named-observable-costs-from-2026-05-29).

## §"The driver is a script, not a role" — named categorical distinction

Line 24, 194 carry the §named-categorical-distinction:

> *The driver is **a script, not a role.** It is a bash program (`scripts/driver/driver.sh <lane>`) that pulls jobs off a generic job inbox*

§First-explicit-observation in library: **§the-driver-IS-a-script-not-a-role-as-named-categorical-distinction — §a-role-IS-an-agent-context-fragment-that-hydrates-a-subagent's-context + §a-script-IS-a-program-a-human-or-systemd-runs + §the-distinction-IS-load-bearing-because-it-determines-where-the-thing-lives-in-the-garden's-directory-tree**.

§The-categorical-distinction-IS-not-a-property-but-a-kind-distinction — §the-driver-IS-IS-not-a-role-not-merely-distinct-from-roles; §sibling-pattern to many programming-language type-vs-kind distinctions.

## §The scripts/ top-level directory with named convention

Lines 38-50 carry §the-scripts/-top-level-directory-with-named-convention:

```
scripts/                              # executable shell scripts for humans + systemd
  driver/
    driver.sh                         # the per-lane driver entry point
    README.md
  watcher/<feed-slug>/
    watcher.sh
    README.md
  daemons/
    start.sh
    stop.sh
  systemd/
    garden-driver@.service
    garden-watcher@.service
```

§First-explicit-observation in library: **§the-scripts-top-level-directory-with-named-convention — §scripts/-IS-the-new-named-top-level-directory + §it-coexists-with-roles/-and-skills/-as-three-named-top-level-directories + §each-has-a-distinct-audience (scripts: humans + systemd; roles: subagent context; skills: just-in-time playbooks)**.

§Three-named-top-level-directories-with-named-audiences (scripts + roles + skills); §the-discipline-IS-separation-of-audience-not-just-separation-of-content.

§The-scripts/-mirrors-the-systemd-templated-unit-shape — `garden-driver@.service` + `garden-watcher@.service` are systemd templates where `@<instance-name>` parameterizes the unit; §sibling-pattern to many systemd conventions.

## §Two daemon shapes — persistent driver pool + per-feed watcher daemons

Lines 26-32 carry §two-named-daemon-shapes:

1. **Persistent driver pool** — `garden-driver@1.service`, `garden-driver@2.service`, ... — each lane's lifetime spans many jobs and many PRs.
2. **One daemon per upstream activity feed** — one watcher per repo / feed; translates upstream events into message dispatches + posts `:eyes:` reactji.

§First-explicit-observation in library: **§two-named-daemon-shapes-with-distinct-cardinality (N-driver-pool + one-watcher-per-feed) — §the-cardinality-shapes-the-discipline + §drivers-IS-many-watchers-IS-one-per-feed + §the-asymmetry-IS-because-drivers-are-fungible + §watchers-are-feed-bound**.

§Sibling-pattern to many systems where worker-pools differ in cardinality from producer-loops.

## §The driver outer loop — six numbered steps

Lines 194-202 carry §the-driver's-six-numbered-steps:

1. Poll the generic job inbox at `journal/jobs/open/` and claim one job at a time via the existing claim-via-push race.
2. Read the job's `kind` and look up the corresponding workflow state machine.
3. Run the workflow's state machine.
4. On result, advance the state machine.
5. On a failure the script cannot interpret, capture the log via `git hash-object`, construct the prompt-on-failure brief, invoke claude.
6. On clean completion, return to step 1.

§First-explicit-observation in library: **§the-driver's-outer-loop-IS-six-numbered-steps-with-deterministic-default-and-LLM-fallback — §steps-1-2-3-4-6-IS-deterministic + §step-5-IS-the-LLM-fallback + §the-LLM-IS-called-only-when-the-script-cannot-decide-deterministically + §sibling-pattern to many systems' fast-path-with-LLM-fallback discipline**.

## §The job inbox's seven named job kinds

Lines 217-218 enumerate §seven-named-job-kinds:
1. `pr-creation`
2. `observed-error`
3. `issue-response`
4. `build-request`
5. `design-request`
6. `retcon-rebase`
7. `ci-recovery`

§First-explicit-observation in library: **§seven-named-job-kinds-in-a-generic-job-inbox — §each-kind-IS-a-named-workflow + §the-`kind`-field-IS-the-dispatch-key + §the-driver-loads-`skills/driver-${kind}-state-machine/SKILL.md`-per-kind**.

§Sibling-pattern to many event-driven systems where the kind field selects the handler; §the-generic-inbox-with-typed-jobs-IS-the-canonical-event-driven-shape.

## §Lane-numbered systemd template with `@<N>.service` syntax

Lines 78, 105 carry §the-systemd-templated-unit-shape:

- `scripts/systemd/garden-driver@.service`
- `scripts/systemd/garden-watcher@.service`

§First-explicit-observation in library: **§lane-numbered-systemd-template-with-`@<N>.service`-syntax — §systemd's-templated-units-IS-the-canonical-pattern-for-N-instance-services + §the-`@`-IS-the-named-parameter-marker + §the-instance-name-becomes-the-lane-number-or-feed-slug**.

§Sibling-pattern to many systemd conventions; §the-cluster-uses-systemd-natively-rather-than-supervising-its-own-processes.

## §The role-prefixed lanes — extending the lane convention

Lines 512-547 carry §role-prefixed-lanes:

> *Lanes named `gardener-1`, `librarian-1`, etc. extend the driver pool to non-PR roles. The role-prefix in the lane name lets the systemd unit and the job-board posting know which role's job-board to claim from.*

§First-explicit-observation in library: **§role-prefixed-lanes-as-extension-of-the-generic-driver-pool — §some-lanes-IS-PR-creation-flow-generic (lane-1 + lane-2 + ...) + §some-lanes-IS-role-prefixed (gardener-1 + librarian-1 + ...) + §the-naming-convention-encodes-the-job-board-routing**.

§Two-named-lane-shapes (generic-numbered + role-prefixed); §sibling-pattern to many systems' worker-pool-with-typed-lanes discipline.

## §The prompt-on-failure capture pattern — `git hash-object -w --stdin`

Lines 358-398 carry §the-prompt-on-failure-capture-pattern:

> *On a failure the script cannot interpret, captures the log via `git hash-object -w --stdin` and passes the SHA into the prompt; claude reads the log on demand via `git cat-file blob`.*

§First-explicit-observation in library: **§the-prompt-on-failure-capture-pattern — §the-failure-log-IS-written-to-the-git-object-store + §the-SHA-IS-passed-to-the-LLM-prompt + §the-LLM-reads-the-log-on-demand-via-`git cat-file blob` + §the-pattern-AVOIDS-stuffing-the-full-log-into-the-prompt + §the-LLM-pulls-only-the-portions-it-needs**.

§Sibling-pattern to many systems' log-by-reference patterns; §the-discipline-IS-cheap-prompt-context-not-eager-load-of-log-content.

§The-`git hash-object`-and-`git cat-file blob`-pair-IS-content-addressed-log-storage — §sibling-pattern to cycle 276's sha512-sharded-cache + cycle 275's SHA-256 blob-storage; §three-cycles-with-content-addressed-storage-disciplines (275 + 276 + 281).

§First-explicit-observation in library: **§three-cycles-with-content-addressed-storage-disciplines (275 SHA-256 blob-storage + 276 SHA-512 source-map-cache + 281 git-object-store-for-failure-logs)**.

## §"What changes in the existing library" — the named refactor record

Lines 560-602 carry §a-What-changes-in-the-existing-library-section — distinct from cycle 275's Affected packages section (which was per-package); §the-cluster-now-has-two-named-shape-for-naming-implementation-blast-radius:
1. **`### Affected packages`** (cycle 275 daemon-weblet-application) — per-package list.
2. **`## What changes in the existing library`** with **`### New artifacts`** and **`### Modified artifacts`** subsections (cycle 281 driver).

§First-explicit-observation in library: **§two-named-shapes-for-naming-implementation-blast-radius (Affected-packages-list cycle 275 + What-changes-in-the-existing-library-with-New-artifacts-and-Modified-artifacts cycle 281)**.

## §Cycle 281 first-explicit-observations roundup (twelve)

1. §the-first-design-from-the-garden's-own-repository-ingested.
2. §the-garden's-design-doc-format-IS-distinct-from-the-endo-but-for-bots-design-doc-format.
3. §multi-author-attribution-by-role-name-as-named-discipline.
4. §the-`## Update — YYYY-MM-DD <topic>`-section-at-top-as-named-time-stamped-amendment.
5. §maintainer-directive-cited-verbatim-as-named-evidence-of-change.
6. §three-cycles-with-design-acknowledging-its-own-evolution-within-the-document (269 + 279 + 281).
7. §the-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-distinction.
8. §three-named-observable-costs-from-a-single-day-as-empirical-motivation.
9. §the-driver-IS-a-script-not-a-role-as-named-categorical-distinction.
10. §the-scripts-top-level-directory-with-named-convention (three named top-level directories with named audiences).
11. §two-named-daemon-shapes-with-distinct-cardinality (N-driver-pool + one-watcher-per-feed).
12. §the-driver's-outer-loop-IS-six-numbered-steps-with-deterministic-default-and-LLM-fallback.

Plus: §seven-named-job-kinds + §lane-numbered-systemd-template + §role-prefixed-lanes + §the-prompt-on-failure-capture-pattern + §three-cycles-with-content-addressed-storage-disciplines (275 + 276 + 281) + §two-named-shapes-for-naming-implementation-blast-radius.

## §Recurring meta-pattern counters bumped at cycle 281

- §**two-cycles-with-meta-design-ingest** (265 endo-but-for-bots `designs/CLAUDE.md` + 281 garden `designs/driver.md`).
- §**three-cycles-with-design-acknowledging-its-own-evolution-within-the-document** (269 + 279 + 281).
- §**three-cycles-with-empirical-evidence-grounding-the-design-rationale** (267 + 269 + 281).
- §**three-cycles-with-content-addressed-storage-disciplines** (275 SHA-256 blob-storage + 276 SHA-512 source-map-cache + 281 git-object-store-for-failure-logs).
- §**two-named-shapes-for-naming-implementation-blast-radius** (Affected-packages-list cycle 275 + What-changes-in-the-existing-library cycle 281).
- §**two-cycles-with-Proposed-Status** (279 + 281).
- §**one-hundred-and-fourteenth consecutive designs-chat alternation cycles 166-250 + 252-281** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-garden's-claude-under-script-architecture applies to the §game-engine-cluster:

- §**`game-driver.sh` script** that drives a state machine and delegates judgment to LLM only when needed (e.g., interpret an ambiguous game-state).
- §**§named categorical distinction** — the game-driver IS a script, not a game-rule (sibling to §the-driver-IS-a-script-not-a-role).
- §**§scripts/ top-level directory** for game-engine executable shell scripts.
- §**§two named daemon shapes** for game-engine — persistent game-driver pool + one watcher per game-event-feed.
- §**§seven named job kinds** for game-engine workflows (game-creation + observed-error + issue-response + build-request + design-request + retcon-rebase + ci-recovery).
- §**§the prompt-on-failure capture pattern** for game-engine failure logs via git object store.
- §**§the `## Update — YYYY-MM-DD <topic>` section at top** for time-stamped amendments to game-engine design docs.
- §**§multi-author attribution by role name** (game-designer + game-implementer + game-tester) for game-engine design docs.

## §Tier-1 borrowing

§the-garden's-design-doc-format-IS-distinct-from-the-endo-but-for-bots-design-doc-format + §multi-author-attribution-by-role-name-as-named-discipline + §the-`## Update — YYYY-MM-DD <topic>`-section-at-top-as-named-time-stamped-amendment + §maintainer-directive-cited-verbatim-as-named-evidence-of-change + §the-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-distinction + §three-named-observable-costs-from-a-single-day-as-empirical-motivation + §the-driver-IS-a-script-not-a-role-as-named-categorical-distinction + §the-scripts-top-level-directory-with-named-convention + §two-named-daemon-shapes-with-distinct-cardinality + §the-driver's-outer-loop-IS-six-numbered-steps + §seven-named-job-kinds-in-a-generic-job-inbox + §the-prompt-on-failure-capture-pattern.

## §Tier-2 borrowing

§three-cycles-with-design-acknowledging-its-own-evolution-within-the-document + §lane-numbered-systemd-template + §role-prefixed-lanes + §two-named-shapes-for-naming-implementation-blast-radius + §three-named-top-level-directories-with-named-audiences (scripts + roles + skills).

## §Tier-3 borrowing

§two-cycles-with-meta-design-ingest (265 + 281) + §three-cycles-with-content-addressed-storage-disciplines (275 + 276 + 281) + §three-cycles-with-empirical-evidence-grounding-the-design-rationale (267 + 269 + 281) + §two-cycles-with-Proposed-Status (279 + 281) + §library-reaches-787-sections at cycle 281 + §one-hundred-and-fourteenth consecutive designs-chat alternation cycles 166-250 + 252-281.

## Pattern summary (tag-prefixed)

§the-first-design-from-the-garden's-own-repository-ingested + §the-garden's-design-doc-format-IS-distinct-from-the-endo-but-for-bots-design-doc-format (field-names-NOT-bold + no-`(prompted)`-suffix + multi-author-comma-separated) + §multi-author-attribution-by-role-name (gardener + fixer + designer) + §the-`## Update — YYYY-MM-DD <topic>`-section-at-top + §maintainer-directive-cited-verbatim + §three-cycles-with-design-acknowledging-its-own-evolution-within-the-document (269 + 279 + 281) + §the-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-distinction + §three-named-observable-costs-from-a-single-day (28-min gap PR #376 + 50-min weaver hand-off PR #357 + 5 consecutive quiet cycles) + §the-driver-IS-a-script-not-a-role-as-named-categorical-distinction + §scripts/-top-level-directory + §three-named-top-level-directories-with-named-audiences (scripts + roles + skills) + §two-named-daemon-shapes-with-distinct-cardinality (N-driver-pool + one-watcher-per-feed) + §the-driver's-outer-loop-IS-six-numbered-steps-with-deterministic-default-and-LLM-fallback + §seven-named-job-kinds-in-a-generic-job-inbox + §lane-numbered-systemd-template-with-`@<N>.service`-syntax + §role-prefixed-lanes + §the-prompt-on-failure-capture-pattern + §three-cycles-with-content-addressed-storage-disciplines (275 + 276 + 281) + §two-named-shapes-for-naming-implementation-blast-radius (Affected-packages-list + What-changes-in-the-existing-library) + §two-cycles-with-meta-design-ingest (265 + 281) + §two-cycles-with-Proposed-Status (279 + 281).
