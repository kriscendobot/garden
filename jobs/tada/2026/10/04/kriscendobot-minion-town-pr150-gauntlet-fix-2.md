**Fix round 2 for kriscendobot/minion.town#150 is pushed and CI is green.** The new commit is `979cb4a`, added on top of `6dd243b` with `safe-push-pr-head.sh` (no history rewritten). `ci-wait-merge` returned rc=0: all 3 checks passed.

Must-fix items from the panel-2 review, all applied:
- **No test for the root-subject gate (prover):** I moved the per-session gate out of `createApp` (in `src/http.ts`) into an exported `makeClaudeAgentsFor` in `src/endo/claude/wiring.ts`, and added tests:
  - a non-root, prefix, longer or empty `sub` gets nothing;
  - with the Claude wiring off, nobody gets the tools;
  - a failed formula lookup is retried, and the resolved handles are cached.
  The panel's mutation, which lets any authenticated caller through, now fails these tests.
- **`MemoryMax` sizing assumed at most two Claude processes (saboteur):** that assumption now holds. In `handleSetupToken`, the plan-derivation and confinement-probe spawns now run one at a time across the deployment. A gated test checks that overlapping connect submissions never run more than one spawn at once; it fails if the serialization is removed. I updated the unit-file and DEPLOYMENT.md comments to match.
- **Tool-name manifest (curator, surfacer):** `REGISTERED_MCP_TOOL_NAMES` now includes the `claudeForm` and `claudeAgents` groups. The coherence test in `test/endo-clip-tools.test.ts` mounts every optional registrar, and the golden list in `test/endo-mcp-tool-names.test.ts` is updated.
- **DEPLOYMENT.md (archivist):** it now quotes the exact boot log line, with its emoji prefix and `(ENDO_CLAUDE_ENABLED=1)`. It also notes that removing a root subject only takes effect for an open session after a restart.
- **Naming (stylist):** `guestFormulaId` is now `guestFormulaIdentifier`.
- **Trims (pruner):** shorter unit-file comment, `createApp` comment and `registerClaudeAgentsTools` JSDoc.
- **Missing summary comment (scribe):** posted on the PR, covering rounds 1 and 2 ([comment](https://github.com/kriscendobot/minion.town/pull/150#issuecomment-5982307843)).

I also made one comment-only change: `dismissClaudeAgent`'s description now matches what it actually does (it dismisses any named child in the account, not just ones this session holds).

**Checks:** `tsc --noEmit` is clean. Locally, `npm test` passed 805 tests and skipped 10. One test failed: `test/git-remote/capability.test.ts`. The panel says it fails the same way on an unmodified checkout, and my own notes record that as a known failure; I did not rerun it on clean `main` myself.

**Left for a later round:**
- the pruner's suggested PR-body edits;
- sharing one child-name check between the schema in `guest-tools.ts` and `isValidChildName` in `agents.ts` (integrator should-fix, fast-checker suggestion);
- a test for an unknown model name passed to `createClaudeAgent` (wire-watcher should-fix).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3388412 cached reads)
- Output: 21618 tokens
- Cost: $1.9357864000000005
- Wall-clock: 639s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
