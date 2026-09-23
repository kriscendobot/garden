Done. Committed `ba38a1372` to `origin/main2`; full test suite green (171/0); worktree torn down; inbox empty.

---

**Completion report — improve-sync-clone-transient-fetch-classification**

Landed on `origin/main2` as commit `ba38a1372`, built in an isolated worktree off `origin/main2` (per garden infra convention) and verified to have landed before teardown.

**What the job asked vs. what I found.** Two of the three requested changes were *already present* on `origin/main2` (the git state had advanced past the snapshot the job spec was written against):

- **(2) Broadened `_fetch_stderr_is_offline`** — already done. `common.sh` now carries a canonical `GARDEN_OFFLINE_SIGNATURES` regex covering the full transient surface (DNS, remote-hung-up, early EOF, RPC failed, unexpected disconnect, connection reset, unable to access, failed to connect, operation/connection timed out, TLS/SSL/gnutls), matched case-insensitively via `grep -qiE`.
- **(3) De-duplicated classifier** — already done, and arguably better than the spec: `self-heal-run.sh` sources `common.sh` and greps the same shared `GARDEN_OFFLINE_SIGNATURES` variable (rather than calling the function, which doesn't suit grepping a multi-line capture tail). Single source of truth achieved — wrapper and library cannot drift.

**What I actually changed:**

- **(1) `sync_clone` (common.sh):** dropped the hard `rc==128` gate and added the `rc==124` timeout case. A `journal_fetch` timeout (`rc==124`) and *any* rc whose captured stderr matches an outage signature now `exit "$GARDEN_OFFLINE_RC"` instead of `die`. Outages surface under several exit codes, not just 128, so the gate is now on the signature, not the code. The reset-path offline guard below it was already signature-only, so the two are now consistent.
- **Test (run-test.sh):** added **SUBTEST 24** driving `sync_clone` directly with an injected `GARDEN_FETCH_CMD` returning `rc=124`, and `rc=128` with "the remote end hung up unexpectedly" stderr — asserting both exit `GARDEN_OFFLINE_RC` (75), plus an end-to-end check that the self-heal wrapper normalizes that rc to a clean exit 0 with no responder.
- **Bonus fix:** corrected a pre-existing stale grep in **SUBTEST 22** (it expected `'offline; skipping claim tick'`, but `gardener.sh` logs `claim transiently offline (rc=N); sleeping and retrying`). This was already failing on `origin/main2` independent of my change; fixed it to keep the suite green per the standing proactive-fix directive.

**Verification:** `fetch-timeout-test.sh` → 10/10 pass. `run-test.sh` → **171 passed, 0 failed** (was 170/1 before the SUBTEST 22 string fix).

**Follow-ups:** none required. Note for the record: the job spec's item (3) description ("self-heal carries a narrower copy missing 'Connection timed out'") was stale — that divergence had already been resolved upstream before I claimed the job.
