---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-24T03:40:50Z
---
role: assessor (jury seat)
pr: kriscendobot/minion.town#52 (feat/daemon-sites-exo, head 1f378d9)
dispatch: gauntlet panel round 4, worktree project-wt-kriscendobot-minion-town-pr52-gauntlet-panel-4-dcb97806
diff base: origin/main

### correctness / control flow (assessor)

**Verdict:** request-changes

**Findings:**

- `src/endo/gateway/daemon-site-registry.ts:296` (`guestPetName = "@self"`) + `:236` (`E(guest).lookup('@self')`) — the live register evaluate can never run. In the pinned daemon a GUEST's special names are `{'@agent': guestId, '@self': handleId}` (`packages/daemon/src/guest.js`), and the handle is `makeExo('Handle', ...{receive, open, receiveEdit, openEdit})` (`mail.js:1624`). `E(guest).evaluate('MAIN', src, ['guest','sites'], ['@self','sites'])` resolves the slot through `specialStore.identifyLocal` (`guest.js:259`), so `guest` is the mail HANDLE; `E(guest).lookup('@self')` then hits an exo with no `lookup`, and `makeDirectory`/`storeValue`/`copy`/`identify` are all on `@agent`. The JSDoc at `:294` ("`@self` resolves the guest's own agent inside the evaluate") is falsified by the daemon source, and `root-host-socket.ts:150` already documents the two-facet split. Fix: bind `@agent` and use the slot directly (`const self = guest;`), dropping the extra lookup hop. Only the ENDO_CHECKOUT-gated B1 case (`test/endo-daemon-integration.test.ts:227`) would catch it; the unit tests fake `guest.evaluate`, so CI is green on a path that always throws. must-fix. [proposed-rule: a JSDoc claim about a pinned dependency's resolution semantics must cite the file:line in that dependency it was read from, so a reviewer can check it without a live daemon]

- `src/endo/gateway/site-registry-exo.ts:236` (`unregister`) — `E(store).remove(hash)` is not the no-op its own JSDoc promises (`:97` "no-op if absent"): the daemon's petStore `remove` throws `Formula does not exist for pet name ...` (`pet-store.js:165-171`). So the partial-register state `register` deliberately engineers at `:216` ("leaves a reclaimable state (an owner record with no pin)") is in fact UNRECLAIMABLE — `unregister` rejects on the missing pin before it ever reaches `remove(ownerName(hash))`. Worse, `list` does NOT hide that state (`:243` pushes a record for any `owner-<hash>` whose label decodes), so a failed `storeIdentifier` leaves a weblet permanently listed as `serving: true` at a URL that 404s and that nobody can remove. The comment's stated rationale is inverted relative to the daemon it names. Fix: tolerate a missing pin (or verify the arity/absent-name semantics in the B1 suite, which asserts arities but not this path). must-fix. [rule: skills/regression-evidence/SKILL.md]

- `src/endo/gateway/publish.ts:220` (`unpublish`) vs `:214` (`list`) — on the live path the two surfaces read different sources: `list` is `sites.list(owner)` → the daemon exo, while `unpublish` short-circuits on `store.read(id)` (the fs vhost table) and returns `no-such-weblet` before calling `sites.unregister`. Because `evaluateRegister` registers in the exo FIRST and writes the fs record after (`daemon-site-registry.ts:363`), any failure of `store.register` leaves an exo-only registration that `weblet_list` shows and `weblet_unpublish` cannot reach. should-fix. [proposed-rule: when a resource is recorded in two stores, the removal path must gate on the same store the enumeration path reads, or reconcile both]

- `src/endo/gateway/daemon-site-registry.ts:363` — `store.register({ id, directoryId: id, owner })` drops the cross-owner guard the scaffold it replaces performs (`site-registry.ts:113`: read the existing record, throw when `existing.owner !== owner`). The exo guards its own store, but nothing guards the fs table, so a guest-supplied `hash` (the result is explicitly treated as untrusted at `:344`) can rewrite the owner of an existing vhost record. This is a different exposure from § Known residuals R1, which only enumerates exo-mediated ones. should-fix. [rule: skills/adversarial-tests/SKILL.md]

**Notes (out of scope but worth flagging):**

- `src/http.ts:216` — `authorities` caches one `GuestSiteAuthority` per owner against the FIRST `GuestAgent` seen; `guest-service.ts` drops and re-opens its connection on failure, so a reconnect leaves the cached authority holding a dead far-ref until restart. Pre-existing on `main`, but the live path makes it load-bearing (every publish is now a real evaluate through that far-ref). [proposed-rule: a cache keyed on identity must not close over a connection-scoped far-ref]
- `src/endo/gateway/daemon-site-registry.ts:411` — `directoryFor: (id) => upgradeStub(id)` returns a stub for ANY id, so `directorySourceForRegistry` over this registry would silently read `undefined` for unknown weblets rather than fail. Not on the serving path today (the gateway uses `makeDaemonSiteDirectorySource`). [rule: skills/panel-review/SKILL.md]
- Confirmed correct on review, worth recording: the `{sites: '@sites'}` → `{sites: 'sites'}` introduce fix is real — `introducedNames` maps host name → guest name and the guest-side `storeIdentifier` asserts a pet name with no `@` (`pet-name.js:14-23`), so `main` could not provision a guest at all; and `introduceNamesToAgent` silently skips an absent parent name (`host.js:1745`) and re-runs on every `provideGuest`, so the failed-install fallback does not break guest provisioning.

Self-improvement: this seat's findings all came from reading the PINNED DEPENDENCY's source (a nearby endo checkout under scratch/) rather than the diff alone; the three must/should-fixes were invisible from the diff because every one of them is a claim about daemon semantics asserted in a comment. Proposing to the gardener that the assessor brief add "when a diff's correctness rests on an external library's resolution or error semantics, locate that library's source and read it before accepting the comment" to its operating norms.
