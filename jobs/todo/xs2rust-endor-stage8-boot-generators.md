---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T11:25:06Z -->

---
model: opus
---
# Stage-8 child 2/6 — restore/author the worker/SES boot generators + sources

**Program:** XS→Rust (Endor) port, PR endojs/endo-but-for-bots **#600**, branch `xs2rust-endor`
(base `llm`). **Keep the PR DRAFT.** Build child of serial orchestration
`xs2rust-endor-build-stage8`; tada-only reporting. One 2400s invocation.

**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots
xs2rust-endor`; sync to the REAL remote tip (the hourly press may rebase); push via CAS
(`git push origin HEAD:xs2rust-endor`), verify by exit code.

**Task.** `rust/endo/xsnap/src/lib.rs` does compile-time `include_str!` of three gitignored boot
bundles; only `daemon_bootstrap.js`'s generator is in-tree. The stage-7 daemon-boot probe
(report: `journal/jobs/tada/xs2rust-endor-stage7-daemon-boot-probe.md` on the garden's journal2
branch — read it) proved the four missing generator/source files are recoverable from the
sibling `slot-machine` branch (`git show slot-machine:<path>`; fetch that branch from origin if
absent locally):

1. **ses_boot pair — restore VERBATIM** (probe-verified compatible with the current tree):
   `packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs` and
   `packages/daemon/src/bus-worker-xs-ses-boot.js` (pulls only `@endo/harden` +
   `@endo/eventual-send/shim.js`).
2. **worker_bootstrap path:** restore `packages/daemon/scripts/bundle-bus-worker-xs.mjs`
   verbatim, but **AUTHOR a current-tree `packages/daemon/src/bus-worker-xs.js`** using
   slot-machine's as a template: strip the `@endo/slots`/`ENDO_USE_SLOT_MACHINE` branch and the
   `./interfaces.js` import (`@endo/slots` does not exist on this branch — CapTP path only),
   and realign the `./bus-xs-core.js` imports (`makeXsNode`, `markShouldTerminate`, …) to the
   CURRENT API (the probe measured ~5 lines of drift; diff slot-machine's `bus-xs-core.js`
   against the current one to find the realignment).

**Definition of done:** the two bundler scripts run to completion (after child 1's daemon-bundle
fix, which precedes you serially) and emit `ses_boot.js` + `worker_bootstrap.js` under
`rust/endo/xsnap/src/` (gitignored — NEVER commit the outputs). Commit the generators and the
authored worker entry only. Lint/format per repo norms. Capture bundler runs to files, check
`$?`.

**Practical notes:** `$HOME` = `/home/kris/garden`; logs under `$HOME/tmp`; `/tmp` noexec; yarn
PATH shim if needed; never `git add c/moddable`. Honest-partial discipline: commit what is done,
report the precise remainder.
