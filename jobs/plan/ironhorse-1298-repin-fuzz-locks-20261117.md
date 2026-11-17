---
gate: go-ahead
priority: normal
role: fixer
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-17T08:53:56Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-17T08:53:56Z
---

---
posted_at: 2026-11-17T07:05:11Z
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Ironhorse #1298: re-pin byte-pinned fuzz locks after the llm merge (F040 re-fold)

Repo endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1298 (head kriscendobot/endo-but-for-bots `ironhorse-fuzz-findings`, base frozen `llm-387ea66`; keep the base). Successor of job ironhorse-ci2-refresh-1298-1534-20261117, which merged current llm into the head (commit 761ab312fc; conflicts resolved, `cargo build -p xs-oracle -p ironhorse-262 -p ironhorse-fuzz --tests` is clean).

Remaining red, locally reproducible with `cd rust/engine && RUST_MIN_STACK=33554432 cargo test --locked -p xs-oracle -p ironhorse-fuzz --no-fail-fast` (needs the c/moddable submodule; init from a peer project worktree with `git -c protocol.file.allow=always -c submodule."c/moddable".url=<peer>/c/moddable submodule update --init c/moddable`): 51 failures, all one cause. llm's a47e9acf1b (architecture finding F040, finite generator cursor) re-folds every recorded fuzz input, so the PR's regression locks that pin raw input BYTES now generate different programs (for example finding_05264cccae42245a's bytes now yield a program whose oracle result is 2048). llm's own convention since F040: the PROGRAM text is the lock, not the bytes (see `finding_5c29667cc15d6d93_large_integer_dtoa_agrees` in ironhorse-fuzz/src/lib.rs).

Failing groups: 16 `tests::finding_*` in ironhorse-fuzz/src/lib.rs, 23 `regexp::tests::finding_*` in src/regexp.rs, 8 `exact_regexp_source_input_agrees_with_xs` plus 1 `exact_regexp_tostring_input_agrees_with_xs`, and the 3 consistency tests in ironhorse-fuzz/tests/vm_finding_fixtures.rs (program, regexp-case, and bytecode fixtures under ironhorse-vm/tests/fixtures are regenerated from `finding-<id>.input.bin` through the generator of the day).

Task: recover each lock's program (or regexp case) as the PRE-merge generator folded it: build the pre-merge head 168f38e5e4 in a scratch checkout and print gen_program, gen_regexp, or gen_stage3b_regexp_program for each pinned input. Then restate each test to pin that program text, the way llm did. For the fixtures, make the checked-in program, regexp-case, and bytecode artifacts the lock: for example, check the bytecode against XS compiling the recorded program rather than re-folding the input. Don't bless them to new programs, because that would silently drop the findings. Run the CI-equivalent `cargo test --locked -p ironhorse-compile -p ironhorse-regexp -p ironhorse-262 -p ironhorse-fuzz --features ironhorse-compile/parity,ironhorse-regexp/parity` (ci.yml ~line 1170) locally, then push to the head. Don't merge. The oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055) stay red until #1613 reaches the base, so leave them alone.
