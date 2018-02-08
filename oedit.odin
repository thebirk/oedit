import "core:fmt.odin"
import "core:os.odin"
using import "buffer.odin"
import "shared:odin-glfw/glfw.odin"
import "shared:odin-gl/gl.odin"
import stbtt "shared:odin-stb/stb_truetype.odin"

HEIGHT :: 540;
WIDTH  :: HEIGHT / 3 * 4;

the_window : glfw.Window_Handle;
running    : bool;

init_glfw_and_opengl :: proc(width, height: int) {
    if glfw.Init() == 0 {
        fmt.printf("Failed to init glfw!\n");
        os.exit(1);
    }
    
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3);
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3);
    
    the_window = glfw.CreateWindow(i32(width), i32(height), "oedit\x00", nil, nil);
    if the_window == nil {
        fmt.printf("Failed to create glfw window!\n");
        glfw.Terminate();
        os.exit(1);
    }
    
    glfw.MakeContextCurrent(the_window);
    glfw.SwapInterval(1);
    
    get_proc_address :: proc(p: rawptr, name: string) {
        (cast(^rawptr)p)^ = glfw.GetProcAddress(&name[0]);
    }
    gl.load_up_to(3, 3, get_proc_address);
    
    close_callback :: proc(window: glfw.Window_Handle) do running = false;
    glfw.SetWindowCloseCallback(the_window, glfw.Window_Close_Proc(close_callback));
}

main :: proc() {
    init_glfw_and_opengl(WIDTH, HEIGHT);
    running = true;
    
    buff := make_empty_buffer("test-buffer");
    buffer_insert(buff, "Hello, world!");
    buffer_seek(buff, -6);
    buffer_insert(buff, "Odin!");
    buffer_insert(buff, "A very very very long string!");
    
    /*
for i := 0; i < len(buff.data); i += 1 {
        fmt.printf("%d ", buff.data[i]);
        if i != 0 && i % 8 == 0 do fmt.println();
    }
    */
    
    gl.ClearColor(0, 0.17, 0.21, 1);
    for running {
        gl.Clear(gl.COLOR_BUFFER_BIT);
        
        glfw.SwapBuffers(the_window);
        glfw.PollEvents();
        
    }
}