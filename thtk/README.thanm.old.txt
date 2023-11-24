THANM.OLD(1)                General Commands Manual               THANM.OLD(1)

NAME
       thanm.old 窶 Touhou sprite archive tool

SYNOPSIS
       thanm.old [-Vf] [-l [version] | -x | -r | -c] [archive [...]]

DESCRIPTION
       The thanm.old utility performs various actions on sprite archives.  The
       following commands are available:

       thanm.old [-f] -l [version] archive
               Displays a specification of the archive.  The version is neces窶
               sary to correctly process archives from TH18 and newer, but may
               otherwise be omitted.

       thanm.old [-f] -x archive [file ...]
               Extracts image files.  If no files are specified, all files are
               extracted.

       thanm.old [-f] -r archive name file
               Replaces  an entry in the archive.  The name can be obtained by
               the -l command.

       thanm.old [-f] -c archive input
               Creates a new archive from a specification obtained by  the  -l
               command.   It  will look for referenced image files in the cur窶
               rent directory.

       thanm.old -V
               Displays the program version.

       These options are accepted:

       -f      The -f option can be used to ignore certain errors.

EXIT STATUS
       The thanm.old utility exits with 0 on success, 1 on error.

SEE ALSO
       Project homepage: https://github.com/thpatch/thtk

BUGS
       A few files from TH12 and TH13 contain overlapping entries with differ窶
       ent formats.  Dumping and recreating these archives will not result  in
       the  same  archives.   The affected pixels seem to all have 0 for alpha
       though.

       One of the scripts in TH95's front.anm  lack  a  sentinel  instruction.
       Dumping and recreating this archive will add a sentinel instruction.

       This version will not create correct TH19 archives, please use the lat窶
       est thanm(1) instead.

SECURITY CONSIDERATIONS
       File names may not be properly sanitized when extracting.  Furthermode,
       invalid  data may not be properly handled.  Do not operate on untrusted
       files.

thtk                             May 23, 2023                     THANM.OLD(1)
