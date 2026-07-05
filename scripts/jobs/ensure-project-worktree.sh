#!/bin/bash
# ensure-project-worktree.sh — give a gardener an ISOLATED project checkout,
# keyed by the gardener's unique job base, off a standing bare clone.
#
# Usage:
#   ensure-project-worktree.sh <base> <owner/repo> <branch> [<ref>]
#
# Prints the absolute path of the project worktree on stdout. The caller `cd`s
# into it and does all project development there.
#
# ── Why this exists (the #58 corruption) ─────────────────────────────────────
# A v2 gardener is launched by handlers/gardener-claude.sh with its cwd already
# set to a per-job GARDEN worktree ($GARDEN_SCRATCH/gardener-wt-<base>), which is
# unique per job base and so never shared. But a PR job that mutates a *project*
# repo (e.g. endojs/endo-but-for-bots) needs a separate checkout of that fork,
# and NOTHING deterministic created it — the `claude -p` gardener improvised a
# path. On endo-but-for-bots #58 two gardeners each improvised the SAME
# repo+PR-keyed name (`…/ebfb-pr58-project`) and so shared ONE working tree:
# their concurrent edits to error-trace.js + chat-bar-component.js bled across
# and corrupted each other.
#
# The fix is to key the project worktree by the gardener's UNIQUE JOB BASE (the
# same key gardener-claude.sh uses for the garden worktree), never by repo+branch
# or a PR number. Two concurrent jobs on the same repo/branch have distinct bases
# and therefore distinct working trees; the git push to the shared head branch is
# where they legitimately race (CAS at the remote), but the working trees can
# never collide. A short discriminator over <owner/repo@branch> is appended so a
# single job that legitimately needs two checkouts (a stacked PR across two repos,
# or one repo at two branches) does not self-collide either.
#
# ── Resume stability ─────────────────────────────────────────────────────────
# The path is DETERMINISTIC in (base, repo, branch): a reaper requeue re-runs the
# SAME base, so the resumed gardener re-derives the SAME path and re-enters its
# in-flight checkout instead of starting from a clean tree and losing uncommitted
# work — exactly as gardener-claude.sh's per-base garden worktree does. An
# existing, validly-registered worktree is therefore REUSED as-is; only a missing
# or stale/broken directory is (re)created off the branch tip.
#
# ── Isolation guarantees asserted by test/project-worktree-isolation-test.sh ──
#   * two DIFFERENT bases, same repo+branch  → DISTINCT paths (the #58 fix);
#   * same base, same repo+branch (a requeue) → the SAME path, work preserved;
#   * same base, DIFFERENT repo/branch        → DISTINCT paths (no self-collision).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

base="${1:?usage: ensure-project-worktree.sh <base> <owner/repo> <branch> [<ref>]}"
repo="${2:?owner/repo}"
branch="${3:?branch}"
ref="${4:-$branch}"     # what to check the worktree out AT (defaults to the branch)

case "$repo" in
  */*) : ;;
  *) die "ensure-project-worktree: repo must be <owner>/<name>, got '$repo'" ;;
esac
owner="${repo%/*}"
name="${repo#*/}"

# Standing bare clone the fork worktrees are cut from (WORKTREES.md § Adding a
# fork worktree; kept fresh by clone-keeper.sh).
bare="$GARDEN_ROOT/worktrees/${owner}-${name}.git"
if [ ! -d "$bare" ]; then
  echo "ensure-project-worktree: bare clone not found at $bare" >&2
  echo "  clone first via: git clone --bare https://github.com/${repo}.git $bare" >&2
  echo "  then set the fetch refspec (a bare clone has none, so a fetch would" >&2
  echo "  leave origin/* tracking refs frozen):" >&2
  echo "  git -C $bare config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'" >&2
  die "ensure-project-worktree: missing bare clone for $repo"
fi

# ── the isolated, per-job path ───────────────────────────────────────────────
# Keyed by the UNIQUE job base (never repo+branch), plus a short discriminator
# over <owner/repo@branch> so one job holding two checkouts does not self-collide.
# `base` is a job basename (no '/', '#', ':'), safe as a path component; sanitize
# defensively anyway. The discriminator keeps the path deterministic (stable for
# resume) while bounding its length — the full base can be long, and deep paths
# under project/ (endo daemon UNIX sockets) push toward the 108-char sockaddr_un
# limit, so we append a fixed 8-hex digest rather than the raw repo/branch.
base_safe="${base//[^A-Za-z0-9._-]/-}"
disc="$(printf '%s@%s' "$repo" "$branch" | cksum | cut -d' ' -f1)"
disc="$(printf '%08x' "$disc" 2>/dev/null || printf '%s' "$disc")"
wt="$GARDEN_SCRATCH/project-wt-${base_safe}-${disc}"

# ── resume: reuse an existing, validly-registered worktree as-is ─────────────
# If the dir exists AND the bare clone still knows it as a registered worktree,
# the caller is resuming into in-flight work; hand back the same path untouched.
if [ -d "$wt" ] && git --git-dir="$bare" worktree list --porcelain 2>/dev/null \
     | grep -qxF "worktree $wt"; then
  printf '%s\n' "$wt"
  exit 0
fi

# ── fresh (or stale-leftover) checkout ───────────────────────────────────────
# A leftover dir that is NOT a live registered worktree (an interrupted create, a
# pruned admin entry) is cleared so the add starts clean. scratch_cleanup refuses
# anything outside $GARDEN_SCRATCH and deregisters a stray worktree first.
[ -e "$wt" ] && scratch_cleanup "$wt"
# The inverse leftover: the DIR is gone but the bare clone still carries its
# admin registration (a deleted checkout whose entry survived). `worktree add`
# then dies "missing but already registered worktree" — and since the path is
# deterministic per job base, every reaper-requeue retry died identically,
# wedging the job until a by-hand prune. Prune resolves it: it only drops
# entries whose working tree is absent, so live checkouts are untouched.
if git --git-dir="$bare" worktree list --porcelain 2>/dev/null | grep -qxF "worktree $wt"; then
  git --git-dir="$bare" worktree prune 2>/dev/null || true
fi
mkdir -p "$GARDEN_SCRATCH"

# Resolve the requested branch into the bare clone's refs/heads/ before the add.
# The fork worktrees' fetch refspec routes branches into refs/remotes/origin/*,
# so a bare branch name would not resolve for `worktree add --detach <path>
# <branch>`; fetching it explicitly into refs/heads/ makes the name resolve. The
# `+` forces an update if the local head already exists. If the branch is on
# neither side the fetch is a no-op and the add below surfaces a clear error.
git --git-dir="$bare" fetch --quiet origin \
  "+refs/heads/${branch}:refs/heads/${branch}" 2>/dev/null || true

git --git-dir="$bare" worktree add --detach "$wt" "$ref" >/dev/null \
  || die "ensure-project-worktree: could not check out $repo@$ref into $wt"

# Pin the bot identity so a subagent's commits cannot drift to the parent shell's
# global git identity (the maintainer identity on a maintainer host).
git -C "$wt" config user.name  "$(bot_name)"
git -C "$wt" config user.email "$(bot_email)"

printf '%s\n' "$wt"
