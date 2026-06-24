---
ts: 2026-06-03T05:40:05Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/053540Z-dispatch-liaison-04ea20.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--e70021`) for stage 2: **first-time ferry** of the reshaped endo-but-for-bots#411 (workflow-only) to a NEW endojs/endo PR.

Source: bots#411 head `fca14cd14`, single commit `ci(browser-test): cache Playwright browsers + retry install` (endolinbot), frozen base master-ba26f4c == endo master `ba26f4cdb`, DRAFT. Touches ONLY `.github/workflows/browser-test.yml` (cache Playwright browsers + retry the install). The Playwright pin was deliberately dropped (stage 1) to avoid conflicting with / regressing naugtur's security PR #3254.

Boatman brief (Shape 1): detach at endo origin/master (`ba26f4cdb`); cherry-pick `fca14cd14`; `--reset-author` to `Kris Kowal <kriskowal@kriskowal.com>` (single author); RUN `git interpret-trailers --parse` on the commit and confirm EMPTY (standing trailer-strip gate — the #3295 incident this session is why this is non-negotiable); strip any `(#411)` suffix; new branch `kriskowal-browser-test-cache`; open the upstream PR with `--draft` (source is draft); body per pr-formation (the recurring browser-test Chromium-download timeout flake; cache + retry as the fix; behavior over diff; NO fork-side refs; do NOT cross-reference #3254 — external-repo etiquette, the bot-side body records the relationship). Post the garden-side mirror cross-link on bots#411. `identity_switch_authorized: true`.

(Process: do NOT write a message: boatman -> steward upstream cross-link — that two-way-mirror step was retired 2026-05-29; garden-side cross-link only.)

Expected report: new upstream PR URL + number, branch + head SHA, attribution + trailers-empty confirmation, CI status, garden-side cross-link comment id.
