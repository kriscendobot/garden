I applied the round-2 panel fixes to kriscendobot/minion.town PR #166 as one follow-up commit (`15b146cdc6e`). It went up through `safe-push-pr-head.sh` in advance mode, on top of `cca9e8e`. CI is green: `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks passing.

**What the commit fixes, by panel seat:**

- **Response text in public failure reasons** (saboteur, breaker, purist, spec-keeper):
  - The token and protected-resource metadata checks now check the HTTP status before parsing the body.
  - Both bodies are parsed by a new `parseJsonBody`, which fails with a fixed message giving only the body's length.
  - The bootstrap body, the negotiated protocol version, `metadata.resource` and `grant.error` are now reported by shape or length only, never echoed.
  - Errors that are not `CheckFailure` are reduced to their name plus a system error code (for example `TypeError (ECONNREFUSED)`) by a new `unexpectedReason`, so a JSON parse message can no longer quote the body.
- **Workflow command injection** (saboteur, breaker): reasons written into `::error`/`::warning` lines now have `%`, CR and LF encoded (`commandMessage`). Step-summary table cells have line breaks removed and `|` escaped (`tableCell`).
- **CSP floor loosened by extra directives** (breaker): any extra directive that can override the floor (`script-src-elem *`, `worker-src *`, `frame-src`, `*-attr`, an empty `media-src`) is now a violation. Two kinds of extra directive still pass: fetch directives limited to `'self'`/`'none'`, and directives that only tighten or report, such as `sandbox` and `upgrade-insecure-requests`.
- **Retry and session-reset test** (corner-prober, the one must-fix-loop item): MCP sessions are now closed with `DELETE /mcp` before each retry and when the probe ends. That also fixes the session leak another seat raised. A new test runs the check against a fake production whose first session fails, and asserts the order: token, close s1, new token, close s2.
- **Smaller items:**
  - Removed the three dashed-line banner comments (archivist).
  - A malformed canary record now fails with an error naming its path (saboteur).
  - `CheckFailure` and `CheckSkipped` now carry their own `name`, and the exported `assert` is now a module-private `demand` (purist).
  - The canary bytes are pinned with `deploy/probe/.gitattributes` (`canary/* -text`), so a line-ending change can't break the hash (corner-prober).
- **Post-deploy runs are now strict:** in `prod-probe.yml`, post-deploy runs now pass `--strict` like scheduled runs, so only a manual dispatch tolerates a skipped check. I updated the header comment and `DEPLOYMENT.md` to match.

The local suite has 19 tests and all pass, including the new ones for the CSP override cases, the reason sanitizing, the command encoding and the session reset.

**Left alone (all marked comment-only or summary-fix by the panel):** the extra boundary tests corner-prober listed, the `failure() || cancelled()` gate on the tracking-issue step, sending a mismatched ETag to test the 304, and splitting comma-joined CSP headers. I did not re-run the panel; the gauntlet driver posts panel-3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1353447 cached reads)
- Output: 14190 tokens
- Cost: $1.2594494
- Wall-clock: 471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
