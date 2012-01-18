#>
#include <SOIL/SOIL.h>

typedef struct
{
    unsigned char *data;
    int width, height, channels;
} image;

<#

(module soil (force-channels/auto force-channels/luminous force-channels/luminous-alpha force-channels/rgb force-channels/rgba texture-id/create-new-id texture/power-of-two texture/mipmaps texture/repeats texture/multiply-alpha texture/invert-y texture/compress texture/dds-direct texture/ntsc-safe-rgb texture/cogo-y texture/rectangle save-type/tga save-type/bmp save-type/dds dds-cubemap-face-order fake-hdr/rgbe fake-hdr/rgb-div-alpha fake-hdr/rgb-div-alpha-squared load-ogl-texture load-ogl-cubemap load-ogl-single-cubemap load-ogl-hdr-texture load-ogl-texture-from-memory load-ogl-cubemap-from-memory load-ogl-single-cubemap-from-memory create-ogl-texture create-ogl-single-cubemap save-screenshot make-image image? image-data image-width image-height image-channels image-data-set! image-width-set! image-height-set! image-channels-set! load-image load-image-from-memory save-image last-result)

  (import chicken scheme foreign)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Enumerations
  
  (define-foreign-variable SOIL_LOAD_AUTO unsigned-integer)
  (define-foreign-variable SOIL_LOAD_L unsigned-integer)
  (define-foreign-variable SOIL_LOAD_LA unsigned-integer)
  (define-foreign-variable SOIL_LOAD_RGB unsigned-integer)
  (define-foreign-variable SOIL_LOAD_RGBA unsigned-integer)
  (define force-channels/auto SOIL_LOAD_AUTO)
  (define force-channels/luminous SOIL_LOAD_L)
  (define force-channels/luminous-alpha SOIL_LOAD_LA)
  (define force-channels/rgb SOIL_LOAD_RGB)
  (define force-channels/rgba SOIL_LOAD_RGBA)

  (define-foreign-variable SOIL_CREATE_NEW_ID unsigned-integer)
  (define texture-id/create-new-id SOIL_CREATE_NEW_ID)

  (define-foreign-variable SOIL_FLAG_POWER_OF_TWO unsigned-integer)
  (define-foreign-variable SOIL_FLAG_MIPMAPS unsigned-integer)
  (define-foreign-variable SOIL_FLAG_TEXTURE_REPEATS unsigned-integer)
  (define-foreign-variable SOIL_FLAG_MULTIPLY_ALPHA unsigned-integer)
  (define-foreign-variable SOIL_FLAG_INVERT_Y unsigned-integer)
  (define-foreign-variable SOIL_FLAG_COMPRESS_TO_DXT unsigned-integer)
  (define-foreign-variable SOIL_FLAG_DDS_LOAD_DIRECT unsigned-integer)
  (define-foreign-variable SOIL_FLAG_NTSC_SAFE_RGB unsigned-integer)
  (define-foreign-variable SOIL_FLAG_CoCg_Y unsigned-integer)
  (define-foreign-variable SOIL_FLAG_TEXTURE_RECTANGLE unsigned-integer)
  (define texture/power-of-two SOIL_FLAG_POWER_OF_TWO)
  (define texture/mipmaps SOIL_FLAG_MIPMAPS)
  (define texture/repeats SOIL_FLAG_TEXTURE_REPEATS)
  (define texture/multiply-alpha SOIL_FLAG_MULTIPLY_ALPHA)
  (define texture/invert-y SOIL_FLAG_INVERT_Y)
  (define texture/compress SOIL_FLAG_COMPRESS_TO_DXT)
  (define texture/dds-direct SOIL_FLAG_DDS_LOAD_DIRECT)
  (define texture/ntsc-safe-rgb SOIL_FLAG_NTSC_SAFE_RGB)
  (define texture/cogo-y SOIL_FLAG_CoCg_Y)
  (define texture/rectangle SOIL_FLAG_TEXTURE_RECTANGLE)

  (define-foreign-variable SOIL_SAVE_TYPE_TGA unsigned-integer)
  (define-foreign-variable SOIL_SAVE_TYPE_BMP unsigned-integer)
  (define-foreign-variable SOIL_SAVE_TYPE_DDS unsigned-integer)
  (define save-type/tga SOIL_SAVE_TYPE_TGA)
  (define save-type/bmp SOIL_SAVE_TYPE_BMP)
  (define save-type/dds SOIL_SAVE_TYPE_DDS)

  
  (define-foreign-variable SOIL_DDS_CUBEMAP_FACE_ORDER c-string)
  (define dds-cubemap-face-order SOIL_DDS_CUBEMAP_FACE_ORDER)

  (define-foreign-variable SOIL_HDR_RGBE unsigned-integer)
  (define-foreign-variable SOIL_HDR_RGBdivA unsigned-integer)
  (define-foreign-variable SOIL_HDR_RGBdivA2 unsigned-integer)
  (define fake-hdr/rgbe SOIL_HDR_RGBE)
  (define fake-hdr/rgb-div-alpha SOIL_HDR_RGBdivA)
  (define fake-hdr/rgb-div-alpha-squared SOIL_HDR_RGBdivA2)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Convenience types
  
  (define-foreign-type texture-id unsigned-integer)
  (define-foreign-type force-channels integer)
  (define-foreign-type texture-flags unsigned-integer)
  (define-foreign-type hdr-format integer)
  (define-foreign-type texture-handle unsigned-integer)
  (define-foreign-type image-type integer)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Functions

  (define load-ogl-texture (foreign-lambda* texture-handle ((c-string* filename) (force-channels channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_texture(filename, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define load-ogl-cubemap (foreign-lambda* texture-handle ((c-string* xpos) (c-string* xneg) (c-string* ypos) (c-string* yneg) (c-string* zpos) (c-string* zneg) (force-channels channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_cubemap(xpos, xneg, ypos, yneg, zpos, zneg, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define load-ogl-single-cubemap (foreign-lambda* texture-handle ((c-string* filename) (c-string* order) (force-channels channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_single_cubemap(filename, order, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define load-ogl-hdr-texture (foreign-lambda* texture-handle ((c-string* filename) (hdr-format hdr) (bool rescale) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_HDR_texture(filename, hdr, rescale, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define load-ogl-texture-from-memory (foreign-lambda* texture-handle ((blob buffer) (integer length) (force-channels channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_texture_from_memory(buffer, length, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define load-ogl-cubemap-from-memory (foreign-lambda* texture-handle ((blob xpos) (integer xposlength) (blob xneg) (integer xneglength) (blob ypos) (integer yposlength) (blob yneg) (integer yneglength) (blob zpos) (integer zposlength) (blob zneg) (integer zneglength) (force-channels channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_cubemap_from_memory(xpos, xposlength, xneg, xneglength, ypos, yposlength, yneg, yneglength, zpos, zposlength, zneg, zneglength, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define load-ogl-single-cubemap-from-memory (foreign-lambda* texture-handle ((blob buffer) (integer length) (c-string* order) (force-channels channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_load_OGL_single_cubemap_from_memory(buffer, length, order, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define create-ogl-texture (foreign-lambda* texture-handle ((blob data) (integer width) (integer height) (integer channels) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_create_OGL_texture(data, width, height, channels, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define create-ogl-single-cubemap (foreign-lambda* texture-handle ((blob data) (integer width) (integer height) (integer channels) (c-string* order) (texture-id id) (texture-flags tflags)) "
unsigned int r = SOIL_create_OGL_single_cubemap(data, width, height, channels, order, id, tflags);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(r);"))

  (define save-screenshot (foreign-lambda* bool ((c-string* filename) (image-type type) (integer x) (integer y) (integer width) (integer height)) "
int r = SOIL_save_screenshot(filename, type, x, y, width, height);
if (r == 0)
  C_return(C_SCHEME_FALSE);
else
  C_return(C_SCHEME_TRUE);"))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Complicated memory image functions

  (define make-c-image (foreign-lambda* c-pointer () "
void *data = malloc(sizeof(image));
C_return(data);
"))

  (define free-c-image (foreign-lambda* void ((c-pointer img)) "SOIL_free_image_data(((image *)img)->data); free(img);"))

  (define c-image-data (foreign-lambda* c-pointer ((c-pointer img)) "C_return(((image *)img)->data);"))
  (define c-image-width (foreign-lambda* integer ((c-pointer img)) "C_return(((image *)img)->width);"))
  (define c-image-height (foreign-lambda* integer ((c-pointer img)) "C_return(((image *)img)->height);"))
  (define c-image-channels (foreign-lambda* integer ((c-pointer img)) "C_return(((image *)img)->channels);"))

  (define-record image data width height channels)

  (define fill-blob (foreign-lambda* void ((blob buffer) (c-pointer src) (integer length)) "memcpy(buffer, src, length);"))

  (define to-image
    (lambda (c-image)
      (let* ((length (* (c-image-width c-image) (c-image-height c-image) (foreign-type-size char)))
            (out-blob (make-blob length)))
        (fill-blob out-blob (c-image-data c-image) length)
        (make-image out-blob (c-image-width c-image) (c-image-height c-image) (c-image-channels c-image)))))

  (define load-image
    (lambda (filename channels)
      (if (not (string? filename)) (error "filename should be a string"))
      (if (not (number? channels)) (error "channels should be a number"))
      (let* ((image-struct (make-c-image))
             (get-data (foreign-lambda* void ((c-pointer img) (c-string* fname) (force-channels chnls)) "((image *)img)->data = SOIL_load_image(fname, &((image *)img)->width, &((image *)img)->height, &((image *)img)->channels, chnls);")))
        (get-data image-struct filename channels)
        (let ((image (to-image image-struct)))
          (free-c-image image-struct)
          image))))
  
  (define load-image-from-memory
    (lambda (buffer length channels)
      (if (not (number? channels)) (error "channels should be a number"))
      (if (not (number? length)) (error "length should be a number"))
      (if (not (blob? buffer)) (error "buffer should be a blob"))
      (let* ((image-struct (make-c-image))
             (get-data (foreign-lambda* void ((blob buf) (integer buflen) (c-pointer img) (force-channels chnls)) "((image *)img)->data = SOIL_load_image_from_memory(buf, buflen, &((image *)img)->width, &((image *)img)->height, &((image *)img)->channels, chnls);")))
        (get-data buffer length image-struct channels)
        (let ((image (to-image image-struct)))
          (free-c-image image-struct)
          image))))

  (define save-image
    (lambda (filename type soil-image)
      (if (not (string? filename)) (error "filename should be a string"))
      (if (not (number? type)) (error "type should be a number"))
      (if (not (image? soil-image)) (error "soil-image should be a soil#image record"))
      (let ((save (foreign-lambda* int ((c-string* f) (image-type t) (integer width) (integer height) (force-channels c) (blob data)) "
C_return(SOIL_save_image(f, t, width, height, c, data));
")))
        (= 1 (save filename type (image-width soil-image) (image-height soil-image) (image-channels soil-image) (image-data soil-image))))))

  (define last-result (foreign-lambda c-string "SOIL_last_result")))









