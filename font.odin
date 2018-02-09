import "core:os.odin"
import "core:fmt.odin"

import "shared:odin-gl/gl.odin"
import stbtt "shared:odin-stb/stb_truetype.odin"

Font :: struct {
    info: stbtt.Font_Info,
    pack_context: stbtt.Pack_Context,
    texture: u32,
    size: f32,
    scale: f32,
    data: []u8,
    atlas_pixels: []u8,
    packed_chars: map[rune]stbtt.Packed_Char,
}

load_font_at_size :: proc(path: string, size: f32) -> ^Font {
    font_data, ok := os.read_entire_file(path);
    if !ok {
        return nil;
    }
    
    font := new(Font);
    
    font.data = font_data;
    ret := stbtt.init_font(&font.info, font_data, 0);
    if !ret {
        free(font);
        return nil;
    }
    
    font.size = size;
    font.scale = stbtt.scale_for_pixel_height(&font.info, size);
    
    fmt.printf("Loaded font '%s'\n", path);
    fmt.printf("numGlyphs: %d\n", font.info.numGlyphs);
    
    // Prepare font atlas
    //gl.GenTextures(1, &font.texture);
    //gl.BindTexture(gl.TEXTURE_2D, font.texture);
    ATLAS_WIDTH  :: 4096;
    ATLAS_HEIGHT :: 4096;
    font.atlas_pixels = make([]u8, ATLAS_WIDTH*ATLAS_HEIGHT);
    
    // Packing default font ranges
    stbtt.stbtt_PackBegin(&font.pack_context, &font.atlas_pixels[0], ATLAS_WIDTH, ATLAS_HEIGHT, 0, 1, nil);
    
    // TODO(thebirk): Find out how to store and pass Packed_Char's
    pack_range(font, 0x20, 0x7F-0x20);
    pack_range(font, 0xA0, 0xFF-0xA0);
    //gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGBA, ATLAS_WIDTH, ATLAS_HEIGHT, 0, gl.RED, gl.UNSIGNED_BYTE, &font.atlas_pixels);
    
    
    return font;
}

free_font :: proc(font: ^Font) {
    stbtt.pack_end(&font.pack_context);
    free(data);
    free(packed_chars);
    free(atlas_pixels);
}

pack_range :: proc(using font: ^Font, from: rune, chars: int) {
    chardata := make([]stbtt.Packed_Char, chars);
    defer free(chardata);
    
    result := stbtt.stbtt_PackFontRange(&pack_context, &font.data[0], 0, size, i32(from), i32(chars), &chardata[0]);
    if result == 0 {
        panic("Failed to pack range! This shold be handled better.");
    }
    
    reserve(&packed_chars, chars);
    for i in 0..chars {
        packed_chars[from+rune(i)] = chardata[i];
    }
}