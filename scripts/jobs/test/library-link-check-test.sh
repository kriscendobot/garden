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
hr; echo "SUBTEST 7: a link resolving OUTSIDE the library is skipped, not flagged"
setup_fixture
# A concept page whose only link points across the tree into the garden's main2
# skills/ (a legitimate cross-tree reference the resolver cannot judge).
cat > "$LIB/concepts/x.md" <<'EOF'
# x
See the [lookup skill](../../../skills/library-lookup/SKILL.md).
EOF
commit_all "concept with an out-of-library link"
out="$("$CHECK" --library "$LIB" --files concepts/x.md 2>&1)"; rc=$?
if [ "$rc" = 0 ]; then ok "out-of-library link does not fail the scan (exit 0)"; else bad "expected exit 0, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "skip .*outside library" && ok "out-of-library link reported as skipped" || bad "no skip line for the out-of-library link"
echo "$out" | grep -q "DANGLING" && bad "out-of-library link flagged as dangling" || ok "out-of-library link NOT flagged dangling"

# ============================================================================
hr; echo "SUBTEST 8: code-span and heading-line quoted links are not navigation"
setup_fixture
# A source page mixing a GENUINE dangling prose link with two quotation classes
# that must NOT be flagged: an inline-code span and a ### narrative heading.
cat > "$LIB/sources/q.md" <<'EOF'
# q source

Parent: [parent](missing-parent.md).

The README materializes the pointer as `[docs/x.md](./docs/x.md)` — quoted as code.

### From upstream (Optional: [dep](missing-dep.md) for confinement)
EOF
commit_all "source page with quoted links"
out="$("$CHECK" --library "$LIB" --files sources/q.md 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "the genuine prose link still fails (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .* -> missing-parent.md" && ok "genuine prose parent link IS flagged" || { bad "missed the genuine link"; echo "$out"; }
echo "$out" | grep -q "docs/x.md" && bad "flagged a link quoted in an inline-code span" || ok "code-span quotation not flagged"
echo "$out" | grep -q "missing-dep.md" && bad "flagged a link inside a ### heading" || ok "heading-line quotation not flagged"

# ============================================================================
hr; echo "SUBTEST 9: --nav scans navigation surfaces, not leaf section bodies"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
write_parent_index "$SLUG" core
append_readme_block "$SLUG" core
# Source page links to a MISSING child (a genuine navigation dangling link).
write_source_page "$SLUG" core missingchild
# A leaf section body carrying a dangling UPSTREAM-verbatim relative link that
# --nav must NOT scan (it is a target, not a navigation source).
cat >> "$LIB/sections/${SLUG}--core.md" <<'EOF'

See [upstream errors doc](./errors.md) — verbatim from the source, must be ignored.
EOF
commit_all "cluster with a nav dangling link and a leaf-body upstream link"
out="$("$CHECK" --library "$LIB" --nav 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "--nav flags the navigation dangling link (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .* -> ../sections/${SLUG}--missingchild.md" && ok "source-page missing-child IS flagged under --nav" || { bad "nav missed the source-page link"; echo "$out"; }
echo "$out" | grep -q "errors.md" && bad "--nav scanned a leaf section body" || ok "leaf section body NOT scanned under --nav"

# ============================================================================
hr; echo "SUBTEST 10: --all advisory-only — a dangling leaf-body link does NOT fail the run"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
write_parent_index "$SLUG" core
append_readme_block "$SLUG" core
write_source_page "$SLUG" core        # nav surfaces all resolve
# A leaf section body carrying a dangling UPSTREAM-verbatim link: advisory, not gating.
cat >> "$LIB/sections/${SLUG}--core.md" <<'EOF'

See [upstream errors doc](./errors.md) — verbatim from the source.
EOF
commit_all "clean nav, one dangling leaf-body link"
out="$("$CHECK" --library "$LIB" --all 2>&1)"; rc=$?
if [ "$rc" = 0 ]; then ok "advisory-only --all exits 0"; else bad "expected exit 0, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .*errors.md \[advisory\]" && ok "leaf-body dangling tagged [advisory]" || { bad "leaf-body dangling not tagged advisory"; echo "$out"; }
echo "$out" | grep -q "advisory — 1 dangling" && ok "advisory count reported separately" || { bad "no advisory count"; echo "$out"; }
echo "$out" | grep -q "OK — every must-resolve" && ok "must-resolve OK verdict printed" || { bad "no must-resolve OK verdict"; echo "$out"; }

# ============================================================================
hr; echo "SUBTEST 11: --all must-resolve — a dangling nav link fails (exit 1), advisory reported too"
setup_fixture
SLUG="proj--docs-guide-md"
write_child "$SLUG" core
write_parent_index "$SLUG" core
append_readme_block "$SLUG" core
# Source page (a must-resolve navigation surface) references a MISSING child.
write_source_page "$SLUG" core missingchild
# Plus a dangling advisory leaf-body link.
cat >> "$LIB/sections/${SLUG}--core.md" <<'EOF'

See [upstream errors doc](./errors.md) — verbatim from the source.
EOF
commit_all "nav dangling + leaf-body dangling"
out="$("$CHECK" --library "$LIB" --all 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "must-resolve dangling fails --all (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .*${SLUG}--missingchild.md \[must-resolve\]" && ok "source-page dangling tagged [must-resolve]" || { bad "nav dangling not tagged must-resolve"; echo "$out"; }
echo "$out" | grep -q "FAIL — 1 must-resolve dangling" && ok "must-resolve FAIL count reported" || { bad "no must-resolve FAIL count"; echo "$out"; }
echo "$out" | grep -q "advisory — 1 dangling" && ok "advisory leaf-body still reported separately" || { bad "advisory not reported alongside the failure"; echo "$out"; }

# ============================================================================
hr; echo "SUBTEST 12: a dangling sibling-section link whose real target is the source page gets a 'did you mean' hint"
setup_fixture
# The overview footgun (2026-06-28 KernelQueue.ts): a parent index with a long
# descriptive slug links a source-page slug as if it were a SIBLING section. There
# is NO bare sections/<slug>.md, but sources/<slug>.md IS committed, so the
# suggestion must point at the source page.
SLUG="metamask-ocap-kernel--src-kernelqueue-ts"
cat > "$LIB/sources/${SLUG}.md" <<EOF
---
source: docs/x.md
status: current
---
## Abstract
Overview source page for the ocap-kernel message queue.
EOF
# An overview index whose See-also mis-links the source-page slug as a sibling
# section, plus a genuinely-missing sibling that has NO source page (the control:
# it must dangle WITHOUT a hint, proving the suggestion does not fire on every
# dangling sibling-section link).
cat > "$LIB/sections/overview-of-the-ocap-kernel-message-queue.md" <<EOF
---
title: Overview of the ocap-kernel message queue
kind: index
status: current
---
## See also
- [$SLUG]($SLUG.md)
- [nope](nope-no-source-page.md)
EOF
commit_all "overview index linking the source-page slug as a sibling section"
out="$("$CHECK" --library "$LIB" --files sections/overview-of-the-ocap-kernel-message-queue.md 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "the dangling sibling link fails (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "DANGLING .* -> ${SLUG}.md.*did you mean ../sources/${SLUG}.md?" \
  && ok "source-page 'did you mean' hint fires on the footgun shape" || { bad "no did-you-mean hint on the footgun link"; echo "$out"; }
echo "$out" | grep "nope-no-source-page.md" | grep -q "did you mean" \
  && bad "hint wrongly fired on a dangling sibling link with no source page" \
  || ok "no hint on a legitimate-sibling-shaped dangling link without a source page"

# ============================================================================
hr; echo "SUBTEST 13: --changed does NOT fail on a PRE-EXISTING dangler on an untouched row"
setup_fixture
# Base: a clean cluster PLUS a shared index page (sources/README.md) that already
# carries a long-lived dangling wikilink on a row nobody is about to touch.
SLUG_A="proj-a--docs-guide-md"
write_child "$SLUG_A" core
write_source_page "$SLUG_A" core
write_parent_index "$SLUG_A" core
append_readme_block "$SLUG_A" core
# sources/README.md with a pre-existing dangling [[wikilink]] to a missing concept.
cat > "$LIB/sources/README.md" <<'EOF'
# Sources index

- [[engine-implementation]] — a concept page that does not exist (pre-existing).
EOF
commit_all "base: clean cluster + a pre-existing dangler in sources/README.md"
git "${git_id[@]}" -C "$TR/journal" branch -f base HEAD

# The new ingest: append a NEW source row to sources/README.md (as every ingest
# does) whose target DOES resolve. The pre-existing dangling row is untouched.
write_child "$SLUG_A" api          # extend the touched cluster harmlessly
cat >> "$LIB/sources/README.md" <<'EOF'
- [proj-a](proj-a--docs-guide-md.md) — a freshly-added, resolvable row.
EOF
# Make the appended row's target actually resolve.
cat > "$LIB/sources/proj-a--docs-guide-md.md" <<'EOF'
---
source: docs/x.md
status: current
---
## Abstract
Placeholder.
EOF
commit_all "ingest: append a resolvable row to sources/README.md (dangler untouched)"

out="$("$CHECK" --library "$LIB" --changed base --wikilinks 2>&1)"; rc=$?
if [ "$rc" = 0 ]; then ok "pre-existing dangler does NOT fail the gate (exit 0)"; else bad "expected exit 0, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "pre-existing" && ok "the pre-existing dangler is reported [pre-existing]" || { bad "pre-existing dangler not reported"; echo "$out"; }
echo "$out" | grep -q "advisory — .* pre-existing" && ok "pre-existing advisory count reported in the verdict" || { bad "no pre-existing advisory verdict"; echo "$out"; }

# ============================================================================
hr; echo "SUBTEST 14: --changed STILL fails on a NEWLY-INTRODUCED dangler (absent at base)"
setup_fixture
commit_all "empty base"
git "${git_id[@]}" -C "$TR/journal" branch -f base HEAD
# A brand-new source page with a brand-new dangling wikilink absent at base.
cat > "$LIB/sources/README.md" <<'EOF'
# Sources index

- [[brand-new-missing-concept]] — introduced by THIS change, never existed at base.
EOF
commit_all "ingest introduces a new dangling wikilink"
out="$("$CHECK" --library "$LIB" --changed base --wikilinks 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "newly-introduced dangler fails the gate (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep -q "brand-new-missing-concept" && ok "the new dangler is flagged" || { bad "new dangler not flagged"; echo "$out"; }
echo "$out" | grep "brand-new-missing-concept" | grep -q "pre-existing" && bad "new dangler wrongly tagged pre-existing" || ok "new dangler NOT tagged pre-existing"

# ============================================================================
hr; echo "SUBTEST 15: --changed gates a link whose target EXISTED at base but the change deleted"
setup_fixture
SLUG_D="proj-d--docs-guide-md"
write_child "$SLUG_D" core
write_source_page "$SLUG_D" core
write_parent_index "$SLUG_D" core
append_readme_block "$SLUG_D" core
commit_all "base: cluster whose child resolves"
git "${git_id[@]}" -C "$TR/journal" branch -f base HEAD
# The change DELETES the child that the (still-present) source/parent/README rows
# reference. Same link text as base, but it resolved at base and now dangles ->
# newly-introduced breakage, must gate.
git "${git_id[@]}" -C "$TR/journal" rm -q "library/sections/${SLUG_D}--core.md"
# Touch the source page so the cluster is in the changed set.
printf '\n<!-- touched -->\n' >> "$LIB/sources/${SLUG_D}.md"
commit_all "change deletes a referenced child"
out="$("$CHECK" --library "$LIB" --changed base 2>&1)"; rc=$?
if [ "$rc" = 1 ]; then ok "deleting a base-resolving target fails the gate (exit 1)"; else bad "expected exit 1, got $rc:"; echo "$out"; fi
echo "$out" | grep "${SLUG_D}--core.md" | grep -q "pre-existing" && bad "a base-resolving-now-deleted target wrongly tagged pre-existing" || ok "deleted target NOT tagged pre-existing (gated)"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ] && { rm -rf "$TR"; exit 0; } || exit 1
