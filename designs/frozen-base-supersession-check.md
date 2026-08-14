---
created: 2026-08-14
updated: 2026-08-14
author: gardener
---

# Frozen-base supersession check: don't rebuild a package that already exists on a frozen base

| Created | 2026-08-14 |
| Author  | gardener |
| Status  | Proposed |

## The incident (the fleet built `@endo/sha256` twice)

The fleet implemented `@endo/sha256` **twice** on `endojs/endo-but-for-bots`:

1. **`#836`** merged the package into the **frozen base** `llm-bfc91f5` — a
   snapshot of `llm` taken at PR-open time per [frozen-base-branch]. Once merged,
   the package lived on the `llm-bfc91f5` branch, *not* on live `llm`. It stays
   invisible from live `llm` until the frozen stack rebases forward — and
   `llm-bfc91f5` is currently **254 commits behind** live `llm`, stranding three
   PRs (`#836`, `#888`, `#943`).
2. **`#903`** was scoped ~10 days later by a producer that read **live `llm`** to
   answer "does `@endo/sha256` exist yet?", saw nothing, and built the package
   **from scratch**.

Disposition of the two PRs was handled in the originating job (`#903` is the
carrier, cross-referenced against `#836`). This design is the **structural fix**
so the fleet stops paying to build the same package twice.

The class is broader than one package. `llm-bfc91f5` alone strands three PRs 254
commits behind live `llm`, and the fleet has separately hit frozen-base drift on
`#621`, `#503`, `#475`, and `#910`. Any producer that scopes brand-new work by
reading the live trunk is blind to anything that merged into a frozen base and
has not yet rebased forward.

## Root cause: the "does this exist yet?" read is base-local

A producer scoping a brand-new package or feature answers "does this exist yet?"
by reading **one branch** — the live trunk (`llm`, `main`, or `master`):

- The builder infers a base by package availability with
  `git ls-tree origin/llm -- packages/<name>` (builder AGENT.md § *Infer the base
  branch from package availability*).
- The design→PR poller's *what counts as covered* rule
  ([design-to-pr-pipeline]) searches PRs, but keys the search on the **design
  slug**, so a package built without a matching design slug — or whose covering
  PR merged into a frozen base — is not counted.
- The builder's semantic-duplicate preflight (builder AGENT.md § *Verify no open
  PR already implements the issue*) searches `gh pr list --search "<N> in:title"`
  — keyed on the **issue number**, and only `--state open`... `all` but with a
  title match, which a frozen-base merge with an unrelated title misses.

None of these sees a package that merged into a frozen `<base>-<sha>` snapshot.
The frozen-base convention is working as designed — it *isolates* each PR from
trunk drift — but that same isolation hides merged work from the next scoping
read until a rebase-forward lands it on the live trunk.

Two candidate fixes were proposed in the originating finding. This design adopts
**(1)** as the landing cut and proposes **(2)** to the maintainer as the
complementary half.

## The two halves: pull (query-time) and push (index-time)

The finding's two candidates are not competitors; they are the **pull** and
**push** halves of one invariant ("scoping sees work merged into a frozen base"):

- **Candidate 1 — supersession check at build-scoping time (this design).** A
  *pull*: before brand-new work starts, query open + recently-merged PRs
  fleet-wide, **across all bases**, plus the fork's own frozen-base branches, for
  the same package path / changeset slug. A hit surfaces "this may already be
  built on base X" for a human/liaison decision. Narrow, additive, no policy
  change — lands here.
- **Candidate 2 — a policy on merging into frozen bases (maintainer followup).**
  A *push*: net-new packages/features land only on the **live** base; frozen
  bases take only fixes to work already on that base; and a merge that does put
  net-new work on a frozen base emits a fleet-visible note. This is a fleet-wide
  policy call — flagged for the maintainer in § *Proposed followup*, not landed
  unilaterally.

The pull half stands alone: it catches the strand **even if no note was ever
emitted**, because it reads the actual PR/branch state. The push half makes the
catch cheap and authoritative rather than a search that can miss. Landing the
pull first means the fix works immediately against the *existing* strands
(`llm-bfc91f5` et al.) with no dependency on new discipline being followed at
every future frozen-base merge.

## What "brand-new work" means (when the check fires)

The check fires only when a producer is scoping work that would **create a new
package or a net-new feature** — the case where "does this exist yet?" is the
load-bearing question. It does **not** fire for:

- a **fix** to an existing package (the package is already on the live base; the
  supersession question is moot),
- a **weave/rebase/retcon/merge/ferry** job (these operate on an existing PR),
- a **probe** ([gap-revealing-build]) whose deliverable is a gap report, not a
  mergeable package.

Concretely the check runs when a producer would post a `build` job (or a liaison
would, in-session) whose scope introduces a package directory that does not exist
on the live base, or a feature the poster believes is net-new. The signal that
distinguishes "new package" from "fix" is exactly the builder's existing
availability probe: the touched package is **absent from the live base's tree**.
That absence is the trigger — and precisely the condition under which a
frozen-base strand is possible.

## What the check queries

The check takes one or more **identity keys** for the work being scoped and asks,
across the whole fork's PR and branch state, "has this already been built
anywhere?" Two identity keys, strongest first:

1. **Changeset slug.** A change that ships observably carries a `.changeset/<slug>.md`
   entry ([changeset-discipline]). The slug is unique per change and is the
   strongest supersession key — a slug collision is almost never coincidental.
   When the scoped work has a known changeset slug (from the design, or the
   producer can synthesize the expected one), search it.
2. **Package path / name.** `packages/<name>/` and the npm name `@endo/<name>`.
   Weaker than the slug (English-noun collisions), but available even before a
   changeset exists, and the direct answer to "does this package exist yet?".

Against those keys the check runs **two independent lookups** and unions the
results:

### Lookup A — PR search across all states and bases (fast, cross-references)

```sh
gh pr list -R <owner>/<repo> --state all --limit 50 \
  --search '<key>' \
  --json number,title,state,baseRefName,mergedAt,url
```

Crucially **not** base-scoped: `--search` spans every base, so a PR merged into
`llm-bfc91f5` surfaces alongside one open against live `llm`. For each hit,
inspect `baseRefName`:

- base matches `^(llm|main|master)-[0-9a-f]{4,40}$` → the hit is **on a frozen
  base**. This is the exact strand: report base + PR number + `mergedAt`.
- base is a live trunk → an ordinary open/merged duplicate; report it too (this
  subsumes the builder's existing semantic-duplicate preflight).

`--state all` is required: `#836` was **merged** (into the frozen base), so an
`--state open` search would have missed it.

### Lookup B — frozen-base branch tree scan (authoritative for own frozen bases)

Lookup A depends on a PR still existing and referencing the key. A frozen-base
branch outlives its PRs only until [frozen-base-branch]'s *sweep on close*
deletes it, but between merge and sweep — and for any package that landed via a
direct push — the authoritative source is the branch tree itself:

```sh
# Enumerate the fork's live frozen-base branches for this trunk.
git ls-remote --heads origin 'llm-*' 'main-*' 'master-*' \
  | awk '{print $2}' | sed 's#refs/heads/##'

# For each, does the package path exist on it (but not on the live base)?
for fb in $frozen_bases; do
  if git ls-tree -r --name-only "origin/$fb" -- "packages/<name>/package.json" \
       | grep -q .; then
    echo "STRAND: packages/<name> exists on frozen base $fb"
  fi
done
```

Lookup B is the authoritative check for the **fork's own** frozen bases; Lookup A
adds cross-PR references and catches work whose frozen base was already swept but
whose merged PR record remains. Union both; dedupe by PR number / base.

Both lookups are **deterministic — no LLM.** They read PR metadata and git trees
only; no untrusted text enters a model's context, so the check is injection-safe
by construction and can run in plain shell.

## Where the check runs — two call sites

### Call site 1 — the producer, before posting a `build` job (primary)

This is the load-bearing site: catching supersession **before work starts** is
the whole point. The producers that mint brand-new build scope are the design→PR
poller ([design-to-pr-pipeline]), the triager posting a maintainer `build X`
directive, and the liaison in-session.

Wire a deterministic helper — `scripts/jobs/supersession-check.sh <owner/repo>
<trunk> <key>...` — that runs lookups A and B and prints hits (or nothing). The
producer runs it as a **pre-post gate**:

- **No hit** → post the `build` job as normal.
- **Hit** → do **not** silently post the build. Instead:
  1. Park the intended build on the plan queue with a hold gate:
     `scripts/jobs/post-plan.sh --gate supersession-hold <base> <body>` (invisible
     to the foreman; requires an explicit promote), and
  2. Surface the hit to the maintainer via the liaison's inbox
     (`message-user.sh` from a producer job, or the liaison writes it in-session):
     *"`@endo/<name>` may already be built on frozen base `llm-bfc91f5` (#836,
     merged 2026-08-02). Rebuild anyway, or rebase that stack forward instead?
     Parked as `<base>` pending go-ahead."*

The maintainer's answer is a one-line decision: **promote** the parked build
(genuinely new / the strand is stale), or **redirect** to a rebase-forward of the
stranded stack (the work already exists). Either way the fleet does not pay to
rebuild blind.

The design→PR poller's *what counts as covered* rule ([design-to-pr-pipeline])
gains the changeset-slug/package-path keys as an **additional** covered signal:
a design whose package already exists on a frozen base is *covered* (by the
strand) and the poller parks-and-surfaces rather than posting a fresh tracking
PR.

### Call site 2 — the builder's preflight, as a backstop (defense in depth)

The producer gate is the primary defense, but a `build` job can be posted by a
path that skipped it (a hand-posted job, a re-issued directive). So the builder's
existing *Verify no open PR already implements the issue* preflight is **widened**
to run the same supersession check by package path / changeset slug, across all
bases, before opening the worktree:

- **Hit** → the builder **stops at impasse** (does not open a duplicate PR),
  messages the maintainer with the existing PR + its base, and surfaces the
  finding in its completion report. It does **not** flip to building anyway.

This backstop is cheap (two `gh`/`git` calls) and closes the gap the producer
gate can't — a build that reached a gardener without passing the gate.

## The helper script

`scripts/jobs/supersession-check.sh` (no LLM, deterministic, injection-safe):

- **Inputs:** `<owner/repo> <trunk>` then one or more identity keys
  (`--package <name>`, `--changeset <slug>`).
- **Behavior:** runs Lookup A + Lookup B, unions and dedupes hits, classifies
  each as `frozen-base` (base matches the `<trunk>-<sha>` pattern) or `live`.
- **Output:** one line per hit — `<class>\t<pr-or-branch>\t<base>\t<url-or-ref>`
  — and exit `0` with **no output** when clean, so a caller can gate on
  `[ -n "$(supersession-check.sh …)" ]`.
- **Fail-open on infra error** (network/`gh` failure): print a diagnostic to
  stderr and exit `0` with no hits, so a transient `gh` outage never *blocks* a
  legitimate build. The cost of a missed check is a possible rebuild (caught by
  the builder backstop); the cost of a false block is a stalled producer. Bias to
  not-blocking, consistent with the accounting/gate fail-open posture elsewhere in
  the fleet.

## Why not just rebase the frozen stacks forward?

Rebasing `llm-bfc91f5` (and its ilk) forward onto live `llm` *would* make the
merged package visible — but that is a separate, heavier problem (254 commits of
drift, conflict resolution, three stacked PRs) and it does not *prevent* the next
strand: as long as any PR is open against a frozen base, a same-named package can
be scoped against live trunk in the window before that stack rebases. The
supersession check is correct **independent of** how promptly frozen stacks
rebase; it reads the strand directly. Rebasing the specific stranded stacks is
worthwhile janitorial work but is out of scope here (and owned by the existing
weave/rebase job vocabulary).

## Proposed followup for the maintainer (candidate 2)

Recommend flagging candidate 2 to the maintainer as a **policy** followup, not
landing it here:

> **Frozen bases take only fixes to work already on that base; net-new packages
> and features land on the live trunk.** When a net-new package nonetheless
> merges into a frozen base, the merge step emits a **fleet-visible journal
> note** (`frozen-base-additions/<trunk>-<sha>.md`, or a `message`-bus broadcast)
> recording "package/feature X now exists on frozen base Y". The next scoping read
> — and the supersession check's Lookup B — then has an authoritative index entry
> instead of relying on a branch-tree scan.

Why propose rather than land:

- It changes **merge discipline** across every fork PR, a fleet-wide behavior
  change the maintainer should ratify (cf. the frozen-base convention itself,
  which was a maintainer directive on 2026-05-22).
- The pull half (this design) already prevents the incident's cost, so the push
  half is an optimization, not a prerequisite. The maintainer can weigh it
  against the merge-step complexity it adds.
- The note-emission sub-part is a strictly additive, lower-risk slice the
  maintainer might accept even if declining the full "net-new only on live"
  policy — worth surfacing as its own option.

## Scope and staging

- **Lands here (this design's build):**
  1. `scripts/jobs/supersession-check.sh` — the deterministic helper (Lookups
     A + B, classify, fail-open).
  2. A new `skills/supersession-check/SKILL.md` capturing the procedure, the two
     call sites, and the hit-surfacing decision.
  3. Wiring: [design-to-pr-pipeline] *what counts as covered* gains the
     package-path/changeset-slug keys and the park-and-surface branch; the
     builder's *Verify no open PR already implements* preflight calls the helper
     as its widened backstop; the triager's build-post step runs the gate.
- **Flagged to the maintainer (out of scope to land):** candidate 2's frozen-base
  merge policy + fleet-visible note.

## Definition of done

- The helper script exists, is deterministic (no `claude -p`), fails open on
  infra error, and classifies hits `frozen-base` vs `live`.
- The producer gate parks-and-surfaces on a hit rather than posting a blind
  `build`; the builder backstop stops-at-impasse on a hit rather than opening a
  duplicate.
- The `@endo/sha256` incident is walked as the worked example: scoping `#903`
  with the check in place would have returned the `#836` frozen-base hit and
  parked the build for a maintainer decision.
- Candidate 2 is written up as a maintainer followup, not landed.

## Composition with existing skills

- [frozen-base-branch] — the convention whose isolation creates the strand; this
  check reads the `<base>-<sha>` naming pattern to classify a hit as frozen-base.
- [design-to-pr-pipeline] — the primary producer call site; its *covered* rule
  gains the supersession keys.
- [changeset-discipline] — the changeset slug is the strongest supersession key.
- [gap-revealing-build] — a probe is exempt (its deliverable is a gap report, not
  a mergeable package).
- [library-lookup] — orthogonal; supersession asks "was this *built*", not "is
  this *documented*".

[frozen-base-branch]: ../skills/frozen-base-branch/SKILL.md
[design-to-pr-pipeline]: ../skills/design-to-pr-pipeline/SKILL.md
[changeset-discipline]: ../skills/changeset-discipline/SKILL.md
[gap-revealing-build]: ../skills/gap-revealing-build/SKILL.md
[library-lookup]: ../skills/library-lookup/SKILL.md
