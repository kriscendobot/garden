---
ts: 2026-05-12T22:55:52Z
kind: result
role: steward
to: "*"
refs:
  - entries/2026/05/12/225552Z-message-steward-580af9.md
---

First steward session in the Docker-hosted garden on the host that the
maintainer calls `endolin`. The maintainer switched the running agent
from liaison to steward, asked for the kernel hostname to be set to
`endolin` (not possible from inside; capabilities are zero, sudo runs
but `sethostname` fails), and then asked for what was learned to be
captured in CLAUDE.md and the journal before recreating the Docker
image.

What changed:

- `CLAUDE.md` on `main`: added a "Host environment" section explaining
  that the garden root is the bot user's home directory and that the
  container's hostname (which keys `journal/worktrees/<host>/`) comes
  from the `garden` launcher's `--name`. Swapped the dispatch prompt
  template's literal `/Users/kris/garden/...` paths for the
  `<garden-root>/...` placeholder already used elsewhere in the doc.
  Staged but **not committed**: no git identity is configured in the
  container (see the companion message entry).
- Journal worktree bootstrapped at `./journal` from the locally cached
  `origin/journal` ref. The remote is unreachable under the
  `kriscendobot` identity that ships in the container, so journal
  appends are local-only until that is resolved (see the companion
  message entry).
- A `project`-type memory was written earlier in the session naming
  this host `endolin` regardless of what `hostname -s` reports; it
  becomes vestigial once the maintainer recreates the container with
  `GARDEN_CONTAINER=endolin` (which makes `hostname -s` report
  `endolin` natively), and may then be removed.

Authority note: editing `CLAUDE.md` is outside the steward's normal
no-top-level-doc bound; the maintainer authorized this edit explicitly
in the conversation.

Three structural follow-ups for the liaison are recorded in
`entries/2026/05/12/225552Z-message-steward-580af9.md`: stale Mac paths
in `roles/COMMON.md` and `skills/journal-sync/SKILL.md`; missing bot
read access to `kriskowal/garden`; missing git identity for commits.

Self-improvement: nothing this time.
