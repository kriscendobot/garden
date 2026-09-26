Inbox empty. All must-fix items applied, pushed, CI green.

## Completion report

**Job:** Gauntlet FIX round 6 for endojs/endo-but-for-bots PR #322 (`design(familiar-flatpak-pipeline)`).

**Panel-6 verdict addressed** (4 request-changes seats + cheap should-fix polish):

- **critic / decomplector / skeptic must-fix** — the design's body marked the single-instance lock as a blocking-for-ship, common-path corruption defect ("must land with/before shipping"), but the Phased Implementation table never scheduled it. Encoded it as an explicit **phase-4 precondition** and added a closing note stating it is the design's one hard blocking-for-ship TODO while every other Known-Gaps item is a confirmation smoke / post-MVR decision the table deliberately does not gate the ship on.
- **ergonomist must-fix** — reshaped `make-flatpak.mjs`'s arch surface to match the package's three sibling scripts: now takes target arch **positionally** or via the `TARGET_ARCH` env var (the value the CI matrix already exports), accepts the pipeline's `x64`/`arm64` Node tokens as well as Flatpak's `x86_64`/`aarch64`, and maps internally — replacing the invented `--arch=` flag + `FLATPAK_ARCH` env + Flatpak-only vocabulary. Updated the § Design Decisions cross-reference to match.
- **pedant must-fix** — fixed the `designs/README.md` spec citation: `G4` → `§ G4` (the form the design's own 8 cross-references use).
- **should-fix polish** — copyeditor: "is based on", sentence-fragment fix, filename de-stutter, tense agreement (`engaged`→`engages`); pedant: OSTree trademark capitalization (both instances); skeptic: added a phase-3 Wayland launch-path smoke as a tracked TODO (the CI catalog is X11-only under `xvfb-run`, so the load-bearing `--ozone-platform-hint=auto` flag was untested).

**Pushed** as follow-up commit `7b2add493` to `origin/feat/familiar-flatpak-pipeline` via `safe-push-pr-head.sh` (advance mode, `457d1ce0b..7b2add493`).

**CI:** GREEN — `total=5 failed=0` at 365s.

Stopped here per stage contract; did not re-run the panel (the driver re-posts panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr322-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (2825554 cached reads)
- Output: 16484 tokens
- Cost: $2.539113999999999
- Wall-clock: 679s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
