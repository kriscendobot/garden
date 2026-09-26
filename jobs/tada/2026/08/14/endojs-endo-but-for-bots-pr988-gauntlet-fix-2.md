CI is green. All panel round-2 must-fix items applied, pushed, and CI passed.

## Completion report

**Job:** Gauntlet FIX round 2 for endojs/endo-but-for-bots PR #988 (`design(daemon): define byte-stable Git commit formulas`) — a design-doc PR.

**Panel round-2 verdict (request-changes)** from critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice. All must-fix items applied in one commit (`8adeb32cb`), pushed as a review-feedback follow-up to the PR head (`d9d22ef26..8adeb32cb`), CI green (5/5, 0 failed).

**What changed** (`designs/daemon-commit-formula.md`, `designs/README.md`):
- **Tree sort canonicalization** (critic, skeptic): stated Git's directory-suffix sort rule explicitly in the `git-tree` definition and in the byte-stable projection step; readable-tree children are re-sorted before serialization so a `foo.txt`-vs-`foo` collision can't yield a wrong OID. Added the collision fixture to the Test Plan.
- **Symbolic-ref bound** (skeptic): fixed hop-count + revisit detection under § Security and Lifetime; cyclic/overlong-chain rejection added to Test Plan.
- **Actor-line rejection** (skeptic): stated a non-conforming actor line rejects the whole object; added a non-conforming fixture.
- **CAS type** (decomplector, ergonomist): retyped `compareAndSwap`'s `expected` as a `FormulaRefExpectation` discriminated union — a direct ref without a `terminal` is now unrepresentable.
- **Interface chaining** (ergonomist): documented `resolve()`'s `FormulaIdentifier` as the cross-store currency (CAS terminal + projection memo key).
- **Union idiom** (ergonomist, should-fix): noted why `GitTreeEntry` discriminates on Git's native `mode` while `FormulaRef` carries an explicit `kind`.
- **Prose** (copyeditor, novice): defined "partition" at first use; split the tangled actor-synthesis sentence; fixed the ambiguous "This"; broke the five-field git-commit paragraph into per-field paragraphs; restated the default-mode rule inline instead of forward-referencing; stated the formula-path motivation up front; `envelopes`→`envelops`.
- **Sentence-per-line** (pedant): reflowed the whole file per CONTRIBUTING.md.
- **README graph** (critic): synced all five dependency edges into the flowchart (added `dgit`, `namehub` node + edge, `dcsgc`, `formula-inspector`). Verified the mermaid renders cleanly (each node once, no banned code points, no em-dashes/arrows).

**Follow-ups:** none — the driver re-posts panel-3. Stopped after one fix pass as instructed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr988-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3005028 cached reads)
- Output: 30410 tokens
- Cost: $3.259295
- Wall-clock: 854s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
