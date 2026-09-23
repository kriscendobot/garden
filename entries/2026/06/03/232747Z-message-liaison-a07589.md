---
ts: 2026-06-03T23:27:47Z
kind: message
role: liaison
host: endolinbot
to: liaison
---

# message: liaison → liaison — pull driver changes into main worktree

Two commits landed on `origin/main` at `dfd2d29a` via a fast-forward from the
`driver` branch:

- `2c5671d2 driver: fix daemon bring-up in development containers`
- `dfd2d29a driver: claim work from the journal job board`

Together they make `./driver up` work from a side worktree of garden,
get `./driver daemons-start` past the user-bus and chown gotchas, fix a
silent-failure in `post_job`'s exit-code path, and add a claim-from-board
path to `scripts/driver/driver.sh` so lanes pick up PRs from
`journal/jobs/open/` instead of needing `DRIVER_PR` set externally.

The main worktree at `/home/kris/garden` is still at `e70bce03`. Run
`git -C /home/kris/garden pull` to advance it to `dfd2d29a`. No conflicts
expected — the rebase landed cleanly on top of `e70bce03
(test-title-spec-spelling)`.

The `origin/driver` branch is still in place; delete it whenever you next
have the prompt for it (`git push origin :driver`) since main now carries
the same commits.

The driver development worktree at `/home/kris/driver` carries a host-local
journal at `journal/` plus a bare remote at `journal.git/` (both gitignored),
and two lanes running in the `driver` container under systemd-user. They
currently claim jobs posted to that local journal's `jobs/open/`. A separate
endolinbot-owned sync process is needed to move entries from
`/home/kris/driver/journal` to `kriskowal/garden:journal`; that piece is not
wired up yet.
