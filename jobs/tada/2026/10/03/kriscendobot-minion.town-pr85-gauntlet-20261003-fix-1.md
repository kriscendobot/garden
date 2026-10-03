Fix round 1 for https://github.com/kriscendobot/minion.town/pull/85 is pushed and CI is green at head `a9d7b3e`. Eight of the nine must-fix items are fixed outright; one is answered with documentation instead, because the gap it names is older than this PR and the PR cannot close it.

**Four follow-up commits on `feat/clip-upgrade-in-place`** (`a41d704..a9d7b3e`, pushed with `safe-push-pr-head.sh`):
1. **stylist** (`9ac8938`): renamed `dir` to `capabilitiesDirectory` in `upgrade-capability.ts` and its test.
2. **prover** (`e5b09b6`): the `assertUpgradable?.(...)` tests could never fail, because the live authority no longer has that method. They now assert the method is absent, which fails if the old "not yet supported" gate comes back. The misleading test title is fixed too.
3. **locksmith** (`9dafac7`, also raised as should-fix by breaker and wire-watcher): an unpublish landing in the middle of an upgrade could be undone, putting the clip back online. `publish.ts` now runs upgrade and unpublish of the same clip one at a time. A new race test fails without this change and passes with it.
4. **Docs** (`a9d7b3e`):
   - **migrator:** clips published before the capability table lose nothing. Before this PR, every upgrade on the live path threw "not yet supported". This is now stated in the code and the PR body.
   - **integrator (stale designs):** `clip-ocap-synthesis.md`, `clip-formula-id-origin-and-content-gc.md` and `clip-shell-framework.md` § 4 now describe live upgrade as landed. They cite the maintainer's 2026-10-02 request to cover both sides of upgrade.
   - **breaker / wire-watcher:** answered with documentation, not a code fix (see below).

**Why breaker/wire-watcher are answered with docs, not code:** I checked the pinned Endo daemon (`1706e632`). A guest's `storeIdentifier` and `lookupById` accept any formula id. A clip's hash is its directory's formula number, and the node suffix can be read from any guest's own `@self`. So any guest that knows a clip URL can already reach that clip's directory, read the publisher's `back` power, and rebind it, with no upgrade capability. This has been true since publish started using the formula number as the hash; this PR did not introduce it. Doing the `back` write from an operator-held authority, as the panel suggested, would leave the directory just as reachable. I recorded it as residual R3 in `daemon-site-registry.ts` and the `upgrade-capability.ts` header, and corrected the claim that "authority is the capability". The capability does gate the upgrade tool and the served content, since only the app writes the served record.

**PR body:** added a section reconciling this PR with the fresh-id design in #88. It cites the 2026-09-04, 2026-09-30 and 2026-10-02 maintainer messages, and says #88, if it lands, replaces this path (integrator and curator must-fix). It also:
- marks the new capability strings as temporary until the #142 lifecycle design lands;
- adds residuals for R3, pre-existing clips, the serialization, and the lack of revocation;
- fixes the stale base reference, uses full URLs for reviews, and links the design for § 3.4.

**Checks:** typecheck is clean. The full suite has 732 passed, 9 skipped, 1 failed; the failure is in `test/git-remote/capability.test.ts`, a known host-environment failure unrelated to this PR. CI ran with `ci-wait-merge.sh --no-merge` and returned rc 0 (3/3 green).

**Follow-ups:**
- **Decision needed:** I messaged the maintainer about the R3 exposure on the live service, which a guest could use today. Fixing it needs one of two choices: a clip id that does not designate the directory (the #88 direction), or the daemon refusing ids a guest was not given. No job is posted for either yet.
- **Should-fix items not done this round:**
  - revoking a capability, and deleting grants on unpublish;
  - an unheld power name gets charged before it is rejected;
  - a guest briefly holds the whole directory during a `back` rewrite;
  - the `upgrade` tool schema dropped `hash` with no deprecation note;
  - no regression test covers the node-qualification branch outside the skip-gated `ENDO_CHECKOUT` integration suite.
- The panel-2 stage is next; the driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4647293 cached reads)
- Output: 28282 tokens
- Cost: $2.4711066000000006
- Wall-clock: 575s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
