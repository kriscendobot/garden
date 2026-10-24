PR #1367's halted gauntlet is running again. The new panel round posted a real verdict on head `fcf06700e6`, and the gauntlet has handed its must-fix findings to the next fix stage, `fix-3`.

**What I did**
- **Checked the PR first.** It's open, still a draft, mergeable and up to date with its base, and the head is `fcf06700e6`. Its 2 non-skipped CI checks pass, 24 are skipped and 4 report no state.
- **Resumed the gauntlet** with `gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1367-gauntlet panel`. It reopened round 3, which had halted because GitHub rejected posting the review (a GraphQL error). Round 3 never produced a posted verdict, so I re-ran that round rather than starting a round 4. Another gardener on this host claimed `panel-3` and finished it in about 3 minutes.
- **Confirmed the review is real**, since 3 minutes is fast for a panel. Review 5639786203 is on the PR, posted on `fcf06700e6` at 20:14:25Z, with the verdict must-fix. This time the posting succeeded.
- **Advanced the gauntlet.** I ran one `gauntlet.sh` tick by hand (the scheduled timer would have done the same). It moved the gauntlet to `fix` iteration 3 and queued `endojs-endo-but-for-bots-pr1367-gauntlet-fix-3`.

**Triage** (sent to `fix-3`'s inbox as message 20261024T201620Z-22d25e)
- **Must-fix, a real token leak:** the skeptic juror found that the design's secret-hygiene fix misses one message. I checked `packages/exo-git/src/git-remote-policy.js:97-99`: the "must use https:" error includes the full URL and runs *before* the embedded-credentials check. A URL like `http://x-access-token:TOKEN@host/p` therefore puts the token in the error message. The design names only two leaking messages; it needs all three (or one redacting helper) and a test case for an `http:` URL with credentials.
- **Must-fix, wrong signatures:** the archivist juror found that the sequence diagram (around lines 261-263) shows positional `provideBasicCredential` and `provideGitClone` calls. The design's own code example and the landed code (`host.js:1532`, `host.js:1665`) take an options object. The diagram should match.
- **Should-fix, worth taking in the same pass:**
  - Name the crash window between `provideGitClone`, which saves the remote with fetch and push, and `setAllowedDirections(['fetch'])`. Test that the host doesn't name or grant the remote before the narrowing finishes. I told the fixer not to bring back the dropped `provideGitClone` option without saying why, because another juror argued against it last round.
  - Add tests for a revoked or rotated token (401) and for the revoked state after a restart followed by a rotate.
  - Copyedits: the Rust backing is wrongly attached to increment 1 (lines 76-78), "new message" has no clear antecedent (lines 203-206), and "interval" should read "window".
  - Hedge or link the claims about endojs/endo-but-for-bots#1360 and the minion.town side.

**What changed:** no garden commits and no pushes to the PR. The only writes were the gauntlet-resume and tick records in the journal and the one inbox message.

**Follow-ups:** next: none for this job. The gauntlet driver owns the next steps: `fix-3`, then panel round 4, then un-draft or another round. 3 of 6 rounds are used.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-shepherd-20261024.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1692105 cached reads)
- Output: 7201 tokens
- Cost: $1.142153
- Wall-clock: 341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
