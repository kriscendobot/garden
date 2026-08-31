The job is complete. Here is my completion report.

---

## Completion report — fuzz finding `314f811064b8febb` (`differential_source`)

**Re-derivation (clean-start requeue).** The standing branch `kriscendobot:ironhorse-fuzz-findings` / PR **#1088** already existed with prior findings. This finding was not yet documented and had no regression test.

**Reproduction & diagnosis.** Decoded the minimized input from the journal marker (`ult{-`, 5 bytes, sha256 verified `4f6dc013…`). Built the pinned fuzz env (`nightly-2026-08-15`, `c/moddable@23b4d6b0` peer-init) and ran the target. The bytes fold, via the structure-aware generator, into the division chain:

```js
(377487360 / (377487360 / (377487360 / (-5 / 981467136))))
```

At the fuzzed base `38ca1d18` this panicked with a *result* divergence `oracle="-74098287619080190"` vs `ironhorse="-74098287619080200"`. Both engines compute the **identical** IEEE-754 double (`0xc370740000000000`); they differ only in decimal rendering — XS's `fx_dtoa` prints a non-shortest form, ironhorse prints the ECMA-262 §6.1.6.1.20 shortest round-tripping decimal (V8-conformant). **Same dtoa-spelling class as `d99d263fcf6ca7a7`, reached through division instead of a product.**

**Causal fix — already present.** The `results_agree` value-comparison helper (commit `4ae39593b`, landed for sibling finding `d99d263` *after* the fuzzed base) already suppresses this at head; the crash does **not** reproduce at branch HEAD. No new causal change was warranted.

**Regression locks (commit `554bd7556`, pushed to the standing branch):**
- `ironhorse-fuzz` `finding_314f811064b8febb_large_integer_dtoa_agrees` — replays the exact 5 bytes through the real `differential_check`, asserts no divergence. **Verified genuinely load-bearing**: reverting `results_agree` to a byte comparison makes it fail with the exact reproduced divergence.
- `ironhorse-vm` `finding_314f811064b8febb_large_integer_dtoa` — pins the port's `number_to_ecma_string` for the finding value to `-74098287619080200`; builds without the oracle/submodule and is the CI-run permanent regression (gitignored corpus is not a substitute).

**Verification.** Full `cargo test -p ironhorse-vm` green (106 + per-finding suites). No rustfmt gate in CI; added lines are clean and mirror the sibling tests.

**PR.** Amended #1088 with fetch/rebase/push CAS discipline and documented finding `314f811064b8febb` as a per-finding PR comment (matching the established pattern): https://github.com/endojs/endo-but-for-bots/pull/1088#issuecomment-5473185336

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-314f811064b8febb-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 104 tokens (3572764 cached reads)
- Output: 30867 tokens
- Cost: $3.4296200000000012 (1 engagement(s) unpriced)
- Wall-clock: 847s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
