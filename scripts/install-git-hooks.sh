#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
HOOKS_DIR="$ROOT/.git/hooks"
mkdir -p "$HOOKS_DIR"

cat > "$HOOKS_DIR/pre-commit" <<'HOOK'
#!/usr/bin/env bash
"$(git rev-parse --show-toplevel)/scripts/scan-secrets.sh"
HOOK

cat > "$HOOKS_DIR/pre-push" <<'HOOK'
#!/usr/bin/env bash
"$(git rev-parse --show-toplevel)/scripts/scan-secrets.sh"
HOOK

chmod +x "$HOOKS_DIR/pre-commit" "$HOOKS_DIR/pre-push" "$ROOT/scripts/scan-secrets.sh"

echo "Installed pre-commit and pre-push secret scan hooks."
