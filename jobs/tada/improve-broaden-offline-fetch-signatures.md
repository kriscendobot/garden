Empty inbox. Work is complete and pushed.

---

## Completion report

**Job:** `improve-broaden-offline-fetch-signatures` — broaden the transient-outage classifier so a self-resolving network blip classifies as `EX_TEMPFAIL` (75) fleet-wide instead of dying in `sync_clone`.

**What I found.** Since the job was written, `origin/main2` had already evolved past the "4 string-literal `case`" form described in the spec: commit `5fc801e85` factored the four signatures into a single shared `GARDEN_OFFLINE_SIGNATURES` regex consumed via `grep -qE` by both `_fetch_stderr_is_offline()` (common.sh) and the belt-and-suspenders fallback in `self-heal-run.sh`. So the task became *broaden that shared regex* rather than convert a `case`. I built off `origin/main2` in an isolated worktree (per the shared-tree-mutation guidance), not the stale local `main2`.

**What changed** (commit `0c8b861c8`, pushed fast-forward to `main2`):
- **`scripts/jobs/common.sh`** — broadened `GARDEN_OFFLINE_SIGNATURES` from the 4 DNS/SSH literals to the full transient surface: `Could not resolve host` (covers both git-over-HTTPS `Could not resolve host:` and SSH `Could not resolve hostname`), `Operation timed out`, `Connection reset by peer`, `Recv failure`, `Early EOF`, `unexpected disconnect`, `RPC failed`, `HTTP 5[0-9][0-9]`, `The requested URL returned error: 5`, `gnutls_handshake`, `SSL`, `TLS`. Switched the classifier grep to `-qiE` (case-insensitive). Documented the full set with a comment block.
- **`scripts/jobs/self-heal-run.sh`** — matched the fallback grep to `-qiE` so the two consumers of the shared regex stay consistent (case-insensitive on both paths).
- **`scripts/jobs/test/run-test.sh`** — added **SUBTEST 23**: sources `common.sh` in an isolated subshell and feeds 17 transient signature strings (each must classify offline, including two case-flipped ones) plus 4 genuine repo errors (`bad object`, non-fast-forward, missing ref, merge conflict — each must *not* classify, proving real failures still fall through to `die`). Per-case tallies reconcile into the harness `PASS`/`FAIL` totals.

**Verification.** Standalone run of all 21 cases: pass=21 fail=0. SUBTEST 23 executed under harness scaffolding: 21 PASS, 0 FAIL, totals reconcile. `bash -n` clean on all three files.

**Follow-ups / notes.**
- The local `/home/kris` `main2` working tree is behind `origin/main2` (sits at `2e3372fbe`); my change is on the remote. No action needed for this job, but anyone working the shared tree should fetch.
- `SSL`/`TLS` are matched case-insensitively, so `gnutls` self-matches on `tls` — intended (still a transient classification). These short tokens are broad by design per the spec; they're unlikely to appear in a genuine non-TLS git fetch error.
