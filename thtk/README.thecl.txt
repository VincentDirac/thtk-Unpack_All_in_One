THECL(1)                    General Commands Manual                   THECL(1)

NAME
       thecl 窶 Touhou enemy control language script tool

SYNOPSIS
       thecl [-Vrsxj] [[-c | -h | -d] version] [-m eclmap]... [input [output]]

DESCRIPTION
       The thecl utility (de)compiles ecl scripts.  The following commands are
       available:

       thecl -c version [-sj] [-m eclmap]... [input [output]]
               Compiles an enemy script.

       thecl -h version [-m eclmap]... [input [output]]
               Creates  a header file with forward declarations of all subs in
               input.

       thecl -d version [-rxj] [-m eclmap]... [input [output]]
               Dumps an enemy script.

       -V      Displays the program version.

       These options are accepted:

       -m eclmap
               The -m option can be used to map ins_* to human readable names.

       -r      The -r option suppresses code  transformations  like  parameter
               detection, or expression decompilation.

       -s      The  -s  option enables simple creation mode, which doesn't add
               any instructions automatically.

       -x      The -x option outputs address information when dumping instruc窶
               tions.  Shows both the file offset and the offset  relative  to
               the start of the sub.

       -j      The  -j  option enables string conversion between Shift-JIS and
               UTF-8.  Source files are treated as UTF-8, ECL files as  Shift-
               JIS.

       Replace  the  version  option  by  the  enemy script format version re窶
       quested.  Running the program without a command will list the supported
       formats.

EXIT STATUS
       The thecl utility exits with 0 on success, 1 on error.

ECLMAP FILE FORMAT
       Eclmap files, which are added with the -m option, consist of two  kinds
       of lines: control lines (which start with 窶!窶), and mapping lines.

       The  file  starts with 窶!eclmap窶 control line.  The rest of the control
       lines select the mapping that is being modified:

       窶!ins_names窶
               Instruction names.  This is the default mapping.
               Value: identifier

       窶!ins_signatures窶
               Instruction signatures.
               Value: signature

       窶!gvar_names窶
               Global variable names.
               Value: identifier

       窶!gvar_types窶
               Global variable types.
               Value: type (窶$窶 for integer, 窶%窶 for float)

       窶!timeline_ins_names窶
               Timeline instruction names.
               Value: identifier

       窶!timeline_ins_signatures窶
               Timeline instruction signatures.
               Value: signature

       Mapping lines are always of form
             [key] [value]
       where key is an integer, and value is a string without  spaces.   Empty
       values are allowed.

       When  multiple  mappings  are  specified for the same key or value, the
       most recent one has priority.  For example:

             123 foo
             123 bar

       will map 窶123窶 to 窶話ar窶, 窶話ar窶 to 窶123窶, and 窶惑oo窶 to 窶123窶.  Note  how
       the first reverse mapping doesn't get removed.

SEE ALSO
       Project homepage: https://github.com/thpatch/thtk

SECURITY CONSIDERATIONS
       Invalid  data may not be properly handled.  Do not operate on untrusted
       files.

thtk                             May 25, 2023                         THECL(1)
