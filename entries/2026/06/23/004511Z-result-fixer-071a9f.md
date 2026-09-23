---
ts: 2026-06-23T00:45:11Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/23/004511Z-result-fixer-071a9f.md
---

RSVP on kriskowal's review 4548846674 of PR #486 (claude-sandbox).
Force-pushed to claude/claude-sandbox from lease anchor 87bfd5d5a.

## Asks addressed

1. **Comment 3456075456** — makeExo over Far in buffered-channel.js.
   Commit 1ca1147c4. Replaced Far(name, {...}) with
   makeExo(name, BufferedReaderInterface, {...}) and added a typed
   M.interface guard.

2. **Comment 3456086532** — "out of vogue" heading in docs.
   Already addressed in prior commit 87bfd5d5a ("Guiding principle").

3. **Comment 3456094295** — passable context / cancellation kit.
   Commit 1d5ff1e17. Extracted makeCancellationKit() (now exported),
   returning { context, cancel } with the daemon's whenCancelled() shape.
   Tests use it. Removed the raw .cancelled fallback branch.

4. **Comment 3456097069** — @import JSDoc sweep.
   Commit 9731850c0. Two inline import() occurrences converted
   (claude-credentials-factory.js:305, claude-sandbox-factory.js:221).

5. **Comment 3456116865** — magic numbers as options (claude-client.js).
   Commit 8a27c3e9b. Added stderrReadLimit (default 16384) and
   stderrTailLength (default 2000) to ClaudeClientArgs.

6. **Body ask — credential-leak analysis** (commit 201206b91).
   DESIGN.md section 9 open item replaced with finding: Claude Code does
   not strip ANTHROPIC_API_KEY / CLAUDE_CODE_OAUTH_TOKEN from tool
   subprocesses; POSIX environment inheritance applies. Added Credential
   exposure section to docs/claude-sandbox-directory.md linking to DESIGN.md.

## Deferred (documented on inline threads)

- Comment 3456107604 (parseStreamJsonLines + mapReader): 1-to-many
  transformation cannot use mapReader directly; needs stateful line
  accumulator + @endo/stream dependency. Follow-up commit.

- Comment 3456119928 (makeBufferedReader + pipe/pump): semantics
  (fire-and-forget push, terminal events, onClose) don't map cleanly
  to makePipe/pump. Needs @endo/stream at makeQueue/makeStream level.
  Follow-up commit.

## Intentionally skipped

Comment 3456084509 (designer dispatch scope).

## Commits on PR branch

- 1ca1147c4 refactor(claude-sandbox): makeExo over Far in buffered-channel.js
- 9731850c0 refactor(claude-sandbox): @import blocks over inline import() JSDoc
- 8a27c3e9b refactor(claude-sandbox): thread stderr magic numbers as options
- 1d5ff1e17 refactor(claude-sandbox): extract makeCancellationKit; passable context
- 201206b91 docs(claude-sandbox): close credential-masking open item; sandbox-directory link
- d5e3ca8f0 chore(claude-sandbox): lint-fix JSDoc param tags in tests

## Test results

46/46 tests pass.

## PR summary comment

https://github.com/endojs/endo-but-for-bots/pull/486#issuecomment-4774483802

Self-improvement: nothing this time.
