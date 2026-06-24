---
title: Key moves
section-slug: garden--journal-jobs-README-md--eleventh-garden-source-and-job-board-contract-and-fourth-design-instance-pair
source-slug: garden--journal-jobs-README-md
url: https://github.com/kriskowal/garden/blob/journal/jobs/README.md
authors: [Endo project (collective; role-as-author convention)]
repo: kriskowal/garden
path: journal/jobs/README.md
total-lines: 143
ingest-cycle: 306
ingest-date: 2026-06-11
lane: chat
scope: full
branch: journal
parent: garden--journal-jobs-README-md--eleventh-garden-source-and-job-board-contract-and-fourth-design-instance-pair
---

- **§the-named-job-board-contract-shape** (first-explicit-observation): the eleventh named shape. The README IS the contract; the named skill (`skills/job-board/SKILL.md`) IS the procedural detail. **§the-named-contract-vs-procedure-split**: "This README IS the contract."

§the-named-board-IS-named-distributed-work-queue: opening line names "The job board IS the garden's distributed work queue." **§the-named-distributed-work-queue-shape**.

§the-named-producer-trio: "Producers (typically a liaison, a returning subagent, or a scheduled-engagement firing) post a job into `open/`". **§three-named-producer-shapes**.

§the-named-consumer-pair: "consumers (steward, general-contractor) race to claim it". **§two-named-consumer-roles**. NOTE: general-contractor was retired 2026-06-03 per cycle 299 CLAUDE.md; the README still references it. **§the-named-stale-reference-witness**: the document pre-dates the retirement.

- **§the-named-board-lifecycle-IS-the-journal-lifecycle** (first-explicit-observation):

> Its lifecycle is the journal's lifecycle: append-and-commit, push, fetch, retry. The git push is the serialization point that resolves claim races between concurrent consumers across hosts and within the same host.

**§the-named-board-lifecycle-IS-named-journal-lifecycle**. **§three-cycles-with-named-git-push-as-the-serialization-point** (cycle 299 CLAUDE.md named the property; cycle 301 COMMON.md named-git-as-the-coordination-primitive; cycle 306 names "The git push IS the serialization point").

§the-named-four-named-coresidents-on-the-journal-branch: "The board lives on the journal branch alongside the entries, inboxes, presence files, and worktree indices." **§the-named-four-named-journal-branch-citizens** (entries + inboxes + presence-files + worktree-indices + jobs/ = five total counting jobs/ itself).

- **§the-named-flat-board-vs-per-role-board** (first-explicit-observation):

```
jobs/open/<UTC>--<short-id>--<slug>.md          # flat board; any eligible role may claim
jobs/<role>/open/<UTC>--<short-id>--<slug>.md   # per-role board; only that role's workers claim
```

**§two-named-board-layouts**: flat + per-role. **§the-named-coexisting-flat-and-per-role-boards**: "Both coexist during the migration." **§the-named-migration-discipline-shape**: the new layout doesn't replace the old; both run concurrently.

§six-named-per-role-boards: cleaner + judge + fixer + weaver + shepherd + conductor. **§the-named-six-named-per-role-boards**. **§the-named-shared-queue-discipline**: "The judge board IS the shared queue for the three judge-flavored roles (`solicitor`, `barrister`, `justice`)." **§the-named-three-flavor-shared-queue**.

§the-named-per-role-board-IS-driver-lane-target: cycle 281 designs/driver.md named the script-orchestrated driver model; cycle 306 names "the per-role boards (...) are the layout `designs/driver.md` § Role-specific job boards adds for the script-orchestrated driver model". **§two-cycles-with-named-design-and-implementation-cross-reference-pair-extends** (cycle 281 design + cycle 304 watcher implementation + cycle 306 board layout). **§three-cycles-with-design-pointer-back-to-driver-design** (281 + 304 + 306).

- **§six-named-filename-components** (first-explicit-observation):

| Position | Component | Purpose |
|---|---|---|
| 1 | `<UTC>` | compact `YYYYMMDDTHHMMSSZ` timestamp at the transition |
| 2 | `<host>` | hostname of the claiming consumer |
| 3 | `<role>` | the claimant's role |
| 4 | `<sid>` | first four hex chars of the claiming session's id |
| 5 | `<short-id>` | six hex chars; set at post time; preserved across moves |
| 6 | `<slug>` | short kebab-case description |

**§six-named-filename-components**. **§the-named-monotonically-growing-filename-shape**: the filename grows on each transition (open/ has 3 components; claimed/ has 6).

§the-named-short-id-IS-the-named-stable-identity: "A job's identity (`<short-id>`) is set once at post time and never changes. The filename grows on each transition; the short-id lets a future reader follow the job across the four directories with a single `find jobs/ -name '*<short-id>*'`." **§the-named-find-recipe-via-stable-identity**. **§the-named-job-identity-IS-set-once-at-post-time-and-never-changes**.

§four-cycles-with-6-hex-short-id-discipline (extends cycle 301's three-cycle pattern): cycle 297 named the format + cycle 298 implemented it via `openssl rand -hex 3` + cycle 301 named its purpose as collision-avoidance + cycle 306 names it as the named-job-identity. **§four-cycles-with-named-6-hex-short-id-discipline** (297 + 298 + 301 + 306).

§the-named-UTC-timestamp-IS-named-transition-time-not-event-time: "generated at the transition that moves the file into the directory (so the `open/` timestamp IS post time; the `claimed/` timestamp IS claim time; etc.)." **§the-named-timestamp-IS-the-transition-time**.

§the-named-four-named-UTC-meanings: open-UTC IS post-time + claimed-UTC IS claim-time + done-UTC IS done-time + abandoned-UTC IS abandon-time. **§the-named-four-named-UTC-semantics**.

- **§the-named-job-frontmatter-shape-with-three-phase-accumulation** (first-explicit-observation):

The frontmatter accumulates fields in three phases:
1. **Post time** (sets the open/ file): job + posted_by_role + posted_by_host + posted_at + verb + project + target + authorizations + priority + deadline + eligible_roles + preconditions + refs.
2. **Claim time** (adds): claimed_by_role + claimed_by_host + claimed_by_session + claimed_at.
3. **Completion time** (adds): result_entry + completed_at + outcome + abandon_reason (only present when outcome=abandoned).

**§the-named-three-phase-frontmatter-accumulation**. **§the-named-frontmatter-grows-monotonically-across-transitions**.

§the-named-target-IS-named-with-four-named-shape-variants: repo + pr + issue + design. "the shape depends on the verb". **§the-named-four-named-target-shapes**.

§the-named-authorizations-block-IS-named-with-named-two-fields: identity_switch (boatman only; default false) + comment_repos (per-action comment authorizations; default empty). **§the-named-authorizations-frontmatter-shape**. Extends cycle 301 COMMON.md's named-three-stage-authorization-pipeline.

§the-named-priority-IS-named-binary: `normal | urgent`. **§the-named-two-named-priority-levels**.

§the-named-deadline-IS-named-staleness-marker: "if the job becomes stale after this". **§the-named-staleness-threshold**.

§the-named-eligible_roles-default-IS-steward: "A producer that does not know which roles are eligible defaults to `[steward]` only." **§the-named-explicit-default-discipline** (extends cycle 303 liaison AGENT.md's named-explicit-default-discipline).

§the-named-preconditions-IS-named-informational-only: "human-readable; informational only". **§the-named-informational-only-field**.

- **§the-named-body-IS-the-named-same-brief-as-message-entries** (first-explicit-observation):

> The body is the same brief shape that used to live in a `message: <role> → steward` entry. The job board does not change what gets said; it changes where the message lands so concurrent consumers can race.

**§the-named-channel-change-not-content-change**. **§the-named-the-board-changes-the-where-not-the-what**. **§the-named-routing-mechanism-shape**.

§three-cycles-with-named-2026-05-18-channel-split-or-equivalent (299 + 303 + 306): cycle 299 named the job-board-claim 2026-05-18 default; cycle 303 named the 2026-05-18 channel split with four-named-residual-inbox-patterns; cycle 306 names the channel-change-not-content-change interpretation.

- **§four-named-job-transitions** (first-explicit-observation):

1. **Post** (no source → `open/`): producer writes the file + commits + pushes; commit message: `jobs: post <short-id> <verb> <slug>`.
2. **Claim** (`open/` → `claimed/`): consumer fetches + verifies + runs `git mv` + appends claim frontmatter + commits + pushes. Push IS the race resolution.
3. **Complete-done** (`claimed/` → `done/`): consumer runs `git mv` + appends result_entry + completed_at + outcome: done.
4. **Complete-abandoned** (`claimed/` → `abandoned/`): outcome: abandoned + one-line abandon_reason.

**§four-named-job-transitions**. **§the-named-atomic-git-commit-per-transition**: "Each transition IS one git commit that moves the file and edits its frontmatter."

§the-named-named-commit-message-format: `jobs: post <short-id> <verb> <slug>` (post transition only). **§the-named-prescribed-commit-message-format**. Extends cycle 302 library-lookup SKILL.md's named-commit-message-format-IS-named-prescribed.

§the-named-the-board-does-NOT-auto-recycle-abandoned-jobs: "A new job (with a fresh short-id) may be re-posted by a producer; the board does not auto-recycle." **§the-named-no-auto-recycle-discipline**. **§the-named-fresh-short-id-on-re-post**.

- **§the-named-four-directory-structure-IS-the-producer-consumer-signal** (first-explicit-observation):

> The four-directory structure is the producer-consumer signal: a glance at `ls open/` answers "what is available", and the bash poll daemon below diffs the listing across ticks to know when to wake the LLM Monitor.

**§the-named-directory-IS-the-named-state-machine**. **§the-named-ls-IS-the-state-query**.

§the-named-four-named-directory-states: open + claimed + done + abandoned. **§four-named-job-states**. **§the-named-state-transitions-via-git-mv**.

- **§the-named-claim-race-resolution** (first-explicit-observation):

> Two consumers see the same `open/X.md` and both try to claim it. Both run `git mv X.md claimed/.../X.md`, commit, push. The git push is serial against `origin/journal`: one push lands first, the other comes back rejected. The rejected pusher hard-resets to `origin/journal` (discarding its local claim commit) and moves on to the next open job, or back to idle.

**§the-named-claim-race-resolution-via-git-push**. **§the-named-git-push-IS-named-serial-against-origin-journal**. **§the-named-loser-hard-resets-and-moves-on**.

§the-named-no-retry-with-rebase-on-claim: "The consumer does **not** retry-with-rebase on a rejected claim push. The whole point of the rejection IS that someone else got the job. Retrying would force-fight for ownership the loser already lost." **§the-named-rejection-IS-named-meaningful-not-noise**. **§the-named-anti-force-fight-discipline**.

§the-named-hard-reset-IS-safe-because-of-single-commit-invariant: "The hard-reset IS safe because the loser only created one commit (the claim commit) since the prior fetch. The reset throws away exactly that commit." **§the-named-single-commit-invariant**. **§the-named-discipline-makes-the-destructive-operation-safe**.

§the-named-no-pre-edit-on-open-side: "The consumer does **not** edit the open-side file before the move. The frontmatter additions (`claimed_by_*`, `claimed_at`) are made in the destination path after `git mv`. This keeps the move atomic from git's perspective." **§the-named-git-mv-atomicity-discipline**. **§the-named-edit-after-not-before-move**.

§the-named-back-off-without-retry-extends-from-cycle-299: cycle 299 CLAUDE.md named "rejected claims back off without retry"; cycle 306 elaborates. **§two-cycles-with-named-back-off-without-retry** (299 + 306).

§the-named-back-off-when-race-interleaves-badly: "If neither consumer can land the claim after a small number of retries (the race interleaves badly under heavy concurrency), both back off; the job stays in `open/` for the next claim attempt." **§the-named-graceful-degradation-under-heavy-concurrency**.

- **§the-named-bash-poll-daemon-shape** (first-explicit-observation):

> A long-lived `skills/job-board/job-board-poll.sh` daemon runs on every host that hosts a consumer. It is parallel in shape to `skills/github-activity-poll/monitor-poll.sh`:
>
> - Polls `git -C journal fetch --quiet origin journal && ls journal/jobs/open/` on its cadence (default 30 s).
> - Writes `[HH:MM:SS] NEW <path>` to `/tmp/garden-jobs.log` for every new filename that appeared since the last tick. Removes that disappear (because someone else claimed) write `[HH:MM:SS] GONE <path>`.

**§the-named-bash-poll-daemon-discipline**. **§two-cycles-with-named-30-second-default-daemon-cadence** (cycle 304 feed-poll-default + cycle 306 job-board-poll). **§the-named-30-seconds-IS-named-garden-wide-daemon-cadence-default**.

§the-named-two-named-state-change-types: NEW (appeared) + GONE (disappeared because claimed). **§two-named-state-change-markers**. **§the-named-symmetric-state-change-naming**.

§the-named-three-named-state-files: `/tmp/garden-jobs.log` (events) + `/tmp/garden-jobs-<host>.state` (prior ls) + `/tmp/garden-jobs.pid` (process). **§three-named-state-files-on-tmp**.

§the-named-parallel-in-shape-to-monitor-poll: explicit cross-reference. The job-board-poll inherits shape from the github-activity-poll monitor. **§the-named-parallel-daemon-shape**. **§the-named-daemon-shape-IS-named-reusable-pattern**.

§the-named-daemon-survives-across-LLM-ticks: "The daemon survives across LLM ticks; state IS the prior `ls` output written to `/tmp/garden-jobs-<host>.state`." Extends cycle 301 COMMON.md's named-standing-monitor-exception and cycle 304 watcher's named-self-heal-via-systemd. **§three-cycles-with-named-bash-daemon-owned-state-survives-LLM-ticks** (301 + 304 + 306).

§the-named-LLM-Monitor-tails-the-log: "the consumer's parent-context Monitor tails `/tmp/garden-jobs.log` and emits one notification per new line; the consumer reacts by attempting a claim." **§the-named-two-tier-poll-and-monitor**: bash daemon polls + LLM Monitor reacts to log lines.

- **§the-named-where-things-are-table** (first-explicit-observation): six rows mapping path → owner → what-it-carries.

| Path | Owner | What |
|---|---|---|
| `journal/jobs/open/` | producers | available jobs |
| `journal/jobs/claimed/` | consumers | jobs in flight |
| `journal/jobs/done/` and `/abandoned/` | consumers | terminal states |
| `<garden-root>/skills/job-board/SKILL.md` | gardener | procedural detail |
| `<garden-root>/skills/job-board/{post-job,claim-job,job-board-poll}.sh` | gardener | helper scripts |
| `/tmp/garden-jobs.{pid,log,err,state}` | bash daemon | poll state |

**§two-cycles-with-named-where-things-are-section** (cycle 301 COMMON.md + cycle 306 jobs/README.md). **§the-named-where-things-are-IS-named-self-index-shape**.

§the-named-three-named-helper-scripts: post-job + claim-job + job-board-poll. **§three-named-job-board-helpers**.

§the-named-tmp-state-files-IS-named-bash-daemon-owned: extends cycle 304 watcher's `.garden-monitor/` state discipline; cycle 306 names `/tmp/garden-jobs.*` as the named bash-daemon-state location. **§two-cycles-with-named-bash-daemon-state-locations** (304 + 306).

- **§the-named-inventory-cap-IS-named-absent** (first-explicit-observation):

> A board with hundreds of open jobs IS a signal the consumer set IS undersized; a board with zero open jobs for a long stretch IS the steady state. There IS no hard cap, but jobs older than their `deadline:` should be triaged by the next consumer cycle that sees them (the bulletin's *Awaits maintainer decision* section IS the escalation surface, not this board).

**§the-named-no-hard-cap**. **§the-named-cap-IS-replaced-by-named-signal-and-named-escalation-surface**. **§the-named-bulletin-IS-the-named-escalation-surface** (extends cycle 301 COMMON.md's named-bulletin-IS-the-maintainer-dashboard).

§the-named-zero-open-IS-named-steady-state: "a board with zero open jobs for a long stretch IS the steady state". **§the-named-empty-IS-named-success-state**.

§the-named-hundreds-open-IS-named-undersized-signal: "A board with hundreds of open jobs IS a signal the consumer set IS undersized". **§the-named-queue-depth-IS-named-capacity-signal**.

- **§the-named-composition-with-the-message-bus** (first-explicit-observation):

> The job board carries **work items** (do something). The inbox ... carries **directed communication** (FYI, decision, retro, reply from a subagent). The two channels are orthogonal:

**§the-named-orthogonal-channels**. **§three-cycles-with-named-channel-split-or-equivalent** (cycle 299 CLAUDE.md two-channel-message-bus + cycle 303 liaison AGENT.md 2026-05-18-channel-split + cycle 306 jobs/README.md composition-with-the-message-bus).

§three-named-channel-selection-examples:
1. "do gamut on #N" → job (Old pattern: message: liaison → steward)
2. "my dispatch encountered X" → message
3. "the inbox-drain Monitor failed again" → message

**§three-named-channel-routing-examples**. **§the-named-do-something-vs-just-read-discrimination**.

§the-named-when-in-doubt-rule: "When in doubt, ask: *would a producer expect a specific role to act on this?* If yes, post a job. If the producer just wants the message read, write a message." **§two-cycles-with-named-act-vs-read-discrimination-question** (303 + 306). **§the-named-act-vs-read-IS-the-named-discriminator**.

§the-named-cross-reference-from-contract-back-to-role-files: "The role files name the channel selection explicitly (`roles/liaison/AGENT.md` § Posting jobs; `roles/steward/AGENT.md` § Job-board claim discipline)." **§the-named-bi-directional-cross-reference**: contract → roles → back to contract. **§the-named-document-mutual-citation-shape**.

- **§the-named-cycle-306-IS-the-named-eleventh-garden-source-and-the-named-second-journal-branch-source-and-the-named-fourth-design-and-instance-pair-realization** (first-explicit-observation):

The garden cluster IS now eleven cycles deep with two cross-branch sources. **§eleven-cycles-with-garden-repo-source-ingest**. **§eleven-named-shapes-of-garden-self-documentation**.

§the-named-cross-branch-cluster-extends: cycle 305 + cycle 306 are both journal-branch. **§two-cycles-with-named-journal-branch-source**.

§the-named-fourth-design-and-instance-pair: cycle 299 CLAUDE.md and cycle 303 liaison AGENT.md both named jobs/README.md as the contract; cycle 306 IS the contract. **§four-named-design-and-instance-pairs-across-the-garden-cluster** (299→301 + 301→302 + 302→305 + (299+303)→306). **§the-named-double-claim-and-single-realization**: two prior cycles named the document; cycle 306 realizes it.
