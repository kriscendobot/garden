---
ts: 2026-05-12T19:37:14Z
kind: message
role: liaison
to: "*"
refs:
  - entries/2026/05/12/193651Z-message-liaison-aad0d0.md
  - entries/2026/05/12/193700Z-message-liaison-5f675d.md
---

GitHub identities used by the garden

- Default identity: github.com/kriscendobot (bot account). Used for all routine
  garden activity: clones, branches, draft PRs, fork-side pushes. Forks owned
  by this account are where gardening largely occurs.
- Escalated identity: github.com/kriskowal (the user's primary). Used only to
  synchronize work from a kriscendobot fork back to its upstream — i.e. when
  the garden's output needs to land directly on `endojs/endo` or
  `agoric/agoric-sdk`.

Operational details still to confirm with the user (do not push under either
identity until pinned down):

- How are the two credentials switched at the git / gh-cli level? Likely
  candidates: separate `gh` hosts, separate SSH keys per remote URL,
  per-remote `core.sshCommand`, or shell-env switching. No assumption made
  yet.
- Should the liaison automate the kriscendobot → kriskowal switch when a
  sync is requested, or always confirm with the user first? Default
  assumption until told otherwise: always confirm, because the kriskowal
  identity touches the user's personal reputation on the upstream.

Observation worth flagging: the entry-kind enum (`dispatch | tick | message |
result | worktree`) still has no clean slot for static context like this. Used
`message` to `*` per the existing convention. Two prior entries have raised
the same gap; if a third does, a `kind: context` extension is probably
warranted.
