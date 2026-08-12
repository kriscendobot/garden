# Dependabot MERGE-NOW auto-conduct

| Created | 2026-08-12 |
| Author | gardener |
| Status | Implemented |

## Directive

A botanist MERGE-NOW on a Dependabot pull request now conducts immediately on a
repository where the bot holds merge authority. The maintainer's direction is
that manual review does not economically increase confidence after the botanist
has completed its diligence, while the wait itself uneconomically adds risk.

What was removed is a human signature, not a check. MERGE-NOW still means that CI
is green; the maturity floor is satisfied (seven days after the freshest version
moved anywhere in the lockfile) or the upgrade closes a real CVE to which the
project is exposed; the source read is clean; and the full transitive set is
benign. Those botanist criteria were carrying the confidence before this change
and remain the whole confidence after it.

## Risk in both directions

Leaving a Dependabot pull request open has a security cost. Dependabot permits at
most one open pull request for a dependency, so the open proposal suppresses a
newer bump. That newer release is often the one that clears advisories left in the
currently proposed version. Seven re-verified, terminal MERGE-NOW rows remained
open behind the former signature gate when this directive was issued.

Automatic merge also has risk. A dependency can contain malicious or newly risky
code, a major bump can change behavior that existing tests do not cover, and a
mistaken supersession judgment can land a no-op or partial revert. The botanist
gate addresses those risks through source review, complete lockfile-transitive
analysis, advisory checks, the maturity rule or real-CVE exception, consumer
testing, and the base-ref census. A maintainer may still veto a particular change
with CHANGES_REQUESTED.

The trade chooses the reviewed, terminal disposition over an indefinite signature
wait: the extra signature adds little evidence, while the open pull request blocks
future remediation.

## Mechanical scope

The bypass lives in `scripts/jobs/gardening/ci-wait-merge.sh` and requires all of
these conditions:

1. The caller explicitly selects `--dependabot-auto-merge`. The default merge mode
   remains approval-gated.
2. A live `gh pr view --json author` read returns a login equal to
   `$GARDEN_DEPENDABOT_LOGIN` (default `dependabot[bot]`, case-insensitive). A
   failed read, invalid JSON, missing login, or different author keeps the
   approval gate.
3. The repository is inside the existing bot-owned merge boundary:
   `endojs/endo-but-for-bots` or a repository owned by `$GARDEN_BOT_LOGIN`. The
   garden repository, `endojs/endo`, `agoric/agoric-sdk`, and every unknown repo
   remain outside. A scope failure keeps the approval gate.

Only when all three conditions hold does the script omit
`pr-maintainer-approval-gh.sh`. The author and ownership checks happen before the
unfreeze step, so a mis-scoped opt-in cannot rewrite a human pull request's base.

## Deliberately unchanged

- `reviewDecision=CHANGES_REQUESTED` remains an absolute veto, checked separately
  after CI and before either approval path.
- CI must reach terminal green. Red exits for a shepherd; pending CI times out for
  re-enqueue rather than completing unmerged.
- Frozen bases are rewritten to the live trunk. A shared frozen base still stalls
  without mutation.
- A head branch used as another open pull request's base is retained. An unreadable
  downstream enumeration also retains it.
- The merge result is read back and must be MERGED or auto-merge-enqueued before
  success is reported.
- The botanist criteria gate is unchanged.
- Human-authored pull requests still need a current approval by a journal
  maintainer on the exact head.
- Non-owned upstream repositories receive a recommendation only. The bypass does
  not grant merge authority.

## Regression exercise

`scripts/jobs/test/ci-wait-merge-test.sh` drives the real shell spine against a
stubbed `gh` and proves the boundary without touching a live pull request. It
covers a human author with no approval (no merge), Dependabot with
CHANGES_REQUESTED (no merge), Dependabot on a bot-owned repo with no approval
(merge path taken), a non-owned repo (no bypass), and an unreadable author (no
bypass). The same suite continues to cover CI, unfreeze/shared-stack, branch
retention, and post-merge verification.
