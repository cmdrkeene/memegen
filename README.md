# memegen

An RMagick-based two-caption meme generator.

![Profit](https://github.com/cmdrkeene/memegen/raw/master/example.jpg)

## Install

You'll need [ImageMagick](http://www.imagemagick.org/script/index.php) and [ghostscript](http://www.ghostscript.com/) installed.

The easiest way on OSX is to use [Homebrew](https://github.com/mxcl/homebrew).

    brew install ghostscript
    brew install --build-from-source imagemagick

For Ubuntu:

    sudo apt-get install rubygems ghostscript graphicsmagick-libmagick-dev-compat libmagickwand-dev 

Then install the gem for OSX!

    gem install memegen

Or for Ubuntu:
    sudo gem install rails (if you haven't alread)
    sudo gem install memegen    

## Usage

To see a list of available images:

    $ memegen --list
    a_dog
    p_obama
    ...

To generate an image:

    $ memegen a_dog "Eat Crayons" "Poop Rainbows"
    /tmp/meme-1234567890.jpg
    $

You only have to supply one piece of text:

    $ memegen a_dog "" "AWESOME"
    /tmp/meme-1234567890.jpg
    $

You can also use URLs for one time use memes:

    $ memegen http://example.com/stupid.jpg "Generated" "From a URL"
    /tmp/meme-1234567890.jpg
    $

## Adding your own images

You can add images to your local `~/.memegen` folder:

    $ ls ~/.memegen
    my_custom_image.png

## Upload to Campfire

If you have a [Campfire](http://campfirenow.com/) account and token, you can automatically upload your image:

    $ memegen a_dog "Hello" "Campfire world" --campfire

It will prompt you for your subdomain, token, and room name the first time.

## Upload to GroupMe

If you have a [GroupMe](http://groupme.com/) account and token, you can automatically upload your image:

    $ memegen a_dog "Hello" "GroupMe world" --groupme

It will prompt you for your phone number, password, and group id the first time. (your password will NOT be stored in plain text).

## Bash completion

Source or copy `script/autocomplete.sh` inside `~/.bashrc` to get image name autocompletion.

See also:

    memegen --install-autocomplete

## Contribute

Pull requests welcome!
