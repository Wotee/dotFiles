purple="%F{93}"        # #9300c0
pink="%F{218}"         # #F5C2E7
lavender="%F{141}"     # #B4BEFE
reset="%f"

# --- Left prompt ---
PROMPT="${purple}λ ${reset}"

# --- Git prompt configuration ---
# Branch name
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Icons for various states
ZSH_THEME_GIT_PROMPT_STAGED="+"       # staged changes
ZSH_THEME_GIT_PROMPT_UNSTAGED="~"     # modified
ZSH_THEME_GIT_PROMPT_UNTRACKED="-"    # deleted/untracked

# Git action icons (from your JSON)
ZSH_THEME_GIT_PROMPT_CHERRY_PICK="\ue29b "   # cherry-pick
ZSH_THEME_GIT_PROMPT_COMMIT="\uf417 "        # commit
ZSH_THEME_GIT_PROMPT_MERGING="\ue727 "       # merge
ZSH_THEME_GIT_PROMPT_REBASING="\ue728 "      # rebase
ZSH_THEME_GIT_PROMPT_REVERTING="\uf0e2 "     # revert
ZSH_THEME_GIT_PROMPT_TAG="\uf412 "           # tag
ZSH_THEME_GIT_PROMPT_NO_COMMITS="\uf0c3 "    # no commits

# Upstream / ahead / behind
ZSH_THEME_GIT_PROMPT_AHEAD=" ↑"
ZSH_THEME_GIT_PROMPT_BEHIND=" ↓"
ZSH_THEME_GIT_PROMPT_DIVERGED=" ↑↓"
ZSH_THEME_GIT_PROMPT_CLEAN=" ≡"

# --- Right prompt ---
# %~ → folder (like {{ .Folder }})
# $(git_prompt_info) → branch name
# $(git_prompt_status) → ahead/behind + file changes
RPROMPT="${pink}%~${reset}${lavender}\$(git_prompt_info)\$(git_prompt_status)${reset}"

