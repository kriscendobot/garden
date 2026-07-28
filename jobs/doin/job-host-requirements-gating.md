---
role: designer
---
# Jobs declare host requirements; the claim path honours them — starting with AWS

Maintainer directive (2026-07-28): *"jobs to state their requirements from the host
that runs them, starting with whether they have access to an AWS key."*

**Deliverable: a design plus implementation.** Land the design under `designs/`; if the
build is large, post it as a child. AWS is the first requirement, but the mechanism must
be **general** — design the axis, not the one-off.

## What exists today

- **No host-capability gating anywhere in the claim path.** `claim-job.sh` filters
  candidates only through `job_eligible_for_kind` (line 64), which gates on the job's
  `model:` pin → provider → worker kind. Nothing considers what the *host* can do.
- **The closest precedent is the ferry**, and it is deliberately a *post-claim* check:
  `roles/boatman/AGENT.md` § Host preconditions has the boatman verify `gh auth status`
  and repo `push: true` **after** claiming, and complete with a **blocked report** if the
  host lacks the credentials (precipitating evidence: 2026-05-14, a re-ferry issued from
  the wrong host). That is the behaviour to generalize — and to improve on, since it
  burns a claim cycle and returns a job to the board having accomplished nothing.
- **AWS capability already has a canonical probe**: `scripts/aws/verify.sh` runs
  `aws sts get-caller-identity` (also used by `scripts/aws/turnkey/lib.sh`). Reuse it;
  do not invent a second notion of "has AWS access."
  See also `skills/aws-administration/SKILL.md`, `context/operations/aws-bringup.md`,
  and `scripts/aws/rotate-key.sh` — keys rotate, which matters below.

## Design the two halves

**1. The job side — a `requires:` header.** Machine-readable, extensible, and parsed by
plain code (`plan_field` shape), e.g. `requires: aws` or a comma-separated set. Decide
whether requirements are opaque tokens or structured (`aws`, `aws:region=us-east-1`),
and keep it minimal — a token set is probably enough and easy to extend.

**2. The host side — how a worker knows what it can do.** Two viable shapes, and the
choice has a **security dimension the design must address explicitly**:

- **Declared in the journal** (`hosts/<GARDEN>`, alongside worker counts). Simple, cheap
  to read, consistent with existing per-host state — **but `journal2` lives on the PUBLIC
  `kriscendobot/garden` repo**. Publishing "this host holds an AWS key" is credential
  *metadata* disclosure: it tells an attacker which machine is worth attacking, even
  though the key itself never leaves the host. Weigh that seriously.
- **Probed locally by the worker** (`aws sts get-caller-identity`, cached per boot the
  way `codex_provider_preflight` caches its local-endpoint probe). Publishes nothing and
  cannot go stale in the journal — at the cost of a probe on the claim path, which the
  per-boot cache largely removes.

**Recommendation to evaluate, not a foregone conclusion:** local probing avoids the
disclosure entirely and is self-correcting when a key is rotated or expires. If you
choose journal declaration, say what mitigates the disclosure.

## The new failure mode this introduces — do not ship without it

**A job whose requirement no live host satisfies becomes silently unclaimable.** It sits
in `todo/` forever: never claimed, so never poisoned, never reaped, never surfaced. The
board looks healthy while the work is dead. This is a *worse* failure than today's
claim-then-block, because today at least the job produces a blocked report a human sees.

Requirements: detect an unsatisfiable requirement and **surface it to the maintainer**
(the foreman or a small watcher is the natural home), naming the job and the requirement
no host meets. Consider a dwell threshold so a transiently-unavailable capability does
not alarm immediately.

## Keep the runtime check — the gate is an optimization, not a guarantee

Claim-time gating must **not** replace the post-claim precondition check. A capability
can lapse between claim and run (`scripts/aws/rotate-key.sh` exists precisely because
keys rotate; a session token can expire mid-job). Keep the boatman-style check as defense
in depth, and have the two share one predicate rather than drifting apart.

## Relationship to authorization — a different axis, do not conflate

The ferry's `identity_switch_authorized: true` is **authorization** — a flag only the
maintainer may originate (CLAUDE.md § The ferry). `requires:` is **capability** — a fact
about the host. A job can be authorized but land on an incapable host, or capable but
unauthorized. State how they compose, and do not let `requires:` become a way to
self-grant authorization.

## Definition of done

- A design under `designs/` covering the header format, the capability-discovery
  mechanism with its security reasoning, unsatisfiable-requirement surfacing, and the
  capability/authorization distinction.
- `requires: aws` implemented end to end: a worker on a host without AWS access does not
  claim such a job; one with access does. Demonstrate **both** directions.
- Unsatisfiable-requirement escalation demonstrated (a job requiring something no host
  has produces a maintainer notice, not silence).
- The post-claim precondition check retained and sharing one predicate with the gate.
- Existing jobs without a `requires:` header behave **exactly** as before — show the
  check.
- Pushed to `main2` (direct push, no PR).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-28T20:53:18Z
