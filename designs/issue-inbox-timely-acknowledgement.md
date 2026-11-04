# Design: timely, non-redundant acknowledgement for the issue inbox

| Created | 2026-11-04 |
| Author | designer |
| Status | Proposed |

Trigger: [kriscendobot/garden#128](https://github.com/kriscendobot/garden/issues/128),
filed 03:37:25Z, `eyes` at 04:31:57Z, first gardener work at 05:36Z.

Code to be built (by `build-issue-inbox-timely-acknowledgement`):
- `scripts/jobs/issue-status-pass.sh` and its unit pair
  `scripts/systemd/garden-issue-status.{service,timer}`.
- Fixes to [`scripts/jobs/comment-latency-watch.sh`](../scripts/jobs/comment-latency-watch.sh),
  [`scripts/jobs/comment-classify.sh`](../scripts/jobs/comment-classify.sh), and the
  skip paths of [`scripts/jobs/issue-inbox-watcher.sh`](../scripts/jobs/issue-inbox-watcher.sh).

## Decision

Keep two tiers of sign of life, and fix them separately.

1. **`eyes` stays the instant ack.** It is cheap and silent, and it normally lands
   in about 90s. Lateness is a liveness defect: fix it, and do not paper over it
   with a comment.
2. **One deterministic status comment, only when the real reply has not come.**
   Post it for an arrival that has no bot comment after it, when either rule fires:
   - **Timeout:** the arrival is at least **20 minutes** old.
   - **Deep queue:** the arrival is at least **5 minutes** old, its job is in
     `jobs/todo/`, and **6 or more** unpinned jobs are ahead of it.

   Hold the comment for up to **5 minutes after a claim**, because the worker's own
   reply is imminent. The claim grace ends at 25 minutes of age at the latest, so a
   claimant that stays silent cannot suppress the status.

There is no immediate heavy ack, no numeric ETA, and no skip based on a short queue.

## Evidence

**Arrival to first sign of life**, for the last 30 non-bot issues on the garden repo
(GitHub timestamps):

| Measure | Result |
| --- | --- |
| `eyes` within 390s | 29 of 30 (typically 90s or less; #128 is the exception at 3272s) |
| First bot comment within 20 min | 21 of 30, median 386s, slowest 961s |
| First bot comment after 20 min | 9 of 30 (1611s up to 2.5 days) |

So 20 minutes clears every fast reply in the sample. Replayed against these issues,
the timeout would have added a comment on about 30% of them, all of which really were
waiting, and on none of the 21 fast ones. This replay counts first bot comments only;
it does not model the claim grace or the deep-queue rule.

**Queue depth as a predictor.** Replaying `todo`/`claim`/`promote` commits on `journal2`
since 2026-10-28 (935 jobs, all kinds):

| `todo` depth at post | Jobs | Waited over 20 min to claim |
| --- | --- | --- |
| 0 to 2 | 811 | 22% |
| 3 to 5 | 70 | 51% |
| 6 to 10 | 48 | 73% |
| 11 to 20 | 6 | 100% |

The depth is a commit-log reconstruction, so treat it as approximate. It still supports
both halves of the decision:

- **A short queue must not skip the ack.** One job in five at depth 2 or less still
  waited over 20 minutes.
- **A deep queue justifies an early ack.** At depth 6 or more, 41 of 54 jobs waited
  over 20 minutes.

**Free-gardener counts are rejected as an input.** Idle workers do not imply a prompt
claim: a host's budget ramp can hold claims with slots free, and host pins and tier fit
narrow who can take a job. While this design was being written, a job pinned to the
leader sat unclaimed for over 22 minutes on a short board. A numeric ETA would be built
on the same unreliable inputs, so the text reports counts and promises no time.

## Root cause of the #128 gap

### Established

- **Not poll cadence.** The timer is 120s and typical `eyes` latency is about 90s.
- **Not the trust gate or the leader.** `dckc` was already acked on #126, and neither
  `maintainers/allowlist` nor `leader` changed in the window. `endolin-garden-ece02cb4`
  was the leader throughout.
- **One tick did all the work.** `eyes` 04:31:57Z, job `posted_at` 04:31:58Z, board
  commit 04:32:04Z, cursor 04:32:13Z. The issue was invisible or unreachable to the
  watcher until that tick. Nothing failed partway and retried.
- **Two separate waits.** Intake took 55 minutes and the claim another 62
  (04:32 to 05:34). Fixing intake alone would still have left dckc waiting about an hour
  for a reply.
- **The latency checker recorded nothing.** No `comment-ack-*` notice was committed from
  01:51Z through at least 06:12Z. Yet #128 should have reached `never-acked` at about
  03:57Z and `acked-late` at 04:32Z, and an open blind notice stopped amending at 01:51Z
  although its comment was still inside the 6h lookback.

### Leading hypothesis, not proven

Both silent paths exit 0 on a host-shared gate, so a held REST latch on the leader
(`api_cooldown_active rest`) would explain the issue watcher and the checker going quiet
together. A long latch has happened before: a 2489s episode on 2026-10-26 is recorded in
`issue-inbox-watcher.sh`. The other candidates are the cursor-IO lock skip and the
journal-outage latch, since lock contention was being reported on endolin in the window.

The deciding evidence is the unit logs and host-local state on endolin, which no other
host can read. Job `diag-issue-inbox-gap-20261104-endolin` collects them. The build reads
its report first and adds a targeted fix if it names a cause outside the changes below.

That this cannot be diagnosed from the journal is itself a defect, fixed in the next
section.

## Fixing lateness

These hold whichever gate was responsible.

1. **Run the checker's quiet pass under a latch.** `comment-latency-watch.sh` exits at
   its REST cooldown and budget-deferral gates before it classifies any heartbeat. The
   quiet pass makes no API calls, so a continuously held REST latch can never raise
   `comment-watcher-stuck-cooldown-host`, the notice written for that case. Run the
   heartbeat classification and its notices before those exits, and skip only the
   API-backed sweep.
2. **Name the gate in the heartbeat.** The heartbeat gains `detail:` with the latch owner
   or skip reason. The cursor-read skip in the issue watcher, which currently records
   only the `offline-journal` default, gets its own outcome (`cursor-busy`). Stuck notices
   carry this detail, so the next incident can be diagnosed from the journal.
3. **Align the issue-inbox predicate.** For the issue-inbox source, `comment_should_ack`
   accepts `@bot` anywhere in the body or any directive reading, while the watcher
   requires the exact first-line `@<bot> ` and drops the rest. The checker therefore
   reports correct drops as `never-acked:blind`. The open blind notice on #117's comment
   looks like this case, and the separate endo-but-for-bots blind notice has reached 179
   occurrences, so check that one too. A notice that is usually false will not get read
   when it is true. The checker must apply the watcher's rule for this source.

`comment-latency-watch` remains an observer: it posts no reaction and no comment. The
20-minute rule does not belong there. It defers at the low-priority REST reserve, and
[its design](comment-latency-watch.md) deliberately keeps it from acting on the signal it
measures.

## The status pass

`issue-status-pass.sh` is a deterministic, no-LLM, leader-only timer at 120s. It shares no
cursor with the issue watcher, so a watcher wedged on its cursor or dispatch path cannot
silence it. Like the latency checker, it still ticks under drain.

### Procedure

1. Skip the tick if `api_cooldown_active rest`. GitHub is refusing or about to refuse, and
   the next tick retries. It does not call `gh_rest_budget_defer`, because this is a
   maintainer-facing path.
2. List issues and comments for the last 24h through the existing
   `handlers/issue-source-gh.sh`.
3. **Trust gate first.** Drop any author not on `maintainers/allowlist`, using the same
   allowlist-only rule as the watcher, before reading any body.
4. Keep **arrivals**: new open issues, and comments whose first line starts with the exact
   `@<bot> `. Share this predicate with the watcher through `comment-classify.sh`.
5. Drop arrivals that have a bot comment created after them. Any bot comment counts,
   including an earlier status. A reaction does not count.
6. Apply the rules in [Decision](#decision), then re-list the issue's comments immediately
   before posting and re-check step 5 and the marker.

### Reading the board

From the pass's own journal clone, using the last fetched view if a fetch fails:

| Value | Definition |
| --- | --- |
| state | The issue spine (`issue-<slug>-<N>`) in `todo`, `doin`, or `tada`, otherwise `not-on-board` |
| `ahead` | Jobs in `todo` with an older `posted_at` and no `job_requirements` tokens |
| `running` | Count of `jobs/doin/` |
| claim age | `claimed_at` of the job in `doin` |
| paused | `fleet_draining` on the leader |

The foreman brake is not an input, because it stops new foreman work and does not stop
claims. Excluding jobs with `requires:` tokens keeps pinned and `scholar-ingest-*` jobs,
which often sit for days, from triggering early acks.

### Comment text

The text is fixed templates filled only with the values above. No issue or comment text
is ever echoed, and no model runs in this path. The fleet `gh` wrapper's provenance footer
applies with `model automatic`.

| State | Text |
| --- | --- |
| `todo` | Received. This is queued as `<spine>`, with `<ahead>` jobs ahead and `<running>` running. A gardener will reply here when it picks this up. |
| `doin` | Received. A gardener claimed this as `<spine>` at `<time>` and is working on it. It will reply here. |
| `not-on-board` | Received, but intake is running behind and this is not on the job board yet. It will be queued when intake catches up. |
| paused (appended) | The garden is paused for maintenance, so pickup may be delayed further. |

Every template ends with "This is an automatic status note." For an addressed comment the
same text applies, using the issue's spine.

### Idempotency

The comment carries `<!-- garden-status:<number>:<arrival-id> -->`, where the arrival id is
`issue` or the comment id. GitHub is the only state: there are no journal writes or cursors,
and a leader handoff or restart re-derives everything from the issue's comments. Because any
bot comment answers every earlier arrival, a burst of comments yields one status, and only a
new maintainer arrival can cause another. The bot's comments are never arrivals, so the pass
cannot feed itself. It never closes an issue.

A worker can still post in the moment between the final re-check and the status comment.
That costs one redundant line, is rare given the claim grace, and is accepted rather than
adding a lock across a worker's reply.

### What this does and does not fix

Replayed on #128, the status lands at about 03:58Z if GitHub was reachable. If a REST latch
was the cause, it lands only when the latch lifts, about 04:32Z, because no comment can be
posted through a refused API. It then still replaces the manual 05:30Z comment and tells dckc
why the wait continued. That limit is why [the lateness fixes](#fixing-lateness) are separate
work and not replaced by this pass.

## The sibling watchers

The lateness fixes cover all three sources, since the checker and heartbeat are shared. The
status comment stays issue-inbox only:

- **PR comment watcher:** `comment-watcher.sh` already posts a reply naming the job through
  `post_reply`, in the same tick as `eyes`. A later status would mostly repeat it. The
  issue-body surface is the one that has no such reply.
- **@-mention watcher:** it watches all of GitHub, so an automated status could land on
  third-party repositories. That is a wider outward action than this design has authority for,
  so `eyes` stays its only automatic signal.

Monitoring safety is unchanged: no new repository or sender, and the gate runs in plain code
before any body is read.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Authority |
| --- | --- | --- | --- | --- |
| Watcher to GitHub | `eyes` | reactji-acknowledgment | Reaction row | Watcher posts; GitHub timestamps |
| Status pass to GitHub | Issue comment | Rules above | Comment and its marker | Status pass posts once per arrival |
| Status pass to board | Read-only clone | Counts only | None | Board stays owned by the job system |
| Checker to maintainer | `watchdog-notice.sh` | Coalesced notices | Journal notice | Checker observes only |

Restart and replay need no recovery, because the pass holds no state of its own. It runs no
model at any point.

## Rollout

Ship the status pass with `GARDEN_ISSUE_STATUS_DRY_RUN=1` for the first deploy, logging what it
would post, then remove the flag once a day of logs matches the rules. On the first live tick,
arrivals from the previous 24h may each get one status if they are still unanswered. That is
intended. Thresholds are env-tunable (`GARDEN_ISSUE_STATUS_TIMEOUT_SECS`, `_EARLY_SECS`,
`_EARLY_AHEAD`, `_CLAIM_GRACE_SECS`).

Update [`skills/issue-inbox/SKILL.md`](../skills/issue-inbox/SKILL.md) (a status note may precede
the worker's reply, and the worker still owes the substantive answer) and the Monitoring safety
section of `CLAUDE.md` (the status pass does not widen surveillance).

## Test plan

Stubbed `gh` and board, in the existing watcher test style:

- Rule table: timeout boundary at 1200s, early rule at 300s with `ahead` of 5 and 6, claim grace
  at 299s and 301s of claim age, and the 25-minute ceiling.
- Trust gate: a non-maintainer issue and comment produce no status, and the body is not read.
- Unaddressed maintainer comment produces no arrival.
- Idempotency: a second tick posts nothing, a burst of comments gets one status, a later comment
  gets its own timer, and a bot reply landing before the final re-check suppresses the post.
- `ahead` excludes jobs carrying `requires:`, including implicit `scholar-ingest-*` tokens.
- Each template, including `not-on-board` and paused, renders with no input from issue text.
- REST cooldown live: no API calls and no post; the next tick posts.
- Checker: a continuously held REST latch now raises the stuck notice without any API call, and
  an unaddressed issue comment is no longer `never-acked:blind`.
- Replay #128's timeline end to end, with and without a REST latch.
