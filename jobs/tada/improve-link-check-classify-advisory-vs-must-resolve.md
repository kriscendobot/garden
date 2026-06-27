31/0 green from the canonical location. The change is committed and pushed to `origin/main2` (`f0b93d637`).

---

## Completion report

**Job:** `improve-link-check-classify-advisory-vs-must-resolve` — harden `scripts/jobs/library-link-check.sh` so the standing `--all` scan's red signal stays actionable.

**Problem:** The hourly scholar cycle runs `--all`, which walks every markdown file and conflated ~166 perpetually-dangling verbatim leaf-section-body links (red every cycle by construction) with the genuinely-broken navigation links into one saturated FAIL — so the signal was always red and never actionable.

**What I changed:**
- **`scripts/jobs/library-link-check.sh`** — In `--all`, each dangling link is now classified by its source file via a new `is_nav_file` helper:
  - **must-resolve** = the exact set `--nav` walks (concepts/topics/sources/roles index pages + `sections/README.md` + library `README.md`) → gates the run.
  - **advisory** = everything else (verbatim leaf section bodies `sections/<slug>--*.md`, and `kind:index` parents whose children are redundantly covered by their source page and the README block) → tallied and reported as a separate informational count, **not** gating.
  - Exit is nonzero only when a must-resolve link dangles; advisory danglers report alongside but don't change exit status. DANGLING lines now carry a `[must-resolve]`/`[advisory]` tag in `--all`. **Other scopes (`--nav`/`--changed`/`--source-slug`/`--files`) keep their existing any-dangling-fails semantics unchanged.**
  - Fixed the help text doc/behavior divergence; updated the header `Exit:` block and STANDING SCAN paragraph.
- **`scripts/jobs/library-link-scan.sh`** — Updated the `--all` usage note to describe the must-resolve-only gating.
- **`scripts/jobs/test/library-link-check-test.sh`** — Added SUBTEST 10 (advisory-only leaf-body dangling stays green, exit 0, advisory count reported) and SUBTEST 11 (a nav/source-table dangling fails exit 1 with the advisory count reported alongside).

**Verification:** Full suite green — `library-link-check-test.sh` 31/0, `library-link-scan-test.sh` 9/9, `bash -n` clean, no new shellcheck warnings. Against the live library, `--all` now splits cleanly: **12 must-resolve danglers → FAIL**, **168 advisory leaf-body danglers → informational** — versus the single saturated ~180 FAIL before.

**Pushed:** `f0b93d637` to `origin/main2` (committed from an isolated worktree off `origin/main2`, explicit pathspecs, per garden infra discipline).

**Design note (deviation worth flagging):** I defined the must-resolve set as exactly the `--nav` set, per the job's repeated framing. This means a `kind:index` parent `sections/<slug>.md` dangling is classified *advisory* — but no real coverage is lost, because every child it lists is redundantly referenced by its source page (`sources/*.md`, must-resolve) and the `sections/README.md` block (must-resolve), so a genuinely-missing child still fails the run on a gating surface.

**Follow-up (pre-existing, not introduced here):** `library-link-check-test.sh` uses a shared absolute fixture path (`/home/kris/.garden-link-check-test`), so concurrent gardener test runs can clobber each other — and `/tmp` is mounted noexec, so the test can't run from a `/tmp` worktree. Worth a separate hardening job (per-PID temp dir) if the fleet runs these tests concurrently.
