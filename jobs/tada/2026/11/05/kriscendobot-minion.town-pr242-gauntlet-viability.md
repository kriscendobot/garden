**Viability: proceed.** PR #242 is an open draft at `49320b763`, and nothing has replaced it.

Deciding question: Does minion.town `main` still register the twelve guest tools #242 removes, with no newer PR or design replacing the removal or dropping the keep-the-tool-surface-minimal direction? **Yes.**

Evidence:
- **PR state:** #242 is open and unmerged, with base `garden/mcp-tool-removal-base-c7c81ca`. It has no comments or reviews. CI passed on its head (run 41768080955, read from the Actions API because this token can't read the check rollup).
- **Not superseded (`main`):** `src/endo/mcp-tool-names.ts` and the README still list 11 of the 12 tools in the baseline group, and the manifest header says the `claudeForm` group, which `submit` belongs to, is registered today. The last commit on `main` to touch `guest-tools.ts` or `mcp-tool-names.ts` is `603dc35c8` (Nov 3, the `cancelInvite` fix), which removes nothing.
- **Not superseded (open PRs):** by title, no other open PR does this removal. #243 is its planned follow-on and removes only `invite` and `cancelInvite`. Among the files I checked (`guest-tools.ts`, `mcp-tool-names.ts`, `resources/guide`), #239 and #240 touch none. #241 touches `guest-tools.ts` for the subscription freeze, a different change, though it could conflict.
- **Premise still holds:** #235's body records the 2026-11-03 direction to keep the tool surface minimal and work through `evaluate`. The removal's blocker was the web-accept route, which #239 still carries as an open draft. No later maintainer reversal appears on #235, #239, #240, #242, #243 or tracker #227, and those PRs have no human comments or reviews. I only have that direction second-hand from the PR body, not from a maintainer message.
- **Still planned:** the parked job `build-minion-town-tool-removal-landing-20261104` owns landing and production proof. garden-book#17, the publisher migration it depends on, is an open draft whose own viability check also passed. The garden's callers already moved in `3ec3eb02`.

Points for later stages (none change this result):
- **Can't land yet:** #235 must land first and is held by its own stop gate, and #239 hasn't merged. Passing the gauntlet won't make #242 mergeable, and the landing job keeps it draft until then.
- **Stale base:** #242's frozen base `c7c81ca` is no longer #235's head (`1920b0a51`), and `main` has moved 103 commits past that base. The landing job already plans a weave.
- **Open decisions:** the PR's "Decide before landing" questions are unanswered, mainly whether hand-escaping out-of-band text in `source` is acceptable. The panel may raise them again.
- **Possible #239 scope change:** the question sent to the maintainer from #239's fix 6, whether to keep the raw-locator route or remove `invite` and `cancelInvite` atomically, has no answer on that PR. It mainly affects #243, not #242.
- **Unproven in production:** nothing here has run in production, including the `evaluate` callers. This host has no MCP bridge credentials, and the landing job owns that proof.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr242-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (375986 cached reads)
- Output: 6785 tokens
- Cost: $0.7912732
- Wall-clock: 145s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
