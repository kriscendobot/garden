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
# ── Warm dependency cache (the native-module rebuild recurrence) ─────────────
# A fresh worktree from `git worktree add` carries only git-tracked files;
# node_modules is gitignored, so every gardener used to improvise `yarn install`
# by hand in an empty tree. For a repo with a NATIVE module (endo-but-for-bots'
# better-sqlite3), that re-ran the native compile in every per-job worktree, and
# where the toolchain is flaky it re-FAILED N times, ad-hoc, with success/failure
# visible only in agent prose (journal 054129Z / 054640Z). This script now
# provisions node_modules itself, ONCE per lockfile per host, from a warm shared
# cache: the first fresh worktree on a given lockfile runs the real installer
# (native builds included, except for botanist jobs) and SNAPSHOTS the resulting
# node_modules trees into a
# content-addressed cache keyed by <owner>-<repo>/<lockfile-hash>; every later
# fresh worktree POPULATES from that cache with a hardlink copy (`cp -al`, the
# pnpm-linker hardlink pattern the local-run recipe uses), so the compiled .node
# inodes are shared, not recompiled. A lockfile change is a new key → an
# automatic rebuild ("refresh when the lockfile changes"). It is best-effort and
# FAILURE-TOLERANT: a provisioning failure emits a deterministic WARM-CACHE log
# line but NEVER fails the worktree handoff, and it is SKIPPED on a resume-reuse
# (preserving the resume-stability guarantee). If the native build never succeeds
# here (missing compiler/python), the warm cache cannot manufacture a build that
# never existed: the install exits non-zero, we emit a WARM-CACHE MISS+FAIL line
# naming the container-image toolchain fallback, and cache NOTHING.
#
# ── Link-state reconcile on a HIT (why a hit still runs the installer) ───────
# A cache HIT populates node_modules and NOTHING ELSE, but a package manager
# keeps its "is this project installed?" state OUTSIDE node_modules — yarn 4
# writes .yarn/install-state.gz at the project root — and that file is gitignored,
# so a fresh worktree has none. Yarn then refuses every `yarn run <script>` with
# "The project in .../package.json doesn't seem to have been installed", which
# made local-verify.sh report ALL SIX steps FAILED with that one usage error on
# endojs/endo-but-for-bots: the pre-push gate was unrunnable on exactly the
# worktrees the cache is for. So a hit now finishes by running the package
# manager's own install (dep_reconcile_cmd) to reconcile its state against the
# trees just linked in. This does not defeat the cache: what the cache exists to
# spare is the NATIVE BUILD, and a reconcile against a populated store performs
# none (measured on endojs/endo-but-for-bots: ~5s reconcile against a ~5s cold
# install on an already-warm yarn store, with better-sqlite3's prebuilt .node
# keeping its cached inode and mtime). Both numbers appear in the HIT log line.
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

# ── warm dependency cache: config + helpers (see the file header) ─────────────
# The cache lives under $GARDEN_STATE — per-host, persistent, OUTSIDE any
# reset-prone worktree (the designed home for host-local caches), and on the same
# filesystem as $GARDEN_SCRATCH (both under $GARDEN_ROOT by default) so the
# hardlink populate is a genuine same-fs `cp -al`. It is keyed by
# <owner>-<repo>/<lockfile-hash>, sitting next to the standing bare clone's data.
: "${GARDEN_DEP_CACHE_ROOT:=$GARDEN_STATE/dep-cache}"
: "${GARDEN_DEP_INSTALL_TIMEOUT:=900}"     # seconds; a wedged install must not wedge the handoff
: "${GARDEN_DEP_LOCK_WAIT:=600}"           # seconds a 2nd concurrent first-job waits for the builder
: "${GARDEN_DEP_CACHE_TTL_DAYS:=14}"       # a sibling lockfile-hash cache idle this long is prunable

# A botanist must inspect an unvetted dependency without giving its lifecycle
# scripts a chance to execute first. Worker handlers pass the job role through
# GARDEN_JOB_ROLE; all other callers retain the historic native-build-enabled
# path. Keep the cache namespaces separate: a scripts-disabled botanist checkout
# must never be populated from an enabled-script cache built by another role.
if [ "${GARDEN_JOB_ROLE:-}" = botanist ]; then
  dep_install_policy="scripts-disabled"
  dep_install_env="GARDEN_DEP_SCRIPTS_DISABLED=1 npm_config_ignore_scripts=true pnpm_config_ignore_scripts=true YARN_ENABLE_SCRIPTS=false"
  dep_install_log_label="scripts disabled"
else
  dep_install_policy="native-builds"
  dep_install_env=""
  dep_install_log_label="native builds included"
fi

# list_node_modules <root> — the OUTERMOST node_modules dirs (the root one plus
# each workspace package's), one relative path per line. `-prune` stops descent
# INTO a matched node_modules, so the pnpm linker's nested node_modules/.store/…
# node_modules are carried wholesale with their parent, never re-listed.
list_node_modules() {
  find "$1" -type d -name node_modules -prune -printf '%P\n' 2>/dev/null
}

# link_tree <src> <dst> — populate <dst> from <src> sharing file storage. Prefer
# a hardlink copy (`cp -al`: instant, zero data copy, shares the compiled native
# .node inodes — the whole point); fall back to a plain recursive copy when src
# and dst straddle filesystems (EXDEV) so reuse still works, just without the
# disk saving. `cp -a` preserves symlinks AS symlinks, which the pnpm linker's
# relative .store symlink web needs. Assumes node_modules is treated as immutable
# by the toolchain (yarn/pnpm relink rather than write-in-place), so a shared
# inode is never mutated under another worktree.
link_tree() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")" 2>/dev/null || return 1
  cp -al "$src" "$dst" 2>/dev/null && return 0
  rm -rf "$dst" 2>/dev/null || true
  cp -a "$src" "$dst" 2>/dev/null
}

# dep_install_cmd <wt> — echo the install command for the worktree's package
# manager, or return 1 when none is usable. For botanists it prefixes every
# command (including the per-project/test escape hatch) with the npm, pnpm, and
# Yarn scripts-disabled settings. GARDEN_DEP_INSTALL_CMD otherwise overrides
# everything. yarn goes through corepack when a
# bare `yarn` is absent (the fresh-worktree norm; see pre-pr-checklist § Pitfalls).
#
# NOTE for the warm-HIT reconcile below: use dep_reconcile_cmd, not this, so a
# destructive `npm ci` never deletes the trees we just linked in.
dep_install_cmd() {
  local wt="$1" cmd=""
  if [ -n "${GARDEN_DEP_INSTALL_CMD:-}" ]; then
    cmd="$GARDEN_DEP_INSTALL_CMD"
  elif [ -f "$wt/yarn.lock" ]; then
    command -v yarn     >/dev/null 2>&1 && cmd="yarn install --immutable"
    [ -n "$cmd" ] || { command -v corepack >/dev/null 2>&1 && cmd="corepack yarn install --immutable"; }
  elif [ -f "$wt/pnpm-lock.yaml" ] && command -v pnpm >/dev/null 2>&1; then
    cmd="pnpm install --frozen-lockfile"
  elif [ -f "$wt/package-lock.json" ] || [ -f "$wt/npm-shrinkwrap.json" ]; then
    command -v npm >/dev/null 2>&1 && cmd="npm ci"
  elif [ -f "$wt/package.json" ]; then
    command -v corepack >/dev/null 2>&1 && cmd="corepack yarn install"
    [ -n "$cmd" ] || { command -v npm >/dev/null 2>&1 && cmd="npm install"; }
  fi
  [ -n "$cmd" ] || return 1
  [ -n "$dep_install_env" ] && cmd="$dep_install_env $cmd"
  printf '%s\n' "$cmd"
  return 0
}

# dep_reconcile_cmd <wt> — echo the install command to run in a worktree that has
# ALREADY been populated from the warm cache, so the package manager reconciles
# its own link state against the trees we linked in (see § Link-state reconcile).
# It is dep_install_cmd with one substitution: `npm ci` DELETES node_modules
# before installing, which would throw away the very trees the hit just placed,
# so the additive `npm install` reconciles instead. `yarn install --immutable`
# and `pnpm install --frozen-lockfile` are already additive/idempotent.
dep_reconcile_cmd() {
  local wt="$1" cmd
  if [ -n "${GARDEN_DEP_RECONCILE_CMD:-}" ]; then
    cmd="$GARDEN_DEP_RECONCILE_CMD"
    [ -n "$dep_install_env" ] && cmd="$dep_install_env $cmd"
    printf '%s\n' "$cmd"
    return 0
  fi
  cmd="$(dep_install_cmd "$wt")" || return 1
  case "$cmd" in
    "npm ci") cmd="npm install" ;;
    *" npm ci") cmd="${cmd% npm ci} npm install" ;;
  esac
  printf '%s\n' "$cmd"
}

# dep_cache_prune <slug> <keep-lockhash> — best-effort removal of sibling
# lockfile-hash caches under this slug that have been idle (unbuilt AND unhit)
# longer than the TTL, keeping the current one. Called under the per-slug lock so
# it never races a concurrent provisioner for this slug; a fresh sibling hash
# (just built or just hit → recent mtime) is never pruned.
dep_cache_prune() {
  local slug="$1" keep="$2" d
  local root="$GARDEN_DEP_CACHE_ROOT/$slug"
  [ -d "$root" ] || return 0
  find "$root" -mindepth 1 -maxdepth 1 -type d ! -name "$keep" \
       -mtime +"$GARDEN_DEP_CACHE_TTL_DAYS" -print 2>/dev/null \
    | while IFS= read -r d; do
        rm -rf "$d" 2>/dev/null && log "dep-cache prune: removed idle $d"
      done
  return 0
}

# provision_deps <wt> <slug> — populate <wt>'s node_modules from the warm cache,
# building the cache once if this lockfile has not been seen on this host. Every
# path returns 0: this is best-effort and never fails the worktree handoff. All
# human/diagnostic output goes to stderr via log(); stdout stays reserved for the
# caller's single worktree-path line.
provision_deps() {
  local wt="$1" slug="$2"
  [ "${GARDEN_SKIP_DEP_PROVISION:-0}" = 1 ] && { log "dep-cache skip: GARDEN_SKIP_DEP_PROVISION=1"; return 0; }

  # Which lockfile identifies the dependency closure? First match wins.
  local lockfile="" lf
  for lf in yarn.lock pnpm-lock.yaml package-lock.json npm-shrinkwrap.json; do
    [ -f "$wt/$lf" ] && { lockfile="$lf"; break; }
  done
  if [ -z "$lockfile" ]; then
    log "dep-cache skip: no lockfile in $wt (nothing to provision)"
    return 0
  fi

  # Content-address the cache by the lockfile hash: a lockfile change → a new key
  # → an automatic rebuild; an unchanged lockfile across branches/PRs → a shared
  # warm cache. git hash-object matches how git already addresses the same bytes.
  local lockhash
  lockhash="$(git hash-object "$wt/$lockfile" 2>/dev/null \
              || sha1sum "$wt/$lockfile" 2>/dev/null | cut -d' ' -f1)"
  [ -n "$lockhash" ] || { log "WARN: dep-cache skip: could not hash $wt/$lockfile"; return 0; }

  local slug_dir="$GARDEN_DEP_CACHE_ROOT/$slug"
  local cache_key="$lockhash-$dep_install_policy"
  local cache_dir="$slug_dir/$cache_key"
  local complete="$cache_dir/.complete"
  local lock="$slug_dir/.lock"
  mkdir -p "$slug_dir" 2>/dev/null \
    || { log "WARN: dep-cache skip: cannot create $slug_dir"; return 0; }
  mkdir -p "$GARDEN_SCRATCH" 2>/dev/null || true

  # Serialize per-repo (fd 9) so two concurrent first-jobs don't both run the
  # native build; the loser waits, then hits the warm cache. The lock is released
  # automatically when the subshell exits. On lock-wait timeout we skip
  # provisioning entirely (best-effort) rather than block the handoff.
  (
    flock -w "$GARDEN_DEP_LOCK_WAIT" 9 || {
      log "WARN: dep-cache: lock wait (${GARDEN_DEP_LOCK_WAIT}s) timed out for $slug; handing back unprovisioned"
      exit 0
    }

    local t0 t1 secs rel n
    t0="$(date +%s 2>/dev/null || echo 0)"

    # yarn 4's portable shell writes exec shims to $TMPDIR; a noexec /tmp makes
    # every yarn-run bin die with "permission denied" (agoric-sdk-local-build-env).
    # Point TMPDIR at an exec-capable scratch dir defensively. Both the cold
    # install and the warm-hit reconcile below dispatch through package bins.
    local tmpexec="$GARDEN_SCRATCH/tmpexec"
    mkdir -p "$tmpexec" 2>/dev/null || true

    if [ -f "$complete" ] && [ -f "$cache_dir/manifest" ]; then
      # Warm HIT: hardlink every cached node_modules tree into the fresh worktree.
      n=0
      while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        [ -d "$cache_dir/trees/$rel" ] || continue
        [ -e "$wt/$rel" ] && continue          # never clobber (fresh tree has none)
        link_tree "$cache_dir/trees/$rel" "$wt/$rel" && n=$((n+1))
      done < "$cache_dir/manifest"
      touch "$cache_dir" "$complete" 2>/dev/null || true   # LRU: last-use, not last-build

      # ── Link-state reconcile ──────────────────────────────────────────────
      # The cache holds node_modules trees ONLY, but a package manager keeps its
      # "is this project installed?" state OUTSIDE them: yarn 4 writes
      # .yarn/install-state.gz at the project root (and .yarn-state.yml under the
      # node-modules linker), and both are gitignored, so a fresh `git worktree
      # add` has neither. The linked-in trees are therefore invisible to yarn and
      # EVERY `yarn run <script>` in the worktree dies with
      #   Usage Error: The project in .../package.json doesn't seem to have been
      #   installed - running an install there might help
      # which made local-verify.sh report ALL SIX steps FAILED with that one
      # message — an environment divergence in the sense of skills/local-verify
      # § Parity is the contract, and a strong incentive to push without the gate.
      # Assuming the copied trees ARE the whole install is the bug; the package
      # manager's own install is what reconciles its state against them. On a warm
      # store that is a relink plus a state write, and it provably does NOT redo
      # the native build the cache exists to spare (better-sqlite3's prebuilt
      # .node keeps its cached inode and mtime across the reconcile). The log line
      # below carries both numbers so the cold-vs-warm delta stays observable.
      local rsecs=0 rrunner rrc=0 r0 r1 rout rsha cold="" coldnote="cold install unrecorded"
      [ -f "$cache_dir/install-secs" ] && cold="$(cat "$cache_dir/install-secs" 2>/dev/null)"
      [ -n "$cold" ] && coldnote="cold install was ${cold}s"
      if [ "${GARDEN_SKIP_DEP_RECONCILE:-0}" = 1 ]; then
        rrunner="(skipped: GARDEN_SKIP_DEP_RECONCILE=1)"
      elif rrunner="$(dep_reconcile_cmd "$wt")"; then
        r0="$(date +%s 2>/dev/null || echo 0)"
        rout="$(mktemp "$GARDEN_SCRATCH/dep-reconcile.XXXXXX" 2>/dev/null)" || rout=""
        ( cd "$wt" && TMPDIR="$tmpexec" timeout --kill-after=30 "$GARDEN_DEP_INSTALL_TIMEOUT" bash -c "$rrunner" ) \
          >"${rout:-/dev/null}" 2>&1 || rrc=$?
        r1="$(date +%s 2>/dev/null || echo 0)"; rsecs=$((r1 - r0))
        if [ "$rrc" -ne 0 ]; then
          # Never fails the handoff, but say so loudly: the trees are in place yet
          # the package manager may still refuse to run any script in the tree.
          rsha=""
          [ -n "$rout" ] && [ -s "$rout" ] && rsha="$(git -C "$wt" hash-object -w --stdin < "$rout" 2>/dev/null || true)"
          log "WARN: WARM-CACHE reconcile FAILED: '${rrunner}' exited rc=${rrc} in ${wt}; the package manager may still report the project as not installed, in which case every 'yarn run' (and so every local-verify step) fails with one usage error. log blob: ${rsha:-<none>}$([ -n "$rsha" ] && printf ' (inspect: git -C %s cat-file -p %s)' "$wt" "$rsha")"
        fi
        [ -n "$rout" ] && rm -f "$rout" 2>/dev/null
      else
        rrunner="(none: no usable package manager)"
      fi

      t1="$(date +%s 2>/dev/null || echo 0)"; secs=$((t1 - t0))
      log "WARM-CACHE hit: ${slug}@${lockhash:0:12} [${dep_install_policy}] populated ${n} node_modules tree(s) into ${wt} in ${secs}s (of which ${rsecs}s link-state reconcile '${rrunner}' rc=${rrc}; ${coldnote})"
      exit 0
    fi

    # COLD: build the closure ONCE, here, under the lock.
    local runner
    runner="$(dep_install_cmd "$wt")" || {
      log "dep-cache skip: no usable package manager for $wt (no yarn/pnpm/npm on PATH)"
      exit 0
    }
    local out rc=0 i0 i1 isecs
    out="$(mktemp "$GARDEN_SCRATCH/dep-install.XXXXXX" 2>/dev/null)" || out=""
    log "dep-cache: cold build ${slug}@${lockhash:0:12} [${dep_install_policy}] — running '${runner}' in ${wt} (${dep_install_log_label})"
    i0="$(date +%s 2>/dev/null || echo 0)"
    if [ -n "$out" ]; then
      ( cd "$wt" && TMPDIR="$tmpexec" timeout --kill-after=30 "$GARDEN_DEP_INSTALL_TIMEOUT" bash -c "$runner" ) >"$out" 2>&1 || rc=$?
    else
      ( cd "$wt" && TMPDIR="$tmpexec" timeout --kill-after=30 "$GARDEN_DEP_INSTALL_TIMEOUT" bash -c "$runner" ) >/dev/null 2>&1 || rc=$?
    fi
    i1="$(date +%s 2>/dev/null || echo 0)"; isecs=$((i1 - i0))

    if [ "$rc" -eq 0 ]; then
      # SUCCESS: snapshot every node_modules tree into the cache, then mark complete.
      rm -rf "$cache_dir/trees" "$cache_dir/manifest" "$cache_dir/manifest.tmp" 2>/dev/null || true
      mkdir -p "$cache_dir/trees" 2>/dev/null || true
      : > "$cache_dir/manifest.tmp" 2>/dev/null || true
      n=0; local fail=0
      while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        printf '%s\n' "$rel" >> "$cache_dir/manifest.tmp"
        if link_tree "$wt/$rel" "$cache_dir/trees/$rel"; then n=$((n+1)); else fail=1; fi
      done < <(list_node_modules "$wt")
      t1="$(date +%s 2>/dev/null || echo 0)"; secs=$((t1 - t0))
      if [ "$n" -gt 0 ] && [ "$fail" -eq 0 ]; then
        mv -f "$cache_dir/manifest.tmp" "$cache_dir/manifest" 2>/dev/null
        # Record the cold install's own duration so every later HIT can log the
        # cold-vs-warm delta (§ Link-state reconcile) rather than assert it.
        printf '%s\n' "$isecs" > "$cache_dir/install-secs" 2>/dev/null || true
        : > "$complete" 2>/dev/null || true
        log "WARM-CACHE built: ${slug}@${lockhash:0:12} [${dep_install_policy}] installed + cached ${n} node_modules tree(s) in ${secs}s (install ${isecs}s)"
        dep_cache_prune "$slug" "$cache_key"
      else
        rm -rf "$cache_dir/trees" "$cache_dir/manifest.tmp" 2>/dev/null || true
        log "WARN: dep-cache: install succeeded but snapshot captured ${n} tree(s) (fail=${fail}) for ${slug}; not caching"
      fi
      [ -n "$out" ] && rm -f "$out" 2>/dev/null
      exit 0
    fi

    # FAILURE: do NOT cache a broken/empty closure. Emit a deterministic signal and
    # name the container-image toolchain fallback (build-essential + python): if the
    # native build never succeeds here, no warm cache can manufacture a build that
    # never existed — the fix moves to the image/entrypoint, which this line flags.
    local sha=""
    [ -n "$out" ] && [ -s "$out" ] && sha="$(git -C "$wt" hash-object -w --stdin < "$out" 2>/dev/null || true)"
    rm -rf "$cache_dir/trees" "$cache_dir/manifest.tmp" 2>/dev/null || true
    log "WARN: WARM-CACHE MISS+FAIL: ${slug}@${lockhash:0:12} '${runner}' exited rc=${rc} (a native-module toolchain gap — missing compiler/python — or a lockfile needing update). If this recurs on every host, the fix is build-essential+python in the container image/entrypoint, NOT this cache. install log blob: ${sha:-<none>}$([ -n "$sha" ] && printf ' (inspect: git -C %s cat-file -p %s)' "$wt" "$sha")"
    [ -n "$out" ] && rm -f "$out" 2>/dev/null
    exit 0
  ) 9>>"$lock"
  return 0
}

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
# The base key stays readable for short jobs, but long bases are truncated and
# carry a stable hash suffix. This bounds the job-owned portion of the path even
# when a producer emits a verbose base, leaving daemon suites room for deep UNIX
# socket paths without asking agents to invent shorter aliases. The discriminator
# separately bounds and identifies <owner/repo@branch>.
base_safe="$(project_worktree_base_key "$base")"
disc="$(printf '%s@%s' "$repo" "$branch" | cksum | cut -d' ' -f1)"
disc="$(printf '%08x' "$disc" 2>/dev/null || printf '%s' "$disc")"
wt="$GARDEN_SCRATCH/project-wt-${base_safe}-${disc}"
legacy_base_safe="${base//[^A-Za-z0-9._-]/-}"
legacy_wt="$GARDEN_SCRATCH/project-wt-${legacy_base_safe}-${disc}"

# ── resume: reuse an existing, validly-registered worktree as-is ─────────────
# If the dir exists AND the bare clone still knows it as a registered worktree,
# the caller is resuming into in-flight work; hand back the same path untouched.
if [ -d "$wt" ] && git --git-dir="$bare" worktree list --porcelain 2>/dev/null \
     | grep -qxF "worktree $wt"; then
  printf '%s\n' "$wt"
  exit 0
fi

# One-time migration for a long-base checkout created before base keys were
# bounded. Move the registered worktree instead of making a fresh checkout, so
# the shorter path takes effect without losing in-flight uncommitted work.
if [ "$legacy_wt" != "$wt" ] && [ -d "$legacy_wt" ] \
   && git --git-dir="$bare" worktree list --porcelain 2>/dev/null \
      | grep -qxF "worktree $legacy_wt"; then
  [ -e "$wt" ] && scratch_cleanup "$wt"
  mkdir -p "$GARDEN_SCRATCH"
  git --git-dir="$bare" worktree move "$legacy_wt" "$wt" \
    || die "ensure-project-worktree: could not shorten legacy worktree path $legacy_wt"
  log "ensure-project-worktree: shortened legacy worktree path to $wt"
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
# `worktree list --porcelain` can print a stale path through an escaped or
# otherwise non-identical spelling, while `worktree add` still considers that
# same missing checkout registered.  When the deterministic destination is
# absent there is no live checkout to preserve at that path, so prune every
# genuinely missing entry instead of relying on an exact textual match.
[ ! -e "$wt" ] && git --git-dir="$bare" worktree prune 2>/dev/null || true
mkdir -p "$GARDEN_SCRATCH"

# Resolve the requested branch into the bare clone's remote-tracking ref
# (refs/remotes/origin/$branch) before the add, then check the worktree out from
# THAT ref. We deliberately fetch into the REMOTE-TRACKING ref, never
# refs/heads/$branch: a standing worktree can legitimately hold refs/heads/$branch
# checked out (e.g. the endo-but-for-bots monitor worktree holds refs/heads/llm),
# and git refuses to fetch into a branch checked out in ANY worktree
# ("fatal: refusing to fetch into branch 'refs/heads/llm' checked out at ..."),
# which the old +refs/heads/$branch:refs/heads/$branch refspec tripped on every
# run — the 2026-07-06 hard-failure. Remote-tracking refs are never checked out,
# so the force-update always succeeds, and a `--detach` add off the remote-tracking
# ref needs no local head at all. The `+` forces the update if the ref already
# exists. If the branch is on neither side the fetch is a no-op and the add below
# surfaces a clear error.
#
# ── Silent stale-fetch guard (the 2026-07-06 regression) ─────────────────────
# A bare `2>/dev/null || true` on the fetch swallows EVERY failure, so a transient
# network/auth blip silently leaves refs/remotes/origin/$branch at a STALE local
# SHA and the gardener works an old tree with no warning. Observed 2026-07-06 (job
# design-daemon-agent-tools-reconcile-mount-git-capabilities): endo-but-for-bots@llm
# was delivered 8 weeks stale at 68246ad9 — missing the very docs the job named —
# while origin/llm was at 11322892, and a manual `git fetch origin llm` succeeded
# moments later. So we verify the remote-tracking head against the AUTHORITATIVE
# remote tip (`git ls-remote`) after the fetch, retry once on any divergence, and
# die rather than hand back a stale tree. The remote lookup itself gets one retry
# so a blip there does not defeat the guard. The fetch's stderr is captured and
# surfaced via log() rather than discarded, so the next failure mode is visible.
remote_branch_sha() {
  git --git-dir="$bare" ls-remote origin "refs/heads/${branch}" 2>/dev/null | cut -f1
}
tracking_branch_sha() {
  git --git-dir="$bare" rev-parse --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null || true
}
fetch_branch() {
  local err
  err="$(git --git-dir="$bare" fetch --quiet origin \
           "+refs/heads/${branch}:refs/remotes/origin/${branch}" 2>&1 >/dev/null)" \
    || { [ -n "$err" ] && log "WARN: ensure-project-worktree: fetch of ${repo}@${branch} failed: ${err}"; return 1; }
  [ -n "$err" ] && log "ensure-project-worktree: fetch ${repo}@${branch}: ${err}"
  return 0
}

remote_sha="$(remote_branch_sha)"
[ -z "$remote_sha" ] && remote_sha="$(remote_branch_sha)"   # one retry past a blip

fetch_branch || true

if [ -n "$remote_sha" ]; then
  # The branch exists upstream: the remote-tracking head MUST equal the remote tip,
  # else the fetch silently failed or delivered a stale ref. Retry once, then refuse.
  have_sha="$(tracking_branch_sha)"
  if [ "$have_sha" != "$remote_sha" ]; then
    log "WARN: ensure-project-worktree: refs/remotes/origin/${branch} is ${have_sha:-<absent>} but origin/${branch} is ${remote_sha}; retrying fetch"
    fetch_branch || true
  fi
  now_sha="$(tracking_branch_sha)"
  if [ "$now_sha" != "$remote_sha" ]; then
    die "ensure-project-worktree: could not fetch ${repo}@${branch} to ${remote_sha} (remote-tracking head is ${now_sha:-absent}, likely a transient network/auth failure); refusing to hand back a stale tree"
  fi
fi
# else: the branch is on neither side (a legitimate detached ref/sha checkout) —
# the fetch is a no-op and the add below resolves $ref locally or errors clearly.

# What to check out: when the caller wants the branch (the default), use the
# remote-tracking ref we just fetched and verified — refs/heads/$branch is no
# longer fetched into and may be absent or held by another worktree. An explicit
# ref/SHA argument is resolved as given.
add_ref="$ref"
[ "$ref" = "$branch" ] && add_ref="refs/remotes/origin/${branch}"

git --git-dir="$bare" worktree add --detach "$wt" "$add_ref" >/dev/null \
  || die "ensure-project-worktree: could not check out $repo@$ref into $wt"

# Pin the bot identity so a subagent's commits cannot drift to the parent shell's
# global git identity (the maintainer identity on a maintainer host).
git -C "$wt" config user.name  "$(bot_name)"
git -C "$wt" config user.email "$(bot_email)"

# ── warm dependency provisioning (native-module reuse across worktrees) ──────
# See the header § Warm dependency cache. Best-effort: the `|| log` net suspends
# `set -e` for the whole call, so a provisioning failure logs and continues —
# the worktree handoff (the printf below) is never blocked.
provision_deps "$wt" "${owner}-${name}" || \
  log "WARN: dep-cache: provisioning raised for ${owner}/${name}@${branch} (non-fatal); worktree handed back unprovisioned"

printf '%s\n' "$wt"
