---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---

# Open the draft PR for the Ironhorse store-chain-walk fix (endojs/endo-but-for-bots)

Handoff from job `ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9`, which did the fix but
could not open the PR: on host oros-studio-garden-ce242c49 the bot PAT gets 403 on
createPullRequest. The head branch `fix/ironhorse-store-chain-walk-bound` (commit
a61dffa38) is pushed to endojs/endo-but-for-bots, based on the existing frozen base
`llm-54d3d2a` (54d3d2a68). Do no code work. Your only task is to open the DRAFT PR,
idempotently, with cwd = a project worktree from ensure-project-worktree.sh:

    ensure-pr.sh ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9 endojs/endo-but-for-bots \
      fix/ironhorse-store-chain-walk-bound llm-54d3d2a \
      --title "fix(ironhorse-vm): bound the store-chain walk in bounded runs" \
      --body-file <the body below, written to a file>

Use the ORIGINAL job base (`ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9`) as the
ensure-pr.sh base, so the PR's garden-job marker names the job that produced the fix.
Leave the PR draft; the gauntlet stages itself from the draft PR. Report the PR URL.

PR body (everything between the markers, exclusive):

----- PR BODY -----
## Description

The `bytecode_decoder` fuzz target (CI `fuzz-ironhorse` tripwire, [run 39727404537](https://github.com/endojs/endo-but-for-bots/actions/runs/39727404537/job/119654508355)) reported a libFuzzer timeout: one unit ran for 1777 s against the 1200 s limit. The cause is a real quadratic path in the interpreter, not a harness artifact.

`store` (and `store_arrow`) append a capture to an environment's property chain by walking the chain from its head to the tail. XS's `XS_CODE_STORE` does the same (`xsRun.c`). With compiled bytecode the walk is short, because each capture is stored once into a fresh closure environment. The 198-byte reproducer (`timeout-1015c4e9cf8a361f98c929653d2023bb8cb70515`) is a catch loop. `delete_super_at` throws back into a run of `get_this`, and each round then does 24 `store_1` into `this`, the global object. That one chain grows by about 24 slots per round, and every store walks the whole chain. Before this change, 10,000 dispatches took 21 ms, 100,000 took 1.86 s, and 1,000,000 had not finished after 120 s. The harness's 2M-dispatch ceiling therefore did not bound wall time.

The fix applies under `run_bounded` only, the same scope as the existing `BOUNDED_RUN_SLOT_CEILING` live-slot guard. A store whose tail walk exceeds `BOUNDED_RUN_STORE_CHAIN_CEILING` (4096 links) halts with `Halt::StepLimit`; `store_arrow` gets the same guard. The reproducer now halts after 12,941 dispatches in under 0.1 s. Files to review: `ironhorse-vm/src/interp/environment.rs` (`store_chain_tail`), `ironhorse-vm/src/interp/dispatch.rs` (`exec_store_arrow`), and the constant in `ironhorse-vm/src/interp.rs`.

### Security Considerations

This shrinks a denial-of-service surface for un-metered bounded callers such as the decoder fuzz harness and the guest-`toString` render. It does not add a check on what `store` targets. XS trusts the compiler to leave a closure environment on top of the stack, and ironhorse doesn't check this either, so malformed bytecode can still append closure slots to an ordinary object's chain, as this input does with the global object. A check would need a marker that identifies a closure environment, which `new_environment` doesn't set today (`is_environment_instance` recognizes only `with`/eval environments). That is left as a follow-up.

### Scaling Considerations

Ordinary (unbounded) runs are unchanged. Bounded runs add a counter increment and a compare to each link of the walk.

### Documentation Considerations

None; this is internal interpreter behavior.

### Testing Considerations

The new `ironhorse-vm/tests/finding_1015c4e9cf8a361f_store_chain_walk.rs` pins the full input. The bounded run must halt with `StepLimit` far below the dispatch ceiling, and a 10,000-dispatch run, whose chains are still short, must still stop exactly at the dispatch limit. Without the fix the first test hangs; it was killed after 90 s. `cargo test --release -p ironhorse-vm` and `-p ironhorse-snapshot` pass, and fmt and clippy (1.88.0, `-D warnings`) are clean. The `ironhorse-fuzz` tests were not run locally, because they need the `c/moddable` oracle submodule; CI runs them.

### Compatibility Considerations

Ordinary runs keep XS's walk, so execution and metering stay the same as XS. Only bounded runs on malformed bytecode can now halt sooner.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T10:26:10Z
