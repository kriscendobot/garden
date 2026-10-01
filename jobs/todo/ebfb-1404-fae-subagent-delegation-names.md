---
role: fixer
pr: https://github.com/endojs/endo-but-for-bots/pull/1404
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Redesign Fae subagent delegation without guest locators — endojs/endo-but-for-bots PR #1404

PR #1404 (head `guest-no-identifiers-locators`) removes `locate`/`storeLocator`
etc. from guests and replaces message `from`/`to` with `fromNames`/`toNames`.
Job ebfb-1404-guest-consumers-identifiers fixed fae provisioning (factory,
spawner, driver bindings via the host; `@self` detection by `fromNames`), but
left Fae's **subagent delegation** locator-keyed, so it throws in a real guest:

- `packages/fae/src/subagent.js` ~628 `spawnSubagent`: `E(powers).storeLocator([SUBAGENT_DIRECTORY, name], locator)`
  on the driver guest. Bind the subagent from the host side instead (the
  spawner holds `host-agent`; it can `copy([<child handle>], [<parent driver profile>, 'subagents', name])`).
- `src/subagent.js` ~475 `askSubagent`: `E(powers).locate(...path)` to learn the
  recipient, and the delegation registry (`claim`, `knownSubagents`,
  `isSameFormula(from|to, recipient)`) matches echoes/replies by locator.
  Note the daemon's `fromNames` is `specialStore.reverseIdentify` (top-level
  names only), so a subagent bound under `subagents/<name>` will not appear in
  `fromNames` — the design must pick a matching key that a guest can see (e.g.
  a top-level binding per subagent, or matching on `replyTo` alone plus a
  daemon-side guarantee). Keep the unsolicited-subagent-mail guard (loop
  prevention) working.
- `test/subagent-loop.test.js` mock currently carries both locators and
  `fromNames`; make it guest-faithful (no `from`/`to`) once the registry no
  longer needs them. `test/subagent.test.js` likewise.

Push to the PR head with `scripts/jobs/gardening/safe-push-pr-head.sh`; keep CI green.
