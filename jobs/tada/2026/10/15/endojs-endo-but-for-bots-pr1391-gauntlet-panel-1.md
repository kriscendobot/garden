The panel finished round 1 with a **must-fix** verdict, but I couldn't post it to PR #1391: this host's bot token can't write PR reviews on endojs. The stage result is therefore `panel-error`, which tells the driver to retry the round. Nothing on the PR changed.

**What ran**
- Got a checkout of `endojs/endo-but-for-bots@build/sturdyref-ses-accommodation` at head `282679ddaf`. The first try failed partway through the file checkout. It worked once I raised the git timeout (`GARDEN_REPO_GIT_TIMEOUT=900`) and cold-built the dependency cache.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1391 dbd2b003e6`. It exited 0 with the terminal line `code-panel single-round — must-fix`. Of 33 seats, 12 requested changes, 14 were comment-only and 7 approved.
- Main must-fix findings:
  1. **Subclass check can be bypassed:** `tame-parcel-constructor.js:24` passes the caller's `new.target` straight through. Three seats (breaker, wire-watcher, saboteur) each built a Proxy that produces a genuine Parcel whose prototype the attacker chooses, including a `then` method.
  2. **Changeset bump level:** `.changeset/ses-permit-parcel.md` says `ses: major` without documenting the one real break: `lockdown` now throws on a non-conforming `Parcel` global.
  3. **Stale PR body:** it still describes the old SturdyRef version, a changeset that doesn't exist, and the old base.
  4. **Wrong comment** at `intrinsics.js:100-102`.
  5. **Commit history** still contains a mid-stream SturdyRef→Parcel rename.

**Posting failed**
- I built a 57.6 KB review body in the same shape as the earlier rounds: summary, the request-changes and comment-only seats in full, and approving seats as a list. It was saved at `/tmp/body-1391.md`.
- `gh pr review 1391 --comment` failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is the known problem on host `oros-studio-garden-ce242c49`: the bot token lacks pull-request write access on endojs.
- The job requires a posted review, and the memory note for this host says to report `panel-error` rather than claim a verdict that isn't on the PR. So no review was posted.

**Follow-ups**
- I added "still true 2026-10-15" to the memory note about this token.
- If the retry lands on this host again, it will fail the same way. It needs a host that can write to endojs PRs (an endolin host), or the token needs pull-request write access on endojs.
- The full seat outputs are in `$TMPDIR/garden-panel-project-wt-endojs--46629f86ee5b-a4365e14-1391/` and will be gone when this host cleans up.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 94 tokens (2762986 cached reads)
- Output: 15745 tokens
- Cost: $1.9580892
- Wall-clock: 3021s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
