# Design: the review-retrospective double loop (every PR comment indicts the review process)

| | |
| --- | --- |
| Created | 2026-07-03 |
| Author | designer (gardener, job `design-feedback-review-retrospective-loop`) |
| Status | Proposed |

Maintainer directive (kriskowal, 2026-07-03): for every comment on a PR in the
gardener workflow, dispatch **two** responses. The first addresses the feedback
as written (the comment-watcher's fixer / branch-op / review job, unchanged).
The second treats the feedback as an **indictment of the review process for
failing to anticipate it**: it tracks common patterns across similar failures
and, past a subjective threshold, dispatches a job to improve the roles,
skills, context library, or standing instructions, with a two-fold goal:
**prevent the error**, and **sense-and-correct the error in the review cycle**
so the panel catches the next instance instead of the maintainer.

The insight is Argyris's double-loop learning. A maintainer comment that a good
review should have caught is a review-process failure, not just a code defect.
Fixing the code closes the symptom (the single loop); the second loop closes
the cause. Today the garden runs only the single loop on maintainer feedback:
the comment becomes a job, the job fixes the artifact, and the knowledge that
the gauntlet missed something evaporates with the fix.

## Current state (verified against main2, 2026-07-03)

- `scripts/jobs/comment-watcher.sh` posts ONE job per recognized PR comment.
  Its observe-to-post path is fully deterministic (maintainer directive
  2026-07-01, no `claude -p` before a gardener claims). Its classifier already
  separates the comment classes this design needs: mechanical branch ops
  (`rebase`/`retcon`/`refresh`/`shepherd`/`gauntlet`), finalization
  (`finalize`), whole-review bundles (`review`, keyed on the durable review
  id), and trusted plain-language directives (`attention`). It computes a
  directive identity (`<repo>#<pr>:comment:<cid>` or `…:review:<id>`) for
  cross-producer dedup, and verifies every post landed before advancing its
  cursor.
- The scripted panel (`skills/panel/SKILL.md`, `scripts/jobs/gardening/panel.sh`)
  fans juror seats (`roles/jurors/<seat>/AGENT.md`) selected by the
  deterministic diff-signal recommender `skills/panel-hints/SKILL.md`
  (`probes/*.sh`, one probe per signal-triggered seat, growing catalog).
- The mentor (`roles/mentor/AGENT.md`, `scripts/jobs/mentor.sh`) watches
  journal progress/error entries plus `journalctl` warnings and posts
  automation-reliability improvement jobs. Its signal source is the garden's
  own telemetry, never maintainer feedback on work products.
- `roles/COMMON.md` § Improving your role and skills makes a per-engagement
  self-improvement pass the final task of every job and names
  `skills/self-improvement/SKILL.md` as canonical. **That file does not exist
  on main2.** The v1 reference shelf
  (`references/endo-but-for-bots/skills/README.md`) records the skill as
  "fully adopted into the active library and the snapshots removed", but the
  adopted copy was lost in the v2 migration; `roles/mentor/AGENT.md` still
  lists it as "to be migrated from v1". This design's build plan repairs that
  dangling reference first (stage 0), because the reconciliation story below
  leans on it.
- The foreman (`scripts/jobs/foreman.sh`) batch-promotes parked
  `gate: deferred` plan jobs, ranked by priority, whenever the fleet is under
  its active-job target. This is the existing cost valve the second loop rides.
- The journal (`journal2`) holds the board, cursors, per-instance config, and
  the curated `library/` tree governed by `skills/context-library/SKILL.md`.

## The mechanism at a glance

```
maintainer comment on a PR
        │
        ▼
comment-watcher (deterministic, unchanged classifier)
        │
        ├─► loop 1: the primary job (review/attention/branch-op/…)   UNCHANGED
        │
        └─► loop 2: IF the class carries substantive feedback
                    (VERB=review, or VERB=attention that reads as a directive)
                    post <primary-base>-retro as a deferred plan job
                            │  (foreman promotes on fleet slack)
                            ▼
                    prosecutor job (fleet-default tier)
                      1. discriminate: review-miss vs new-direction (recorded grounds)
                      2. record: journal review-misses/{misses,dismissed}/<id>.md
                      3. cluster: assign or mint review-misses/clusters/<slug>.md
                      4. threshold: floor + judgment, rationale recorded in the cluster
                            │  (only when the threshold trips)
                            ▼
                    review-improve-<cluster> job (builder tier, identity-deduped)
                      a. PREVENTION: edit the producing role / skill / library page
                      b. SENSING: a durable review check (juror-seat brief line +
                         panel-hints probe, or a pre-push gate when mechanizable)
                      c. close the cluster, citing what changed and how each
                         member miss would now be caught
```

A recurrence after closure reopens the cluster and escalates to the maintainer:
that is the signal the improvement did not take.

## Q1. Dispatch point and gate

**Dispatch point: the comment-watcher, immediately after the primary job's
post is verified.** The watcher already holds everything the retrospective
needs (repo, PR, surface, author, URL, the classified verb, and the directive
identity), and dispatching both loops from one place keeps their pairing
auditable: every retro names its primary. A separate watcher reading `tada/`
reports was considered and rejected: it would re-derive classification the
comment-watcher already did, add a polling service to the leader-only set, and
lose the comment identity that makes the retro idempotent.

**Gate: deterministic verb-class filtering, no LLM in the watcher.** The
2026-07-01 directive (fully deterministic observe-to-post) is preserved. The
watcher mints a retro only when the primary class can carry substantive
feedback on a work product:

- `VERB=review` (a trusted review: CHANGES_REQUESTED, inline comments, an
  approval bundled with asks): always eligible. The review-id fold means one
  review mints exactly one primary and therefore one retro, however many
  inline comments it carries.
- `VERB=attention`: eligible only when the already-computed
  `reads_as_directive` signal fired. Trusted chatter ("thanks, looks great!")
  mints an attention job for the reply but no retro.
- Everything else mints no retro. Mechanical branch ops (`rebase`, `retcon`,
  `refresh`, `shepherd`, `gauntlet`) are maintenance the review was never
  supposed to anticipate; a clean `finalize` is praise; untrusted and
  mention-only-filtered comments never get this far. (A maintainer having to
  *ask* for a shepherd is arguably an automation miss, but that is the
  mentor's telemetry loop, not the review loop; see Q5.)

**The subjective discriminator runs inside the claimed retro job**, not in the
watcher. The retro's first task is to judge: **"should the review have caught
this?"** A real miss is a bug, a style or spec violation, a missed edge case,
a violated convention the panel demonstrably knows (it is written in a seat
brief, a skill, or a standing instruction). Not a miss: new direction, taste,
scope change, a requirement first stated in the comment itself. The judgment
is recorded either way, with grounds (see Q2's record shape): a `dismissed`
verdict is as durable as a `miss`, so the same comment is never re-litigated
and the discriminator's calibration is auditable. To ground the judgment the
prosecutor consults the PR's actual review history: the gauntlet/panel jobs
for that PR in `journal/jobs/tada/`, and the panel's PR comments. A PR that
never ran a panel when the gauntlet should have run one is itself a miss
(category `process`).

**Posting discipline.** The retro base is `<primary-base>-retro`; its identity
is the primary's identity with a `:retro` suffix, so cross-producer duplicates
collapse exactly as primaries do. The retro post is **best-effort with a loud
WARN**: a lost retro never sets `fail_floor` or freezes the cursor. Rationale:
the primary is a maintainer directive (the never-drop discipline applies); the
retro is derived telemetry whose loss costs one data point, and freezing the
cursor for it would hold later directives hostage to a second-order concern.
The WARN lands in journalctl where the mentor's digest sees it.

## Q2. The review-miss store

**Journal, not library.** The store lives on `journal2` at top level:

```
review-misses/
  README.md                     # abstract + layout, per context-library discipline
  misses/<primary-base>.md      # one confirmed miss per file
  dismissed/<primary-base>.md   # one recorded non-miss per file (audit + idempotency)
  clusters/<slug>.md            # one pattern per file: members, count, status
```

Justification: the store is machine-appended structured evidence written by
many concurrent retro jobs across hosts, which is exactly the journal's
CAS-push append pattern (`jobs/`, `cursors/`, `entries/`). The `library/` tree
is the scholar's curated prose, governed by abstracts and partitioning for
*reading*; raw per-incident records would pollute it, and main2 is a deployed
library, wrong for high-churn state. The library is instead a *target* of the
loop: when an improvement job distills a cluster into durable guidance, a
library page is one of its legitimate outputs. Keying miss files on the
primary job base gives idempotency for free: if
`review-misses/{misses,dismissed}/<primary-base>.md` exists, the retro already
ran and the job completes as a no-op.

**Record shape** (YAML frontmatter plus a short body):

```yaml
---
kind: review-miss            # or review-miss-dismissed
ts: 2026-07-03T18:20:00Z
repo: endojs/endo-but-for-bots
pr: 594
comment_url: https://github.com/...#pullrequestreview-...
identity: endojs/endo-but-for-bots#594:review:4597029908
primary_job: endojs-endo-but-for-bots-pr594-review-ab12cd34
producing_role: builder       # who made the work product, when recoverable
producing_job: <base>         # the job that produced the reviewed work, when recoverable
category: missed-edge-case    # from the taxonomy below
missed_by: [corner-prober]    # seat(s)/stage that should have caught it
severity: moderate            # minor | moderate | major
verdict: miss                 # miss | not-a-miss
cluster: empty-input-boundaries   # only on verdict: miss
grounds: >
  One paragraph: why the review should (or could not) have caught this,
  citing the seat brief / skill / standing instruction that covers it.
---
The prosecutor's own paraphrase of the feedback and the diagnosed root cause.
```

The body is the **prosecutor's paraphrase, never the raw comment text**. The
comment is untrusted input; keeping the store bot-authored means downstream
improvement jobs read trusted summaries with a URL to re-fetch verbatim if
needed, and untrusted prose never propagates through the learning loop.

**Cluster file shape:**

```yaml
---
slug: empty-input-boundaries
category: missed-edge-case
status: open                  # open | improvement-dispatched | closed
count: 2
members:
  - endojs-endo-but-for-bots-pr594-review-ab12cd34
  - endojs-endo-but-for-bots-pr601-review-99fe21aa
prs: [594, 601]
improvement_job:              # set when dispatched
improved_by:                  # commits/files, set at closure
threshold_rationale:          # set when dispatched, by the prosecutor
---
Pattern statement, one or two sentences: what class of feedback keeps arriving
and which review stage keeps missing it.
```

**Taxonomy of review-failure categories**, chosen so every category maps to
the review surface that should gain the check (the Q4 dispatch routes on it):

| Category | Should have been caught by |
| --- | --- |
| `correctness-bug` | `breaker`, `saboteur`, `prover` |
| `type-error` | `typist` |
| `spec-violation` | `spec-keeper`, `pedant` |
| `style-convention` | `stylist`, `purist`, or a pre-push gate |
| `missed-edge-case` | `corner-prober` |
| `test-gap` | `fast-checker`, `prover` |
| `packaging-exports` | `packager`, `curator`, `surfacer` |
| `docs-drift` | `scribe`, `archivist`, `pruner` |
| `naming` | `ergonomist`, the rename-discipline skill |
| `security-hardening` | `locksmith`, `warden` |
| `wire-protocol` | `wire-watcher` |
| `migration-compat` | `migrator`, `releaser` |
| `process` | not a seat: the gauntlet chain, a skill, or a standing instruction failed to run or to bind |
| `new-direction` | nobody: the dismissal category (taste, scope, first-stated requirements) |

The taxonomy is a starting vocabulary, not a closed set; the prosecutor may
mint a category by adding it to the store README's table in the same push that
first uses it.

**Clustering procedure.** Deterministic first, judgment second: the prosecutor
lists `clusters/` filtered by the miss's `category`, reads the one-line
pattern statements, and either joins the best match or mints a new cluster.
A helper script (`scripts/jobs/review-miss-record.sh`, stage 1) owns the
mechanical half: the CAS push loop, the idempotency pre-check, appending the
member, bumping `count`, and updating `prs`. The LLM decides; plain code
writes.

## Q3. The subjective threshold

The threshold is the prosecutor's judgment, bounded by a floor and forced to
leave a paper trail:

- **Floor (default path):** a cluster is dispatchable when it holds **K ≥ 3
  misses spanning ≥ 2 distinct PRs**. The two-PR requirement stops one messy
  PR from masquerading as a systemic pattern.
- **Severity bypass:** a single `severity: major` miss may dispatch
  immediately, but only when the grounds cite a **standing rule that already
  exists and did not bind** (a seat brief line, a skill, a COMMON.md norm the
  work violated anyway). That case is a pure sense-and-correct failure: the
  knowledge existed, the review did not exercise it, and waiting for two more
  instances of a security-class or correctness-class miss is the wrong trade.
- **Judgment above the floor:** meeting the floor does not compel dispatch.
  The prosecutor may hold a cluster (members look coincidental after all, or
  the right fix is already in flight elsewhere) but must say so in the cluster
  body. Whatever the decision, `threshold_rationale` records it.

**Evaluation point: event-driven, at the tail of every retro that records a
miss.** The prosecutor re-reads the one cluster it just touched and evaluates
then and there. No scanning service, no new timer. Double-dispatch is
prevented deterministically twice over: `status: improvement-dispatched`
short-circuits the evaluation, and the improvement job's identity
(`review-cluster:<slug>`) collapses a race between two concurrent retros onto
one open job via the existing `jobs/index` dedup.

**Recurrence after closure:** a new miss joining a `closed` cluster reopens it
(status back to `open`, count continues) and the prosecutor messages the
maintainer (`message-user.sh`): the improvement demonstrably failed to
prevent or catch the pattern, and a second improvement round should not
proceed on autopilot.

## Q4. The improvement dispatch: prevention AND review-cycle sensing

When the threshold trips, the prosecutor posts **one** job,
`review-improve-<cluster-slug>`, identity `review-cluster:<slug>`, role
`builder` (it edits main2 roles/skills/scripts; builder rides Opus per
`skills/model-selection/SKILL.md`). The job body names the cluster file, every
member miss, and the two-part contract. Both parts are mandatory; a completion
that delivers only one is incomplete:

**(a) Prevention: the doing role stops making the error.** An edit to the
narrowest artifact that governs the producing work: the producing role's
`AGENT.md`, a skill's procedure or pitfalls section, a context-library page,
or `roles/COMMON.md` for a fleet-wide norm. Prose guidance is the floor, not
the ceiling: where the error is mechanically detectable at authoring time, a
pre-push gate (`skills/pre-push-gates`, scripts under
`scripts/jobs/gardening/`) beats an instruction an agent has to remember. This
is the mentor's standing bias (move judgment into scripts) applied to the
prevention half.

**(b) Sensing: the review cycle gains the ability to catch it.** A learned
pattern becomes a **durable review check**, not a prose note. Concretely, in
descending order of preference:

1. **A deterministic pre-push gate or panel-stage script check**, when the
   signal is mechanizable. Deterministic checks cannot forget.
2. **A juror-seat brief amendment plus a panel-hints probe.** The seat named
   by the cluster's `missed_by` gains an explicit check in
   `roles/jurors/<seat>/AGENT.md` (seat briefs are the panel's executed
   checklists: a line there runs on every panel where the seat fires), and,
   when the pattern has a diff signal, a probe under
   `skills/panel-hints/probes/` fires the seat on that signal (the skill's
   "Adding a probe" convention: probe and seat change land in the same
   commit). The panel-hints bias (err toward firing) means a loose probe is
   acceptable; a missed fire is not.
3. **A new juror seat**, only when no existing seat's lens covers the
   category, with its probe in the same commit. Expected to be rare: the
   26-seat code panel covers the taxonomy above.

**Verification: the re-litigation test.** The improvement job must close with
a per-member statement: for each miss in the cluster, name the exact check
(gate, probe + seat line, or seat) that would now catch it, and demonstrate
the probe fires on the historical diff where that miss occurred (panel-hints'
own smoke-test convention). Then it updates the cluster: `status: closed`,
`improved_by:` listing the commits and files. Garden-repo edits of this size
land directly on main2 per the CLAUDE.md convention (no self-PR); a change big
enough to warrant review goes through the designs-PR exception, at the
builder's judgment.

## Q5. Reconciliation with the existing self-improvement machinery

Three loops, three signal sources, no overlap:

| Loop | Signal | Scope | Cadence | Output |
| --- | --- | --- | --- | --- |
| `skills/self-improvement` (per COMMON.md; restored in stage 0) | the doer's own friction during one engagement | inward, single job | every job, at completion | a routed lesson: one-line report, a message to the liaison for structural changes |
| mentor (`roles/mentor`, `mentor.sh`) | journal progress/error entries + journalctl warnings | the automation: scripts, services, reliability | timer-driven digest | improvement jobs hardening scripts, moving judgment out of agents |
| **prosecutor (this design)** | **maintainer feedback on work products** | **the review process: panel, seats, gates, standing instructions** | event-driven, per qualifying comment | miss records, clusters, and dual-goal `review-improve-*` jobs |

The prosecutor is the only loop whose signal is "a human had to catch what the
gauntlet should have". The mentor sees a WARN when a retro post is lost, and
its digest may someday summarize the miss store, but no wiring between them is
required for either to work (kept out of scope). The improvement jobs the
prosecutor dispatches end, like every job, with the per-engagement
self-improvement line: the loops compose by each doing its own layer.
Boundary rule of thumb: *the work was wrong and review missed it* is the
prosecutor's; *the machinery misbehaved* is the mentor's; *my own process on
this job had friction* is self-improvement's.

`panel-hints` is not a fourth loop but the **actuator** the prosecutor's
improvement jobs write to: the probe catalog is how a learned pattern becomes
a standing, deterministic seat trigger.

## Q6. Cost and noise

A naive second job per comment doubles comment-driven dispatch. The controls,
all deterministic and all in the watcher or the board (no LLM spent on
non-qualifying comments):

- **Class filter (the big cut).** Only `review` and directive-reading
  `attention` comments mint retros. Branch ops, finalizations, chatter,
  untrusted and mention-only-suppressed comments mint nothing. On the current
  armed set (`endojs/endo-but-for-bots` only) substantive-feedback comments
  are a minority of watcher traffic.
- **One retro per review, ever.** The review-id fold and the `:retro` identity
  mean a review with N inline comments still yields one retro, and a re-poll
  or a peer producer collapses onto it.
- **Deferred, not competing.** Retros are posted with `post-plan.sh` as
  `gate: deferred`, `priority: low` plan jobs. The foreman batch-promotes
  deferred work only when the fleet is under its active-job target, so the
  second loop consumes slack capacity and never delays a maintainer's primary
  directive. (The board never idles them forever: the same foreman pass that
  tops up work drains the deferred queue in priority order.)
- **Cheap dismissal path.** The retro runs at the fleet-default tier (no
  model pin; the prosecutor gets no row in `role_default_model`), and a
  `not-a-miss` verdict is a single short pass: record the dismissal with
  grounds, complete. The expensive tier (builder/Opus) is spent only past the
  threshold, which by construction fires once per K misses, not per comment.
- **Idempotency everywhere.** Miss files key on the primary base; clusters
  dedup improvement dispatch by status and identity; a requeued retro is a
  no-op against its own record.

If volume still proves noisy after arming, the knob to add is a per-repo
retro rate cap in the watcher (deterministic, journal-configured), noted here
as a follow-on rather than built speculatively.

## New artifacts

- `roles/prosecutor/AGENT.md`: the retrospective role. Purpose line, skills
  list (`review-retrospective`, `job-board`, `journalism`, `message-bus`),
  norms (paraphrase untrusted text; grounds are mandatory; hold the floor),
  definition of done. The name joins the garden's judicial family (solicitor,
  barrister, justice, appellate, jurors): the prosecutor decides whether the
  evidence indicts the review process, builds the case across incidents, and
  files charges as an improvement job.
- `skills/review-retrospective/SKILL.md`: the canonical playbook: the
  discriminator with its recorded-grounds contract, the taxonomy table, the
  clustering procedure, the threshold rules, the improvement-job template
  (both deliverables plus the re-litigation test), and the recurrence
  escalation.
- `scripts/jobs/review-miss-record.sh`: the deterministic store writer (CAS
  loop, idempotency pre-check, member append, count bump, status guard), with
  tests beside the existing jobs-script tests.
- `journal review-misses/` tree, seeded with its README.
- The comment-watcher change: a `mint_retro` step after the primary
  post-verify, gated on the verb classes above, posting via `post-plan.sh`
  (deferred), best-effort with WARN.

## Staged build plan

Each stage lands independently on main2 and is a separate job; the chain is an
orchestration (`skills/orchestration`) so the follow-ups are watched, serial,
halt-on-failure. The build is blocked on this design's acceptance.

- **Stage 0: repair the self-improvement reference.** Migrate/reauthor
  `skills/self-improvement/SKILL.md` on main2 so `roles/COMMON.md` § Improving
  your role and skills and `roles/mentor/AGENT.md` stop dangling. Small,
  independent, and a prerequisite for this design's reconciliation story being
  true in the tree.
- **Stage 1: store, skill, role.** Seed `review-misses/` on journal2 (README
  + empty dirs); land `skills/review-retrospective/SKILL.md`,
  `roles/prosecutor/AGENT.md`, and `review-miss-record.sh` with tests. No
  behavior change yet: the store and playbook exist, nothing feeds them.
- **Stage 2: watcher wiring.** The comment-watcher mints `<primary-base>-retro`
  deferred plan jobs for qualifying classes, with test coverage in the
  watcher's existing stub-driven test (retro minted for review and
  directive-attention; not minted for branch ops, chatter-attention,
  finalize, untrusted; identity dedup; lost-retro WARN never freezes the
  cursor). After this stage the loop runs end to end through recording and
  clustering.
- **Stage 3: threshold and improvement dispatch.** The skill's threshold
  evaluation goes live: cluster status lifecycle, `review-improve-<slug>`
  posting with identity dedup, the dual-deliverable contract and
  re-litigation test, closure bookkeeping, recurrence-reopens-and-escalates.
- **Stage 4: observability.** A bulletin line for clusters at K-1 and open
  improvement jobs; optionally fold a miss-store summary into the mentor's
  digest. Nice-to-have; the loop is complete without it.

## Files inspected

`scripts/jobs/comment-watcher.sh` (classifier, fold, identity, post-verify,
cursor discipline), `scripts/jobs/mentor.sh`,
`scripts/jobs/handlers/mentor-claude.sh` (existence), `scripts/jobs/foreman.sh`
(deferred-plan promotion), `scripts/jobs/journal-entry.sh`,
`scripts/jobs/post-job.sh` / `post-plan.sh` surfaces via
`skills/job-board/SKILL.md`, `roles/mentor/AGENT.md`, `roles/COMMON.md`,
`skills/panel/SKILL.md`, `skills/panel-hints/SKILL.md`,
`skills/context-library/SKILL.md`, `skills/journalism/SKILL.md`,
`skills/model-selection/SKILL.md`, `designs/README.md`,
`designs/orchestration-jobs.md`,
`references/endo-but-for-bots/skills/README.md` (the v1 self-improvement
adoption record), and the journal2 top-level tree.
