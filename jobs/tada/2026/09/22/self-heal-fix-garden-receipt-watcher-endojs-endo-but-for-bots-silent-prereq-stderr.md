Pushed to `main2` as `3002969de52`.

## Completion report

**Job:** Make `receipt-watcher.sh`'s prerequisite subshell diagnosable after the self-heal capture `24818db04` recorded `prereq_rc=1` with a **completely empty** `PREREQ_ERR` — a command inside `( ensure_clone; sync_clone )` failed without reaching any `die()`/`log()` path, leaving nothing to classify.

**What I did:** Added an ERR trap to the prerequisite subshell (`scripts/jobs/receipt-watcher.sh:117-122`) that records the failing `source:line`, function, command, and rc into `PREREQ_ERR`.

**Important correction to the job's suggested snippet.** The literal fix in the spec — dropping a `trap … ERR` into the existing `( … ) 2>"$PREREQ_ERR" || prereq_rc=$?` — **does not fire**. I verified this empirically: the `|| prereq_rc=$?` puts the subshell in a *tested* context where bash **ignores errexit**, and the ERR trap fires only under errexit conditions, so a bare trap there never triggers (I confirmed with a real script that the trap output stayed empty and execution ran past the failing command). The working pattern I landed instead:
1. `set +e` in the parent so the subshell is a standalone statement (not `||`-tested) whose rc can be read separately without killing the script;
2. `set -eE` **inside** the subshell — errexit re-armed (now in an un-ignored context) plus errtrace, so the trap is inherited into `ensure_clone`/`sync_clone` and the sourced `common.sh` helpers they call;
3. capture `prereq_rc=$?` as a separate statement, then restore parent errexit.

Verified end-to-end in a script mirroring the real structure: a failure inside a sourced function now yields e.g. `[prereq] failed at common.sh:<line> in sync_clone(): <cmd> (rc=…)`.

**No behavior change on success:** no command fails, so the trap never fires — identical. `die()`/`exit` inside still propagate as the subshell rc with their own stderr, exactly as before. Re-arming errexit inside matches how essentially every other caller (`ci-watcher`, `gauntlet`, `defer-doomed-plan`, `detect-quota-resets`, `inbox-list`, `doom-notice`) invokes these helpers — as bare statements under `set -euo pipefail`.

**Note on the likely trigger:** the current `main2` HEAD `05c22e5c0e9` ("per-slug journal clone") already addresses the shared-clone contention theory named in the job. This diagnostics fix is complementary: if the empty-capture signature recurs from any cause, it will now name the failing command.

**Follow-up (out of scope, not fixed):** `scripts/jobs/cursor-set.sh:74` has the same latent blind spot — `if ( sync_clone "$DIR" ) 2>"$diagnostic_file"; then …` runs the subshell in an errexit-ignored `if` context, so a mid-function `set -e` failure there could likewise leave an empty diagnostic. Worth the same treatment if it ever surfaces.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-endojs-endo-but-for-bots-silent-prereq-stderr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (960301 cached reads)
- Output: 18368 tokens
- Cost: $1.4836795
- Wall-clock: 268s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
