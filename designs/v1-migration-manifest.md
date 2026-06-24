# v1 → v2 Migration Manifest

Read-only reconnaissance of the v1 garden at `/home/kris/v1` against the v2
garden rooted at `/home/kris`. Every v1 **role** (30), **juror** (33), and
**skill** (83) appears below exactly once, classified by disposition.

## What changed in v2 (the lens used to classify)

- Work is coordinated by a git-backed **job board + message bus** on the
  `journal2` branch. Producers (triagers, watchman) post jobs; consumer
  **gardeners** race to claim them via an accepted `git push` (the CAS). See
  [`designs/job-board.md`](job-board.md), scripts under `scripts/jobs/`.
- The **steward** is retired — its autonomous PR-pipeline work is now the
  gardener-script fleet (`scripts/jobs/gardening/`,
  [`designs/gardening-state-machine.md`](gardening-state-machine.md)).
- The **liaison** is implicit (the agent in the garden root); its role file
  already exists in v2 (`roles/liaison/`).
- **general-contractor** and the **driver** lanes are superseded by the gardener
  pool. (No `general-contractor` role file exists in v1 — it was already retired
  there per `CLAUDE.md` — but its `driver-*` skills remain and are superseded.)
- **Jurors** carry verbatim; panels still run as-is.
- The **judicial** roles (judge / solicitor / barrister / justice / appellate)
  are translated into a scripted panel→fixer-loop workflow supervised by a
  gardener.
- The directed-message practice (inboxes, role/broadcast topic bus, journal
  progress entries) already exists in v2 as
  [`skills/message-bus`](../skills/message-bus/SKILL.md) and
  [`skills/job-board`](../skills/job-board/SKILL.md). v1 skills that *describe*
  that practice (`inbox-drain`, `journal-sync`, `scheduling`, `dispatch-worktree`,
  `worktree-per-pr`) are superseded by the v2 equivalents.
- Vocabulary fix: v1's **"gamut"** is erroneous; the correct idiom is
  **"gauntlet"**. Any carried/translated artifact that says "gamut" must be fixed.

## Disposition summary

| Disposition | Roles | Jurors | Skills | Total |
|---|---|---|---|---|
| CARRY_VERBATIM | 0 | 33 | 0 | 33 |
| TRANSLATE | 18 | 0 | 39 | 57 |
| LEAVE_BEHIND | 12 | 0 | 44 | 56 |
| **Total** | **30** | **33** | **83** | **146** |

---

## CARRY_VERBATIM

Panels still run as-is; the 33 jury seats are unchanged content. The only
migration action is to copy the seat files into v2 `roles/jurors/<seat>/` (the
v2 README already reserves that path). No body edits.

### Jurors (33)

| name | kind | rationale |
|---|---|---|
| archivist | juror | Docs / JSDoc-prose-accuracy seat; panel content unchanged. |
| assessor | juror | Correctness-logic / control-flow seat; unchanged. |
| benchmarker | juror | Benchmark-closure-on-optimization-claims seat; unchanged. |
| breaker | juror | Invariant-attack seat; unchanged. |
| changeset-auditor | juror | Changeset-vs-diff-coherence seat; unchanged. |
| copyeditor | juror | Design-panel prose-mechanics seat; unchanged. |
| corner-prober | juror | Edge / corner-case seat; unchanged. |
| critic | juror | Design-panel substantive-critique seat; unchanged. |
| curator | juror | Public-API-surface / exported-shape seat; unchanged. |
| decomplector | juror | Simple-vs-easy (Hickey-lens) design seat; unchanged. |
| engine-realist | juror | V8 / XS / vat-lifecycle-reality seat; unchanged. |
| ergonomist | juror | Interface-ergonomics design seat; unchanged. |
| fast-checker | juror | Property-based-testing (`fast-check`) seat; unchanged. |
| gateway | juror | Repo-root-config-justification seat; unchanged. |
| integrator | juror | Integration-coherence seat; unchanged. |
| locksmith | juror | Capability-flow / attenuation seat; unchanged. |
| migrator | juror | Backwards-compat / bump-level seat; unchanged. |
| novice | juror | Top-down-clarity (naïve-reader) design seat; unchanged. |
| packager | juror | Diff-hygiene / commit-splitting / changeset seat; unchanged. |
| pedant | juror | Formal-style (Chicago) design seat; unchanged. |
| prover | juror | Regression-evidence seat; unchanged. |
| pruner | juror | Documentation-padding seat; unchanged. |
| purist | juror | Ocap-purity / conceptual-integrity seat; unchanged. |
| releaser | juror | Upgrading-user / changeset-need seat; unchanged. |
| saboteur | juror | Adversarial-inputs seat; unchanged. |
| scribe | juror | Knowledge-capture-closure seat; unchanged. |
| skeptic | juror | Adversarial-premise (design) seat; unchanged. |
| spec-keeper | juror | Language-spec-reference seat; unchanged. |
| stylist | juror | Naming seat; unchanged. |
| surfacer | juror | Public-surface-coherence seat; unchanged. |
| typist | juror | Type-accuracy (TS / JSDoc) seat; unchanged. |
| warden | juror | SES / hardened-JS-boundary seat; unchanged. |
| wire-watcher | juror | Security-protocol-on-the-wire seat; unchanged. |

---

## TRANSLATE

Carry the substance, but rewire dispatch/coordination to the v2 job board +
gardener model, and apply the gamut→gauntlet vocabulary fix where present.

### Roles (18)

| name | kind | rationale | specific change |
|---|---|---|---|
| boatman | role | Upstream ferry still needed; identity-switch discipline preserved. | Triager posts a `ferry` job; a gardener (credentialed host) claims it instead of liaison/steward `Agent` dispatch. Keep host-precondition + identity-switch norm. |
| assayer | role | Per-change test authoring still needed in the gauntlet. | Invoked as a step in the gardener-supervised gauntlet script, not a separate `Agent` dispatch from steward. |
| botanist | role | Dependabot triage still needed. | Triager posts a `dependabot` job; gardener claims and runs the merge/embargo/reject decision. |
| builder | role | Core implement-and-open-DRAFT role; central to the gauntlet. | Job-board `build` job claimed by a gardener; gamut→gauntlet in any chain language. |
| cleaner | role | Coverage-maximization step still part of the gauntlet. | Becomes a step in the gardener gauntlet script (cf. v2 `gardening-state-machine`); drop steward/driver dispatch. |
| conductor | role | Merge-linearization still needed. | Triager `merge`/`run-the-gauntlet` terminal step posts a job; gardener claims. Replace "drain the steward's Merge queue" with job-board claim. |
| designer | role | Prompt→design-doc expansion still needed. | Job-board `design` job claimed by a gardener; researcher-precedence (if kept) becomes a script step, not an `Agent` pre-dispatch. |
| fixer | role | Review-feedback + CI shepherding; the loop half of panel→fixer-loop. | Driven by the scripted panel→fixer-loop a gardener supervises; replace steward/judge `Agent` dispatch with job-board / supervisor loop. |
| shepherd | role | Drive-CI-to-green still needed. | Triager `shepherd #N` directive → job; gardener claims. Keep shepherd→fixer auto-escalation as a script branch. |
| weaver | role | Rebase / merge-weaving still needed. | Triager `rebase`/`weave` directive → job; gardener claims; keep weaver→fixer escalation. |
| judge | role | Panel orchestration survives, but as a script. | Becomes the scripted panel→fixer-loop supervised by a gardener; the role file collapses into that workflow (it was already a redirect splitting into the three below). |
| solicitor | role | Design-panel orchestration survives. | Fold into the scripted design-panel run; gardener supervises the 7-seat panel instead of an `Agent`-dispatched judge. |
| barrister | role | First-round code-panel orchestration survives. | Fold into the scripted code-panel (first round) run under a gardener. |
| justice | role | Code-panel re-run orchestration survives. | Fold into the scripted code-panel re-run (fixer-loop iterations) under a gardener. |
| appellate | role | Verdict-appeal-of-deferrals logic survives. | Becomes a decision step in the scripted panel→fixer-loop (appeal small-and-in-context deferrals before un-draft); not a standalone dispatch. |
| librarian | role | On-demand journal search still useful. | Any agent posts a `librarian` job to the board (or asks via message-bus) instead of `Agent`-dispatching directly; v1 `driver-librarian-workflow` lane superseded by gardener pool. |
| researcher | role | Library/project-reference gathering before design/build is valuable. | Becomes a script step (or a posted `research` job) feeding the gardener's design/build job, not a liaison/steward `Agent` pre-dispatch. |
| monitor | role | Repo-activity watching survives — but it is the v2 **triager/watchman** function. | Re-home onto v2 `triager` (per-repo PR-comment watch) + `watchman` (main2 evolution); the monitoring-safety repo-gating constraint carries. |

### Skills (39)

| name | kind | rationale | specific change |
|---|---|---|---|
| pr-creation-flow | skill | The PR-lifecycle chain is the gauntlet's spine. | Re-express as the gardener gauntlet script's stages; gamut→gauntlet; replace per-role `Agent` handoffs with script steps. |
| ci-failure-classification-loop | skill | The OODA loop driving red-CI to green is the gardener supervisor loop. | Re-home onto the gardener-supervised script; replace "orchestrator re-prompt" with the script's `loop` signal. |
| pre-pr-checklist | skill | Pre-PR gate still needed. | Run as a gauntlet script step; drop steward dispatch framing. |
| pre-push-gates | skill | Deterministic pre-push gate still needed. | Keep; reference builder/fixer-as-script-steps; ensure paths point at v2 `scripts/`. |
| pr-formation | skill | PR title/body discipline still needed. | Keep content; consumed by the script's PR-open step. |
| pr-handoff | skill | Ferry git mechanics still needed. | Keep; consumed by the `ferry` job a gardener claims (boatman translation). |
| pr-ci-watch | skill | Per-PR CI-status watch still needed. | Keep; called from the gardener gauntlet / shepherd step. |
| github-activity-poll | skill | Conditional-GET repo polling still needed. | Re-home onto the v2 triager/watchman producers (last-seen markers in `GARDEN_STATE`, per job-board design). |
| activity-feed-watcher | skill | Per-feed watcher contract maps to the triager. | Translate to the v2 triager-handler contract; standing markers under `GARDEN_STATE`. |
| at-mention-surveillance | skill | @-mention surfacing → triager's PR-comment watch. | Re-home onto the v2 triager; replace "steward dispatches fixer" with "triager posts a job". |
| review-queue-poll | skill | kriskowal pending-review polling still useful. | Re-home as a triager/watchman producer; canonical-set file under `GARDEN_STATE`, not `/tmp`. |
| panel-review | skill | The two-panel jury procedure runs the panels. | Keep panel composition; replace judge-`Agent` orchestration with the scripted panel run a gardener supervises. |
| panel-hints | skill | Diff-signal recommender feeds the panels. | Keep; consumed by the scripted panel run instead of the three judge roles. |
| saboteur-adversarial-review | skill | Adversarial-review procedure feeds the saboteur seat. | Keep; consumed by the scripted code-panel. |
| adversarial-tests | skill | Adversarial-test authoring still needed. | Keep; consumed by assayer/builder script steps. |
| regression-evidence | skill | Regression-evidence discipline feeds the prover seat. | Keep; consumed by the scripted panel / builder step. |
| coverage-driven-testing | skill | Coverage discipline feeds the cleaner step. | Keep; consumed by the cleaner script step. |
| node-parity-test | skill | Parity-claim substantiation still needed. | Keep; consumed by builder/assayer script steps. |
| retcon | skill | Reset+restage discipline still needed. | Keep; triager `retcon #N` directive → job (already named in v2 job-board design). |
| conflict-resolution | skill | Conflict discipline feeds the weaver job. | Keep; consumed by the weave/rebase job. |
| rebase-before-followup | skill | Rebase-before-followup discipline still needed. | Keep; consumed by the fixer/followup script step. |
| rebase-hygiene-audit | skill | Rebase-hygiene audit still useful. | Keep; consumed by weaver/conductor step. |
| cherry-pick-followup | skill | Cherry-pick followup still needed. | Keep; consumed by the fixer/followup step. |
| review-feedback-followup-commits | skill | Followup-commit discipline still needed. | Keep; consumed by the fixer step. |
| pr-review-thread-replies | skill | Inline-reply discipline still needed. | Keep; consumed by the fixer step. |
| reactji-acknowledgment | skill | Reactji-ack still useful. | Keep; consumed by triager/gardener acknowledgment step. |
| changeset-discipline | skill | Changeset discipline feeds builder + several seats. | Keep; consumed by builder/cleaner script steps. |
| yarn-lock-separate-commit | skill | Separate-lockfile-commit discipline still needed. | Keep; triager `retcon` job already specifies this split in v2 design. |
| rename-discipline | skill | Rename discipline feeds builder + stylist seat. | Keep; consumed by builder script step. |
| frozen-base-branch | skill | Frozen-base-branch discipline still needed for fork PRs. | Keep; consumed by the PR-open step. |
| pr-dependency-graph | skill | Per-PR dep registry still useful. | Keep; registry lives in `journal2`; consumed by gauntlet ordering. |
| pr-dependency-topo-sort | skill | Topo-sort of PRs still useful. | Keep; consumes the dep graph above. |
| stacked-pr-build | skill | Stacked-PR build still needed. | Keep; consumed by the build job. |
| gap-revealing-build | skill | Probe-build (gap-report) deliverable still useful. | Keep; triager `probe #N` → job; PR stays DRAFT (no gauntlet chain). |
| design-to-pr-pipeline | skill | Roadmap→initial-PR seeding maps to the triager/poller producer. | Translate the producer to post `build` jobs to the v2 board (replaces design-poller/general-contractor). |
| design-dependency-walk | skill | Design-dependency walk still useful before a build. | Keep; consumed by the design/build job's preparation step. |
| verify-upstream-state-before-pinning | skill | Upstream-state verification still needed. | Keep; consumed by botanist/major-general jobs. |
| node-lts-window-watch | skill | Node-LTS sensor+planner+driver still useful. | Re-home the driver portion onto a triager/poller producer + gardener job. |
| context-library | skill | Agent-optimized journal docs convention still useful. | Keep; point at `journal2` layout; consumed by scholar-style doc jobs. |

---

## LEAVE_BEHIND

Either superseded by an existing v2 mechanism, an artifact of the retired
steward/driver/orchestrator dispatch model, or a `references/`-adopted upstream
copy whose home is the reference shelf, not the active library.

### Roles (12)

| name | kind | rationale |
|---|---|---|
| steward | role | Explicitly retired; its autonomous PR-pipeline work is the gardener-script fleet. |
| gardener (v1) | role | v1 "gardener" = liaison's meta-evolution deputy; that name is reassigned in v2 to the job consumer. v1's meta-evolution function maps to the v2 `watchman` (main2 evolution) / liaison, not a carried role. |
| liaison | role | Already exists in v2 (`roles/liaison/`); implicit garden-root agent. No carry needed. |
| evaluator | role | A/B garden-comparison agent tied to the retired steward/driver replay-chain harness; not part of the v2 job-board model. |
| journalist | role | Bulletin/review-list maintenance tied to the v1 journal layout + steward survey; the v2 bus narrates via `entries/` + message-bus, no standing bulletin role. |
| review-queue | role | Standing review-queue daemon role; its polling function re-homes onto a v2 triager/watchman producer (skill TRANSLATEd separately), so the role itself is not carried. |
| scholar | role | Cadence-driven journal/doc grower tied to the v1 timekeeper + journal layout; doc growth is a posted job in v2, not a standing role. |
| scout | role | `references/`-adopted perf-tradeoff role; lives on the reference shelf, dispatched as a one-off job if needed — no active-library carry. |
| investigator | role | `references/`-adopted hypothesis-investigation role; reference-shelf, one-off job if needed. |
| major-general | role | `references/`-adopted major-version-upgrade scout; reference-shelf; its sensor maps to a triager/poller if revived. |
| groom | role | `references/`-adopted roadmap-maintenance role; reference-shelf; roadmap upkeep is a posted job if revived. |
| timekeeper | role | Scheduler role superseded by v2 `skills/schedule` + the systemd timer fleet (scaler/reaper/repo-watcher/watchman). |

### Skills (44)

| name | kind | rationale |
|---|---|---|
| inbox-drain | skill | Superseded by v2 `skills/message-bus` (directed inbox `unread→read` CAS). |
| journal-sync | skill | Superseded by v2 `skills/job-board` + `message-bus` git-CAS append model. |
| scheduling | skill | Superseded by v2 `skills/schedule` + systemd timers. |
| dispatch-worktree | skill | Superseded by v2 `skills/dispatch-worktree` (already present) + per-gardener worktrees. |
| worktree-per-pr | skill | Superseded by v2 `skills/worktree-per-pr` (already present). |
| autonomous-loop-pacing | skill | Steward/loop pacing artifact; superseded by gardener-loop + systemd-timer cadence. |
| agent-termination | skill | Long-living-subagent termination-report artifact of the `Agent`-dispatch model; v2 jobs complete via `complete-job.sh`. |
| model-selection | skill | Per-role model table for `Agent` dispatch by orchestrator/judge; superseded by gardener-script handler model choice. |
| self-improvement | skill | Per-engagement role/skill-evolution artifact; v2 evolution is the watchman's job over `main2`. |
| rule-elision-test | skill | Role/skill-compaction meta-tool tied to the v1 gardener role; reference-shelf at most. |
| prompt-section-discovery | skill | `references/`-adopted prompt-archaeology skill; reference-shelf. |
| process-documents | skill | `references/`-adopted; reference-shelf. |
| journalism | skill | v1-journal-layout user manual; superseded by v2 `journal2` layout + message-bus. |
| library-lookup | skill | v1 `journal/library/` lookup; superseded by v2 journal layout (revisit if a v2 library lands). |
| design-poller | skill | `garden-design-poller` systemd daemon superseded by the v2 triager/poller producer + gardener pool. |
| design-queue-drift-check | skill | `references`-adopted, tied to the design-poller/general-contractor producer; superseded. |
| driver-pr-creation-state-machine | skill | Driver-lane skill; driver superseded by gardener pool (v2 `gardening-state-machine`). |
| driver-design-only-pr-workflow | skill | Driver-lane skill; superseded by gardener pool. |
| driver-gardener-workflow | skill | Driver-lane skill; the v2 gardener supersedes the driver-lane gardener. |
| driver-librarian-workflow | skill | Driver-lane skill; superseded by gardener pool / posted librarian job. |
| gardener-inbox-error-reporting | skill | Driver-shell error-reporting pattern; superseded by v2 gardener-script error handling + message-bus. |
| prompt-on-failure-capture | skill | Driver-shell capture-by-SHA pattern; v2 uses `GARDEN_TRACE`/`prompt-on-failure` in the gardening script. |
| pre-dispatch-grep-gate | skill | `scripts/checks/` gate pattern tied to the driver-dispatch flow; superseded by v2 script gates if revived. |
| ci-status-summary | skill | `references/`-adopted; reference-shelf (CI summarization folded into pr-ci-watch usage). |
| ci-runtime-comparison | skill | `references/`-adopted perf-runtime comparison; reference-shelf. |
| benchmark-comparative-report | skill | `references/`-adopted benchmark-report; reference-shelf (tied to scout/evaluator). |
| garden-ab-evaluation | skill | A/B garden-evolution procedure tied to the retired evaluator/steward replay harness. |
| velocity-recalibration | skill | `references/`-adopted roadmap-velocity skill; reference-shelf (tied to groom). |
| roadmap-projection | skill | `references/`-adopted roadmap-projection; reference-shelf (tied to groom). |
| dependency-graph-maintenance | skill | `references/`-adopted design-dep-graph upkeep; reference-shelf (tied to groom). |
| groom-open-questions | skill | `references/`-adopted; reference-shelf (tied to groom). |
| merged-pr-feedback-watch | skill | v1-gardener merged-PR-feedback procedure; superseded by the v2 watchman / a posted job. |
| monitor-arming | skill | `Monitor`-tool-over-daemon arming tied to the steward/monitor model; v2 uses systemd timers + the liaison maintainer-watch Monitor. |
| monitor-endo-but-for-bots | skill | Per-repo monitor reaction config for the v1 `monitor` role; re-authored as triager config in v2, not carried as-is. |
| monitor-garden | skill | Per-repo monitor reaction config (liaison-dispatched); re-authored against v2 watchman/triager. |
| monitor-endo | skill | DORMANT per the v1 monitoring-safety constraint; not in the v2 safe-to-watch set. |
| monitor-agoric-sdk | skill | DORMANT; not in the v2 safe-to-watch set. |
| monitor-cosgov | skill | DORMANT; not in the v2 safe-to-watch set. |
| em-dash-style | skill | House style rule; absorb into v2 `roles/COMMON.md` once written, not a standalone carried skill. |
| no-latin-shorthand | skill | House style rule; absorb into v2 `COMMON.md`. |
| relative-paths | skill | House style rule; absorb into v2 `COMMON.md`. |
| test-title-spec-spelling | skill | Narrow house style rule; absorb into `COMMON.md` / spec-keeper-seat guidance. |
| job-board (v1) | skill | v1 `journal/jobs/` claim/complete skill; superseded by v2 `skills/job-board` (already present) over `journal2`. |
| cleaner (skill) | skill | v1 driver-pool per-role executable for the cleaner; the executable lives under v2 `scripts/jobs/gardening/`, not as a carried skill (cleaner is a gauntlet script step). |

> Style-rule note: `em-dash-style`, `no-latin-shorthand`, `relative-paths`, and
> `test-title-spec-spelling` are left behind **as standalone skills** but their
> substance should be folded into the v2 `roles/COMMON.md` when it is authored
> (the v2 README notes COMMON.md is "not yet written").
