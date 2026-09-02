CI is GREEN (rc 0, 5/5 checks passed, 0 failed). The fix is pushed and CI is green.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1116 — gauntlet FIX round 1. PR head `endojs:design/guest-native-invitations` is the design document `designs/guest-native-invitations.md` ("Guest-Native Invitation and Acceptance").

**What I did:** Read the panel-1 verdict (7 seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice — all request-changes, disposition must-fix) and revised the design once to apply the must-fix items plus the cheap should-fix ones, then pushed as a follow-up commit and watched CI to green.

**What changed** (`9781c05d81`, one follow-up commit on the PR head):
- **Locator authority** (critic + skeptic must-fix): the URL authority is now the **daemon** node, not the guest's agent key; the agent identity travels in `from`/`fromNode`/`handleNode`, all now shown in the section-2 locator example. Removes the internal contradiction with section 4.
- **Connection hints** (critic + skeptic must-fix): hints come from the **daemon's** networks directory, not a guest's empty `@nets`; cross-daemon reachability restated as a daemon precondition rather than silently assumed.
- **Consume-once** (skeptic must-fix): the durable record is now the **pet-store de-reference**, not the in-memory controller cancellation (which `provideController` would re-incarnate from the persisted formula); cancellation reframed as the in-process liveness half.
- **Crash-recovery sentence** (copyeditor must-fix): recast so the re-driven `accept` — not "a crash" — is the obligation's subject.
- **`writeRemoteAgentKey` contradiction** (copyeditor must-fix): disambiguated the denied public method from the injected closure capture of the same name.
- **Em-dashes → colons** (pedant + copyeditor must-fix); file now has 0 prose em-dashes.
- **Reader onboarding** (novice must-fix): opens with the host/guest distinction and what an invitation establishes; adds a real gloss of what a `handle` is and why binding one is not minting a guest.
- **Naming + no duplication** (ergonomist must-fix): role-neutral `peerName` on both facets (kills the `hostName`/`@host` collision the critic flagged); guards hoisted into a shared `EndoAgent` invitation vocabulary instead of copied.
- **Convergence contradiction** (decomplector must-fix): resolved section 9 vs open-question #1 — guest path is normatively no-mint; host path branches on inviter kind until the `@pins` retention question resolves.
- Plus: honest atomicity note (reentrant depth counter, not a mutex), peer-overwrite and registration-before-validate caveats, an explicit `accept` failure taxonomy, `§`→"section" and `façade`→`facade` code-point fixes, bulleted test-retain list with parallelism fixes, and the README registration points (recently-added block + count note), metadata `Updated` row, and author-name form.

**CI:** GREEN — 5/5 checks passed (lint, build, zizmor, test, browser-tests), 0 failed, via `ci-wait-merge.sh --no-merge` rc 0.

**Follow-ups:** None owed by this stage. The driver re-posts panel-2 to review the revision; several genuine Open questions remain in the design by intent (host-path convergence, what the `@pins/guest-*` mint protected, mid-accept recovery ordering, restart revocation, per-guest peer-registration bounds) for the maintainer/builder.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 73 tokens (3436403 cached reads)
- Output: 39892 tokens
- Cost: $3.7724564999999997
- Wall-clock: 1356s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
