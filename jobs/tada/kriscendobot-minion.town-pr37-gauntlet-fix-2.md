Applied the panel's round-2 must-fix items to `designs/ocap-mailboxes.md` (PR #37, `kriscendobot/minion.town`), pushed as a follow-up commit, and CI is green.

## What I did

Read the latest panel verdict (gauntlet iteration 2, disposition **must-fix**) and applied every request-changes finding:

**critic**
- **Bearer-token leak (must-fix):** §8 published the raw handle formula id as the email local-part while claiming it was "not a bearer reference" — but the project's own companion (`mcp-endo-guest.md` §4.3) redeems a formula id as a bearer credential via `GatewayBootstrap.fetch(token)`. Changed the local-part to a **one-way keyed digest** of the formula id (`<digest(formula-id)>@minion.town`): non-redeemable by construction, while preserving the maintainer's derive-from-handle / no-vanity-allocation / lifetime-coupled properties. Rewrote the "why not a breach" paragraph and propagated the notation through §§8–9,11.
- **Adapter guest lifecycle (must-fix):** specified the synthetic email-backed guest's provisioning — one shared domain adapter (default; sole SES-authority holder), plus a guest-elected personal adapter as the exception with `thisDiesIfThatDies` lifetime.

**skeptic + decomplector** (same core finding on §4)
- Named the **membrane split** reconciling "pass-invariant identity" with "per-grant revocation": a per-grant revocable *forwarder* over a stable *correspondent-identity presence*, with `===` ranging over the presence, never the forwarder. Updated the prose, the revocable bullet, and the §4 diagram.
- **Keyed audit digest:** §6's "digest not content" now mandates a keyed HMAC (key outside `admin.audit`'s reach) to defeat offline dictionary attack on low-entropy bot-to-bot mail.
- **Success-path timing leak:** named email-latency-vs-CapTP fingerprinting alongside the existing bounce-timing leak in §5, and qualified §1's indistinguishability claim as interface-level.

**decomplector** — split `admin.identity` into `admin.mint` / `admin.revoke` (table, prose, diagram).

**novice** — clarified v1-only vs deferred breaker trip conditions (§5); glossed "exo" and "formula-id" on first use.

Also folded quick comment-only fixes (copyeditor comma splices / "are an edge" category error, pedant stray ampersand, ergonomist canonical `E(handle).send(msg)` call shape).

## What changed
- One commit `f2f5441` on `design/ocap-mailboxes`, docs-only (`designs/ocap-mailboxes.md`). Pushed via `safe-push-pr-head.sh` (advance mode, clean fast-forward).
- CI: **green** (rc 0).

## Follow-ups / notes
- The keyed-digest local-part **refines the literal maintainer directive** ("the local-part *is* the formula id") for the named security reason; the doc flags this explicitly and leaves the maintainer free to override (or to instead prove namespace separation). Worth the maintainer's eye on the next review pass.
- Per the stage contract I did not re-run the panel; the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr37-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3953270 cached reads)
- Output: 34526 tokens
- Cost: $3.782854999999999
- Wall-clock: 548s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
