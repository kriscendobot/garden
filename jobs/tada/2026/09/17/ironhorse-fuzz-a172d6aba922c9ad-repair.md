The work is complete. Final report:

---

**Finding `a172d6aba922c9ad` (`differential_regexp`) — diagnosed as the regexp match-meter 32-bit truncation class; port correct, oracle already fixed; regression-locked and documented.**

**What I did**
- Set up the pinned fuzz environment (peer-init `c/moddable` @ `23b4d6b0` from `.garden-state`, `nightly-2026-08-15`, cargo-fuzz) in an isolated project checkout of `endojs/endo-but-for-bots@ironhorse-fuzz-findings`. Verified the input file's sha256 = `0cb7cc8be…432196f`.
- Reproduced/characterized: the 6-byte input `df 3b 14 29 df 29` folds via `gen_regexp` into a 16-group backreference-heavy nested-alternation pattern (`b+(…\2…\16…)`), no flags, subject `"0 0 0"`@5. It never matches (correct — V8/Node agree `null`), but the port backtracks **119645** metered steps → raw meter `119645×65536 = 7841054720` (> `u32::MAX`). The old 32-bit oracle field wrapped it to `3546087424` (delta = 2³² exactly, `pin == ironhorse & 0xFFFFFFFF`) — a phantom divergence. The port meters into `u64` and was always correct.
- Confirmed the widened-oracle fix `c8497fd8` is already on the standing branch and `llm`: with it, `cargo fuzz run differential_regexp <input> -- -runs=1` **exits 0**, and port/pin agree bit-for-bit on `matched=false`, all captures, and the full-width meter. **No port code change needed** (same disposition as peers `8b8afc47`, `c99f800f`, etc.).

**What changed**
- Added `rust/engine/ironhorse-vm/tests/finding_a172d6aba922c9ad_regexp_meter_overflow.rs` — submodule-free, CI-visible under `cargo test -p ironhorse-vm`; pins `matched=false`, exact capture offsets, and full-width `match_meter_raw = 7841054720`, asserting the meter is never the wrapped `3546087424`. Test passes.
- Rebased onto the peer-advanced tip (`01c3ce66`), committed with explicit pathspec, pushed to `ironhorse-fuzz-findings` (CAS, `01c3ce66→c3646b08`). Standing PR **endojs/endo-but-for-bots#1298** (draft, base frozen `llm-387ea66`) head is now my commit; posted a comment documenting the finding, diagnosis, and disposition.

**Follow-ups / notes**
- I did **not** stage a gauntlet — under the manual-gauntlet-trigger regime that is a maintainer action (`run the gauntlet #1298`); this is an already-fixed truncation-class finding, so only the regression lock + documentation was warranted.
- Persistent inconsistency unchanged: journal `ironhorse-fuzz/standing.md` still says generation 2 / `ironhorse-fuzz-findings-2`, but live work is gen-1 `ironhorse-fuzz-findings` / PR #1298. Not in this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-a172d6aba922c9ad-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 70 tokens (2375639 cached reads)
- Output: 23054 tokens
- Cost: $2.5592425 (4 engagement(s) unpriced)
- Wall-clock: 982s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
