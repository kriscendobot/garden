---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T02:25:12Z -->

---
model: opus
---
# stage-10k child 2: outage-hardened 52-file daemon sweep remeasure (PR #600)

**Measurement-only: no commits, no pushes, no PR comments; PR #600 stays DRAFT.** Measure the REAL remote tip of `endojs/endo-but-for-bots` `xs2rust-endor` (fetch first; if the tip regressed to an already-measured sha, SKIP honestly and say which). Read the latest `xs2rust-endor-press-*` tadas first — the press can advance the branch between sessions.

**Environment (endolin-garden proven env `/home/kris/garden/tmp/s9r`):** short AF_UNIX path; `TMPDIR` short path; `mkdir -p $HOME/tmp` before redirecting. Sync the changed `rust/` files to tip; verify the recompile actually triggers (touch → `Compiling endor-vm` / `Compiling endo`); fresh `cargo build --release -p endo --bin endor`, record BUILD_EXIT=0. `c/moddable` clean at pin `23b4d6b0a65f`. Regenerate the XS bundles; note md5 identity vs prior. Daemon-boot smoke (`context.test.js`) before the sweep. Guard the three environment-artifact classes: AF_UNIX sun_path overflow (real short path only), uniform provisioning-race asserts, stale seeded `target/`.

**Sweep:** 52 files, ava default reporter (NOT tap — the TAP reporter crashes in `dumpError` on a timed-out test), `--concurrency=1 --timeout=25s`, detached (`setsid nohup`), resumable TSV. Artifacts to `$HOME/tmp/s10k-results/` (MEASURED-TIP.txt, build-exit.txt, per-file logs, sweep TSV, SUMMARY.md).

**Your tada MUST answer:**
1. **Did the error-trace 6-pending pin MOVE?** Name EVERY error-trace test that flipped vs the s10h/s10j anchor (fail=14 / skip=20 / hang=1, TSV-identical baselines). The pin is THE question — if child 1 landed the live round trip, the 6 pending should flip; account for each.
2. **Any NEW daemon class** beyond the ledger (content-store-gc 9, git 3, git-remote 2 = 14 fails; channel-relay 4 + invite-retention 10 + iroh-network 1 + ws-relay 5 = 20 skips)?
3. **Did any class change?** If yes, re-run the C-XS same-harness baseline (anchor 530/19/20/0) and report the direct comparison; if no class changed, C-XS is not re-run — say so.

Report via your tada completion report ONLY — never inbox-send the parked supervisor.
