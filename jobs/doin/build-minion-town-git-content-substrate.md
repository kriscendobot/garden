---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# build: the git content substrate (serving-side) into minion.town

Repo: **kriscendobot/minion.town** — private fork, direct push to `main` (no upstream PR; the repo's own flow).
Design (spec): **`designs/git-content-substrate.md`**, merged via kriscendobot/minion.town#39 (commit `d69a3b8`).
Directive: maintainer comment https://github.com/kriscendobot/minion.town/pull/39#issuecomment-5321716813 — "Post a builder."

## What to build

Implement the **serving-side** mechanism the merged `designs/git-content-substrate.md`
settled, scoped to the first coherent, testable slice:

- **§4 Projection and atomic publication** — project a Git tree into the weblet
  content-addressed store (CAS): intern the tree, derive its `contentRoot`, then
  advance a stable, source-named **mutable vhost/record** from an expected old root
  to the new root in one **compare-and-swap** (§1.3).
- **§5 Deployment-coherent static caching** — the two-tier read-side cache policy:
  `no-cache` + `ETag:"<contentRoot>"` on mutable entry/navigational documents;
  `max-age=31536000, immutable` on root-qualified `/.content/<contentRoot>/`
  sub-resources. Documents are pinned by their own immutable sub-resource
  references — **no URL redirect, no cookie** — so shared/bookmarked navigational
  links stay clean and durable across a content-root advance (§1.4). The projector/
  serving layer must root-qualify sub-resource refs (scripts/styles/images) while
  leaving `<a href>` root-free.
- **§6 Serving and security invariants** — branch/tree content is **DATA**,
  byte-for-byte streamed, **never executed server-side**.

Scope the smallest end-to-end vertical that a reviewer can exercise (projection →
CAS intern → CAS-native manifest → mutable-record CAS advance → root-qualified
serving with the correct cache headers), with tests. Later slices (a first real
consumer weblet, sync cadence) are follow-ups, not this job.

## Constraints — read before writing code (from the design's own status)

`designs/git-content-substrate.md` is titled **"(deferred experiment)"** and its
status line + §1.5 impose a hard boundary you MUST respect:

- **Stay local.** Implement inside the **minion.town** repo only. Do **NOT** extract
  the projector or mutable-record mechanism into an upstream `@endo/*` package —
  that upstream extraction is explicitly deferred until the capability-addressed
  Git-remote design is reviewed. "Landing upstream" is forbidden here; building the
  serving plane into minion.town's own deployment is what is asked.
- **Supersession is in FRAMING, not mechanism.** The Git **wire protocol**,
  **capability-URL authorization**, **CAS partition**, and **guest-inventory model**
  are owned by the superseding design `designs/git-remote-capability.md`
  (kriscendobot/minion.town#41, currently CHANGES_REQUESTED — do not depend on it
  landing). Build **only** the serving-side substrate (§4/§5/§6); do not implement
  the git-HTTP remote / cap-URL surface here.
- Opaque, unguessable identifiers + Endo petnames are the only human-readable layer
  (§2); no human-readable public hostnames.

## Target-check (safety valve)

The maintainer commented on kriscendobot/minion.town#39. A liaison-side
disambiguation was raised (build #39's serving substrate now vs. build #41's wire
protocol, which is still in changes-requested) and this job is the "build #39's
serving substrate" reading — the only build-ready target. If on reading both
designs you conclude there is **no coherent build-ready serving slice** yet, or
that the merged design is genuinely blocked on an #41 decision, do **not**
fabricate a speculative feature: message the maintainer
(`scripts/jobs/message-user.sh <this-base>`) with the specific blocker and hand off
rather than guessing.

## Definition of done

- The serving-side slice implemented in minion.town, `npm run typecheck` clean,
  tests for projection + CAS advance (CAS) + the two-tier cache headers + the
  root-qualification rule (sub-resources root-qualified, `<a href>` root-free).
- Content-is-data invariant enforced (no server-side execution of pushed content).
- DEPLOYMENT.md / docs updated for the new content-source path (coexists with
  `weblet_publish` and the fixture seeder — §7, do not replace them).
- The draft PR auto-runs the gauntlet per the builder flow.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-18T00:20:06Z
