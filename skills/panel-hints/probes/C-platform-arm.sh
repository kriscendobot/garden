#!/bin/bash
# C-platform-arm — fires coverage-auditor (and engine-realist on xs/endor/hermes or
# native-vs-shim signals) when a change adds or alters a platform-conditional arm.
# Sensing half of the `cross-platform-test-coverage` review-miss cluster (#836,
# #475, #1290). The seats, not the probe, decide whether a test actually runs on
# that platform; see skills/coverage-driven-testing/SKILL.md § Platform-conditional arms.
#
# Signals (any one fires; err toward firing):
#   cond  an added/changed platform condition key in a package.json
#         (`"browser"`, `"xs"`, `"endor"`, `"hermes"`, `"react-native"`, ...)
#   file  an added/changed non-test source whose basename carries a platform
#         token (`sha256-browser.js`, `sha256-endor-async.js`, `foo.xs.js`)
#   stub  an added/changed `test:<platform>` script whose body is a stub
#         (`exit 0`, `true`, `echo ...`)
#   pkg   a touched package whose package.json has a stub `test:xs`/`test:endor`
#         (its tests only ever run on Node) — engine-realist + coverage-auditor
#   shim  an added test line asserting native-vs-shim shape (emulated/shim,
#         `ArrayBuffer.isView`, `sliceToImmutable`, `[object Immutable...]`) —
#         engine-realist
#
# Usage: BASE=<ref> C-platform-arm.sh                  (reads git diff BASE...HEAD)
#        C-platform-arm.sh --diff-stdin [--root DIR]   (unified diff on stdin; the
#          `pkg` signal reads DIR/<pkg>/package.json, else `git show HEAD:`)
set -uo pipefail
BASE=${BASE:-origin/master}
HEAD_REF=${PROBE_HEAD:-HEAD}
FROM_STDIN=false
ROOT=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --diff-stdin) FROM_STDIN=true; shift;;
    --root) ROOT=$2; shift 2;;
    *) shift;;
  esac
done

if $FROM_STDIN; then
  diff=$(cat)
else
  diff=$(git diff "$BASE...$HEAD_REF" -U0 2>/dev/null)
fi

PLAT='browser|xs|endor|hermes|moddable|react-native|deno|bun|worker|workerd|edge-light|electron'
ENGINE='xs|endor|hermes|moddable'

# Walk the diff once: track the current file, collect per-signal hits.
cond="" cond_engine="" file="" file_engine="" stub="" shim="" touched=""
cur=""
while IFS= read -r line; do
  case "$line" in
    '+++ b/'*)
      cur=${line#+++ b/}
      touched+="$cur"$'\n'
      base=${cur##*/}
      case "$cur" in
        *test*|*spec*|*.md|*.d.ts) ;;
        *.js|*.mjs|*.cjs|*.ts|*.mts|*.cts|*.jsx|*.tsx)
          if [[ "$base" =~ (^|[-_.])($PLAT)([-_.]) ]]; then
            [ -z "$file" ] && file="$cur"
            [[ "$base" =~ (^|[-_.])($ENGINE)([-_.]) ]] && [ -z "$file_engine" ] && file_engine="$cur"
          fi;;
      esac
      continue;;
    '+++ '*|'--- '*) continue;;
    +*) ;;
    *) continue;;
  esac
  add=${line#+}
  case "$cur" in
    *package.json)
      if [[ "$add" =~ ^[[:space:]]*\"($PLAT)\"[[:space:]]*: ]]; then
        k=${BASH_REMATCH[1]}
        [ -z "$cond" ] && cond="\"$k\" in $cur"
        [[ "$k" =~ ^($ENGINE)$ ]] && [ -z "$cond_engine" ] && cond_engine="\"$k\" in $cur"
      fi
      if [[ "$add" =~ \"test:($PLAT)\"[[:space:]]*:[[:space:]]*\"(exit[[:space:]]+0|true|:|echo[^\"]*)\" ]]; then
        [ -z "$stub" ] && stub="test:${BASH_REMATCH[1]} stub in $cur"
      fi;;
  esac
  case "$cur" in
    *test*|*spec*)
      if [ -z "$shim" ] && [[ "$add" =~ ([Ee]mulat|[^a-z]shim|[Ss]him[A-Z]|ArrayBuffer\.isView|sliceToImmutable|transferToImmutable|\[object\ Immutable) ]]; then
        shim="${BASH_REMATCH[1]} in $cur"
      fi;;
  esac
done <<< "$diff"

# pkg: a touched packages/<name>/ whose package.json carries a stub test:xs/endor.
pkg=""
for p in $(printf '%s' "$touched" | sed -n 's|^\(packages/[^/]*\)/.*|\1|p' | sort -u); do
  if [ -n "$ROOT" ]; then
    pj=$(cat "$ROOT/$p/package.json" 2>/dev/null)
  else
    pj=$(git show "$HEAD_REF:$p/package.json" 2>/dev/null)
  fi
  if [[ "$pj" =~ \"test:(xs|endor)\"[[:space:]]*:[[:space:]]*\"(exit[[:space:]]+0|true|:|echo[^\"]*)\" ]]; then
    pkg="$p test:${BASH_REMATCH[1]} is a stub (\"${BASH_REMATCH[2]}\"); its tests run only on Node"
    break
  fi
done

cov_reason=""
for r in "cond:$cond" "file:$file" "stub:$stub" "pkg:$pkg"; do
  [ -n "${r#*:}" ] && { cov_reason="platform-arm ${r%%:*}: ${r#*:}"; break; }
done
eng_reason=""
for r in "cond:$cond_engine" "file:$file_engine" "stub:$stub" "pkg:$pkg" "shim:$shim"; do
  [ -n "${r#*:}" ] && { eng_reason="platform-arm ${r%%:*}: ${r#*:}"; break; }
done

if [ -n "$cov_reason" ]; then echo "fire coverage-auditor $cov_reason"; else echo "skip coverage-auditor"; fi
if [ -n "$eng_reason" ]; then echo "fire engine-realist $eng_reason"; else echo "skip engine-realist"; fi
