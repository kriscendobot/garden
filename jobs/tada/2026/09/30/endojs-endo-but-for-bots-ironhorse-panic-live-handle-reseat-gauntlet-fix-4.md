I applied the round-4 panel's must-fix items to PR #1380 and pushed them, but CI didn't finish within the hour deadline (`ci-wait-merge` rc 4). One macOS test cell has failed so far and I couldn't read its log yet, so this fix round is not confirmed green.

**CI on head `0d244a84d2`:** 33 of 35 checks passed.
- `test (22.x, macos-15)` failed after 30 minutes in the "Run yarn test (affected set)" step. The same cell passed on the previous head `343d0143d5`. GitHub won't serve its log until the whole run completes, so I couldn't tell whether it's a flake or caused by this change. The next stage should look at it first.
- `test (24.x, macos-15)` was still pending when I stopped.

The first push failed the `format-ironhorse` rustfmt check on the slot-machine-transcript crate. That's fixed in `0d244a84d2` and the check passes.

**What was fixed**, in four commits (`1995aab22b..0d244a84d2`):
- **Refused deliveries** (breaker, saboteur, wire-watcher): a delivery the transcript won't record no longer disappears with a log line. The worker stops with an error the supervisor can see. After a crank fails to commit, every later crank is refused.
- **One crank per delivery** (saboteur, breaker, prover): any crank left open outside a delivery is committed before the next delivery starts, on both receive paths. Under a transcript, the pump runs each envelope's promise jobs before taking the next envelope.
- **XS abort during a host call** (engine-realist): the ledger and the file map are no longer held borrowed while XS allocates. An abort there now makes the crank abort instead of causing a Rust panic.
- **Unverified resumed heap** (wire-watcher): `resume_from_cas` checks the name's format and that the bytes hash to that name before XS loads them.
- **Unrecorded randomness** (assessor): `randomHex256`, `randomFillBytes` and `ed25519Keygen` now go through the transcript, so a generated key or random value is recorded.
- **Tests** (prover, fast-checker): new tests for per-delivery cranks, refused deliveries, tampered or misnamed heaps, and a round trip of every handle descriptor including the hasher size limit.
- **Names** (stylist): `conn`, `stmt`, `arg_handle` and `directory_arg` are spelled out.
- **PR body** (integrator): added the Documentation and Testing sections and cut the prose to 214 words. The PR stays draft because it's a probe, as the panel required.

I also posted a summary comment on the PR.

**Local testing:** the build and tests ran against the XS sources and three generated JS bundles borrowed from sibling worktrees. The workspace type-checks cleanly, and 153 xsnap unit tests (including the new ones) and all slot-machine-transcript tests pass. One more xsnap test, `archive_text_endowments_provide_codecs`, crashed (segfault) locally. It loads one of the bundles I copied from another worktree, so I think the copy is to blame, but I haven't confirmed that.

**Not done in this round:**
- **Not fixed at all:**
  - The two-envelope scenario isn't tested end to end through the full worker loop. The new test checks crank boundaries one level down.
  - The `WorkerFiles.dir` test-helper rename.
  - Rewriting the history into clean commits and fixing the stacked base.
- **Should-fix items I left and listed in the PR comment:**
  - Routing the process and module-loading reads through the transcript.
  - One shared request encoding across the host callbacks.
  - Checking a re-seated reader's file hasn't changed.
  - The hasher descriptor rewriting its whole input on every crank.
  - Binding the duplicate-frame check to the real sender.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (9240254 cached reads)
- Output: 42872 tokens
- Cost: $3.8554907999999997
- Wall-clock: 6431s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
