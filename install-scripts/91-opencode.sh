#!/usr/bin/env bash
# OpenCode installation and verification script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

log_info "Setting up OpenCode..."

# Check if opencode is installed
if ! command -v opencode &>/dev/null; then
    log_error "OpenCode not found. Install it first."
    exit 1
fi

log_success "OpenCode found: $(opencode --version 2>/dev/null || echo 'version unknown')"

# Setup zsh completions
COMPLETIONS_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
COMPLETION_FILE="$COMPLETIONS_DIR/_opencode"

if [[ ! -f "$COMPLETION_FILE" ]] || [[ "${1:-}" == "--force" ]]; then
    log_info "Generating OpenCode zsh completions..."
    execute "mkdir -p '$COMPLETIONS_DIR'"
    execute "opencode completion zsh > '$COMPLETION_FILE'"
    log_success "Completions generated at $COMPLETION_FILE"
else
    log_info "Completions already exist (use --force to regenerate)"
fi

# Quick API test (optional, requires API key)
if [[ "${OPENCODE_TEST:-0}" == "1" ]]; then
    log_info "Testing API connectivity with gemini-2.5-flash..."
    if timeout 20 opencode run "say ok" -m google/gemini-2.5-flash 2>&1 | grep -qi "ok"; then
        log_success "API test passed"
    else
        log_error "API test failed"
    fi
fi

log_success "OpenCode setup complete!"
