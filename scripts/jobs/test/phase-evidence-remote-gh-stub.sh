#!/bin/bash
# phase-evidence-remote-gh-stub.sh -- serves a cross-repo design for
# phase-evidence-gate-test.sh: one PR (other/designs#7, head sha 'a'*40) whose
# files include designs/remote.md, readable from $PHASE_STUB_DESIGN.
set -u
[ "${1:-}" = api ] || exit 1
shift
[ "${1:-}" = --paginate ] && shift
sha=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
case "${1:-}" in
  repos/other/designs/pulls/7) echo "$sha" ;;
  repos/other/designs/pulls/7/files) printf '%s\n' designs/README.md designs/remote.md src/x.js ;;
  "repos/other/designs/contents/designs/remote.md?ref=$sha"|"repos/other/designs/contents/designs/remote.md?ref=main")
    cat "$PHASE_STUB_DESIGN" ;;
  *) exit 1 ;;
esac
