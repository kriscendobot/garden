Empty inbox. Work is complete.

## Completion report

**Job:** improve-mention-reactji-failure-diagnostics

**What changed:** `scripts/jobs/handlers/mention-reactji-gh.sh` — the reactji POST at the (former) line 44.

**The problem:** The POST was invoked as `gh_api_retry ... >/dev/null 2>&1`. The `2>&1` sent `gh_api_retry`'s diagnostic WARN (rc, gh's stderr response, and its definitive-vs-transient verdict — all emitted via `log` to stderr) to `/dev/null`. The only surviving trace was the handler's terse info-level `reactji POST failed on $path`, which sits below WARN and is filtered out of the mentor's `journalctl -p warning` tail. So a failure like `WARN: reactji failed on issue-comment/4833847468` (that WARN comes from the *watcher's* continue-on-failure line) reached the mentor with **no cause**, making recurring-vs-benign undiagnosable.

**The fix:**
- Keep `>/dev/null` (still discard the success payload) but **capture** `gh_api_retry`'s stderr instead of dropping it, via `reason="$(gh_api_retry ... 2>&1 >/dev/null)" || rc=$?` (the `|| rc=$?` reads the rc without tripping `set -e`).
- On failure, emit a **`WARN:`** carrying `rc` and the captured reason (rc + gh's response), so the cause reaches the journal at warning level.
- Classify a **definitive 404** (deleted/absent comment or issue — a benign ack race) as a **silent skip** (`exit 0`, `<6>` info log) rather than an error, so a deleted-comment race stops masquerading as a WARN and a real **403/permission** failure stands out. `gh_api_retry` has already ridden out any transient blip under backoff before this point, so a surviving 404 is truly definitive.
- Updated the header block comment to reflect the 404 exception.

**Unchanged (as required):** The watcher's continue-on-failure behavior — the ack stays non-fatal to job posting. The handler's exit code still drives `mention-watcher.sh:322-323`; a real failure exits 1 (watcher logs and continues), and the benign 404 now exits 0 (no watcher WARN at all).

**Verification:** Syntax-checked (`bash -n`); shellcheck clean apart from two pre-existing informational items. Drove all three paths with `gh` stubs via the `GARDEN_GH` seam: success → `<6>` "reacted" exit 0; 404 → `<6>` silent-skip exit 0; 403 → `<4>` WARN carrying rc + `HTTP 403` reason, exit 1.

**Note:** My initial edit accidentally landed in the deployed garden root; I moved it into the job worktree, restored the deployed root to clean, and committed/pushed only from the worktree.

**Committed & pushed:** `7b7d7d6de` on `origin/main2` (clean CAS push, first attempt).

**Follow-ups:** None. (Minor cosmetic: the handler's WARN embeds `gh_api_retry`'s own already-prefixed WARN line, so the reason text contains a nested `<4>…`; the content is fully diagnosable and journald keys only off the line-start prefix, so I left it rather than over-engineer stripping.)
