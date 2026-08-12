# Conductor rebase before merge

| Created | 2026-08-12 |
| Author  | gardener |
| Status  | Accepted |

## Problem

The conductor doctrine already says to survey and rebase a pull request before
merging it. The deterministic merge spine does not. `ci-wait-merge.sh` can accept
green checks attached to an old head, unfreeze the base, and merge without ever
establishing that the head contains the live base tip. The botanist's
`--dependabot-auto-merge` path makes this gap especially important because that
path deliberately has no human signature at the merge point.

The merge spine must establish this invariant immediately before it begins the
CI wait:

> The exact remote PR head was replayed onto the freshly fetched live base, or the
> live base was already its ancestor; any rewritten head was lease-pushed, and
> all CI evidence accepted afterward belongs to that resulting head.

## The approval trap

A rebase changes commit identities. `pr-maintainer-approval-gh.sh` deliberately
accepts an approval only when its `commit_id` is the current `headRefOid`. Treating
a clean replay as approval-preserving would weaken that invariant: although the
patch may be equivalent, neither the new commit objects nor their interaction
with the intervening base were the objects the maintainer signed. It would also
create a general mechanism by which an agent-authored force-push could retain a
signature that GitHub correctly made stale.

The alternatives have these costs:

- A behind-count threshold leaves a knowingly stale interval and gives the
  threshold no safety meaning. It also still needs re-approval whenever it fires.
- Preserving the pre-rebase approval avoids a round trip, but defeats the exact-head
  approval gate and can miss changed conflict resolutions, hooks, generated files,
  or other differences introduced during replay.
- Rebasing only the signature-free Dependabot path fixes the most exposed caller
  but leaves the ordinary deterministic conductor inconsistent with its doctrine.
- A GitHub merge queue could supply equivalent base-update semantics, but it is
  not uniformly enabled and would move this invariant outside the spine.

The chosen rule is therefore: **rebase every behind head, and never preserve an
approval across the rewrite**. “Every” includes both ordinary and Dependabot
calls; a head that already contains the live base tip is exempt only because
`safe-rebase.sh` proves there is no operation to perform. On the ordinary path,
a rewrite intentionally ends this invocation at the existing current-head
approval gate after CI is green. The maintainer approves the rebased head, and a
later invocation observes the now-current branch, performs a no-op freshness
check, reuses CI from that same head, and merges. If the base moves again before
that merge, another rebase and approval are required. That is not a silent loop:
it is the approval invariant responding to a genuinely new base integration.

The Dependabot auto-conduct path has no approval round trip by design, so it
continues from the rebased head once that head's CI is green. In both paths,
`CHANGES_REQUESTED` remains an independent veto.

## Stage ordering

For a merge-capable invocation, the deterministic order is:

1. Resolve whether the narrow Dependabot approval bypass is eligible, without
   mutating the PR.
2. Unfreeze a frozen snapshot base to its live trunk. Refuse a shared frozen base.
3. Read the live base and exact remote head. Synchronize the isolated project
   worktree only by a clean fast-forward to that head; refuse dirty, ahead, or
   divergent local state.
4. Invoke the existing `safe-rebase.sh` against a freshly fetched live base.
   Its lockfile-only recovery remains the only automatic conflict resolution;
   any other conflict fails closed as `needs weave`.
5. If HEAD changed, publish it through `safe-push-pr-head.sh --mode rewrite`, whose
   fresh lease closes both peer-update races. Record the resulting head OID.
6. Poll `statusCheckRollup`, accepting a result only when the simultaneously read
   `headRefOid` equals the recorded post-rebase OID. An empty rollup remains
   pending. Thus a pre-rebase green run can never satisfy this stage.
7. Route terminal red to the existing `ci red: needs shepherd` outcome. On green,
   re-read and enforce `CHANGES_REQUESTED`.
8. On an ordinary call, require a maintainer `APPROVED` review on the current
   post-rebase head. On an eligible Dependabot call, omit only this signature.
9. Apply the existing downstream-stack branch-retention guard, merge, and verify
   `MERGED` or a live auto-merge request.

`--no-merge` remains a read-only CI probe. It neither unfreezes nor rebases because
it does not proceed to a merge.

## Worktree and failure boundary

Rebasing requires the caller's isolated project checkout. The spine uses
`GARDEN_PR_WORKTREE` when set and otherwise the current directory; conductor and
botanist doctrine require invoking it from the checkout returned by
`ensure-project-worktree.sh`. The helper validates that checkout rather than
creating a shared checkout or overwriting local work.

A non-lockfile conflict returns a distinct refusal from the rebase helper and is
rendered by the spine as `needs weave`; it never reaches CI or merge. Operational
metadata, fetch, or push failures also fail closed. Existing safeguards remain in
their relative positions: unfreeze/shared-stack before replay, current-head CI
and review vetoes before branch deletion and merge, and post-merge verification
last.

## Acceptance evidence

Regression coverage must exercise the composed spine for a behind clean head, a
conflicting head that never pushes or merges, red CI on the rebased OID, and an
ordinary approval that becomes stale across the rewrite and is accepted only
after approval of the new head. Existing tests continue to cover frozen bases,
the `CHANGES_REQUESTED` veto, Dependabot scope, branch retention, and merge-state
verification.
