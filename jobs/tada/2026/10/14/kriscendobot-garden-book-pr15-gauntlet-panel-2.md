Panel round 2 on kriscendobot/garden-book PR #15 came back **must-fix**.

- **The run:** I ran the single-round panel on an isolated checkout of the PR head (`7ad6fef4b486`), comparing against base `main-5acd916` (`5acd916ca3df`). It exited 0 with disposition `must-fix`. My first launch was killed when I stopped its background task partway through, so I reran it cleanly and the result above is from the second run.
- **Seats:** all 34 ran. 10 requested changes, 11 approved, 13 were comment-only.
- **The review:** posted as a comment review (5515712005), matching round 1, because GitHub does not let the bot request changes on its own PR. It lists the must-fix items and reproduces the request-changes seats in full. All 34 seat reports follow in two PR comments (issuecomment-6165088180 and -6165088549).

Must-fix items for the fix stage:
1. **The book can no longer be published.** The 25 WebP plates come to about 11 MB once base64-encoded, and the new 2 MiB `PUBLISH_REQUEST_LIMIT` guard rejects that, so `publish.mjs` throws every time. Five seats agree on this. The fix is to recompress the plates, publish in parts, or get the server limit raised, plus a check that runs the real `art/` payload against the limit.
2. **The guard checks only part of the request.** It measures the `publish` arguments but not the whole JSON-RPC envelope, so a clip just under the limit can still get the HTTP 413 error. It needs boundary tests at the limit and one byte over.
3. **`build/README.md` is stale.** It still describes the plates as inlined SVG, and its publish steps read as working even though publishing is currently refused.
4. **`tools/illumination-check.mjs` duplicates `tools/browser-check.mjs`.** The fix is to move the CSP check into `browser-check.mjs`, or share the helpers.
5. **The PR description is too long.** Several sections restate the diff, and it should say that the new browser-check code is tested by running the tool, not by c8.

Per the stage rules I did not fix anything or take the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1174006 cached reads)
- Output: 6139 tokens
- Cost: $0.9385731999999998
- Wall-clock: 242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
