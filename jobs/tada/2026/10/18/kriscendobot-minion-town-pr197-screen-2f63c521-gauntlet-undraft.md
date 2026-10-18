**Gauntlet undraft stage: kriscendobot/minion.town PR #197**

**Result:** nothing to do. The PR is already out of draft, on the head the panel passed.

- **Metadata check:** fetched just before the stage decision and again just now. Both times: `state=OPEN`, `isDraft=false`, `headRefOid=a643682e04d4434256b87e5d308b2dcd1e3ef657`, which is the head the panel covered. Because it was already ready for review, I did not run `gh pr ready`.
- **Advisory appellate pass** (`claude -p`, Sonnet; advisory only, nothing gated on it). The diff was cut off at 60 KB with the lockfile hash lines removed, so later parts of it may not have been reviewed. It raised five points:
  1. **Load timeout:** the 15-second `LIVE_FRAME_LOAD_TIMEOUT_MS` also fires on clips that are slow but working, and swaps them for the inert card, so their state is lost.
  2. **Old `src` left behind:** `showDocument` and the failure fallback don't clear the previous `src`. The next `showLive` then briefly loads the old clip's URL, which could resolve the new clip's load watch too early.
  3. **Storage partitioning untested:** browsers partition the framed clip's storage and cookies by the top-level site, so the pane and "Open in new tab" don't share state. The browser gate doesn't test this, and Playwright WebKit doesn't reproduce Safari's tracking prevention (ITP).
  4. **Headers are mocked:** the gate tests mocked headers (CSP regex-scraped from the Caddy file, plus `ISOLATION_HEADERS`), not the headers Caddy and the gateway actually serve.
  5. **CI hardening:** the `pull_request` trigger runs on a self-hosted runner, which matters if fork PRs are possible. `actions/checkout@v4` is pinned to a tag rather than a SHA, and the workflow has no `concurrency` cancellation.

**Changes:** none. I made no garden commits and no changes to the PR.

**Follow-ups:** none of these points blocked the stage. Points 1 and 2 are small fixes worth a look; the supervisor or maintainer can decide whether to post a fixer job for them.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174585 cached reads)
- Output: 1628 tokens
- Cost: $0.412069
- Wall-clock: 65s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
