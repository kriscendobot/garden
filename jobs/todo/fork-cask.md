# Fork kriskowal/cask for future work

The maintainer wants the bot to fork another of its own (kriskowal's) repositories
for future garden work — companion to `fork-collections-and-frb`. This is the
maintainer's own repo — trusted, in scope.

## Task

Fork under the **bot account** (whatever `gh` is authenticated as on this host),
GitHub-only (no local clone yet):

```
gh repo fork kriskowal/cask --clone=false
```

- **Idempotent:** if the fork already exists under the bot account, that is success.
- Confirm and capture the fork URL and the account it landed under
  (`gh repo view <bot>/cask --json url,parent`).

## Record it for future work

Add a short journal `message` note (or a one-line stub under `journal/projects/`)
recording the upstream and the bot fork URL, tagged for future work — same shape as
the collections/frb note. Do **not** set up worktrees, monitors, project READMEs, or
any pipeline yet. Respect the standing scope constraint (bot repos + the bot's own
forks; nothing here touches agoric-sdk).

## Definition of done

`kriskowal/cask` is forked under the bot account (or confirmed already forked), its
URL reported, and a short journal note recorded. If forking is blocked, report the
precise diagnosis and the exact `gh` command rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
