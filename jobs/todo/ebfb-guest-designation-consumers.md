---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Migrate in-repo guest consumers off guest identifiers/locators

Repo: endojs/endo-but-for-bots. Stack on the head branch `guest-no-identifiers-locators` of the draft PR opened by job `ebfb-guest-no-identifiers-locators` (find it with `gh pr list --repo endojs/endo-but-for-bots --head guest-no-identifiers-locators`); base this PR on that head branch (stacked), not on `llm`.

That PR removes from `EndoGuest` every identifier/locator method (identify, reverseIdentify, locate, reverseLocate, followLocatorNameChanges, listIdentifiers, listLocators, lookupById, lookupByLocator, storeIdentifier, storeLocator, invite, accept, deliver). Guest messages carry `fromNames`/`toNames` instead of `from`/`to` and no `ids`/`promiseId`/`resolverId`/`valueId`, and guest `followNameChanges` events carry no `value`. Hosts can still traverse a pet-name path into their own guest (`host.copy([...], [guestAgentName, x])`, `host.identify(guestAgentName, x)`).

Migrate every consumer listed in that PR body's "Breakage ledger" rows marked follow-up: lal, fae, jaine, floot, workflow, claude-sandbox, chat/spaces guest-profile paths, cli guest `--as` paths, auto-responder-agent, fae smoke test, the code-mode-provisioning tests, and the listed designs/docs. Recovery patterns: self-mail detection by `fromNames.includes('@self')`; form/value replies by `adopt(n, 'value', name)` then `lookup`; provisioning into a guest by `introducedNames` or `host.copy` into the guest's agent path; key maps by pet name instead of formula id; sturdy refs (the `ebfb-sturdyref-layer*` stack) for durable cross-session designation. Do NOT re-add any guest identifier/locator surface. Changeset per affected published package.
