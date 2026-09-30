Fix round 1 for kriscendobot/minion.town PR #143 is pushed and CI is green: all 3 checks passed, and `ci-wait-merge` returned rc 0. The head moved from `d76483b` to `9c54b53` through `safe-push-pr-head.sh`, as three follow-up commits.

**Must-fix items from the panel-1 review (all applied):**
1. **`/account/clips` crash (engine-realist):** a listing failure that was not `DaemonUnavailableError` was rethrown from an async Express 4 handler, which can exit Node. The route now catches every error, logs the unexpected ones, and returns a 503 with `Cache-Control: no-store`. A new test uses a plain `Error("CapTP connection closed")` and gets a 503 back. This also fixes the should-fix about the 503 lacking `no-store`. (`3d48fd8`)
2. **Incomplete `shell.html` → `index.html` rename (integrator):** fixed in the Caddy comment, `DEPLOYMENT.md` and the `shell.js` frame-bust comment. The only remaining `shell.html` mentions describe the redirect stub or the page's history. (`54ba6c1`, `9c54b53`)
3. **Design only half-updated (integrator):** in `designs/clip-shell-framework.md` I rewrote the status line and updated § 2, § 3, § 6, § 8 and Open question #2 to match what shipped. Open question #3 (storing clips in `localStorage`) is marked resolved, because the server now keys the list by account and nothing is stored in the browser. (`9c54b53`)

**Should-fix items also applied:**
- The "+" button now clears the highlighted clip in the gutter.
- If the user clicks something before the clip list finishes loading, the list no longer auto-selects the first clip over their choice.
- The iframe `sandbox` is now set before `srcdoc`, never after.
- Two `→` characters in a doc comment are now ASCII `->`.
- The owner-key test now checks against `identityKey(ISSUER, "alice")` instead of a hard-coded string.

**Not done:**
- **Commit split (integrator):** the original commit would need a history rewrite to split, which a follow-up-commit round shouldn't do.
- **`placeholder` field (purist):** it is now always `false`. I left the code alone; the design now says the field is reserved for § 6.
- **`listClips` identity shape (purist):** not changed; the test now uses the shared key function instead.
- **`clipOrigin` hard-codes `ocap.site`:** the server's clip domain is configurable, so the two can disagree on a non-default deployment. Not changed.

**Tests:** the three touched test files pass (55 tests). The full `npm test` run had one failure, `test/git-remote/capability.test.ts` ("propagates a git failure…"). It's in code this round didn't touch and matches a git-remote failure already recorded as pre-existing on this host.

Next is panel round 2, which the gauntlet driver posts.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-gutter-default-landing-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1808439 cached reads)
- Output: 11845 tokens
- Cost: $1.2259878
- Wall-clock: 411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
