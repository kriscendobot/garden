Inbox empty. Job complete.

## Completion report

Added a third enforcement site for `skills/no-comment-banners` — a comment-banner sweep inside the gardening PR loop — by mirroring the existing workstation-coupling detector+handler pair exactly.

**What changed (committed `0b66b251b`, pushed to `main2`):**

1. **`scripts/jobs/gardening/detect-banners.sh`** (new) — deterministic, quiet-by-design detector modeled on `detect-home-coupling.sh`. `check <wt> [base]` exits 0 on an ADDED banner, 1 clean; `lines` prints each `<path>: <text>`. Scans only ADDED `^+` diff lines (never the `+++` header) in code files (`js/ts/jsx/tsx/mjs/cjs`) for the SKILL's banner shape — a `//`/`#`/`*`/`/* … */` comment whose body is a 4+ run of `- = * ~ _`. No resolvable base → quiet exit 1. The rule-run is written as four explicit char-classes + one (no awk intervals) for portability. Markdown breaks, data dashes, and directional-arrow prose can't match (extension restriction + the "nothing but rule chars" anchor).

2. **`scripts/jobs/handlers/banner-sweep-claude.sh`** (new) — conditional fixer modeled on `portability-coupling-claude.sh`. Invoked only after the detector fires; hands the offending lines to `claude -p` to delete rule lines (keeping a bracketed title as a plain comment) and re-stage. Best-effort: missing/declining `claude` never aborts the state machine; the archivist juror is the backstop.

3. **`scripts/jobs/gardening/garden-pr.sh`** — wired `DETECT_BANNERS`/`GARDEN_BANNER_FIXER` behind a `run_if …check… -- …fixer…` gate, exactly alongside the home-coupling `run_if`, with the requested env-override shape.

4. **`skills/no-comment-banners/SKILL.md`** § Scope — now records three sites (generation / gardening loop / review) with the detector+handler paths.

5. **`designs/gardening-state-machine.md`** — stage 2 now names both concrete detectors (home-coupling and banners) as the sense-gated automations.

6. **`scripts/jobs/test/detect-banners-test.sh`** (new) — hermetic 9-case smoke test.

**Verification (all run):**
- `shellcheck` clean on the detector, test, and `garden-pr.sh`; the handler emits only the same two SC1091/SC2034 infos the mirrored `portability-coupling-claude.sh` emits (`GARDEN_TAG` is consumed by `common.sh`).
- `detect-banners-test.sh`: **9 passed, 0 failed** — HIT on an added `// ----` banner (`check`=0, `lines` prints path+text); clean diff → `check`=1 silent; removed-banner not a hit; arrow/dash prose and markdown break not hits; equals/star/block forms all hit; no base → quiet.
- End-to-end: a synthetic worktree adding a `.js` banner drives `run_if` → detector fires → stub fixer invoked with `<wt> HEAD~1`.
- Self-clean check: the new scripts carry no banner comments (the only grep hits are `.sh` prose/fixture strings, and `.sh` is outside the detector's scanned extension set).

**Follow-ups:** none. The handler's LLM path (`claude -p`) was exercised only via a stub, per its best-effort contract; live behavior relies on the same pattern the shipped `portability-coupling-claude.sh` already uses.
