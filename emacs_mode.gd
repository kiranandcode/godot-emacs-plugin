@tool
extends EditorPlugin
var script_editor : ScriptEditor;

func current_code_edit() -> CodeEdit:
	return script_editor.get_current_editor().get_base_editor()

class EmacsCommand:
	var _name : String
	var _key : String
	var _fun: String
	var _shortcut : String
	
	func _init(name,key,fun, shortcut): _name = name; _key = key; _fun = fun;_shortcut = shortcut

var commands = [
	EmacsCommand.new(
		"beginning-of-line", 
		"emacs/beginning-of-line", 
		"go_to_start_of_line",
		"Ctrl+a"
	),
	EmacsCommand.new(
		"end-of-line", 
		"emacs/end-of-line", 
		"go_to_end_of_line",
		"Ctrl+e"
	),
	EmacsCommand.new(
		"next-line", 
		"emacs/next-line", 
		"go_to_next_line",
		"Ctrl+n"
	),
	EmacsCommand.new(
		"previous-line", 
		"emacs/prev-line", 
		"go_to_prev_line",
		"Ctrl+p"
	),
	EmacsCommand.new(
		"forward-char", 
		"emacs/forward-char", 
		"go_to_next_char",
		"Ctrl+f"
	),
	EmacsCommand.new(
		"backwards-char", 
		"emacs/backwards-char", 
		"go_to_prev_lin",
		"Ctrl+b"
	)
]

func _enter_tree():
	var command_palette = EditorInterface.get_command_palette()
	
	for command : EmacsCommand in commands:
		# external_command is a function that will be called with the command is executed.
		var command_callable = Callable(self, command._fun)
		command_palette.add_command(command._name, command._key,command_callable, command._shortcut)

	script_editor = EditorInterface.get_script_editor()
	script_editor.get_current_editor().get_base_editor().add_user_signal()

func _exit_tree():
	var command_palette = EditorInterface.get_command_palette()
	for command : EmacsCommand in commands:
		command_palette.remove_command(command._key)

func go_to_start_of_line():
	var code_edit = current_code_edit()
	code_edit.set_caret_column(0)
	print(code_edit.get_signal_connection_list("input/ui_text_select_all"))
	
func go_to_next_line():
	var code_edit = current_code_edit()
	var line = code_edit.get_caret_line()
	code_edit.set_caret_line(line + 1)

func go_to_end_of_line():
	var code_edit = current_code_edit()
	var line = code_edit.get_caret_line()
	var line_length = code_edit.get_line(line).length()
	code_edit.set_caret_column(line_length - 1)

func go_to_prev_line():
	var code_edit = current_code_edit()
	var line = code_edit.get_caret_line()
	if line > 0:
		code_edit.set_caret_line(line - 1)

func go_to_next_char():
	var code_edit = current_code_edit()
	var col = code_edit.get_caret_column()
	code_edit.set_caret_line(col + 1)

func go_to_prev_char():
	var code_edit = current_code_edit()
	var col = code_edit.get_caret_column()
	if col > 0:
		code_edit.set_caret_column(col - 1)
