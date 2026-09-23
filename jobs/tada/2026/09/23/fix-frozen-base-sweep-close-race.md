I scripted the frozen-base sweep that runs when a PR closes, and made it re-check open PRs right before deleting and repair itself if a delete still hits a new PR. The new test passes 23/23; the script has not yet run against a live GitHub repo. Pushed to `main2` as `8eb5040789`.

**Why minion.town#114 was closed.** The sweep was only a shell loop written out in the skill, run by hand by the agent closing a PR. Its "does another open PR use this base?" check used `gh pr list --search`, and GitHub's search index is seconds to minutes behind new PRs. So #114, opened 8 seconds earlier on the shared `main-8e9f2be` base, was invisible to it. Even an up-to-date check can't fully close the gap, because GitHub has no way to delete a branch only if nothing changed since the check.

**What changed:**
- **New `scripts/jobs/gardening/sweep-frozen-bases.sh <owner/repo> <N>`** (`--dry-run` available). It reads the PR's base history plus its current base, and only ever considers pinned `<base>-<sha>` names, so a live trunk can't be deleted. For each base:
  - Immediately before deleting, it asks GitHub's REST API directly for open PRs on that base (never the search index). It keeps the base if any other PR uses it, if it is the head of an open PR, or if the lookup fails.
  - It records the base's SHA, deletes it, waits about 15 seconds, then looks for any other PR on that base that is open or was closed unmerged since the delete. If it finds one, it recreates the base at the recorded SHA and reopens the PR, which is the same recovery done by hand for #114.
  - If that repair fails, it exits 1 and prints the commands to finish it by hand.
- **New `scripts/jobs/test/sweep-frozen-bases-test.sh`** runs against a fake `gh`. It covers the normal sweep, keeping a base still in use, keeping a base that is a stacked PR's parent, the #114 race and its repair, a failed repair returning exit 1, a long-closed PR not counting as a victim, dry run, and an unreadable PR (deletes nothing).
- **`skills/frozen-base-branch/SKILL.md`:** the "Sweep on PR close" section now calls the script and explains both checks. The field notes have a new 2026-09-23 entry next to the existing shared-base note, covering how to recognise this failure (a PR closed unmerged seconds after opening, with a `base_ref_deleted` event and no human close) and the manual recovery commands.
- **`roles/conductor/AGENT.md`:** the conductor now uses the script and must not write the delete by hand with `--search`.

**Follow-ups:**
- I couldn't confirm the field name GitHub uses for the old base in `base_ref_changed` events, so the script reads `base_ref`, `previous_ref` and `current_ref`, whichever is present. It's worth checking the first real run (a `--dry-run` works) to see that bases from earlier retargets are picked up.
- Sweeping the head branch of a garden answer-surface PR (the PR opened so the maintainer can answer a design's open questions) is still done by hand.
- `ensure-pr.sh` still doesn't check itself that a PR it opened is still open afterwards. The fix is entirely on the sweep side.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-frozen-base-sweep-close-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (933295 cached reads)
- Output: 17812 tokens
- Cost: $1.187979
- Wall-clock: 158s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
