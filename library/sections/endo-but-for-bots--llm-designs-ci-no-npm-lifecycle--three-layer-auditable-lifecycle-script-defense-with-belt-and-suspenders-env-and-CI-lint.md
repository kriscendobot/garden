---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
---

# Three-layer auditable lifecycle-script defense with belt-and-suspenders env and CI lint

> *CI workflows must treat lifecycle scripts as untrusted
> code. Any work that a lifecycle script would do is moved
> into an explicit, named workflow step that a reviewer can
> see in the workflow file and in the Actions log.*
>
> — `designs/ci-no-npm-lifecycle.md` §Principle

`ci-no-npm-lifecycle.md` (378 lines, *Complete* status,
shipped 2026-05-14 via PR #126 commit `ddbc8ad7e`) is a
**CI-supply-chain-defense design** by Kris Kowal *(prompted)*.
Created 2026-04-23; design-phase commit `102a94bc9` 2026-04-29
in a *batch of seven proposals*; implementation-phase squash-
merge 2026-05-14. **16-day calendar window** of which most
was queue/review wait, not active authoring.

## The §load-bearing-threat-model — supply-chain attacks via npm lifecycle

The §What-is-the-Problem-Being-Solved section opens with the
threat model:

> *GitHub Actions workflows that install dependencies with
> scripts enabled give every transitive dependency — and
> every future transitive dependency — arbitrary code
> execution inside the CI runner. That runner has a checkout
> of the repository, cached credentials, and, on release
> workflows, publish tokens and signing keys. One compromised
> `postinstall` in a dependency five levels deep is enough to
> exfiltrate secrets, tamper with build artifacts, or push
> forged commits.*

The §the-runner-is-the-attack-surface observation. CI runners
hold *write access to the workspace + read access to any
secret the job mounted*. A malicious `postinstall` runs with
*all* of those privileges, *before any source is audited*.

§Supply-chain-attacks-cited:

> *The risk is not hypothetical. Supply-chain attacks against
> the npm ecosystem (event-stream, ua-parser-js, node-ipc,
> the 2024 XZ-style typosquatting campaigns) have repeatedly
> delivered their payload through lifecycle scripts rather
> than through source imports, precisely because lifecycle
> scripts run at install time before any source is executed
> or audited.*

The §lifecycle-scripts-run-before-source-audit observation:
this is the *structural why* of the attack vector. Source-
review processes assume source is read before it runs;
lifecycle scripts violate that assumption.

## The §three-concerns enumeration

The design names **three distinct concerns**:

1. **Supply-chain risk** — malicious `pre/postinstall` /
   `prepare` / `prepack` / `postpack` runs as the CI user.
2. **Reproducibility** — *Lifecycle scripts are opaque side
   effects. A developer reading a workflow sees `yarn install`
   and cannot tell which compilation, code generation, or
   download step actually ran.*
3. **Correctness** — implicit `prepack` runs during
   `yarn install` *in some configurations* produce *stale
   artifacts that then shadow the real build output*.

The §three-concerns-not-just-security framing: even if the
security risk were zero, *reproducibility* and *correctness*
alone justify disabling lifecycle scripts. The §multiple-
independent-justifications discipline makes the design robust
against "security-doesn't-matter-here" pushback.

## The §existing-posture-at-rest audit

The most structurally interesting *audit* move:

> *The repository already takes the right position at rest.
> `.yarnrc.yml` sets `enableScripts: false` globally; the
> legacy `.yarnrc` sets `ignore-scripts true`; the root
> `package.json` pins `@lavamoat/preinstall-always-fail` and
> `@lavamoat/allow-scripts` with a narrow allowlist
> (`@ipshipyard/node-datachannel`, `better-sqlite3`) for the
> two native addons that genuinely need to build during
> install. This design pins that posture down in CI and adds
> enforcement so the posture cannot regress silently.*

The §pin-the-posture-don't-invent-it framing: the repo's
local-development setup *already* has the right policy. The
design's job is to *extend that policy to CI* (where it
matters most) and to *add enforcement* (so a future
maintainer can't accidentally regress).

The §light-migration property: most workflows already do the
right thing; the design adds a thin enforcement layer. Same
shape as cycle 151's §verified-current-state methodology
(audit-before-spec) applied to *security policy* rather than
*feature coverage*.

## The §single most structurally interesting move — §three-layer auditable defense

§Design Decision 1 names the architecture:

> *Disable globally, opt in per package, run in a named step.*
> *The combination of `enableScripts: false` (repo-wide), an
> explicit `@lavamoat/allow-scripts` allowlist (per package),
> and a named `yarn allow-scripts run` step (per workflow)
> means any native-addon build is auditable at three layers:
> the config, the allowlist, and the Actions log line.*

The §three-layer-auditability discipline:

| Layer | Mechanism | Audit point |
|-------|-----------|-------------|
| **Config** | `.yarnrc.yml` `enableScripts: false` | Repo-wide default — no script runs unless explicitly invoked |
| **Allowlist** | `@lavamoat/allow-scripts` + `dependenciesMeta.built` | Per-package whitelist — only listed packages can build |
| **Named step** | `yarn allow-scripts run` in CI | Per-workflow visibility — the build step is a *named line* in the Actions log |

The §each-layer-can-fail-without-catastrophic-loss property:
if the config is mistakenly removed, the allowlist still
gates which packages can run scripts; if the allowlist is
mistakenly widened, the named-step is still required to
trigger the build (and reviewers see the step in the
workflow file).

The §defense-in-depth-against-three-different-mistakes
shape: each layer protects against a *different* class of
error (accidental config deletion / accidental allowlist
expansion / accidental implicit-script-invocation). One
mistake doesn't compromise the whole posture.

## The §belt-and-suspenders mechanism

§Design Decision 2:

> *`.yarnrc.yml` already sets `enableScripts: false`, so in
> principle the env var is redundant. CI sets it anyway
> because the env var survives deletions of `.yarnrc.yml` on
> branches, survives invocations of `npm` from a script that
> expected `yarn`, and shows up in the workflow file where a
> reviewer will read it.*

The §belt-and-suspenders-against-package-manager-confusion
discipline. Three concrete failure modes the env var defends
against:

1. **`.yarnrc.yml` deleted on a feature branch** — config
   missing, env var still wins.
2. **A script invokes `npm` when the workflow author expected
   `yarn`** — the env var name covers both (`YARN_ENABLE_SCRIPTS`
   *and* `npm_config_ignore_scripts`).
3. **Reviewer-visible** — the env var appears in the workflow
   YAML; the config file's setting does not. A code reviewer
   reading a PR diff to the workflow *sees* the security
   posture inline.

The §reviewer-visible-defense observation: defense-in-depth is
not just about resilience to attacks; it's also about *making
the defense visible to humans reading the code*. A config
buried in `.yarnrc.yml` is invisible at the workflow file's
diff-review moment; the inline env block is visible.

## The §explicit-named-step principle

§Principle:

> *Any work that a lifecycle script would do is moved into
> an explicit, named workflow step that a reviewer can see in
> the workflow file and in the Actions log.*

The §explicit-named-step-not-implicit-side-effect discipline.
Three observable consequences:

1. **The workflow file enumerates what runs**: read the YAML;
   you see every step.
2. **The Actions log enumerates what ran**: read the timeline;
   you see every step's runtime + output.
3. **Failures point to the responsible step**: a build break
   names the failing step, not "something during install".

The §observability-through-explicitness move. Implicit
side-effects (lifecycle scripts) are *invisible* in both
review and runtime; explicit steps are *visible* in both.

§Three things to notice about the example workflow (lines
122-134):

1. `yarn install --immutable` with scripts disabled by both
   config and env var.
2. Two allowlisted native addons rebuilt in a named step via
   `yarn allow-scripts run`.
3. Build artifacts come from explicit `yarn build` — never
   from implicit `prepack` side effect.

## The §native-addons exception with §`@lavamoat/allow-scripts`

> *Two packages declare `"built": true` in `dependenciesMeta`
> and appear in the lavamoat allowlist:*
> *- `@ipshipyard/node-datachannel`*
> *- `better-sqlite3`*
>
> *Both are legitimate native-module builds, not arbitrary
> scripts. They run through `@lavamoat/allow-scripts`, which
> checks each entry against the repo's explicit allowlist
> before executing.*

The §narrow-allowlist-for-legitimate-exceptions discipline.
Native node-gyp builds are *necessary*; the allowlist names
them *explicitly*. Any future package trying to sneak a build
into the workspace must be *added* to the allowlist, which
shows up as a diff a reviewer can audit.

The §named-list-not-pattern-match approach: the allowlist
contains *exact package names*, not regex patterns. A new
malicious package can't masquerade as an allowlisted one by
having a similar name.

## The §comprehensive workflow audit

The §Audit section (lines 162-187) tabulates **nine workflows**
with their install command and status:

| Workflow | Status |
|---------|--------|
| `ci.yml` (9 jobs) | OK — inherits, add env var |
| `ci.yml` (viable-release) | OK — exemplary |
| `release.yml` | needs `--immutable` + env var |
| `familiar-release.yml` | OK exemplary, add env var |
| `browser-test.yml` | tighten to `--immutable`, root + own npm dir already correct |
| `depcheck.yml` | OK — no Node install |
| `typedoc-gh-pages.yml` | needs `--immutable` + env var |
| `update-action-pins*.yml` (2) | OK — add env var |
| `claude*.yml` | OK — no Node install |

The §enumerate-every-workflow discipline parallel to cycle
151's §verified-current-state methodology (audit-before-spec)
applied to *security policy* instead of *feature coverage*.

> *No workflow currently relies on an implicit lifecycle
> script to produce its build output.*

The §every-build-already-explicit observation: the audit
*confirms* the migration is light — *every build artifact is
produced by an explicit `yarn build`, `yarn workspace ...
build`, `yarn workspace ... bundle`, `yarn workspace ... make`,
`yarn docs`, or `yarn pack` step*.

## The §workspace-prepack scripts — §don't-rename-just-control-call-sites

The §Workspace `prepack` scripts subsection addresses an
obvious objection: *many packages have `prepack` scripts;
should those be removed?*

> *These are invoked deliberately by `yarn lerna run prepack`
> in the `viable-release` job and by humans running `yarn
> pack`. They are not invoked implicitly during `yarn install`
> because the repo is configured with `enableScripts: false`.
> This design does not require renaming them; it requires
> only that CI never calls them through a bare `yarn install`.*

The §don't-rename-don't-touch-existing-mechanisms-just-control-call-sites
discipline. The property the design wants is *invisibility at
install time*, not *non-existence*. The existing `prepack`
hooks remain (they're useful for type-def builds at pack
time); the design just ensures `yarn install` doesn't trigger
them.

§Design Decision 4 makes this explicit:

> *No attempt to forbid `prepack` in workspace `package.json`s.
> `prepack` is the correct hook for building typedefs before
> pack, and it runs under human control (via `yarn pack` or
> `yarn lerna run prepack`) as an explicit workflow step.*

The §control-the-call-not-the-callee distinction: the design
controls *when* lifecycle scripts run, not *which* lifecycle
scripts exist.

## The §two-layer enforcement

> *Two complementary checks keep the posture from rotting.*

**Layer 1: §repository-level-lint**:

`scripts/check-no-ci-lifecycle.mjs` (new) scans
`.github/workflows/*.yml` and fails if:

- Any step runs `yarn install` / `yarn` / `npm install` /
  `npm i` / `npm ci` *without* either `--ignore-scripts` or
  the env block.
- Any step runs `yarn publish` / `npm publish` / `lerna
  publish` *outside* an allowlisted release-workflow job.
- The checked-in `.yarnrc.yml` no longer contains
  `enableScripts: false`.

§Runs-as-CI-job-gated-on-relevant-paths: the lint runs only
when `.github/`, `.yarnrc.yml`, `.yarnrc`, or `package.json`
changes. Same shape as the existing `check-action-pins` job.

**Layer 2: §positive-tripwire** via `@lavamoat/preinstall-always-fail`:

> *If any workflow accidentally enables scripts globally,
> this package's `preinstall` fires first and fails the
> install with an obvious error message, rather than letting
> a silent supply-chain script run.*

The §canary-package-fails-loud discipline: a package
*designed to fail* sits at the front of the dependency tree;
if scripts run at all, *its* script runs first and aborts the
install with a visible error. Catches the policy regression
at install time, not after the malicious payload runs.

The §two-layer-enforcement architecture: lint catches policy
violations at PR-review time; tripwire catches them at
install time. Both fail loud.

## The §five Design Decisions codify the structural choices

§Design Decisions:

1. **Disable globally, opt in per package, run in a named
   step** — §three-layer-auditability.
2. **Belt and suspenders on env vars in CI** — §reviewer-
   visible-defense + §survives-config-deletion.
3. **Prefer `yarn install --immutable` over bare `yarn`** —
   *`--immutable` additionally prevents the install from
   mutating the lockfile, which closes off another vector for
   a malicious PR to change what gets resolved*. §lockfile-
   immutability-as-supply-chain-defense.
4. **No attempt to forbid `prepack` in workspace package.json**
   — §control-the-call-not-the-callee.
5. **The `browser-test/` directory uses npm, not yarn** —
   *don't fix what isn't broken*; the npm side already has
   `--ignore-scripts` and `.npmrc` config.

## The §16-day calendar window — §design-burst-then-queue-wait

§Roadmap calibration via `git blame`:

- Active development: 2026-04-29 → 2026-05-14 (**16 days,
  calendar**).
- Design phase: 2026-04-29 single commit `102a94bc9`
  (*batch of seven proposals*).
- Implementation phase: 2026-05-14 single squash-merge
  `ddbc8ad7e`; *the bulk of the elapsed window was queue /
  review wait rather than active authoring*.

The §design-burst-then-queue-wait calibration: 16 calendar
days, but only *two days* of active work (one design + one
impl). The §calendar-time-vs-active-time distinction matters
for roadmap projection — *14 days of waiting* is the queue
characteristic of the project, not the work characteristic.

The §batch-of-seven-proposals observation: the design phase
commit was part of a *batch of seven*. Implies multiple
related security/CI proposals authored together on the same
day. The §parallel-design-burst pattern (Aaron's two designs
in cycle 143+151 are a smaller version of the same shape).

## The §self-contained-design property

> *None. This design is self-contained and touches only CI
> configuration and a single lint script.*

The §Dependencies-None property is the cleanest possible:
*no other design must land first*. The §self-contained-by-
construction quality is rare — most designs depend on
multiple substrate pieces.

This is consistent with the §pin-the-posture-don't-invent-it
framing: nothing new is *built*; existing posture is *locked
in* and *audited*.

## Related sections

- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — sibling §roadmap-calibration-via-git-blame discipline (3-day
  active window vs this design's 16-day calendar/2-day active).
- cycle 151
  [[endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline]]
  — sibling §verified-current-state methodology applied to
  *feature coverage* (Aaron's milestone) vs *security policy*
  (this design).
- cycle 60+
  (daemon-256-bit-identifiers + related) — broader security-by-
  construction discipline the @endo project carries.
