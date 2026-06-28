# Build a PR patching `@agoric/internal` hex codec (on the bot fork)

A trusted maintainer (kriskowal) directed this on garden issue #9:
"post a job to build a PR that patches Agoric internal hex. Follow up here
with the PR link when it's up."

## Task

Build a PR that patches the hex codec at
`packages/internal/src/hex.js` in the Agoric monorepo, **on the bot-owned
fork `kriscendobot/agoric-sdk` only** (open the PR fork-internally:
feature-branch → `kriscendobot/agoric-sdk` default branch). Open it as a
**DRAFT**. Do **NOT** push to or open a PR against upstream
`agoric/agoric-sdk` — upstream agoric-sdk is off-limits for autonomous
garden action; upstreaming, if wanted, is a separate maintainer-directed
boatman step.

## What to patch (interpretation — confirm against the file)

The maintainer did not spell out the change. Examine `hex.js` first. The
clear defect candidate is a **validation divergence between the two
codecs**: `makePortableHexCodec().decodeHex` throws on odd-length and on
any non-hex input, but `makeBufferishHexCodec().decodeHex` delegates to
`Buffer.from(hex, 'hex')`, which **silently drops** invalid bytes and
odd-length tails instead of throwing — so `encodeHex`/`decodeHex` behave
differently depending on whether `Buffer` is present. Make the Bufferish
codec validate consistently with the portable one (reject odd-length and
non-hex input by throwing the same `Invalid hex string: ${hex}` error),
and add tests that pin both codecs to identical accept/reject behavior on:
valid lowercase/uppercase/mixed-case hex, odd-length input, and non-hex
characters. Round-trip both codecs and assert they agree.

If on reading the file you find a different, more obviously-intended
defect, patch that instead and note your reasoning in the PR body and the
issue follow-up.

## Verification

Run the `@agoric/internal` package's test + lint (and the new tests) to
green before un-drafting readiness. Keep DRAFT for maintainer review.

## Follow-up (required)

When the DRAFT PR is up, **comment the PR link on issue #9** (the
issue_url below), with a one-line summary of what the patch changes and
that it is DRAFT on the bot fork awaiting review. Do NOT close the issue —
the submitter does that.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-9
issue_url: https://github.com/kriskowal/garden/issues/9#issuecomment-4824968517
submitter: kriskowal
----- END ISSUE NOTE -----

Provenance: promoted from dead-lettered message originally addressed to
issue-kriskowal-garden-9; picked up by gardener job
deadmail-20260628T052047Z-d6fc2a.
