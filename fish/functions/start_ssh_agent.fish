function start_ssh_agent -d "Idempotently start ssh-agent"
    # Do nothing if this is a non-interactive shell command being run by, for
    # example, Emacs.
    if not status is-login; or not status is-interactive
        return 0
    end

    function start_new_agent -a agent_info_file -d "Helper function to start a new SSH agent"
        # Tell ssh-agent to generate csh style commands. Apparently those are
        # compatible with Fish.
        eval (ssh-agent -c) >/dev/null

        touch $agent_info_file
        chmod 600 $agent_info_file

        # Save the SSH agent config to be reused by other terminal sessions.
        echo "export SSH_AGENT_PID=$SSH_AGENT_PID" > $agent_info_file
        echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> $agent_info_file

        # Add SSH keys to the agent.
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519 >/dev/null 2>&1
    end


    set -l agent_info_file ~/tmp/ssh_agent_info

    if test -f $agent_info_file
        source $agent_info_file

        # Check if the ssh-agent is alive.
        if not ps -p $SSH_AGENT_PID >/dev/null
            start_new_agent $agent_info_file
        end
    else
        start_new_agent $agent_info_file
    end
end
