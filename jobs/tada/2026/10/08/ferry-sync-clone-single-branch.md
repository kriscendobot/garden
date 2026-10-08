**Completion report: ferry-sync-clone-single-branch**

`scripts/ferry.sh` now clones only the journal branch on its first sync. It's pushed straight to `main2` as `3d03a367d56`, with no PR, as garden convention says.

**Change:** I added `--single-branch` to the first-time clone in `sync_clone()`. Nothing else changed: the fetch on later runs, the bash-3.2/BSD dialect, and how the ferry board works are all as they were.

**Verification:** I used a scratch git repo standing in for the journal remote, with `main2`, the orphan `journal`, two stray branches and a `journal2` holding one fake `jobs/ferry/` directive. A stub stood in for `claude`, so no real boatman ran and no production credentials were touched. I ran `./scripts/ferry.sh --once` against an empty `GARDEN_FERRY_STATE`:
- **Size (check a):** the new clone's `.git` was 352K, against 952K for the same clone with the old flags. I did not re-measure against the real ~800MB origin.
- **Branches (check b):** `branch -a` lists only `journal2` and `remotes/origin/journal2`, and the fetch setting is narrowed to `journal2`. The old flags pulled down 6 branches.
- **Dispatch (check c):** the run found the directive, claimed it into `doing/` and pushed that, ran the stub, saw its completion marker, and moved the directive to `done/` with a second push. Both commits landed on the stand-in remote's `journal2`. Pushes name their target branch explicitly, so the narrower clone doesn't affect them.
- The test ran inside the container, so the script printed its usual "you're inside the container" warning, which was expected here. I deleted the scratch directory afterwards.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ferry-sync-clone-single-branch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (337801 cached reads)
- Output: 2973 tokens
- Cost: $0.5026282
- Wall-clock: 39s

<!-- garden-usage-end -->
