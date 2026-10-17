I added the headless-browser coherence test that design § 10 asks for to PR #181 (kriscendobot/minion.town). It passes in CI, and #181's Phase ledger now says `deliverable`.

**The test.** `test/git-remote/served-clip-browser.test.ts` is a new commit, 4553500, on #181's head branch `git-remote-served-clip`, pushed with `safe-push-pr-head.sh`.
- The gateway serves push A to headless Chromium. Every sub-resource request is held in the browser until push B has been committed and projected. Holding all of them, not just the stalled first script, stops the browser from fetching later assets early, before the push.
- It then checks both sides:
  - **Server side:** after the page itself, the gateway received only `/.content/<rootA>/` requests for the four assets the page names (two scripts, a stylesheet and an image).
  - **Browser side:** the page ran both A scripts, applied A's colour and rendered A's image width.
  - **Control:** the clean path `/app.js` was already serving B when the held requests were let through.
- With the HTML rewrite turned off, the server-side check fails, so the test does detect a page that mixes roots.

**Dependency and CI.**
- **Dependency:** `playwright-core@1.64.1` is now a devDependency, pinned exactly. It doesn't download a browser at install time.
- **`npm test`:** skips this file when no browser is installed. Setting `REQUIRE_BROWSER=1` turns a missing browser into a failure instead.
- **CI step:** `.github/workflows/test.yml` has a new step that runs the test inside the `mcr.microsoft.com/playwright:v1.64.1-noble` Docker image, with `REQUIRE_BROWSER=1`. The image is needed because the self-hosted runner has no sudo, so Chromium's system libraries can't be installed on it directly. Docker pulls the image fresh on every run.

**Results.**
- **CI:** run 39007298834 on 4553500 passed. The new step ran the test and passed, and the general `npm test` step skipped it as intended.
- **Typecheck:** passes locally.
- **Full suite locally:** one failure, `capability.test.ts` "propagates a git failure". The PR body already records it as failing only locally and passing in CI.

**PR #181 description.** The Phase line now reads `deliverable` and the "Successor" line is gone. I added a paragraph on the browser test and removed "no headless-browser coherence test" from the Gaps. The PR is still a draft, blocked only by design PR #177, which is also still a draft.

**Follow-up.** Another branch, `feat/clip-live-frame`, has its own "clip frame browser gate" workflow, so it is adding browser tooling too. Whichever lands second should switch to the same Playwright dependency and setup.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-git-remote-served-clip-browser-coherence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2743311 cached reads)
- Output: 19971 tokens
- Cost: $1.6678502000000004
- Wall-clock: 1763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
