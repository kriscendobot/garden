Inbox empty. Work is complete and pushed to `main2` (commit `f6e111ee8`).

---

## Completion report

**Job:** comment-watcher must never silently slide past a trusted comment — always reactji-ack + log every slide. Root cause: kriskowal's directive on endo-but-for-bots #405 (2026-06-28) was logged only as "acted on 0; failed=0" — no reactji, no job, no reason — so the maintainer asked "is the watcher working?"

**Branch:** `main2`, commit `f6e111ee8`, built in an isolated worktree off `origin/main2`, explicit-pathspec commit, pushed via fetch+rebase CAS (landed on attempt 1). Bot identity (endolinbot).

### What changed

`scripts/jobs/comment-watcher.sh`:
1. **Always reactji a trusted, in-scope comment** — new `ack_or_log_slide` helper fires a 👀 receipt for any trusted sender on a reactable surface even when no job is minted. The "I saw this" signal no longer depends on actionability. `pr-review-body` (unreactable) and untrusted senders correctly skip the reactji.
2. **Never slide silently** — both previously-silent branches (the `rc==1` not-actionable slide and the `rc==2` reader-`skip` slide) now log the dropping gate plus the comment id/url, so a future drop is diagnosable from the journal.
3. **Trusted no-verb comments route to the claude reader** (`rc 2`) instead of the silent `rc==1` drop, in `classify()` — the deterministic verb gate can't catch every phrasing ("Let's aggregate…", "Remove…", "increase the indent"). Untrusted no-verb comments still drop. Subsumes the old imperative+trusted special case.
4. **Per-tick latency win** — `verify_fetch` fetches the shared VERIFY journal clone at most once per tick (used by the allowlist read, mention-only read, and idempotency pre-checks); the post-confirm passes `fresh` so a lost push is always seen. This addresses the ~40-87s tick that delayed the reactji.

`scripts/jobs/issue-inbox-watcher.sh`: same shared-fetch latency win (`verify_fetch` + `fresh` post-confirm). Audited: it already logs every maintainer-interaction slide and has no claude fallback (every maintainer issue/comment is actioned, never dropped), so the no-silent-slide property already held there — only the latency fix applied.

### Tests
`scripts/jobs/test/comment-watcher-test.sh`: rewrote **G** to pin the new property (trusted non-actionable → no job, but always reactji + logged reason), added **GG** (the #405 phrasing with no "please"/verb routes to the reader, not `rc==1`) and **GH** (an untrusted drop is still logged, not silent). `run_watcher` now denies trust deterministically so the verb-gate cases stay hermetic now that trusted senders route to the reader. **Result: 90 passed, 2 failed.**

### Follow-up (not introduced by this change)
The 2 failures (Q review-9001, Z review-7001 in `comment-source-gh.sh` source-level tests) are **pre-existing** — identical on the baseline (82 passed / 2 failed before my change). Cause: the fleet `bin/gh` identity wrapper that `common.sh` prepends to PATH shadows those tests' on-PATH `gh` stub, so the stub never runs and the handler gets empty real-API output. Worth a separate job to make those source-level tests inject the stub via the `GARDEN_*` handler-override seam (like the rest of the suite) rather than via PATH.
