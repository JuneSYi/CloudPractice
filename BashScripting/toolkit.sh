#!/bin/bash

# Description:
# Menu to select which utility should be run

# Usage: ./toolkit.sh

PS3="Which utility do you want to run?: "
select script in "cruft_remover" "folder_organiser"; do
    $HOME/bash_course/scripts/"$script.sh"
    break
done