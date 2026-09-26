Done. Garden worktree is clean (all work was in the external darkwow clone + host env setup, nothing belongs on `main2`), and I did not close the issue (per issue-inbox discipline — the submitter closes it).

## Completion report

**Job:** kriskowal/garden#40 (from dckc) — clone `codeberg.org/PatrickM123/darkwow` @ `0ac13a3` and get a node running, nix-flake-preferred else docker.

**What I did**
- Cloned the repo at the requested commit and assessed all three run paths. Replied on the issue with a full reproducible write-up ([comment](https://github.com/kriskowal/garden/issues/40#issuecomment-4950187346)).
- **Nix flake — not viable:** `contrib/flake.nix` is the inherited upstream DarkFi flake (builds `drk`/`darkfid`/`ircd`, no `dwowd` target, deprecated `crane.lib` API). Would need a rewrite.
- **Docker — not viable:** no pullable image; local build blocked by the same contract bugs; and the devnet entrypoint generates a `dwow-devnet` config section while the binary requires `darkwow-devnet` (name mismatch → config not found).
- **Native build — succeeded**, after fixing 5 blockers not in the README: missing `libsqlite3-dev`; cargo git-over-SSH auth failure (fixed with `CARGO_NET_GIT_FETCH_WITH_CLI`); a contract-Makefile `PKGNAME` bug in stablecoin/insurance_market (`grep` matched a `[[bin]]` name line); stale committed `.source_hash` guards that `exit 1`; and missing genesis-contract `.wasm` blobs that `dwowd` `include_bytes!`es (built + placed 9 of them). Produced a working `./dwowd 0.5.0`.
- **Ran it:** wrote a minimal single-node devnet `dwowd_config.toml` + `keys.toml` and launched with `NODE_NAME/CREATE_GENESIS/MINING_ENABLED`. The node boots fully — initializes all 9 genesis contracts, builds ZK verifying keys, builds the coinbase, passes `pow_reward_v1` exec — then **panics at genesis block-1 `apply()`** (`panic_bounds_check` in `dwow_native_token_contract.wasm` `__update`) and aborts. This is a deterministic upstream defect in the coinbase-apply path (freshly rewritten by commit `7b46f39b5`), internal to the native_token contract.

**Outcome:** Builds cleanly and boots through full genesis-contract init, but a single-node `create_genesis` devnet cannot accept block 1 at `0ac13a3`. Reported this to dckc with the exact error, the reproducible recipe, and an offer to finish once the apply path is fixed or a known-good commit is provided.

**Follow-ups (owner's to act on):** fix the native_token coinbase `apply` panic; add `libsqlite3-dev` to build deps; fix the two contract Makefiles' `grep -m1` and the docker `NETWORK_NAME` mismatch; either rewrite or drop the stale nix flake. No garden-repo changes were needed; nothing committed to `main2`.
