function param {
    name=$1

    echo "export $name = $(pwd)" >> ~/.profile
}
