# Fix round 3 for kriscendobot/minion.town PR #192: both panel must-fix themes addressed, CI green

I made the fixes, pushed them to the PR head, and CI is green on the new head `efab329`. The panel was not re-run, as the stage requires.

**What I fixed**
1. **Missing ACL tools let checks pass silently.** Ten seats flagged this, including assessor, archivist, locksmith, saboteur and breaker. A prior claimant of this job had already fixed it in `50ab9a5`, but never watched CI or posted a summary for it:
   - All three deploy scripts now run `ensure_setfacl` before `install_node22` and abort if it fails.
   - `install_node22` refuses to run without both `getfacl` and `setfacl`.
   - A failing `getfacl` now stops the install instead of reading as "no ACL", and ACLs are always stripped.
   - Tests cover a missing `getfacl`, a missing `setfacl` and a failing `getfacl`.
2. **Symlink swap between check and lock** (saboteur, purist). New commit `efab329`:
   - Directories are now locked parents first, and each one is checked for a symlink only after its parent is locked. A non-root account can no longer swap one in before the privileged `chown`/`chmod`/`setfacl` runs.
   - A new test swaps `bin` for a symlink at the moment `/usr/local` is locked. It checks that the install refuses and never touches the symlinked path.

**What I declined**, with reasons in the summary comment on the PR (https://github.com/kriscendobot/minion.town/pull/192#issuecomment-6210511930):
- **Decomplector's must-fix:** it asks to rebuild the install as an immutable directory named by its digest, with an atomic switch. That changes the `/usr/local/bin/node` layout every deploy script and service points at, so it needs its own PR. The next panel may raise it again.
- **Releaser's changeset:** the repo has no `.changeset` directory.
- **Corner-prober's two-process `flock` test and fast-checker's property over every entry:** left for a follow-up.
- **Pruner's PR-body trims:** left for un-draft.

**Verification**
- The new test passes locally. Two older tests (`keeps a stamped…` and `locks the directories…`) fail locally both with and without my change, so the failures come from this host, not the fix.
- `ci-wait-merge.sh` returned rc 0: the one Actions run, `test (typecheck + vitest)`, passed on `efab329`. The bot token can't read the PR's check summary on this host, so it read the Actions runs instead and can't see other kinds of status checks.
- My first `ci-wait-merge` call was moved to the background and later stopped at its time limit. I polled the Actions API in the foreground until the run finished, then re-ran the script, which returned GREEN.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1503959 cached reads)
- Output: 11122 tokens
- Cost: $1.0938558000000003
- Wall-clock: 1795s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
