Run the gauntlet on https://github.com/endojs/endo-but-for-bots/pull/821 (base llm): clean -> panel review -> fix-loop -> un-draft.

The PR is a one-hunk fix carrying the entry rejection message in the archive error value (rust/endo/xsnap/src/archive.rs), fixing the deterministic red unit test cjs_require_missing_module_is_clean_error merged to llm with #818.

Note: repo CI does not compile rust/endo, so the fix-loop must run `cargo test --release -p endo --lib -- --test-threads=1` (and `-p xsnap --lib`) locally for any change it makes; generated xsnap bundles (ses_boot.js, worker_bootstrap.js, daemon_bootstrap.js) are not in-tree and can be copied from a sibling npm-cas press project worktree under /home/kris/garden/scratch (see rust/endo/README.md section Building). Building also needs `git submodule update --init c/moddable`.
