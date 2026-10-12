I applied all six must-fix items from the round-1 panel review on PR #183, and CI is green on the current head.

**Pushed** (three follow-up commits, 8428fb3 → 3c1cd39). A peer then added 80f4853 on top, a cosmetic test-parameter tweak; CI ran green on that head, which includes my commits.

1. **The state file could point a subject at another secret (locksmith).** `readSecret` now works out the secret's name from the subject itself and ignores the name stored in the state file. If the stored name doesn't match, the record reads as `needs-auth` and is logged without the token. A test covers it.
2. **The gate's wiring had no test (prover).**
   - I moved the code that builds the root seams into an exported `claudeCliSeamsOver`, so a test can check that `providerFor` is gated.
   - The tools test now uses a gated backend. The root MCP `infer` tool reaches the backend, and the same agent's far-callable `infer` gets `needs-containment`.
   - I reverted each of the three wiring changes in turn (`agents.ts` label, `cli-deployment.ts` gate, `guest-tools.ts` root-authored path). Each revert makes a test fail.
3. **No deprecation step for the gate (migrator).** `DEPLOYMENT.md` now records it as a breaking change. It lists the in-repo callers that now get `needs-containment`: the inbox responder caplet, `inbox-watch.ts`, and the `/_internal/claude/infer` by-name path in `wiring.ts`. It says why there is no flag, and that moving tokens off the old records is one-way, so a rollback leaves those subjects needing to re-run `setup-token`.
4. **No test for migrating old `version: 1` records (corner-prober).** New tests cover:
   - active and pending records;
   - a secret that already exists in active and in revoked state;
   - a safe retry after the record rewrite fails once the secret is stored.
5. **Overlapping first reads could collide (corner-prober).** Every vault operation on one subject now runs alone, in arrival order. Tests run reads concurrently with `Promise.all` and overlap `store`/`store` and `store`/`revoke`. With the serialization removed, the two overlap tests fail.
6. **PR body padding (pruner).** I removed the "What to attend to" and "Out of scope" sections and added a short "Breaking change" section. The evidence ledger and the job marker are unchanged.

I also took one should-fix item: the gated object is now frozen so its `infer` can't be swapped, and it treats `null` options as unlabeled. There are tests for that, for case and whitespace variants of the origin label, and for `cancelled` being passed through. The log check now asserts that no log line contains the prompt.

**Checks:** typecheck is clean and `npm test` passes except one test, `test/git-remote/capability.test.ts`, which fails locally. That file isn't touched by this PR and passed in CI. `ci-wait-merge` returned rc 0 with 3/3 checks green.

**Follow-ups:** I didn't take these should-fix items, and the next panel round may raise them again:
- Pass the vault narrower capabilities instead of the whole root host.
- Replace the module-level `inferRootAuthored` registry with a capability held only by the root session.
- Give the refusal its own result type instead of reusing `error`.
- Map `auth-failed` explicitly in `toMinionOutcome`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3849287 cached reads)
- Output: 23485 tokens
- Cost: $2.1498054
- Wall-clock: 1345s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
