I've applied all of the round-6 must-fix items on kriscendobot/minion.town#248 and pushed them, and CI is green: all 6 checks pass, including the browser gate on chromium, firefox and webkit.

**Fixes (head `c9cd4a92` → `43628b51`, pushed with `safe-push-pr-head.sh`):**
- **`bc469d91` (breaker, engine-realist, corner-prober):** a pending refresh now hides `#empty` along with the clips and the frame. Before, one account's "No clips yet." stayed visible while the next account's read was pending.
  - `test/browser/clip-frame-gate.ts` adds a test that holds a refresh after an empty listing, checks the pane is hidden, then checks it comes back once the read settles.
  - A second new test covers deploy skew: it runs the shell without `#empty-title` through an empty read, a failed read and the New Clip button, and gets no page errors.
- **`c8198b78` (fast-checker):** a fast-check property in `test/shell-clip.test.ts`, 1000 runs over status, redirect and arbitrary JSON body. It checks that "account empty" is true exactly when a 2xx, unredirected answer lists `clips: []`.
- **`43628b51` (archivist, integrator, changeset-auditor):**
  - `designs/clip-shell-framework.md` now describes `ClipListing { clips, accountEmpty }` and which pane title each kind of listing produces: empty, denied, redirected, malformed, failed and pending.
  - The changeset is now `patch`, describes only the new title behavior, and puts one sentence per line.
- **PR body (coverage-auditor):** I added a note explaining that `dev/new-clip-browser-demo.mjs` is a developer demo that needs the full local stack, not shipped code. The behavior it shows is covered by `clip-frame-gate.ts` on all three engines.
- **Scribe:** posted a completion summary comment (issuecomment-6653720839) listing the follow-up commits for each review and the verification. Nothing was declined.

**Local checks:**
- `test/shell-clip.test.ts`: 101/101 pass.
- `npm run typecheck`: clean.
- `clip-frame-gate.ts` on chromium: 41/41 pass.
- The full vitest suite has failures in three files this PR doesn't touch (`test/git-remote/capability.test.ts`, `tools/claude-harness/install.test.mjs`, `tools/claude-harness/release-verifier.test.mjs`). They didn't show up in CI.

**CI wait:** the 4 checks besides chromium sat queued for about 20 minutes. My first `ci-wait-merge.sh` run was in the background and got killed by its time limit. I re-ran it in the foreground in about 9-minute segments: two returned rc 4 (still pending), the third returned rc 0 (green).

No follow-ups. The driver posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr248-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2221438 cached reads)
- Output: 12841 tokens
- Cost: $1.3191955999999998
- Wall-clock: 3810s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
