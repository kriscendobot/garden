## Panel round 1: kriscendobot/minion.town PR #192 came back **must-fix**

The panel ran and the verdict is posted on the PR. GitHub would not accept a request-changes review because the bot (kriscendobot) opened this PR. I posted it as a comment review instead; the body says must-fix plainly.

**What I did**
- **Checkout:** made an isolated checkout of `kriscendobot/minion.town` branch `fix/node-install-root-ownership` at head `ed06164`, against base `origin/main-30a4c62`.
- **Panel:** ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh`. It exited 0 and all 33 seats finished with status ok. The disposition is `must-fix`, and the run is recorded at `panel-runs/kriscendobot-minion.town-192/93ea48420362.md`.
- **Restart:** my first attempt ran under a 10-minute background limit, so I stopped it and re-ran it detached, polling until it finished.
- **Posting:** the full aggregate is about 79 KB, more than GitHub allows in one review body.
  - The comment review (posted 2026-10-16T03:35:09Z) carries the must-fix heading, a table of every seat's verdict, and the full findings of the five seats that requested changes.
  - The other 28 seats' findings went into two PR comments (issuecomment-6207495554 and -6207495955).

**Main must-fix findings**
- **Missing directories abort the deploy:** in `deploy/aws/scripts/lib/install-node22.sh`, the `chown root:root` step lists directories without checking they exist. A Node v22 install laid out differently from the official tarball can lack one, and the `|| return 1` then stops the whole deploy. The tests stub `chown` and never create these directories, so they miss this. Raised by breaker and corner-prober.
- **Heredoc expansion is unchecked:** at the three install sites, nothing confirms that `$INSTALL_NODE22` survives the unquoted heredoc intact. The fix is to render each deployed script and run `bash -n` on it.
- **Other seats:** locksmith, wire-watcher and pruner also requested changes. Pruner reviewed the PR description because the concision check flagged it. Their details are in the review.

**Follow-up**
- **Fix stage may miss the verdict:** its instructions in `scripts/jobs/gauntlet.sh` say to read "the request-changes `gh pr review`". On a PR the bot opened, that review will always show up as COMMENTED. The heuristic should also accept a must-fix comment review, or the fix stage needs to read the heading.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (998915 cached reads)
- Output: 5573 tokens
- Cost: $0.808203
- Wall-clock: 307s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
