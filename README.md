# Important!

This project is now maintained at:
https://github.com/kdltr/soil-egg

# soil

[SOIL](http://www.lonesock.net/soil.html) bindings for Chicken.

The source is available on [GitHub](https://github.com/dleslie/soil-egg)

The interface adheres closely to the stock SOIL interface.

soil is known to work on Linux, Mac OS X, Windows, and with OpenGL ES. soil will automatically compile with ES support on ARM hardware, or when `gles` is defined during compilation (e.g. `chicken-install -D gles`).

Much thanks to Jonathan Dummer for writing the original SOIL library.

## SOIL Overview

[SOIL](http://www.lonesock.net/soil.html) is a tiny C library for uploading images as textures into OpenGL. Also, saving and loading of images is supported.

SOIL uses [Sean's Tool Box](http://www.nothings.org/) image loader as a base, upgrading it to load TGA and DDS files, and adds a direct path for loading DDS files straight into OpenGL textures, when applicable.

The following image formats are supported:

- BMP: load and save
- TGA: load and save
- DDS: load and save
- PNG: load
- JPG: load

OpenGL Texture Features:

- resample to power-of-two sizes
- MIPmap generation
- compressed texture S3TC formats (if supported)
- can pre-multiply alpha for you, for better compositing
- can flip image about the y-axis (except pre-compressed DDS files)

## Reference

### Functions

    [procedure] (load-ogl-texture filename force-channels texture-id texture-flags)

Loads an image from disk into an OpenGL texture.

- `filename`: Name of the file to load
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (load-ogl-cubemap xpos-file xneg-file ypos-file yneg-file zpos-file zneg-file force-channels texture-id texture-flags)

Loads a cubemap texture from disc.

- `xpos-file`: File to load for the +x cube face
- `xneg-file`: File to load for the -x cube face
- `ypos-file`: File to load for the +y cube face
- `yneg-file`: File to load for the -y cube face
- `zpos-file`: File to load for the +z cube face
- `zneg-file`: File to load for the -z cube face
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (load-ogl-single-cubemap filename face-order force-channels texture-id texture-flags)

Loads a single image from disc and splits it into an OpenGL cubemap texture.

- `filename`: File to load and split into the texture
- `face-order`: The order of the faces in the file, any permutation of `"NSWEUD"` representing North, South, West, East, Up, Down
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (load-ogl-hdr-texture filename hdr-format rescale-to-max texture-id texture-flags)

Loads an HDR image from disk into an OpenGL texture.

- `filename`: File to load and split into the texture
- `hdr-format`: One of the `fake-hdr/***` flags, i.e., `fake-hdr/rgbe`
- `rescale-to-max`: If true, rescales the image to max
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (load-ogl-texture-from-memory buffer length force-channels texture-id texture-flags)

Loads an image from memory into an OpenGL texture.

- `buffer`: The blob from which the image should be loaded
- `length`: The length, in bytes, to read from the blob
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (load-ogl-cubemap-from-memory xpos-buffer xpos-length xneg-buffer xneg-length ypos-buffer ypos-length yneg-buffer yneg-length zpos-buffer zpos-length zneg-buffer zneg-length force-channels texture-id texture-flags)

Loads a cubemap texture from memory.

- `xpos-buffer`: Buffer to load for the +x cube face
- `xpos-length`: Size, in bytes, to read from xpos-buffer
- `xneg-buffer`: Buffer to load for the -x cube face
- `xneg-length`: Size, in bytes, to read from xneg-buffer
- `ypos-buffer`: Buffer to load for the +y cube face
- `ypos-length`: Size, in bytes, to read from ypos-buffer
- `yneg-buffer`: Buffer to load for the -y cube face
- `yneg-length`: Size, in bytes, to read from yneg-buffer
- `zpos-buffer`: Buffer to load for the +z cube face
- `zpos-length`: Size, in bytes, to read from zpos-buffer
- `zneg-buffer`: Buffer to load for the -z cube face
- `zneg-length`: Size, in bytes, to read from zneg-buffer
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (load-ogl-single-cubemap-from-memory buffer length order force-channels texture-id texture-flags)

Loads a single image from memory and splits it into an OpenGL cubemap texture.

- `buffer`: Blob to load and split into the texture
- `length`: Size, in bytes, to read from the blob
- `face-order`: The order of the faces in the file, any permutation of `"NSWEUD"` representing North, South, West, East, Up, Down
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (create-ogl-texture data width height force-channels texture-id texture-flags)

Creates a 2D OpenGL texture from raw image data. The raw data is not freed after being uploaded. (And it is thus safe to use a blob).

- `data`: Blob to upload as an OpenGL texture
- `width`: The width of the image in pixels
- `height`: The height of the image in pixels
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (create-ogl-single-cubemap data width height force-channels order texture-id texture-flags)

- `data`: Blob to upload as an OpenGL texture
- `width`: The width of the image in pixels
- `height`: The height of the image in pixels
- `face-order`: The order of the faces in the file, any permutation of `"NSWEUD"` representing North, South, West, East, Up, Down
- `force-channels`: Format of image channels to force, see below definitions for appropriate values
- `texture-id`: Use either `texture-id/create-new-id` or use an existing texture id to overwrite an existing texture
- `texture-flags`: See below for appropriate `texture/***` flags to use, i.e., `texture/repeats` or `texture/mipmaps`. Flags are bitwise, and can be combined with `bitwise-ior`

Returns an OpenGL texture ID.

    [procedure] (save-screenshot filename save-type x y width height)

Captures the OpenGL window (RGB) and saves it to disk.

- `filename`: The file to save the image to
- `save-type`: The format to save the image in, one of save-type/*
- `x`: Start x position
- `y`: Start y position
- `width`: Width of image
- `height`: Height of image

Returns `#t` if successful.

    [procedure] (last-result)

Returns the last error message as a string.

    [procedure] (ogl-texture-width texture)
    [procedure] (ogl-texture-height texture)

Returns the width and height of the given OpenGL texture.


### Flags

#### Image Loading

These flags affect the format of images that are loaded.

    [constant] force-channels/auto

Leaves the image in whatever format it was found.

    [constant] force-channels/luminous

Forces the image to load as Luminous (greyscale).

    [constant] force-channels/luminous-alpha

Forces the image to load as Luminous with Alpha.

    [constant] force-channels/rgb

Forces the image to load as Red Green Blue.

    [constant] force-channels/rgba

Forces the image to load as Red Green Blue Alpha.

#### Texture Creation

    [constant] texture-id/create-new-id

Passed in as the `texture-id` argument, this will cause soil to register a new texture ID using `gl:gen-textures`. If the value passed as a `texture-id` argument is greater than zero, then soil will just reuse that texture ID (great for reloading image assets in-game).

#### OpenGL Texture Format
If multiple `texture/***` flags are to be passed to the `texture` argument, they must be OR’d (i.e. with `bitwise-ior`) together.

    [constant] texture/power-of-two

Force the image to be power-of-two.

    [constant] texture/mipmaps

Generate mipmaps for the texture.

    [constant] texture/repeats

Sets the image to repeating, otherwise it will be clamped.

    [constant] texture/multiply-alpha

For when using (`gl:+one+`, `gl:+one-minus-src-alpha+`) blending.

    [constant] texture/invert-y

Flip the image vertically.

    [constant] texture/compress

If the card supports it this will convert RGB to DXT1, and RGBA to DXT5.

    [constant] texture/dds-direct

Will load DDS files directly without any additional processing.

    [constant] texture/ntsc-safe-rgb

Clamps RGB components to the NTSC GL safe range.

    [constant] texture/cogo-y

RGB becomes CoYCg and RGBA becomes CoCgAY.

    [constant] texture/rectangle

Uses `ARB_texture_rectangle`; generates pixedl indexed with no repeat, mip maps or cube maps.

#### Saving File Formats

    [constant] save-type/tga

TGA format in uncompressed RGBA or RGB.

    [constant] save-type/bmp

BMP format in uncompressed RGB

    [constant] save-type/dds

DDS format in DXT1 or DXT5

#### Internal HDR Representations

    [constant] fake-hdr/rgbe

RGB * pow( 2.0, A - 128.0)

    [constant] fake-hdr/rgb-div-alpha

RGB / A

    [constant] fake-hdr/rgb-div-alpha-squared

RGB / (A * A)


## Authors

Dan Leslie (dan@ironoxide.ca)

Alex Charlton (alex.n.charlton@gmail.com)

## Version history

- 1.3: Remove `dds-cubemap-face-order`, fix texture creation function return values, support OpenGL ES
- 1.2: SOIL source built into egg
- 1.1: Added procedures to retrieve texture size
- 1.0: First release

## License

Copyright 2012 Daniel J. Leslie. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY DANIEL J. LESLIE ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DANIEL J. LESLIE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the authors and should not be interpreted as representing official policies, either expressed or implied, of Daniel J. Leslie.
