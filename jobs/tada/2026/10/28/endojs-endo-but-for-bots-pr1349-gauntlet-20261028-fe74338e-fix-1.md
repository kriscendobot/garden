I applied fix round 1 for endojs/endo-but-for-bots#1349, pushed it, and CI came back green: all 15 checks passed and `ci-wait-merge` returned rc 0.

**What I worked from.** The job had no pre-pass block, so I used the latest panel review, 5675257967 (posted against head `fe74338e`). Its two must-fix items were both from the integrator. I also applied the should-fix items from the releaser, packager and pruner that only needed text edits.

**Commits pushed with `safe-push-pr-head.sh`** (head moved from `d376e0f162` to `1e19cde89b`):
- `298d42bc` puts back the curly apostrophe (`it’s`) on the unrelated line in `docs/reference.md`.
- `5c213d1e` keeps a single explanation of the codec substitution in each of `docs/guide.md` and `packages/ses/docs/guide.md`, instead of a separate paragraph plus a repeated sentence.
- `f17926ae` shortens the repeated JSDoc in `tame-text-codecs.js` and removes the repeated "AVA runs this file in its own worker" note from four test headers.
- `1e19cde8` splits the changeset in two:
  - The XS lockdown-compartment change now uses the same file and wording as #1425: `.changeset/ses-xs-lockdown-compartment-intrinsics.md`, as a `patch`. When one of the two PRs lands, the other's copy becomes a duplicate to drop.
  - The codec changeset goes from `major` to `minor`. It now tells users to read `globalThis.TextEncoder` and `globalThis.TextDecoder` after `lockdown()` rather than caching them, and that `instanceof` works with either the old or the new constructor.

**PR body.**
- **Integrator must-fix 1:** I removed the false claim that `ci.yml` changes.
- **Integrator must-fix 2:** The body now says the XS change overlaps #1425, which owns it, and that whichever PR lands second drops the duplicate.
- **Other body edits:**
  - "Depends on: #1425" is now "Overlaps: #1425".
  - The opening sentence names the XS change.
  - The `BROWSER_TEST_PORT` setting is mentioned.
  - Compatibility now just points at the changesets.
  - The body went from 319 to about 230 words.

I also posted a follow-up comment on the PR listing what each item got: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6460928343

**Not done:**
- **History cleanup.** Squashing the leftover `fixup!` commits and moving the workflow edits into a separate `ci:` PR (packager 1 and 4, integrator 4) both mean rewriting history. That belongs in a retcon before this goes to the ferry; I didn't do it here.
- **Head moved before this round.** The PR head had already moved past the reviewed commit (`d376e0f1`, a test fix) before I started. Panel round 2 will review it along with these changes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1157896 cached reads)
- Output: 10764 tokens
- Cost: $1.0464752000000002
- Wall-clock: 634s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
