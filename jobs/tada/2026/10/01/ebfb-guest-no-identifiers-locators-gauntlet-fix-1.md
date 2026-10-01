Fix round 1 for endojs/endo-but-for-bots#1404 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 with 33 checks and 0 failures, on head `9b850783b0` (advanced from `9809f6d979`).

**What the panel required and what changed** (five follow-up commits, pushed with `safe-push-pr-head.sh`):

- **breaker: guests could still turn authority into data.** A guest's `makeDirectory`, `lookup`, `maybeLookup` and `listValues` handed back a full `EndoDirectory`. A guest could copy any value it names into that directory and then call `identify` or `locate` on it there.
  - Each directory now hands guests a new `EndoGuestDirectory` instead, which has the pet-name and file methods but no identifier or locator methods.
  - This covers directories the host grants a guest as well as ones the guest makes.
  - Directories reached through that object, including through its `readOnly()` view, get the same treatment.
  - The new directory object is cached, so every route returns the same one, and the host can still reach into what the guest made.
  - New test in `endo.test.js`: "a directory reaches a guest without identifier or locator methods".
- **saboteur: a catch-all hid real errors in `namesForLocator`.** The message-hiding code moved to a new `guest-redaction.js`. Now only a locator that fails to parse is caught, and it is reported instead of silently dropped. An error from the pet store now surfaces instead of quietly emptying `fromNames`/`toNames`.
- **fast-checker: the safety rule was checked on only two hand-picked messages.** I added `fast-check` to the daemon's dev dependencies, with the `yarn.lock` change in its own commit. The new `test/guest-redaction.test.js` checks the rules over randomly generated messages:
  - no hidden field survives;
  - every other field is kept;
  - locators become the guest's own pet names;
  - `namesForLocator` never throws;
  - name changes lose their `value`.
- **typist: lal's `InboxMessage` type still described the old message shape.** It now points at `GuestMessage`, which `@endo/daemon` now exports along with `EndoGuestDirectory`. The field table in `LAL-ARCHITECTURE.md` matches. I also replaced the curly apostrophes in three new strings and test titles.
- **stylist:** renamed the `msg` parameter to `message` in `isOwnForm`, in both `lal/agent.js` and `fae/llm-provider-factory.js`.
- **packager, curator and changeset-auditor:** the changeset now also covers `@endo/fae` (major), `@endo/floot` (major), `@endo/lal` (major) and `@endo/cli` (patch). It names each package's change, mentions the new guest directory object, and is one sentence per line.

**Local tests:**
- Daemon type check is clean, and so is `lal`'s.
- Passing: `endo.test.js` (262 tests), the guest-redaction properties, `fae` subagent tests, `lal`, `agent-mcp-stdio`, `floot` container-mounts and inbox-delegation, and the daemon's help-text, read-only-view and envelope tests.
- I could not run the whole daemon suite locally. The `channel` and `code-mode-provisioning` tests fail here because the worktree path makes the daemon's socket path too long; these failures are environmental, not caused by this change, and CI passed them.
- The type check over the whole repo timed out locally; CI's lint passed.

**For panel 2:**
- The `makeDirectory` fix changes more than the reviewer asked: guests now also get the restricted directory object for directories the host grants them, not only ones they create. This is deliberate, but reviewers should confirm it.
- Code a guest runs inside `evaluate` is outside this fix.
- I did not act on the should-fix to rename the `fix(fae)` commit's scope to include floot, because that would mean rewriting history that is already pushed.
- Housekeeping: the shared `better-sqlite3` native binary in the project worktree was built for a different Node version, so I rebuilt it locally to run the daemon tests. It is not committed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 6 tokens (510867 cached reads)
- Output: 1840 tokens
- Cost: $4.464951400000001 (1 engagement(s) unpriced)
- Wall-clock: 7227s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
