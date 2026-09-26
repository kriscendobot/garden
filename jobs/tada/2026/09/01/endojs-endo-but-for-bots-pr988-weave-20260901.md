The weave is complete. Report:

---

## Weave of endojs/endo-but-for-bots#988 — daemon commit-formula design PR

**Outcome: rebased and mergeable.** Not superseded — revived, not closed.

### What I did
- Fetched current `llm` (`b067f22869`) and rebased the PR's 5-commit chain (`design(daemon): define byte-stable Git commit formulas` + panel rounds 1–4) onto it. All 5 commits preserved (no squash).
- Resolved the `designs/README.md` conflicts. The stall's root cause was a **structural** conflict: since 2026-08-14, `llm` adopted a new grooming convention — historical "Layered on …" groom notes and superseded totals blocks were moved out of `README.md` into a new `designs/ARCHIVE.md`, and the index now keeps only the single current-totals block. The PR predated that and layered a new groom note + stale totals block at the top of `README.md`. I honored both sides:
  - **Groom note** → moved to `ARCHIVE.md`'s *Historical groom notes* section (newest-first), carrying the panel-round-1 wording fix (`git` → `Git`, `.` → `;`).
  - **Summary-table row, mermaid dependency-graph node/edges, M3 constituent row, and per-design estimate row** for `daemon-commit-formula` → kept in `README.md`, reconciled against `llm`'s updated statuses (e.g. the git trio now *In Progress*, `exo-git-follow-root-advancement` present).
  - **Stale totals blocks** (the PR's 2026-08-14 / 2026-07-30 counts) → dropped; the 2026-08-29 rolling-index current-totals block on `llm` is now authoritative. Appended a `2026-09-01` increment line documenting the `daemon-commit-formula` addition (Proposed 39→40, design count 194→195), matching the running-increment style already in the file.
- Verified: no conflict markers remain; the design doc `designs/daemon-commit-formula.md` is byte-identical to the pre-rebase PR head; all mermaid graph node ids referenced by the new edges are defined exactly once. `prettier --check` passes on all three files; both README mermaid fences parse (`flowchart-v2`, `gantt`) via parse-only validation.
- Force-pushed (`--force-with-lease`) to `kriscendobot:design/daemon-commit-formula`. **Left draft** — un-drafting is the gauntlet's job.

### State
`#988` now reports `mergeable: MERGEABLE` (was `CONFLICTING`), `isDraft: true`, base `llm`. `mergeStateStatus: UNSTABLE` reflects CI just re-triggered on the push — a CI/gauntlet concern, not a weave residual.

### Supersession assessment
**Not superseded.** The design specifies the byte-stable Git *object* DAG (tree/commit/tag serialization, SHA-1/SHA-256 OID projection, orphan-commit envelopes, CAS ref updates) — the object-store seam a real git remote must project. Nothing that landed since 2026-08-14 covers this: `npm-registry-as-directory-tree` and `npm-dev-publisher-attenuation` are npm-registry work, and `exo-git-follow-root-advancement` is fs tree-identity/root-follower work. If anything, the git trio moving to *In Progress* makes this foundational piece more relevant, not less. Revive was the right call.

### Downstream minion.town git-remote follow-up
**Unblocked at the design level.** The sentinel's question ("has #988 advanced?") is now answerable "yes": the conflict that stalled it is resolved and `#988` is mergeable and ready to run the gauntlet. Strictly, the minion.town CAS-native git-remote follow-up depends on `#988` *merging* to `llm` (the design defines the byte-stable seam it builds on), so it can proceed once `#988` lands — the weave has cleared the only obstacle that was deferring that indefinitely.

### Follow-ups
- Run the gauntlet on `#988` (clean → panel → fix-loop → un-draft), then merge, to fully release the minion.town follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr988-weave-20260901.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4413514 cached reads)
- Output: 26503 tokens
- Cost: $4.043349999999999
- Wall-clock: 441s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
