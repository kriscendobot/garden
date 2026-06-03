---
ts: 2026-06-03T05:38:26Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/03/053540Z-dispatch-liaison-04ea20.md
---

Reshaped endo-but-for-bots#411 to workflow-only scope. The PR previously
carried three files: the `.github/workflows/browser-test.yml` cache+retry
change (kept) and an exact Playwright pin (`^1.49.1` to `1.49.1`) in
`browser-test/package.json` plus its lockfile (dropped). The pin conflicted
with and regressed naugtur's open upstream PR endojs/endo#3254, which bumps
Playwright to a current release for security.

Procedure: tagged the pre-rework tip `b82249e1c`, `git reset --mixed` to the
frozen base `master-ba26f4c`, restored the two pin files to base via
`git checkout origin/master-ba26f4c -- ...`, reworded the now-stale in-workflow
cache comment, committed the single-file change, force-pushed with lease, and
deleted the tag.

Comment reword (the old text claimed the pin was exact):
old: "is keyed on `browser-test/package-lock.json`, which moves only / when
`@playwright/test` itself moves (the pin is now exact, not / a caret range),
so a Playwright version bump invalidates the / cache on the same commit that
lands the bump."
new: "is keyed on `browser-test/package-lock.json`, which moves when / the
resolved `@playwright/test` version changes, so a Playwright / version bump
invalidates the cache on the commit that lands it."

New #411 head SHA: `fca14cd14bd5c642a510d567dac51110ad4b924a`.
Net diff vs base `master-ba26f4c` is the single file
`.github/workflows/browser-test.yml` only; the pin-file diff is empty (pin
fully dropped); commit message carries no trailers.
Force-with-lease push: `b82249e1c...fca14cd14 (forced update)`.

Bot-side PR record updated: title set to
"ci(browser-test): cache Playwright browsers + retry install" (dropped the
"+ pin version"); body rewritten to the cache+retry scope, dropping the
"Pin @playwright/test exactly" section and adding a scope note that the
Playwright version pin is intentionally left to upstream security PR
endojs/endo#3254. Did not touch endojs/endo.

Self-improvement: nothing this time. The frozen-base reset-and-restore
pattern for dropping a subset of files from a PR while keeping the net-diff
invariant is already well covered by skills/retcon and the frozen-base-branch
skill; this dispatch was a clean application with no friction worth encoding.
