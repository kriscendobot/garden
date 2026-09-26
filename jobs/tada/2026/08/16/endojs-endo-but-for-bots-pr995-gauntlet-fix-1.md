Inbox empty. The FIX round-1 stage is complete: panel must-fixes applied, pushed to the PR head, CI green.

## Completion report

**Job:** endojs/endo-but-for-bots PR #995 — gauntlet FIX round 1 (design PR `designs/endo-claude.md`).

**Panel verdict addressed:** 7 seats, all request-changes. The convergent finding was that the design's confinement mechanics contradicted the runnable Claude Code CLI (2.1.232). Applied all six must-fixes plus the mechanical should-fixes, as prose/spec edits to the design doc and its README index:

1. **`--bare` vs subscription-OAuth (mutually exclusive).** Under `--bare`, `claude` reads no `CLAUDE_CODE_OAUTH_TOKEN`. Reworked the credential story: the pooled `ClaudeCredentials` is presented via an `apiKeyHelper` in a minimal generated `--settings` file (the sole escape `--bare` honors), and the subscription-vs-metered question is now named as the load-bearing residual to verify — not an asserted OAuth path that was measured not to work. Updated the flowchart injection edge, flag table, § Relationship, § Pooling, and Design Decision 5.
2. **`--strict-mcp-config` takes no argument.** The path belongs to `--mcp-config`; `--strict-mcp-config` is boolean. Fixed the argv diagram, flag table (split into two rows), prose, sequence diagram, package tree, and README estimate row.
3. **No deny-by-default `--permission-mode`.** Replaced the fictional mode and the self-nullifying `--disallowedTools "*"` with an explicit built-in deny set (disjoint from the `mcp__` allow set, so deny-over-allow precedence never cancels the allow-list), stated the precedence, and added a required live negative-confinement test.
4. **One designator.** `infer` now takes the guest **formula id**; the allow-list derives from the bridge's `tools/list` catalog (one value, cannot drift); stdio vs HTTP isolation topologies separated (fixing the novice's incompatible-topology must-fix).
5. **README authoritative totals synced** (150→151 designs, Not Started 39→40); M6 note re-attributed to P1 only; dependency-graph prerequisite edge made solid.
6. **Prose/spec:** introduced the "garden" fleet analogy, fixed the `least-recently- burned` soft-wrap, mermaid participant quotes, `-ly` hyphenations, cross-reference heading names, the refuted open-question premise, and the unlocatable error-taxonomy precedent.

**Verification:** all four mermaid diagrams re-validated with `mermaid.parse` (flowchart + sequence in the design; flowchart + gantt in README). 

**Push:** rebased over a concurrent peer commit (`60e6c5bca8`, no conflicts, no reintroduced errors) and advanced the head to `8ae8b364a8` via `safe-push-pr-head.sh`.

**CI:** `ci-wait-merge.sh … --no-merge` returned rc 0 — 5/5 checks green, 0 failed.

Stopped here per the stage contract (did not re-run the panel; the driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 131 tokens (8290526 cached reads)
- Output: 56491 tokens
- Cost: $7.078509999999999
- Wall-clock: 1268s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
