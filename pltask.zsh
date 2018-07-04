#pltask functions
## pltask is a lightweight facade to taskwarrior for use with Powerlevel9k's Second Prompt Prefix (by dmidlo @querentCode)
## Be sure to set search.case.sensitive=no within .taskrc
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\n"

pltask () {
    setNewlinePrompt () {
        POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="%K{white}%F{black}\n $1 %f%k%F{white}%f $ "
    }

    if [ -n "$3" ]; then
        echo "pltask only supports two args. did\nyou remember to use quotes when\ncreating a task?"
        return 1
    elif [ -z "$1" ]; then
        export PLTASK=`task _get 1.description`
        if [ -z "$PLTASK" ]; then
            echo "no tasks in queue, go do something else"
            echo "Setting pltask to '.' "
            setNewlinePrompt "."
        else
            echo "Setting pltask to first task from taskwarrior:" $PLTASK
            setNewlinePrompt $PLTASK
        fi
    elif [[ $1 = "_print" || $1 = "_p" ]]; then
         echo $PLTASK
    elif [[ $1 = "help" || $1 = "h" ]]; then
        echo "\n pltask is a lightweight facade to taskwarrior for use with Powerlevel9k's Second Prompt Prefix\n"
        echo   Options:
        echo -----------------------------------------------------------------------------
        echo   "  No args           ---   Calls first available task from taskwarrior."
        echo   "  help              ---   h - This help dialog."
        echo   "  list              ---   ls - A Wrapper for \'task next\'."
        echo   "  set  <taskID>     ---   s - Sets the pltask prompt to description of specified task id."
        echo   "  done              ---   d - Completes the current task and sets pltask to next task."
        echo   "  \"string\"          ---       \"string\" with no additional arguments, sets the pltask prompt but no new task."
        echo   "  \"string\" add      ---   a - \"string\" followed by 'add' will set the pltask and add a new task to taskwarrior.\n\n"
        echo   Examples:
        echo "-----------------------------------------------------------------------------\n"
        echo "   Create a task:"
        echo "      $ pltask \"Edit Super Cool Project\" add"
        echo "      $ pltask \"Write Blog Post\" a"
    elif [[ $1 = "list" || $1 = "ls" ]]; then
        task next
    elif [[ $1 = "set" || $1 = "s" ]]; then
        export PLTASK=`task _get $2.description`
        if [ -z "$PLTASK" ]; then
            export PLTASK=`task _get 1.description`
            if [ -z "$PLTASK" ]; then
                pltask
            else
                echo "no task with id $2 in queue"
                echo "Setting pltask to first available task: " $PLTASK
                setNewlinePrompt $PLTASK
            fi
        else
            echo "Setting pltask to task id $2:" $PLTASK
            setNewlinePrompt $PLTASK
        fi
    elif [[ $1 = "done" || $1 = "d" ]]; then
        task /$PLTASK/ done
        task
        export PLTASK=`task _get 1.description`
        if [ -z "$PLTASK" ]; then
                pltask
        else
            echo "Setting pltask to next task: "$PLTASK
            setNewlinePrompt $PLTASK
        fi
    elif [ -z "$2" ]; then
        setNewlinePrompt $1
        echo "terminal pltask set to " $1 "But no task has been created"
    elif [[ $2 = "add" || $2 = "a" ]]; then
        export PLTASK="$1"
        task "$1" add
        task
        setNewlinePrompt $1
    fi
}
# Initial state
pltask "."
