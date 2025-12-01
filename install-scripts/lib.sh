#!/bin/bash

# Shared configuration and functions for installation scripts

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$DOTFILES_DIR/install.log"

# Logging
log_info() {
    local msg="[INFO] $1"
    echo -e "${BLUE}${msg}${NC}"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

log_success() {
    local msg="[SUCCESS] $1"
    echo -e "${GREEN}${msg}${NC}"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOG_FILE"
}

log_warning() {
    local msg="[WARNING] $1"
    echo -e "${YELLOW}${msg}${NC}"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$LOG_FILE"
}

log_error() {
    local msg="[ERROR] $1"
    echo -e "${RED}${msg}${NC}" >&2
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

# Utilities
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ensure_dir() {
    if [ ! -d "$1" ]; then
        if [ "$DRY_RUN" = "1" ]; then
            log_info "[DRY-RUN] Would create directory: $1"
        else
            mkdir -p "$1"
            log_info "Created directory: $1"
        fi
    fi
}

execute() {
    local cmd_str="$*"
    if [ "$DRY_RUN" = "1" ]; then
        log_info "[DRY-RUN] Would run: $cmd_str"
        return 0
    else
        log_info "Running: $cmd_str"
        if "$@"; then
            return 0
        else
            log_error "Command failed: $cmd_str"
            return 1
        fi
    fi
}

execute_sudo() {
    local cmd_str="sudo $*"
    if [ "$DRY_RUN" = "1" ]; then
        log_info "[DRY-RUN] Would run: $cmd_str"
        return 0
    else
        log_info "Running (sudo): $*"
        if sudo "$@"; then
            return 0
        else
            log_error "Command failed: $cmd_str"
            return 1
        fi
    fi
}

# Helper to run a command and handle errors
run_step() {
    local step_name="$1"
    shift
    log_info "Running: $step_name"
    if "$@"; then
        log_success "Finished: $step_name"
    else
        log_error "Failed: $step_name"
        return 1
    fi
}
