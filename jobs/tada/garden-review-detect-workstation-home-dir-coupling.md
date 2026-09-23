Done. Landed on `main2` (commit `2a46a8a1e`).

## Completion report

**Job:** detect developer-workstation (home-dir) coupling in change review + add a portability juror.

### What I did

**Part 1 — deterministic detector + conditional `claude -p` fixer**
- **`scripts/jobs/gardening/detect-home-coupling.sh`** (new): a no-LLM detector that scans a change's **added** diff lines (`+`, excluding `+++` headers) for the current user's home directory, taken **dynamically from `$HOME`** — never a hardcoded literal, so the script stays clean under its own check. `check` subcommand is quiet-by-exit-status (exit 0 = coupling, exit 1 = clean), mirroring `sense.sh`; `lines` prints the offending `<path>: <text>` for the fixer. Honest-and-quiet on an unresolvable base or empty `$HOME` (no new coupling identifiable).
- **`scripts/jobs/handlers/portability-coupling-claude.sh`** (new): the conditional fixer, mirroring the existing `*-claude.sh` shape (sources `common.sh`, `--dangerously-skip-permissions`, best-effort). Runs only after the gate fires; hands the offending lines to `claude -p` to rewrite into portable forms (`$HOME`/`$GARDEN_ROOT`/relative/config var) and re-stage. Exits 0 on a missing `claude` so it never aborts the state machine.
- **`scripts/jobs/gardening/garden-pr.sh`**: wired the detector+fixer as a `run_if` sense-gated automation alongside the existing gates (overridable via `GARDEN_HOME_COUPLING_FIXER`). Quiet on the clean path.

**Part 2 — portability juror**
- **`roles/jurors/transplanter/AGENT.md`** (new): semantic backstop for coupling the literal grep can't catch — other users' homes, absolute machine paths, hardcoded hostnames (the `GARDEN`/`GARDEN_HOST` knob), UID/port/single-OS assumptions. Wired into **`panel.sh`**'s code-panel seat list (comment updated 26→27 seats).

**Tests** — `scripts/jobs/test/detect-home-coupling-test.sh` (new): hit / no-hit, **added-lines-only** (removed/context home literals don't count), **`$HOME`-dynamic** (clean under a different `$HOME`, hits under that home's own path), portable `$HOME`-variable form not flagged, no-base/empty-`$HOME` quiet. **10/10 pass.**

### Verification
- Detector test: 10/10 pass. Syntax-checked all touched scripts.
- **Self-consistency confirmed**: the real `$HOME` (`/home/kris`) appears in none of the new/changed files; the detector run against my own diff vs `origin/main2` reports clean. (Coarse `grep` hits in the juror brief and test are an illustrative `/home/alice` example and synthetic `$TR/home/*` dirs — not workstation coupling.)
- **End-to-end wiring smoke test**: coupling tree → gate fires, fixer invoked with `(wt, base)`, exit 0; clean tree → gate quiet, fixer not invoked, exit 0.
- Committed under the bot identity (`endolinbot`); pushed `HEAD:main2`, landed first attempt.

### Follow-ups / notes
- The conditional fixer's actual rewrite quality depends on `claude -p` at runtime; the transplanter juror is the deliberate semantic backstop for anything it leaves behind.
- Pre-existing coupling elsewhere in the repo (e.g. `run-test.sh`'s hardcoded `TR=/home/kris/.garden-test`) is out of scope — the detector only flags **newly added** lines, so it won't fire on untouched legacy paths, but the transplanter would flag such a line if a future change touched it.
- No central test runner discovers `*-test.sh` files; the new test is standalone like its peers (e.g. `local-verify-test.sh`).
