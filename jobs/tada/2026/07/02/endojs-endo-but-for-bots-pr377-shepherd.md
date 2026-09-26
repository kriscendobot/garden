The macOS runner has been stuck in GitHub's runner-availability queue for ~15+ minutes — a pure infrastructure delay with 0 failures anywhere, and this exact job passed on the immediately-prior run. The substantive shepherd work is complete and verified: every executable check is green on the head SHA.

I'll finalize honestly — I won't claim the queued macOS job is green (it's queued, not run), but the shepherd repair is done and confirmed.

---

**Shepherd report — endojs/endo-but-for-bots PR #377 ("fix(benchmark): retry esvu installs in install-engines.sh")**

**Diagnosis.** The red rollup that minted this job was a stale 2026-05-29 run (5+ weeks old, unre-runnable). I re-triggered fresh CI (close/reopen, then a real push) and separated the failures into three classes:

1. **lint / test (22.x) / test-async-hooks (18) / check-action-pins** — failed in ~8s inside `actions/setup-node` with `Could not get yarn cache folder path for undefined` (`yarn --version` returned empty). The CI config is correct (`corepack enable` precedes setup-node, matching green master); this was a transient corepack/yarn runner flake. **Cleared on the fresh run — all green.**
2. **zizmor** (Workflow security audit) — real, reproducible: exit 13 on `release.yml:63: action's hash pin has mismatched or missing version comment` (`# v1`). zizmor v1.24.1 now demands the full version; **master already carries `# v1.8.0`**, but this stale frozen-base branch predates that fix.
3. **test-xs** — `esvu` failed to download XS 8.2.3 + V8 15.2.13 even after the PR's retries. I probed both download URLs live — **both return 200** — so this was a transient download/extract blip that caught both retry attempts in a bad window, not a hard version rotation.

**Fix applied.** One atomic commit on the PR head branch (`f54e7ea32`), matching master's known-good line:
- `.github/workflows/release.yml:63`: `changesets/action@…​ # v1` → `# v1.8.0` (clears the zizmor finding).

**Result (head SHA `f54e7ea3`).** zizmor: **green**. test-xs: **green** (transient cleared on re-run, as predicted from the live-URL probe). All other jobs green — lint, test (22.x/24.x ubuntu + 24.x macos), test-async-hooks (18/22), test262 (22/24), test-hermes, check-action-pins, cover, viable-release, test-ocapn-python. **0 failures.** The single job `test (22.x, macos-15)` is sitting in GitHub's macOS-runner-availability queue (never dispatched to a runner) — an infrastructure wait, not a failure; the identical job passed green on the prior run.

**Follow-ups (not shepherd scope, for the maintainer/liaison):** This PR is a DRAFT, 149 commits behind master on a frozen base (`master-c49fb04`), and its raison d'être (esvu retry hardening) overlaps work master may have since absorbed — worth a staleness/supersession review. No PR comment posted: auto-dispatched with no maintainer comment and no per-action comment authorization in the job body (shepherd External-repo etiquette).

`next: none` — the reproducible failure (zizmor) is fixed and confirmed green; the rest were transient flakes that cleared on the fresh run.
