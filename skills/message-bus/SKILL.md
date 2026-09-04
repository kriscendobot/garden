# Skill: message-bus

Agent-to-agent and agent-to-user messaging over the journal branch. The bus is
the journal even for same-host communication, because the garden may run on many
hosts. Full design in [`designs/job-board.md`](../../designs/job-board.md) § 5.

## Two mechanisms

Message files are markdown and carry `.md`: `msgs/<addr>/<timestamp-id>.md` and
`inbox/<doer>/{unread,read}/<id>.md`. The mailbox directories (`inbox/<doer>/`)
stay extensionless — they are keyed by the job's spine basename.

- **Topic (fan-out)** — `msgs/role/<r>` and `msgs/broadcast`. Many readers, each
  tracking its own read cursor *outside* the journal (so `reset --hard` never
  loses it).
  - send: `send-msg.sh role/<name>|broadcast [body]`
  - read: `read-msgs.sh <seen-key> <addr>…` (prints unseen, advances the cursor;
    exit status = count). Every working gardener polls `role/gardener` +
    `broadcast`.
- **Directed inbox (point-to-point)** — `inbox/<doer>/{unread,read}`, state held
  in the journal. The inbox is created at claim and destroyed at completion (a
  job doer's lifetime).
  - send: `inbox-send.sh <doer> [body]` (CAS-append to `unread/`; refuses if the
    doer is not active). Frontmatter: `from_host`, `from`, optional `reply_to`,
    and `sent_at`. Machine-produced deadline warnings additionally carry
    `kind: deadline-nudge`, `claim_attempt`, `deadline_at`, and
    `remaining_seconds`.
  - read: `inbox-read.sh <doer>` (the doer CAS-moves `unread → read`).
  - deadline warnings are queued journal messages, not mid-turn model input. A
    running job observes one only when it next calls `inbox-read.sh <doer>`.

## Maintainer channel (via the liaison)

- A gardener: `message-user.sh <its-base> [body]` → standing `inbox/maintainer/`,
  tagged `reply_to: <base>`.
- The liaison runs `maintainer-watch.sh` through the Claude **Monitor** tool,
  then `maintainer-reply.sh <msgid>` (routes into the doer's inbox + archives) or
  `maintainer-archive.sh <msgid>`. An **empty reply** to `maintainer-reply.sh`
  (blank body-file and blank stdin) delivers nothing and just moves the message
  unread → read, the same as a bare archive: leave the reply blank to dismiss a
  message that needs no answer.
- The still-working gardener receives the reply through its own `inbox-read.sh`.

## Coalescing repeats (stable ids + amend-while-unread)

`inbox-send.sh` mints a **fresh random id per call** unless the caller supplies a
stable one via `GARDEN_MSG_ID`. A stable id alone is the **idempotent-skip**
contract (a re-polled GitHub comment must not double-deliver): a re-send of the
same id is a no-op while the entry is present.

Autonomous notify paths want the **other** discipline — the one
`watchdog-notice.sh`/`doom-notice.sh` already prove — so a *repeat* AMENDS one
entry instead of piling a file per send (the 2026-07-28 flood shape; audit rec 9 /
[cybernetics-audit](../../designs/cybernetics-audit.md) § 3.3). Opt in with
`GARDEN_MSG_COALESCE=1` **plus** a stable `GARDEN_MSG_ID` (the **episode** key):

- A re-send whose episode entry is still **unread** amends it in place —
  `notice_count` bumps, `first_seen` is preserved, `last_seen` and the body
  refresh — under a **1 h per-key delivery throttle**
  (`GARDEN_MSG_COALESCE_THROTTLE_SECS`): occurrences inside the window are
  **counted, never dropped**, and fold into the next past-window amend.
- Once the recipient **drains** the entry (`unread → read`), the next occurrence
  posts a **fresh** episode — a re-occurrence after it was handled deserves to be
  seen again (same archive rule as `watchdog-notice.sh`).
- Key on **(sender, episode)**, never sender alone: distinct messages carry
  distinct ids, so genuinely different notices still get their own entry.

Callers wired this way: `orchestrate.sh`/`gauntlet.sh` (episode = the `<base>`-
condition subject), the follow-up liaison handler (episode = message content
digest), and `message-user.sh`, which **defaults** a per-job, per-content episode
key (`msg-<doer>-<body-digest>`) so a gardener re-reporting the same status folds
while a distinct message does not — pin your own `GARDEN_MSG_ID`, or set
`GARDEN_MSG_COALESCE=0`, to override.

## Fully-qualify issue/PR references

Issue/PR references in a message **body** must be **fully-qualified**:
`owner/repo#N` or a full `https://github.com/owner/repo/(issues|pull)/N` URL —
these resolve without knowing who sent them, so they render unambiguously
everywhere. A bare `#N` (or a bare `owner#N` / `GH-N`) is **rejected**: every
author-written send primitive (`message-user.sh`, `send-msg.sh`, `inbox-send.sh`,
`maintainer-reply.sh`) runs the deterministic, Markdown-aware
`check-issue-refs.sh` on the body before the push and refuses to post it,
printing each offending reference and the remedy. References inside **fenced code
blocks** (```` ``` ````/`~~~`) and **inline `code` spans** are exempt (a
`` `rebase #652` `` command example is vocabulary, not a reference), as is an ATX
heading marker. Machine/relay producers that forward generated or external bodies
bypass the gate with `GARDEN_SKIP_REF_CHECK=1`.

## Notes

Both directions CAS over the journal push: senders add (retry), the receiver
moves `unread→read` (it is the sole mover, so it always eventually lands).
