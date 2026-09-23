CI is running on #873 (all checks pending; the change is Rust + design-doc only, and the repo's CI does not compile `rust/endo`, so the JS surface is untouched). Inbox empty. The tick's work is complete.

# Press report — npm-via-CAS registry proxy (tick 2026-07-26, 23:35Z)

## Assessment

All five design phases remain merged to `llm`; the arc's functional finish line holds. Of the prior tick's follow-ups: shepherding fix PR **#864** (the XS quiesce race) was already claimed by a live peer (`fu-endo-npm-cas-registry-press-20260726-172007-1`, a hermit on `endolin-garden2`, claimed 21:53Z) — I deferred rather than duplicate. The four gap drafts (#857 peer/optional deps, #859 process shim, #860 npmrc auth, #862 registry CLI) are open and held draft. That left exactly one known gap in `designs/endor-npm-registry-proxy.md` with no PR covering it: **workspace-protocol resolution for unpublished monorepos**. I pressed that.

## What I built — draft PR endojs/endo-but-for-bots#873

`feat/endor-npm-workspace-resolution` (kept draft per press policy):

- New `rust/endo/src/workspace.rs`: workspace discovery — walks up from the entry package root to the nearest ancestor `package.json` declaring `workspaces` (array or `{"packages": [...]}` form), expands member globs (literal segments, `*` in a segment, whole-segment `**`; negation and `?`/`[`/`{` forms rejected rather than misread), and indexes members by name. `node_modules` is never a member; duplicate names error; a workspace that doesn't list the entry as a member doesn't apply to it.
- `assemble.rs` now partitions the dependency graph before registry resolution: `workspace:` protocol ranges always resolve to the sibling's working tree ingested into the CAS (`workspace:*`/`^`/`~` accept the local version, concrete ranges are checked against it, and a missing member is a clean error since no registry can serve the protocol); plain semver ranges naming a sibling resolve locally when satisfied and fall back to the registry otherwise, as npm does. Member-to-member edges recurse, and edge binding prefers a satisfying member over a same-name registry version.
- Design doc's known-gap checkbox ticked with the semantics and deliberate sub-gaps recorded.

## Real-execution evidence

Cold-state debug `endor` from the branch, on a monorepo whose `app` member depends on `greeter: workspace:*` **and** `semver: ^7.5.4`: the run fetched only `semver@7.8.5` from registry.npmjs.org (MVS: greatest of major 7), took `greeter` from its working tree, and printed both packages' output from the XS machine. The registry table afterwards holds only `('semver','7.8.5')`. An `--offline` replay reproduced the identical compartment-map hash in 19 ms, and editing the sibling's source changed the next (still offline) run's output — the working tree is live, with no install step. Tests: 20 new (12 discovery, 8 assembly integration); full `endo` lib suite 190/190 green serially — the one parallel flake is the pre-existing cross-machine XS pending-jobs race that #864 (in a peer's hands) fixes. rustfmt clean; no new clippy findings.

## Follow-ups for the next tick

- Watch #873's CI (running at completion; the repo's CI doesn't build `rust/endo`, so only the JS/lint surface is at stake) and fold in any panel feedback.
- #864 stays with its live peer; re-verify it merged before the next stress-run claim.
- With #873, every actionable known gap now has a PR (#857, #859, #860, #862, #873) — the arc's remaining press work is landing them through the gauntlet when the maintainer promotes them, plus the two deliberate non-goals (install scripts, native modules).
