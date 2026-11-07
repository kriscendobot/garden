Fix round 2 for kriscendobot/minion.town#243 is pushed, but CI was still not finished when the one-hour deadline ran out, so this ends as still-pending. Six of seven checks passed (test, changes, the three browser gates, and Claude harness amd64). Claude harness (arm64) was still pending at 22:20Z; the final `ci-wait-merge.sh` call returned rc 4. No check failed.

**What I applied.** There was no pre-pass block, so I worked from the latest panel review (5815048472, "Must-fix before merge", on commit `8381c1b`). The follow-up commit is `a84de64`, pushed with `safe-push-pr-head.sh` as a fast-forward from `8381c1b`. The edits are to comments, docs and changesets only; I did not re-run `tsc` or the tests locally.

- **changeset-auditor:**
  - Deleted `.changeset/mcp-guest-invite.md`. It announced the `invite`/`cancelInvite` tools this PR removes, and it was never released (the repo has no `CHANGELOG.md`).
  - Put each sentence of `mcp-invite-tool-removal.md` on its own line.
  - Added a `Breaking:` line explaining why the bump stays `minor`: the app is a private 0.x with no published API consumers.
- **releaser:**
  - The `major` bump question is answered by that same `Breaking:` line, which follows the sibling `mcp-tool-minimalism.md`.
  - I reworded "holds a guest" to "has a guest session".
  - I did not split the "Fixed" line into its own patch changeset; that suggestion was marked optional. Its question about other HTTP and web changes also has no answer yet.
- **pruner:**
  - Deleted the comments that restated the code below them in `src/http.ts` and `verify-web-accept.ts`.
  - Cut the `home.js` comment down to why the check must come before `showShell()`.
  - Shortened the "bounded on purpose" header paragraph in `verify-web-accept.ts`.
  - Dropped the primer's copy of the guide's "same secret, works once" sentence.
  - Trimmed the PR body from 492 to about 350 words:
    - removed the repeated "production proof has not run" paragraph;
    - replaced the PASS list with one line saying the proof script passed;
    - replaced the `tools/list` table with "19 → 7 → 5 tools";
    - cut the test tallies and the list of removed files.
  - I left two pruner items alone: the run instructions that appear in both the `verify-web-accept.ts` and `local-daemon-server.ts` headers, and a link to the CI run in the Proof section (it is still mentioned under Tests).

**Follow-ups:**
- The driver should re-post this stage to finish the CI wait before panel-3.
- `ensure-project-worktree.sh` failed again with a read-only file system error under the monk sandbox (the known EROFS issue). I worked around it by cloning into `$TMPDIR`.
- The `ci.minion.town` runner was slow: jobs sat queued for about 25 minutes before running one at a time.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr243-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1760579 cached reads)
- Output: 8388 tokens
- Cost: $1.0657797999999998
- Wall-clock: 3844s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
