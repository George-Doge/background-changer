#! /bin/bash

_current_background=$(gsettings get org.cinnamon.desktop.background picture-uri)
_current_background_index=-1

# this is in order to sanitize the output
_current_background=${_current_background//\'/}

_user_name=$(whoami)
_path_to_backgrounds="/home/$_user_name/wallpapers/"

_backgrounds_array=()
_backgrounds_array_length=${#_backgrounds_array[@]} # should set it to 0 if it is empty

# all background paths are saved into an array
load_backgrounds() {
    for background in "$_path_to_backgrounds"/*; do
        [[ -e "$background" ]] || continue  # breaks the 'loading' if the path is invalid
        _backgrounds_array+=("file://$background")
    done
    _backgrounds_array_length=${#_backgrounds_array[@]}
    # echo "Array length $_backgrounds_array_length"
}

# current background index is figured out
index_background() {
    echo "All backgrounds:"
    for i in ${!_backgrounds_array[@]}; do
        echo ${_backgrounds_array[$i]}
        if [[ ${_backgrounds_array[$i]} == $_current_background ]]; then
            _current_background_index=$i
        fi
    done
}

change_background() {
    if (( _current_background_index < (--_backgrounds_array_length) )); then
        ((_current_background_index++))
        gsettings set org.cinnamon.desktop.background picture-uri "${_backgrounds_array[$_current_background_index]}"
    else
        gsettings set org.cinnamon.desktop.background picture-uri "${_backgrounds_array[0]}"
    fi
    echo "Background changed!"
}

echo "Current background path: $_current_background"
load_backgrounds

if (( $_backgrounds_array_length >= 1 )); then
    index_background
    change_background
else
    echo "Error, Invalid path or designated folder is empty! Keeping the old background."
fi