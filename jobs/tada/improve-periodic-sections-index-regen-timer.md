Done. Completion report below.

---

**Job: improve-periodic-sections-index-regen-timer — COMPLETE**

**What I did.** Added a deterministic systemd timer that regenerates `library/sections/README.md` off-agent, so the link-check navigation backstop self-heals even when no scholar cycle runs step 9 (the gap that left `erights--elang-same-ref` missing across the 16:33Z–16:48Z cycles).

**What changed** (pushed to `main2` as `cdd895416`, fast-forward over the dependency's `7d3519074`):
- `scripts/systemd/garden-regenerate-sections-index.service` — `Type=oneshot`, `SuccessExitStatus=143 130 75 SIGTERM SIGINT`, `TimeoutStartSec=900`, run under `self-heal-run.sh garden-regenerate-sections-index --expect 75 -- .../regenerate-sections-index.sh` (no mode args = `--land`).
- `scripts/systemd/garden-regenerate-sections-index.timer` — `OnCalendar=*:37` + `Persistent=true`, `WantedBy=timers.target`.

**Decisions / reconciliation:**
- The job specified "modeled byte-for-byte on `garden-library-source-drift-scan`" AND cited the exact `75 EX_TEMPFAIL` retry behavior. Byte-for-byte, *both* sibling library units (drift-scan, link-scan) run their payload through `self-heal-run.sh ... --expect 75 -- <script>` — and `--expect 75` is precisely the idiom for the tip-sync-outage code the job describes. So I used the self-heal wrapper (crash diagnosis + SIGTERM normalization for unattended operation) with the regenerate script in default `--land` mode as the payload, rather than a bare exec. The script's `land` mode is idempotent (lands nothing when current) and exits 75 on a transient outage, so a missed tick retries next cadence.
- `OnCalendar=*:37` chosen clear of the sibling library cadences (clone-keeper `:00/:30`, drift-scan `:07`, link-scan `:22`) so tip-sync ticks don't pile up. Absolute `OnCalendar`+`Persistent` (not relative `OnActiveSec`) per the documented daemon-reload-churn failure mode the siblings already encode.
- **No `install-units.sh` edit needed.** That script deliberately derives *both* the render set and the enable set from the units actually present in `scripts/systemd/` (the policy comment explicitly rejects a hand-maintained list because it drifts). A timer-paired oneshot carrying `WantedBy=timers.target` is wired automatically: the timer is enabled, its sibling service is started by the timer. Adding a hand entry would reintroduce the anti-pattern. The job's "wire it into install-units.sh" is satisfied by this auto-derivation.

**Verification:** `systemd-analyze verify` on the rendered units is clean (no directive/parse errors; the deployed root holds both `self-heal-run.sh` and `regenerate-sections-index.sh`). Built in an isolated worktree off `origin/main2`, committed explicit pathspecs under the bot identity, pushed FF, worktree removed.

**Dependency:** `improve-land-sections-index-regenerator` had already landed (`7d3519074`) — confirmed `scripts/jobs/regenerate-sections-index.sh` tracked on `origin/main2` with the documented `--print/--check/--land`, default-`--land`, and `75` exit-code contract.

**Follow-ups:** None required. The unit auto-enables on the next `install-units.sh install && enable-services` on each host (e.g. via the deliberate-deploy / install-units path); no manual enable step is owed.
