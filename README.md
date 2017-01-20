# imagesite

OS X's iPhoto software had a feature that exported photos to a static web site.
iPhoto was discontinued in 2015. Its replacement, Photos, does not have that
feature. imagesite approximates that feature.

imagesite HTML is similar, but not identical, to iPhoto's.
imagesite's HTML is amateurishly styled, although somewhat less so than iPhoto's.
On the bright side, imagesite's output includes an image's tags as well as 
its title and description.

## Requirements

imagesite works with Ruby 2.0.0p648, which comes with OS X 10.11 (El Capitan), 
and with later versions of Ruby.
If your Mac has an older OS X, imagesite may or may not work with its built-in Ruby.
If not, you may be able to install a newer Ruby on your Mac to use with imagesite.

## Installation

- Install [FreeImage](http://freeimage.sourceforge.net/).
  The easiest way to do that is probably with [homebrew](http://brew.sh/) or 
  [MacPorts](https://www.macports.org/).
- If you're using the Ruby that comes with OS X,

      $ sudo gem install imagesite

    If you're using a Ruby that you installed yourself, `sudo` may or may not be appropriate.

## Usage

- Edit and annotate your images in Photos as usual.
- Export your images from Photos (select them and choose
  File ▶ Export ▶ Export Photos…, or type ⇧⌘E).
- Run imagesite in Terminal:

      $ imagesite -t 'Images' -o ~/Desktop/images ~/Desktop/images-export/*
    
  Replace `'Images'` with whatever you'd like the title of the image set to be,
  `~/Desktop/images` with whatever you'd like the output directory to be, and
  `~/Desktop/images-export` with the directory into which you exported your
  images from Photos.
  
imagesite puts photos in its output in the order in which they're given to it
on the command line. Unix, unlike Finder, sorts files whose names begin with
numbers (such as those created by Photos' Sequential filename export option)
in a way that requires leading zeros. You may, therefore, need to add
leading zeros to your exported image filenames for `*` to list them in the order
you want.

### Customizing the output

Run `imagesite -h` to see more options.
  
imagesite's HTML is largely determined by two template files. To change them,
run the following command to see where they are

    $ gem contents imagesite
    
and edit them to your liking.

## License

imagesite is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
