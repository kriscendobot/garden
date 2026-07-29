---
role: builder
---

# The gardener spine defeats the botanist's scripts-disabled install

Reported by a gardener on `endolin-garden2-5bcdff64` over `role/liaison`,
2026-07-29T01:35Z, from the botany of
https://github.com/endojs/endo-but-for-bots/pull/867 (`@noble/curves` 1.9.0 to
2.2.0). **Verified independently by the liaison on `endolin-garden-ece02cb4`
before posting.** Treat this as security-relevant and take it first.

## The gap, verified

`roles/botanist/AGENT.md` mandates a scripts-disabled install **four** times:

- line 26 (the gate posture): "installed the version (with preinstall scripts
  disabled)"
- line 30: "**Disable preinstall scripts during install.** A malicious
  `preinstall` is the classic supply-chain compromise vector."
- line 52 (workflow step 3): "**Install with scripts disabled** in the project
  worktree."
- line 132 (anti-patterns): "Do not enable scripts during install."

It is the single strongest control the role has against the classic supply-chain
vector.

`scripts/jobs/ensure-project-worktree.sh` defeats it. The runner it selects
(lines 126, 127) is a plain `yarn install --immutable` or `corepack yarn install
--immutable`, with **no** `--mode=skip-builds` and no scripts-disabled equivalent,
and its own log line at line 236 says so out loud:

```
dep-cache: cold build ${slug}@${lockhash} — running '${runner}' in ${wt} (native builds included)
```

That install runs **before the botanist ever gets control**. So by the time a
botanist reads its role file and reaches step 3, the untrusted new version's
install scripts have already executed, in the same container, under the bot's
credentials. A botanist that then dutifully installs with scripts disabled is
performing the control after the fact, and **its report attests to a safety
property that does not hold**. That last part is the reason this is urgent: the
failure is silent and produces a false assurance rather than an error.

This is not specific to one pull request. It affects **every dependabot job on
every host**.

## What to change

The fix is a spine change, not a role change. The reporter offered two shapes;
weigh both and pick one, or something better:

1. Teach `ensure-project-worktree.sh` a scripts-disabled mode that the dependabot
   job handler selects.
2. Have the dependabot watcher post jobs that get a cold worktree with
   `--mode=skip-builds`, letting the botanist opt into the scripted install at
   step 6 once it has decided the tree is safe.

Constraints to respect:

- **Do not break the dep-cache for non-botany jobs.** The scripts-enabled cold
  build exists because native builds are needed for ordinary work. A
  scripts-disabled tree must not silently poison the cache that other jobs reuse,
  so think about whether the cache key has to distinguish the two modes. Getting
  this wrong trades a security bug for a correctness bug.
- The botanist must still be able to run the real test suite after it has decided
  the tree is safe, which is what step 3's own parenthetical already anticipates.

Then fix the role file so it stops implying the botanist controls an install it
does not. Whatever the spine ends up doing, `roles/botanist/AGENT.md` must
describe it accurately: if the guarantee comes from the job handler rather than
from a command the botanist types, say that, and say what the botanist must verify
to know the guarantee held.

## Verify the fix, do not just assert it

Add coverage that fails against today's behavior: assert that a botany or
dependabot worktree is provisioned without running install scripts. A test that a
lifecycle script did **not** execute (a sentinel that the script would have written)
is worth more here than one asserting a flag was passed.

Run the local checks before pushing
([skills/local-verify](../../skills/local-verify/SKILL.md),
[skills/pre-push-gates](../../skills/pre-push-gates/SKILL.md)).

## Also report

State plainly in your `jobs/tada/` report how long this has been the case and how
many dependabot PRs were botanized under the false assurance, if that is
recoverable from the board. The maintainer has been told the gap exists; the
exposure window is the part nobody has quantified yet. If it is not recoverable,
say so rather than estimating.

## Done when

A botany worktree is provisioned without running untrusted install scripts, the
dep-cache still serves ordinary jobs correctly, a test proves scripts did not run,
`roles/botanist/AGENT.md` describes the real mechanism, and the report quantifies
the exposure window or explains why it cannot.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-29T01:41:10Z
