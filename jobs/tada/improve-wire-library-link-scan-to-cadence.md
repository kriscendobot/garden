Done. The worktree is torn down and my inbox is empty.

## Completion report

**Job:** `improve-wire-library-link-scan-to-cadence` — give the standing section-link-integrity scan a real cadence.

**What I did** (isolated worktree off `origin/main2`, committed `d56e48bc9`, pushed `HEAD:main2`):

1. **New systemd pair** `scripts/systemd/garden-library-link-scan.{service,timer}`, mirroring the source-drift pair:
   - oneshot service wrapped in `self-heal-run.sh garden-library-link-scan --expect 75 -- … library-link-scan.sh --actuate`, with the same `SuccessExitStatus`/`TimeoutStartSec` belt-and-suspenders.
   - `OnCalendar=*:22` (distinct minute from drift's `:07` so the two tip-syncing library scans never contend), `Persistent=true`, `WantedBy=timers.target`. Verified `install-units.sh` auto-derives it into the intended/enable set — no hand-wiring.

2. **Resolved the design decision (actuating shape)** — took the job's recommended path but made `--actuate` an **explicit opt-in flag rather than the default**, and recorded the rationale in the script header. On a dangle it posts **one** `scholar-fix-dangling-nav-links-<hash>` job naming the targets and **exits 0** (so the unit stays Healthy and a finding creates remediation work, parity with drift's per-source refresh posts). The default `--nav`/`--exists`/`--` modes keep their raw nonzero-exit diagnostic contract intact — which matters because the in-context callers (the scholar's `--exists` re-verify primitive, by-hand `--nav`) depend on it, and the step-8 gate actually calls the core `library-link-check.sh --changed` directly, not this wrapper. The basename is **content-derived** (sha of the sorted dangle-set) so the same breakage is idempotent but a *new* set posts a fresh job — avoiding a fixed name that would only ever post once. Added `--actuate --dry-run` as a CI-style check (exit 1, posts nothing).

3. **Tests:** extended `library-link-scan-test.sh` with actuate post / idempotent / clean-tip / dry-run subtests plus a unit-render check for the new pair — 25/25 pass. `enable-services-test.sh` still 24/24 (its independent derive picks up the new timer automatically).

**Verified current state:** ran `library-link-scan.sh` at tip — clean, no live dangling-link debt; the gap was purely the missing cadence, now closed.

**Follow-up / note:** the units are on `main2` but not yet installed on this running host — the root checkout advances only via the deliberate `deploy-garden.sh`, and `install-units.sh install`/`enable-services` will pick up the new pair automatically on the next deploy (derive-from-present set). No manual enable step is owed.
