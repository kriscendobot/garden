#!/bin/bash
# directive-identity-dedup-test.sh — the cross-producer directive-identity dedup
# guard on post-job.sh (fu-endojs-endo-but-for-bots-pr58-4932647c-2).
#
# The gap it closes: a single PR directive (PR #58) spawned TWO concurrent jobs —
# one from the comment-watcher (`<slug>-pr<N>-<hash>`) and one from a peer/liaison
# hand-naming a job for the SAME comment (`ebfb-pr-<N>-<slug>`). post-job.sh's
# basename idempotency cannot see the two DIFFERENTLY-named jobs are the ONE
# directive, so both landed and two gardeners raced the same PR (the clobber root
# cause). The fix keys an extra dedup index on a producer-supplied *directive
# identity* (`<owner>/<repo>#<pr>:comment:<cid>`): one directive → at most one
# OPEN job, whatever each producer named it.
#
# Asserts:
#   1. First post with identity I creates the job AND one index entry.
#   2. A DIFFERENT-named post with the SAME identity I is a NO-OP (deduped);
#      only the first job exists.
#   3. A post with a DIFFERENT identity J is NOT deduped (two jobs coexist).
#   4. Auto-derivation: a post with NO explicit identity whose BODY cites exactly
#      one canonical GitHub comment URL dedups against the identity that URL maps
#      to (a hand-named peer job that merely quotes the comment collapses too).
#   5. A body citing TWO distinct comment URLs derives NO identity (conservative —
#      never fold two distinct directives), so it posts as its own job.
#   6. Stale index: once the owning base has DRAINED out of the lifecycle, the
#      same identity may mint a fresh job (a completed directive never blocks a
#      new one), and the index is re-pointed to the new base.
#   7. Backward compatibility: a post with no identity and no derivable one
#      behaves exactly as before (creates its job, writes no index entry).
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.
#
# Usage: directive-identity-dedup-test.sh

# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/directive-identity-dedup-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Scrub any ambient fleet GARDEN_*/JOURNAL_* so a live gardener invoking this test
# cannot splice the real journal under it (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

# --- throwaway journal ------------------------------------------------------
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/index
  touch jobs/todo/.gitkeep jobs/doin/.gitkeep jobs/tada/.gitkeep jobs/index/.gitkeep
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2 )

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
       GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
       GARDEN=idhost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1

# job_id_hash for asserting the exact index key from the test side.
# shellcheck source=../common.sh
source "$JOBS/common.sh"

tree()  { git -C "$BARE" ls-tree -r --name-only journal2; }
has()   { tree | grep -qx "jobs/todo/$1.md"; }   # is <base> present in todo/
nidx()  { tree | grep -c '^jobs/index/[0-9a-f]'; } # count real index entries
post()  { "$JOBS/post-job.sh" "$@" >/dev/null 2>&1; }  # rc preserved
bodyfile() { local f; f="$(mktemp "$TR/body.XXXXXX")"; printf '%s\n' "$1" > "$f"; printf '%s' "$f"; }

ID="endojs/endo-but-for-bots#58:comment:4850565566"
OTHER="endojs/endo-but-for-bots#58:comment:9999999999"

echo "================================================================"
echo "DIRECTIVE-IDENTITY DEDUP"
echo "================================================================"

# --- 1: first post with identity creates the job + one index entry ----------
post --identity "$ID" watcher-pr58-abc123 "$(bodyfile 'comment-watcher job for #58')"
has watcher-pr58-abc123 && ok "1a first identity post created its job" \
                        || bad "1a first identity post did not create its job"
[ "$(nidx)" -eq 1 ] && ok "1b exactly one index entry written" \
                    || bad "1b expected 1 index entry, got $(nidx)"
idkey="$(job_id_hash "$ID")"
tree | grep -qx "jobs/index/$idkey" && ok "1c index keyed on job_id_hash(identity)" \
                                    || bad "1c index not keyed as expected ($idkey)"

# --- 2: a DIFFERENT-named post with the SAME identity is a no-op ------------
post --identity "$ID" ebfb-pr-58-error-bubble "$(bodyfile 'peer hand-named job, same directive')"
! has ebfb-pr-58-error-bubble && ok "2a same-identity peer post deduped (no second job)" \
                              || bad "2a same-identity peer post was NOT deduped (clobber gap open!)"
has watcher-pr58-abc123 && ok "2b the original job is untouched" \
                        || bad "2b the original job vanished"
[ "$(nidx)" -eq 1 ] && ok "2c still exactly one index entry" \
                    || bad "2c index entry count changed to $(nidx)"

# --- 3: a DIFFERENT identity is not deduped --------------------------------
post --identity "$OTHER" watcher-pr58-def456 "$(bodyfile 'a genuinely different directive on #58')"
has watcher-pr58-def456 && ok "3a distinct-identity post created its own job" \
                        || bad "3a distinct-identity post was wrongly deduped"
[ "$(nidx)" -eq 2 ] && ok "3b two index entries now" \
                    || bad "3b expected 2 index entries, got $(nidx)"

# --- 4: auto-derivation from a body citing ONE comment URL dedups ----------
# No --identity; the body quotes the SAME comment URL that maps to $ID, so the
# derived identity collides with the already-owned $ID → deduped.
url="https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4850565566"
post autoderive-pr58-xyz "$(bodyfile "Please address this — see $url for the ask.")"
! has autoderive-pr58-xyz && ok "4 body-derived identity dedups a hand-named peer job" \
                          || bad "4 body-derived identity did NOT dedup (auto-derive broken)"

# --- 5: a body citing TWO distinct comment URLs derives no identity --------
url2="https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-7777777777"
post ambiguous-pr58-two "$(bodyfile "Refs $url and also $url2 — two different comments.")"
has ambiguous-pr58-two && ok "5a ambiguous body (2 URLs) posts as its own job" \
                       || bad "5a ambiguous body was wrongly deduped/dropped"
[ "$(nidx)" -eq 2 ] && ok "5b ambiguous body wrote NO index entry (still 2)" \
                    || bad "5b ambiguous body unexpectedly changed index count to $(nidx)"

# --- 6: stale index — a drained owner never blocks a fresh directive -------
# Drain the $ID owner (watcher-pr58-abc123) out of the lifecycle entirely, then
# re-post the same identity under a NEW base. It must be allowed and re-pointed.
PC="$TR/drain"; git clone -q -b journal2 "$BARE" "$PC" 2>/dev/null
git -C "$PC" rm -q "jobs/todo/watcher-pr58-abc123.md"
git -C "$PC" -c user.name=t -c user.email=t@l commit -q -m 'drain owner'
git -C "$PC" push -q origin journal2
post --identity "$ID" watcher-pr58-reopened "$(bodyfile 'the directive recurred after the first job drained')"
has watcher-pr58-reopened && ok "6a same identity re-mints once the owner has drained" \
                          || bad "6a stale index wrongly blocked a fresh directive"
owner_now="$(git -C "$BARE" cat-file -p "journal2:jobs/index/$idkey" | sed -n 's/^base:[[:space:]]*//p')"
[ "$owner_now" = watcher-pr58-reopened ] && ok "6b index re-pointed to the new owner" \
                                         || bad "6b index owner is '$owner_now', expected watcher-pr58-reopened"

# --- 7: no identity, none derivable — unchanged behavior -------------------
before="$(nidx)"
post plain-job-no-identity "$(bodyfile 'a plain infra job with no comment reference at all')"
has plain-job-no-identity && ok "7a plain (no-identity) post still creates its job" \
                          || bad "7a plain post failed"
[ "$(nidx)" -eq "$before" ] && ok "7b plain post wrote no index entry" \
                            || bad "7b plain post unexpectedly wrote an index entry"

# --- 8: a COMPLETED job (in tada/, same base) never swallows a FRESH directive --
# The mechanical-verb producers key the base on (PR,verb), NOT the comment id, so a
# second maintainer directive on the same PR derives the SAME base as an already-
# COMPLETED job. With a directive identity present, the identity index — not the
# basename-in-tada — is the authoritative re-see guard, so a genuinely NEW directive
# must still post (the endo-but-for-bots #671 "Shepherd." drop, where a finished
# auto-shepherd in tada/ silently deduped a fresh directive of the same base).
CBASE=verb-collide-pr671-shepherd
IDA="endojs/endo-but-for-bots#671:comment:1111111111"   # the OLD (completed) directive
IDB="endojs/endo-but-for-bots#671:comment:2222222222"   # a FRESH directive, new comment
post --identity "$IDA" "$CBASE" "$(bodyfile 'first shepherd on #671')"
has "$CBASE" && ok "8a first same-base directive posted" || bad "8a first directive did not post"
# Complete it: move todo → tada (the finished auto-shepherd shape).
CC="$TR/complete"; git clone -q -b journal2 "$BARE" "$CC" 2>/dev/null
git -C "$CC" mv "jobs/todo/$CBASE.md" "jobs/tada/$CBASE.md"
git -C "$CC" -c user.name=t -c user.email=t@l commit -q -m 'complete shepherd (todo->tada)'
git -C "$CC" push -q origin journal2
! has "$CBASE" && ok "8b the completed job is now in tada/ (not todo)" || bad "8b completed job still in todo"
post --identity "$IDB" "$CBASE" "$(bodyfile 'a SECOND shepherd on #671, days later')"
has "$CBASE" && ok "8c a FRESH directive re-mints the base despite the completed tada job" \
             || bad "8c fresh directive swallowed by the tada entry (the #671 silent drop)"

# --- 8d: a NO-IDENTITY post whose base sits in tada/ is STILL deduped ----------
# The identity layer is what relaxes the tada-basename dedup; a plain producer (no
# identity, e.g. a commit triager re-seeing an old completed change) keeps FULL tada
# idempotency, unchanged.
NIB=plain-tada-idempotent
CC3="$TR/ntada"; git clone -q -b journal2 "$BARE" "$CC3" 2>/dev/null
printf 'done\n' > "$CC3/jobs/tada/$NIB.md"
git -C "$CC3" add -A; git -C "$CC3" -c user.name=t -c user.email=t@l commit -q -m 'seed tada for no-id case'
git -C "$CC3" push -q origin journal2
post "$NIB" "$(bodyfile 'plain no-identity re-post')"
! has "$NIB" && ok "8d a no-identity post whose base is in tada stays deduped (unchanged)" \
             || bad "8d no-identity tada dedup regressed (re-minted into todo)"

# The same basename idempotency must see a completed report below a date shard.
SHARDED_NIB=plain-sharded-tada-idempotent
CC4="$TR/ntada-sharded"; git clone -q -b journal2 "$BARE" "$CC4" 2>/dev/null
mkdir -p "$CC4/jobs/tada/2026/08/13"
printf 'done\n' > "$CC4/jobs/tada/2026/08/13/$SHARDED_NIB.md"
git -C "$CC4" add -A
git -C "$CC4" -c user.name=t -c user.email=t@l commit -q -m 'seed sharded tada for no-id case'
git -C "$CC4" push -q origin journal2
post "$SHARDED_NIB" "$(bodyfile 'plain no-identity re-post of sharded completion')"
! has "$SHARDED_NIB" && ok "8e a no-identity post dedups a sharded completed basename" \
                     || bad "8e sharded tada dedup regressed (re-minted into todo)"

# --- 8f: a no-identity collision against a COMPLETED tada job WARNs loudly ------
# The dedup no-op is correct (8d), but it used to log only a routine one-liner, so a
# recurring-action post swallowed by an OLD completed job passed unnoticed inside a
# scripted loop (the endo-but-for-bots-pr395-weave orchestration-child drop,
# 2026-08-17). A collision against tada/ must now surface as a WARN, distinct from the
# routine plan/todo/doin "already present" no-op.
WBASE=warn-on-tada-collision
CC5="$TR/warn-tada"; git clone -q -b journal2 "$BARE" "$CC5" 2>/dev/null
printf 'done\n' > "$CC5/jobs/tada/$WBASE.md"
git -C "$CC5" add -A; git -C "$CC5" -c user.name=t -c user.email=t@l commit -q -m 'seed tada for warn case'
git -C "$CC5" push -q origin journal2
werr="$("$JOBS/post-job.sh" "$WBASE" "$(bodyfile 'recurring post that collides with a completed job')" 2>&1 >/dev/null)"
! has "$WBASE" && ok "8f1 tada collision is still a no-op (not re-minted)" \
              || bad "8f1 tada collision wrongly re-minted"
printf '%s' "$werr" | grep -qi 'WARN.*collides with a COMPLETED job' \
  && ok "8f2 tada collision surfaces a loud WARN (not a routine no-op)" \
  || bad "8f2 tada collision did not emit the expected WARN (got: $werr)"

# --- 9: a COMPLETED owner (in tada/, index still points at it) never blocks a ----
# fresh directive of the SAME identity under a DIFFERENT base. This is the pr475
# incident: `...-pr475-reply-humans-resolve-policy` was refused because the identity
# index for comment 5333026938 still pointed at an EARLIER, already-COMPLETED job
# `...-pr475-e3925eb5` sitting in tada/. The old dedup used job_in_lifecycle, which
# counts tada as "in lifecycle", so the completed owner wrongly swallowed the new
# directive and the re-point path below never ran. Distinct from test 6 (which
# DELETED the owner from the board entirely) and from test 8 (a fresh directive with
# a DIFFERENT identity): here the owner survives IN tada and the identity is IDENTICAL,
# so only a plan|todo|doin-scoped active-owner check (job_is_active) lets it re-mint.
IDR="endojs/endo-but-for-bots#475:comment:5333026938"
OLDBASE=endojs-endo-but-for-bots-pr475-e3925eb5
NEWBASE=endojs-endo-but-for-bots-pr475-reply-humans-resolve-policy
idrkey="$(job_id_hash "$IDR")"
CC6="$TR/tada-owner-blocks"; git clone -q -b journal2 "$BARE" "$CC6" 2>/dev/null
printf 'done\n' > "$CC6/jobs/tada/$OLDBASE.md"
mkdir -p "$CC6/jobs/index"
printf 'base: %s\nidentity: %s\n' "$OLDBASE" "$IDR" > "$CC6/jobs/index/$idrkey"
git -C "$CC6" add -A
git -C "$CC6" -c user.name=t -c user.email=t@l commit -q -m 'seed completed owner + live index entry'
git -C "$CC6" push -q origin journal2
post --identity "$IDR" "$NEWBASE" "$(bodyfile 'maintainer reply directive on pr475, prior job already done')"
has "$NEWBASE" && ok "9a a fresh directive re-mints past a COMPLETED (tada) same-identity owner" \
              || bad "9a completed same-identity owner wrongly blocked the fresh directive (pr475 refusal)"
owner_r="$(git -C "$BARE" cat-file -p "journal2:jobs/index/$idrkey" | sed -n 's/^base:[[:space:]]*//p')"
[ "$owner_r" = "$NEWBASE" ] && ok "9b the identity index re-pointed to the new base" \
                            || bad "9b index owner is '$owner_r', expected $NEWBASE"

echo "----------------------------------------------------------------"
echo "directive-identity-dedup-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
