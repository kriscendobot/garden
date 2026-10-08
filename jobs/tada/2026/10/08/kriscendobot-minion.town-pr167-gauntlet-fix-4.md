I applied the round-4 must-fix items on kriscendobot/minion.town PR #167 (the root-canary design), pushed, and CI is green.

**What changed:** one follow-up commit, `c764d6f`, to `designs/root-canary-principal.md`. The PR head moved from `3760c2b` to `c764d6f` through `safe-push-pr-head.sh`.

- **Helper token cache removed (decomplector must-fix #1).** The helper now keeps nothing between calls. Each call reads the secret through the reader role and does one `refresh_token` grant, so the § 2.3 rule that the token never enters a file holds. The § 2.3 sentence now says where the token lives: in the helper call's memory only, and the canary command holds only short-lived access tokens.
- **Pedant items:**
  - `DEPLOYMENT.md` in the "Grounded against" header is now a relative link. It points to `../DEPLOYMENT.md`, not the panel's suggested `./`, because the file is at the repo root.
  - The "Restart and replay" and "Execution classification" labels, plus "Script entry points", are now bold like the other labels.
  - The terse "exit status is the failure channel" sentence is reworded.
  - I also fixed a wrong cross-reference: the sweep is § 2.6 step 2, not step 1.
- **Should-fix items I also took, beyond the must-fixes:**
  - **One channel for auth-unavailable.** Decomplector #2, critic #2 and ergonomist #2 all asked for this. The helper writes the status file and exits non-zero, the canary command just exits non-zero, and only the wrapper exits 75. The § 2.6 table, step 6, the ownership-map text and build item 8 are updated to match. Build item 8 now also tests a helper that dies before writing the status file, a gap the skeptic raised.
  - **Separate status script (ergonomist #3).** The read-only check is now its own `root-canary-status.sh` instead of a `--status` flag on the destructive revoke script. The script entry points are listed in run order.

**CI:** `ci-wait-merge.sh --no-merge` returned 0, with 3 of 3 checks passing.

**Follow-ups:** the panel's remaining should-fix and comment-only items are not addressed yet. They are:
- critic: the `AdminLinkProviderForUser` fallback, and the 15-minute versus 5-minute access-token lifetime
- critic #5: a cap on how much one sweep may delete
- skeptic: making clear what happens if premise A2 fails, A3's limits, and anomaly alerting
- novice: density and terms that are never defined

The next panel round (panel-5) will judge these.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (750417 cached reads)
- Output: 7192 tokens
- Cost: $0.8255794000000001
- Wall-clock: 327s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
