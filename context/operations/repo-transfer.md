# Moving the garden's own repo to a new owner

The garden's own GitHub repo was **transferred** `kriskowal/garden` →
`kriscendobot/garden` on **2026-07-28**. This page records what a transfer
touches, what it does *not* touch, and the one thing that cannot be automated.
It is written to generalize: a future transfer follows the same shape.

## What GitHub carries for you

Both branches survive a transfer untouched — `main2` and the orphan `journal2`
keep their exact tips, and no history is rewritten. GitHub then redirects the
old location **indefinitely** for the web UI, the REST API, and both git
transports (https and scp-ssh), so an un-migrated remote keeps fetching and
pushing rather than breaking.

Two consequences follow, and they pull in opposite directions:

- Nothing is *urgent*. A host still on the old origin is not stranded.
- Nothing is *self-correcting* either. A redirect hides the drift, so the old
  URL lingers wherever it is written down until someone migrates it.

**Never recreate a repo at the old path.** A new `kriskowal/garden` would
shadow the redirect and silently split the fleet across two repos.

## What it does not carry

- **GitHub Pages.** A project site is served from `<owner>.github.io/<repo>/`,
  and that URL is owner-derived with **no redirect**. The bulletin moved from
  `https://kriskowal.github.io/garden/bulletin/` to
  `https://kriscendobot.github.io/garden/bulletin/`; the old address is a hard
  404. Pages source (branch + folder) does survive, so the new URL publishes on
  its own once the transfer lands.
- **Fine-grained personal access tokens.** A fine-grained token is scoped to a
  **resource owner**, and that scope does not follow the repo. Any token minted
  under the old owner loses write access even though its URL still redirects.
  Re-minting requires the account holder — see `docs/bulletin/SETUP.md` § 2.

## The migration alias (and retiring it)

`scripts/jobs/common.sh` validates every journal/origin URL against the
canonical repo, and that validation is load-bearing: it is the guard that
refuses a root origin a worker rewrote to a project fork (incident 2026-07-21).
Three knobs express the transfer:

    GARDEN_PRODUCTION_JOURNAL_REPO           kriscendobot/garden   the canonical repo
    GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES   kriskowal/garden      accepted during migration
    GARDEN_PRODUCTION_JOURNAL_URL            git@github.com:kriscendobot/garden.git

The alias exists so a host whose origin has not been migrated yet still
resolves and pushes. The regex built from these is anchored to the **full
`<owner>/<name>` path** — an alternation of exact repos, never a bare owner
prefix — because the garden now shares an owner with the product forks:
`kriscendobot/endo-but-for-bots` must still read as foreign. Widening this to
`kriscendobot/*` would disarm the poison guard entirely.

Retire the alias once no live origin, per-host cache, or per-instance clone
still names the old path — checked per host with:

    git -C <garden-root> config --get remote.origin.url
    cat <garden-root>/.garden-state/config/journal-remote
    git -C <garden-root>/.garden-state/*/journal config --get remote.origin.url

## Order of operations

The compatibility change must be **deployed everywhere before** any live origin
moves, or a host running the old code would reject the new URL as foreign and
FATAL-storm its units. So:

1. Land the alias-accepting change on `main2`.
2. Deploy it ([deploy.md](deploy.md)) — leader and every follower.
3. CAS `config/garden-repo` to the new path (`scripts/jobs/set-garden-repo.sh`),
   which is what the issue-inbox and Pages watchers read.
4. Reconcile the `comment-repos/` arming records so exactly one watcher covers
   each surface, then migrate root, journal, and cached remotes per host.

Step 4's watch-set reconciliation is the easy one to get wrong: the arming
record is keyed by the `<owner>-<name>` slug, so a transfer makes the old slug
stale rather than updating it. Land the new slug and delete the old one in the
**same** commit, or both watchers dispatch on the same comment. Note also that
`config/fork-owners` now matches the garden's own repo, so
`scripts/jobs/fork-watch-provisioner.sh` would auto-arm it (including a commit
triager the garden's own repo never had); the `watch-optout/<slug>` tombstone is
what holds that off while leaving a hand-written `comment-repos/<slug>` record
in force.
