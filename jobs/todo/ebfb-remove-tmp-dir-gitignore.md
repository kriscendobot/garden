# Remove the top-level .tmp directory from endo-but-for-bots and gitignore it

Wear the **cleaner** (or fixer) role. The repo **endojs/endo-but-for-bots** has a stray top-level
**`.tmp/`** directory tracked in git. Remove it and add it to `.gitignore`. Bot repo, bot identity.

## Task

1. **Determine which branch(es)** carry a tracked top-level `.tmp/` (check `master` and `llm`,
   whichever applies) and remove the directory (`git rm -r .tmp`).
2. **Add `.tmp/` to `.gitignore`** (top-level) so it cannot be re-committed. Use a trailing-slash
   directory pattern; place it sensibly with the other ignore entries. If `.gitignore` already has
   it, just ensure the directory is removed.
3. Open a **PR** for the change (the branch is PR-protected — direct push is rejected) titled e.g.
   `chore: remove stray .tmp directory and gitignore it`, base the branch where `.tmp` lives. If
   it exists on more than one branch, handle each (or note which) — do not leave it tracked
   anywhere.
4. Verify nothing references `.tmp/`'s contents (it should be pure scratch); if anything legitimate
   lives under it, STOP and report rather than deleting.

## Definition of done

The tracked top-level `.tmp/` directory removed from endo-but-for-bots and `.tmp/` added to
`.gitignore`, via a PR (per protected branch), with a summary. Report the PR number(s) and which
branch(es) were cleaned. If `.tmp` is not actually tracked, report that and just ensure the
`.gitignore` entry exists.

Posted by the liaison on behalf of the maintainer.
