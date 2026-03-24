#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

PATTERN='(sk_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]+|ghp_[A-Za-z0-9]+|AIza[0-9A-Za-z\-_]{20,}|xox[baprs]-[A-Za-z0-9-]+|-----BEGIN (RSA|OPENSSH|EC|DSA)? ?PRIVATE KEY-----|GITHUB_TOKEN|ELEVENLABS_API_KEY|OPENAI_API_KEY)'

IGNORE_REGEX='^(scripts/scan-secrets.sh|scripts/install-git-hooks.sh|\.gitignore)$'

echo "Running secret scan in $ROOT"

FOUND=0
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  if [[ "$file" =~ $IGNORE_REGEX ]]; then
    continue
  fi
  if grep -nIE "$PATTERN" "$file"; then
    FOUND=1
  fi
done < <(git ls-files)

if [[ $FOUND -eq 1 ]]; then
  echo
  echo "Secret scan FAILED."
  echo "Something key-like or token-like was found in tracked files. Review before committing/pushing."
  exit 1
fi

echo "Secret scan passed."
