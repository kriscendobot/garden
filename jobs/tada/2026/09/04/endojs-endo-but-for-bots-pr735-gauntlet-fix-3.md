CI is terminal GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 3 — endojs/endo-but-for-bots PR #735 (design: Chat HTTP controller UI).

**What I did:** Read the panel-3 request-changes verdict (disposition **must-fix**, 8 juror blocks) and applied its findings to `designs/chat-http-controller-ui.md` and `designs/README.md`, verifying every claim against the landed `@endo/exo-http-client` source before rewriting copy. Pushed as one review-feedback follow-up commit (`c34b4d2796`) to the PR head `design/chat-http-controller-ui`, then watched CI to terminal.

**Substantive must-fix items (critic / skeptic / decomplector / ergonomist):**
- **Static-vs-pinned is not derivable from `listBindings()`** — the constructor pins every static origin (`decidedBy: 'constructor'`), so mere presence conflates the two. Rewrote the Policy narrative, § Layout 2, Design Decision 6, and the Test Plan to derive the mark from `Binding.decidedBy` (`constructor`/`controller` = static; `tofu-auto`/`pending` = pinned), and added the "report the static set" upstream ask to OQ5(c).
- **"Permanent deny" is false** — `removeAllowedOrigin`/`revokeBinding` is a *durable but reversible* deny (re-add overwrites the `Revoked` binding). Corrected the HttpClientControl table, § Layout 2/4, and § Modal interactions; added a **Re-allow** affordance; kept **Reset** on `Revoked` rows for recovery; scoped Reset off `constructor`/`controller` static rows and put durable narrowing acts under the same confirm bar (§ Boundary 4).
- **Bindings-panel visibility rule was always-true** — made the panel available to any control viewer (it holds the deny/revoke rows the allowlist can't), dropping the "TOFU-modes-only"/`strict`-string gate; fixed the mermaid node label and the "hidden in strict" test.

**Should-fix (cheap, clearly-correct):** softened the § Detection OQ4 interface-tag overstatement (self-asserted tag = entropy, not authentication); made the read-only tier confirm *every* off-allowlist send (it can't read the mode); qualified the persistence-boundary durability copy for the best-effort-persist gap + OQ5(d).

**Mechanical must-fix (pedant / copyeditor):** removed 5 em dashes and 2 U+2026 ellipses from the design doc; unbroke 9 hyphenated compounds split across hard wraps; split the two paired-method table rows and filled the blank `Returns` cells; fixed the README index entry (verb repetition, "without an error" vs "silently", 273-col line wrap, `revised` verb).

**Result:** CI terminal GREEN — 5/5 checks SUCCESS (browser-tests, build, lint, test, zizmor), `rollup-terminal … failed=0 → CI GREEN`, rc 0. Left the panel to the driver (panel-4) per the stage contract.

**Follow-ups:** none for this stage; the driver re-posts the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 160 tokens (8937270 cached reads)
- Output: 50518 tokens
- Cost: $8.481717999999997
- Wall-clock: 1937s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
