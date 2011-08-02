# memegen

An RMagick-based two-caption meme generator.

![Profit](https://github.com/cmdrkeene/memegen/raw/master/example.jpg)

## Install

You'll need [ImageMagick](http://www.imagemagick.org/script/index.php) installed.
The easiest way is to use [Homebrew](https://github.com/mxcl/homebrew).

    brew install imagemagick
    
Then install the gem!

    gem install memegen

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

## Upload to Cloudapp

If you have [Zach Holman](https://github.com/holman/)'s [Cloudapp
script](https://github.com/holman/dotfiles/blob/master/bin/cloudapp), you can
automatically upload your image to your Cloudapp account:

   $ memegen y_u_no "WHY U NO" "USE CLOUDAPP" --cloudapp
   Uploaded to http://cl.ly/3U2I3R2Z1X1I0q303N0I. 

You'll have to configure `~/.cloudapp` first.

## Bash completion

Source or copy `script/autocomplete.sh` inside `~/.bashrc` to get image name autocompletion.

See also:

    memegen --install-autocomplete

## Contribute

Pull requests welcome!
