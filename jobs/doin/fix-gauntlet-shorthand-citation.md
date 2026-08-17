---
role: gardener
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Fix: PR-shorthand citations silently skip the design-PR gauntlet gate

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR (CLAUDE.md § Conventions).

## What happened (the grounding incident — TWO instances today, same session)

`groom-endo-designs-readme` and its follow-on `groom-endo-stale-design-docs`
(both `role: designer`) each completed with a bot-authored, OPEN, DRAFT,
design-only PR (`endojs/endo-but-for-bots#1023` and `#1024`), and each
completion report cited its own PR as `endojs/endo-but-for-bots#1023` /
`#1024` — the shorthand `owner/repo#N` form — **not** the fully-qualified
`https://github.com/.../pull/N` form. Both PRs sat mergeable, CI-green, and
completely **without a staged design-panel gauntlet**, for over 20 minutes
with no gauntlet job anywhere on the board, until caught by manual
inspection. I staged both gauntlets by hand
(`endojs-endo-but-for-bots-pr1023-gauntlet`,
`endojs-endo-but-for-bots-pr1024-gauntlet`) as an immediate unblock; this job
is the actual fix.

## Root cause

Two sibling scripts each scan a job's completion report for the PR it names,
using a regex restricted to the fully-qualified URL form only:

```sh
grep -hEo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+' "$report"
```

- `scripts/jobs/auto-gauntlet-handoff.sh` (the stager: on a completed
  non-builder job with a design-only PR, records the gauntlet that gets a
  panel to review it before maintainer eyes).
- `scripts/jobs/assert-design-pr-gauntlet.sh` (the gate: refuses to record a
  job complete until that PR's gauntlet record exists — per
  `roles/designer/AGENT.md` "the design-panel gauntlet is staged
  automatically at job completion... you do not hand-post it").

Neither recognizes the `owner/repo#N` shorthand — even though
`scripts/jobs/common.sh`'s `parse_pr_ref()` (used later in both of these same
files, once a `pr_url` has already been found) **already parses both forms**:

```sh
parse_pr_ref() {
  if [[ "$a" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then ...
  elif [[ "$a" =~ ^([A-Za-z0-9._-]+)/([A-Za-z0-9._-]+)#([0-9]+)$ ]]; then ...
```

So when a completion report cites its own PR in shorthand — a form the house
style (`skills/fully-qualified-github-urls/SKILL.md`) asks agents to avoid
but that nothing mechanically prevents — the report-scanning `grep` finds
zero matches, `auto-gauntlet-handoff.sh` silently exits 0 with **no gauntlet
staged and no log line for a non-builder role** (see its own comment: "the
overwhelming majority of NON-builder jobs legitimately complete with no PR at
all, so stay silent for them"), and `assert-design-pr-gauntlet.sh`'s sensor
finds no PR reference either, so it does not block completion. The job
completes cleanly, and the PR is stuck exactly as if this were the
`garden-design-pr-gauntlet-bypass` cluster (kriskowal/garden#7,
endojs/endo-but-for-bots#809, kriscendobot/minion.town#41) all over again —
same symptom, different code path, and this path is a **silent** failure
(the builder path at least logs; the design-PR path does not, by design,
because it correctly treats "no PR" as the common case for most non-builder
jobs — but that same silence hides this bug).

## The fix

In both `auto-gauntlet-handoff.sh` and `assert-design-pr-gauntlet.sh`, the
report-scanning extraction must recognize **both** forms `parse_pr_ref`
already does, not just the full-URL form. Prefer one shared helper (add it to
`common.sh` alongside `parse_pr_ref`, e.g. `extract_pr_refs_from_text <file>`
that emits every full-URL AND every `owner/repo#N` match, one per line,
de-duplicated) that both scripts call, rather than fixing the two `grep`
lines independently and leaving a third copy of the same bug the next time a
new caller is added. Feed each shorthand match through `parse_pr_ref` (or
normalize it directly) so the rest of each script's logic — which already
expects `pr_url` to be resolvable by `parse_pr_ref` downstream — sees no
behavioral difference between a shorthand and a full-URL citation.

**Do not change house style** (agents should still prefer fully-qualified
URLs per `skills/fully-qualified-github-urls/SKILL.md` — that skill stays as
the guidance for how an agent *writes*). This fix is the mechanical backstop
so a report that doesn't follow the guidance still gets its PR correctly
recognized, matching the general principle already used elsewhere in these
same files: a mechanical safety invariant (every design PR gets a gauntlet)
should not depend on an agent's prose obeying a style rule.

## Acceptance

- A regression test (alongside the existing gauntlet-bypass tests — check
  `scripts/jobs/test/` for the existing `garden-design-pr-gauntlet-bypass`
  coverage and extend it, don't duplicate a parallel test file) that: posts a
  non-builder-role job whose completion report cites its own bot-authored,
  open, draft, design-only PR via the **shorthand** `owner/repo#N` form only,
  completes it, and asserts a gauntlet record now exists for that PR. Cover
  both the stager (`auto-gauntlet-handoff.sh`) and the gate
  (`assert-design-pr-gauntlet.sh`) paths.
- Existing tests for the full-URL form and for the builder path still pass
  unchanged.
- Report cites this incident (`endojs/endo-but-for-bots#1023`,
  `endojs/endo-but-for-bots#1024`) as the grounding example, per house style
  (name the artifact, don't just assert the lesson).

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T22:03:16Z
