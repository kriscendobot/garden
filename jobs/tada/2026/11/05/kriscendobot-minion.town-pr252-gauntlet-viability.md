**Gauntlet viability: PR #252, `kriscendobot/minion.town`, fix(home): recover guest links pasted in the open page**

Result: `viability=proceed`. I ran no clean, panel, fix, CI-wait or un-draft stages and changed nothing.

**PR state:** open draft, created 2026-11-05T08:52Z, with no comments or reviews. It has one commit, `755d0179`, on base `main-7a0bcc9`, and GitHub reports it as mergeable.

Deciding question: On current `main`, does pasting a guest URL over the open landing page still fail to run recovery, with no other merged or open change already fixing it in `home.js`?

Answer: yes, on both counts.

Evidence:
- **Defect is still in the code:** `deploy/aws/www/home.js` on `main` reads `location.hash` only once during `boot()` and has no `hashchange` listener (0 matches). A fragment-only navigation therefore can't re-run recovery.
- **Reproduction:** the producing job, `fu-minion-town-older-draft-triage-20261105-1`, reports reproducing it in real Chromium: the splash stayed up and the credential stayed visible in the address bar. I didn't re-run this; the code on `main` is unchanged since then.
- **No newer base history:** `main` and `main-7a0bcc9` are the same commit, `7a0bcc90`, so the PR is 0 commits behind. The last `home.js` change on `main` was `7c34f50de` on 2026-10-25, and the eight most recent merged PRs don't appear to address this by title.
- **Not superseded:** I searched the diffs of all 66 open PRs for added `hashchange` lines, and only #129 has one.
    - #129 is the older draft from 2026-09-28, and its listener targets `guest.js`, which is no longer on `main` (the triage attributes the deletion to #198).
    - So #252 replaces the live part of #129, not the other way round.
- **Need still holds:** the 2026-11-05 older-draft triage named this as the one finding that suggested a live user-facing defect, and asked for a port to `home.js` if it reproduced. #252 is that port, and it adds a same-tab recovery check to `test/browser/clip-frame-gate.ts`.

**Follow-ups:**
- **CI not checked:** the bot PAT can't read `statusCheckRollup`. The producing job reported the five checks still queued, so CI remains for the later stages.
- **#129 cleanup:** once #252 lands, #129's pasted-URL part is moot. The triage report notes the rest of #129 separately, so a later triage should decide what to do with it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr252-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (277104 cached reads)
- Output: 4270 tokens
- Cost: $0.5262127999999999
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
