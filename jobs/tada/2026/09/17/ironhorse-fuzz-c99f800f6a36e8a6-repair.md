Job complete. Here's the report.

## Completion report — `ironhorse-fuzz-c99f800f6a36e8a6-repair`

**Finding:** `differential_regexp` reproducer c99f800f6a36e8a6 (20-byte input, sha256 `60759a73…e785335`, toolchain `nightly-2026-08-15`, project SHA `38ca1d18`).

**Diagnosis — not a port bug; the meter 32-bit truncation class.** The input folds through `ironhorse_fuzz::gen_regexp` into `/((a+a*|a+)a*){1,2}((a*|a*)?(?!a*[a-c0-9](a*)?|a*)|0){1,2}(a*|a*|[^a-c]*){1,2}/s` on `"aaaaaaaa"`. The pattern **never matches** — its middle `{1,2}` group requires either a literal `0` (absent) or `(a*|a*)?(?!…|a*)`, whose negative lookahead can never succeed (the `a*` alternative always matches empty, so the negation always fails). I confirmed with Node/V8: `exec` is `null`. The port returns `matched=false`, correct.

The port backtracks **67862** metered steps → raw match meter `67862×65536 = 4447404032`, which is `> u32::MAX`. At the fuzzed SHA the old XS oracle truncated the pin's 64-bit `meterIndex` to a 32-bit field (`4447404032 & 0xFFFFFFFF = 152436736`), a phantom divergence. Same root cause as `5d122a6fc10babd9`/`8275793bca439f6e`/`407764ab1120ed1a`/`8b8afc47fcfb223d`, fixed oracle-side by `c8497fd8` (meter fields → u64), already on the standing branch and merged to `llm`.

**Verified.** I peer-init'd `c/moddable` (pin 23b4d6b0) from the durable path and built the widened oracle. `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` **exits 0**; a direct probe shows port and pin agree **bit-for-bit** on `matched`, every capture (`[(-1,-1),(8,-1),(8,-1),(-1,-1)×4]` — both engines leave the last failed attempt's partial state, irrelevant to the `null` result), and the full-width meter `4447404032` (delta 0).

**What changed.** Added submodule-free `ironhorse-vm` regression `rust/engine/ironhorse-vm/tests/finding_c99f800f6a36e8a6_regexp_meter_overflow.rs`, pinning the port's full-width meter, `matched=false`, and the exact capture offsets (guards against any future silent 32-bit narrowing). Test passes; no engine code change. Committed, rebased onto the current standing tip, CAS-pushed to `kriscendobot:ironhorse-fuzz-findings` (`959072767d..d417fc65b5`).

**PR.** The standing PR **already exists** — endojs/endo-but-for-bots#1298 (head `ironhorse-fuzz-findings`, base frozen `llm-387ea66`, draft). My commit is its head; documented the finding in [a PR comment](https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5706770402).

**Follow-ups (maintainer-facing, not blocking this job):**
- The PR is a draft; the gauntlet is a maintainer trigger under the manual-gauntlet regime (`run the gauntlet #1298`), not auto-staged for a single submodule-free regression lock.
- Journal `ironhorse-fuzz/standing.md` still reads `generation: 2` / branch `ironhorse-fuzz-findings-2`, but live work (and #1298) is on gen-1 `ironhorse-fuzz-findings` — the generation record is stale.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-c99f800f6a36e8a6-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (4 unmetered)
- Input: 104 tokens (4448357 cached reads)
- Output: 37437 tokens
- Cost: $4.3762115 (4 engagement(s) unpriced)
- Wall-clock: 1948s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
