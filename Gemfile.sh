
function gem_install() {
    if `gem specification $1 > /dev/null 2>&1`; then
        echo $1 has already installed.
    else
        gem install $1
    fi
}

gem_install "rubygems-update"

gem_install "bundler"

gem_install "pry"
gem_install "pry-doc"

gem_install "homesick"
