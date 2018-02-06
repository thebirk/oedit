import "core:fmt.odin"
using import "buffer.odin"

main :: proc() {
	test := make_empty_buffer("test-buffer");
	buffer_insert(test, 'a');
	buffer_insert(test, 'b');
	buffer_move_left(test);
	buffer_insert(test, 'c');

	fmt.printf("%s\n", buffer_to_utf8_string(test));
}