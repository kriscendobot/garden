Gauntlet clean stage for kriscendobot/minion.town PR #119: I added edge-case tests, pushed them to the PR head, and CI is green on the new head `88d208e`.

**What I did**
- **Idempotence check.** The PR is an open draft, head `dbfb22c`, based on `main-561472a`. CI was green, but no coverage pass had been done: the PR had only one commit, so this was not a no-op.
- **Coverage pass.** I ran it in an isolated checkout of `feat/claude-agent-credential-reauth`, with the full vitest suite under v8 coverage. The package doesn't include a coverage provider, so I installed one outside the checkout and linked it in for the run only; nothing about it was committed. I then compared the uncovered lines against the lines the PR adds.
  - The new logic was already mostly covered: `reauth.ts` about 97%, `classify.ts` about 96%, `wiring.ts` about 93%.
  - The uncovered added lines were edge cases, and the new tests below cover them.
- **Dead code.** I found none left behind by this change. The only `--noUnusedLocals` hit in the touched files is the unused `McpServer` import in `src/http.ts`, which was already there on the base branch, so I didn't touch it.

**What changed:** one commit, `88d208e`, on the PR head. It only touches `test/claude-reauth.test.ts`, adding 6 tests (19 → 25 in that file):
- **Provider-response classifier:** a numeric reset time is read correctly; a bare JSON value like `null` or `42`, an unreadable reset time, or an unknown pinned response type all fall back to "unclassified".
- **File-backed reauth state store:** a missing file starts empty; a corrupt file makes it throw instead of silently losing state.
- **Config (`loadClaudeConfig`):** the reauth time limits are read from the environment in hours, and zero, empty or non-numeric values fall back to the defaults; the state-path and webhook settings are read too.
- **No notification channel configured:** delivery never pretends to succeed, and the notice ends in a `reauth-abandoned` alert.
- **Webhook with no secret:** it sends no authorization header.
- **Reconnect listeners:** one listener throwing doesn't stop the others from being called, and unsubscribing works.

Typecheck and the full suite pass locally (504 passed, 7 skipped). I pushed with `safe-push-pr-head.sh` as a fast-forward from `dbfb22c` to `88d208e`.

**CI:** `ci-wait-merge.sh --no-merge` returned 0 (green) after about 3 minutes. All three checks passed on `88d208e`: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

**Follow-ups:** none for this stage. The unused `McpServer` import in `src/http.ts` could be cleaned up separately, since this PR didn't add it.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1294728 cached reads)
- Output: 10456 tokens
- Cost: $1.0307936000000002
- Wall-clock: 388s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
