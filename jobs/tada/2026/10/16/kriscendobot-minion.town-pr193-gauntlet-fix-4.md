Fix round 4 for kriscendobot/minion.town PR #193 is pushed as `0d3b357`, and CI is green (`ci-wait-merge.sh --no-merge` rc 0; the one Actions run, "Test (typecheck + vitest)", succeeded). The offline suite passes locally, 58 of 58.

**Must-fix threads from the panel (head `9e0533e`):**
- **Bindings ledger:** removed `fileLedger`, `memoryLedger` and `locatorDigest`, as the decomplector suggested. Each run now removes and re-adopts every guest under `ocapn-canary-guest-<name>` (new `unbind:` and `bind:` steps). A corrupt, `null` or unwritable `bindings.json` can no longer stop a run or suppress its audit record. A rotated locator now takes effect on the next run.
- **Pet-name grammar:** the run identifier is now lowercase. The test fake now checks every pet name against `[a-z][a-z0-9-]{0,127}` instead of the looser `[\w-]+`. On Endo `llm`, the daemon's own `isPetName` accepts any 1–255 characters without `/`, `\0` or `@`. So the uppercase names probably wouldn't have failed live, but they did break the canary's own rule.
- **Self-deletion:** guest names and peer names that start with `ocapn-canary-` are now refused as `malformed-guests`. Names are capped at 128 characters, including the host pet name built from the guest name.

**Other review items fixed in the same commit:**
- Canary messages now match on exact text rather than a substring.
- A poll cut short by the run deadline now records `run-deadline`. I confirmed the new test fails without this fix.
- A flag given without a value is refused.
- An unwritable audit directory or `--output` path now writes one stderr line and exits 1; the header documents this.
- The header now cites where `makeExo` and `M` come from (the `endowments` in Endo `llm` `packages/daemon/src/worker.js`). It also explains the stdin and `--file` forms of `adopt-locator`.
- The probe's `prove` method now uses method shorthand, so it has a stable name.
- The systemd unit header now says it is a user-scope unit and needs `loginctl enable-linger`.
- The PR body now says the PR builds on #191 as revised at `90db939`, and that it uses the guest locator instead of the formula identifier on purpose.

**Declined:** the procurer's request to use `@endo/pass-style`'s `isRecord`. That function only classifies hardened values and throws on the unfrozen output of `JSON.parse`. The package also can't be imported without SES; I tried it and got `missing globalThis.assert`. A code comment now gives the reason.

**Not done, all should-fix:**
- A check that the capability message came from the expected guest before adopting it.
- A `.d.ts` for the exported functions.
- Folding the "address panel-N" commits into the two original commits before the PR leaves draft.
- A live-daemon smoke test, which stays with `minion-town-ocapn-canary-live-run`.

A disposition comment listing all of this is on the PR (issuecomment-6217750844).

During the work I mistakenly ran a `git stash push` in the project checkout. I restored it by its SHA, dropped that entry by tag, and checked that nothing else was touched.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4277364 cached reads)
- Output: 31002 tokens
- Cost: $2.4944648000000003
- Wall-clock: 1208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
