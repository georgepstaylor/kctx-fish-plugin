function kctx --description "Switch kube context for this shell session only"
    # For each shell session, keep a point in time snapshot of the kube config
    if not set -q _KCTX_SESSION_CONFIG
        set -gx _KCTX_SESSION_CONFIG (mktemp /tmp/kubeconfig-session-XXXXXX)
        # Use KUBECONFIG env var to overwrite the config file location
        set source_config ~/.kube/config
        if set -q KUBECONFIG; and test -f "$KUBECONFIG"
            set source_config $KUBECONFIG
        end
        cp $source_config $_KCTX_SESSION_CONFIG
        set -gx KUBECONFIG $_KCTX_SESSION_CONFIG
        echo "(session-local kubeconfig initialised from $source_config)"
    end

    # Use the first arg or show fzf picker
    if test (count $argv) -gt 0
        set context $argv[1]
    else
        if not command -q fzf
            echo "fzf not found — pass a context name directly, e.g.: kctx my-context (install fzf for search support!)"
            return 1
        end
        set context (kubectl config get-contexts -o name 2>/dev/null \
            | fzf --height=40% --reverse --prompt="kube context> " \
                --preview='bash -c "out=\$(kubectl config view --minify --context={} 2>/dev/null); printf \"Cluster ARN:\\n  \"; echo \"\$out\" | grep -o \"arn:[^ ]*\" | head -1; printf \"\\nAWS Profile:\\n  \"; echo \"\$out\" | grep -A1 AWS_PROFILE | grep value: | sed \"s/.*value: //\"; printf \"\\nNamespace:\\n  \"; echo \"\$out\" | grep namespace: | sed \"s/.*namespace: //\""' \
                --preview-window=right:50%:wrap)
    end

    if test -z "$context"
        echo "No context selected, not setting"
        return 0
    end

    kubectl config use-context $context
end
