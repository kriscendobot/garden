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
    doer is not active). Frontmatter: `from`, optional `reply_to`, `sent_at`.
  - read: `inbox-read.sh <doer>` (the doer CAS-moves `unread → read`).

## Maintainer channel (via the liaison)

- A gardener: `message-user.sh <its-base> [body]` → standing `inbox/maintainer/`,
  tagged `reply_to: <base>`.
- The liaison runs `maintainer-watch.sh` through the Claude **Monitor** tool,
  then `maintainer-reply.sh <msgid>` (routes into the doer's inbox + archives) or
  `maintainer-archive.sh <msgid>`.
- The still-working gardener receives the reply through its own `inbox-read.sh`.

## Notes

Both directions CAS over the journal push: senders add (retry), the receiver
moves `unread→read` (it is the sole mover, so it always eventually lands).
