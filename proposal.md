# Endo Capability Bank — Grant Proposal

## Q1: Summary

*Max 1,000 characters. Used for pre-screening — include key reasons in favor.*

Please provide a brief summary of your project (max. 1000 characters).

We will use this summary to pre-screen your application, so please make sure to
include the key reasons in favor of your project here.
If you have already talked to a particular fund manager, please mention their
name here so we can be sure to get their input.

### :: PROPOSED RESPONSE (For Review) ::

Endo is an object-capability runtime that bounds what an AI agent can do,
regardless of intent or alignment.
Its foundations, Hardened JavaScript and OCapN, already secure MetaMask
(30M+ monthly users) and Agoric's blockchain in production.
Funds requested in this grant application extend foundation work already done
under a grant from the Foresight Institute.

This grant funds one senior engineer for five months to ship a confinement
framework for AI coding agents: precisely scoped filesystem, process, and
network access through unforgeable capability references.
Success criterion is a live demonstration where an agent under least authority,
after successful prompt injection, cannot reach credentials, unrelated
projects, or ungranted network hosts.

This complements alignment research by bounding damage rather than shaping
behavior.
OWASP's Top 10 for Agentic Applications and recent IDEsaster findings show
every tested AI IDE is vulnerable to prompt-injection-to-tool-abuse chains
today.
Timeline is scoped against measured engineering velocity from three completed
reference designs.

---

## Q2: Project Goals

What specific actions or steps might your project involve?
What impact will this have on the world?
What is your project's goal, how will you know if you've achieved it, and
what is the path to impact?
How does this relate to the goals of the fund(s) you are applying to?

### :: PROPOSED RESPONSE (For Review) ::

#### Specific actions

This grant would support development and security review of the Endo capability bank: isolated filesystem and execution environments.  The filesystem environment will support both virtual and physical mounts.  The execution environment will support both JavaScript and POSIX shells, where the POSIX shell will stand on kernel-isolated filesystem and network namespaces.

1. **OS-level sandbox plugin (months 1-2):** Wraps macOS sandbox-exec (Linux
   stretch goal) to confine native processes — compilers, linters, data
   pipelines — with declaratively specified endowments: allowed filesystem
   paths, network hosts, executables, and environment variables.
   AI coding agents that invoke native tools (gcc, npm, pip) get OS-enforced
   boundaries instead of ambient developer authority.

   > **Annotation — sandbox design has been superseded.**
   > The "wraps macOS `sandbox-exec` (Linux stretch goal)" description matches
   > the older `daemon-os-sandbox-plugin` design (Status: **Superseded** on
   > `llm`), not the current `endo-posix-sandbox` design (Status: **In
   > Progress, Phase 3**) that supersedes it. The current design differs in
   > three material ways:
   >
   > 1. **Linux is the initial target, not a stretch goal.**
   >    Phases 0–1 (bubblewrap on Linux) have shipped. Phase 2 (podman) and
   >    Phase 3 (nested slices via `fork()`) are in flight on
   >    `bots-ssh/jcorbin-sandbox-paths`. macOS is **Phase 4** via lima +
   >    Apple Containerization (an in-guest Linux backend with a host-side
   >    proxy), not a native SBPL backend. Windows via WSL2 is Phase 6 and
   >    composes the same in-guest pattern.
   > 2. **The capability surface is split**, not a single `SandboxMaker` →
   >    `Sandbox`. It is now `SandboxFactory` → `SandboxHandle` →
   >    `ProcessHandle` / `MountHandle`, so slice lifetime, mounts, and
   >    processes are individually addressable and GC-pinnable.
   > 3. **Mounts are `Mount` capabilities**, never host path strings; the
   >    plugin no longer receives the daemon's host-paths power.
   >
   > Recommend rewording to: "Wraps bubblewrap on Linux (initial target;
   > Phases 0–1 shipped) with macOS via lima + Apple Containerization and
   > Windows via WSL2 sharing the same in-guest backend pattern." The
   > capability-surface and Mount-cap details can stay implicit.

2. **Filesystem capability (months 2-3):** A Dir/File capability pair
   providing structural confinement.
   A guest holding a Dir rooted at /project cannot access /home/.ssh because
   no method returns a parent reference.
   Attenuation is compositional: readOnly() and subDir() chain in any order.
   This is the foundation for giving an AI agent "read-write access to this
   project directory and nothing else."

   > **Annotation — consistent with current design.**
   > This paragraph matches `designs/daemon-capability-filesystem.md` on `llm`
   > (the `readOnly()` / `subDir(path)` chainable attenuators, the
   > root-without-parent-reference structural argument). No changes required.
   > Note however that this work item is scheduled under **Milestone 1**, not
   > Milestone 5 (see milestone-mapping annotation above).

3. **Capability bank integration (months 3-5):** Unifies the sandbox plugin,
   filesystem capability, and persona system into named role profiles for
   agent confinement.
   A "read-only developer" profile bundles attenuated capabilities specifying
   exactly which filesystem subtrees, executables, network hosts, and
   environment variables the agent may access.

   > **Annotation — persona vs. role-profile bundling.**
   > Two small misalignments with the `llm`-branch designs:
   >
   > - The `daemon-capability-persona` design ("Delegates and Epithets") is
   >   primarily about *delegation identity* — verifiable/deniable claims like
   >   "Aifred (assistant to Alice)" and mandatory AI-disclosure on handles
   >   — not about role profiles. Calling persona part of "named role
   >   profiles" conflates two separable concerns.
   > - The composition layer that bundles attenuated capabilities into named
   >   profiles is explicitly described in `daemon-capability-bank.md` as a
   >   **cross-cutting concern** deferred "until the individual capability
   >   shapes are settled." It is real future work, but framing it as a
   >   distinct integration step (rather than as part of persona) would be
   >   more faithful to the design.
   >
   > Consider rewording to: "Unifies the sandbox plugin and filesystem
   > capability into named role profiles for agent confinement; integrates
   > the persona system (delegation identity and AI-disclosure)."

4. **Security review (month 5):** Independent review of capability bank and
   sandbox plugin by engineers who were not the original implementers.
   This gates the transition from proof of concept to MVP.

**Success criterion:** A demonstrated AI coding agent (Fae, built on Endo)
running inside the capability bank with principle of least authority enforced.
The agent can read and write files in its project directory, run specified
build tools, and communicate with its principal — but cannot read
credentials, access unrelated projects, or establish network connections
beyond what was granted.
A prompt injection that hijacks the agent's intent is confined by the same
boundaries.

> **Annotation — "Fae" framing.**
> Per `packages/fae/README.md` and `packages/fae/CLAUDE.md` on `llm`, Fae is
> *an LLM agent manager* — a factory caplet that creates and provisions
> agent instances and adopts tool capabilities at runtime. The coding-agent
> framework (`bash`, `exec`, `git` tools, system-prompt builder, heartbeat
> loop) is `@endo/genie` ("a Claw-like AI Agent framework for the Endo
> hardened JavaScript project"); `endo-posix-sandbox` names genie as its
> first concrete consumer.
>
> "AI coding agent (Fae, built on Endo)" reads as if Fae alone is the coding
> agent. A more faithful framing is e.g. "An AI coding agent built on Endo
> (Fae's agent manager + genie's tool framework, running inside the
> capability bank)" — or simply "An AI coding agent built on Endo."

#### Impact and path to impact

The direct output is a working, reviewed capability confinement system for
AI agents.
The path to broader impact:

- **Short term (6-12 months):** Proof of concept demonstrates that
  production-grade AI agent confinement is architecturally feasible and
  shippable, not just a research concept.
- **Medium term (1-2 years):** Endo capability bank ships as part of the
  Familiar desktop application.
  Developers can download and use confined AI agents without framework
  changes.
  OCapN standard publication enables other runtimes to adopt the same
  confinement model.
- **Long term (2-5 years):** Object-capability confinement becomes a baseline
  expectation for AI agent deployments, analogous to how memory-safe
  languages became baseline for systems software.
  DCF's contribution is proving the concept and publishing the standard;
  adoption depends on developer uptake and framework integration.

#### Relation to LTFF goals

LTFF funds work reducing existential risk from AI.
Endo addresses a specific, under-invested failure mode: autonomous AI agents
operating with unbounded system access.
Current AI safety funding concentrates on alignment (what agents intend) and
evaluations (measuring what agents can do).
Confinement — architecturally limiting what agents can do when compromised —
is a complementary approach with very little dedicated funding.
Endo is the most mature implementation of capability-based agent confinement,
with production foundations and a scoped engineering plan to deliver the
missing confinement layer.

---

## Q3: Funding Amount and Breakdown

### :: PROPOSED RESPONSE (For Review) ::

**Total request: $150,000 for 5 months of engineering + security review
(July-November 2026)**

> **Annotation — timeline vs. recalibrated roadmap.**
> Per the 2026-05-08 recalibration in `designs/README.md` on `llm`:
>
> - Milestone 5 (which contains `endo-posix-sandbox`, `daemon-capability-bank`,
>   and `daemon-capability-persona`) is estimated at **14-20 weeks of effort**,
>   plus a 2-week review-queue carry, and currently lands **Mid-Late March
>   2027** in the published Gantt — after M1 → M4 complete.
> - `daemon-capability-filesystem` is in **M1** (estimated 1.5-3 weeks),
>   which targets Mid July 2026 in the published timeline.
> - `endo-posix-sandbox` alone has "6-10 weeks remaining" of phase work
>   (Phases 1.5, 2, 3, 4, 6) and is the L-XL item on the roadmap.
>
> A July-November 2026 window collides with the projected M2-M3 period
> (Networking, Weblets & Integrations); shipping a reviewed capability bank
> in that window means either reordering M5 ahead of M2-M4, narrowing scope
> (e.g., focusing on filesystem-cap + sandbox + a thin profile layer and
> deferring persona / channel-bridges / browser), or both. Worth either
> flagging the reorder explicitly in the proposal, or revising the dates to
> match the published critical path.

| Share          | Amount   | Item                                                                                                                                                                                                       |
| -------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **65%**        | $97,500  | **Senior engineer compensation** — 5 months at $19,500/month ($125/hr, loaded rate including 20% time padding and 15% administrative overhead, yielding $1,380/loaded person-day). This engineer builds the OS sandbox plugin, filesystem capability, and capability bank integration. |
| **13%**        | $19,500  | **Independent security and code review** — contracted reviewers who were not the original implementers, reviewing the capability bank and sandbox plugin. This is the gate between proof of concept and MVP, as identified by Mark Miller and Kris Kowal. |
| **5%**         | $7,500   | **Infrastructure** — CI/CD, build systems, code-signing for distributable installers, compute for testing.                                                                                                 |
| **7%**         | $10,500  | **Buffer** (7% of total) — LTFF recommends building a buffer into the budget. This covers unforeseeable costs in a security-critical engineering project.                                                  |
| **10%**        | $15,000  | **DCF administration and operations** — project coordination, contracting, financial management, and reporting.                                                                                            |
