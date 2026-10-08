**PR #472 viability: overtaken.** The PR is open and not merged, but the work it mainly documents has since been replaced on the integration branch. No clean, panel, fix, CI-wait or un-draft budget was spent, and nothing was committed, pushed or opened. The verdict is from my earlier session's checks of the PR and the `llm` branch; I didn't re-query this session.

**Deciding question:** Does current `llm` still ship `bytesToImmutable` and `packages/immutable-arraybuffer/designs/freezable-typedarray.md`, the two things this PR documents and annotates, without a newer change replacing them?

**Answer: no.**

**Evidence:**
- **PR facts:** state OPEN, not draft, not merged. Head `chore/468-followups` @ `a516972374`; base pinned to the frozen `master-80e9b3e`. Last updated 2026-09-01.
- **What the PR changes:**
  - It adds a `@endo/bytes` README section showing how `bytesToImmutable`'s result can back a freezable `Uint8Array` wrapper.
  - It adds an ECMA-262 §10.4.2 citation and a "Why not a Proxy wrapper?" note to `designs/freezable-typedarray.md`.
  - It adds one test pinning the subclassing limitation and fixes a "TypeArray" typo.
- **kriskowal predicted this** on 2026-06-23: "This may be obviated by part 3 on byte arrays."
- **That change has landed.** endojs/endo-but-for-bots#475 ("narrow byteArray to a frozen Uint8Array") merged into `llm` 2026-08-30 as `830a924d7`. On current `llm` (`7d2eb307a`):
  - `packages/bytes/src/to-immutable.js` and `from-immutable.js` are gone.
  - The `@endo/bytes` README now points to `frozenBytes`/`thawedBytes` in `@endo/immutable-arraybuffer`. `frozenBytes` returns a hardened, frozen `Uint8Array` directly, which makes the README recipe this PR adds pointless.
  - `freezable-typedarray.md` no longer exists, so the citation and Proxy note have nothing to attach to.
- **The related branches are settled:** the Proxy alternative (endojs/endo-but-for-bots#602) was closed. The parked boundary tests went to endojs/endo-but-for-bots#586, which is still open and separate.
- **Small leftover:** the "TypeArray" → "TypedArray" typo is still on `llm` (`packages/immutable-arraybuffer/README.md`). That fix is too small to justify the gauntlet; it could go into a one-line follow-up.
- **Caveat:** the frozen `master` base still has the old API and design doc. But `master` hasn't moved since 2026-07-22 and the active line is `llm`, so landing this would document an API that line has already removed.

Option: close as superseded

No follow-ups were posted. Closing #472, and optionally carrying the typo fix forward, is the maintainer's call.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr472-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (416394 cached reads)
- Output: 5173 tokens
- Cost: $1.1955328
- Wall-clock: 62s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
