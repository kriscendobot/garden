I ran panel round 1 on PR #610 and it came back **must-fix**. I posted the verdict to the PR, but as a comment rather than a request-changes review, because GitHub refused the latter.

- **Checkout:** PR head `endojs/endo-but-for-bots` @ `design/gateway-bearer-token-auth-reconcile` (e97da7153b), checked out in isolation at `/home/kris/garden/scratch/project-wt-endojs--1a5352f37843-c71aebca`. It touches two files: `designs/gateway-bearer-token-auth.md` and `designs/README.md`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 610 1132289243ba` (the real base SHA of `llm`, which is also the merge-base). It exited 0 with disposition `must-fix`. Output is in `/tmp/garden-panel-pr610-r1`.
- **Seat verdicts:**
  - Request changes: critic, decomplector, copyeditor, pedant, novice.
  - Comment only: skeptic, ergonomist.
  - Approve: orthographer, thesaurus.
- **Main findings:**
  1. Two other design docs still make the false claim this PR corrects: `daemon-web-gateway.md` and `daemon-docker-selfhost.md`.
  2. The design's own recommended setup (a reverse proxy on the same host, in Phase B) gets past the loopback-only admission check, and the doc gives no interim warning about it.
  3. The doc doesn't say which of `ENDO_GATEWAY=remote` and `ENDO_GATEWAY_ALLOWED_CIDRS` wins when both are set. Today `remote` silently discards the CIDR list.
  4. "Lineage" is never defined, the rate-limited rejection is missing from the sequence diagram, and there are em-dash and `§` style nits.
- **Posted review:** https://github.com/endojs/endo-but-for-bots/pull/610#pullrequestreview-5328619887. It has a summary header, all seat sections and a `garden-job` marker. The first request-changes attempt failed with "Can not request changes on your own pull request". The body says the disposition is must-fix and that it was posted as a comment only because of that limit.

**Follow-up:** if the next-stage heuristic keys on the review state rather than the stage marker below, it will see COMMENTED here and may not treat this as must-fix. The gauntlet script moves to the fix stage on the marker. I did no fixing and did not un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr610-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 22 tokens (729042 cached reads)
- Output: 3868 tokens
- Cost: $0.7692963999999999
- Wall-clock: 253s
- Model(s): claude-opus-4-8 ×6, claude-opus-5-5 ×1

<!-- garden-usage-end -->
