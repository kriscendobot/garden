PR #1404 fix round 2 is done. I pushed fixes for the panel's must-fix findings, and CI on the new head `4614dd5d99` is green (33 checks, 0 failed).

The first CI run failed one leg, `test (22.x, ubuntu-latest)`. All 1337 daemon tests passed there; the leg failed only on one unhandled `Termination requested` rejection at teardown in `endo.test.js`. That is the known flake tracked as issue #1137, and CI on the previous head was green. I re-ran the failed job and it passed.

**Commits pushed** (with `safe-push-pr-head.sh`, `9b850783b0` → `4614dd5d99`):
- **breaker (`07b1a31793`):** a guest's `evaluate` no longer binds a single-name endowment by formula id. Every endowment now resolves through the guest's own `lookup`. A directory endowment therefore arrives as its narrowed `EndoGuestDirectory` facet, without `locate`, `identify` or `storeIdentifier`. There is a new regression test, and the changeset has a line about it.
- **typist, warden, integrator (`d3330e803a`):**
  - `GuestMessage` now keeps each message kind's own fields; the old `Omit` over the union dropped them. This also clears 4 existing type errors in `fae/endo-skill.js`.
  - `redactNameChange` now hardens `remove` changes as well as `add` changes, and the property test checks that the result is frozen.
  - The guest directory's `help()` overview no longer recommends `storeIdentifier()` or `storeLocator()`.
- **migrator (`4614dd5d99`):** `@endo/jaine` no longer uses guest `storeIdentifier`, `identify` or `locate`:
  - The host now binds the provider and agent references. Setup passes the factory's agent name through `env.JAINE_FACTORY_AGENT_NAME`.
  - The router detects its own mail with `fromNames.includes('@self')`.
  - Channels are keyed by the agent's pet name instead of an identifier.

**Not changed in code:**
- **migrator's space-chat finding:** I declined it for this PR. space-chat only runs with host powers, because chat's `enterHost` admits a profile only if it answers `identify('@self')`, which guests no longer have. Guest-profile support for chat is already listed as follow-up job `ebfb-guest-designation-consumers` in the PR's consumers table.
- **integrator's PR-description item:** I removed the duplicated Minion Town paragraph and its broken heading. I also updated the consumers table: jaine is marked fixed, and there is a new row for guest `evaluate`.
- **scribe's missing summary:** I posted the round-2 summary comment (issuecomment-5934023084).

**Local checks:**
- The daemon type-check is clean.
- The `*guest*` tests (28) and `*eval*`/`*endow*` tests (12) pass.
- eslint reports no errors on the touched files.
- The full daemon suite was too slow on this host and was killed before it finished, so CI's full run is the only complete pass.
- The shared node_modules cache had better-sqlite3 built for Node 24, but this host runs Node 22. I rebuilt it only in this job's checkout, without touching the shared copy.

Follow-ups:
- The comment-only `spaces-util` audit stays with `ebfb-guest-designation-consumers`.
- The `endo.test.js` teardown flake is tracked as #1137.

The next step is the driver re-posting panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 6 tokens (337441 cached reads)
- Output: 1653 tokens
- Cost: $4.854075199999999 (1 engagement(s) unpriced)
- Wall-clock: 7224s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
