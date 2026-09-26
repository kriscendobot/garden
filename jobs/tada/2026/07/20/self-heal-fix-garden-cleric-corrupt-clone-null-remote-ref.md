Cleric 7 has already re-cloned cleanly (`origin/journal2: d4bc27103`, healthy tracking ref) — the wedge is resolved. Inbox empty. All work complete.

---

## Completion report

**Finding: the code work this job specifies was already landed on `origin/main2` and refined beyond the spec.** Commit `7ccfe92e62` ("two-tier corrupt-journal-clone self-heal (cheap repair, then re-clone)") implemented exactly the in-place-repair-then-reclone design this job describes; commits `a31a2`→`4465b` (2026-07-20) then deliberately refined it to the simpler, more robust **atomic reclone-only** design now in `common.sh`. The self-heal for the internally-corrupt journal-mirror-clone case (null-sha `refs/remotes/origin/journal2` + stale `.git/gc.log`, cleric item 7) is fully present:

- `GARDEN_CORRUPT_SIGNATURES` (common.sh:1802) — the single-source-of-truth constant next to `GARDEN_OFFLINE_SIGNATURES`, covering `bad object`, `did not send all necessary objects`, `invalid sha1 pointer`, `bad ref for`, `failed to run repack`, `gc\.log`, etc.
- `_fetch_stderr_is_corrupt` / `_fetch_stderr_corrupt_signature` classifiers.
- `sync_clone` (common.sh:2628-2646): on a non-offline fetch failure matching a corruption signature (or gc.log present), it logs `WARN: <dir> corrupt (<sig>); self-healing by re-cloning`, atomically re-clones under the held `clone_lock` via `ensure_clone`, re-fetches once, logs `REPAIRED:`, and only `die`s if the reclone also fails — bounded to one reclone, no infinite loop. Guardrailed to mirror clones only.
- Tests A–D in run-test.sh SUBTEST 24.

I verified this end-to-end by running the corrupt-clone scenarios standalone against a throwaway bare remote sourcing the real `common.sh` (all pass: real zeroed-ref+gc.log reclone, injected `bad object` reclone, injected `failed to run repack` reclone, always-corrupt dies-loud once). The full suite can't reach SUBTEST 24 in this live-gardener environment — it aborts earlier at SUBTEST 4 (gardener-scaler, which mutates shared fleet state), a pre-existing failure unrelated to this job (I made no code changes to `common.sh`).

**What I changed:** Added SUBTEST 24 case **(B2)** to `scripts/jobs/test/run-test.sh` — an injected `GARDEN_FETCH_CMD` emitting the `failed to run repack` / `.git/gc.log` stderr (the second cleric-item-7 shape, which emits *no* `bad object` line and classifies corrupt *only* via `failed to run repack`/`gc\.log`), asserting `sync_clone` reclones and recovers on its one post-reclone fetch (fetches=2). Case (B) already covered the injected `bad object` path; this closes the letter of the job's test requirement and regression-guards the gc.log/repack half of the signature set. Verified passing standalone; `bash -n` clean. Committed as `897e02ed17` and pushed to `main2`.

**Manual mitigation (done):** Confirmed cleric 7's journal at `.garden-state/clerics/7/journal` was still wedged with the exact reported signature (`bad object refs/remotes/origin/journal2` + `did not send all necessary objects` + `failed to run repack` + stale gc.log). Verified its one local commit (`7c57850328b`) was already an ancestor of `origin/journal2` and its uncommitted `M reputation/...` file is recomputable derived state — no unpushed work lost. `rm -rf`'d the clone; it has since re-cloned cleanly (`origin/journal2: d4bc27103`).

**Follow-ups (optional, not blocking):** SUBTEST 4 (gardener-scaler) aborts the full test run when invoked inside a live gardener, because it calls `set-gardeners.sh`/`gardener-scaler.sh` against shared state — worth making hermetic so the suite runs to completion in-fleet, but out of scope here.
