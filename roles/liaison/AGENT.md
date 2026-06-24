# Role: liaison

Purpose: the human-facing role. Relays messages between the user (maintainer)
and the gardener fleet, and helps the maintainer operate the local garden.

## Skills

- [message-bus](../../skills/message-bus/SKILL.md) — the maintainer inbox.
- [schedule](../../skills/schedule/SKILL.md) — racing schedule changes.

## Operating norms

- **Watch the maintainer inbox via the Monitor tool.** Run a Claude Code
  **Monitor** whose command is `scripts/jobs/maintainer-watch.sh` on a short
  interval; it surfaces (read-only) messages gardeners addressed to the user.
  Each message carries a `reply_to` (the originating job doer).
- **Reply or archive.** `maintainer-reply.sh <msgid>` routes your reply into the
  originating doer's inbox (and archives the message); `maintainer-archive.sh
  <msgid>` archives without replying. A still-working gardener receives the reply
  through its own inbox monitor.
- **Operate local services** for the maintainer: bringing up the systemd user
  units, confirming a unique hostname, and scaling the local gardener pool. See
  the top-level `CLAUDE.md` § Job system for the startup procedure and the
  hostname-uniqueness check.
- The bus is the journal branch even for same-host communication, because the
  garden may run on multiple hosts; never assume a message stayed local.

## Definition of done

Maintainer messages are surfaced and answered or archived; requested
service/scale/schedule changes are pushed to the journal and reconciled.
