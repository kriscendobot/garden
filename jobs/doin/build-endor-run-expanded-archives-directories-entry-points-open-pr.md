---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Open the draft PR for the `endor run` form-override and `--cas-dir` slice of the endor-run-expanded design in endojs/endo-but-for-bots. The predecessor job `build-endor-run-expanded-archives-directories-entry-points` did the work, but its host (oros-studio-garden-ce242c49) gets a 403 on `createPullRequest` for endojs. Do NOT change any code. Both branches are already pushed to endojs/endo-but-for-bots:

- head `feat/endor-run-form-flags-cas-dir` at `14af3028a`, one commit "feat(endor): --zip/--dir form overrides and --cas-dir for endor run" on top of #1521's head `0300b55f9` (stacked; #1521 merges first)
- base `llm-f02cd81`, the same frozen base #1521 targets

Steps:
1. Get a project checkout keyed by THIS job's base: `scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots feat/endor-run-form-flags-cas-dir`. Confirm `git rev-parse origin/feat/endor-run-form-flags-cas-dir` starts with `14af3028a` and `git merge-base` with `origin/llm-f02cd81` is `f02cd81b2`. If the branch has moved, stop and report.
2. Write the PR body below, everything between the BODY markers, to a file. With cwd set to that checkout, run:
   `scripts/jobs/gardening/ensure-pr.sh build-endor-run-expanded-archives-directories-entry-points endojs/endo-but-for-bots feat/endor-run-form-flags-cas-dir llm-f02cd81 --title 'feat(endor): --zip/--dir form overrides and --cas-dir for endor run' --body-file <file>`
   Pass the PREDECESSOR's base as the first argument so the body carries its `garden-job` marker and a retry adopts the PR instead of duplicating it.
3. Confirm the PR is a draft with the right head and base. Name the PR URL in your completion report so the gauntlet stages.

-----BEGIN BODY-----
Refs: `designs/endor-run-expanded.md` § CLI changes and design decision 5. Stacked on #1521.

## Description

`endor run` gains the explicit form flags and the CAS location flag the design lists.

- `--zip` and `--dir` replace extension and magic-byte detection. A ZIP behind a self-extracting stub does not start with `PK\x03\x04`, so detection cannot place it, but `--zip` runs it. Conflicting form flags, a form flag with `--cas <hash>`, or a path of the wrong type exit 2. A file that detection cannot place now gets a message naming `--zip` instead of "input not found".
- `--cas-dir <path>` selects the CAS for ZIP, directory, `--cas`, and `--node-modules` runs. Before this change the parser skipped the flag and then ignored it. The default is unchanged.

The decision most worth reviewing is that the default registry resolver rejects `--cas-dir` instead of honoring it. Its registry table records hashes that live in the daemon's CAS, so moving one without the other would strand the table's entries.

Out of scope: `--entry`. Every file that detection does not already send to the entry form has an extension both entry resolvers refuse, so the flag would change only the error message. It first needs a module-language rule for extension-less entries.

This branch carries #1521's commit and merges after it. Only the top commit is new.

### Security Considerations

None. `--cas-dir` writes only where the caller points it.

### Scaling Considerations

None.

### Documentation Considerations

`endor help run` and the design's Status section describe the flags.

### Testing Considerations

`run_input` unit tests pin parsing and override resolution. `tests/endor_run_cli.rs` drives the built binary: a stub-prefixed ZIP, `--cas-dir` ingest and replay, and each usage error. Those tests fail against the previous `endor.rs`. Like the rest of the `endo` crate, they are not in CI and were run locally.

### Compatibility Considerations

A run that passed `--cas-dir` now uses that store, or exits 2 under the registry resolver. Otherwise this change is additive.

### Upgrade Considerations

None.
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T04:24:03Z
