#!/bin/bash
# Shared temp-base selection for tests that execute fixtures from their temp tree.

garden_test_exec_tmpdir() {
  local candidate probe

  for candidate in "${GARDEN_TEST_TMPDIR:-}" "${TMPDIR:-}" /var/tmp /tmp "${HOME:?HOME must be set}"; do
    { [ -n "$candidate" ] && [ -d "$candidate" ] && [ -w "$candidate" ]; } || continue
    probe="$(mktemp -d "$candidate/.garden-test-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 0\n' > "$probe/x"
    chmod +x "$probe/x" 2>/dev/null || true
    if [ -x "$probe/x" ] && "$probe/x" 2>/dev/null; then
      rm -rf "$probe"
      printf '%s\n' "$candidate"
      return 0
    fi
    rm -rf "$probe"
  done

  # Preserve run-test.sh's historical last resort. The caller's mktemp will
  # provide the useful failure if even HOME cannot host the test tree.
  printf '%s\n' "$HOME"
}
