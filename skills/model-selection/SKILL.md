---
created: 2026-06-10
updated: 2026-06-10
author: gardener
---

# Skill: model-selection

The canonical per-role model assignment. Every `Agent` dispatch the orchestrator (liaison, steward, driver-lane, or judge) issues passes a `model` parameter chosen from this skill's table. The principle the maintainer set on 2026-06-10: *the model that is adequate to the task, for which any more advanced model would be wasteful.*

This is the single source of truth. When a new Claude version lands (Sonnet 5, etc.), one table edit retargets every role. Per-role frontmatter is deliberately not used so the assignment does not drift across thirty-plus files.

## Tiers

The current Claude 4.X family carries three tiers; each role binds to one of them.

- **Opus** (`claude-opus-4-7`) — the most capable model. Use for roles that compose substantive prose, hold a wide context, aggregate multi-source input into a single verdict, or take judgment calls whose downstream consequences are hard to reverse. Orchestrators, the three judges, the design author, meta-evolution, and the heaviest jurors live here.
- **Sonnet** (`claude-sonnet-4-6`) — middle tier; balanced cost and capability. The default for substantive engineering work within a well-scoped dispatch: implementation, surgical fix, library curation, the long tail of jurors. Most roles land here.
- **Haiku** (`claude-haiku-4-5-20251001`) — small, fast, cheap. Use for roles whose dispatch body is dominated by deterministic substeps (running scripts, checking field values, posting reactjis, classifying log lines into known categories), where the LLM's job is mainly to drive a small decision tree.

**Adequacy beats parsimony.** When a role's typical engagement straddles tiers (the shepherd sometimes hits a tricky CI failure; a fixer sometimes hits a thorny review thread), pick the tier whose adequacy is reliable for the *typical* case and let the role file's escalation discipline route the outlier. A role whose Haiku-tier instances are 90% adequate but the 10% failures are *"I'll wait for the next monitor tick"* shows that Haiku is not actually adequate; promote to Sonnet.

## Per-role assignments

### Orchestrators and meta-evolution

| Role | Tier | Why |
| --- | --- | --- |
| `liaison` | Opus | The user-in-the-loop orchestrator. Translates ambiguous prompts into dispatches, holds the bulletin and journal context, applies authority and posture judgment. |
| `steward` | Opus | Autonomous orchestrator. Per-cycle survey, dispatch decisions, escalation classification, maintainer-feedback routing. The cycle's quality compounds. |
| `gardener` | Opus | Meta-evolution. Authors role and skill prose; holds threshold judgment; integrates lessons across many engagements. |
| `evaluator` | Opus | A/B comparison engagement. Reads two replay chains side by side and produces a recommendation. Rare and expensive; quality matters. |
| `investigator` | Opus | Hypothesis-driven investigation of behavioural mysteries. Reads broadly and produces a synthesis. |

### Judges

| Role | Tier | Why |
| --- | --- | --- |
| `solicitor` | Opus | Design-panel judge; aggregates seven juror blocks into a single verdict and submits the formal review. |
| `barrister` | Opus | Code-panel first-round judge; aggregates twenty-six juror blocks. Heaviest aggregation in the garden. |
| `justice` | Opus | Code-panel re-run judge; reads the fixer's response plus the prior verdict plus the panel's re-runs. |
| `appellate` | Opus | Appeals judgment on terminating verdicts; promotes follow-up dispositions to summary-fix. Single-shot but nuanced. |
| `judge` (redirect) | (n/a) | Retained as a redirect to the three above; not directly dispatched. |

### PR-creation chain

| Role | Tier | Why |
| --- | --- | --- |
| `designer` | Opus | Drafts whole design documents; surfaces open questions; cross-references prior art. Authoring at scale. |
| `builder` | Sonnet | Substantive implementation within a single well-scoped dispatch. |
| `assayer` | Sonnet | Tests and fixtures alongside the builder. |
| `cleaner` | Haiku | Mechanical pre-push-gate run plus coverage / dead-code pass; the deterministic substrate carries most of the work. |
| `fixer` | Sonnet | Surgical fixes against inline review comments; reads each comment, applies the fix, re-requests review. |
| `weaver` | Sonnet | Rebase with conflict resolution; trivial rebases run mechanically, non-trivial conflicts need judgment. |
| `shepherd` | Sonnet | CI-to-green. The 2026-05-29 *"I'll wait for the next monitor tick"* incidents are evidence that Haiku is not adequate; Sonnet is the right floor. |
| `conductor` | Haiku | Merge queue drain; `gh pr merge`, frozen-base unfreeze (per `roles/conductor/AGENT.md` § Loop step 2), sweep on close. Mechanical. |
| `boatman` | Sonnet | Identity-switching ferry to upstream; cherry-picks, attribution rewrites, PR formation. Needs care. |
| `researcher` | Sonnet | Walks `journal/library/` and the project context; returns curated references. Well-scoped library walk. |

### Per-task and curation roles

| Role | Tier | Why |
| --- | --- | --- |
| `scout` | Sonnet | Performance benchmarks, comparative reports. |
| `botanist` | Sonnet | Dependabot triage; verdict on each upgrade. |
| `major-general` | Sonnet | Dependency adoption cadence; planning. |
| `groom` | Sonnet | Roadmap edits on `designs/README.md` and equivalents. |
| `journalist` | Sonnet | Bulletin maintenance, milestone classification. |
| `librarian` | Sonnet | Library ingest, prune, shortcut, audit. The library-audit variant's 1-hour budget per `skills/driver-librarian-workflow/SKILL.md` benefits from Sonnet's capacity. |
| `scholar` | Sonnet | Source-document ingest. Substantive prose curation. |

### Standing watchers

| Role | Tier | Why |
| --- | --- | --- |
| `monitor` | Haiku | Per-event-class reactions per `skills/monitor-<slug>/SKILL.md`. Mostly mechanical classification. |
| `review-queue` | Haiku | Polls `kriskowal`'s review-request set and reconciles the bulletin. Deterministic. |
| `timekeeper` | Haiku | Scheduling-adjacent. Mechanical. |

### Code-panel jurors

The barrister dispatches up to twenty-six seats on a source-touching PR per `skills/panel-hints/SKILL.md`. Each seat's brief is narrow (one lens); most are Sonnet. The four heaviest are Opus.

| Juror | Tier | Why |
| --- | --- | --- |
| `archivist` | Sonnet | Documentation accuracy. |
| `assessor` | Sonnet | Risk assessment. |
| `benchmarker` | Sonnet | Microbenchmarks and runtime cost. |
| `breaker` | Opus | Invariant attacks. Security-adjacent judgment; the cost of a missed invariant is high. |
| `changeset-auditor` | Haiku | Mechanical changeset / lockfile check. |
| `curator` | Sonnet | File and dependency hygiene. |
| `engine-realist` | Sonnet | Cross-engine reality (Hermes, XS, V8). |
| `integrator` | Sonnet | Cross-package integration surface. |
| `locksmith` | Sonnet | Capability discipline. |
| `migrator` | Sonnet | Backwards-compat impact. |
| `novice` | Sonnet | First-reader perspective. |
| `packager` | Haiku | Commit hygiene, splits, changeset structure. Mechanical against a checklist. |
| `prover` | Sonnet | Regression evidence. |
| `purist` | Sonnet | Idiom. |
| `releaser` | Sonnet | Release / changeset substance. |
| `saboteur` | Opus | Adversarial inputs and broad-try discipline (per the 2026-06-09 tight-try lens). The failure-mode probe needs judgment about what counts as "the throwing operation." |
| `scribe` | Sonnet | Cross-PR observation. |
| `spec-keeper` | Sonnet | Specification fidelity. |
| `stylist` | Sonnet | Naming. The 2026-06-07 redundant-word lens lives here. |
| `typist` | Sonnet | Type safety and JSDoc agreement. |
| `warden` | Opus | Security review; same calculus as breaker — the cost of a missed issue is high. |
| `wire-watcher` | Sonnet | Wire formats. |
| `fast-checker` | Haiku | Quick smoke check. |
| `corner-prober` | Sonnet | Edge cases. |
| `gateway` | Sonnet | Entry-point clarity. |

### Design-panel jurors

The solicitor dispatches seven seats on a design-only PR. All Sonnet by default; the critic and skeptic carry the heavier judgment and rise to Opus.

| Juror | Tier | Why |
| --- | --- | --- |
| `copyeditor` | Sonnet | Prose mechanics. |
| `critic` | Opus | Substantive critique of the design's reasoning. The lens that produces the must-fix verdicts. |
| `decomplector` | Sonnet | Complexity audit. |
| `ergonomist` | Sonnet | API ergonomics. |
| `pedant` | Sonnet | Chicago Manual style. |
| `pruner` | Sonnet | Redundancy removal. |
| `skeptic` | Opus | Alternative-considered audit. The lens that asks *"did the design name the alternatives it rejected?"* needs to read the design and the corpus deeply. |
| `surfacer` | Sonnet | Surface area. |

## Procedure

The orchestrator (liaison, steward, driver-lane, or a judge dispatching jurors):

1. Reads the role's row in the table above.
2. Passes the tier's model ID to the `Agent` tool's `model` parameter at dispatch time. The current model IDs (2026-06-10):
   - Opus: `opus`
   - Sonnet: `sonnet`
   - Haiku: `haiku`
3. Records the model choice in the `dispatch` journal entry's frontmatter (a new optional field, `model: opus | sonnet | haiku`), so the audit trail captures it.

The orchestrator does not invent a model choice. When a role is missing from the table, the orchestrator defaults to Sonnet and writes a `message: <role> -> gardener` flagging the omission so the gardener fills the row.

## Overrides

A maintainer prompt or dispatch brief may name an explicit model override (*"dispatch the builder on Opus for this one because the change is structurally subtle"*). The override wins over the table for the named engagement only; the table's assignment stays canonical for subsequent dispatches.

A juror seat whose lens carries an unusually heavy case for one PR (a saboteur dispatch on a security-critical PR; a critic dispatch on a design touching capability semantics) may also be lifted to Opus by the dispatching judge with the rationale recorded in the dispatch entry.

## Composition with other skills

- The skill is read by the orchestrator at dispatch time, not by the dispatched subagent. Subagents do not need to know which model they are.
- The dispatch contract in `CLAUDE.md` § Dispatch contract names this skill as a lookup the orchestrator performs as part of step 3 (invoking `Agent`).
- The driver design's lane workflows (`skills/driver-<role>-workflow/SKILL.md`) consult this skill when their classifier dispatches a sub-agent for an engagement.

## Notes from the field

- _2026-06-10_: skill landed in response to the maintainer's directive: *"As the gardener, please direct each role to be dispatched with the best model fit for the job. That is, the model that is adequate to the task, for which any more advanced model would be wasteful."* The initial assignment table reflects the patterns visible in the journal as of this date: Opus for the orchestrators, judges, designer, and the four heaviest jurors; Haiku for the mechanical roles (cleaner, conductor, monitor, review-queue, timekeeper, and three jurors); Sonnet for the long tail. The shepherd's 2026-05-29 *"I'll wait for the next monitor tick"* incidents were the explicit evidence that Haiku is not adequate for that role despite its mostly-mechanical surface; Sonnet is the right floor.
