## Completion report: build-endoclaw-network-fetch

I opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1588**, which splits outbound HTTP into two packages: `@endo/fetch` and a new `@endo/confined-fetch`. Head branch is `endo-fetch-split-confined-plugin`, based on the pinned `llm-9a14ddf`. Its 26 tests pass locally, the pre-push and phase-evidence gates pass, and the PR has not run through CI yet.

The job pointed at `designs/endoclaw-network-fetch.md`, but on `llm` that design is marked superseded by `designs/endo-fetch.md`. The basic HTTP capability already landed in #566. PR #723 then merged `@endo/fetch` as a single plugin, and the newer design says that should be split into two packages in its own PR. No PR had done that, so this one does. kriskowal approved #723 without objecting to the split, so this doesn't reverse any maintainer decision.

**What changed**
- **`@endo/fetch` is now the unrestricted base.** It wraps the worker's built-in `fetch` in a `Fetch` object with no allowlist, limits, policy or saved state, and it can be passed between processes. Responses come back as plain records whose body is a byte stream. Cancellation uses an `@endo/cancel` token instead of an `AbortSignal`, which can't be passed between processes.
- **`@endo/confined-fetch` is the restricted plugin.** It holds the service, the saved-settings store and the setup code that used to live in `@endo/fetch`. It only reaches the network through the `Fetch` object it is given:
  - Its setup rejects if that object is missing.
  - The service core refuses to start without it, where before it would quietly fall back to the global `fetch`.
  - A new `src/transport.js` connects it to the base and forwards timeouts and revocation.
  - A guest receives only `client()`.
- Byte chunks arriving from the base read as zeros until converted with `thawedBytes`; the transport does that now.
- I removed the store's use of `Math.random`, which isn't available inside a confined worker.
- I rewrote both READMEs and consolidated the changeset to cover both packages. `designs/endo-fetch.md` now says In Progress, with an implementation-status section. In `designs/README.md` I corrected two status rows, one of which wrongly said Complete. The auto-formatter also normalized two typographic characters in unrelated rows of that file.
- Yarn lockfile changes are in their own `chore: Update yarn.lock` commit.

**Tests**
- 6 new tests in `@endo/fetch`.
- 9 new tests in `confined-fetch/test/boundary.test.js` for the access boundary: no network without the base, the guest sees only the client's methods, blocked origins and redirects never reach the base, the response size limit cuts the stream, revocation survives a restart, saved trust decisions survive a restart, and an aborted request cancels the base's token.
- The 11 tests moved over from the old package now go through a real base.
- To check the new tests actually catch failures, I broke three things in turn: the requirement for a base transport, the forwarding of cancellation, and the lookup of the base. Each break failed the matching tests.

**Follow-up:** the restricted plugin can't yet run inside a truly confined worker. `@endo/http-confine` relies on the global `setTimeout`, `AbortController` and clock, and the daemon's confined workers don't provide them (`packages/daemon/src/worker.js`). Until that's fixed, `@endo/confined-fetch` has to be started with `makeUnconfined`. Its only network access is still the `Fetch` object it's given. Fixing this needs a design decision because the design says `http-confine` stays untouched, so I posted a designer job, **`design-confined-fetch-timer-endowment`**. The gap is also noted in the PR body, the README and the design's status section.

**Note:** I marked the PR's phase checklist "deliverable". All three of the design's phases are met: phase 2 landed in #723 and is re-checked here, and phases 1 and 3 are this PR. The design's acceptance bar for each phase is unit tests and an in-memory restart test; I did not try it in a running daemon.

Packages affected: `@endo/fetch`, `@endo/confined-fetch` (new); the changeset also covers `@endo/exo-http-client`, whose code this PR doesn't change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endoclaw-network-fetch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 188 tokens (14577827 cached reads)
- Output: 79616 tokens
- Cost: $6.215117399999997
- Wall-clock: 1685s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
