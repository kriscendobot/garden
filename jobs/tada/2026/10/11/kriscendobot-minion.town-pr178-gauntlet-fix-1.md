Fix round 1 for kriscendobot/minion.town PR #178 is pushed and CI is green. `ci-wait-merge.sh --no-merge` returned 0, and all three checks passed (test, Claude harness amd64 and arm64).

**Pushed to `git-remote-push-caps` with `safe-push-pr-head.sh`** (a3bc700 → b47181d):

- **`9ea87be` fix(git-remote): reserve a declared push's length and split large refusals**
  - **Must-fix, corner-prober (one push starving another):** a push that declares its size and isn't gzipped now reserves at most that size. Before, it reserved `min(maxPushBytes, room)`, so a second push arriving while the first ran got a false "partition is full". A push with no declared size still reserves the most it may write; that behaviour is now documented and covered by a test. Every reservation is at least one byte, because git treats `receive.maxInputSize=0` as "no limit".
  - **Oversized refusal (corner-prober, warden, wire-watcher):** a refusal sent over side-band is now split into packets of at most 1000 bytes. Before, a push naming many refs got one packet past git's size limit, which the client could not read. `packetLine` now throws past 65516 bytes, and a ref too long to fit falls back to the plain HTTP refusal. The plain `side-band` capability is now recognised alongside `side-band-64k`.
  - **Must-fix, archivist:** the doc comments for `directorySize` and `readHead` now say they return a Promise, and `refusePushWithHead`'s fallback is spelled out. Comments now cite the git settings `receive.maxInputSize` and `receive.unpackLimit`, and say where a reservation is released.
  - **Tests:**
    - overlapping pushes: a declared push lets a second push in, and a push with no declared size holds the room until it is aborted, then gives it back;
    - refusal splitting, the packet size limit, and the plain side-band capability;
    - the config test now uses a named list of cap variables instead of `slice(6)`.
  - Without the reservation change, the new overlapping-push test fails.
- **`b47181d` docs(git-remote): rollout notes for the push caps**
  - DEPLOYMENT.md now says the default caps change behaviour for existing users, and gives a size survey to run on existing partitions before deploying and a rollback setting.
  - The stale "env table" pointer is gone, and the push-bytes cap is described as bounding the pack after HTTP decoding, not "after inflation".
  - The `…` placeholders in the design doc are replaced with named ones.

**Not applied:**
- **procurer:** the suggested `@endo/cbor` `readHead` is a different function. It parses a CBOR header; ours reads the first bytes of an HTTP body, so there is nothing to reuse.
- **Left for a follow-up** (all should-fix or comment-only, none blocking):
  - the small-request exemption from the rate limit trusts the client's declared size;
  - a push could still land just before the over-limit kill while the client is told it was refused;
  - a gzipped command list could expand without a bound;
  - the full directory walk on every push request has no cache.

I posted a comment on the PR saying what was fixed and what wasn't: https://github.com/kriscendobot/minion.town/pull/178#issuecomment-6107195752

**Running tests on this host:** typecheck is clean and all 97 git-remote tests pass, but only with `/usr/bin` first on `PATH`. The fleet's `git` wrapper takes a lock per repository, so it holds a second concurrent `http-backend` on the same repo. Under it, the new concurrency test hangs, and one existing test in `capability.test.ts` fails as well. Nothing changes in CI, which uses plain git.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4604125 cached reads)
- Output: 26892 tokens
- Cost: $2.5174490000000005
- Wall-clock: 1130s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
