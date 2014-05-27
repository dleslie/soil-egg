[[tags: egg soil image opengl gl bmp tga dds png jpg game]]

== soil

SOIL bindings for Chicken.

[[toc:]]

== Disclaimer

For now, the egg is available at:
https://github.com/dleslie/soil-egg

The interface adheres closely to the stock SOIL interface.

Much thanks to Jonathan Dummer for writing the original SOIL library.

== SOIL Overview

SOIL is a tiny c library for uploading images as textures into OpenGL.  Also saving and loading of images is supported.

It uses Sean's Tool Box image loader as a base:
http://www.nothings.org/

SOIL upgrades stb_image to load TGA and DDS files, and adds a direct path for loading DDS files straight into OpenGL textures, when applicable.

Image Formats:
; BMP : load and save
; TGA : load and save
; DDS : load and save
; PNG : load
; JPG : load

OpenGL Texture Features:
* resample to power-of-two sizes
* MIPmap generation
* compressed texture S3TC formats (if supported)
* can pre-multiply alpha for you, for better compositing
* can flip image about the y-axis (except pre-compressed DDS files)

Thanks to:
* Sean Barret - for the awesome stb_image
* Dan Venkitachalam - for finding some non-compliant DDS files, and patching some explicit casts
* everybody at gamedev.net
* Jonathan Dummer for writing SOIL

== Reference

=== Flags and Enumerations

==== Image Loading

The format of images that may be loaded.

<constant>force-channels/auto</constant>

Leaves the image in whatever format it was found.

<constant>force-channels/luminous</constant>

Forces the image to load as Luminous (greyscale).

<constant>force-channels/luminous-alpha</constant>

Forces the image to load as Luminous with Alpha.

<constant>force-channels/rgb</constant>

Forces the image to load as Red Green Blue.

<constant>force-channels/rgba</constant>

Forces the image to load as Red Green Blue Alpha.

==== Texture Creation

<constant>texture-id/create-new-id</constant>

Passed in as reuse-texture-id, and will cause SOIL to register a new texture ID using glGenTextures(). If the value passed into reuse-texture-id > 0 then SOIL will just reuse that texture ID (great for reloading image assets in-game).

==== OpenGL Texture Format

<constant>texture/power-of-two</constant>

Force the image to be power-of-two.

<constant>texture/mipmaps</constant>

Generate mipmaps for the texture.

<constant>texture/repeats</constant>

Sets the image to repeating, otherwise it will be clamped.

<constant>texture/multiply-alpha</constant>

For when using (GL_ONE, GL_ONE_MINUS_SRC_ALPHA) blending.

<constant>texture/invert-y</constant>

Flip the image vertically.

<constant>texture/compress</constant>

If the card supports it this will convert RGB to DXT1, and RGBA to DXT5.

<constant>texture/dds-direct</constant>

Will load DDS files directly without any additional processing.

<constant>texture/ntsc-safe-rgb</constant>

Clamps RGB components to the NTSC GL safe range.

<constant>texture/cogo-y</constant>

RGB becomes CoYCg and RGBA becomes CoCgAY.

<constant>texture/rectangle</constant>

Uses ARB_texture_rectangle; generates pixedl indexed with no repeat, mip maps or cube maps.

==== Saving File Formats

<constant>save-type/tga</constant>

TGA format in uncompressed RGBA or RGB.

<constant>save-type/bmp</constant>

BMP format in uncompressed RGB

<constant>save-type/dds</constant>

DDS format in DXT1 or DXT5

==== Cube Maps

<constant>dds-cubemap-face-order</constant>

The current face order as defined in the C preprocessor. Defaults to EWUDNS. In order to reorder this you will need to define SOIL_DDS_CUBEMAP_FACE_ORDER in the C preprocessor, likely in the #> <# header block of the appropriate scheme source file.

==== Internal HDR Representations

<constant>fake-hdr/rgbe</constant>

RGB * pow( 2.0, A - 128.0)

<constant>fake-hdr/rgb-div-alpha</constant>

RGB / A

<constant>fake-hdr/rgb-div-alpha-squared</constant>

RGB / (A * A)

=== Functions

<procedure>(load-ogl-texture filename force-channels texture-id texture-flags)</procedure>

Loads an image from disk into an OpenGL texture.

<parameter>filename</parameter> Name of the file to load
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(load-ogl-cubemap xpos-file xneg-file ypos-file yneg-file zpos-file zneg-file force-channels texture-id texture-flags)</procedure>

Loads a cubemap texture from disc.

<parameter>xpos-file</parameter> File to load for the +x cube face
<parameter>xneg-file</parameter> File to load for the -x cube face
<parameter>ypos-file</parameter> File to load for the +y cube face
<parameter>yneg-file</parameter> File to load for the -y cube face
<parameter>zpos-file</parameter> File to load for the +z cube face
<parameter>zneg-file</parameter> File to load for the -z cube face
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(load-ogl-single-cubemap filename face-order force-channels texture-id texture-flags)</procedure>

Loads a single image from disc and splits it into an OpenGL cubemap texture.

<parameter>filename</parameter> File to load and split into the texture
<parameter>face-order</parameter> The order of the faces in the file, any combination of NSWEUD
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(load-ogl-hdr-texture filename hdr-format rescale-to-max texture-id texture-flags)</procedure>

Loads an HDR image from disk into an OpenGL texture.

<parameter>filename</parameter> File to load and split into the texture
<parameter>hdr-format</parameter> One of the fake-hdr/* flags, IE, fake-hdr/rgbe
<parameter>rescale-to-max</parameter> If true, rescales the image to max
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(load-ogl-texture-from-memory buffer length force-channels texture-id texture-flags)</procedure>

Loads an image from memory into an OpenGL texture.

<parameter>buffer</parameter> The blob from which the image should be loaded
<parameter>length</parameter> The length, in bytes, to read from the blob
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(load-ogl-cubemap-from-memory xpos-buffer xpos-length xneg-buffer xneg-length ypos-buffer ypos-length yneg-buffer yneg-length zpos-buffer zpos-length zneg-buffer zneg-length force-channels texture-id texture-flags)</procedure>

Loads a cubemap texture from memory.

<parameter>xpos-buffer</parameter> Buffer to load for the +x cube face
<parameter>xpos-length</parameter> Size, in bytes, to read from xpos-buffer
<parameter>xneg-buffer</parameter> Buffer to load for the -x cube face
<parameter>xneg-length</parameter> Size, in bytes, to read from xneg-buffer
<parameter>ypos-buffer</parameter> Buffer to load for the +y cube face
<parameter>ypos-length</parameter> Size, in bytes, to read from ypos-buffer
<parameter>yneg-buffer</parameter> Buffer to load for the -y cube face
<parameter>yneg-length</parameter> Size, in bytes, to read from yneg-buffer
<parameter>zpos-buffer</parameter> Buffer to load for the +z cube face
<parameter>zpos-length</parameter> Size, in bytes, to read from zpos-buffer
<parameter>zneg-buffer</parameter> Buffer to load for the -z cube face
<parameter>zneg-length</parameter> Size, in bytes, to read from zneg-buffer
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(load-ogl-single-cubemap-from-memory buffer length order force-channels texture-id texture-flags)</procedure>

Loads a single image from memory and splits it into an OpenGL cubemap texture.

<parameter>buffer</parameter> Blob to load and split into the texture
<parameter>length</parameter> Size, in bytes, to read from the blob
<parameter>face-order</parameter> The order of the faces in the file, any combination of NSWEUD
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(create-ogl-texture data width height force-channels texture-id texture-flags)</procedure>

Creates a 2D OpenGL texture from raw image data. The raw data is not freed after being uploaded. (And it is thus safe to use a blob).

<parameter>data</parameter> Blob to upload as an OpenGL texture
<parameter>width</parameter> The width of the image in pixels
<parameter>height</parameter> The height of the image in pixels
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(create-ogl-single-cubemap data width height force-channels order texture-id texture-flags)</procedure>

<parameter>data</parameter> Blob to upload as an OpenGL texture
<parameter>width</parameter> The width of the image in pixels
<parameter>height</parameter> The height of the image in pixels
<parameter>face-order</parameter> The order of the faces in the file, any combination of NSWEUD
<parameter>force-channels</parameter> Format of image channels to force, see above definitions for appropriate values
<parameter>texture-id</parameter> Use either texture-id/create-new-id or use an existing texture id to overwrite an existing texture
<parameter>texture-flags</parameter> See above for appropriate texture/* to use, ie, texture/repeats or texture/mipmaps. Flags are bitwise, and can be combined with bitwise-ior

Returns an OpenGL texture-id.

<procedure>(save-screenshot filename save-type x y width height)</procedure>

Captures the OpenGL window (RGB) and saves it to disk.

<parameter>filename</parameter> The file to save the image to
<parameter>save-type</parameter> The format to save the image in, one of save-type/*
<parameter>x</parameter> Start x position
<parameter>y</parameter> Start y position
<parameter>width</parameter> Width of image
<parameter>height</parameter> Height of image

Returns #t if succesful.

<procedure>(last-result)</procedure>

Returns the last error message as a string.

<procedure>(ogl-texture-width texture)</procedure>
<procedure>(ogl-texture-height texture)</procedure>

Returns the width and height of the given OpenGL texture.

== Known Issues


== Authors

Dan Leslie (dan@ironoxide.ca)

Alex Charlton (alex.n.charlton@gmail.com)

== Version history

; 1.2 : SOIL source built into egg

; 1.1 : Added procedures to retrieve texture size

; 1.0 : First release

== License

Copyright 2012 Daniel J. Leslie. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY DANIEL J. LESLIE ''AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DANIEL J. LESLIE OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of Daniel J. Leslie.
