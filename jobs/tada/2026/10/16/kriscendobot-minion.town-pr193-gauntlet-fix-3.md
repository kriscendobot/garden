I applied the panel-3 must-fix items to kriscendobot/minion.town PR #193 in one follow-up commit (`9e0533e`) and pushed it to `build/ocapn-guest-canary`. CI is green (`ci-wait-merge.sh` returned 0). The 49 offline canary tests also pass locally.

**Must-fix items fixed:**
- **`await` in eval (spec-keeper, engine-realist):** the wrapper is now `(async () => JSON.stringify((await (src)) ?? null))()`, because the daemon runs eval source as a script, where a bare top-level `await` doesn't work. A new test runs the wrapper as a script under `node:vm`, and shows the old form failing there.
- **Double JSON parse (engine-realist):** eval output is now parsed once. `endo eval` prints with `console.log`, so the JSON string arrives without quotes. The fake Endo CLI in the tests now prints the same way instead of encoding twice.
- **Remove `scrub` (decomplector):** no step records command output any more. Each step detail is fixed text, at most with an exit code, so neither a locator nor the per-run proof can reach the audit record. This also removes the second scrub in `auditRecord`, the partial-locator leak from truncating before scrubbing, and the missing test for the proof. A new test has the fake leak locators and the proof in its output and checks the audit record stays clean.
- **Duplicated docs (pruner):** the DEPLOYMENT.md canary section now points at the script header instead of restating it. The timing sentence is shortened, and the systemd unit comment is trimmed (plus a note explaining the `$$` escaping).

**Should-fix items also fixed:**
- Locators are passed to `endo adopt-locator` on stdin, as the repo's federation test does, and the temporary locator file is gone.
- A new host-local `bindings.json` stores a SHA-256 of each guest's locator. If a pet name is already bound but its locator was rotated or never recorded, its `bind:` step fails with an `endo remove` instruction.
- Canary messages and names are now filtered inside the daemon, so a large inbox can't overflow the CLI's output buffer.
- Peer names are looked up with `Object.hasOwn`, so a guest named `constructor` works.
- The guests file must now hold exactly two guests; a third gets a new `excess-guests` reason.
- Message numbers must be in a form a BigInt literal accepts (no leading zeros).
- Only the `missing` and `insufficient-guests` reasons map to the auth-unavailable signal; the others are local file errors.
- The audit JSON is printed before the audit file is written, so an unwritable audit directory doesn't lose the result.
- A new test covers a failed capability adopt (the exercise is skipped and cleanup still runs). I removed the unpinned `.reverse()` in cleanup, and renamed a few variables as the stylist suggested.

**Declined:** the procurer asked to use `isRecord` from `@endo/pass-style`. That function only accepts hardened values, and this code checks a plain `JSON.parse` result, so it isn't the same check.

**Documented in the script header, not changed in code:** the guests must be dedicated canary accounts; a manual run overlapping the timer's run can make both fail; only the capability leg resists a forged message; and the proof appears in the `endo eval` arguments and in the probe's stored formula.

I posted these decisions as a PR comment: https://github.com/kriscendobot/minion.town/pull/193#issuecomment-6216583993

Follow-up: the panel-4 stage, which the gauntlet driver posts next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (2198265 cached reads)
- Output: 25919 tokens
- Cost: $1.881377
- Wall-clock: 1107s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
