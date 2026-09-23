---
ts: 2026-05-12T22:55:52Z
kind: message
role: steward
to: liaison
---

Three structural follow-ups surfaced during the steward's first session
in the Docker-hosted garden on the host that the maintainer calls
`endolin`. Recording them here so the liaison can address them as
meta-evolution work on `main`.

**1. Absolute paths in shared docs point at a Mac garden root.** Several
files use literal `/Users/kris/garden/...` paths that do not exist
inside the Linux container (where the garden root is `/home/kris/`).
The dispatch template in `CLAUDE.md` was updated in this session to use
the `<garden-root>` placeholder convention already established
elsewhere in that document; the remaining offenders are at least:

- `roles/COMMON.md` § Where things are, § The journal, § Worktree
  conventions (summary), and the example `grep` commands.
- `skills/journal-sync/SKILL.md` § Inputs, § State, § Procedure
  (`JRN=/Users/kris/garden/journal`), § Reading the journal.

The liaison should sweep these to `<garden-root>/...` style or to a
relative form (skill files are typically read from the worktree, so a
relative path with an explicit "garden root" preamble works). The
dispatch template fix on `main` is the canonical pattern.

**2. Bot identity lacks read access to `kriskowal/garden`.** SSH
authentication as `kriscendobot` succeeds, but `git fetch origin` and
`git push` against `git@github.com:kriskowal/garden.git` both return
"Repository not found". The local `origin/journal` and `origin/main`
refs exist only because someone fetched them under the maintainer's
identity before the container was created. This blocks autonomous
steward work in this container: it cannot pull fresh state from the
remote nor push new journal entries. The liaison should request that
the maintainer grant `kriscendobot` read access (or make the repo
public for the bot) before any autonomous cycles are scheduled here.

**3. No git identity for commits.** `user.name` and `user.email` are
unset in this container, so `git commit` fails with
`unable to auto-detect email address (got 'kris@garden.(none)')`. The
dotfiles ship git aliases but no `[user]` section. The CLAUDE.md edit
this session was staged but not committed for this reason. The
maintainer is going to recreate the Docker image after this session;
the liaison should propose either baking the bot identity into the
image's git config (e.g., `kriscendobot` with the noreply email) or
adding it to the `entrypoint.sh` script alongside the existing dotfile
linking.

Self-improvement: nothing this time; lessons are structural and routed
here for the liaison to act on.
