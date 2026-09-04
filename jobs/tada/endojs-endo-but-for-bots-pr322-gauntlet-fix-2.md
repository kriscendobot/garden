The CI watcher returned rc 0 (GREEN). The fix stage is complete.

## Completion report

**Job:** FIX round 2 of the PR #322 gauntlet — endojs/endo-but-for-bots, design PR `design(familiar-flatpak-pipeline)`.

**What I did:** Read the round-2 panel verdict (disposition: must-fix; 7 seats) and applied every must-fix item plus the high-value should-fix/nit items to `designs/familiar-flatpak-pipeline.md`. All the must-fixes traced back to one root defect — the document asserted three contradictory storage models — so I verified the actual behavior against source (`packages/where/index.js`, `packages/familiar/src/daemon-manager.js`, `.github/workflows/familiar-release.yml`) before rewriting.

**What changed (one commit, `fe5435e981`, pushed to `feat/familiar-flatpak-pipeline`):**
- **Storage model stated once** in a new "Where the Familiar's Data Lives" section: under Flatpak's per-app `$HOME` and per-app (private tmpfs) `$XDG_RUNTIME_DIR`, the daemon's state, cache, CapTP socket, and worker PID files all resolve app-private **by default** with no grant. Dropped all three `--filesystem=xdg-{run,state,cache}/endo` grants (`xdg-state` isn't a valid token; the others would map *host* dirs in and reintroduce the `EADDRINUSE` collision). Every dependent section (finish-args, launcher, smoke, CI clean-state, design decisions, gaps, open questions) now derives from this one statement. (critic, skeptic, decomplector, ergonomist, copyeditor, novice)
- **Sandbox-engagement gate** replaced the tautological machine-wide `pgrep bwrap` with a scoped `assert-sandbox.sh` that checks (a) no `--no-sandbox` in the Familiar's own process tree and (b) the renderer runs in a user namespace distinct from the broker. (critic, skeptic, novice)
- **Missing CI `Package app` step** added: the `make` job never runs `step:package`, so `out/Familiar-linux-x64/` is never produced and both `step:make` and the flatpak step would fail. (skeptic)
- **"unsigned, integrity-checkable"** rewritten: unsigned bundle verifies internal ostree checksums, not provenance; no key imported. (copyeditor)
- **Defined what the Familiar is** in the problem statement. (novice)
- should-fixes: single version source (metainfo generated from package.json), arch-decomplected staging to fixed `app/`, `--runtime-repo` on build-bundle, dropped redundant double upload, named release-gate blast radius + escape hatches, corrected `--share=ipc`/BaseApp rationales, dropped desktop `%U`, removed nonexistent chrome-sandbox README citation, em-dashes removed, relative-path citation sweep, `§ G4` instead of a bare line number, bumped Updated date + README cells.

**Result:** Pushed as a review-feedback follow-up commit. Bounded CI watch returned **rc 0 (GREEN)** — all 5 checks pass (browser-tests, build, lint, test, zizmor).

**Follow-ups:** The deep README milestone-table row / dependency-graph node integration (novice should-fix) was left for a future pass; summary-table and prose rows already exist. Per stage instructions I did not re-run the panel — the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr322-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 110 tokens (6394527 cached reads)
- Output: 65796 tokens
- Cost: $6.667989
- Wall-clock: 1094s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
