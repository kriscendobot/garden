---
tier: mentat
dispatch: manual
---
role: builder
handler-timeout: 14339

# Ironhorse test262 compliance ratchet — round 3

Repo: endojs/endo-but-for-bots, base `llm`. The maintainer resumed this on 2026-09-28 in a liaison session on endolin-garden2. Tracker: https://github.com/kriscendobot/garden/issues/51. Round 1 was PR #1087 (merged). Round 2 was https://github.com/endojs/endo-but-for-bots/pull/1113 (merged 2026-09-07).

**Goal:** raise Ironhorse whole-corpus test262 coverage on the pinned corpus. Diagnose and fix failing and aborted clusters, and never lose an already-covered case. Deliver one draft PR on a fresh branch off current `llm`, for example `feat/ironhorse-test262-ratchet-round3`, opened with ensure-pr.sh. Leave it draft; the maintainer will run the gauntlet.

**Floor to defend:** `baseline/refresh-20260904`: 30,233 covered / 0 failures / 13,711 unsupported / 7,414 skipped / 618 infra, at `tc39/test262@be13516fb644`, XS oracle `23b4d6b0a65f`. Keep the pin unless you record a deliberate reason to move it.

**Steps:**
1. Branch-point sweep. `llm` has taken many engine merges since 09-07. Re-sweep the floor at current `llm` before changing anything, and diff against covered.txt. Round 2 found this bug class returns after merges: a native/VM raise that returns `raise_js`'s `Ok(handler_pc)` as a body start, or a bare `Err(Halt::Throw(...))` from a native validation site. Either silently breaks try/catch, and it shows up as `ironhorse-aborted` or as a silent demotion, not as a fail. The catchable protocol is `Err(Halt::Resume(target))` via `catchable_type_error[_msg]`. Fix any demotions first.
2. Ranked queue, starting from the split `ironhorse-aborted:*` reasons in report.json. Pick the highest-yield clusters that fit the session:
   - iterator-protocol reification (about 241 Iterator/prototype aborts). Check what the intrinsic-metadata work already landed.
   - `wrong-throw:*` families: TypedArray/prototype ~766, Array/prototype ~366, Date ~243, RegExp ~241, String ~237.
   - `unsupported-opcode:*`: defineProperty ~843, eval ~626, getOwnPropertyDescriptor ~558.
   - the 162 `:internal:resume` escapes that round 2's canary surfaced (enter_call sibling leaks).
   - module evaluation (443+164 infra) is the largest single item, but it's likely too big for one round. Scope it, don't start it, unless the rest is done.
   Temporal and Intl are oracle-host limits and out of scope.
3. Add a dual-run (oracle-checked) regression suite for every fixed cluster.
4. Final sweep at head. Commit a new superseding floor under `baseline/refresh-<date>/` with covered.txt kept byte-sorted, and zero lost against -20260904. Run the Rust gates (`cargo test --release -p ironhorse-vm -p ironhorse-compile -p ironhorse-262 -p ironhorse-snapshot`).
5. Post a before/after summary with the remaining ranked queue as a comment on https://github.com/kriscendobot/garden/issues/51.

**Logistics that worked in round 2 (endolin hosts):**
- A whole-tree `full-run.sh --jobs 14 --oracle on` takes about 4-25 min.
- Detach sweeps with setsid/nohup plus a log file, because the handler limit reaps supervisor sessions and resume-aware results survive.
- Fetch test262 at the pin with `git clone --filter=blob:none --no-checkout https://github.com/tc39/test262.git` then `git checkout be13516fb644`. The bare kriscendobot-test262.git lacks the pin. Pass `--test262-dir <dir> --no-fetch`.
- c/moddable at its pin clones fast from `worktrees/kriscendobot-moddable.git`.
- `regexp_unicode_sets` needs `RUST_MIN_STACK=64M` locally.
- RegExp property-escapes batches produce spurious `ironhorse-hang` failures under contention. Rerun them before trusting a fail count.
- Never `test262:update` the hardened262 baseline locally. A 7-entry xs/sesXs delta is a local-xst artifact; CI's pinned xst decides.
- /tmp is noexec; use a scratch TMPDIR.

If the round cannot finish in one session, push progress to the branch each time a cluster lands, so a requeue resumes from the branch rather than starting over.
