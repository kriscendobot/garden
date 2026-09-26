`ci-wait-merge` returned rc 0 (CI GREEN, 26 checks, 0 failed). The clean stage is complete.

## Completion report

**Stage:** CLEAN — endojs/endo-but-for-bots PR #970 (gauntlet `ironhorse-js-26-ca-regexp-properties-gauntlet`, iteration 0)

**What I did:**
- Confirmed the increment's scope: the regexp-properties work is commits `d019bf86da` (implement RegExp Unicode properties) and `7c472dee6a` (vendor Unicode property tables), touching `ironhorse-regexp/{compile.rs, lib.rs, unicode_property.rs, unicode_properties_generated.rs}`, `ironhorse-regexp/tests/parity.rs`, and `ironhorse-262/tests/regexp_properties.rs`.
- **Dead-code check:** the transient `build.rs` added by the first commit was already removed by the vendoring commit in favor of the checked-in `unicode_properties_generated.rs` table — nothing orphaned. The 6296-line generated table is live (consumed by `unicode_property.rs`/`compile.rs`).
- **Clippy:** ran `cargo clippy -p ironhorse-regexp`. The 2 `compile.rs` warnings (`manual_is_ascii_check` @832, `redundant_pattern_matching` @1168) and 2 `matcher.rs` warnings all trace via `git blame` to commit `f6691b304df` (2026-08-06), which predates this increment — pre-existing, out of scope, and non-gating (CI `test-ironhorse` passed).
- **Coverage:** ran the touched-package suites — `ironhorse-regexp` 27 lib unit tests + 2 parity tests pass; `ironhorse-262 --test regexp_properties` 3 integration tests pass (parse-time syntax errors, property families/aliases, negation/astral/ignore-case in u and v modes). Coverage is adequate for the new surface; no gaps required new tests. (Initialized the `c/moddable` submodule so the xs-oracle dev-dep needed by the parity target could build.)
- **No source changes** were required, so no follow-up commit/push to the PR head.
- **CI:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh endojs/endo-but-for-bots 970 --no-merge` → rc 0, "CI GREEN" across all 26 checks, 0 failed.

**Changed:** nothing (no commits pushed; the PR head is unchanged and green).

**Follow-ups:** none for this stage. The pre-existing clippy warnings in `compile.rs`/`matcher.rs` from `f6691b304df` are a candidate cleanup for a future increment but are non-blocking and out of this gauntlet's scope.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-properties-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (1437388 cached reads)
- Output: 10298 tokens
- Cost: $1.5159870000000002
- Wall-clock: 1162s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
