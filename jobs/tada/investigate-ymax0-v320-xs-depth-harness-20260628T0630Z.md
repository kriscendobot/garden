Done. Completion report follows.

---

## Completion report — investigate-ymax0-v320-xs-depth-harness

**What I did.** Ran the methodology step-6 synthetic XS depth harness (export-free) the job asked for, using the surviving harness assets under `~/.cache/garden-scratch/exp6-ymax0/` (already had `{value,tail}` `LogEntry`-shaped probes + a fresh-vat bisect + a V8 control). I extended it to cover every path the job names, then measured the depth ceiling on the prebuilt xsnap-worker v0.14.2 (4096-slot stack) vs native V8, and captured exact frames/level with the instrumented worker.

**Empirical result (decisive).**
- **XS depth ceiling ≈ 49–52 nested levels for ALL paths** — `passStyleOf` (~50), `passStyleOf` array (~52), `mustMatch`/deep-pattern (~50), `mustMatch(·,M.any())` (~50), `fromCapData`/unserialize (~49), `keyEQ`/equate (~49). V8 is ~2000 for the passStyleOf-bound paths (~40× deeper) and ~500–600 for the deep-pattern probes (~10–13×).
- **frames/level ≈ 3.1** (`passStyleOfRecur`→`assertRestValid`→`passStyleOfInternal`), but frames are *fat* (~25 slots vs 10 for trivial recursion, ~78 slots/level), so the **4096-slot value stack** caps at ~161 frames ≈ ~51 levels.

**Verdict on the prior estimates.**
- `passStyleOf ~115 levels` → **REFUTED**, actual ~50–51. The ~3 frames/level estimate was right; the "~350-frame budget" was wrong — the limiter is the 4096-*slot* stack with fat frames.
- `checkMatches ~15 levels` → **REFUTED**, actual ~50. `checkMatches`/`mustMatch` isn't separately limited; deep-pattern and `M.any()` probes overflow at identical N/frames, top-of-stack is the entry `passStyleOf` — match/unserialize/equate all collapse to the passStyleOf wall.
- `V8 ~15–30× deeper` → broadly **CONFIRMED** (~40× for passStyleOf-bound paths; ~10–13× for deep-pattern probes).
- Meta-conclusion: this **confirms** the instrumented-trace finding that v320 is *not* depth-driven (real bundle aborts at 9 frames via scope width); no realistic copyRecord chain nests ~50 deep.

**What changed.** Added `probeUnserialize`/`probeKeyEQ` to `app-entry.js` + `measure-v8.mjs` and rebuilt `app-bundle.js` (esbuild IIFE; original backed up to `app-bundle.orig.js`). Copied the instrumented worker into the executable scratch dir (it's EACCES from `/tmp`, noexec). Posted the full threshold curve + frames table as a comment on the issue thread (kriskowal/garden#9 → `issuecomment-4825152147`); did **not** close it. Updated the durable `reference_xsnap_xs_repro_without_agoric_build` memory with the harness location and findings.

**Follow-ups / notes.** No garden-repo files touched and no worktree created — this was XS investigation in the standing scratch harness, not main2 development. Caveat for re-runs: `/tmp` and `~/.cache/garden-scratch` are wiped by redeploys, so the harness + worker + bundle may need regenerating from the fork SHA. The actionable v320 remedy is unchanged: the contract-side width fix (rebuild `hex.js` `decodings` with a loop to reclaim ~1000 ref slots), not the depth ceiling this harness measured.
