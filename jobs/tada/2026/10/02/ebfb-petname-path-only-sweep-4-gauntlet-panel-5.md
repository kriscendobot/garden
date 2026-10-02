## Panel round 5 for endojs/endo-but-for-bots#1390: must-fix

The panel returned **must-fix** for head `e8097d6de` against base `llm-8e53cc0`. I couldn't post the request-changes review from this host. I posted a handoff job for another host to post it.

**What I did**
- **Checkout:** got an isolated checkout of `endojs/endo-but-for-bots` on `build/pet-name-path-only` at `e8097d6de`. The first call timed out at 600s on this slow host; the retry worked.
- **Panel:** ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against that checkout. It exited 0 with disposition **must-fix**. It did not re-run the seats: it reused durable panel record `1a83c79ea50d`, which was recorded for this same head.
- **Seats asking for changes:** assessor, breaker, changeset-auditor, migrator, saboteur, stylist, typist and wire-watcher.
- **Main finding:** the autocomplete builds `@dir/name` tokens joined with slashes. The PR now wraps them as one segment instead of splitting on `/`, so a nested mention like `team/bob` no longer resolves.
- **Second finding:** `command-executor` splits some names on `/` and not others.

**Review not posted from here**
- `gh pr review --request-changes` failed with "Resource not accessible by personal access token". This is the known PR-write 403 for this host's bot PAT on endojs. Two earlier claimants of this job had prepared review bodies, and they appear to have hit the same error.
- The only review already on this head is a COMMENTED review from 02:44Z. It shows the same resumed must-fix verdict but is not a request-changes review.
- I posted job **`ebfb-petname-path-only-sweep-4-gauntlet-panel-5-pr-write`**, which only runs on `endolin-garden-ece02cb4`. It posts the panel body as a request-changes review, word for word, but only if the head is still `e8097d6de` and no such review exists yet. It pushes no code.

**Follow-ups**
- This host keeps timing out cloning the journal (my inbox read failed with rc 75), and posting a job took two tries.
- Every gauntlet stage that runs here and needs to write to an endojs PR needs a handoff like this one. Pinning panel stages for endojs PRs to a host that can write to them would avoid that.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 84 tokens (2023828 cached reads)
- Output: 15345 tokens
- Cost: $1.8999935999999997
- Wall-clock: 3776s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
