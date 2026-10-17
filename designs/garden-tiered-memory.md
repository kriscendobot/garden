---
created: 2026-10-17
updated: 2026-10-17
author: gardener (designer), job design-garden-tiered-memory
---

# Design: a two-tier, fleet-coordinated garden memory

| Created | 2026-10-17 |
| Author  | gardener (designer) |
| Status  | Proposed |

The liaison's memory today is Claude Code's auto-memory directory
(`.claude/projects/-home-kris-garden/memory/`): about 81 one-fact files plus a
`MEMORY.md` index, gitignored and host-local. A fact the liaison learns on one
host does not exist on any other host, and no gardener ever sees it. The
maintainer decided (kriskowal, liaison session 2026-10-17) that memories must be
capturable **in the garden**, so every host and the fleet share them, with
**tiers** so nothing sensitive is published. This design specifies the tiers, the
only write path into the shared tier, the read path at session start and at claim
time, the role and doc edits, and the migration of the existing memories.

The hard constraint: `kriscendobot/garden` is **public**, and `journal2` is pushed
to that same origin. Anything committed to the journal is published, and deleting
it later does not unpublish it (forks, caches, the reflog of every clone).

## 1. Tiers

| Tier | Where | Who reads it | How a fact gets there |
| --- | --- | --- | --- |
| **Private** (default) | `.claude/projects/-home-kris-garden/memory/` on each host, unchanged | the liaison on that host only (Claude Code auto-loads `MEMORY.md`) | the liaison writes it as today; this is the default for every new memory |
| **Shared** | `memory/` on `journal2` (`journal/memory/` in every checkout) | the liaison on every host, and every gardener at claim time | only `scripts/jobs/share-memory.sh` (§ 2), an explicit act |

Nothing moves from private to shared automatically, ever. No sync daemon, no
watcher, no "share all of type X" rule. Sharing is one deliberate invocation per
fact.

### Shared-tier file shape

One fact per file, `journal/memory/<slug>.md`, in the frontmatter shape the
private tier already uses, plus three fields:

```markdown
---
name: bearer-tokens-vs-ocaps
description: A bearer token is ocap-coherent when it designates one object, not an identity
metadata:
  type: feedback            # user | feedback | project | reference
shareable: true             # literal; required; the write path refuses anything else
updated: 2026-10-17         # last content change (absolute date)
reviewed: 2026-10-17        # last time someone confirmed it is still true
---

<the fact; for feedback/project, **Why:** and **How to apply:** lines.
Links: [[other-shared-slug]].>
```

- `name` must equal the filename slug. The slug is the identity used for
  conflicts and retirement (§ 3).
- `[[links]]` may only name other **shared** slugs. A link to a private memory
  would publish that memory's name and dangle on every other host.
- `originSessionId` and `node_type` (seen in some private files) are dropped. A
  session id is host-local noise.
- `user`-type memories are not shareable in v1 (§ 5 rubric): they describe the
  maintainer as a person.

### Shared-tier index

`journal/memory/README.md` follows [context-library](../skills/context-library/SKILL.md)
discipline: a short abstract, then one line per fact, grouped by `metadata.type`:

```markdown
- [bearer-tokens-vs-ocaps](bearer-tokens-vs-ocaps.md) — A bearer token is ocap-coherent when it designates one object, not an identity
```

The index is **generated** from frontmatter by the write and retire scripts and
is never edited by hand. A hand edit would drift from the files, and a merge
conflict on a generated file resolves by regenerating it (§ 3).

## 2. Write path

`scripts/jobs/share-memory.sh <file>` is the only way any agent writes into
`journal/memory/`. It runs in plain code, with no LLM, and fails closed:

1. **Shape gate.** It refuses unless the frontmatter parses; `shareable: true` is
   present literally; `name` matches `^[a-z0-9][a-z0-9-]*$` and the target
   filename; `metadata.type` is `feedback`, `project`, or `reference`;
   `description` is one line of 200 characters or fewer; `updated` and `reviewed`
   are ISO dates; and every `[[link]]` names an existing shared slug. A file
   without `shareable: true` gets "unmarked: memories are private by default".
2. **Secret scan.** `scripts/jobs/memory-secret-scan.sh <file>` (also usable
   standalone) rejects on any hit and prints the rule id and line, never the
   matched text. Rules:
   - credential prefixes: `sk-ant-`, `sk-`, `ghp_`, `gho_`, `ghs_`, `ghu_`,
     `github_pat_`, `xox[abp]-`, `AKIA`/`ASIA` access-key ids, `-----BEGIN`,
     `Authorization:`/`Bearer ` followed by a value;
   - cloud identifiers: 12-digit AWS account ids, `arn:aws:`, EC2 instance ids
     (`i-[0-9a-f]{8,17}`), Route53 zone ids (`Z[0-9A-Z]{12,}`), KMS key ids
     (UUID shape near `kms`);
   - high-entropy runs: base64 or base64url of 32 or more characters, or hex
     longer than 40 characters (so git SHAs pass);
   - email addresses, except `*@users.noreply.github.com`;
   - private-repo references: any `owner/repo` slug or `github.com/owner/repo`
     URL whose repo is not public. Visibility is read with
     `gh api repos/<owner>/<repo> --jq .visibility`, cached per run. An
     unreachable or unknown repo counts as private;
   - private-matter markers: `PRIVATE`, `do not share`, `confidential`,
     `registrar`, `password`, `passphrase`, `subscription`, `quota`, and the
     account-pool names listed in `config/budget-pools`;
   - absolute host paths outside the garden root, such as `/root/` or `/etc/`.

   There is **no override flag**. A false positive is fixed by rewording the fact
   (for example, "an AWS account" instead of the id). Every bypass would become
   the path of least resistance, and on a public repo a bypass cannot be taken
   back.
3. **CAS against the version you read.** The script records the blob id of
   `memory/<slug>.md` at `origin/journal2` before writing (or "absent"). Under the
   journal lock it fetches, and if the remote blob changed since, it refuses with
   "memory changed under you; re-read and retry". If not, it writes the file,
   regenerates `README.md`, commits with the bot identity (message
   `memory: share <slug>` plus an `Origin-Host: <GARDEN>` trailer), and pushes
   through the journal's existing rebase-and-push CAS loop.
4. **Private copy removal.** On success it prints the private-tier path to
   delete. The liaison deletes it and its `MEMORY.md` line, so the fact has one
   source. The script cannot delete it itself: it runs on the host where the fact
   was written, but it does not assume the caller's memory directory.

Gardeners do not call `share-memory.sh`. A gardener that learns something
fleet-worthy adds a `## Memory candidates` section to its completion report; the
liaison sees it at muster and decides. *Considered and rejected:* gardener
self-sharing. *Reason:* sharing publishes text, and publishing is a
maintainer-facing decision that belongs to the role in the loop with the
maintainer.

**Backstop.** The leader runs a daily `memory-audit` schedule: it runs
`memory-secret-scan.sh` over every file under `journal/memory/` and the shape
gate over the set, catching anything that arrived by a hand commit. A hit raises
a `watchdog-notice.sh` alert. It never auto-deletes, because by then the text is
already published and the response is **rotate the exposed credential first**,
then retire the file (§ 3). The audit is detection, not prevention.

## 3. Read path, conflicts, retirement

**Liaison.** Session preflight gains a third step, after the container guard and
the virgin probe: read `journal/memory/README.md` (index only), alongside the
auto-loaded private `MEMORY.md`. Bodies are read on demand by path, the same way
the private tier works.

**Gardeners.** `worker_job_prompt` (`scripts/jobs/handlers/worker-common.sh`)
appends a `SHARED GARDEN MEMORY (index; read a body with cat when relevant)`
block holding the index from the host's journal checkout, read from the commit
the claim already synced, so no extra fetch is needed. Cost bound: the block is
capped at **6 KiB** (about 40 lines at the 200-character description cap, a few
thousand tokens). Past the cap the block is truncated with a pointer to the full
README, and `memory-audit` raises a "shared index over budget" notice so the set
gets pruned or split into `memory/<scope>/` subtrees with their own READMEs, per
context-library. Memory text is bot-authored through a gated script, so it is
trusted like the rest of the journal, not handled as foreign content.

**Host conflicts.** One fact per file plus the per-file CAS in § 2 means two
hosts editing *different* facts never conflict (the index is regenerated after
rebase). Two hosts editing the *same* fact: the second writer is refused and
must re-read the winner's text and fold its change in. Neither side wins
silently. Two hosts creating the *same new slug*: the first push wins and the
second gets the same refusal.

**A private fact contradicting a shared one.** The shared fact governs fleet
behavior. The liaison that notices the contradiction either updates the shared
fact through `share-memory.sh` or deletes its private copy.

**Staleness and retirement.**
- `scripts/jobs/retire-memory.sh <slug> <reason>` deletes the file, regenerates
  the index, and commits `memory: retire <slug>` with the reason in the body. Git
  history is the archive. There is no tombstone directory: a retired fact
  should stop costing index bytes.
- A fact that turned out **wrong** is retired, or rewritten if a corrected fact
  replaces it, the same day it is found. A wrong shared memory misleads every
  host at once, which is exactly what this design makes possible.
- `memory-audit` also lists entries whose `reviewed` date is more than 60 days
  old into the maintainer inbox as one coalesced item. At muster the liaison
  re-confirms each one (bumping `reviewed` through `share-memory.sh`) or retires
  it. Point-in-time PR-status facts ("#NNN superseded, recommend close") are the
  usual case: once the PR is closed they are retired, not kept.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| liaison → `share-memory.sh` | the script (shape gate, scan, CAS) | the § 5 rubric, applied by the liaison | none until the push | the liaison invokes; the script may refuse | one candidate file |
| `share-memory.sh` → `journal2` | the journal push CAS | none | `memory/*.md`, the generated `README.md` | the accepted push | one commit |
| `journal2` → gardener | `worker_job_prompt` read of the synced checkout | 6 KiB cap | none (read-only) | none | the index text |
| `memory-audit` → maintainer | scheduled scan plus `watchdog-notice.sh` | 60-day review age | a host-local notice cache | none: it alerts, never edits | rule ids and slugs, never matched text |

Restart and replay: every step is idempotent. Re-sharing an unchanged file is a
no-op commit that the script skips, and a retire of an absent slug exits 0.

## 4. Role and doc changes

- **`roles/liaison/AGENT.md`**, new § *Memory*: private is the default; a
  candidate is shared only through `share-memory.sh`, after applying the § 5
  rubric; after sharing, delete the private copy; triage `## Memory candidates`
  and `memory-audit` items at muster; never put shared-tier content in the private
  `MEMORY.md`.
- **`roles/COMMON.md`**, new § *Shared garden memory*: the prompt carries the
  shared index; read a body before acting on a matching task; never write under
  `journal/memory/` directly; propose a fact through `## Memory candidates` in
  the report, written as a candidate the liaison can share as is (no secrets, no
  private-repo detail).
- **`CLAUDE.md`**: the session-preflight list gains step 3 (read the shared
  index); § Layout gains a `journal/memory/` bullet. The memory instructions the
  harness injects into the liaison stay valid for the private tier. CLAUDE.md
  adds one sentence: "the harness memory directory is the *private* tier; shared
  facts go through `share-memory.sh`."
- **`skills/garden-memory/SKILL.md`** (new): the rubric, the scripts, the
  leak-response runbook (rotate, then retire, then tell the maintainer).

## 5. Migration of the existing memories

**Nothing is copied or pushed by this design.** The per-memory classification is
delivered to the maintainer inbox for veto (job `design-garden-tiered-memory`,
2026-10-17). Its reasons are written so they reveal nothing beyond the slug,
because the inbox is on `journal2` too and is just as public. Once the
maintainer has ruled, a follow-up build migrates the approved set one fact at a
time through `share-memory.sh`, so every migrated fact passes the same gates.

**Rubric** (first match wins):

1. **Private.** The fact concerns credentials or token mechanics; cloud account,
   instance, IAM, or zone identifiers; registrar or DNS custody; subscription
   plans, quota, pool names, or real cost; identity linkage between bot logins,
   accounts, and people; the security posture of a production box (open or
   closed containment, unpatched risks); or any content whose source of truth is
   a **private** repository (today `kriscendobot/minion.town`, which is private).
   `user`-type memories are also private.
2. **Needs maintainer decision.** The fact records the maintainer's own judgment
   or strategy that is not already stated on a public surface, or it mixes
   shareable engineering with one private detail that rewording might remove.
3. **Shareable.** The fact concerns public code (`endojs/endo-but-for-bots`, the
   garden itself, `kriscendobot/agoric-sdk`): toolchain gotchas, CI flakes,
   fixed-bug signatures, maintainer rulings already given on public PRs, and
   garden mechanics already documented on `main2`. A shareable fact that is a
   **point-in-time PR status** carries a "verify current before migrating" note,
   and is retired instead of migrated if the PR is closed.

Totals from applying the rubric to the 81 files: 49 shareable (6 of them need a
reword to drop a private-repo reference, 10 are point-in-time PR status to verify
first, and 1 is stale and should be retired instead), 28 private, and 4 needing a
maintainer decision.

## 6. First shared entry

`bearer-tokens-vs-ocaps` is the first candidate: a maintainer ruling about a
concept, with no credential, account, or host detail in it. It cannot be copied
as is, though. Its **Why** line cites minion.town PR #180, and minion.town is
private, and its link `[[minion-town-access-control-ocap]]` names a private memory. The
scanner's private-repo rule and the shared-links rule would both refuse it, which
is the gates working as intended. The shareable text drops both:

> A bearer token is not incoherent with object capabilities. What matters is
> whether the token refers to an **identity** (ambient authority, "who you are",
> such as a master secret) or to **one specific object** that represents the
> designated authority. The second is an ocap; the first is not.
> **Why:** a design review (2026-10-17) read "write authority is a capability
> object, not a bearer token" as ruling out any key-based control plane, and the
> maintainer corrected that framing.
> **How to apply:** when a review cites "no bearer tokens" as an ocap violation,
> ask whether each token designates one object and is attenuated to it. Flag
> identity-shaped tokens, not tokens as such.

## Test plan

- `memory-secret-scan.sh` fixture suite: one positive fixture per rule, plus
  negatives (a 40-hex git SHA, a noreply email, a public `endojs/...` slug, the
  word "quota" inside a code span is still a hit, which is deliberate), and a
  check that output never contains the matched text.
- `share-memory.sh`: refuses unmarked, misnamed, `user`-typed, private-linked,
  and scan-hit files; a concurrent-edit test with two clones confirms the second
  writer is refused; the index regenerates byte-identically from the files.
- `worker_job_prompt`: the shared block is present, at most 6 KiB, and truncated
  with a pointer past the cap.
- Migration dry run: run every candidate in the maintainer-approved set through
  the scanner before any push. The approved shareable set must scan clean or be
  reworded.

## Open questions

1. **Should the shared tier be a private repository instead of public
   `journal2`?** The scanner catches secret *shapes* (tokens, ids, private-repo
   slugs) but cannot recognize secret *meanings*. "Containment on the production
   box is open" contains no token-shaped string. On `journal2` the real defense
   is the rubric plus the explicit, per-fact act, with the scanner as a net under
   it. A private repo (for example `kriscendobot/garden-memory`, cloned beside
   `journal/` on each host) would make a miss survivable, at the cost of a second
   clone, a second credential scope, and a second CAS loop. Recommendation: start
   on `journal2` with the fail-closed scanner and keep the shared set to facts
   about public code. Is that acceptable, or should v1 go straight to a private
   repo?
2. **Does the fleet need a third, fleet-private tier?** The 26 private memories
   include minion.town engineering facts that every host's gardeners would
   benefit from, and they are private only because the repo is. A private
   shared repo (question 1's alternative) would give them a home. Without one,
   they stay host-local by design.
3. **Is the existing public journal content in scope?** `journal2` already
   publishes budget checkpoints, usage ledgers, host identities, and project
   notes, some of which the § 5 rubric would call private. This design keeps new
   memories out of the journal but does not audit what is already there. Should a
   separate job audit and relocate existing journal content?
