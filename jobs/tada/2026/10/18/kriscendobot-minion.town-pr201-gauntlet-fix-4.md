Round 4 fixes for PR #201 are pushed, but CI never started. The run for head `28aaa90bab4` sat queued for the whole hour after the push, and `ci-wait-merge.sh` returned rc 4 (still pending). So this stage ends as still-pending, not done; the queue looks saturated rather than red.

**Commits pushed** with `safe-push-pr-head.sh` (`27036b5..28aaa90`):
- `b7fe5da` fix(new-clip): code changes and tests
- `28aaa90` docs(new-clip): doc and trim changes

**What changed, by panel seat:**
- **breaker #1 (must-fix):** a visitor import whose `type=` names a directory that doesn't exist no longer locks up the clip power.
  - `measure` now never throws. A name whose `list` or text read fails counts as one name with no text.
  - `importLocator` removes the stored name if the size accounting fails.
  - New test: such an import stays writable and can be removed.
- **breaker #2:** `readText` refuses a blob longer than one write may store (`NEW_CLIP_MAX_TEXT_LENGTH`), with a test. The docs now say a single blob is still read whole, because the daemon has no length-limited read.
- **engine-realist #1:** queued mutations are capped at `NEW_CLIP_MAX_PENDING_MUTATIONS` (1024). Past that they are refused instead of waiting forever behind a stuck daemon call. The doc comment names that failure mode and says the usage cache lives only in memory. Test added with a write that never returns.
  - I first tried a cap of 64, but that broke the existing burst test, which fires 300 writes at once.
- **warden #1:** `describeKind` only reads labels the table itself defines, so a type of `constructor`, `__proto__` or `toString` now shows as unknown instead of rendering blank. Test added.
- **decomplector #1/#2:** the pet-name rules now live in one place, the new `src/endo/gateway/new-clip-pet-name.ts`. The clip power's source gets them inserted as data, and the page's `model.js` imports from that file. The design doc says why: the power is a source string, so it can't import shared code.
- **archivist #1–#4:**
  - `designs/new-clip.md` no longer claims the shell frame shows the current form; that becomes a follow-on.
  - The design doc and the `mintNewClip` comment now describe what happens when releasing the names fails: an `AggregateError` after a failed publish, a `warning` after a successful one.
  - The `guest-self-endpoint.ts` comment now says "not same-origin".
- **pruner #1–#7:**
  - In the design doc, the "Bounded work" and "Local values only" bullets became a pointer to the header in `new-clip.ts`, and the `@endo/init` sentence is gone.
  - Removed the repeated Playwright note in the demo header, the comment in `types.d.ts`, and the three section comments in `styles.css`.
  - Trimmed the PR body: dropped the "Browser coverage" section and the beta-pass line, and shortened the bullets.

**Tests:** the two New Clip test files pass (33 tests). Typecheck is clean and the front bundle builds. The full suite has one failure, `test/git-remote/capability.test.ts`, in code this PR doesn't touch.

**Not addressed:** breaker #3 (should-fix). `metamorphose` and `makeApp` still accept an imported directory as an app root. Exploiting it needs a leaked 256-bit formula id, so the breaker rated it should-fix. It's left for the next panel to decide.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3188602 cached reads)
- Output: 19800 tokens
- Cost: $1.8316724000000002
- Wall-clock: 3879s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
