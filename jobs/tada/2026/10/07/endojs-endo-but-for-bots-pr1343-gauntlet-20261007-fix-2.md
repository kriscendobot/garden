Fix round 2 for endojs/endo-but-for-bots#1343 is pushed and CI is green: all 26 checks pass at head `d2cf543e4`. The final `ci-wait-merge` exited 0.

**What I fixed** (four follow-up commits on `issue982-build-special-names`, `647d77050..d2cf543e4`):
- **Must-fix (saboteur 1, breaker 1): a special endowment could be silently dropped on the provisioned path.** The exact sequence the panel described was already blocked: "cannot add authority to an existing unprovisioned guest" fires before any record is written. A new test now locks that in. The window that really was open was a guest created concurrently between that check and guest creation. I closed it: a newly written policy record now passes `specialOnCreateOnly` through the provisioner's `makeGuest` callback, so that case throws instead of quietly keeping the default `@main`.
- **One gap remains:** if that race does fire, the policy record has already been written and is not rolled back. The call fails loudly, but the leftover record could later reconnect to the wrong guest. I said so in the PR comment rather than calling it fixed.
- **`@main` must be a worker (saboteur 2, purist 1, breaker 3).** Special endowments now go through one shared `resolveSpecialEndowment` helper in `host.js`, used by both the unretained path and the provisioner. It rejects a missing source, as before, and an `@main` that doesn't resolve to a worker.
- **Wrong error for a changed special path (breaker 2).** A retained guest that is re-provided with a different special path now gets the policy-violation error before anything is resolved, not `ENDO_SPECIAL_NAME_SOURCE_UNAVAILABLE`.
- **Duplication and naming (purist 3/4, typist 2).** The `@` split is now one exported `partitionEndowments`. The internal `makeGuest` option is renamed `resolvedEndowments`.
- **Docs (changeset-auditor 1, pruner 1–2).** I reflowed the changeset and the README endowments section to one sentence per line, and dropped the formula-graph internals from the README. The README now also notes that repeating a special endowment is an error for an unretained guest but accepted for a retained one.

**Tests:** I added three cases: the `@main` worker check on both paths, the late-authority sequence, and the changed-path error. `test/provision-lifecycle.test.js` passes 11/11 locally on Node 24. Node 22 is the default here and can't start the daemon because of the better-sqlite3 native module. Lint, prettier and type checks are clean.

**CI:** the first push failed on a type error that my local check missed; I fixed it in the last commit. After that, `test (24.18.0, macos-15)` failed once in a `packages/chat` command-selector UI test, which this PR doesn't touch and which passed on the previous head. I reran that one job and it passed.

**Declined or deferred** (all explained in the PR summary comment):
- **Pruner 3:** the credential sentence it wanted removed is from the base README, not this PR, so it stays.
- **Integrator 1–3:** squashing the two `fixup!` commits, regrouping the commits, and moving the `→`/`->` changes out of `help.md` all need a history rewrite. That belongs before un-draft, not in an add-only fix push.
- **Integrator 4 and purist 2:** the agentry `introducedNames` → `endowments` sweep is a follow-up.
- **Assessor 1–2:** pinning special ids during creation and rejecting duplicate `--introduce` keys are should-fix hardening and not done.

The summary comment that scribe asked for is at https://github.com/endojs/endo-but-for-bots/pull/1343#issuecomment-6048082175. It was written before the type-fix push, so it names head `0f0b8f9a4` and says CI was still running.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 140 tokens (7323392 cached reads)
- Output: 28351 tokens
- Cost: $3.1065303999999996
- Wall-clock: 5335s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
