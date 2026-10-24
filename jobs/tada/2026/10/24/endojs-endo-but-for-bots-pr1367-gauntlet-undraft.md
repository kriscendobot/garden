## Gauntlet UNDRAFT: endojs/endo-but-for-bots#1367 is now ready for review

**Result:** I un-drafted the PR at head `351dd0bc476c24d9fc6db92fbecd1035336de93e`, the exact head the passing panel covered.

**Gate checks:**
- **Before the change:** state OPEN, isDraft true, head matched the panel's head. Then I ran `gh pr ready`.
- **After the change:** isDraft false and the head is still `351dd0bc…`.

**Advisory appellate pass:** I ran a light `claude -p` (Sonnet) review on the diff alone. Per the job spec it did not block anything, and I did not post it to the PR. The PR changes 3 files (+508/−10) for the `daemon-git-remotes` next-slice design. Its notes:
- **M3 claim is overstated.** The PR says it "closes the client half" of the M3 git-push goal, but this slice only fetches. Pushing is left to an external client.
- **Origin can be persisted as fetch+push.** `provideGitClone` saves the origin with push allowed before it is narrowed to fetch-only. Only a host-discipline rule covers that gap, and open question 5 defers the fix.
- **Secret handling has gaps:**
  - The capability URL reaches the host helper through argv, env or shell history.
  - The redacting helper hides only the userinfo part of a URL.
  - The design never says to percent-decode `URL.password` before use.
  - It is loose about "never crosses CapTP" (the password does cross).
- **Docs disagree.** The README overrides `daemon-git-next-steps.md`, which this PR does not edit.
- **Small stuff:**
  - Stale dates.
  - The sentence "this PR changes no other row" is wrong: the PR adds one row and edits three.
  - "S, 1–2 days" looks optimistic.
  - Some cross-references are unchecked, including `#1360` and `minion.town#136`.

**Follow-ups:** none required. A later revision or human reviewer could pick up the advisory notes.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175247 cached reads)
- Output: 1513 tokens
- Cost: $0.41521339999999995
- Wall-clock: 60s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
