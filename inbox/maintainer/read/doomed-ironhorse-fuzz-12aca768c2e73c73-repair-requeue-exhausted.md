from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-31T17:25:09Z
doom_base: ironhorse-fuzz-12aca768c2e73c73-repair
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-31T17:25:09Z
last_seen: 2026-08-31T17:25:09Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-fuzz-12aca768c2e73c73-repair) or removes it, so nothing is lost.
Original job base: ironhorse-fuzz-12aca768c2e73c73-repair

--- original job body ---
---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix Ironhorse fuzz finding 12aca768c2e73c73 (target `differential_regexp`) and amend the standing PR

The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
load-bearing regression case AND the causal fix, then amend the ONE standing
pull request for fuzz findings.

## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)

- Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
- Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
- Toolchain: `nightly-2026-08-15`
- Minimized input sha256: `bceeca5a518f6f60608f8c89d24091431806eebe454eacc00d453b8082d9ee5d` (10 bytes)
- Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/12aca768c2e73c73/input.bin`
- Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/12aca768c2e73c73.md`
- Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`

## Procedure

1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
2. Recover the minimized input to a FILE without inlining it into any prompt:
   decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
   durable artifact path above. Verify `sha256sum` equals `bceeca5a518f6f60608f8c89d24091431806eebe454eacc00d453b8082d9ee5d`.
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
7. Document THIS case and its solution in the standing PR body or a PR comment (finding 12aca768c2e73c73).
8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
   comment, and record the unsolved finding visibly in the PR — never let it disappear.
