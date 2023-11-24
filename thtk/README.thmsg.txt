THMSG(1)                    General Commands Manual                   THMSG(1)

NAME
       thmsg — Touhou dialogue tool

SYNOPSIS
       thmsg [-Ve] [[-c | -d] version] [input [output]]

DESCRIPTION
       The  thmsg utility converts dialogue files from and to a human-readable
       format.  The following commands are available:

       thmsg -c version [-e] [input [output]]
               Creates a new dialogue file from the input.

       thmsg -d version [-e] [input [output]]
               Dumps a dialogue file.

       thmsg -V
               Displays the program version.

       The version specifies which dialogue format to use, it is further modi‐
       fied by the presence of the -e option.  Running the program  without  a
       command will list the supported formats.

       -e      The  -e  option is used to process ending dialogue, and for the
               mission.msg file in TH125.

EXIT STATUS
       The thmsg utility exits with 0 on success, 1 on error.

EXAMPLES
       Create a new dialogue file from the input file:

             thmsg -c10 input.txt output.msg

       Dump the mission descriptions to standard output:

             thmsg -ed125 mission.msg

SEE ALSO
       Project homepage: https://github.com/thpatch/thtk

SECURITY CONSIDERATIONS
       Invalid data may not be properly handled.  Do not dump  untrusted  dia‐
       logue files.

thtk                            April 24, 2023                        THMSG(1)
