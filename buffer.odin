import "core:fmt.odin"
import "core:strings.odin"
import "core:utf8.odin"

DEFAULT_GAP_SIZE :: 32;

// Gap buuffer
// pre  - start of gap
// post - end of gap
// pre therefore doubles as the insert position
Buffer :: struct {
	data: []rune,
	name: string,
	pre, post: int,

	utf8_string: string,
	dirty: bool = true,
}

make_empty_buffer :: proc(name: string) -> ^Buffer {
	b := new(Buffer);

	b.name = strings.new_string(name);
	b.data = nil;
	b.pre = 0;
	b.post = 0;

	return b;
}

buffer_new_size :: proc(using buffer: ^Buffer) -> int {
	if data == nil {
		return 2+DEFAULT_GAP_SIZE;
	} else if len(data) > 1024 {
		return len(data)+1024+DEFAULT_GAP_SIZE;
	} else {
		return len(data)*2+DEFAULT_GAP_SIZE;
	}
}

buffer_expand :: proc(using buffer: ^Buffer) {
	if pre+post >= len(data) {
		fmt.printf("Expanded\n");
		new_size := buffer_new_size(buffer);
		old_data := data;
		if old_data != nil do defer free(old_data);
		data = make([]rune, new_size);

		for i := 0; i < pre; i += 1 {
			data[i] = old_data[i];
		}
		for i := len(old_data); i > post; i -= 1 {
			data[len(data)-i-1] = data[i];
		}
	}
}

buffer_insert :: proc[
	buffer_insert_char,
];

buffer_to_utf8_string :: proc(using buffer: ^Buffer) -> string {
	if dirty {
		if utf8_string != "" do free(utf8_string);
		string_buffer: [dynamic]u8;
		codepointbuffer: [4]u8;
		length: int = 0;

		append_bytes :: proc(string_buffer: ^[dynamic]u8, cp: [4]u8, length: int) {
			for i in 0..length {
				append(string_buffer, cp[i]);
			}
		}

		for i := 0; i < pre; i += 1 {
			codepointbuffer, len = utf8.encode_rune(data[i]);
			append_bytes(&string_buffer, codepointbuffer, length);
		}

		for i := len(data); i > post; i -= i {
			codepointbuffer, len = utf8.encode_rune(data[len(data)-1-i]);
			append_bytes(&string_buffer, codepointbuffer, length);
		}

		return cast(string)string_buffer[..];
	} else {
		return utf8_string;		
	}
}

buffer_insert_char :: proc(using buffer: ^Buffer, r: rune) {
	buffer_expand(buffer);
	data[pre] = r;
	pre += 1;
	dirty = true;
}

buffer_move_left :: proc(using buffer: ^Buffer) {
	if pre > 0 {
		r := data[pre-1];
		data[len(data)-post-1] = r;
		pre -= 1;
		post += 1;
		dirty = true;
	}
}