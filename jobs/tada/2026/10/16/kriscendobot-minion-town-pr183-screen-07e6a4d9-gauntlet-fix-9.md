I fixed the round-9 panel's must-fix items on kriscendobot/minion.town#183, pushed them as one commit, and CI is green on the new head.

**Push:** commit `6fd1d40` ("fix(claude): address panel round 9 findings"), pushed to `build/inference-phase3-secrets` with `safe-push-pr-head.sh`, which moved the head forward from `dff1ff8`.

**Must-fixes applied:**
- **surfacer 1:** `InferOutcome` (`src/endo/claude/classify.ts`) now includes `needs-containment`, with its own new `contained` class. The doc comment says only the agent layer produces it. Both classifier tests in `test/claude-reauth.test.ts` cover it, and the class table in `designs/claude-agent-credential-reauth.md` has a new row for it.
- **surfacer 2:** the root `infer` MCP tool description in `src/endo/guest-tools.ts` now says that path never answers `needs-containment`.
- **surfacer 3:** the `CredentialVault` doc in `types.ts` names its two implementations (the `@secrets` vault in production and the file vault in test helpers). It also says why there is no in-memory counterpart.
- **archivist:** `designs/claude-agents-capability.md` now describes the legacy-record move correctly: one pass before the vault's first operation, retried on the next operation if it fails.
- **migrator:** `DEPLOYMENT.md` already documented the breaking change. I added that the inbox responder does not loop on a refused message (each subscription delivers it once), and that nothing shipped in this repo relies on facet inference.

**Cheaper should-fixes also applied:**
- **saboteur 3:** `readLive` now logs the error class instead of silently swallowing a catalog fault.
- **stylist:** renamed the two shadowing `migrated` bindings to `migratedRecord` and `ensureMigrated`.
- **pruner 3 / typist 4:** removed a restated containment comment from `types.ts` and `guest-tools.ts`.
- **pruner 5 (PR body):** I rewrote the Why, Release note and Verification sections. The old release note gave the wrong refusal shape (`{type:"error", reason:"needs-containment"}`) and said migration happens on first read. The new text names the new authority the root `infer` tool gets (locksmith 3). The phase ledger is unchanged.

**Verification:**
- `npm run typecheck` is clean.
- The full vitest run had 1071 tests pass and 1 fail: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That file has nothing to do with this change, and the failure looks like a git quirk of this host. It passed in CI.
- CI: the single Actions run ("test (typecheck + vitest)") sat queued for about 12 minutes, then succeeded. `ci-wait-merge.sh` returned rc 0 (GREEN). It had to read the Actions runs API because the PAT can't read the status rollup on this host.

**Not done (left for the panel to raise again if still wanted):**
- locksmith 1: give facets a provider that cannot reach the backend, instead of relying on a runtime flag.
- saboteur 1 and 2: keep one bad record from blocking every subject, and scrub malformed legacy records that still hold a token.
- wire-watcher 1: tie probe trust to a digest of the probed token bytes.
- procurer: use `isRecord` from `@endo/pass-style` instead of a local copy.
- migrator 3 and 4: optional members for the new required fields, and a daemon-first deploy-order note.
- pruner 1 and 2: trim repeated narrative in source headers.
- surfacer 5: decide which `secrets-credential-vault.ts` exports are really public.

The PR stays draft (the pre-pass verdict is HOLD-DRAFT), and the driver re-posts panel-10.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2337639 cached reads)
- Output: 12513 tokens
- Cost: $1.3524118000000003
- Wall-clock: 1644s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
