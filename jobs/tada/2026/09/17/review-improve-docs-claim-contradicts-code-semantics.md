All work is landed and verified. Here is my completion report.

---

## Completion report: `review-improve-docs-claim-contradicts-code-semantics`

Closed the `docs-claim-contradicts-code-semantics` review-miss cluster (docs-drift; PRs #475, #877, #264) by delivering **both** mandated halves. Landed as one commit `d5c13fcfe0` on `main2` (pushed, HEAD == origin/main2); cluster marked `closed` on `journal2` via the store writer.

### (a) Prevention — in the producing work
Both producers are doc-authoring roles (builder for README/source-comments, designer for design docs), so the norm lives fleet-wide:
- **`roles/COMMON.md`** — new section *"Definite technical claims in authored prose"*: every definite, in-repo-verifiable claim (API, format, export, behavior) in fleet-authored prose must be cross-verified against the authoritative implementation **and the doc's own other statements** before landing, or hedged as an explicit assumption. Formulated as a concrete check ("open the exports / the reference impl / the format writer and confirm; re-read the doc for a contradicting statement"), not a memory aid.

### (b) Durable review-cycle sensing — the archivist seat
Truth of a claim isn't mechanizable (it requires reading the code), so option 2 (seat brief + probe) is the right rung; the signal *detection* is mechanized as the probe.
- **`roles/jurors/archivist/AGENT.md`** — explicit "cross-verify every definite technical claim about an in-repo entity against the authoritative code (and the doc's own other statements)" operating norm.
- **`skills/panel-hints/probes/C-archivist-claim-accuracy.sh`** (new) — fires the archivist when an added line (README, any `*.md`, design doc, or source comment) carries a named in-repo entity (`@endo/*`, backticked dotted API / file / export, or archive-format term) **and** a definite-claim cue. Errs toward firing.
- **`skills/panel-hints/panel-hints.sh`** — wired the probe into the **design-panel** branch so the archivist cross-fires onto a design-only PR (the #264 gap: the archivist is absent from the seven design seats and probes previously never ran on design PRs). On a code panel the archivist is already always-on and is **never double-listed** (the `archivist-claim-accuracy` filename slug doesn't match the emitted `archivist`, same mechanism `C-typist-inline-import-jsdoc` uses). Probe + seat change in the same commit per the panel-hints convention.
- **`skills/panel-hints/SKILL.md`** — documented the design-panel cross-fire and added a notes-from-field entry.

### Re-litigation test (per member) — `scripts/jobs/test/docs-claim-accuracy-probe-test.sh`, wired into `.github/workflows/checks.yml`
Each member's exact check is the probe firing the archivist + the seat's cross-verify line; demonstrated firing on the real historical prose:
- **#475** → `packages/immutable-arraybuffer/README.md` brand-check prose. Probe fires on the real README diff at `caddaede83` (verified by hand against the bare clone) and on a faithful reconstruction of the maintainer-flagged "canonical brand check" line (the exact line was squash-merged away). ✅
- **#877** → the `archive-text-endowments-xs.js` header comment `@endo/base64` "deliberately does not provide" — fires on the exact buggy line at `6db54d5e8d` (fixed by `3a7f1dc077`). ✅
- **#264** → `designs/compartment-mapper-import-attributes.md` "typically a `tar.gz`" — fires on the exact line at `e7f1a9b89e` (reviewed head `9d68588c0`, fixed `db011c31a`). ✅
- **Negative controls** (abstain): claim-free motivation prose, an entity-pointer-only line (`See @endo/pass-style ...`), and a bare `import ... from '@endo/base64'`. ✅

Test result: `6/6 pass`. End-to-end `panel-hints.sh` verified on temp fixtures: design PR with a claim → archivist cross-fires (total 8); design PR without a claim → Cross-panel 0 (total 7); code PR → archivist stays in always-on only (no double-list). `shellcheck -S warning` clean on both new scripts; `bash -n` clean on all three changed scripts.

### Cluster close
`scripts/jobs/review-miss-record.sh cluster-status docs-claim-contradicts-code-semantics closed --improved-by "<commit + files>"` → `status=closed` (CAS push confirmed).

### Follow-ups
- None blocking. Minor observation (not routed as a separate lesson): the peer-added `sibling-family-probe-test.sh` (same day) is also not in the CI focused-test list; I only added mine. Someone may wish to add it too.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-docs-claim-contradicts-code-semantics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5974104 cached reads)
- Output: 43755 tokens
- Cost: $5.490189000000002
- Wall-clock: 720s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
