#include <command.h>

void run_command(const char* cmd, const char* arg) {
    if (arg == NULL) {
        if (strcmp(cmd, "$exit") == 0 || strcmp(cmd, "$quit") == 0) {
            if (!qflag) printf("Goodbye!\n");
            program_running = 0;
		} else if (strcmp(cmd, "$fly") == 0) {
			cmd_print("You throw yourself at the ground and smash face-first into the mud.");
		    cmd_print("Why on earth did you think that would ever work?!");
        } else {
            yyerror("unknown command: %s", cmd);
        }
    } else {
        if (strcmp(cmd, "$load") == 0) {
            load_lib(arg);
        } else {
            yyerror("unknown command: %s", cmd);
        }
    }
}
