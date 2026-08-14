CI is green. All panel round-1 must-fix items applied, pushed as a follow-up commit, CI terminal green.

## Completion report

**Job:** Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #988 (`design(daemon): define byte-stable Git commit formulas`), a design-only PR.

**Panel disposition:** must-fix — 5 of 7 seats (critic, skeptic, decomplector, ergonomist, novice) returned request-changes; copyeditor and pedant comment-only. I applied all findings in one commit and stopped (no panel re-run).

**Changes to `designs/daemon-commit-formula.md`:**
- **critic (must-fix):** submodule gitlinks (mode `160000`) now a distinct opaque raw-OID (`gitlinkOidHex`) entry variant instead of requiring a resolvable `git-commit`, so repos with submodules / shallow boundaries ingest; stated the readable-tree default-mode rule recurses through nested subtrees and forbade mixing non-default modes under a `readable-tree`.
- **skeptic + decomplector:** `rawBase64` declared the sole hashing input with one construction-time derivation direction plus an explicit Git actor grammar for daemon-authored commits; Test Plan gained rejection cases for each Security bound (size/depth/entry-count/parent-count) and the reader-observed-stale-terminal race.
- **decomplector:** CAS `terminal` check made non-optional for direct refs (rejects binding-only comparison).
- **ergonomist:** added a `### Capability construction` section (states these are trusted daemon internals, no `provideX`); renamed `oidFor` → `computeOid`; added singular `get(ref)`.
- **novice:** defined Strategy A/B in the problem statement; glossed *name hub* / pet-store edge at first use; tied *selector* and `RefStore` to the locally defined types.
- **copyeditor/pedant:** five wording fixes; README `git`→`Git` capitalization and semicolon note-style fix. Kept the doc's established ASCII style (no em-dashes, no `±`) to avoid a fresh pedant finding.

**Out of scope / not done:** critic's mermaid-graph namehub-edge note was explicitly flagged comment-only/pedant-lane over a curated subgraph — left as-is.

**Push & CI:** committed `d9d22ef26`, pushed via `safe-push-pr-head.sh --mode advance` (`df8569c46 → d9d22ef26`); `ci-wait-merge.sh --no-merge` returned rc 0 — 5/5 checks, 0 failed, **CI GREEN**.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr988-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3243299 cached reads)
- Output: 26097 tokens
- Cost: $3.100045499999999
- Wall-clock: 733s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
