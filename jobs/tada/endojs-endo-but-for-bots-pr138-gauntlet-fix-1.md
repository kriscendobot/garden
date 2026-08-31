PR head is still my fix commit `309b234de`; rollup remains empty ~3 hours after push. State confirmed. Here is my report.

---

## Gauntlet FIX round 1 — endojs/endo-but-for-bots#138

**What I did:** Applied the design-panel round-1 must-fix (and cheap should-fix) items to the design PR and pushed them as a review-feedback follow-up commit (`309b234de`, now the PR head).

**Changes (2 files: `designs/README.md`, `designs/ocapn-daemon-integration.md`):**
- **README migration-shim contradiction (critic #2 / skeptic #3, must-fix):** dropped the "migration shim from `@nets`" effort-row phrase that contradicted the design body's repeated "no migration shim" decision.
- **Broken `closes #118 b)` parenthetical (copyeditor #1 / pedant #4, must-fix):** fixed to `closes #118 item (b)` in both README rows.
- **ASCII "Layer cake" → mermaid (critic #3 / copyeditor #3 / pedant #2, must-fix):** converted to a `flowchart TD`; validated with `mermaid.parse` (OK flowchart-v2).
- **Em-dashes (pedant #1, must-fix):** rewrote every authored `—` as period/paren/colon; cleared all typist-hostile code points (`↑ ─ • → …` → `-> ...`), verified none remain.
- **Substance should-fixes:** specified the pre-handshake inbound Noise IK demux mechanism (SNI-style routing preamble, no trial decryption) for critic #1/skeptic #2; flagged the stale Noise-XX-vs-IK discrepancy in `ocapn-noise-network` (skeptic #1); added an inbound-identity-demux integration test for Decision #2; resolved Decision #9 delegation (child gets a fresh Ed25519 identity, not the parent's key) for decomplector; glossed the `llm` branch ref, reworded "flush"→"converge", normalized heading case, renamed the same-daemon sharing section.

An unrelated `packages/hex-test/package.json` reflow (from the yarn install reconcile) was reverted so it stayed out of the commit.

**CI:** The bounded `ci-wait-merge` (`--no-merge`) polled to its deadline reporting **"rollup empty (checks not attached)"** and returns **rc 4 (still-pending)**. Root cause: the PR is **CONFLICTING with its base `llm`** (I reproduced a real conflict in `designs/README.md`; base has advanced past merge-base `e56e9940d7`), so GitHub never builds a merge ref and attaches **zero checks** — confirmed still 0 roughly three hours after push. CI cannot go green here without a rebase; that is out of scope for a fix stage.

**Follow-up:** I messaged the maintainer (via the liaison) that #138 needs a **weave** (rebase onto current `llm`, resolve the `designs/README.md` conflict) before CI/merge can proceed, so the gauntlet doesn't loop re-posting fix stages. The panel must-fixes are done regardless.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr138-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 158 tokens (6490108 cached reads)
- Output: 37142 tokens
- Cost: $7.3193670000000015
- Wall-clock: 756s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
