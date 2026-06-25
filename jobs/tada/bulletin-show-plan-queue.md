## Completion report — `bulletin-show-plan-queue`

**Outcome:** The bulletin now renders a deterministic **"## Plan queue"** section surfacing the parked `jobs/plan/` category, distinct from the design-plan `render_plan`. Confirmed live on `origin/journal2`.

**What I found:** The feature itself (`render_plan_queue` in `scripts/jobs/bulletin.sh` + `plan_gate`/`plan_priority`/`plan_deferred_ranked` helpers in `common.sh`) had *already* landed at `cf1ff5233` (the HEAD at claim time). Two things were missing to satisfy the DoD:
1. **No tests** for the renderer.
2. The running `garden-bulletin.service` was on **stale code** — started 18:26 UTC, before the 21:00 UTC feature commit — so it computed a dashboard without the section, matched the posted README, and never re-rendered.

**What I did:**
- Verified `render_plan_queue` against the real plan files — go-ahead `(none)`, deferred ranked normal-before-low.
- Added **SUBTEST 10c** to `scripts/jobs/test/run-test.sh` (isolated worktree off `origin/main2`): extracts the renderer + plan-metadata helpers and asserts (a) `gate: go-ahead` jobs land under "awaiting go-ahead" with description (deferred excluded), (b) `gate: deferred` jobs land under "deferred" sorted high-before-low (go-ahead excluded), (c) empty `jobs/plan/` → `(none)` for both groups. **5/5 PASS** in isolation; `bash -n` + `shellcheck -S warning` clean (no new findings on my lines). *(The heavy suite's SUBTEST 1/5 fail in the scratch env — pre-existing concurrency/timing sensitivity unrelated to this change; `/tmp` is also `noexec`, which is why I ran from a home worktree.)*
- Committed + pushed to `main2`: **`0d24e5f79`**.
- **Restarted** `garden-bulletin.service` (user systemd, non-blocking) → now on feature code (21:30 UTC).

**Verified live** — `origin/journal2:README.md`:
```
## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
(none)

### deferred (top by priority; foreman auto-promotes when idle)
- `investigate-systemd-run-vs-gardener-loops` — _normal_ · PLAN: investigate systemd-run vs. …
- `investigate-resumable-gardeners`           — _normal_ · PLAN: investigate making gardeners RESUMABLE …
- `ingest-ocap-library-sections`              — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- `ingest-ocap-kernel`                        — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- `classify-lint-endo-master`                 — _low_    · PLAN: classify lint errors on endo master …
```
All currently parked plans are `gate: deferred` (the four named in the job plus a fifth, `ingest-ocap-kernel`, posted since the job was written); go-ahead is empty as expected.

**Notes / follow-ups:**
- The shipped row format is `` - `<base>` — _<priority>_ · <description> `` rather than the job's suggested `(priority <p>)` suffix — same information, and it was already committed/tested, so I left it as the canonical form rather than churn it.
- Worktrees torn down, scratch cleaned, inbox drained (empty).
