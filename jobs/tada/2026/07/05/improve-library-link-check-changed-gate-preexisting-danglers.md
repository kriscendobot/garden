Inbox is empty. Work is complete and pushed.

## Completion report

**Job:** Make the `scripts/jobs/library-link-check.sh --changed` gate fire ONLY on newly-introduced dangling links, so a scholar's post-ingest gate stops going RED for pre-existing danglers on untouched rows of shared index files.

**What I did** (baseline-diff approach, the one the job recommended as more precise):

- Added a `link_preexisting_dangler` helper: when a dangling link is found under `--changed`, it reads the referrer at `$BASE_REF` and returns "pre-existing" only if (a) the referrer carried the *exact* same link target at base **and** (b) that target did not resolve to a committed file at base. Pure git object reads against the already-fetched ref — no network.
- Pre-existing danglers are now classified **advisory**: reported with a `[pre-existing]` tag and a verdict line, but they do **not** add to the gating `DANGLING` count. Exit 1 fires only on danglers absent at base — including a target that resolved at base but the change deleted (correctly still gated as newly-introduced breakage).
- Hoisted `libpfx` and added a one-time `BASE_AVAILABLE` probe. When `$BASE_REF` is unavailable (shallow clone / unknown ref), the helper short-circuits and every dangler gates — **preserving today's whole-file behavior** exactly, as required.
- The `sections/README.md` block is checked via a mktemp slice; I threaded a `logical_referrer` arg through `check_links_in` so the base lookup and reporting key off the real `sections/README.md` history, not the temp path. This also improves the reported referrer path.
- Updated header docstring, `--changed` usage text, and verdict output.

**Changed files:** `scripts/jobs/library-link-check.sh`, `scripts/jobs/test/library-link-check-test.sh` (+3 subtests: pre-existing dangler is advisory-not-gating; a newly-introduced dangler still gates; a base-resolving-now-deleted target still gates).

**Verification:** full hermetic test suite passes **42/42** (all 12 original subtests preserved + 3 new). Also manually confirmed the base-unavailable fallback still gates a dangler (exit 1).

**Pushed:** commit `64755b76e` landed on `main2` (rebased onto `origin/main2`, push CAS succeeded on first attempt → `ae9f51caf`).

**Follow-ups:** none required. Note: `--changed` currently only checks source/section clusters (via `slug_for_file`); `topics/*.md`/`concepts/*.md` index pages aren't walked in `--changed` at all, so they never produced this false alarm — the fix covers the surfaces the gate actually checks (`sources/README.md`, the `sections/README.md` block, source pages, and kind:index parents).
