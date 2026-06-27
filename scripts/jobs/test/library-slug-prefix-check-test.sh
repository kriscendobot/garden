#!/bin/bash
# library-slug-prefix-check-test.sh — coverage for the source-slug prefix-
# divergence check (library-slug-prefix-check.sh).
#
# Regression for the erights.org churn: a scholar landed a new erights.org source
# under slug prefix `erights-org--` while the sibling corpus already used
# `erights--`, then had to re-land + `status: superseded` the divergent files. The
# check must catch a divergent prefix BEFORE it lands, naming the canonical sibling
# prefix, so the reland+supersede cycle never starts.
#
# Hermetic: a throwaway git repo stands in for the journal worktree with a tiny
# library/sources fixture. No real journal, no network.
#
# Usage: library-slug-prefix-check-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
CHECK="$JOBS/library-slug-prefix-check.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-slug-prefix-test
rm -rf "$TR"; mkdir -p "$TR"
LIB="$TR/journal/library"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- fixture -----------------------------------------------------------------
# Two erights.org thematic prefixes (erights--, web--), one endojs/endo repo
# prefix (endo--), and a paper row (author cell, no host — must be ignored).
mkdir -p "$LIB/sources"
write_readme() {
  cat > "$LIB/sources/README.md" <<'EOF'
# Sources

## Web sources

| Source | URL | Sections | Status |
|--------|-----|----------|--------|
| [E index](erights--elang-index.md) | https://erights.org/elang/index.html | 1 | current |
| [E intro](erights--elang-intro.md) | https://erights.org/elang/intro/index.html | 1 | current |
| [grant matcher](web--miller-grant-matcher.md) | https://erights.org/elib/equality/grant-matcher/index.html | 6 | current |
| [object sameness](web--miller-object-sameness.md) | https://erights.org/elib/equality/same-object.html | 1 | current |

## Repo sources

| Source | Repo | File | Sections | Status |
|--------|------|------|----------|--------|
| [handled-promise](endo--packages-eventual-send.md) | endojs/endo | packages/eventual-send/x.js | 3 | current |

## Papers

| Source | Author | Year | Venue | Sections | Status |
|--------|--------|------|-------|----------|--------|
| [paradigm regained](papers--miller-shapiro-2003.md) | Miller, Shapiro | 2003 | ASIAN | 4 | current |
EOF
}
write_readme

init_git() {
  git -C "$TR/journal" init -q 2>/dev/null || true
  ( cd "$TR/journal" && git checkout -q -b journal2 2>/dev/null || true )
  git -C "$TR/journal" add -A
  git -C "$TR/journal" "${git_id[@]}" commit -q -m base
}

hr; echo "library-slug-prefix-check tests"; hr

# --- 1. divergent prefix on a known host FAILS, naming the canonical sibling --
out="$("$CHECK" --propose erights-org--elang-foo --host erights.org --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 1 ] \
    && grep -q "DIVERGENCE" <<<"$out" \
    && grep -q "Canonical sibling prefix: 'erights'" <<<"$out"; } \
  && ok "divergent erights-org-- fails (exit 1), names canonical 'erights'" \
  || bad "divergent erights-org-- not caught (rc=$rc): $out"

# --- 2. a matching established prefix passes ---------------------------------
out="$("$CHECK" --propose erights--elang-bar --host erights.org --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 0 ] && grep -q "matches an established prefix" <<<"$out"; } \
  && ok "matching erights-- passes (exit 0)" \
  || bad "matching erights-- wrongly failed (rc=$rc): $out"

# --- 3. the OTHER established prefix on the same host also passes ------------
out="$("$CHECK" --propose web--something-new --host erights.org --library "$LIB" 2>&1)"; rc=$?
[ "$rc" = 0 ] \
  && ok "second established prefix web-- on same host passes (exit 0)" \
  || bad "web-- on erights.org wrongly failed (rc=$rc): $out"

# --- 4. a brand-new host cannot diverge -------------------------------------
out="$("$CHECK" --propose anything--goes --host example.invalid --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 0 ] && grep -q "new host" <<<"$out"; } \
  && ok "new host passes (nothing to diverge from)" \
  || bad "new host wrongly failed (rc=$rc): $out"

# --- 5. --allow-new-prefix downgrades a divergence to a warning (exit 0) -----
out="$("$CHECK" --propose erights-org--elang-foo --host erights.org --allow-new-prefix --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 0 ] && grep -q "WARN" <<<"$out" && grep -q "DIVERGENCE" <<<"$out"; } \
  && ok "--allow-new-prefix downgrades divergence to WARN (exit 0)" \
  || bad "--allow-new-prefix did not downgrade (rc=$rc): $out"

# --- 6. divergent repo prefix on an owner/name host fails --------------------
out="$("$CHECK" --propose endojs--packages-foo --host endojs/endo --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 1 ] && grep -q "Canonical sibling prefix: 'endo'" <<<"$out"; } \
  && ok "divergent repo prefix endojs-- fails, names canonical 'endo'" \
  || bad "repo-host divergence not caught (rc=$rc): $out"

# --- 7. URL-derived host (no --host) matches the same siblings --------------
out="$("$CHECK" --propose erights-org--x --url https://erights.org/elang/foo.html --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 1 ] && grep -q "host 'erights.org'" <<<"$out"; } \
  && ok "--url derives host erights.org and detects divergence" \
  || bad "--url host derivation failed (rc=$rc): $out"

# --- 8. host derived from the slug's OWN row in the README ------------------
# Append a row for the proposed slug, then check without --host/--url.
cat >> "$LIB/sources/README.md" <<'EOF'
| [diverge me](erights-org--elang-self.md) | https://erights.org/elang/self.html | 1 | current |
EOF
out="$("$CHECK" --propose erights-org--elang-self --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 1 ] && grep -q "host 'erights.org'" <<<"$out"; } \
  && ok "host derived from the slug's own README row; self-row excluded from siblings" \
  || bad "README-row host derivation failed (rc=$rc): $out"
write_readme   # restore the clean fixture

# --- 9. --changed gates only the NEW rows against the base corpus ------------
init_git
# Add a divergent row to the working tree (uncommitted).
cat >> "$LIB/sources/README.md" <<'EOF'
| [new diverge](erights-org--elang-new.md) | https://erights.org/elang/new.html | 1 | current |
EOF
out="$("$CHECK" --changed journal2 --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 1 ] && grep -q "erights-org--elang-new" <<<"$out"; } \
  && ok "--changed flags the new divergent row against the committed base" \
  || bad "--changed did not flag the new row (rc=$rc): $out"

# A new row with an established prefix passes --changed.
write_readme
cat >> "$LIB/sources/README.md" <<'EOF'
| [new ok](erights--elang-new-ok.md) | https://erights.org/elang/ok.html | 1 | current |
EOF
out="$("$CHECK" --changed journal2 --library "$LIB" 2>&1)"; rc=$?
[ "$rc" = 0 ] \
  && ok "--changed passes a new row that reuses an established prefix" \
  || bad "--changed wrongly failed a conforming new row (rc=$rc): $out"
write_readme

# --- 10. --audit flags a singleton beside an established prefix --------------
# Add a third erights.org prefix used exactly once.
cat >> "$LIB/sources/README.md" <<'EOF'
| [lone cluster](ocap-history--survey.md) | https://erights.org/elang/index.html | 1 | current |
EOF
out="$("$CHECK" --audit --quiet --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 1 ] && grep -q "SUSPECT" <<<"$out" && grep -q "ocap-history" <<<"$out"; } \
  && ok "--audit flags the singleton ocap-history beside established erights/web" \
  || bad "--audit did not flag the singleton (rc=$rc): $out"
write_readme

# --- 11. paper rows (author cell, no host) are ignored, not misparsed --------
out="$("$CHECK" --audit --library "$LIB" 2>&1)"; rc=$?
{ [ "$rc" = 0 ] && ! grep -qi "Miller" <<<"$out" && ! grep -qi "papers" <<<"$out"; } \
  && ok "paper rows (no host) are skipped by the parser" \
  || bad "paper row leaked into the host map (rc=$rc): $out"

hr
echo "library-slug-prefix-check: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" = 0 ]
