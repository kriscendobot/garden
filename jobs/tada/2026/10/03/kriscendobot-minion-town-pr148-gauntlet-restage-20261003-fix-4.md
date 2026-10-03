Round-4 fixes for PR #148 are pushed to the head branch (`03dee45` → `4605078`, three commits), and CI on the new head is green (`ci-wait-merge` rc 0, 3 of 3 checks passed). The phase/evidence pre-pass still blocks this PR, so the next panel run will most likely return must-fix again (details at the end).

**Commits:**
- **`0b83343`: output cap (assessor, orthographer).** `cli-launch.ts` now reads a chunk's complete lines before checking the output-byte cap. A `result` that arrives in the chunk that crosses the cap now resolves `ok` instead of `limit-exceeded`. Added a fake-claude `capped` scenario and a regression test. Changed `signalled` to `signaled`.
- **`85cb779`: DEPLOYMENT.md (archivist).** Restored the base text, which fixes the `id_tokens` and Stripe secret-shape asterisks and the three dedented list lines. The file keeps only this PR's two real edits: the Claude CLI backend section and the `root-host-socket.ts` pin path.
- **`4605078`: confinement and cleanup.**
  - **Locksmith 1:** every spawn now also denies `mcp__endo__evaluate`, `mcp__endo__eval` and `mcp__endo__define` through `--disallowedTools`. The confinement probe fails if any of them appears in the session's tools.
  - **Saboteur 1–3:**
    - A stored credential is now pending until the probe passes. Only the probe can read it; status, plan models and inference see it only after activation.
    - A corrupt vault record is logged by file name.
    - The token check now sits inside `infer`'s `try`.
  - **Purist 1–5, surfacer, locksmith 5:**
    - Reuse the shared formula-identifier parser from `invitation-envelope.ts`.
    - Delete the unused `endo-claude.d.ts` and the empty bridge `close()`.
    - Key children by subscription as well as caller.
    - Move probe guests under `claude-probes/`.
    - Treat a malformed `ok` result as an error.
    - Harden the infer object.
  - **Pruner:** trimmed the bridge's 56-line module comment.
- **PR body (integrator 2 and 5):** it now describes the edits to all three designs, including the Prettier reflow, and names the one test that fails.
- **Summary comment (scribe):** posted at https://github.com/kriscendobot/minion.town/pull/148#issuecomment-5972834630, covering both the round-3 and round-4 fixes.

**Local checks:** `tsc --noEmit` is clean. Vitest: 776 passed, 10 skipped, 1 failed. The failure is `test/git-remote/capability.test.ts` › projectPartition › "propagates a git failure rather than reporting the ref absent". It is the test the PR body says also fails on `main`, and an earlier note from this host says the same. I did not re-run it on the base this time.

**Not done:**
- **Phase/evidence pre-pass (`non-deliverable-probe`, integrator 1).** No code fix can clear this. It needs the canary child's Phase 3–6 evidence, or the maintainer taking #148 out of the gauntlet.
- **Integrator 3 (regroup the commit history).** That means rewriting history, which this fix stage can't do because it may only add commits. It should happen before un-drafting.
- **Locksmith 2–3 and server-side filtering of the upstream tool list.** Still tracked in kriscendobot/minion.town#149.
- **Comment-only items (purist 6–7).** Not acted on.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (6127652 cached reads)
- Output: 30166 tokens
- Cost: $2.9596584
- Wall-clock: 574s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
