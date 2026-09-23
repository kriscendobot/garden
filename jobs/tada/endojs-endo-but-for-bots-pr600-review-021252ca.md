Addressed PR #600 review: renamed the Rust daemon binary from `endot` to `endor` in `288140fed`, reserving `endot` for a future test262 binary. Posted inline reply and PR summary.

Verification: `cargo test -p endo --bin endor` passed; `./target/debug/endor --help` exited 0. CI remains queued.

Self-improvement: nothing this time.
