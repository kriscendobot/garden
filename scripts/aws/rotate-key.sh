#!/bin/bash
# rotate-key.sh — rotate the garden-fleet IAM access key, links preserved.
#
# Usage: rotate-key.sh
#
# Rotates the single access key for the IAM user garden-fleet using
# create-new-before-delete-old ordering, so a failure at any step leaves a
# working credential in place:
#
#   1. read the currently-active key id (the one to retire) from the creds file;
#   2. create a NEW access key for the user (needs a free key slot; IAM caps a
#      user at two, so this requires the user currently hold exactly one);
#   3. write the new key into $HOME/.aws/credentials IN PLACE (truncate + write,
#      never rename) so the shared inode — and thus every hard-linked checkout —
#      carries the new secret without breaking any link;
#   4. relink-aws-creds.sh to repair any link that had drifted;
#   5. verify with `sts get-caller-identity` (retried for IAM eventual
#      consistency), asserting the identity is user/garden-fleet;
#   6. ONLY on a clean verify, delete the OLD key.
#
# On any failure after the new key is written, the original credential file is
# restored in place and the freshly-created key is deleted, so the rotation is
# all-or-nothing.
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

IAM_USER="${GARDEN_AWS_IAM_USER:-garden-fleet}"
AWS_SOURCE_DIR="${AWS_SOURCE_DIR:-$HOME/.aws}"
CREDS="$AWS_SOURCE_DIR/credentials"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v aws >/dev/null 2>&1 || { echo "rotate-key: aws not on PATH (install-aws-cli.sh)" >&2; exit 1; }
[ -f "$CREDS" ] || { echo "rotate-key: no credential file at $CREDS" >&2; exit 1; }

# The key we intend to retire is whatever is active in the creds file right now.
OLD_KEY="$(aws configure get aws_access_key_id 2>/dev/null || true)"
[ -n "$OLD_KEY" ] || { echo "rotate-key: could not read current aws_access_key_id" >&2; exit 1; }

# Confirm the active credential works and is the user we expect before we touch
# anything.
who="$(aws sts get-caller-identity --query Arn --output text)"
case "$who" in
  *":user/$IAM_USER") : ;;
  *) echo "rotate-key: refusing to rotate; active identity is '$who', not user/$IAM_USER" >&2; exit 1 ;;
esac

# IAM allows at most two access keys per user; create-before-delete needs a free
# slot, so the user must hold exactly one key (the active one) going in.
key_count="$(aws iam list-access-keys --user-name "$IAM_USER" \
  --query 'length(AccessKeyMetadata)' --output text)"
if [ "$key_count" != "1" ]; then
  echo "rotate-key: user $IAM_USER has $key_count keys; expected 1." >&2
  echo "            IAM caps a user at two keys, so rotation needs a free slot." >&2
  echo "            Delete the unused key first, then re-run." >&2
  exit 1
fi

# Back up the current credential contents so we can restore in place on failure.
backup="$(mktemp)"
chmod 600 "$backup"
cat "$CREDS" >"$backup"

echo "rotate-key: creating a new access key for $IAM_USER ..."
created="$(aws iam create-access-key --user-name "$IAM_USER" \
  --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text)" \
  || { echo "rotate-key: create-access-key failed" >&2; rm -f "$backup"; exit 1; }
read -r NEW_ID NEW_SECRET <<<"$created"
if [ -z "$NEW_ID" ] || [ -z "$NEW_SECRET" ]; then
  echo "rotate-key: create-access-key returned no key" >&2; rm -f "$backup"; exit 1
fi

rollback() {
  echo "rotate-key: rolling back — restoring the previous credential and deleting the new key" >&2
  cat "$backup" >"$CREDS"           # in-place restore preserves the shared inode
  "$HERE/relink-aws-creds.sh" >/dev/null 2>&1 || true
  aws iam delete-access-key --user-name "$IAM_USER" --access-key-id "$NEW_ID" >/dev/null 2>&1 || true
  rm -f "$backup"
}

# Truncate-and-write (the '>' redirect) keeps the same inode, so every hard link
# in every checkout root sees the new secret. A rename would unshare the inode.
{
  printf '[default]\n'
  printf 'aws_access_key_id = %s\n' "$NEW_ID"
  printf 'aws_secret_access_key = %s\n' "$NEW_SECRET"
} >"$CREDS"
chmod 600 "$CREDS"

"$HERE/relink-aws-creds.sh" || { rollback; exit 1; }

# The new key is eventually consistent; give it a few tries before declaring failure.
echo "rotate-key: verifying the new key ..."
ok=""
for _ in 1 2 3 4 5 6; do
  arn="$(aws sts get-caller-identity --query Arn --output text 2>/dev/null || true)"
  case "$arn" in
    *":user/$IAM_USER") ok="$arn"; break ;;
  esac
  sleep 5
done
if [ -z "$ok" ]; then
  echo "rotate-key: new key did not verify as user/$IAM_USER" >&2
  rollback
  exit 1
fi
echo "rotate-key: verified as $ok"

echo "rotate-key: deleting the old key $OLD_KEY ..."
aws iam delete-access-key --user-name "$IAM_USER" --access-key-id "$OLD_KEY"

rm -f "$backup"
echo "rotate-key: done — active key is now $NEW_ID"
