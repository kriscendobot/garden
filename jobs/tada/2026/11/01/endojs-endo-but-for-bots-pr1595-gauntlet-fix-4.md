I applied every panel-4 item on PR #1595 and pushed the fixes, and CI is green: all 36 checks ended with none failed.

**Pushed** to `kriscendobot:build-daemon-git-remotes-interactive-provisioning` with `safe-push-pr-head.sh`, moving the head from `a630f3b8d` to `dbcb13fc9`. Four follow-up commits:
- **`824a3c559` fix(cli):**
  - **Hidden characters (saboteur, breaker, wire-watcher, corner-prober, spec-keeper):** `--branch` values now reject control characters and Unicode text-direction markers. The blocked set now covers all of them, including U+061C, which was missing.
  - **Escaped output:** `inspect` escapes control characters in every value the daemon reports, including the credential audience.
  - **Revocation race:** if a remote is revoked while `inspect` runs, it is now reported as revoked instead of failing. Any other credential-check failure is still raised as an error.
  - **One rules path (decomplector, purist):** the approval preview now uses `normalizeGitRemotePolicy` from `@endo/exo-git`, the same rules the daemon enforces, and each profile is checked through it. That removes the CLI's own URL parser and push-target derivation, so `@endo/exo-git` is now a CLI dependency.
  - **Types (purist, typist):** the CLI reuses exo-git's types and also shows `defaultPullRef` and `allowLocalFileTransport`. The `GitRemoteProvisionOptions` type I had added to `@endo/daemon` is reverted; the CLI derives it from `EndoHost` instead. An active remote's inspection now must include a credential.
  - **Preview (prover):** `--yes` now also prints the preview to stderr. The integration test checks the endpoint, push target and unverified-credential line in both modes, and that the preview comes before the prompt.
  - README and changeset updated to match.
- **`2c0320dfb` test(daemon) (fast-checker):** randomized property tests (`@fast-check/ava`) for branch-selector handling (500 runs) and for the formula's push refspecs matching the normalizer (300 runs).
- **`ad369c3d4` docs(designs) (archivist, integrator):** `daemon-git-remotes.md` now records Phase 6 CLI provisioning and inspection as done, with form flows and trust-on-first-bind still open. `formula-inspector.md` now lists the `git-credential` and `git-remote` properties.
- **`dbcb13fc9` chore: Update yarn.lock.** `yarn install --immutable` passes with it.

**Regression evidence (prover):** added to the PR description. I broke each fix on purpose and confirmed a test failed each time:
- removing the branch check;
- dropping U+061C;
- turning off escaping;
- removing the revocation re-check;
- removing either stderr preview;
- making the formula report one push refspec too few.

All the breaks were reverted.

**Local checks:**
- The CLI `git-remote` unit tests (30) pass.
- The integration test passes under Node 24 only. Node 22 can't start the daemon here because the installed `better-sqlite3` was built for a different Node version.
- The daemon `formula-record` test (15) passes.
- eslint, the per-package `tsc` runs and the repo-root `tsc` show no errors for cli or daemon.

A fix-round comment listing what each panel finding got is on the PR: https://github.com/endojs/endo-but-for-bots/pull/1595#issuecomment-6550555241

**CI:** `ci-wait-merge.sh` returned rc 0. I ran it as a series of foreground calls, so the wait came to about 95 minutes rather than one 3600-second window. The macOS test legs took about 60 minutes, up from about 40 last round. I did not re-run the panel; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 164 tokens (10701461 cached reads)
- Output: 45407 tokens
- Cost: $4.3313362
- Wall-clock: 6085s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
