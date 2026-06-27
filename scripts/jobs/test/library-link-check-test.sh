#!/bin/bash
# library-link-check-test.sh — coverage for the deterministic library section-link
# resolver (library-link-check.sh) and its post-ingest gate (--changed) mode.
#
# Regression for the 2026-06-27 missing-parent-index defect (job
# `ingest-ocap-kernel`, commit 069d42b1): an ingest committed 11 child section
# files + the source page + the sections/README.md rows but silently dropped the
# `kind: index` parent section file, leaving the README (index) row and the
# source page pointing at a nonexistent file. The gate must catch this at write
# time, before the ingest is reported complete.
#
# Hermetic: a throwaway git repo stands in for the journal worktree with a tiny
# library/ tree. No real journal, no network.
#
# Usage: library-link-check-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
CHECK="$JOBS/library-link-check.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-link-check-test
rm -rf "$TR"; mkdir -p "$TR"
LIB="$TR/journal/library"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- fixture builders --------------------------------------------------------
write_child() {
  local slug="$1" sec="$2"
  cat > "$LIB/sections/${slug}--${sec}.md" <<EOF
---
title: $sec
status: current
---
## Abstract
Child section $sec.

## See also
- Source index: [${slug}](../sources/${slug}.md)

Source: [docs/x.md](https://example/blob/abc/docs/x.md) at commit \`abc\`.
EOF
}

write_source_page() {
  local slug="$1"; shift
  {
    echo "---"; echo "source: docs/x.md"; echo "status: current"; echo "---"
    echo; echo "## Abstract"; echo "Source page for $slug."; echo
    echo "## Sections"; echo
    echo "| Section | Topics | Status |"; echo "|---|---|---|"
    for sec in "$@"; do
      echo "| [${sec}](../sections/${slug}--${sec}.md) | t | current |"
    done
  } > "$LIB/sources/${slug}.md"
}

write_parent_index() {
  local slug="$1"; shift
  {
    echo "---"; echo "title: Parent"; echo "kind: index"; echo "status: current"; echo "---"
    echo; echo "## Abstract"; echo "Index parent for $slug."; echo
    echo "## Sections"
    for sec in "$@"; do
      echo "- [${sec}](${slug}--${sec}.md)"
    done
  } > "$LIB/sections/${slug}.md"
}

append_readme_block() {
  local slug="$1"; shift
  {
    echo
    echo "### ${slug}"
    echo
    echo "- [${slug}](${slug}.md) (index — test)"
    for sec in "$@"; do
      echo "  - [${sec}](${slug}--${sec}.md)"
    done
  } >> "$LIB/sections/README.md"
}

setup_fixture() {
  rm -rf "$TR/journal"
  mkdir -p "$LIB/sections" "$LIB/sources" "$LIB/topics" "$LIB/concepts" "$LIB/roles"
  echo "# Sections index" > "$LIB/sections/README.md"
  git -C "$TR/journal" init -q
}

commit_all() {
  git "${git_id[@]}" -C "$TR/journal" add -A
  git "${git_id[@]}" -C "$TR/journal" commit -q -m "$1"
}

# ============================================================================
hr; echo "SUBTEST 1: a clean source cluster resolves (exit 0)"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
write_child "$SLUG" api
write_source_page "$SLUG" core api
write_parent_index "$SLUG" core api
append_readme_block "$SLUG" core api
commit_all "clean cluster"
git "${git_id[@]}" -C "$TR/journal" branch -f base HEAD

out="$("$CHECK" --library "$LIB" --source-slug "$SLUG" 2>&1)"; rc=$?
if [ "$rc" = 0 ]; then ok "clean cluster exits 0"; else bad "clean cluster exit $rc:"; echo "$out"; fi
echo "$out" | grep -q "OK — every checked link resolves" && ok "OK verdict printed" || bad "no OK verdict"

# ============================================================================
hr; echo "SUBTEST 2: the missing-parent-index defect (children+source+README, no parent) fails"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
write_child "$SLUG" api
write_source_page "$SLUG" core api
# parent index DELIBERATELY OMITTED (the defect)
append_readme_block "$SLUG" core api
commit_all "missing parent index"

out="$("$CHECK" --library "$LIB" --source-slug "$SLUG" 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "missing parent fails (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .* -> ${SLUG}.md" && ok "README (index) row flagged as dangling" || { bad "missing-parent row not flagged"; echo "$out"; }
echo "$out" | grep -q "FAIL — 1 dangling" && ok "single dangling reported" || bad "dangling count wrong"

# ============================================================================
hr; echo "SUBTEST 3: GATE mode (--changed) reproduces the ingest defect from a diff"
setup_fixture
# Base: empty library committed.
commit_all "empty base"
git "${git_id[@]}" -C "$TR/journal" branch -f base HEAD
# The faulty ingest: children + source page + README rows committed, parent NOT written.
SLUG="metamask-ocap-kernel--docs-kernel-guide-md"
write_child "$SLUG" core-concepts
write_child "$SLUG" kernel-api
write_source_page "$SLUG" core-concepts kernel-api
append_readme_block "$SLUG" core-concepts kernel-api
commit_all "ingest ocap-kernel (parent omitted)"

out="$("$CHECK" --library "$LIB" --changed base 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "--changed catches the omitted parent (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .* -> ${SLUG}.md" && ok "gate flags the missing parent via the README block" || { bad "gate missed the parent"; echo "$out"; }

# ============================================================================
hr; echo "SUBTEST 4: GATE mode passes once the parent index is written"
write_parent_index "$SLUG" core-concepts kernel-api
commit_all "add the missing parent index"
out="$("$CHECK" --library "$LIB" --changed base 2>&1)"; rc=$?
if [ "$rc" = 0 ]; then ok "gate passes after repair (exit 0)"; else bad "expected exit 0, got $rc:"; echo "$out"; fi

# ============================================================================
hr; echo "SUBTEST 5: a missing CHILD (source page row dangles) is caught"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
# 'api' child omitted but referenced everywhere
write_source_page "$SLUG" core api
write_parent_index "$SLUG" core api
append_readme_block "$SLUG" core api
commit_all "missing child"
out="$("$CHECK" --library "$LIB" --source-slug "$SLUG" 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "missing child fails (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .* -> ${SLUG}--api.md\|DANGLING .* -> ../sections/${SLUG}--api.md" \
  && ok "missing-child row flagged" || { bad "missing child not flagged"; echo "$out"; }

# ============================================================================
hr; echo "SUBTEST 6: an on-disk but git-untracked target is treated as dangling"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
write_source_page "$SLUG" core
write_parent_index "$SLUG" core
append_readme_block "$SLUG" core
commit_all "committed cluster"
# Now add a child file on disk but DON'T commit/stage it, and reference it.
write_child "$SLUG" uncommitted
git "${git_id[@]}" -C "$TR/journal" checkout -q -- . 2>/dev/null || true
# re-create untracked child + a referencing row in an untracked edit
write_child "$SLUG" uncommitted
printf '  - [uncommitted](%s--uncommitted.md)\n' "$SLUG" >> "$LIB/sections/README.md"
out="$("$CHECK" --library "$LIB" --source-slug "$SLUG" 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "untracked target fails (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "git-untracked" && ok "untracked diagnosis printed" || { bad "no untracked diagnosis"; echo "$out"; }
# And with --no-require-tracked it should pass (file exists on disk).
out2="$("$CHECK" --library "$LIB" --source-slug "$SLUG" --no-require-tracked 2>&1)"; rc2=$?
if [ "$rc2" = 0 ]; then ok "--no-require-tracked accepts on-disk file (exit 0)"; else bad "expected exit 0 with --no-require-tracked, got $rc2"; fi

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ] && { rm -rf "$TR"; exit 0; } || exit 1
