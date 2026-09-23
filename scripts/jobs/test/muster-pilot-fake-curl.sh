#!/bin/bash
# Fixture for muster-pilot-test.sh. Kept in-repo because /tmp is noexec.
set -euo pipefail
: "${MUSTER_TEST_REQUEST:?}"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --data-binary)
      cp "${2#@}" "$MUSTER_TEST_REQUEST"
      shift 2
      ;;
    *) shift ;;
  esac
done
jq -n '{
  model:"jev-test",
  answers:{
    message_0_compaction:{choice:"keep",confidence:0.91},
    message_0_pattern:{choice:"approval_wait",confidence:0.92},
    message_0_muster_class:{choice:"approval_gated",confidence:0.93},
    message_1_compaction:{choice:"archive_if_verified_handled",confidence:0.81},
    message_1_pattern:{choice:"completion_notice",confidence:0.82},
    message_1_muster_class:{choice:"informational",confidence:0.83}
  },
  usage:{input_tokens:123,output_tokens:45}
}'
