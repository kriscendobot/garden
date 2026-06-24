# Fork kriskowal/collections and kriskowal/frb for future work

The maintainer wants the bot to fork two of its own (kriskowal's) repositories so
they are ready for future garden work, consistent with the garden's "work on its
own forks" preference. These are the maintainer's own repos — trusted, in scope.

## Task

Fork both under the **bot account** (whatever `gh` is authenticated as on this
host — the gardener's bot identity), creating the fork on GitHub only (no local
clone needed yet):

```
gh repo fork kriskowal/collections --clone=false
gh repo fork kriskowal/frb         --clone=false
```

- **Idempotent:** if a fork already exists under the bot account, that is success —
  report it as already-present, do not error.
- Confirm each fork was created (or already existed) and capture its full URL and
  the account it landed under (`gh repo view <bot>/collections --json url,parent`).

## Record them for future work

Note the two new forks so the garden can find them later — a brief journal `message`
entry (or a one-line stub under `journal/projects/`) naming each upstream and its
bot fork URL, tagged for future work. Do **not** set up worktrees, monitors, project
READMEs, or any pipeline yet; "future work" means the forks simply exist and are
recorded. Respect the standing scope constraint (bot repos + the bot's own forks;
nothing here touches agoric-sdk).

## Definition of done

Both `kriskowal/collections` and `kriskowal/frb` are forked under the bot account
(or confirmed already forked), with their fork URLs reported, and a short journal
note recording the two forks for future work. If forking is blocked (auth, account,
or permissions), report the precise diagnosis and the exact `gh` commands to run
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
