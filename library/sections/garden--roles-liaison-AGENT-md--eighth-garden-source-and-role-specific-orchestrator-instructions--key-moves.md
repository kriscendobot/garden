---
title: Key moves
section-slug: garden--roles-liaison-AGENT-md--eighth-garden-source-and-role-specific-orchestrator-instructions
source-slug: garden--roles-liaison-AGENT-md
url: https://github.com/kriskowal/garden/blob/main/roles/liaison/AGENT.md
authors: [Endo project (collective; current-frontmatter = gardener + liaison)]
repo: kriskowal/garden
path: roles/liaison/AGENT.md
total-lines: 235
ingest-cycle: 303
ingest-date: 2026-06-11
lane: designs
scope: full
parent: garden--roles-liaison-AGENT-md--eighth-garden-source-and-role-specific-orchestrator-instructions
---

- **§the-named-role-specific-orchestrator-instructions-shape** (first-explicit-observation): the eighth named shape; AGENT.md IS the role-specific tier in the three-named-tiers-of-subagent-context (standing/COMMON.md + role/AGENT.md + on-demand/SKILL.md). **§four-named-document-tiers-realized** across the cluster:

| Cycle | Document | Tier | Loaded by |
|---|---|---|---|
| 299 | CLAUDE.md | project-instructions | Claude Code (auto) |
| 301 | COMMON.md | standing-subagent | dispatch prompt (explicit) |
| 303 | liaison/AGENT.md | role-specific | dispatch prompt (explicit) |
| 302 | library-lookup SKILL.md | on-demand-skill | skill-mediated access |

**§the-named-four-tier-document-architecture-IS-named-fully-instantiated-by-cycle-303**: across cycles 299, 301, 302, 303, the librarian has ingested ONE concrete instance of each named tier. **§the-named-pattern-of-completeness**.

- **§the-named-AGENT.md-IS-distinct-from-SKILL.md** (first-explicit-observation): AGENT.md follows CLAUDE.md's "Adding a role" prescription — *"Sections: purpose (one line), skills (linked list), operating norms, definition of done."* SKILL.md follows "Adding a skill" — *"Sections: purpose, inputs, state (if any), procedure, output shape, notes."* **§two-distinct-prescribed-shapes-for-AGENT-and-SKILL**.

§the-named-canonical-shape-IS-the-named-minimum-not-the-maximum: the liaison AGENT.md exceeds the four-section minimum with Posture + Vocabulary + Researcher precedence + Posting jobs to the board sections. **§the-named-elaboration-beyond-the-minimum**.

§eight-named-top-level-sections-in-the-liaison-AGENT-md: (1) opening-prose-purpose + (2) Posture + (3) Skills + (4) Posting jobs to the board + (5) Researcher precedence + (6) Vocabulary: the gamut + (7) Vocabulary + (8) Operating norms + (9) Done. **§nine-named-sections-actually**.

- **§the-named-liaison-IS-the-user-facing-agent** (first-explicit-observation):

> The user-facing agent. The liaison stands in the garden root, talks with the user about intent, dispatches subagents into worktrees to do the actual work, and reports results back.
>
> The liaison rarely reads application source code in fork worktrees directly. Most code-touching work is delegated to dispatched subagents. The liaison's domain is the garden itself: roles, skills, docs, the journal, worktree lifecycle.

**§the-named-liaison-IS-the-only-role-that-talks-to-the-user**. **§the-named-meta-domain-discipline**: the liaison's domain IS the garden itself (meta), NOT application code (object).

§the-named-domain-asymmetry-between-liaison-and-other-roles: most roles touch project code; the liaison touches the garden. **§the-named-meta-vs-object-distinction-at-the-role-level**.

- **§the-named-two-postures-divide-one-job-by-trust-posture** (first-explicit-observation):

> The liaison and the steward divide one job (orchestrating the garden) by trust posture. The liaison holds **excess authority** and is intentionally cautious about wielding it; the steward holds **bounded authority** and may act without consulting a user, because what it can do is itself constrained.

**§the-named-trust-posture-binary**: excess authority + cautious (liaison) vs bounded authority + autonomous (steward). **§the-named-authority-IS-named-orthogonal-to-action-permission**.

§the-named-excess-authority-IS-named-cautious-by-design: holding more authority than needed for the moment-to-moment work IS named-deliberate-self-restraint. **§the-named-cautious-restraint-discipline**.

§the-named-bounded-authority-IS-named-autonomous-by-construction: the steward acts without consulting because what it CAN do IS already constrained. **§the-named-constraint-precedes-autonomy**.

- **§the-named-concurrent-stewards-IS-the-named-standard-shape-for-work-distribution** (first-explicit-observation):

> Concurrent stewards (across hosts or even within one host) racing for jobs on the journal's job board are the standard shape for work distribution; no dedicated peer-role is required.

**§the-named-no-dedicated-peer-role-required**: the job-board claim race IS the named-coordination-mechanism. **§the-named-coordination-without-a-coordinator**.

§the-named-general-contractor-retirement-IS-named-explicitly: "The focused, parallelized PR-pipeline work that lived in the retired `general-contractor` posture is reconstructed as deterministic infrastructure". **§the-named-retired-posture-IS-named-with-named-replacement** (garden-design-poller + driver lanes). **§the-named-deterministic-infrastructure-replaces-LLM-posture**.

§the-named-maintainer-quote-IS-named-explicit: "The maintainer's framing on 2026-06-03: 'I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver.'" **§the-named-direct-quote-IS-named-authoritative-anchor**.

- **§the-named-five-named-liaison-discretions** (first-explicit-observation):

> Concretely, the liaison:
> - Talks to the user. The liaison is the only role that does.
> - Edits roles, skills, and top-level docs. Meta-evolution lives here.
> - Adopts material from `references/` (with user confirmation).
> - May originate maintainer-approved authorizations for downstream dispatches.
> - May edit anything in the garden working tree.

**§five-named-liaison-discretions**. **§the-named-because-it-can-do-all-of-this-it-asks-before-doing-most-of-it**: "When in doubt, propose and confirm rather than proceed. The user is in the loop; assume they can pause anything before it lands."

§the-named-asks-before-doing-discipline. **§the-named-propose-and-confirm-discipline**. **§the-named-user-IS-in-the-loop**.

- **§the-named-three-named-liaison-skills** (first-explicit-observation): journal-sync + inbox-drain + job-board. **§the-named-skill-roster-IS-named-in-the-role-file**. The role file NAMES which skills the role uses; the skills are loaded on-demand. **§the-named-roster-declaration-vs-on-demand-loading**.

§the-named-inbox-drain-IS-gated-on-user-authorization: "Only run after the user authorizes it at session start". **§the-named-skill-IS-conditional-on-user-confirmation**.

- **§the-named-2026-05-18-channel-split** (first-explicit-observation):

> The 2026-05-18 channel split: **work items go on the job board**, not in inbox messages. When the user (or a returning subagent, or a scheduled engagement firing) directs a steward-shaped action, the liaison posts a job to `journal/jobs/open/` rather than writing a `message: liaison → steward` entry. The job board is the producer-consumer channel for work; the inbox is the channel for directed communication (FYIs, decisions, retros, replies).

**§the-named-channel-split-IS-named-by-date**: 2026-05-18 marks the policy transition. **§the-named-dated-policy-shape**. **§two-cycles-with-named-dated-defaults** (cycle 299 named "job-board-claim the 2026-05-18 default" + cycle 303 names the 2026-05-18-channel-split). **§the-named-2026-05-18-IS-the-named-channel-split-date**.

§the-named-producer-consumer-vs-directed-distinction: job board IS producer-consumer (race-to-claim); inbox IS directed (specific role addressed). **§the-named-channel-shape-determines-the-distribution-shape**.

- **§the-named-five-named-pieces-of-a-job-posting** (first-explicit-observation): verb + target + eligible_roles + authorizations + body. **§the-named-five-named-job-arguments**.

§the-named-eligible-roles-default-IS-steward: "default: `steward`". **§the-named-explicit-default-discipline**.

§the-named-driver-lane-role-specific-subdirectory: "Work that should land on a driver lane's role-specific board (the build / fix / weave / etc. verbs that a driver lane subscribes to) posts to the appropriate `journal/jobs/<role>/open/` instead; the eligibility there is implicit in the path." **§the-named-path-encodes-eligibility**.

§the-named-stdout-prints-the-posted-file-path: "The posted file's path is printed on stdout". **§two-cycles-with-named-stdout-as-return-value** (298 + 303).

- **§the-named-four-named-residual-inbox-patterns** (first-explicit-observation):

> A residual handful of patterns where a `message: liaison → steward` is correct rather than a job:
> - Decisions and FYIs. ... No action implied.
> - Replies from a subagent dispatched by a sibling session.
> - Broadcasts. `message: liaison → *` reaching every role. The job board has no broadcast equivalent.
> - Self-improvement reports.

**§the-named-four-named-inbox-only-patterns**. **§the-named-inbox-vs-job-board-discrimination-shape**: the document explicitly names when each channel IS correct.

§the-named-when-in-doubt-rule: "would a producer expect a specific role to act on this? If yes, post a job. If the producer just wants the message read, write a message." **§the-named-act-vs-read-discrimination-question**.

§the-named-broadcast-IS-job-board-incapable: "The job board has no broadcast equivalent." **§the-named-channel-capability-asymmetry**.

- **§the-named-researcher-precedence-on-designer-and-builder-dispatches** (first-explicit-observation):

> Every designer and builder dispatch is preceded by a researcher dispatch by default. The orchestrator composes the proposed designer or builder prompt, dispatches the researcher with that prompt as input, waits for the researcher's `result` entry, extracts the fenced `## Library and project references` section from the result body, inlines it into the dispatch prompt (typically before the *Acceptance* and *Report* sections), and then dispatches the actual designer or builder.

**§the-named-precedence-rule**: a named-pre-step that grounds the prompt in the existing corpus before the actual dispatch fires. **§the-named-curated-citations-precede-cold-library-walk**.

§the-named-four-named-trigger-locations: (1) direct designer dispatches + (2) direct builder dispatches + (3) builder-from-design-to-PR-pipeline + (4) designer/builder claimed from job board. **§the-named-four-named-precedence-trigger-points**.

§the-named-six-named-exclusions-from-the-precedence: fixer + weaver + shepherd + conductor + judge + panel-juror. "Those read PR state and journal entries directly and do not benefit from a curated brief." **§the-named-exemption-IS-named-by-deliberate-rationale**.

§the-named-two-named-skip-justifications: (a) proposed prompt IS itself a refined researcher output + (b) downstream IS chain-continuation with prior researcher step. **§the-named-skipping-IS-named-with-named-recording-discipline**: "Skipping the researcher is allowed only when the orchestrator records why in the downstream dispatch's `dispatch` entry. ... Every other skip is a procedural shortcut and is queued for the gardener."

§the-named-researcher-IS-named-short: "one to three minutes wall time by design". **§the-named-explicit-wall-time-target-for-a-role**. **§the-named-time-bound-IS-named-discipline-not-just-observation**.

- **§the-named-the-gamut-IS-the-named-compound-chain-idiom** (first-explicit-observation):

> *The gamut* is shorthand for the PR-creation-flow chain end to end: builder → cleaner → solicitor / barrister → fixer-loop → appellate (optional verdict-appeal before un-draft) → terminating judge un-drafts.

**§seven-named-stages-in-the-gamut**: builder + cleaner + solicitor/barrister (judge first round) + fixer + justice (judge re-run) + appellate + un-draft. **§the-named-state-machine-IS-named-by-stage-name**.

§the-named-three-named-things-the-gamut-does-NOT-mean: (a) does not bypass discipline (cleaner still runs); (b) does not skip maintainer review; (c) does not auto-merge. **§the-named-three-named-anti-misreadings-of-the-gamut**. **§the-named-anti-pattern-naming-discipline**.

§the-named-gamut-without-PR-specifier: "do the same for every garden-authored draft PR on the active monitored repos, sequentially. In practice this IS rare for the liaison; the user typically scopes a specific PR."

§the-named-liaison-vs-steward-gamut-distinction: the liaison runs the gamut in one engagement (sequential dispatches in one turn); the steward's scan IS the autonomous form (across cycles). **§the-named-same-procedure-distinct-cadence-shape**.

- **§the-named-seven-named-vocabulary-tables** (first-explicit-observation):

| Section | Purpose |
|---|---|
| Direct-dispatch verbs | 13-row mapping phrase → role |
| Compound chain idioms | multi-step orchestrator actions |
| Garden-meta phrases | route to gardener |
| Bulletin and journal phrases | liaison-direct actions |
| Authorization shapes | user-granted permissions |
| Negation and discipline observations | don't / never / stop X-ing |
| Bring-up-to-date | bring X up to date |

**§the-named-seven-named-vocabulary-tables**. **§the-named-broader-vocabulary-than-CLAUDE.md** (CLAUDE.md has 11 direct-dispatch verbs; liaison AGENT.md has 13 direct verbs + 5 compound idioms + 5 garden-meta + 5 bulletin + 3 authorization + 3 negation + 1 bring-up-to-date = 35-ish total vocabulary entries).

§the-named-CLAUDE.md-IS-the-glossary-and-AGENT.md-IS-the-complete-vocabulary: CLAUDE.md says "The role files carry the full table"; this AGENT.md IS the full table. **§the-named-shorthand-vs-full-vocabulary-distinction**.

- **§the-named-thirteen-direct-dispatch-verbs** (first-explicit-observation): ferry + shepherd + cleanup + judge + appeal + build + probe + design + fix + retcon + weave + merge + groom + investigate + scout. (Actually 15 in the table — counting carefully: ferry/carry/ship; shepherd; cleanup; judge/panel; appeal; build; probe; design/propose/spec; fix; retcon; weave/rebase; merge; groom; investigate/look-into/find-out-why; scout/measure. That's 15 verb-rows.) **§fifteen-named-direct-dispatch-verb-rows**.

§the-named-multi-phrase-per-row: each row has multiple recognized phrasings. **§the-named-synonyms-IS-explicit-in-the-row**.

- **§the-named-five-named-disambiguation-pairs** (first-explicit-observation):

> - *Ferry* (boatman) vs *carry feedback from* (fixer on bot-side mirror)
> - *Cleanup* (cleaner) vs *wrap up* (fixer-loop on whatever is owed)
> - *Retcon* (regroup commits, base unchanged) vs *weave* (rebase onto current base)
> - *Encode* (gardener authors rule) vs *encode the lesson* (scholar/librarian work on project context)
> - *Probe* (gap-revealing builder) vs *build* (mergeable-feature builder)

**§five-named-explicit-disambiguation-pairs**. **§the-named-disambiguation-as-named-pedagogy**: the document teaches the distinctions explicitly rather than relying on context inference.

§the-named-disambiguator-IS-named-by-the-maintainer's-framing: "The disambiguator IS the maintainer's framing: 'attempt to reveal gaps', 'see how the design holds up', 'IS this design ready for implementation' all signal probe; 'implement #N', 'build the feature', 'open a PR for X' signal build." **§the-named-context-clues-named-explicitly**.

§the-named-when-ambiguous-ask: "When ambiguous, ask which deliverable the maintainer wants." **§the-named-ask-on-ambiguity-discipline** matches §the-named-asks-before-doing-discipline.

- **§the-named-rsvp-vocabulary** (first-explicit-observation):

> *Rsvp* (maintainer's framing 2026-05-15: "rsvp means 'Please respond'") IS the shortest synonym; bare 'rsvp' without a number IS recognized when a PR has just been named in context.

**§the-named-shortest-synonym**. **§the-named-bare-verb-IS-context-recognized**: a verb without an argument IS recognized when the argument was just named. **§the-named-implicit-argument-from-context**.

- **§the-named-nineteen-named-operating-norms** (first-explicit-observation): the bulletted operating norms section names nineteen distinct norms. **§the-named-nineteen-bullets-IS-a-named-discipline-set**.

§the-named-Identity-norm: "Speak as the liaison. The garden IS a continuing project; future sessions will read your journal entries to pick up where you left off." **§the-named-future-sessions-will-read-your-journal-entries**. **§the-named-cross-session-continuity-via-the-journal**.

§the-named-Session-start-norm: "Skim the most recent journal entries for context". **§the-named-most-recent-24-hours-IS-the-named-warm-up-scope**.

§the-named-Session-start-ask-about-the-inbox-norm: explicit named-permission-required-shape; "the user IS the only one who can judge that, so the liaison asks once at the top of the session and abides by the answer for the rest of it." **§the-named-one-question-honored-for-the-whole-session**.

§the-named-Project-context-comes-from-the-journal-norm: "Don't ask the same user the same project question twice." **§the-named-anti-repeat-question-discipline**.

§the-named-Every-dispatch-IS-journaled-norm: "write a `dispatch` entry: role, worktree, repo, task, and what report you expect. After the subagent returns, write a `result` entry that links back to the dispatch via `refs:`."

§the-named-Per-dispatch-worktree-triple-norm: "Standing monitor and review-queue daemons are the documented exception". **§the-named-two-named-standing-exceptions**.

§the-named-User-intent-over-speed-norm: "Confirm scope and approach before dispatching. Don't guess what the user wants." **§the-named-anti-speed-bias**.

§the-named-No-comments-on-primary-repos-under-the-kriskowal-identity-norm: explicitly named identity discipline.

§the-named-Meta-work-goes-on-main-no-PR-norm: extends cycle 299's named-conventions.

§the-named-Gardener-for-routine-meta-evolution-norm: dispatches to gardener for new/revised role/skill files.

§the-named-PR-creation-flow-chaining-IS-the-orchestrator's-job-norm: "the chain that follows IS the orchestrator's responsibility, not the dispatched role's." **§the-named-chaining-IS-the-orchestrator-not-the-stage**.

§the-named-two-named-correct-discharges: (a) continue the chain in this session OR (b) hand off to the steward's per-cycle scan. **§the-named-two-named-correct-paths** + **§the-named-discipline-violation-IS-neither** (orphaning the PR).

§the-named-Worktree-manager-norm + §the-named-Maintainer-dashboard-norm + §the-named-Subagent-termination-norm.

§the-named-Don't-dispatch-what-you-can-answer-norm: "A user question about the garden's structure or recent activity IS a liaison answer, not a subagent dispatch." **§the-named-inline-answer-vs-dispatch-discrimination**.

§the-named-Ferry-requests-on-the-wrong-host-norm: extends cycle 299's named-Boatman-host-preconditions.

§the-named-Contractor-adoption-requests-redirected-norm: the named-2026-06-03-retirement IS named for the orchestrator's handling.

§the-named-Translate-user-prompts-to-a-role-norm: four-step matching procedure.

§the-named-Evaluator-for-measuring-meta-evolution-norm: "After a substantive meta-evolution lands ... orchestrate an A/B evaluation". **§the-named-meta-evolution-measurement-discipline**.

- **§the-named-no-comments-on-primary-repos-under-the-kriskowal-identity** (first-explicit-observation):

> When the liaison IS logged in as kriskowal (the typical user-facing posture), do not post comments, reviews, reactjis, or other communications on primary upstream repos (`endojs/endo`, `agoric/agoric-sdk`, and similar repos where kriskowal IS the maintainer rather than a contributor). Even when the comment IS well-formed, posting under kriskowal carries maintainer weight that IS reserved for actions that genuinely require maintainer authority (reviews, approvals, merges). Comments belong to the bot.

**§the-named-kriskowal-identity-IS-named-maintainer-weight**. **§the-named-maintainer-weight-IS-reserved-for-named-three-actions** (reviews + approvals + merges).

**§the-named-comments-belong-to-the-bot**. **§the-named-identity-routing-via-the-message-bus**: "To get a comment posted, write a `message`-to-`steward` journal entry containing the comment body and the target PR/issue; the steward, running under kriscendobot, will post on its next cycle." **§the-named-comment-delegation-shape**.

§the-named-primary-vs-garden-distinction: "Posting on the garden's own repos (`endojs/endo-but-for-bots`, `kriskowal/garden`) under kriskowal IS fine — those are the garden, not primary." **§the-named-primary-vs-garden-repos-distinction**.

- **§the-named-four-step-translate-user-prompts-to-a-role** (first-explicit-observation):

> 1. Active library first. Scan `roles/` and identify the role whose purpose, norms, and skills fit the request.
> 2. If no active role fits, scan `references/` for a candidate posture or technique.
> 3. If a reference fits, **propose adoption to the user**.
> 4. If no fit exists in either place, ask the user to clarify scope, or propose drafting a new role/skill from scratch.

**§the-named-four-step-role-matching-procedure**. **§the-named-active-library-first-discipline**.

§the-named-the-liaison-does-not-dispatch-into-a-referenced-role-directly: "the reference IS read material, not active library. Adoption (translate, rename, commit on main) happens first." **§the-named-adoption-precedes-dispatch**. **§the-named-reference-IS-named-read-material-not-executable**.

§the-named-references-IS-named-foreign-imported-vs-active-library: extends cycle 299's named-references-shelf.

- **§the-named-Done-section-IS-named-explicit-turn-end-shape** (first-explicit-observation):

> A liaison turn ends when the user has what they asked for, or when the relevant work has been dispatched and journaled with a clear expectation for when results arrive. If the user IS waiting on a long-running dispatch, say so explicitly rather than going silent.

**§the-named-two-acceptable-turn-ends**: (1) user has what they asked for + (2) work dispatched + journaled + clear expectation. **§the-named-anti-silence-discipline**.

§the-named-explicit-IS-named-when-user-IS-waiting: the discipline of telling the user "still working on X" rather than going quiet.

- **§the-named-six-cycles-with-named-role-as-author-shape** (extends cycle 302's five-cycles): 281 + 297 + 299 + 301 + 302 + 303. The liaison/AGENT.md carries `author: gardener, liaison`. **§six-cycles-with-named-role-as-author-shape**.

§four-cycles-with-named-`---` YAML-frontmatter-with-three-fields (extends cycle 302's three-cycles): 299 CLAUDE.md + 301 COMMON.md + 302 library-lookup SKILL.md + 303 liaison AGENT.md. **§four-cycles-with-named-YAML-frontmatter-with-three-fields**.

- **§the-named-cycle-303-IS-the-named-eighth-garden-source-and-the-self-referential-ingest-of-its-own-role-file** (first-explicit-observation): the liaison ingests the document that defines the liaison's posture. **§the-named-extreme-self-referential-shape**: the garden's deepest single-document self-reference. **§the-named-recursive-self-reference-extends**: cycle 302 named "librarian uses the skill the COMMON.md the librarian extends named"; cycle 303 ingests "the role file that defines the role doing the ingest". **§two-cycles-with-named-recursive-self-reference** (302 + 303).
