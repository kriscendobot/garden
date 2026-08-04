# The control-surface gallery: how maintainers actually steer the garden

A living gallery of real maintainer dispatches, each a worked illustration of a
garden control surface pulled in a novel or instructive way. Every entry is
grounded in the journal: the cited `journal/...` path (a file on the orphan
`journal2` branch, checked out at `journal/` in a running instance) holds the
original ask or the report of what the garden did with it. Read this page to
learn the levers by example; the reference itself is
[README § Key vocabulary and § Control surfaces](../README.md) and CLAUDE.md
§ Orchestrator vocabulary. This page holds no procedure: for "how do I do X" go
to [operations/](operations/README.md); for "why is X shaped this way" go to
`designs/`.

New entries land here, in the section for the surface they exercise, in the
same shape: the maintainer's phrasing or intent, the lever it pulled, what the
garden did, and why that lever was the right one, with a journal citation.
Quotes are verbatim where marked; everything else is a close paraphrase of the
cited record. When a section's examples start repeating a pattern, prune to
the most vivid one.

## The board and jobs

Everything becomes a job: a file on the `journal2` branch that any eligible
gardener races to claim, with an accepted `git push` as the serialization
point and a short deterministic basename as the job's identity. The basename
discipline is not cosmetic; it is what makes re-issued asks idempotent and
compound dispatches safe to repeat.

- **A compound directive re-issued into a race, safely.** A job asked a
  gardener to merge PR #284 and then post the next-phase build job. A peer had
  executed both halves 63 seconds before the claim landed. Instead of
  duplicating, the claimant verified the merge SHA, confirmed the next-phase
  job was alive in `jobs/doin/`, and completed as a deliberate no-op. The
  deterministic basenames and the board's claim race are what let the
  maintainer re-issue a compound ask without fear of double execution
  (`journal/jobs/tada/ebfb-pr-284-conduct-and-post-next-phase.md`).

- **A review sweep that survived its own reaper.** A maintainer ask to review
  and fix the entire ~22.5k-line `scripts/` tree on Fable ran long enough to be
  requeued five times. Because the job's worktree and spec are board state, each
  incarnation resumed the same work; twice the new incarnation found its
  predecessor still alive editing the shared job worktree, terminated it at a
  clean-tree moment, and posted that infrastructure defect as a follow-up job
  with evidence. The board is not just dispatch, it is the recovery substrate
  (`journal/jobs/tada/fable-review-fix-garden-scripts.md`).

## The message bus

Directed messages ride per-doer inboxes on the journal; a running job has a
bus address keyed by its basename, and the maintainer's replies route back
into the asking worker's inbox mid-flight. The bus is how a job's spec stays a
living document, and how peers deconflict without a coordinator.

- **One job steered twice without restarting.** kriskowal's CHANGES_REQUESTED
  review on endo-but-for-bots #594 ("Please use JavaScript for the driver
  script. Use zx if that helps keep it concise...") was folded into a related
  in-flight strategy job as a message to the job's own bus address. Four hours
  later a second message rescoped the same job to advisory-only ("do NOT push
  code to #594") because a dedicated fixer now owned the branch. The job's
  requirements were amended and then shrunk, twice, with no repost
  (`journal/msgs/job/ebfb-lint-master-strategy-evidence/20260702T102624Z-b37ca1.md`,
  `journal/msgs/job/ebfb-lint-master-strategy-evidence/20260702T142214Z-ef4596.md`).

- **The surfaces running in reverse.** After the foreman reported six times
  that the fleet had no buildable work left, the liaison digested 42 unread
  inbox messages into one ordered review list for the maintainer: tiered by
  how many stacked PRs each merge unblocks, every entry re-verified open and
  mergeable, with a separate section for items needing a decision rather than
  a review. The bus is bidirectional: here the garden steers the maintainer,
  naming his review bandwidth as the bottleneck and pricing each merge
  (`journal/entries/2026/07/10/162535Z-message-liaison-3c97e1.md`).

- **Peers deconflicting over the bus on one PR.** Two gardeners raced the same
  approved review on endo-but-for-bots #58 and landed byte-identical fix
  commits. The job holder deconflicted over the bus (the peers stood down on
  the merge), unfroze the frozen base after a clean trial merge, merged, and
  flagged the duplicate-job posting as a triager defect to fix. Concurrent
  claims are expected; the bus is where the survivors negotiate
  (`journal/jobs/tada/ebfb-pr-58-makeexo-fix-and-conduct.md`).

## The plan queue

Parked jobs live in `jobs/plan/` with a `gate:` that says what promotes them:
`deferred` (the foreman promotes when the board idles), `go-ahead` (only an
explicit maintainer authorization), `blocked` (a deterministic watcher
promotes when the named blocker completes), or `orchestrated` (only an
orchestration record). The gate field encodes the authorization boundary
directly into board data.

- **The plan queue as a security airlock.** The minion.town open-signup flip
  (the consequential change: the site opens to all authenticated users) was
  parked as a fully specified `gate: go-ahead` job whose body names exactly
  which maintainer decisions a promotion implies; the foreman is forbidden
  from auto-promoting go-ahead jobs. A sibling record shows the gate teaching
  its own vocabulary: a parked verification job embeds the exact sentence that
  resumes it, "go ahead on verify-ymax0-hex-fix-inquisitor," so the promote
  phrase is discoverable at the moment of decision
  (`journal/jobs/plan/open-signup-gate-flip-minion-town.md`,
  `journal/jobs/plan/verify-ymax0-hex-fix-inquisitor.md`).

- **"Don't page the maintainer; park with `blocked_on`."** A maintainer
  directive (2026-06-27) redirected blocked gardeners away from free-text
  "please wait" messages: post a structured block signal instead. The
  machinery landed the same day: `block-job.sh` parks the job as a blocked
  plan with a `blocked_on:` field, and the `garden-unblock` timer promotes it
  back to `todo/` the moment the blocker merges, closes, or reaches `tada/`.
  A negation answered with a replacement mechanism, not a rule
  (`journal/msgs/broadcast/20260627T191656Z-928984.md`).

- **A months-long campaign as a relay of parked jobs.** The XS-to-Rust engine
  port runs as a standing Fable supervisor that checkpoints itself into the
  board: each stage posts its own continuation (`-s2`, `-s3`, ... `-s18`)
  parked `--blocked --blocked-on` the stage before it, so the unblock watcher
  revives the supervisor the moment its predecessor completes. No idle
  polling, no long-blocked claim for the reaper to doom; by stage 18 the
  handoff header narrates quantitative acceptance bars (60 CESU-8 divergences
  remaining) and a kill criterion checked each round
  (`journal/jobs/tada/port-xs-to-rust-memory-safe-engine.md`,
  `journal/jobs/plan/port-xs-to-rust-memory-safe-engine-s18.md`).

## Orchestration jobs

The standing decomposition: a multi-part ask becomes parked child jobs plus
one orchestration record that promotes them in sequence or all at once,
watches each to completion, and applies a declared failure policy. The
orchestrate watcher is deterministic (no model call); the intelligence lives
in the decomposition.

- **The pattern itself was a dispatch.** kriskowal (2026-07-01): for a
  multi-part job, always make an orchestration job that moves parked sub-jobs
  onto the board in sequence or parallel and watches the children so no
  follow-up is forgotten. A gardener built `post-orchestration.sh` and the
  leader-only `orchestrate.sh` timer on the same promote-when-the-board-
  reaches-a-state substrate as `unblock.sh`, added the `on-child-failure:
  halt|continue` policy, and encoded the standing pattern into CLAUDE.md and
  the role briefs
  (`journal/jobs/tada/garden-build-orchestration-job-pattern-sequence-and-watch-children.md`).

- **A design tension compiled into a halting pipeline.** kriskowal's directive
  on the endo #127 stack (keep a working normative JS glob/grep, leave room
  for performance pushdown into @endo/platform, decouple glob from grep)
  became a three-child serial orchestration: design on Fable, build on Opus,
  then the gauntlet, with `on-child-failure: halt` chosen explicitly "so a
  design tension can be re-pondered rather than merged past"
  (`journal/jobs/orch/orch-endo-glob-grep-pushdown.md`).

- **One CAS commit arms a whole workstream.** The four minion.town OAuth
  stage-2 phases were pre-parked as `orchestrated`-gated children, then a
  single `post-orchestration.sh --parallel --on-child-failure continue` record
  promoted all four at once, with each failure isolated rather than halting
  the fan-out (`journal/jobs/tada/minion-town-oauth-fanout.md`).

## Schedules

Recurring and one-time jobs are journal files raced on by compare-and-swap,
dispatched by the sole leader-side scheduler, so the schedule set is shared
across hosts rather than hidden in a crontab. The novel uses treat schedules
as alarm clocks, undo timers, and standing supervisors.

- **"Turn it up now, and schedule the turning-down."** The maintainer paused
  two efforts and boosted two related schedules to a 30-minute cadence, both
  until Saturday morning. Each temporary change was paired with a `once:`
  schedule that reverses it: one re-runs `set-schedule.sh <name> 6h` to drop
  the cadences back, the other un-pauses the parked schedules, re-creates the
  halted orchestration over only the still-parked children, and restores the
  foreman's concurrency target, messaging the maintainer the exact commands if
  it happens to fire on the wrong host. The garden schedules its own
  un-pausing (`journal/schedules/xs2rust-xst-cadence-restore-6h.md`,
  `journal/schedules/xs2rust-xst-reactivate.md`).

- **A PR comment compiled into a self-retiring supervisor.** kriskowal on
  endo-but-for-bots #612: "push this through to implementation ... check in
  once per day and chase the dependencies down until the whole tree is merged
  and confirmed operational." That sentence became a daily schedule whose
  every firing is one supervisory engagement: reconstruct the dependency tree
  read-only, push the single next unblocked step by posting board jobs, check
  in with the maintainer, and retire the schedule itself when the tree is
  operational. The supervisor never implements anything
  (`journal/schedules/exo-google-sheets-impl-supervisor.md`).

- **Idempotency by naming, across weeks.** kriskowal's decision on PR #89:
  "We are embracing a dependency on Pi at this time. Please schedule a weekly
  job to watch for new releases and propose migrations if necessary." The
  weekly schedule posts a proposal job keyed `propose-pi-bump-<version>` only
  for versions not already tracked, so a later week can never duplicate a
  proposal. No state file, just the basename discipline doing the dedup
  (`journal/schedules/pi-release-watch.md`).

- **A standing pressure with the injection boundary drawn in ink.** A
  maintainer charter delivered as a comment on draft PR #600 (press the
  xs2rust-endor implementation until the daemon integrates and test262
  reaches parity) runs as a 30-minute schedule dispatching a model-pinned
  Fable driver, with a preflight script gating each dispatch. The schedule
  body names the PR comment as the directive's source while instructing that
  any quoted comment text is untrusted data: the charter encoded in the
  schedule is the instruction, the live thread is evidence only
  (`journal/schedules/xs2rust-endor-press.md`).

## The gauntlet and the PR-creation chain

"Run the gauntlet #N" drives a PR through clean, panel review, fix-loop, and
un-draft, with the panel alone authorized to mark a PR ready. The instructive
dispatches show the chain adapting: to cold third-party PRs, to designs that
want interrogation rather than shipping, and to moments when the maintainer
deliberately dials the process weight down.

- **The gauntlet pointed at a stranger's PR.** A sender-gated "@kriscendobot
  please review" mention put kumavis's 4345-line @endo/privacy-cards PR
  through the cold-PR gauntlet path: real typecheck/lint/test runs, a
  seat-matched panel verifying the budget-escrow capability invariant, then
  only the one mechanical must-fix (a missing changeset) actually pushed. Code
  judgments were flagged to the human author in a COMMENTED review rather than
  imposed; the register was chosen deliberately for someone else's work
  (`journal/jobs/tada/mention-endojs-endo-but-for-bots-604-gauntlet.md`).

- **"Probe #N": code written to interrogate a design.** The captp
  error-identification design was probed with a gap-revealing build: a DRAFT
  PR skeleton-implementing the design that surfaced seven structured gaps,
  identified the load-bearing crux (return-shape string versus console), and
  stayed draft on purpose, as a discussion artifact for the design's authors.
  No cleaner, no panel, no un-draft: the draft state is the contract
  (`journal/jobs/tada/endojs-endo-but-for-bots-pr595-probe-unredact-error.md`).

- **The authorized express lane.** The same lint fix rode two processes at
  once: the master-side PR #594 stayed in the full review chain, while a
  maintainer-authorized job replicated the fix onto the llm branch and merged
  it immediately, "the authorized fast unblock, no full gauntlet," to unshackle
  waiting shepherds. Process weight is per-dispatch, not per-repo
  (`journal/jobs/tada/ebfb-replicate-pr594-lint-fix-on-llm-and-merge.md`).

## Steering PRs by comment

On watched repos, a deterministic comment watcher recognizes the branch-op
verbs in imperative position, acknowledges with a reactji, and posts a board
job with a basename derived from the comment. GitHub comments become a
first-class command surface, with the failure modes on the record too.

- **The verbs go live, loss-proof by ordering.** The arming broadcast for the
  comment watcher (endo-but-for-bots only, per the monitoring safety
  constraint) fixed the pipeline's order of operations: recognize
  rebase/retcon/refresh/shepherd/run-the-gauntlet, acknowledge the comment
  with 👀 first, post the `<slug>-pr<N>-<verb>` job, and advance the cursor
  only after the post is confirmed on `origin/journal2`. A crash at any point
  re-delivers rather than drops
  (`journal/msgs/broadcast/20260624T204951Z-15135d.md`).

- **"Please retcon and conduct. This is ready to merge."** One comment on PR
  #277 drove a whole chain, and the worker inserted the safety step the verbs
  did not spell out: a blind reset onto the moved base would have reverted
  unrelated work, so it rebased onto the current base first, then restaged
  eight commits into one conventional commit, proved the tree byte-identical,
  and force-pushed with lease en route to the merge
  (`journal/jobs/tada/endojs-endo-but-for-bots-pr277-retcon.md`).

- **"Please refresh" fans out into done, and withheld.** kriskowal on PR #133:
  "we migrated the Chat app to preact. Please refresh. Also, refresh the title
  and description of the PR per the github template." The gardener refreshed
  the title and body immediately but withheld the branch refresh: the preact
  migration had turned a mechanical rebase into a re-implementation colliding
  with a genuine design conflict, so it messaged the maintainer three
  decision-ready options with a recommendation instead
  (`journal/jobs/tada/endojs-endo-but-for-bots-pr133-refresh.md`).

- **When the verb classifier guesses wrong.** A feature-refinement directive
  on PR #405 was misclassified as "rebase." The claimed job found the PR
  already mergeable, recognized the comment as something the classifier had no
  verb for, refused the no-op rebase, routed the real directive to the
  maintainer inbox, and posted a garden-infra job to add an "attention"
  fallback, with this comment as the regression fixture. The dispatch layer
  patches itself (`journal/jobs/tada/endojs-endo-but-for-bots-pr405-rebase.md`).

## The fix, weave, and shepherd loop

Fixers address review feedback, weavers rebase and resolve conflicts,
shepherds drive CI green. The instructive episodes are the ones where the
mechanical verb turns out to hide a judgment call, and the worker converts the
job into the right question instead of forcing the motion.

- **A weave that explains why frozen bases exist.** PR #510 had merged onto a
  frozen base 186 commits behind the live branch, so its content never reached
  trunk. The weaver cherry-picked its four commits forward, discovered direct
  pushes to the trunk are ruleset-blocked, opened and merged a carrier PR to
  land them, cut a fresh frozen base, rebased the dependent PR onto it, and
  flagged five sibling PRs stranded on the old snapshot
  (`journal/jobs/tada/weave-sturdyrefs-onto-live-llm.md`).

- **A shepherd that refused to drive the wrong thing green.** Resuming a
  shepherd on PR #301, the rebase revealed the PR's entire feature had been
  independently re-landed on the target branch by another PR; going green
  would have collapsed it to an empty diff. The shepherd aborted, identified
  the only two files with unique remaining value, and messaged the maintainer
  a decision-ready close-versus-extract recommendation, touching nothing
  (`journal/jobs/tada/endojs-endo-but-for-bots-pr301-shepherd-llm-resume.md`).

## Fleet operations

Drain, stand-up, stand-down, restore, and the worker-pool counts are the
liaison's direct levers, most of them journal state rather than process
state, which is why they survive resets and deploys.

- **One sentence, three levers, and a guarantee.** A maintainer-directed
  fleet-wide drain before a reset and upgrade fanned out into the leader's
  drain marker (nothing new claimed), the follower's journal-declared gardener
  count set to zero (the scaler winds down between claims, never mid-job), and
  a bus order to every liaison to hold all promotions until the maintainer
  confirms, with the explicit note that the journal-backed board outlives the
  machines being reset
  (`journal/msgs/role/liaison/20260710T162839Z-b1aa4e.md`).

- **The stale-drain trap, and what was deliberately not automated.** A drain
  marker that outlives a deploy leaves a fleet where every startup probe looks
  healthy while zero gardeners run. The fix added a bring-up step probing
  `drain-fleet.sh status` with an operator-confirmed lift, and recorded the
  negative-space decision next to it: auto-lifting was rejected because it
  would silently resume a fleet an operator intentionally paused. The rename
  episode that preceded it made the marker itself self-documenting: engaging
  the drain writes a prose body into the marker file saying what it means and
  how to lift it (`journal/jobs/tada/doc-startup-drain-restore-check.md`,
  `journal/jobs/tada/rename-killswitch-to-draining-marker.md`).

- **A worker declining to restart the fleet it is standing in.** The dispatch
  to wrap every service in the self-healing wrapper ended with 17 units
  wrapped and one deliberate omission: the doer did not mass-restart the
  gardener pool, "I am gardener@39 and a pool restart would interrupt
  in-flight claims (including this job)." Fleet-ops safety posture in one
  sentence (`journal/jobs/tada/apply-self-healing-wrapper-to-all-services.md`).

## Leader, follower, and the deliberate deploy

One journal marker names the leader; singleton services gate on it, gardeners
run everywhere. Re-pointing the marker is the act of raising a leader (there
is no automatic failover), and the root checkout only advances by a drained,
deliberate deploy.

- **A handoff conducted entirely over the bus.** To un-stick the leader-gated
  singletons, a follower's liaison took the marker, verified no split-brain by
  checking singleton activity timestamps, then broadcast a stand-down
  checklist to the former leader: drain, stop your maintainer-inbox Monitor
  (two liaisons must never double-answer), optionally remain as a pure
  follower, confirm quiesced on the bus
  (`journal/msgs/broadcast/20260629T153916Z-4ac889.md`).

- **Designation-is-raising has a failure mode.** A leadership handback was
  silently undone when the incoming leader host never came up and a deploy
  cutover re-took the marker; the second attempt broadcast the honest warning
  that until the named host comes up there is no leader running the
  singletons and production stalls. Pointing the marker at a dead host is a
  real outage, and the fleet narrates it rather than papering over it
  (`journal/msgs/broadcast/20260701T232453Z-ee7eaf.md`,
  `journal/msgs/broadcast/20260701T223158Z-02707b.md`).

- **The deploy that defers instead of dooming a drain.** One long mid-job
  gardener kept fleet-pausing every deploy attempt. The fix samples each
  gardener's busy-marker mtime before engaging the drain: the marker's age is
  exactly how long that worker has been mid-job, a deterministic long-job
  signal needing no model and no job introspection, and the deploy defers
  rather than starting a drain it cannot finish
  (`journal/jobs/tada/garden-deploy-defer-long-mid-job-gardener.md`).

## The ferry and identity

Ferrying carries approved work upstream under the maintainer's own identity,
so it is the garden's most permissioned surface: a flag only the maintainer
may originate, a host precondition, and a `gh` wrapper that makes every
human-identity call explicit and auditable.

- **The forensic ferry brief.** Before authorizing a ferry of one new tip
  commit onto upstream endojs/endo#3296, the liaison pre-verified parent blob
  equality so the cherry-pick would be a true fast-forward, then dispatched
  the boatman with an exacting recipe: detach at the upstream head (not
  master), cherry-pick, reset authorship to the maintainer, gate on empty
  trailers, strip the fork's PR-number suffixes, push without force, edit the
  cross-link. `identity_switch_authorized: true` rode the job; the constraint
  rode with it (`journal/entries/2026/06/04/034622Z-dispatch-liaison-8714f0.md`).

- **One-directional identity, per-call escalation.** The fleet's PATH-injected
  `gh` wrapper pins every call to the bot token, live per call, propagating
  even into subagents' shell calls; the maintainer's identity is reachable
  only by an explicit `GARDEN_GH_IDENTITY=kriskowal` on that one invocation,
  and resolution failure degrades loudly with a possible-identity-leak
  warning. This is the substrate that makes the ferry's authorization flag
  meaningful: escalation is grep-able
  (`journal/jobs/tada/harden-fleet-gh-identity.md`).

- **The gate holding under temptation.** A gardener on a credential-less host
  finished its work and found the only functioning credential was an SSH key
  authenticating as kriskowal. It refused ("this job carries no
  `identity_switch_authorized: true` and I am not the boatman") and instead
  delivered a complete landing kit to the maintainer's inbox: branch, SHAs, PR
  title and body, exact push commands. In a sibling episode a mention-triggered
  job advanced everything it could on PR #297 and stopped exactly at the ferry
  boundary, surfacing the ready-to-ferry PR as the open maintainer call
  (`journal/inbox/maintainer/read/20260704T170858Z-0fbe2f.md`,
  `journal/jobs/tada/endojs-endo-but-for-bots-pr297-17268b2c.md`).

## Watch sets and their arming

Standing watchers pull external text toward model contexts, so every widening
is a maintainer-authorized act recorded in the journal, and the un-gateable
surfaces substitute a deterministic sender-trust check that runs before any
text reaches a model. The instructive episodes are the arming ceremonies
themselves.

- **Built, tested, and deliberately not armed.** The GitHub-wide @-mention
  watcher shipped with its sender gate proven by test (allowlist or trusted
  org membership checked in plain code; untrusted mentions logged and
  discarded), the maintainer authorization recorded as required, and one thing
  withheld: the builder did not enable the unit, "actually arming a live
  monitor is a monitoring-safety action I left to an explicit run." The
  allowlist file doubles as its own authorization document, down to recording
  that the maintainer's "mathieu" resolved to the login mhofman
  (`journal/jobs/tada/build-github-mention-watcher.md`,
  `journal/trusted-senders/allowlist`).

- **Arming by writing state, trust one commit at a time.** The issue-inbox
  watcher is inert until `config/garden-repo` and `maintainers/allowlist`
  exist, so enabling the unit is harmless and writing the config is the
  deliberate arming act. The allowlist's git history is the audit trail of
  trust decisions, one login per commit over ten days. Usage followed
  immediately: issue #30 had a scholar study taskpeace.com and reply on the
  thread without closing it, and issue #23 ("activate the foreman and
  authorize loading up the work in progress to three active concurrent jobs")
  became a named concurrency knob with the authorization cited at the point of
  use (`journal/jobs/tada/issue-inbox-maintainer-interaction-workflow.md`,
  `journal/maintainers/allowlist`, `journal/jobs/tada/issue-kriskowal-garden-30.md`,
  `journal/jobs/tada/issue-kriskowal-garden-23.md`).

- **Three missed approvals become a standing widening.** kriskowal approved
  kriscendobot/minion.town#3 three times in one evening and the fleet never
  noticed. The response was a formally recorded authorization broadcast citing
  the misses by timestamp, plus the generalizing fix: `config/fork-owners`
  makes every own fork auto-watched by a provisioner, with a mandatory sender
  gate substituting for repo-gating because own forks may be public, and a
  `watch-optout/<slug>` tombstone as the only durable way to unwatch (a
  reconciler re-adds a bare deletion)
  (`journal/msgs/broadcast/20260709T225552Z-e61229.md`,
  `journal/jobs/tada/design-auto-provision-fork-watchers.md`).

- **Process change composed on top of a fresh arming.** The day minion.town
  entered the watch set, the maintainer flipped design delivery for that
  project: new design documents land as pull requests against main (the
  watched fork now draws review on them automatically) rather than as direct
  commits, forward-looking only. One surface's arming made another surface's
  process viable, and the maintainer composed them the same day
  (`journal/projects/minion-town/README.md`).

## Model selection

The model tier per role is a canonical map in code, and any job or schedule
can pin `model:` in its frontmatter to override it. The instructive dispatches
are where the pin came from and what it took to make it real.

- **A tier directive encoded where it cannot drift.** kriskowal (2026-07-02):
  designers ride Fable, builders the latest Opus, an explicit `model:` always
  winning. The doer found models were resolved per-job only and the skill the
  directive named was a dangling v1 pointer; it built the canonical map into
  `common.sh`, taught every producer to stamp `role:`, and rewrote the skill
  so the prose points at the executable source of truth rather than repeating
  it (`journal/jobs/tada/set-designer-fable-builder-opus-model-policy.md`).

- **Grow the capability, then use it.** The wish "rewrite the README as a
  usage tutorial, on Fable" required a per-job model pin that did not exist
  yet. The garden grew it first (the gardener handler learned to honor
  `model:` frontmatter, typo-safe), then ran the motivating job on Fable,
  which itself parked a deferred plan job for the CLAUDE.md drift its research
  exposed. One dispatch, three surfaces grown or fed
  (`journal/jobs/tada/garden-gardener-claude-honor-per-job-model.md`,
  `journal/jobs/tada/rewrite-garden-readme-usage-tutorial-fable.md`).

## Teaching the garden

"Encode this" turns a correction, a coinage, or a boundary into library text,
skills, and enforcement, so the maintainer never has to say it twice. The
strongest examples carry their negative space: what the new rule deliberately
does not authorize.

- **Coining a verb.** kriskowal (2026-05-14): "A new verb I would like to use
  is 'retcon' meaning 'Please reset this branch and restage the changes in
  sensibly grouped commits...'" One sentence extended the garden's command
  language; the dispatch minted the retcon skill with the exact semantics
  (per-package commits, separate yarn.lock commit, net diff invariant) and
  anticipated compound usage like "retcon and ferry." The verb is now
  watcher-recognized (`journal/entries/2026/05/14/230219Z-dispatch-liaison-c31b1c.md`).

- **A review annoyance becomes fleet law with an enforcer.** Maintainer
  feedback on PR #474 (silent pushes and inline-only replies are not enough;
  post a top-level summary comment after feedback-driven work) was written
  once as a skill, cited from six roles' definitions of done, added to the
  common etiquette, and, the novel move, taught to the scribe juror seat so
  the panel now flags exactly the gap that prompted it. Documented norms decay;
  enforced ones do not (`journal/jobs/tada/encode-pr-summary-comment-norm.md`,
  `journal/msgs/broadcast/20260625T170439Z-3ee0df.md`).

- **Delegating authority in one line.** After a gardener wrongly routed
  erights' PR directive to the maintainer inbox for separate authorization,
  kriskowal's one-line comment "erights has all the authority of a maintainer"
  was encoded as a standing rule: lifecycle directives from a
  maintainer-authority are self-authorizing, with the boundary spelled out
  that this confers no upstream credentials
  (`journal/projects/endo-but-for-bots/README.md`).

- **A grant and a ban, both absolute.** "You are generally authorized to post
  freely on endo-but-for-bots. It is yours" became a repo-scoped standing
  grant, carefully encoded with carve-outs for destructive actions and an
  audit obligation for every posted comment. Its mirror image is the ocapn
  project's rules: no comments on the upstream repo ever, no cross-references,
  no monitoring, under any identity, with the striking clause that even a
  ferry job carrying `identity_switch_authorized: true` must refuse a dispatch
  targeting upstream ocapn, and a closing "why" addressed to the next agent
  tempted to leave a quick comment
  (`journal/projects/endo-but-for-bots/README.md`,
  `journal/projects/ocapn/README.md`).

- **Information hiding as an enforced gate.** kriskowal (2026-06-28):
  issue- and PR-scoped agents talk to the maintainer through comments only;
  the maintainer inbox belongs to free-standing roles. The encoding classified
  every role, scrubbed the two leaks, and then built a verification gate that
  fails if a scoped role file, or any skill a scoped role loads, mentions the
  inbox, or if the token-bearing file set diverges from an in-commit
  allowlist. "Don't tell them the inbox exists" became a set-equality check
  (`journal/jobs/tada/comms-issue-pr-comments-not-maintainer-inbox.md`).
