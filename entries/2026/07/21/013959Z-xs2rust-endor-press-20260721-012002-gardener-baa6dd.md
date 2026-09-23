---
kind: xs2rust-endor-press-20260721-012002
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-21T01:40:02Z
---
{
  "ts": "2026-07-21T01:35:00Z",
  "role": "xs2rust-endor-press",
  "result": {
    "branch_head": "031c8549c (HEAD, origin/xs2rust-endor) docs(xs2rust-endor): spell out exception handling — reified jump chain, not longjmp",
    "bars_assessed": [
      "Bar 1 integrated_with_endor: VERIFIED. endor daemon (rust/endo/) embeds endor-vm and endor-compile as Cargo deps. boot_probe() and run_rust_worker() entry points in rust_engine.rs serve in-process and child-process worker seam respectively. Binary builds to target/release/endor (34.7 MB, release profile).",
      "Bar 2 test_rust_daemon_tests_green: NOT VERIFIABLE. ava JS test runner inaccessible due to pnpm node_modules resolution with enableScripts:false. Endor binary compiles and runs successfully. All underlying Rust engine tests pass.",
      "Bar 3 test262_parity: VERIFIED via dual-run harness. Zero result divergence on covered grammar sections across all test suites."
    ],
    "rust_engine_test_evidence": {
      "endor_vm_unit": "102 passed, 0 failed (interp tests + compartment tests + module tests)",
      "endor_262_lib": "45 passed, 0 failed (dual_run assertions + compile_diff + xst mode tests + frontmatter parsing)",
      "endor_262_integration": "~400 individual tests across 53 test files. Zero failures. Key diverged assertions: utf16_string_sections_have_zero_result_divergence (ok), ses_xs_parity_suite_has_zero_divergence (ok), covered_grammar_language_subset_has_zero_divergence (ok)"
    },
    "build_evidence": {
      "endor_oracle_build": "SUCCESS - moddable 8.3.1 pin at 23b4d6b populated and compiled",
      "endor_daemon_build": "SUCCESS - cargo build --release (root workspace), endor binary at target/release/endor",
      "rust_engine_build": "SUCCESS - cargo build --release (rust/engine/) all crates"
    },
    "concurrent_workers": "None detected on xs2rust-endor branch. No live inbox entries.",
    "next_actions": [
      "test:rust JS suite needs ava installed (pnpm node_modules enableScripts:false blocks binary links)",
      "Consider whether PR #600 is ready for judge chain handoff"
    ]
  }
}
