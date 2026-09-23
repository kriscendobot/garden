CI is GREEN (rc 0). All five checks pass. The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #231 (`design(familiar): MVR release plan`)

**What this PR is:** A design-only change adding `designs/familiar-release.md`. The panel-1 verdict (disposition **must-fix**) came from four request-changes seats (critic, skeptic, ergonomist, pedant) plus comment-only seats (copyeditor, decomplector, novice). Nearly every finding was a stale/dead-citation defect from an audit never refreshed against the current checkout.

**Fixes applied (one pass), verified against the live repo state:**
- **Dead cross-references:** retargeted four `endo-gateway.md` links → `gateway-package.md` (its documented successor; `endo-gateway` was removed 2026-05-29 and folded into `gateway-package.md` — a more accurate target than the panel-suggested `endo-gateway-mcp.md`); `daemon-node.js` → `manager-node.js` (where `ENDO_EXTRA` actually lives); removed the dead `skills/verify-upstream-state.md` link (garden-library path that never existed in this repo).
- **Stale citations:** `agent.js` "line 1641" → 186; `bundle.mjs` "line 99" → 80; electron `^40.8.0` → `^43.3.0`; Node pin corrected from "v20.18.1" to the already-landed `v22.22.3` (skeptic).
- **G1 reconciliation:** rewrote G1 and its MVR row to acknowledge `familiar-release.yml` already wires the CI pipeline, so the remaining work is confirmation + per-PR build-smoke promotion, not authoring the workflow (skeptic).
- **Missing MVR deliverables:** added the Linux `chrome-sandbox` suid-setup doc row (critic must-fix) and the `familiar.log`/`endo.log` selection-rule note (ergonomist).
- **Test catalog:** added a Tier-1 assertion for the MVR exit criterion (exchange a message with `lal`) that no tier previously covered (skeptic).
- **G2 contradiction:** explicitly acknowledged the `xattr` workaround as a deliberate exception to the "no developer tooling" criterion (ergonomist).
- **Copyedits:** collide→join wording (G9), British→American spelling, CAS gloss, percentage form, novice bridge sentence, structural-promise reword, redundancy trims.
- Verified all relative links resolve; no non-ASCII/em-dashes introduced; bumped the "Updated" metadata.

**Deliberately not changed:** the `## What is the Problem Being Solved?` title-case heading (pedant should-fix) — it matches the established Endo design-doc template (e.g. `gateway-package.md` uses the identical heading), so "fixing" it would make this doc inconsistent with the corpus. The decomplector's field-conflation restructure (comment-only) was left as scope beyond a single fix pass.

**Follow-up for the maintainer/driver:** kriskowal's 2026-06-25 CHANGES_REQUESTED review raised a deeper design-level direction (rework how static assets bundle into the Familiar; the subagent-spawning workflow reshaping `lal` integration). That is a design-substance concern outside this panel-fix stage and remains open.

**Push:** `e6912e4a5 → 64eed591d` on `endojs/design/familiar-release`. **CI: GREEN** (browser-tests, build, lint, test, zizmor all pass; rc 0).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (4325256 cached reads)
- Output: 27540 tokens
- Cost: $3.980760000000001
- Wall-clock: 1013s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
