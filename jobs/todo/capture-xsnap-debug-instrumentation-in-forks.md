# Capture xsnap debug instrumentation in bot-owned fork(s)

Map: **build/capture** — preserve diagnostic scratch into a bot fork so it
survives. Maintainer-directed; no upstream interaction.

## Origin and authorization

Maintainer directive (kriskowal) on kriskowal/garden issue #9:
https://github.com/kriskowal/garden/issues/9#issuecomment-4823971284
"Please also post a job to capture the debug instrumentation improvements to
xsnap in forks of the relevant repositories."

This authorizes committing/pushing the diagnostic artifacts to **bot-owned
forks only**. It does **not** authorize any upstream interaction.

## Scope guardrails (hard)

- **Bot-owned forks ONLY.** Push to `kriscendobot/agoric-sdk` (and, for the
  Endo bisection probe, a bot-owned Endo fork such as `kriscendobot/endo` or
  `endojs/endo-but-for-bots` if you prefer the bot's standing-authorized repo).
- **No upstream push, no PR, no comment, no cross-reference** against
  `Agoric/agoric-sdk` or `endojs/endo`. agoric-sdk upstream is off-limits to
  the garden; this job stays inside the bot fork as preservation only.
- The investigation set the agoric-sdk fork's push URL to `DISABLED-NO-PUSH`;
  re-enabling push to the **bot's own fork** (`kriscendobot/agoric-sdk`) is in
  bounds. Do not point a push URL at any upstream remote.

## What to capture (the "debug instrumentation")

These were produced by `investigate-beta3-ymax0-xs-repro-and-fix`
(see `jobs/tada/investigate-beta3-ymax0-xs-repro-and-fix.md`). They currently
exist only as untracked scratch on host `endolinbot` and may be GC'd:

1. **XS/V8 stack-depth probes** (the core instrumentation): measure the
   XS-vs-V8 native non-tail-frame budget and derive per-path level limits for
   `passStyleOf` / `marshal` / `mustMatch`-`checkMatches`. Run inside a real
   `xsnap` worker (fresh worker per trial; an XS stack overflow is uncatchable
   and aborts the worker with `"exited: stack overflow"`).
   Source files on host (copy these in if still present, else reconstruct from
   the report):
   - `/home/kris/agoric-sdk/packages/xsnap/scratch-xs-depth.mjs`  (xsnap worker depth probe)
   - `/home/kris/agoric-sdk/scratch-xs-repro/probe-v8.mjs`, `probe-raw.mjs`
   - `/tmp/endo-beta2/probe.mjs`  (beta2-vs-beta3 Endo bisection probe)
2. **The xsnap build workaround** for this host class: yarn's build-script
   subprocess gets EACCES on bin-shims even with the sandbox disabled; bypass
   yarn's build runner and run the native builds directly
   (`node_modules/.bin/prebuild-install` for `better-sqlite3`; use the prebuilt
   `xsnap-worker`). Capture this as a short `README`/notes file next to the
   probes so the next investigator reproduces the XS engine without yarn's
   build runner.

## Deliverable

- A branch on `kriscendobot/agoric-sdk` (suggested: `xsnap-debug-instrumentation`)
  containing the probe scripts under a clearly-scratch path (e.g.
  `packages/xsnap/debug-instrumentation/`) plus the build-workaround README.
  Pushed to the **bot fork**, no PR.
- If you also capture the Endo bisection probe, put it on a bot-owned Endo fork
  branch, same shape, no PR.
- A `result` journal entry naming the fork branch(es) and the files captured,
  so the artifacts are discoverable later.

## Notes

- This is preservation of diagnostic scratch, not a feature: no tests/CI gate,
  no gamut, no judge. Keep the commit messages plain and bot-identity.
- If the scratch files are already GC'd, reconstruct the probes from the
  investigation report's "Deliverable findings" and "Artifacts" sections — the
  measured limits and frame-cycle names are recorded there.
