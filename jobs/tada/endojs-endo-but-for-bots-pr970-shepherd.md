The job is complete. CI is green.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #970 — drive CI to green.

**Failure diagnosed (single red check):** `build-wasm` failed with `the lock file Cargo.lock needs to be updated but --locked was passed`.

**Root cause:** An earlier PR commit added `icu_normalizer = "=2.2.0"` to `rust/engine/ironhorse-vm/Cargo.toml`. `rust/engine` is an *excluded* nested workspace, but `rust/endo` (a **root** workspace member) links `ironhorse-vm` by path — so ironhorse-vm is part of the **root** `Cargo.lock`'s graph. The PR updated only the nested `rust/engine/Cargo.lock`, leaving the workspace-root `Cargo.lock`'s `ironhorse-vm` entry missing the `icu_normalizer` edge (and its transitive `utf16_iter`/`write16` crates). `build-wasm` builds `ocapn_noise` from the root workspace with `--locked`, so it caught the stale root lock. Every other check was already green.

**Fix applied:** Regenerated the root `Cargo.lock` with the pinned toolchain (`cargo +1.91.1 update -p ironhorse-vm --offline`), a minimal 16-line addition — the missing dependency edge plus two small transitive crate entries, no version churn. Committed as `chore: Update Cargo.lock` (`00fc377422`), matching this PR's existing lockfile-commit convention, and pushed to the PR head with a `--force-with-lease` CAS against the expected anchor.

**Verification:**
- Local: `cargo metadata --locked` rc=0; the actual `rust/ocapn_noise/build.sh` (the CI step) rebuilt with `--locked`, rc=0; the emitted wasm was byte-identical (reproducible-build flags confirmed), so only `Cargo.lock` changed.
- CI: fresh run on head `00fc377422` — **all 26 checks green, 0 failures**, including the previously-red `build-wasm`.

**Notes/follow-ups:**
- No comment posted: the job body carried no per-action comment authorization and PR is still a draft; the shepherd deliverable (green CI) is met. Un-drafting/review is not the shepherd's call.
- `next: none` — the sole failure was a real in-scope lockfile staleness, now fixed and green; no escalation needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr970-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 59 tokens (2124166 cached reads)
- Output: 20577 tokens
- Cost: $2.2304659999999994
- Wall-clock: 1086s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
