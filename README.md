# memegen

An RMagick-based two-caption meme generator.

![Profit](https://github.com/cmdrkeene/memegen/raw/master/example.jpg)

## Install

You'll need [ImageMagick](http://www.imagemagick.org/script/index.php) installed.
The easiest way is to use [Homebrew](https://github.com/mxcl/homebrew).

    brew install imagemagick

## Usage

To see a list of available generators:

    $ memegen --list
    a_dog
    p_obama
    ...
    
To generate an image:

    $ memegen a_dog "Eat Crayons" "Poop Rainbows"
    /tmp/meme-1304797373.jpg
    $ 
    
You only have to supply one piece of text:

    $ memegen a_dog "" "AWESOME"
    /tmp/meme-1304797375.jpg
    $
    
## Adding your own generators

You can add generators to your local `~/.memegen` folder:

    $ ls ~/.memegen
    my_custom_generator.png
    
## Contribute

Feel free to improve this and add your own generator images!
    