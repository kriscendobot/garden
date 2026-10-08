---
created: 2026-10-08
author: designer (job design-review-docket)
---

# The clerk and the maintainer review docket

| Created | 2026-10-08 |
| Author | designer (job `design-review-docket`) |
| Status | Proposed; build owned by the next child of orchestration `review-docket-20261008` |
| Reuses | [accountant arc apportionment](accountant-arc-apportionment.md), [approval reconciler](approval-reconciler.md), [PR completion receipts](pr-completion-receipts.md), `skills/review-queue-poll` |

The maintainer's review queue is currently split between hand-written priority
documents, GitHub requested-reviewer state, and PR-shaped messages in
`inbox/maintainer/`. The proxy deliberately archives non-gating PR messages, so a
review request there is both unordered and liable to disappear from the unread
surface. Review requests need durable queue semantics, not message semantics.

## Decision

Call the mechanism the **clerk** and its queue the **review docket**, following
the garden's existing judicial vocabulary. The clerk is deterministic shell and
`jq`, not a role and not an LLM loop. Producers provide the one-line summary and
the review ask; the clerk validates records, reads trusted journal state and
GitHub metadata, orders entries, and renders Markdown. Optional prose summaries
may be prepared outside this path and supplied as data, but intake, retirement,
ordering, and regeneration never depend on a model.

The dedicated address is the journal tree
`review-docket/open/<owner>-<repo>-pr<N>.json`, written only through
`scripts/jobs/review-docket.sh`. It is intentionally not an `inbox/<doer>`:
doer inboxes disappear when a job completes, while a review obligation may wait
for weeks. It is also not under `inbox/maintainer`, so `proxy.sh`'s PR-comment
auto-clear cannot match or move it. One PR has at most one open record.

The maintainer-facing document is **`journal2:PRIORITIES.md`**. It combines the
accountant's ranked arc stack with the review docket in one root document rather
than creating sibling priority and review files: the maintainer has one stable
URL and cannot read a stale review order beside a newer resource order. The
accountant remains the sole writer of allocation policy; `PRIORITIES.md` is a
generated view and says so at its top. The journal `README.md` links it near the
top. After migration the clerk sends the maintainer the stable URL
`https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md` once.

## Record and intake

`review-docket.sh upsert` accepts a canonical PR URL plus trusted producer data:

```json
{
  "schema": 1,
  "repo": "endojs/endo-but-for-bots",
  "pr": 1398,
  "url": "https://github.com/endojs/endo-but-for-bots/pull/1398",
  "head_oid": "afc5c25c1f...",
  "ask": "approve",
  "arc": "endo-ocapn-background",
  "milestone": "M4",
  "summary": "mint a SturdyRef for a formula without incarnating it",
  "unblocks": [{"kind": "dependent-stack", "ref": "sturdyref-layer-9",
                 "summary": "allows the first consumer layer to proceed"}],
  "source": "endojs-endo-but-for-bots-pr1398-gauntlet",
  "requested_at": "2026-10-07T22:12:59Z",
  "first_requested_at": "2026-10-07T22:12:59Z",
  "generation": 1,
  "ci": {"state": "green", "observed_at": "..."}
}
```

`ask` is exactly `approve`, `decide`, or `re-review`. `arc` must name the
producer job's `arc:`/legacy `ratchet-arc:` or `unallocated`; it does not infer a
new strategic category. `milestone` is the producer's roadmap milestone (`M<N>`)
or `-`. Each `unblocks` item names a real parked job/plan, milestone gate,
dependent PR/stack, or other concrete next step. The script rejects an entry
whose URL and repo/number disagree, sanitizes all rendered single-line text, and
reads the current head and CI rollup itself. Repeating the same source, head, and
ask is a no-op; a new head or ask increments `generation`, resets
`requested_at`, and preserves `first_requested_at`.

Every current review-request producer moves to this address:

| Producer today | Clerk intake |
| --- | --- |
| `ci-wait-merge.sh` / conductor stalls for missing or dismissed maintainer approval | Upsert `ask: approve`, with the merge/conductor and any blocked plans in `unblocks`. A live `CHANGES_REQUESTED` is not an approval request: the existing review event posts a fixer instead. |
| `gauntlet.sh` terminal `review-budget-reached` notice | Replace `gauntlet_notify ...-review-budget-reached` with an upsert derived from the terminal record and last panel/fix reports. |
| `gardener.sh` stale-panel-head disposition | Replace `message-user.sh` with `ask: re-review`, preserving reviewed and presented heads in the summary/source evidence. |
| producer draft guard's manual-gauntlet handoff and `design-pr-gauntlet-coverage-audit.sh` historical alert | Upsert `ask: decide` (run the gauntlet or review directly). Post-arm automatic gauntlet staging remains unchanged. |
| changes-requested verification and fixer completion | The verifier uses `ask: re-review`; a substantive fixer completion upserts only after its pushed head has green CI, inheriting arc, milestone, summary, and unblock links from the retired generation. This replaces the ad-hoc `review-request-*` maintainer messages. |
| garden design PR with `<!-- garden-design-open-questions -->` | `ensure-pr.sh`'s design completion path upserts `ask: decide` after the answer-surface exists, naming the questions and the build it gates. |
| native GitHub review requests | Extend the existing deterministic `review-queue-poll` producer: an ADD imports/upserts the PR; a REMOVE is only a wake signal, never sufficient retirement evidence. This catches manual and external requests that bypass a garden producer. |

No producer writes JSON directly. Producers call the one helper so validation,
deduplication, rendering, and CAS behavior stay uniform. Generic operational
alerts remain in the maintainer inbox; only requests for PR review or a PR-bound
decision enter the docket. `bulletin.sh` drops its separate fuzzy-ranked
"Parked for maintainer feedback" query and shows only the docket's open count and
stable `PRIORITIES.md` link; retaining its ranking would recreate a second
priority scheme. Its GitHub discovery duty moves to `review-queue-poll` above.

## Retirement and re-entry

A review request is satisfied when an allowlisted journal maintainer submits any
formal GitHub review state `APPROVED`, `CHANGES_REQUESTED`, or `COMMENTED`, or
when the PR merges or closes. The event does not have to approve the PR: the
promise is that *receiving a review* removes the item. Retirement moves the open
record to
`review-docket/retired/<YYYY>/<MM>/<DD>/<repo-slug>-pr<N>-g<G>.json`, adding
the review id/state/author/time or terminal PR state, and regenerates priorities
in the same journal CAS commit.

The existing signals compose rather than compete:

- `comment-watcher.sh` retires on an allowlisted maintainer review event, then
  keeps its existing dispatch: `CHANGES_REQUESTED`, or substantive `COMMENTED`
  feedback, posts one fixer job.
- `approval-reconciler.sh` retires an effective approval before it posts the
  conductor, closing a missed-event hole.
- `receipt-watcher.sh` retires merged and closed PRs while detecting completion.
- A leader-only `review-docket-reconcile` timer re-reads every open PR and
  applies the same rules, covering missed watcher events and refreshing head/CI.

Retirement is generation-safe. A review event retires only a generation whose
`requested_at` precedes that event; an old delayed event cannot erase a later
re-request. Merge or close retires every open generation. Unknown API state
fails closed and leaves the entry visible.

On requested changes, the fixer owns the next action, not the clerk. The docket
remains retired while work is in flight. After the fixer pushes and CI is green,
its completion hook creates a new generation with `ask: re-review` and the new
head. If the review was only a comment or decision and no fix is dispatched,
nothing silently re-adds the PR; a producer must make a new explicit request.

## Regeneration and ordering

Every successful upsert or retirement calls a pure renderer before its CAS
commit. The reconciliation timer also renders when live head/CI or retirement
state changes, and `set-apportionment.sh` invokes the same renderer in its own
allocation commit. Thus an accountant re-slice reorders the docket immediately;
the docket never copies arc ranks into a second policy file.

`PRIORITIES.md` contains:

1. the current week, total, ordered arc slices, summaries, milestones represented
   by their open entries, and derived headroom from `config/apportionment`,
   `config/arc-budgets/*`, and `arc-spend.sh`;
2. one review-docket table grouped by arc and milestone; and
3. an archive link and generation timestamp.

Each review row shows PR URL, arc and milestone, concrete unblock, ask, CI state
with observation time, one-line summary, and age since the current generation's
`requested_at`. The total order is deterministic:

1. `config/apportionment.slate[].rank`; `unallocated` and unknown/retired arcs
   follow every active ranked arc;
2. numeric milestone (`M1` before `M2`; `-` last) within the arc;
3. observed foreman impact: a referenced blocked plan/job, then a milestone
   gate, then a dependent stack/PR (more direct dependents first), then an entry
   with no live dependent; and
4. oldest current request first, then repo and PR number.

The impact order is not a second strategic ranking: it is derived from live
`jobs/plan` blockers and `pr-deps/` edges named by the record, after the
accountant's arc and roadmap milestone order have already won. A missing or
unresolvable reference is displayed as stale evidence and sorts in the last
class; the clerk never guesses. Age changes in the rendered text only when some
real journal or reconciliation event rebuilds it, avoiding clock-only commits.

## Priorities archive and migration

The archive is `priorities-archive/<YYYY-MM-DD>.md` with
`priorities-archive/README.md` as its date index. Each rebuild writes the latest
snapshot for that UTC date; git history retains earlier same-day generations.
Any migration appendix in that date's file is immutable across later same-day
rewrites.
On 2026-10-08 the first archive also embeds exact, path-labelled snapshots of
the three superseded documents:

- `projects/garden/review-priorities.md`;
- `pr-review-sequence.md`; and
- `reports/maintainer-priorities-2026-09-28.md`.

The originals are then removed, so searches and links converge on
`PRIORITIES.md`, while their contents remain readable in the dated archive. The
same initial archive indexes the imported
`inbox/maintainer/read/review-request-*`, `manual-gauntlet-handoff-*`,
`stale-panel-head-*`, and `*-review-budget-reached` source messages and records
whether each was imported, already reviewed, merged/closed, or stale. The source
messages remain in `read/` as audit evidence.

Migration validates every candidate against live GitHub state, folds duplicate
messages into one PR record, imports only open PRs with no later allowlisted
maintainer review, and refreshes arc/milestone/unblock data from matching journal
jobs and dependency records. It then renders the first root document and sends
the maintainer its URL. Re-running migration is idempotent.

## Foreman link and headroom

The docket describes why a maintainer review matters; it does not execute the
unblocked work. `blocked_on: <PR URL>` remains the durable gate. Approval retires
the review request and lets the approval reconciler post a conductor, but does
not promote a merge-dependent plan early. A successful merge lets the existing
receipt/unblock path promote or reconsider the dependent plan. Changes requested
dispatches a fixer; the fixed, green head re-enters the docket. Closing without
merge holds or declines merge-dependent work rather than treating closure as
success.

Review state does **not** consume or restore arc headroom. Arc headroom measures
fleet token spend, while a review waits on maintainer attention; mixing them
would make a blocked arc appear artificially funded or exhausted. The foreman
digest gains the docket's live blocker references so it can explain why a
milestone is waiting and choose another unblocked step, but its existing
`blocked_on` and accountant admission checks remain authoritative.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Lifecycle / commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| producer → clerk | `review-docket.sh upsert` | producer states ask/summary/unblock; clerk validates | `review-docket/open/*.json` | clerk's journal CAS | versioned request record |
| GitHub → clerk | review event, approval reconciliation, terminal receipt, periodic poll | allowlisted review or terminal state retires | GitHub review/PR state plus retired record | clerk's generation-safe CAS | review/terminal evidence |
| accountant → renderer | `config/apportionment`, arc budgets, `arc-spend.sh` | accountant's authorized rank and slices | accountant-owned `config/*` | accountant allocation CAS; renderer is read-only | rank, summary, slice, headroom |
| clerk → maintainer | pure Markdown renderer | fixed sort after accountant policy | `PRIORITIES.md`, dated archive | same CAS as intake/retirement | one review-priority view |
| docket → foreman | blocker references in digest | existing dependency/admission rules | job board and `pr-deps/` | unblock/conductor/fixer paths, not clerk | explanation of what review unblocks |

The clerk owns docket records and rendered views; the accountant owns allocation
state; GitHub owns review and PR state; the job board owns execution gates.
The clerk decides whether a queue mutation commits, while maintainers decide the
review and existing lifecycle scripts decide fix, merge, promotion, or hold.
Restart/replay syncs the journal, re-reads GitHub, and re-applies idempotent event
ids; no host-local cursor is authoritative. Review-event classification belongs
to the comment/approval watchers, while the clerk only applies the resulting
queue transition.

Inner/outer naming is clean: `review-docket.sh` mutates a request queue and
returns an intake/retirement result; it does not claim to approve, merge,
unblock, or commit a PR. Those outer lifecycle words remain with the maintainer,
conductor, fixer, and foreman paths that own them.

## Failure behavior and tests

Queue mutation and rendering are one CAS transaction in an isolated journal
clone. A render failure leaves the old record and document together; a lost CAS
resyncs, reapplies the idempotent event, and rerenders. GitHub read failure leaves
an existing entry visible with its last observation and marks it stale on a later
successful render; it never retires on absence from search alone. The timer is
leader-only, bounded, and uses no LLM.

Hermetic tests cover: same-generation upsert idempotency; new-head re-entry;
arc/milestone/foreman-impact ordering and reordering after an apportionment
change; all three review states from allowlisted and non-allowlisted authors;
delayed-review versus new-generation races; merge/close retirement; changes
requested → fixer → green re-review; proxy PR auto-clear leaving the docket
untouched; readiness-audit, gauntlet-budget, stale-panel, conductor, design, and
GitHub-poll intake adapters; CI refresh/failure; Markdown escaping; daily archive
indexing; and the one-time consolidation fixture with duplicate and already-
retired legacy requests.

Considered and rejected: a `clerk` LLM role (ordering must change atomically on
every event); `inbox/clerk` (doer mailboxes are ephemeral and still need a durable
queue); a second root `REVIEW-DOCKET.md` (two competing priority pages recreate
the current drift); and making review waits spend arc headroom (it conflates
maintainer attention with inference budget).
