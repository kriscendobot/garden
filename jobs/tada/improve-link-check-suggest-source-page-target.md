Done. Completion report follows.

---

**Job: improve-link-check-suggest-source-page-target — complete**

**What I did**

Added a deterministic "did you mean" hint to `scripts/jobs/library-link-check.sh`. In `check_links_in`, when a markdown link is reported DANGLING, the code now derives the target's basename `<name>.md` and checks whether `sources/<name>.md` resolves to a committed file (via the same `is_committed` graph resolution against `TRACKED` + `LIBRARY`). If so — and the candidate isn't the dangling target itself (guards against suggesting a link back to itself when the referrer already points at `../sources/<name>.md`) — it appends ` — did you mean ../sources/<name>.md?` to both DANGLING output lines (the untracked and no-such-file variants).

**What changed**
- `scripts/jobs/library-link-check.sh`: hint computation in the DANGLING branch; suffix appended to both DANGLING `echo` lines.
- `scripts/jobs/test/library-link-check-test.sh`: new SUBTEST 12 reproducing the 2026-06-28 KernelQueue.ts footgun — an overview-style parent index (long descriptive slug, **no** bare `sections/<slug>.md`) that links a source-page slug as a sibling section. Asserts (a) the hint fires pointing at `../sources/<slug>.md`, and (b) a control dangling sibling link with **no** corresponding source page gets **no** hint, so the suggestion doesn't fire on legitimate sibling-section links.

**Verification**
Full suite passes: **34 passed, 0 failed**, both in the working tree and re-run on a clean `origin/main2` worktree.

**Landed**
Committed on an isolated worktree off `origin/main2` (per the garden-infra-jobs convention — the shared root tree is concurrently mutated) and pushed: `fcd7bab9d` → `origin/main2`. Worktree removed; the deployed root checkout left clean for the deliberate-deploy flow.

**Follow-ups**
None. The change is pure graph resolution with no new network/writes; the script's "no writes, no network" invariant holds. The hint will surface automatically wherever `check_links_in` runs (the `--changed` ingest gate, `--source-slug`, `--files`, `--nav`, `--all`), turning the source-page-vs-sibling-section mis-link from a re-land round-trip into a one-shot fix. It reaches the running fleet on the next deliberate deploy.
