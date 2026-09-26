CI is GREEN (rc 0, 5/5 checks passed, 0 failed). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 3 — endojs/endo-but-for-bots PR #322 (`design(familiar-flatpak-pipeline)`, a design-panel review of a markdown design).

**What I did:** Applied the round-3 panel verdict's must-fix items (plus the cheap, clearly-actionable should-fix/comment items across all seven jury seats) as one review-feedback follow-up commit to the PR head `feat/familiar-flatpak-pipeline`, pushed via `safe-push-pr-head.sh` (advance mode, `fe5435e981 → f164ccc0c1`), and watched CI to terminal: **GREEN, 5/5 checks, 0 failed.**

**What changed** (`designs/familiar-flatpak-pipeline.md` +279/−128, `designs/README.md` +2/−2):
- **§ Where the Familiar's Data Lives (critic/skeptic/novice):** scoped the "isolated Endo" claim to the *filesystem*; named `--share=network` as the one non-app-private axis and its collision disposition (host `8920` daemon or a second instance trips the start-time bind invariant → fail-to-start); expanded "CapTP socket" at first use; walked the two-instance / per-instance `$XDG_RUNTIME_DIR` case; reconciled the `xdg-state` (inert) vs `xdg-cache`/`xdg-run` (harmful) contradiction so both sections agree.
- **CI (critic/skeptic/ergonomist/decomplector):** the sandbox gate now launches the app (`xvfb-run` + bounded renderer-up wait) before `assert-sandbox.sh`; metadata validation points at the *shipped* staged metainfo, not the checked-in placeholder; toolchain install adds `appstream`/`desktop-file-utils`/`xvfb`.
- **Build script (renamed `build-flatpak.mjs`→`make-flatpak.mjs`, `step:build-flatpak`→`step:flatpak`):** `--arch` is an explicit input; release date from `SOURCE_DATE_EPOCH`/committed data, not the wall clock; fails loudly if the `<releases>` placeholder is missing; toolchain precondition check; corrected the `--runtime-repo` comment placement.
- **`assert-sandbox.sh`:** scoped by Flatpak instance (`flatpak ps` + `/.flatpak-info`) instead of pgid, so zypak's portal-reparented renderers aren't missed.
- **Desktop entry / AppStream:** generic `GenericName`, dropped the `Development` category, summary off the internal codename.
- **Phased impl:** reordered so clean-host validation (incl. proving `assert-sandbox.sh` passes) precedes wiring the release-blocking gate; added a phase-2 series-currency gate for `24.08`.
- **Prose:** kept em-dash-free; unified MVR spelling; `i.e.`→"that is"; removed `-ly` adverb hyphens; link text now matches URL host; unpacked run-on/nested sentences; deleted the doubled table-bracketing sentence; reconciled the README totals date (`2026-09-02`→`2026-09-04`).

**Follow-ups:** None for this stage. The gauntlet driver re-posts panel-4 next; I did not re-run the panel. One juror's structural suggestion (relocate § Where the Familiar's Data Lives under § Design) was left in place deliberately — the substantive concerns were addressed inline, and moving the load-bearing section is high-churn with many cross-refs.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr322-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 172 tokens (10196615 cached reads)
- Output: 70986 tokens
- Cost: $10.16274925
- Wall-clock: 1587s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
