# Gauntlet fix round 5: endojs/endo-but-for-bots PR #1380

I applied the round-5 panel's must-fix items and pushed five follow-up commits. The PR head moved from `0d244a84d2` to `2fb39bc218`. CI is green: `ci-wait-merge` exited 0 with all 35 checks passed and none failed. The PR is still a draft.

## Must-fix items

- **Integrator (the PR is a probe and must stay draft):** it is still a draft, and I did not un-draft it. This stage's fix commits add to the fix-loop history the integrator objected to. Only the probe/gauntlet mismatch that the integrator flagged can clear its finding; no code change here does.
- **Breaker (13 read callbacks never reached the transcript):** `readFileText`, `readFile`, `maybeReadFile`, `readDir`, `exists`, `isDir`, `readLink`, `stat`, `getPid`, `getEnv`, `realPath` and `loadModuleSource` now go through a new `host_ledger::answer` helper. It records the value the guest saw as the call's reply.
- **Prover (no test for recorded randomness):** a new test, `replay_answers_recorded_reads_with_the_values_the_guest_saw`, changes the files after the crank. It then checks that replay answers these calls with the recorded values: `randomHex256`, `ed25519Keygen`, `readFileText`, `readDir`, `exists` and `getEnv`.
- **Locksmith and warden (private keys and random bytes stored in plaintext):** the transcript file and the snapshot files it stores are now created readable only by their owner (mode `0600`), and opening an existing transcript tightens it the same way. A new test covers this. The design doc and PR body now say the file is a plaintext record of the worker's secrets and ambient `root` paths. They also say why it is not encrypted: replay needs the actual bytes.
- **Stylist (abbreviated names):** `rec` is now `record`. I also did the should-fix sweep in `sqlite.rs`: `stmt_handle`, `db_handle` and `execute_stmt` are spelled out.
- **Benchmarker (unmeasured cost claims in the PR body):** "(unmeasured)" is replaced with a reason for not measuring yet. No daemon path attaches a transcript, so the benchmark belongs with the supervisor-attach follow-up. The hasher restaging cost now has an explicit "no further optimization" line, bounded by the size limits below.

## Should-fix items also done

- **Engine-realist and saboteur (memory can grow without limit through many open hashers):** a new 16 MiB limit covers the bytes all of a worker's open hashers keep between them, alongside the existing 1 MiB per hasher. A hasher past either limit comes back broken after a resume.
- **Breaker (failed abort not latched):** a crank that fails to abort now blocks every later crank, as a failed commit already did.
- **Migrator (unchecked `"Error: "` results in JS):** the XS crypto powers in `bus-manager-rust-xs-powers.js` now throw a transcript refusal instead of passing it on as a handle, key or nonce. `@endo/daemon` is private, so no changeset is needed.

## Checks run locally

- `slot-machine-transcript`: all tests pass, including the crash matrix.
- `xsnap` lib tests, one thread at a time: 143 pass. I skipped 12 tests that need the generated SES/bootstrap bundles, which I replaced with empty files locally. Run in parallel, the suite crashes with a segfault; CI only type-checks `xsnap`, so this is not a CI gate.
- The `xsnap` crate was not rustfmt-clean before my change. I kept my diff free of unrelated reformatting.

## Follow-ups

- **Should-fix items not done:**
  - no hasher test across suspend and resume past the size limit;
  - no test for a crank that stages no outbound frames;
  - no `proptest` round-trip test for the CAS store;
  - no statement context in the SQLite params-parse error.
- **Local build setup:** to build, I initialized the `c/moddable` submodule in the project checkout.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 170 tokens (13392223 cached reads)
- Output: 51431 tokens
- Cost: $5.357384599999998
- Wall-clock: 3996s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
