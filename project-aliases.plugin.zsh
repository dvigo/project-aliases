# project-aliases - Zsh plugin to auto-load and clean project-specific aliases from .proj_aliases, keeping your shell organized and project-ready.
# Copyright (C) 2025 David Vigo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# ===========================
#  Project Aliases Plugin
# ===========================
# Loads aliases defined in .proj_aliases of each project when entering its folder.
# Cleans previous aliases when leaving the project.
# ===========================

CURRENT_PROJECT=""
PROJECT_ALIASES_LIST=()

# Find project root (contains .proj_aliases or .git)
function find_project_root() {
    local dir="$1"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.proj_aliases" || -d "$dir/.git" ]]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
    echo ""
}

# Remove aliases from previous project
function unset_project_aliases() {
    for alias_name in "${PROJECT_ALIASES_LIST[@]}"; do
        unalias "$alias_name" 2>/dev/null
    done
    PROJECT_ALIASES_LIST=()
}

# Load aliases from a file and store names
function load_project_aliases_file() {
    local file="$1"
    # Extract alias names from the file
    local names=($(grep -oE '^alias[[:space:]]+[a-zA-Z0-9_-]+' "$file" | awk '{print $2}'))
    
    # Source the file to define the aliases
    source "$file"

    # Store names in PROJECT_ALIASES_LIST
    for name in "${names[@]}"; do
        PROJECT_ALIASES_LIST+=("$name")
    done
}

# Load aliases for the current project
function load_project_aliases() {
    local dir=$(pwd)
    local root=$(find_project_root "$dir")

    # Not in any project -> clean aliases
    if [[ -z "$root" ]]; then
        if [[ -n "$CURRENT_PROJECT" ]]; then
            unset_project_aliases
            CURRENT_PROJECT=""
            echo "[project-aliases] Project aliases removed."
        fi
        return
    fi

    # Changed project -> clean and reload
    if [[ "$root" != "$CURRENT_PROJECT" ]]; then
        unset_project_aliases
        CURRENT_PROJECT="$root"
        if [[ -f "$root/.proj_aliases" ]]; then
            load_project_aliases_file "$root/.proj_aliases"
            echo "[project-aliases] Aliases loaded from $root/.proj_aliases"
        fi
    fi
}

# Command to list, edit, or reload aliases
function palias() {
    case "$1" in
        list)
            if [[ ${#PROJECT_ALIASES_LIST[@]} -eq 0 ]]; then
                echo "No active project aliases."
            else
                echo "Active project aliases:"
                for name in "${PROJECT_ALIASES_LIST[@]}"; do
                    alias "$name"
                done
            fi
            ;;
        edit)
            if [[ -n "$CURRENT_PROJECT" && -f "$CURRENT_PROJECT/.proj_aliases" ]]; then
                ${EDITOR:-nano} "$CURRENT_PROJECT/.proj_aliases"
            else
                echo "No .proj_aliases file found in the current project."
            fi
            ;;
        reload)
            if [[ -n "$CURRENT_PROJECT" && -f "$CURRENT_PROJECT/.proj_aliases" ]]; then
                unset_project_aliases
                load_project_aliases_file "$CURRENT_PROJECT/.proj_aliases"
                echo "[project-aliases] Aliases reloaded from $CURRENT_PROJECT/.proj_aliases"
            else
                echo "[project-aliases] No active project or missing .proj_aliases file."
            fi
            ;;
        *)
            echo "Usage: palias [list|edit|reload]"
            ;;
    esac
}

# Hook when changing directory
autoload -U add-zsh-hook
add-zsh-hook chpwd load_project_aliases

# Initial load
load_project_aliases
