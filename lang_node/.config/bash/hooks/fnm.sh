export FNM_DIR="$XDG_DATA_HOME/fnm"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"

# npm XDG Compliance
export npm_config_cache="$XDG_CACHE_HOME/npm"
export npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc"

# Initialize fnm
if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell bash)"
fi