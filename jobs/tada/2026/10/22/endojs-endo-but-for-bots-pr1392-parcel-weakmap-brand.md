---
handed-off: endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand-pr-writes
deliverable-complete: false
---
# PR #1392: Parcel recognition is now a WeakMap brand check

The code fix is pushed to `build/sturdyref-pass-style-recognition`, which is now at head `5f9bc1533d9dbfecbe026b6eff8ef67030509bea`. The PR description, the two inline replies, the summary comment and the review re-request are **not posted yet**. This host's bot token gets 403 on every write to endojs PRs (`gh pr edit` failed with `updatePullRequest` 403). I handed those steps to a successor job pinned to the endolin host. The text for each step is written out in full in that job.

## What changed
- **`4a034b968` `fix(pass-style)`**: `packages/pass-style/src/parcel.js` checks that the candidate is an object, then asks `Parcel.isParcel`. That is `has` on the shim's private WeakMap, which maps each parcel to its location and open hook. All the shape validation is deleted, along with the reentrancy guard and error handling that only an untrusted `isParcel` needed. I kept three guards:
  - **Read through descriptors:** a getter installed on `globalThis.Parcel` before the shim is never run.
  - **Non-function means no Parcel:** if the global or its `isParcel` isn't a function, nothing is a Parcel, instead of every `passStyleOf` throwing.
  - **Captured once at module load:** a later replacement of the global can't change an answer `passStyleOf` has already cached. This is also the only moment worth reading it: once pass-style has imported `@endo/harden`, the shim refuses to install, which I confirmed by running it.
- **Tests:** the pre-shim fixture went from 24 shape scenarios to 4:
  - no global;
  - a getter global that is never invoked;
  - the real shim, where an object with the same prototype, frozen and empty, is rejected;
  - a replaced global that doesn't change answers.

  `parcel.test.js` also asserts that the same-shape impostor is not a Parcel.
- **`5f9bc1533` `test(marshal,patterns)`**: recognition no longer requires a frozen constructor, so the Parcel tests in pass-style, marshal and patterns now also run in the shims-only test profile, and they pass there. A side effect is that a Parcel is now passable before lockdown.
- **PR description:** I rewrote the Description and Security Considerations paragraphs to describe the brand check. Posting them is part of the successor job.

## Verification
- **Tests:** `yarn test` passes for pass-style, marshal and patterns in every profile. Three unrelated files failed during the full run while the host was loaded; they passed when rerun alone.
- **Lint:** 0 errors; prettier and the full pre-push gates pass (exit 0).
- **One probe failure:** the abbreviated-identifier probe flags fast-check's `numRuns` option. It is that library's option name and was in the PR before my change.

## Open question for kriskowal
His line-1 comment may mean he wants the WeakMap inside pass-style itself. Doing that would invert the layering in `designs/parcel.md`. I left the WeakMap in the shim and wrote the question into the line-1 reply, which the successor will post.

## Successor job
`endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand-pr-writes`, pinned to `endolin-garden-ece02cb4`. It checks that the head is unchanged, then:
1. Updates the PR description.
2. Replies to inline comments 4345265068 and 4345270943 with the commit SHAs.
3. Posts the summary comment.
4. Waits for CI and re-requests kriskowal's review only if CI is green.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4417877 cached reads)
- Output: 29461 tokens
- Cost: $2.373483399999999
- Wall-clock: 2753s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
