I ran panel round 7 on PR #94 and it came back **must-fix**. I posted the verdict as a review, but only as a comment: GitHub won't let the bot request changes on its own PR, which is how earlier rounds were posted too.

- **Run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against an isolated checkout of `kriscendobot/minion.town@security/token-client-auth-and-secret-umask` (head `889c963`), base `main-50aa690`. It exited with code 0 and its last line was `code-panel single-round — must-fix`.
  - My first launch was a background shell that would have been killed at 10 minutes, so I stopped it and re-ran the panel detached. That run reused the round already in the run directory and wrote the record `panel-runs/kriscendobot-minion.town-94/b8b4bd891748.md`.
- **Seats:** 34 ran. 2 requested changes (archivist, breaker), 20 were comment-only and 11 approved. The comment-banner check forced the archivist seat in, and the repeated-mechanism check forced the decomplector to ask whether the mechanism is needed. It found the `/token` client check is needed and is a shared extraction of the existing SIWE check, so it raised no must-fix.
- **Must-fix items:**
  1. **breaker:** the shared `formUrlDecode` now turns `+` into a space and URL-decodes every Basic credential. If Cognito sends a raw `id:secret`, a secret containing `+` or `%` gets mangled and every request fails with 401. The fix is to confirm what Cognito actually sends, add a test with a raw `+`/`%`, and either fall back to the raw split or show the decoding is safe.
  2. **archivist:** the github-oidc-thunk README says the Cognito IdP reads the same `minion/github-oauth-app` secret the thunk checks against, but nothing in the diff confirms it. It also asked for a short comment on why `parseFormOrJson` returns `{}` for JSON that isn't an object.
- **Should-fix items also listed:** a stale precondition in the `deploy-thunk.sh` header comment, the smoke-check wording, tests that grep script text instead of running it, outage tests that depend on test order, and `any` used where `unknown` fits.
- **Posted review:** https://github.com/kriscendobot/minion.town/pull/94#pullrequestreview-5481305653, with the `<!-- garden-panel-verdict -->` marker. The full panel output is about 88 KB, too long for one review, so the review has the summary, the two request-changes write-ups in full, the list of seat verdicts, and a pointer to the journal record.

I changed no garden or project code and didn't un-draft anything. The fix stage owns the next step.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-panel-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1214519 cached reads)
- Output: 6104 tokens
- Cost: $0.9840878
- Wall-clock: 405s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
