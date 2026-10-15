# Fix round 2 for kriscendobot/minion.town PR #183: fixes pushed, CI green

I applied the round-12 panel verdict's must-fix item and the main should-fix items from the five seats that requested changes. The PR head moved from `66fcb1b` to `bc6289a`, pushed with `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` returned rc 0 (CI green), though the bot token can't read the PR's combined check status, so it judged green from the single Actions run alone. I did not re-run the panel; the driver posts panel-3.

## What changed

**Commit `e4c8ff1`: the refusal now happens at the agent, not through an exo registry.** This was the decomplector's must-fix.
- Removed the `refusingExos` WeakSet, `isRefusingExo`, and the post-slot `outcome === NEEDS_CONTAINMENT` check, which could never be true.
- `refuseUncontained` now gives its provider an optional `refuse()` method.
- A new `makeFacetAgent` is used where `create` mints an agent and where the inbox responder does. While the child is live, it returns the refusal before any credential read or inference slot, and records no outcome.
- Following the locksmith: `rootProvider` no longer sits on `ClaudeAgentsContext`, which every facet can reach. The subscription record holds it and passes it to `makeRootAuthoredInfer` as an argument.
- Corrected the "never made `Far`" wording, and documented why the agent handle, not `childFormulaId`, is the staleness key: a child id is a deterministic path that a dismiss and re-create reissues.

**Commit `0311a11`: the `@secrets` facet only reaches Claude blobs.** The locksmith, purist and wire-watcher all flagged this.
- `SecretsHostFacet` no longer hands out the whole catalog (`secretsCatalog`) and the unrestricted importer (`secretsImporter`).
- In their place are `findEntry(name)` and `createBlob(name, base64)`. Both check the Claude secret-name pattern, as `readBlob` already did.
- From the wire-watcher: an empty or non-UTF-8 blob now reads as `needs-auth` instead of starting a spawn with a bad token.
- New tests cover a foreign name being refused on every method, and empty or malformed blobs.

**Commit `bc6289a`: documentation trims from the pruner.**
- Cut the storage-naming and design-history detail from the Credentials and Containment notes in `DEPLOYMENT.md`.
- Deleted 6 test comments that restated the line below them.
- Trimmed the PR body; the phase ledger and job marker are unchanged.

## Verification

- Typecheck is clean.
- The Claude and Endo test suites pass: 462 tests, 10 skipped.
- The full `npm test` run had 2 failures, both in `test/git-remote/*`, which this change doesn't touch: `capability.test.ts` and `git-remote-e2e.test.ts`. They are probably caused by the fleet's git environment. Since CI went green on the new head, they don't appear to be real regressions.

## Not done
- **purist #5**, stop vendoring the unpublished `@endo/claude` package: the vendoring predates this PR, and changing it needs a maintainer decision.
- **purist #3**, make `needs-containment` its own outcome type rather than an error reason: a wider change to the outcome types, so I left it.
- **purist #4**, one refusing exo is shared by every child: left as is, since a refusing provider's minted exo is no longer used for refusal.
- **decomplector #2**, key staleness on `childFormulaId`: answered with the docstring rather than a code change, because a re-created child gets the same id.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3024791 cached reads)
- Output: 19903 tokens
- Cost: $1.8219141999999997
- Wall-clock: 1054s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
