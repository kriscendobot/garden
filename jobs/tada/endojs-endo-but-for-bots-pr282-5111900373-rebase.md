Rebased endojs/endo-but-for-bots PR #282 onto current `llm` (`bfc91f55802c0b2fb63257b86762bf0dd5645c64`) and force-pushed with lease from `0696e94ed5a402ab0cf8a74b5ddebe453af533c5` to `1b42c06753cec661b13ad8e3e30bfb4b6a6639f8`.

Resolved conflicts by preserving both sides: kept current `llm` registry-proxy/`endor run` surfaces while replaying the PR’s entry-point classifier, CAS ingestion, and Phase 5 local `node_modules` dependency walk; kept both design-index updates; added `entry_walk` alongside the newer registry/assemble modules.

Verification: `git diff --check` passed. `cargo test --manifest-path rust/endo/Cargo.toml --lib run_input` could not complete because `xsnap` requires generated `ses_boot.js`, `worker_bootstrap.js`, and `daemon_bootstrap.js`; initializing `c/moddable` fixed the SDK precondition, but generating the JS bundles failed due unresolved internal `@endo/*` modules in the worktree. I posted the required PR summary comment with these details: https://github.com/endojs/endo-but-for-bots/pull/282#issuecomment-5114429071

Follow-up: shepherd/conduct remain separate from this rebase job; PR state after push is `UNSTABLE`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr282-5111900373-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 617s

<!-- garden-usage-end -->
