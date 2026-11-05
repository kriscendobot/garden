I applied the panel-1 must-fix items for PR #1652 and pushed them to `design/unified-virtual-filesystem`, moving the head from `22a475e7ff` to `4e280a46e2`. CI is green: 31 of 31 checks, 0 failed (`ci-wait-merge` rc 0). The PR is still a draft. Prettier passes on the design file. I re-ran no other authoring checks, because this is a documentation-only change.

**Commits** (follow-ups only, all in `designs/unified-virtual-filesystem.md`):

| Commit | Panel items addressed |
|---|---|
| `c086b956b1` Identity | **skeptic, decomplector, archivist.** Separates `Revision`, `ContentIdentity` and `Snapshot`. `ContentIdentity` holds no content and compares only within one identity domain. Comparing across providers uses `Snapshot.equivalent`, and the content store owns retention. Adds canonical forms for blob, tree, log, data and link entries, a new `IDENTITY_INCOMPARABLE` error, and `snapshot.transform` so a result can be checked against a preview. The identity law now applies at the instant `t` the snapshot is taken. |
| `5701e96178` Controller | **decomplector.** The provider journals policy generations alongside content commits, so it alone serializes those decisions. The controller only sends absolute, idempotent commands. Ownership map updated. |
| `0ed7f9b5e2` Readers and recovery | **ergonomist, skeptic.** All listing and search methods return one `ResultReader` (`PassableReader` from `@endo/exo-stream`). Limits end the reader with `RESULT_TOO_LARGE` and can't be resumed. Recovery advice names only methods on the facet that raised the error, and blobs gain `grep` so that advice can be followed. |
| `c5f67c7c7c` Manifest | **critic, skeptic.** The manifest binds every archive member and is signed with Ed25519. The trust anchor is the restorer's `trustedSigners`, verification runs in a fixed order, and failure throws a new `ARCHIVE_UNAUTHENTICATED` error. `links: 'inert'` is the only mode that needs no signer, and it creates no links. |
| `4e280a46e2` Prose and pruning | **novice, pruner.** Replaces the undefined rubric and override references with plain criteria, and removes the empty Open questions section and the Prompt section. |

The panel's cheap should-fix items went into the same commits:
- attenuation across traversal
- a worked example of the views
- the `captive`, `XL` and en-dash wording
- the executable `glob` recovery path
- a stated role for the envelope versus the manifest

**Pruner calls you may want to check:**
- **Prompt section:** I removed it even though 151 of 249 designs carry one, because those I sampled quote the maintainer's request verbatim and this one was an unquoted paraphrase. I did not find the original request to confirm that, so it can go back if you want the record.
- **PR body:** I kept the Documentation and Testing Considerations headings because the repo's PR template requires them, and cut each to one line instead of deleting it.

**PR body edit:** this host's token gets a 403 when updating PRs on endojs, so I posted `endojs-endo-but-for-bots-pr1652-body-prune-20261105`, pinned to endolin. That job finished and I confirmed the live body now has the new text, including "signed manifest" in the Security section.

**Unreplied review items:** the panel left no inline threads, so there were none to reply to. As the job specifies, I did not re-run the panel; panel-2 reviews the new head.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1400709 cached reads)
- Output: 39716 tokens
- Cost: $2.0523898000000003
- Wall-clock: 1357s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
