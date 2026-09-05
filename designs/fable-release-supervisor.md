<!-- garden-design-open-questions -->

# A Fable release supervisor: deterministic gates, human-only ferry

| Created | 2026-09-04 |
| Author  | designer |
| Status  | Proposed |

Maintainer @kriskowal asked (kriscendobot/garden#58): *"enable a Fable supervisor
to approve changes that have undergone a full gauntlet, satisfied the release
criteria, and been proven deployed to production."* This design proposes a
supervisor that can grant the **approval** the conductor's merge gate today
requires a human to provide, but ONLY behind a closed, deterministic set of
gates and ONLY for `kriscendobot/minion.town`. It carries an open question
(§ Open questions) and so lands as a review PR, not bare.

The supervisor's sole initial scope is the `kriscendobot/minion.town` own-fork PRs
the resumed `minion-town-press` schedule advances (issue #58 is the minion.town
primary-phase agenda). No other repository is eligible until a maintainer revises
this design.

## What "approve" means today, and the gap

The conductor merges a fork PR only when `pr-maintainer-approval-gh.sh` finds an
**effective APPROVED** review from a login in `journal2:maintainers/allowlist`
(`roles/conductor/AGENT.md` step 4). That signature is a *human* act. The one
existing exception is the botanist's `--dependabot-auto-merge` path
(`designs/dependabot-auto-merge.md`), which *substitutes a completed-criteria gate
for the signature* while retaining every other conductor guard. The release
supervisor is the same shape, generalized: a set of deterministic gates standing
in for the human signature, but for bot-authored feature work rather than a
Dependabot bump.

## The three gates (deterministic preconditions, not LLM judgment)

Each gate is a plain-code predicate an LLM supervisor **confirms but cannot
hand-wave past**. This is the same discipline as the approval reconciler
(`designs/approval-reconciler.md`), which re-derives every gate from ground truth
and "never mints a job that would stall at the merge gate."

```mermaid
flowchart LR
  PR[bot-authored own-fork PR] --> A{Gate A<br/>full gauntlet}
  A -- pass --> B{Gate B<br/>release criteria}
  A -- fail --> STOP[not approvable]
  B -- pass --> C{Gate C<br/>deploy proof}
  B -- fail --> STOP
  C -- pass --> TOK[supervisor writes<br/>approval token]
  C -- fail --> STOP
  TOK --> CD[conductor re-runs A+B+C<br/>consumes token, merges]
  KILL["kill switch off / token revoked / maintainer veto or unresolved feedback"] -. vetoes .-> CD
```

### Gate A: the full gauntlet passed

**Signal (existing, concrete):** the PR's gauntlet record
(`<owner>-<repo>-pr<N>-gauntlet`) reached its terminal transition in
`scripts/jobs/gauntlet.sh`: a last stage marker of `panel-<k> pass` followed by
`undraft done`, written as `gauntlet-status: complete`. The record is **not**
`tada_failed`/halted. Corroborated by live state: the PR is currently **not draft**
(`gh pr view --json isDraft` = false), CI is green at the current head, and no
maintainer holds an effective `CHANGES_REQUESTED`.

Maintainer feedback is also a veto. Every maintainer-authored review comment on the
candidate must have an author response and maintainer acknowledgment. For an inline
thread, the deterministic acknowledgment is the maintainer resolving the thread or
submitting a later `APPROVED` review. A later `APPROVED` review also acknowledges
earlier top-level feedback. Any unanswered item, answered-but-unacknowledged item,
or unreadable review state fails closed. This check may read comment metadata and
bodies from allowlisted maintainers; other comment text remains untrusted input and
cannot satisfy or bypass the gate.

### Gate B: release criteria satisfied (NEW; proposed here)

There is **no `release criteria` concept in the garden today.** This design
proposes one: a per-repo, **maintainer-authored** manifest on the journal,
`journal2:release-criteria/<owner>-<repo>.yaml`, read by a new deterministic
handler `scripts/jobs/handlers/release-criteria-gh.sh <owner/repo> <N>` (sibling of
`pr-mergeable-gh.sh`). **Fail-closed:** a repo with no manifest is **not**
release-eligible; the supervisor cannot approve it. The manifest is a *closed* set
of checkable predicates, each resolvable in plain code and each emitting a
per-predicate result line for the audit record:

- `required-checks:`: named CI checks that must be green (beyond the rollup).
- `changeset-present:`: a changeset / version-bump file per
  [changeset-discipline](../skills/changeset-discipline/SKILL.md).
- `no-release-blocker-labels:`: for example, `do-not-merge`, `needs-design`.
- `no-blocker-markers:`: the diff carries no `TODO(release-blocker)` /
  `FIXME(release-blocker)`.
- `linked-issue-state:`: a referenced tracking issue is in a terminal/accepted
  state.
- `coverage-floor:` / `max-diff-size:`: a coverage floor where the repo reports
  it; an upper diff bound (a very large change is never auto-approvable).

The handler returns 0 only when **every** manifest predicate passes. New predicate
kinds are added only by a maintainer editing the manifest. Like
`maintainers/allowlist`, the manifest is itself the arming act, and it is
journal-tracked (attributable, diffable).

### Gate C: proven deployed to production (NEW artifact; proposed here)

Deploy proof is a **captured artifact of a real run**, never a supervisor
assertion. An out-of-band deploy+probe run writes
`journal2:deploy-proofs/<owner>-<repo>/<head-sha>.json` carrying: the head SHA, the
deploy target, the probe command(s), the exit code, a rendered-observation digest,
a timestamp, and the producing session id. For minion.town the probe is the
deployed-topology evidence pattern already in use: build the candidate, deploy that
exact head to the live production daemon, and run the end-to-end production probe
(the Gate-2 bridge CC-token -> Cognito -> `/mcp` recipe; `designs/*` minion.town
topology). CI is separately required by Gate A and never substitutes for this live
deployment observation.

The gate (checked by the supervisor and, defense-in-depth, re-checked by the
conductor) requires a proof that (1) **matches the merge-candidate head SHA**, (2)
is within a freshness window, and (3) recorded exit 0 plus a positive probe
observation. The supervisor confirms the artifact; it does not manufacture it.

Keying the proof to the head SHA inherits the CI/approval **staleness** subtlety: a
rebase changes the SHA, so a rebase invalidates the proof (re-deploy + re-probe
required) exactly as it invalidates CI freshness. The candidate must be deployed
and probed before the approval token is written; a later rebase requires a new
production deploy and probe.

## What "approve" mechanically is, and its audit trail

**Primary mechanization: a supervisor-approval token.** The supervisor records
`journal2:approvals/supervisor/<owner>-<repo>/pr<N>-<head-sha>.md`, carrying the PR,
head SHA, and evidence pointers for gates A/B/C (record paths + per-predicate
results), plus the delegating maintainer or supervisor, the mandate that authorized
the delegation, a timestamp, the model, and the session id. The token is append-only,
attributable via git history, and revocable. It is the proxy exercise of authority
rooted in a maintainer; there is no separate supervisor allowlist and a bot review
does not become maintainer approval.

**Conductor consumption: a scoped `--supervisor-approved` path** on
`scripts/jobs/gardening/ci-wait-merge.sh`, mirroring `--dependabot-auto-merge`. It
substitutes the token for the human signature but retains **every** other conductor
guard: unfreeze, rebase, CI freshness at the post-rebase head, the
`CHANGES_REQUESTED` veto, branch retention, and post-merge verification. Crucially,
before honoring the token the conductor **re-runs all three gates in plain code**
(the token is a *claim*; the gates are ground truth) and requires the token's head
SHA to equal the current head. A rebase invalidates the token, forcing a fresh
supervision, exactly the staleness discipline `pr-maintainer-approval-gh.sh` applies
to humans.

**Why a distinct token, not adding the bot to `maintainers/allowlist`:** that list
means *humans* everywhere it is read (the approval gate, the issue-inbox gate, the
mention gate). A separate supervisor token is separately revocable and separately
kill-switchable without weakening human-approval semantics. The conductor validates
the token's maintainer-rooted delegation chain instead of consulting another allowlist.

**Audit + revocation + kill switch.** Every token is a journal commit (attributable,
timestamped, diffable); the conductor records which token it consumed in its merge
report. Revocation is a maintainer write
(`approvals/supervisor/<owner>-<repo>/revoked/pr<N>`), and a human
`CHANGES_REQUESTED` always vetoes. Unanswered or maintainer-unacknowledged feedback
also vetoes, as defined by Gate A. No fixed cooling-off interval is required because
these vetoes remain available until the token is consumed.
The kill switch is a journal flag `config/fable-supervisor` (off by default; follows
the `leader` marker like the foreman brake). When off, no supervisor dispatches and
the conductor's `--supervisor-approved` path refuses. Repository scope is fixed to
`kriscendobot/minion.town` in the role and deterministic handler, not in a separate
allowlist.

## Two hard invariants

### Dispatch authority and the unambiguous liaison command

`skills/model-selection/SKILL.md` states plainly: *"No automatic path may emit
Fable/mentat or any other manual-only pin,"* enforced in `job_eligible_for_kind` /
`claim-job.sh` and the gardener handler (they refuse `tier: mentat` unless
`dispatch: manual`). A **standing/automatic** Fable supervisor is exactly the
automatic-emits-mentat path this forbids. The release supervisor is therefore
manual-only.

The role name is `release-supervisor`. Its unambiguous liaison invocation is
`supervise release <owner/repo>#<N>`. The liaison accepts that command only from a
maintainer or from another supervisor acting under a recorded mandate that explicitly
includes release supervision. It posts a `role: release-supervisor`, `tier: mentat`,
`dispatch: manual` job carrying the delegator and mandate evidence. The job is never
created by a schedule, watcher, ordinary worker, or automatic promotion. The target
must be `kriscendobot/minion.town`; all other repositories fail closed.

The role is Fable-only. It carries no `fallback-tier`; if mentat is unavailable, the
job waits or fails rather than downshifting an authority decision to another tier.

### Approval is NOT ferry

The supervisor operates **strictly on the garden's own forks**; its approval
authorizes only the **bot-identity** merge the conductor already performs. It
**NEVER** originates `identity_switch_authorized: true` and **NEVER** approves an
upstream ferry. That flag is *"a flag no agent may originate; only the
maintainer"* (CLAUDE.md § The ferry, `designs/fleet-gh-identity.md`).
The ferry is **permanently** outside the supervisor's vocabulary, never merely
deferred, mirroring the sysop's
permanent exclusion of ferry and identity switches (`designs/sysop.md`).

## Files

- `roles/release-supervisor/AGENT.md`: the manual-only, Fable-only role; validate
  its delegation chain, confirm gates A/B/C, write the
  token, never ferry.
- `skills/release-criteria/SKILL.md`: the manifest format and predicate vocabulary.
- `scripts/jobs/handlers/release-criteria-gh.sh`: Gate B handler (no LLM), scoped
  initially to `kriscendobot/minion.town`.
- `scripts/jobs/gardening/ci-wait-merge.sh`: grows `--supervisor-approved` (re-runs
  A/B/C; consumes the token; every other guard unchanged).
- Journal state: `release-criteria/<owner>-<repo>.yaml`,
  `deploy-proofs/<owner>-<repo>/<sha>.json`,
  `approvals/supervisor/<owner>-<repo>/...`, and `config/fable-supervisor`.

## Open questions

- **Who authors the first release-criteria manifest, and its initial predicate
  set?** The manifest is maintainer-authored and fail-closed. What is the starting
  set for `kriscendobot/minion.town`?
