---
handed-off: run-the-gauntlet-minion-town-pr90
deliverable-complete: false
---
All work is durable. Core build deliverable complete and deployed; the residual review-to-undraft loop (which a 29-seat panel exceeding the reaper window can't converge in-session) is owned by a posted, verified successor. Emitting the completion report and honest handoff.

---

## Completion report — `build-minion-town-clip-shell-framework`

**Built** the greenfield clip app-shell for `kriscendobot/minion.town` as **draft PR #90** (head `build/clip-shell-framework`, base `main`, latest `69a3852`), design doc landed **alongside** the build (it carries a non-empty `## Open questions`, so the PR *is* its review surface):

- `designs/clip-shell-framework.md` — clip-gutter model, iframe/ocap.site boundary, the unforgeable-chrome property, axis-based responsive rule; mermaid diagram (parse-validated); `## Open questions`.
- `deploy/aws/www/shell.html` + `shell.js` (factory-function/template-literal style borrowed from `@endo/chat`'s spaces gutter, no framework): gutter of clips with a `+` add button (self-describing placeholder clips), an iframe main pane, and a bottom-left settings/auth overlay consolidating login/logout, account/role, credits (Stripe), and guest formula id — today's `index.html` surfaces behind one entry point.
- **Unforgeable chrome:** overlay painted in the top document above the iframe's stacking context (`isolation: isolate` + `position: fixed` + max `z-index`), speech-bubble grown from the bottom-left corner button; PR body/design state precisely why (z-order layering holds in both layouts; corner-anchor is landscape-strong).
- **Responsive:** pure-CSS `@media (max-aspect-ratio: 1/1)` — gutter left in landscape, bottom bar in portrait, chosen by the shorter axis.
- **Theming:** `color-scheme: light dark` + `prefers-color-scheme` across all regions; `shell.html` added to `test/dark-mode.test.ts`.

**Deployed live** (SSM) at **`https://minion.town/shell.html`** — gated by the existing login (opt-in by URL), `/` (`index.html`) untouched. Verified live; the gated route now also serves `Content-Security-Policy: frame-ancestors 'none'` + `X-Frame-Options: DENY` (anti-clickjacking). Also **fixed `deploy/aws/scripts/deploy-www.sh`** (per-file SSM) which previously overflowed the ~100 KB `SendCommand` ceiling.

**Reviewed hard:** ran **four** full panel rounds; addressed every must-fix each round with verified fixes (inert pane / no live `src`, base32-label record validation, escaping, fail-closed sandbox + inline frame-bust + CSP header, deploy-payload ceiling, animation reflow, guarded account wiring, double-submit + non-JSON checkout handling, dedupe, landscape grid-row, renames, 30 regression tests). typecheck + all 7 pre-push gates green (`GARDEN_YARN=npm`); 321-test suite passes.

**Deferred (named follow-ups):** real clip minting via the guest publish path (`publish.ts` `@sites`); live `*.ocap.site` framing (needs the per-clip isolation-floor relaxation — Open q#1); a shared `account.js` deduping `index.html`/`shell.js`; account-scoped clip storage; canonical base32 id minting; reconciling the clip-id model against PRs #85/#88 (fresh-id-on-upgrade).

**Why handoff:** the build deliverable is complete and deployed, but a 29-seat panel runs ~20 min — longer than this host's reaper window (6 requeues this run) — so the panel-fixer loop cannot reach a clean disposition + un-draft within a single session, and only a clean panel may un-draft. I posted the durable successor **`run-the-gauntlet-minion-town-pr90`** (verified on `origin/journal2`) which owns the residual panel-verification → fixer-loop → un-draft, with the full recipe (detached panel, `GARDEN_YARN=npm`, rebase-before-push, deploy steps, the deferred-items list). PR #90 remains draft.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-clip-shell-framework.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 1 host(s)
- Input: 592 tokens (80723855 cached reads)
- Output: 279416 tokens
- Cost: $61.298581250000005
- Wall-clock: 4851s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
