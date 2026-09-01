from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-31T03:44:22Z
doom_base: ironhorse-fuzz-fad9672dc7a6e6be-repair
doom_signature: policy-refusal
notice_count: 1
first_seen: 2026-08-31T03:44:22Z
last_seen: 2026-08-31T03:44:22Z
---
Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
would only repeat the failure and spam the error inbox with an identical capture.
REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-fad9672dc7a6e6be-repair); or, if
the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
Original job base: ironhorse-fuzz-fad9672dc7a6e6be-repair

--- original job body ---
---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix Ironhorse fuzz finding fad9672dc7a6e6be (target `differential_source`) and amend the standing PR

The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
load-bearing regression case AND the causal fix, then amend the ONE standing
pull request for fuzz findings.

## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)

- Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
- Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
- Toolchain: `nightly-2026-08-15`
- Minimized input sha256: `676e2c8aa6e7d449bd966554684840708b84656330fadc8b69bff829ef18c94b` (6 bytes)
- Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/fad9672dc7a6e6be/input.bin`
- Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/fad9672dc7a6e6be.md`
- Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`

## Procedure

1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
2. Recover the minimized input to a FILE without inlining it into any prompt:
   decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
   durable artifact path above. Verify `sha256sum` equals `676e2c8aa6e7d449bd966554684840708b84656330fadc8b69bff829ef18c94b`.
3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
   see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
   before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.

4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
   so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
   that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
5. Fix the causal defect. Keep the fix minimal and targeted.
6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
   `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
   PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
   and run its required gauntlet.
7. Document THIS case and its solution in the standing PR body or a PR comment (finding fad9672dc7a6e6be).
8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
   comment, and record the unsolved finding visibly in the PR — never let it disappear.
