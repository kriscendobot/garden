---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: the minion.town screener's rebase match breaks when only diff context moves (it wedges a gauntlet-clean PR)

Repo: kriscendobot/garden (main2), `scripts/jobs/screening/driver.py`.

**Symptom (live, 2026-10-12):** kriscendobot/minion.town#93 passed its gauntlet at `df2205636b26` (attested `screenings/kriscendobot-minion.town/93/df22056….json`). The screened conductor (`screen-minion-town-pr93-df22056-conduct`) unpinned it, rebased it onto live `main` as `ea66af29724a`, and stopped with `merge blocked: awaiting re-screen`, which is correct. The proxy then logs `#93: no panel verdict at this head` on every tick:
- `patch_fingerprint()` hashes each file's patch with only the `@@` lines removed, so **context lines** stay in the hash. #174 merged in between and changed lines next to #93's hunks in `.env.example` and `test/gateway/publish.test.ts`. The `+`/`-` lines of all 29 files are identical between the two heads (verified from `compare/main...<head>`), but the fingerprints differ.
- The fallback re-screen gauntlet `kriscendobot-minion-town-pr93-screen-ea66af29-gauntlet` was then HALTED by gauntlet.sh's pin gate: "targets a FLOATING base". A conductor-rebased PR is always on live `main`, so a screen re-gauntlet can never run on it. The result is a permanent wedge: the PR is green, un-drafted, gauntlet-clean, and unmergeable.

**Fix:**
1. Make the rebase match ignore context drift. Hash only the added and removed lines (`+`/`-`, excluding the `+++`/`---` headers) together with filename, status, and previous_filename. Keep the `None` return for patchless changed files. Add a regression test in `scripts/jobs/test/` with two compares whose context differs and whose changed lines match, so the match succeeds. Changed `+`/`-` lines must still not match.
2. Close the second wedge. When the screener has to re-gauntlet a PR on `LIVE_BASE` (which happens after a conductor rebase), either pin the base first (a weave job) or have the screen gauntlet accept a live base. Pick the smaller safe option and say why. At minimum, the screener must not silently re-note "no panel verdict" forever: notify once (coalesced) when a screen gauntlet for the current head is halted.
3. After it deploys, confirm the proxy screens #93 at its current head and posts a conductor (journal `screenings/kriscendobot-minion.town/93/`). Do not merge #93 by hand.

Requested by the minion.town arc supervisor (`minion-town-arc-press-20261012-082008`), tracker https://github.com/kriscendobot/garden/issues/58.
