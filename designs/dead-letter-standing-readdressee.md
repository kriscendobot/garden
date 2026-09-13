# Completion-safe dead-letter readdressing

| Created | 2026-09-13 |
| Author  | gardener (job `design-deadletter-standing-readdressee`) |
| Status  | Proposed |

## Decision

Use the existing dead-mail queue and `garden-deadmail` service as the standing
re-addressee. Strengthen the completion boundary so an unread message can never
be deleted with its recipient's inbox, enrich the promoted continuation with the
completed job's report, and return a machine-readable route receipt to the
sender.

Do not retain a standing doer, parked job, or alias for every completed job. A
dead letter already has a single-consumer path to a fresh gardener job. The
missing piece is atomic ownership transfer at completion, not another long-lived
reader.

## Existing mechanism and remaining gap

The bus has two different ownership models. Role and broadcast topics fan out to
many readers with private cursors, while a directed inbox has one doer and lives
only for that job's lifetime
([`skills/message-bus/SKILL.md:13`](../skills/message-bus/SKILL.md#L13),
[`skills/message-bus/SKILL.md:20`](../skills/message-bus/SKILL.md#L20)). The
directed send path already distinguishes a parked job from a departed one:

- a `plan/` or `todo/` recipient gets a staged inbox that its future claimant
  preserves ([`scripts/jobs/inbox-send.sh:175`](../scripts/jobs/inbox-send.sh#L175));
- an absent recipient gets `inbox/dead/<msgid>.md`, including the intended `to:`,
  sender, and body ([`scripts/jobs/inbox-send.sh:220`](../scripts/jobs/inbox-send.sh#L220));
- `deadmail.sh` turns that entry into the basename-idempotent
  `deadmail-<msgid>` job, verifies that the job reached the shared branch, and
  only then retires the queue entry
  ([`scripts/jobs/deadmail.sh:127`](../scripts/jobs/deadmail.sh#L127),
  [`scripts/jobs/deadmail.sh:201`](../scripts/jobs/deadmail.sh#L201),
  [`scripts/jobs/deadmail.sh:224`](../scripts/jobs/deadmail.sh#L224)).

The 2026-09-13 runtime survey found the corresponding dedicated producer and
verification clones under `.garden-state/deadmail/`. The producer queue was
empty, while the verification clone retained historical completed
`deadmail-*` jobs and one pending typed issue follow-up. This is a working
re-addressing service, not an unconsumed archive. Its leader-only unit runs on a
five-minute persistent timer
([`scripts/systemd/garden-deadmail.service:7`](../scripts/systemd/garden-deadmail.service#L7),
[`scripts/systemd/garden-deadmail.timer:5`](../scripts/systemd/garden-deadmail.timer#L5)).

Two gaps remain:

1. `complete-job.sh` removes the whole inbox in the same completion commit,
   without first transferring unread entries
   ([`scripts/jobs/complete-job.sh:194`](../scripts/jobs/complete-job.sh#L194),
   [`scripts/jobs/complete-job.sh:200`](../scripts/jobs/complete-job.sh#L200)). A
   send can commit to a live inbox, lose the next CAS race to completion, and
   then be erased unread. The sender saw success, so no later dead-letter send is
   guaranteed.
2. The generic promotion carries the original message and intended basename but
   not the completed job's result
   ([`scripts/jobs/deadmail.sh:188`](../scripts/jobs/deadmail.sh#L188)). The
   result survives in `jobs/tada/`, but the new reader must discover it. The
   original `deadmail-20260728T074423Z-6bee53` correction was actionable only
   after reconstructing the departed botanist's context
   ([`designs/post-verdict-addressee.md:22`](post-verdict-addressee.md#L22)).

The motivating approval-held botanist state no longer exists on bot-owned
Dependabot pull requests: MERGE-NOW now auto-conducts under a narrowly scoped
exception ([`designs/dependabot-auto-merge.md:41`](dependabot-auto-merge.md#L41)).
The delivery race is nevertheless generic. It applies to any correction that
crosses a job's completion boundary, including ordinary approval-gated conductor
work and non-PR jobs.

## Route states and receipt

`inbox-send.sh` keeps exit status zero for every durably accepted route, so
existing callers remain compatible. On stdout it emits exactly one parseable
receipt after the successful push:

```text
delivery=<live|staged|readdressed> recipient=<base> message=<msgid>
```

| Receipt | Durable owner after the send CAS | Meaning |
| --- | --- | --- |
| `live` | `inbox/<base>/unread/<msgid>.md` for a `doin/` job | A live doer owns the message. Completion will transfer it if it remains unread. |
| `staged` | the same path for a `plan/` or `todo/` job | A future claimant owns the message. |
| `readdressed` | `inbox/dead/<msgid>.md` | The named doer is gone or unknown; the standing deadmail service owns delivery to a fresh reader. |

The send decision reads board state on every synced retry, not directory
existence alone: `doin` means live, `plan` or `todo` means staged, and no job
means re-addressed. The standing `maintainer` inbox is an explicit live-system
address. This also prevents a stale or pre-created inbox from being reported as
a live doer.

The receipt reports routing, not human or model acknowledgment. `inbox-read.sh`'s
unread-to-read CAS remains the acknowledgment boundary
([`scripts/jobs/inbox-read.sh:51`](../scripts/jobs/inbox-read.sh#L51)). A sender
that needs to distinguish a live reader from re-addressing captures the receipt;
interactive wrappers render the same words. The bulletin already exposes the
equivalent distinction in its reply status
([`docs/bulletin/app.js:207`](../docs/bulletin/app.js#L207)). Callers that discard
stdout retain today's accepted-or-error behavior.

Idempotent retries return the route of the existing entry rather than an
ambiguous success. `GARDEN_NO_DEADLETTER=1` continues to turn the re-addressed
case into an error for callers that require a live doer.

## Atomic completion handoff

On every completion retry, after syncing the journal clone and before deleting
`inbox/<base>/`, `complete-job.sh` handles each inbox child as follows:

1. Leave `read/` entries eligible for deletion. Their doer already committed the
   acknowledgment.
2. Rewrite each `unread/<msgid>.md` as `inbox/dead/<msgid>.md`, preserving its
   sender metadata and body while adding `to: <base>`, `dead_lettered_at:`, and
   `readdressed_by: completion`.
3. Stage those rewrites in the same commit that writes `tada`, removes `doin`
   and `work`, and removes the old inbox.

The existing push CAS gives the handoff its safety:

- If `inbox-read` wins first, completion resyncs, sees the message in `read/`, and
  removes an acknowledged message.
- If completion wins first, a concurrent sender resyncs, sees no live recipient,
  and writes directly to `inbox/dead/`.
- If the sender wins first, completion resyncs and transfers the new unread
  message to `inbox/dead/`.

There is no state in which both a live inbox and deadmail own the same message.
There is also no state in which an unread entry is deleted. The old job still
ends normally and its inbox still disappears, so this does not resurrect it.

The completion helper must compare an existing global dead-queue pathname before
overwriting it. Byte-identical content is an idempotent success; different
content under the same caller-supplied `GARDEN_MSG_ID` is a hard collision that
leaves the inbox and job in place for a retry or operator diagnosis.

## Context-carrying continuation

The generic deadmail route remains a fresh `role: gardener` job. Before posting,
`deadmail.sh` uses the existing shard-aware `tada_find` helper
([`scripts/jobs/common.sh:5836`](../scripts/jobs/common.sh#L5836)) to locate the
intended recipient's report. The promoted body contains:

- `kind: deadmail-continuation` and `continuation_of: <base>` metadata;
- the current top-level direction to pick up the message's intent;
- the original message, unchanged and quoted as data;
- a `Completed recipient report` block copied from the exact `tada` file, also
  quoted as data, or an explicit `not found` marker for a typo or pre-history
  recipient.

Cap the copied report at 64 KiB, retaining its beginning and end with an omitted
byte count. This follows the error-reporting capture's bounded-context precedent,
which avoids making every journal reader pay for unbounded attachments
([`skills/gardener-inbox-error-reporting/SKILL.md:162`](../skills/gardener-inbox-error-reporting/SKILL.md#L162)).
The canonical full report remains at its `jobs/tada/` path.

Schedule carry-forward remains more specific and wins before generic promotion;
it already transfers the entry and retires dead mail atomically
([`scripts/jobs/deadmail.sh:146`](../scripts/jobs/deadmail.sh#L146)). Typed issue
follow-ups retain their current issue framing. The added completed-report block
applies to both typed issue follow-ups and generic continuations when a matching
report exists.

## Why this composes with the bus

- **Directed inboxes:** remain the fast path and keep a single owner. Completion
  adds a lossless unread-to-dead ownership transition.
- **Role and broadcast topics:** remain fan-out advisory channels. They do not
  become correction queues and therefore cannot double-answer a directed send.
- **Maintainer inbox:** remains the standing human channel. Dead-doer corrections
  become ordinary work, not maintainer notices. A routine completion with no
  unread mail writes no dead letter and posts no job.
- **Host error inbox:** remains an append-only, host-scoped failure log, not a
  reply target. Its documented purpose is surviving deterministic service
  failures when no gardener is running on that host
  ([`skills/gardener-inbox-error-reporting/SKILL.md:150`](../skills/gardener-inbox-error-reporting/SKILL.md#L150));
  using it for corrections would lose per-doer identity and mix action requests
  with operational diagnostics.

## Alternatives considered

- **A parked standing re-addressee per completed job.** Rejected. Parked inbox
  staging assumes a future claimant; a never-claimable record needs a second
  watcher, persists without a principled lifetime, and duplicates the deadmail
  queue. Creating it before completion also creates two apparent addresses for a
  live job. The earlier PR-specific proposal records this shape
  ([`designs/post-verdict-addressee.md:34`](post-verdict-addressee.md#L34)); its
  botanist use case was withdrawn after auto-conduct removed the approval wait.
- **Send every late message to `role/<role>`.** Rejected. Topics intentionally
  fan out with per-reader cursors, so several gardeners could answer, and idle
  roles do not provide a single durable acknowledgment.
- **Send every late message to the maintainer or liaison.** Rejected. It makes
  the human inbox a work queue and adds noise precisely when the garden can
  claim a continuation itself.
- **Keep the original job alive until its external subject terminates.**
  Rejected. It occupies a claim, is reaper-sensitive, and resurrects a finished
  unit of work instead of creating a separately auditable correction.
- **Leave deadmail unchanged and rely on send-after-completion.** Rejected. It
  does not cover the send-before-completion CAS ordering and cannot correct a
  receipt that already reported live delivery.

## Implementation and test plan

1. Factor a message-file readdress helper used by `inbox-send.sh` and
   `complete-job.sh`, including collision detection and the route receipt.
2. Change completion to transfer unread entries in its existing CAS commit.
3. Enrich generic and typed-issue promotions with shard-aware completed-report
   context. Keep schedule routing unchanged.
4. Update `skills/message-bus/SKILL.md`, CLI help, bulletin wording, and worker
   prompts so `live`, `staged`, and `readdressed` have one definition.
5. Add hermetic race tests for all three CAS orderings above, plus live, parked,
   absent, stable-id retry, conflicting-id, completed-report-present,
   completed-report-missing, schedule, and typed-issue cases. Assert both the
   receipt and that exactly one durable owner exists after every step.

Rollout needs no journal migration. Existing dead letters keep their current
shape, and the promoter treats missing new metadata as legacy input. The runtime
deadmail clones are caches and refresh from `journal2`; they need no direct edit.

## Dependencies

None beyond the current journal CAS, `tada_find`, deadmail singleton, and job
claim lifecycle.

## Out of scope

This design does not grant action or repository authority, guarantee that a
claimed continuation reaches the requested conclusion, retain completed
worktrees, or turn broadcast delivery into point-to-point acknowledgment. It
guarantees the narrower bus property: after an accepted send, one durable owner
can act on the message, including across recipient completion.
