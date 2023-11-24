THANM(1)                    General Commands Manual                   THANM(1)

NAME
       thanm 窶 Touhou sprite archive tool

SYNOPSIS
       thanm  [-Vfouv]  [[-l | -x | -X | -r | -c]  version] [-m anmmap]... [-s
             symbols] [archive [...]]

DESCRIPTION
       The thanm utility performs various actions  on  sprite  archives.   The
       following commands are available:

       thanm -l version [-fouv] [-m anmmap]... archive
               Displays a specification of the archive.

       thanm -x version [-fouv] archive [file ...]
               Extracts image files.  If no files are specified, all files are
               extracted.

       thanm -X version [-fouv] archives...
               Extracts all image files from multiple archives.

       thanm -r version [-fouv] archive name file
               Replaces  an entry in the archive.  The name can be obtained by
               the -l command.

       thanm -c version [-fuv] [-m anmmap]... [-s symbols] archive input
               Creates a new archive from a specification obtained by  the  -l
               command.   It  will look for referenced image files in the cur窶
               rent directory.

       thanm -V
               Displays the program version.

       These options are accepted:

       -f      The -f option can be used to ignore certain errors.

       -m anmmap
               The -m option can be used to map ins_* to human readable names.

       -s symbols
               The -s option saves symbol ids to the symbols file.

       -o      The -o option adds address information for ANM instructions.

       -u      The -u option extracts each texture into a separate file.  When
               specified  twice,  x/y   offset   is   ignored.    See   窶廬MAGE
               COMPOSITION窶 for more information.

       -v      The  -v  option  increases  verbosity of the output.  It can be
               specified multiple times.

EXIT STATUS
       The thanm utility exits with 0 on success, 1 on error.

IMAGE COMPOSITION
       Each texture in an ANM file has an associated  source  image  filename.
       By  default thanm creates textures by cropping the source image accord窶
       ing  to  the  following  parameters:   xOffset,   yOffset,   THTXWidth,
       THTXHeight.   When  extracting  the  textures, the process is reversed.
       However, because multiple textures may come from a single source  file,
       they  have to be composed together during extraction.  Additionally, in
       either case, the textures have to be converted to/from the  appropriate
       format.

       Composition when creating (-c) or replacing (-r):
               The  source image is read from a file, decoded as PNG, cropped,
               and encoded in the texture format.

       Composition when extracting (-x and -X):
               Each texture is decoded into RGBA, and placed on a canvas.  The
               canvas is encoded as PNG and written to the destination file.

       The -u option extracts each texture into its own file.  It's  important
       to  also  use  the -u option for listing (-l), because -c relies on the
       alternative filenames being specified in the spec file.  Even  with  -u
       the images are cropped/padded when they have an offset.  The -uu option
       ignores the offset, thereby disabling cropping/padding.

       In TH19, the textures are stored using PNG and JPEG compression.  thanm
       tries to avoid recompression when possible, so composition is only done
       when  necessary.  Uncompressed textures (pre-TH19) are always composed,
       even if only to convert them to PNG.  PNGs are only  composed  only  if
       there's  a  nonzero  offset, or there are multiple textures referencing
       the same image.  Otherwise the file is copied directly, without  recom窶
       pression  (-uu forces this behavior).  JPEGs are never composed, but it
       shouldn't be necessary either.  If a JPEG has  to  be  composed,  thanm
       will issue a warning.

ANMMAP FILE FORMAT
       Anmmap  files, which are added with the -m option, consist of two kinds
       of lines: control lines (which start with 窶!窶), and mapping lines.

       The file starts with 窶!anmmap窶 control line.  The rest of  the  control
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

       Mapping lines are always of form
             [key] [value]
       where  key  is an integer, and value is a string without spaces.  Empty
       values are allowed.

       When multiple mappings are specified for the same  key  or  value,  the
       most recent one has priority.  For example:

             123 foo
             123 bar

       will  map 窶123窶 to 窶話ar窶, 窶話ar窶 to 窶123窶, and 窶惑oo窶 to 窶123窶.  Note how
       the first reverse mapping doesn't get removed.

SEE ALSO
       Project homepage: https://github.com/thpatch/thtk

BUGS
       A few files from TH12 and TH13 contain overlapping entries with differ窶
       ent formats.  Dumping and recreating these archives will not result  in
       the  same  archives.   The affected pixels seem to all have 0 for alpha
       though.

SECURITY CONSIDERATIONS
       File names may not be properly sanitized when extracting.  Furthermore,
       invalid data may not be properly handled.  Do not operate on  untrusted
       files.

thtk                           September 3, 2023                      THANM(1)
