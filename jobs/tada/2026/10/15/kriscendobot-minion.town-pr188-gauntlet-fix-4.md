## Gauntlet FIX round 4: kriscendobot/minion.town#188

I applied the panel's round-4 must-fix items (the review on 3b5bb8f). The commit is pushed and CI is green (`ci-wait-merge.sh` exited 0; the `test` job and both `Claude harness` jobs passed).

**Code changes:** pushed as follow-up commit `e4c71b8` to `clip-gutter-live-refresh` with `safe-push-pr-head.sh`, moving the head from 3b5bb8f to e4c71b8.
- **Missing refresh button (saboteur):** the shell no longer fails to start when `#refresh-clips` is missing. That happens when an older `index.html` is served alongside the new `shell.js` during a deploy. Focus and visibility refresh are still wired, and a new test covers this.
- **Redundant parts (decomplector):**
  - I removed the `generation` counter. The per-read `AbortController` alone now decides whether a read was replaced by a newer one.
  - I removed `invalidate()` and the `refresher.invalidate()` call in `markUserActed`. When a listing arrives, the shell already checks `userActed`, so the extra call did nothing more. Its two tests and the source-pinning assertion are deleted.
  - I kept `load()` returning `null` (failed read) separately from `[]` (empty answer). The JSDoc now says why: only a real answer may use up the first-load auto-select.
- **Spurious warning (saboteur, corner-prober):** a read that is cancelled on purpose no longer logs a warning, in either `makeClipSource` or the refresher. A new test covers this.
- **Design citation (integrator):** changed "design § 3" to "design Open questions #3".
- **Prose cuts:**
  - Pruner: removed the duplicated supersession sentence in the JSDoc, the comment above the selector, the "(tested above)" note, and the mechanics sentence in the design doc.
  - Archivist: the test comment now names `text()` instead of `body.json()`.

**PR title and description (integrator's must-fix):** both rewritten. They now describe the newest read winning over older ones, clearing the gutter when a refresh fails, pane stability, and the missing-button case, and name the test for each. The `garden-job` marker is kept.

**Local checks:** `npm run typecheck` passes, and `test/shell-clip.test.ts` passes (47 tests). I didn't run the full `npm test` locally; CI's `test` job ran it and passed.

**Left as comment-only items, not acted on:**
- A sentence in design § 2 about the new refresh control (integrator #3).
- Squashing the fix commits into the `feat` commit (integrator #4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1592214 cached reads)
- Output: 10681 tokens
- Cost: $1.1540948000000002
- Wall-clock: 961s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
