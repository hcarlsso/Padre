package Wx::Scintilla;

use strict;
use warnings;
use Carp ();
use Wx   ();

our $VERSION = '0.33_01';

# Define Perl 6 lexer
use constant {
    wxSCINTILLA_LEX_PERL6  => 102,
    wxSCINTILLA_P6_DEFAULT => 0,
    wxSCINTILLA_P6_COMMENT => 1,
    wxSCINTILLA_P6_STRING  => 2,
};

use constant {
    INVALID_POSITION                => -1,
    START                           => 2000,
    OPTIONAL_START                  => 3000,
    LEXER_START                     => 4000,
    WS_INVISIBLE                    => 0,
    WS_VISIBLEALWAYS                => 1,
    WS_VISIBLEAFTERINDENT           => 2,
    EOL_CRLF                        => 0,
    EOL_CR                          => 1,
    EOL_LF                          => 2,
    CP_UTF8                         => 65001,
    CP_DBCS                         => 1,
    MARKER_MAX                      => 31,
    MARK_CIRCLE                     => 0,
    MARK_ROUNDRECT                  => 1,
    MARK_ARROW                      => 2,
    MARK_SMALLRECT                  => 3,
    MARK_SHORTARROW                 => 4,
    MARK_EMPTY                      => 5,
    MARK_ARROWDOWN                  => 6,
    MARK_MINUS                      => 7,
    MARK_PLUS                       => 8,
    MARK_VLINE                      => 9,
    MARK_LCORNER                    => 10,
    MARK_TCORNER                    => 11,
    MARK_BOXPLUS                    => 12,
    MARK_BOXPLUSCONNECTED           => 13,
    MARK_BOXMINUS                   => 14,
    MARK_BOXMINUSCONNECTED          => 15,
    MARK_LCORNERCURVE               => 16,
    MARK_TCORNERCURVE               => 17,
    MARK_CIRCLEPLUS                 => 18,
    MARK_CIRCLEPLUSCONNECTED        => 19,
    MARK_CIRCLEMINUS                => 20,
    MARK_CIRCLEMINUSCONNECTED       => 21,
    MARK_BACKGROUND                 => 22,
    MARK_DOTDOTDOT                  => 23,
    MARK_ARROWS                     => 24,
    MARK_PIXMAP                     => 25,
    MARK_FULLRECT                   => 26,
    MARK_LEFTRECT                   => 27,
    MARK_AVAILABLE                  => 28,
    MARK_UNDERLINE                  => 29,
    MARK_CHARACTER                  => 10000,
    MARKNUM_FOLDEREND               => 25,
    MARKNUM_FOLDEROPENMID           => 26,
    MARKNUM_FOLDERMIDTAIL           => 27,
    MARKNUM_FOLDERTAIL              => 28,
    MARKNUM_FOLDERSUB               => 29,
    MARKNUM_FOLDER                  => 30,
    MARKNUM_FOLDEROPEN              => 31,
    MASK_FOLDERS                    => 0xFE000000,
    MARGIN_SYMBOL                   => 0,
    MARGIN_NUMBER                   => 1,
    MARGIN_BACK                     => 2,
    MARGIN_FORE                     => 3,
    MARGIN_TEXT                     => 4,
    MARGIN_RTEXT                    => 5,
    STYLE_DEFAULT                   => 32,
    STYLE_LINENUMBER                => 33,
    STYLE_BRACELIGHT                => 34,
    STYLE_BRACEBAD                  => 35,
    STYLE_CONTROLCHAR               => 36,
    STYLE_INDENTGUIDE               => 37,
    STYLE_CALLTIP                   => 38,
    STYLE_LASTPREDEFINED            => 39,
    STYLE_MAX                       => 255,
    CHARSET_ANSI                    => 0,
    CHARSET_DEFAULT                 => 1,
    CHARSET_BALTIC                  => 186,
    CHARSET_CHINESEBIG5             => 136,
    CHARSET_EASTEUROPE              => 238,
    CHARSET_GB2312                  => 134,
    CHARSET_GREEK                   => 161,
    CHARSET_HANGUL                  => 129,
    CHARSET_MAC                     => 77,
    CHARSET_OEM                     => 255,
    CHARSET_RUSSIAN                 => 204,
    CHARSET_CYRILLIC                => 1251,
    CHARSET_SHIFTJIS                => 128,
    CHARSET_SYMBOL                  => 2,
    CHARSET_TURKISH                 => 162,
    CHARSET_JOHAB                   => 130,
    CHARSET_HEBREW                  => 177,
    CHARSET_ARABIC                  => 178,
    CHARSET_VIETNAMESE              => 163,
    CHARSET_THAI                    => 222,
    CHARSET_8859_15                 => 1000,
    CASE_MIXED                      => 0,
    CASE_UPPER                      => 1,
    CASE_LOWER                      => 2,
    INDIC_PLAIN                     => 0,
    INDIC_SQUIGGLE                  => 1,
    INDIC_TT                        => 2,
    INDIC_DIAGONAL                  => 3,
    INDIC_STRIKE                    => 4,
    INDIC_HIDDEN                    => 5,
    INDIC_BOX                       => 6,
    INDIC_ROUNDBOX                  => 7,
    INDIC_STRAIGHTBOX               => 8,
    INDIC_DASH                      => 9,
    INDIC_DOTS                      => 10,
    INDIC_SQUIGGLELOW               => 11,
    INDIC_DOTBOX                    => 12,
    INDIC_MAX                       => 31,
    INDIC_CONTAINER                 => 8,
    INDIC0_MASK                     => 0x20,
    INDIC1_MASK                     => 0x40,
    INDIC2_MASK                     => 0x80,
    INDICS_MASK                     => 0xE0,
    IV_NONE                         => 0,
    IV_REAL                         => 1,
    IV_LOOKFORWARD                  => 2,
    IV_LOOKBOTH                     => 3,
    PRINT_NORMAL                    => 0,
    PRINT_INVERTLIGHT               => 1,
    PRINT_BLACKONWHITE              => 2,
    PRINT_COLOURONWHITE             => 3,
    PRINT_COLOURONWHITEDEFAULTBG    => 4,
    FIND_WHOLEWORD                  => 2,
    FIND_MATCHCASE                  => 4,
    FIND_WORDSTART                  => 0x00100000,
    FIND_REGEXP                     => 0x00200000,
    FIND_POSIX                      => 0x00400000,
    FOLDLEVELBASE                   => 0x400,
    FOLDLEVELWHITEFLAG              => 0x1000,
    FOLDLEVELHEADERFLAG             => 0x2000,
    FOLDLEVELNUMBERMASK             => 0x0FFF,
    FOLDFLAG_LINEBEFORE_EXPANDED    => 0x0002,
    FOLDFLAG_LINEBEFORE_CONTRACTED  => 0x0004,
    FOLDFLAG_LINEAFTER_EXPANDED     => 0x0008,
    FOLDFLAG_LINEAFTER_CONTRACTED   => 0x0010,
    FOLDFLAG_LEVELNUMBERS           => 0x0040,
    TIME_FOREVER                    => 10000000,
    WRAP_NONE                       => 0,
    WRAP_WORD                       => 1,
    WRAP_CHAR                       => 2,
    WRAPVISUALFLAG_NONE             => 0x0000,
    WRAPVISUALFLAG_END              => 0x0001,
    WRAPVISUALFLAG_START            => 0x0002,
    WRAPVISUALFLAGLOC_DEFAULT       => 0x0000,
    WRAPVISUALFLAGLOC_END_BY_TEXT   => 0x0001,
    WRAPVISUALFLAGLOC_START_BY_TEXT => 0x0002,
    WRAPINDENT_FIXED                => 0,
    WRAPINDENT_SAME                 => 1,
    WRAPINDENT_INDENT               => 2,
    CACHE_NONE                      => 0,
    CACHE_CARET                     => 1,
    CACHE_PAGE                      => 2,
    CACHE_DOCUMENT                  => 3,
    EFF_QUALITY_MASK                => 0xF,
    EFF_QUALITY_DEFAULT             => 0,
    EFF_QUALITY_NON_ANTIALIASED     => 1,
    EFF_QUALITY_ANTIALIASED         => 2,
    EFF_QUALITY_LCD_OPTIMIZED       => 3,
    EDGE_NONE                       => 0,
    EDGE_LINE                       => 1,
    EDGE_BACKGROUND                 => 2,
    STATUS_OK                       => 0,
    STATUS_FAILURE                  => 1,
    STATUS_BADALLOC                 => 2,
    CURSORNORMAL                    => -1,
    CURSORWAIT                      => 4,
    VISIBLE_SLOP                    => 0x01,
    VISIBLE_STRICT                  => 0x04,
    CARET_SLOP                      => 0x01,
    CARET_STRICT                    => 0x04,
    CARET_JUMPS                     => 0x10,
    CARET_EVEN                      => 0x08,
    SEL_STREAM                      => 0,
    SEL_RECTANGLE                   => 1,
    SEL_LINES                       => 2,
    SEL_THIN                        => 3,
    ALPHA_TRANSPARENT               => 0,
    ALPHA_OPAQUE                    => 255,
    ALPHA_NOALPHA                   => 256,
    CARETSTYLE_INVISIBLE            => 0,
    CARETSTYLE_LINE                 => 1,
    CARETSTYLE_BLOCK                => 2,
    ANNOTATION_HIDDEN               => 0,
    ANNOTATION_STANDARD             => 1,
    ANNOTATION_BOXED                => 2,
    UNDO_MAY_COALESCE               => 1,
    SCVS_NONE                       => 0,
    SCVS_RECTANGULARSELECTION       => 1,
    SCVS_USERACCESSIBLE             => 2,
    KEYWORDSET_MAX                  => 8,
    MOD_INSERTTEXT                  => 0x1,
    MOD_DELETETEXT                  => 0x2,
    MOD_CHANGESTYLE                 => 0x4,
    MOD_CHANGEFOLD                  => 0x8,
    PERFORMED_USER                  => 0x10,
    PERFORMED_UNDO                  => 0x20,
    PERFORMED_REDO                  => 0x40,
    MULTISTEPUNDOREDO               => 0x80,
    LASTSTEPINUNDOREDO              => 0x100,
    MOD_CHANGEMARKER                => 0x200,
    MOD_BEFOREINSERT                => 0x400,
    MOD_BEFOREDELETE                => 0x800,
    MULTILINEUNDOREDO               => 0x1000,
    STARTACTION                     => 0x2000,
    MOD_CHANGEINDICATOR             => 0x4000,
    MOD_CHANGELINESTATE             => 0x8000,
    MOD_CHANGEMARGIN                => 0x10000,
    MOD_CHANGEANNOTATION            => 0x20000,
    MOD_CONTAINER                   => 0x40000,
    MODEVENTMASKALL                 => 0x7FFFF,
    KEY_DOWN                        => 300,
    KEY_UP                          => 301,
    KEY_LEFT                        => 302,
    KEY_RIGHT                       => 303,
    KEY_HOME                        => 304,
    KEY_END                         => 305,
    KEY_PRIOR                       => 306,
    KEY_NEXT                        => 307,
    KEY_DELETE                      => 308,
    KEY_INSERT                      => 309,
    KEY_ESCAPE                      => 7,
    KEY_BACK                        => 8,
    KEY_TAB                         => 9,
    KEY_RETURN                      => 13,
    KEY_ADD                         => 310,
    KEY_SUBTRACT                    => 311,
    KEY_DIVIDE                      => 312,
    KEY_WIN                         => 313,
    KEY_RWIN                        => 314,
    KEY_MENU                        => 315,
    SCMOD_NORM                      => 0,
    SCMOD_SHIFT                     => 1,
    SCMOD_CTRL                      => 2,
    SCMOD_ALT                       => 4,
    SCMOD_SUPER                     => 8,
    LEX_CONTAINER                   => 0,
    LEX_NULL                        => 1,
    LEX_PYTHON                      => 2,
    LEX_CPP                         => 3,
    LEX_HTML                        => 4,
    LEX_XML                         => 5,
    LEX_PERL                        => 6,
    LEX_SQL                         => 7,
    LEX_VB                          => 8,
    LEX_PROPERTIES                  => 9,
    LEX_ERRORLIST                   => 10,
    LEX_MAKEFILE                    => 11,
    LEX_BATCH                       => 12,
    LEX_XCODE                       => 13,
    LEX_LATEX                       => 14,
    LEX_LUA                         => 15,
    LEX_DIFF                        => 16,
    LEX_CONF                        => 17,
    LEX_PASCAL                      => 18,
    LEX_AVE                         => 19,
    LEX_ADA                         => 20,
    LEX_LISP                        => 21,
    LEX_RUBY                        => 22,
    LEX_EIFFEL                      => 23,
    LEX_EIFFELKW                    => 24,
    LEX_TCL                         => 25,
    LEX_NNCRONTAB                   => 26,
    LEX_BULLANT                     => 27,
    LEX_VBSCRIPT                    => 28,
    LEX_BAAN                        => 31,
    LEX_MATLAB                      => 32,
    LEX_SCRIPTOL                    => 33,
    LEX_ASM                         => 34,
    LEX_CPPNOCASE                   => 35,
    LEX_FORTRAN                     => 36,
    LEX_F77                         => 37,
    LEX_CSS                         => 38,
    LEX_POV                         => 39,
    LEX_LOUT                        => 40,
    LEX_ESCRIPT                     => 41,
    LEX_PS                          => 42,
    LEX_NSIS                        => 43,
    LEX_MMIXAL                      => 44,
    LEX_CLW                         => 45,
    LEX_CLWNOCASE                   => 46,
    LEX_LOT                         => 47,
    LEX_YAML                        => 48,
    LEX_TEX                         => 49,
    LEX_METAPOST                    => 50,
    LEX_POWERBASIC                  => 51,
    LEX_FORTH                       => 52,
    LEX_ERLANG                      => 53,
    LEX_OCTAVE                      => 54,
    LEX_MSSQL                       => 55,
    LEX_VERILOG                     => 56,
    LEX_KIX                         => 57,
    LEX_GUI4CLI                     => 58,
    LEX_SPECMAN                     => 59,
    LEX_AU3                         => 60,
    LEX_APDL                        => 61,
    LEX_BASH                        => 62,
    LEX_ASN1                        => 63,
    LEX_VHDL                        => 64,
    LEX_CAML                        => 65,
    LEX_BLITZBASIC                  => 66,
    LEX_PUREBASIC                   => 67,
    LEX_HASKELL                     => 68,
    LEX_PHPSCRIPT                   => 69,
    LEX_TADS3                       => 70,
    LEX_REBOL                       => 71,
    LEX_SMALLTALK                   => 72,
    LEX_FLAGSHIP                    => 73,
    LEX_CSOUND                      => 74,
    LEX_FREEBASIC                   => 75,
    LEX_INNOSETUP                   => 76,
    LEX_OPAL                        => 77,
    LEX_SPICE                       => 78,
    LEX_D                           => 79,
    LEX_CMAKE                       => 80,
    LEX_GAP                         => 81,
    LEX_PLM                         => 82,
    LEX_PROGRESS                    => 83,
    LEX_ABAQUS                      => 84,
    LEX_ASYMPTOTE                   => 85,
    LEX_R                           => 86,
    LEX_MAGIK                       => 87,
    LEX_POWERSHELL                  => 88,
    LEX_MYSQL                       => 89,
    LEX_PO                          => 90,
    LEX_TAL                         => 91,
    LEX_COBOL                       => 92,
    LEX_TACL                        => 93,
    LEX_SORCUS                      => 94,
    LEX_POWERPRO                    => 95,
    LEX_NIMROD                      => 96,
    LEX_SML                         => 97,
    LEX_MARKDOWN                    => 98,
    LEX_AUTOMATIC                   => 1000,
    P_DEFAULT                       => 0,
    P_COMMENTLINE                   => 1,
    P_NUMBER                        => 2,
    P_STRING                        => 3,
    P_CHARACTER                     => 4,
    P_WORD                          => 5,
    P_TRIPLE                        => 6,
    P_TRIPLEDOUBLE                  => 7,
    P_CLASSNAME                     => 8,
    P_DEFNAME                       => 9,
    P_OPERATOR                      => 10,
    P_IDENTIFIER                    => 11,
    P_COMMENTBLOCK                  => 12,
    P_STRINGEOL                     => 13,
    P_WORD2                         => 14,
    P_DECORATOR                     => 15,
    C_DEFAULT                       => 0,
    C_COMMENT                       => 1,
    C_COMMENTLINE                   => 2,
    C_COMMENTDOC                    => 3,
    C_NUMBER                        => 4,
    C_WORD                          => 5,
    C_STRING                        => 6,
    C_CHARACTER                     => 7,
    C_UUID                          => 8,
    C_PREPROCESSOR                  => 9,
    C_OPERATOR                      => 10,
    C_IDENTIFIER                    => 11,
    C_STRINGEOL                     => 12,
    C_VERBATIM                      => 13,
    C_REGEX                         => 14,
    C_COMMENTLINEDOC                => 15,
    C_WORD2                         => 16,
    C_COMMENTDOCKEYWORD             => 17,
    C_COMMENTDOCKEYWORDERROR        => 18,
    C_GLOBALCLASS                   => 19,
    D_DEFAULT                       => 0,
    D_COMMENT                       => 1,
    D_COMMENTLINE                   => 2,
    D_COMMENTDOC                    => 3,
    D_COMMENTNESTED                 => 4,
    D_NUMBER                        => 5,
    D_WORD                          => 6,
    D_WORD2                         => 7,
    D_WORD3                         => 8,
    D_TYPEDEF                       => 9,
    D_STRING                        => 10,
    D_STRINGEOL                     => 11,
    D_CHARACTER                     => 12,
    D_OPERATOR                      => 13,
    D_IDENTIFIER                    => 14,
    D_COMMENTLINEDOC                => 15,
    D_COMMENTDOCKEYWORD             => 16,
    D_COMMENTDOCKEYWORDERROR        => 17,
    D_STRINGB                       => 18,
    D_STRINGR                       => 19,
    D_WORD5                         => 20,
    D_WORD6                         => 21,
    D_WORD7                         => 22,
    TCL_DEFAULT                     => 0,
    TCL_COMMENT                     => 1,
    TCL_COMMENTLINE                 => 2,
    TCL_NUMBER                      => 3,
    TCL_WORD_IN_QUOTE               => 4,
    TCL_IN_QUOTE                    => 5,
    TCL_OPERATOR                    => 6,
    TCL_IDENTIFIER                  => 7,
    TCL_SUBSTITUTION                => 8,
    TCL_SUB_BRACE                   => 9,
    TCL_MODIFIER                    => 10,
    TCL_EXPAND                      => 11,
    TCL_WORD                        => 12,
    TCL_WORD2                       => 13,
    TCL_WORD3                       => 14,
    TCL_WORD4                       => 15,
    TCL_WORD5                       => 16,
    TCL_WORD6                       => 17,
    TCL_WORD7                       => 18,
    TCL_WORD8                       => 19,
    TCL_COMMENT_BOX                 => 20,
    TCL_BLOCK_COMMENT               => 21,
    H_DEFAULT                       => 0,
    H_TAG                           => 1,
    H_TAGUNKNOWN                    => 2,
    H_ATTRIBUTE                     => 3,
    H_ATTRIBUTEUNKNOWN              => 4,
    H_NUMBER                        => 5,
    H_DOUBLESTRING                  => 6,
    H_SINGLESTRING                  => 7,
    H_OTHER                         => 8,
    H_COMMENT                       => 9,
    H_ENTITY                        => 10,
    H_TAGEND                        => 11,
    H_XMLSTART                      => 12,
    H_XMLEND                        => 13,
    H_SCRIPT                        => 14,
    H_ASP                           => 15,
    H_ASPAT                         => 16,
    H_CDATA                         => 17,
    H_QUESTION                      => 18,
    H_VALUE                         => 19,
    H_XCCOMMENT                     => 20,
    H_SGML_DEFAULT                  => 21,
    H_SGML_COMMAND                  => 22,
    H_SGML_1ST_PARAM                => 23,
    H_SGML_DOUBLESTRING             => 24,
    H_SGML_SIMPLESTRING             => 25,
    H_SGML_ERROR                    => 26,
    H_SGML_SPECIAL                  => 27,
    H_SGML_ENTITY                   => 28,
    H_SGML_COMMENT                  => 29,
    H_SGML_1ST_PARAM_COMMENT        => 30,
    H_SGML_BLOCK_DEFAULT            => 31,
    HJ_START                        => 40,
    HJ_DEFAULT                      => 41,
    HJ_COMMENT                      => 42,
    HJ_COMMENTLINE                  => 43,
    HJ_COMMENTDOC                   => 44,
    HJ_NUMBER                       => 45,
    HJ_WORD                         => 46,
    HJ_KEYWORD                      => 47,
    HJ_DOUBLESTRING                 => 48,
    HJ_SINGLESTRING                 => 49,
    HJ_SYMBOLS                      => 50,
    HJ_STRINGEOL                    => 51,
    HJ_REGEX                        => 52,
    HJA_START                       => 55,
    HJA_DEFAULT                     => 56,
    HJA_COMMENT                     => 57,
    HJA_COMMENTLINE                 => 58,
    HJA_COMMENTDOC                  => 59,
    HJA_NUMBER                      => 60,
    HJA_WORD                        => 61,
    HJA_KEYWORD                     => 62,
    HJA_DOUBLESTRING                => 63,
    HJA_SINGLESTRING                => 64,
    HJA_SYMBOLS                     => 65,
    HJA_STRINGEOL                   => 66,
    HJA_REGEX                       => 67,
    HB_START                        => 70,
    HB_DEFAULT                      => 71,
    HB_COMMENTLINE                  => 72,
    HB_NUMBER                       => 73,
    HB_WORD                         => 74,
    HB_STRING                       => 75,
    HB_IDENTIFIER                   => 76,
    HB_STRINGEOL                    => 77,
    HBA_START                       => 80,
    HBA_DEFAULT                     => 81,
    HBA_COMMENTLINE                 => 82,
    HBA_NUMBER                      => 83,
    HBA_WORD                        => 84,
    HBA_STRING                      => 85,
    HBA_IDENTIFIER                  => 86,
    HBA_STRINGEOL                   => 87,
    HP_START                        => 90,
    HP_DEFAULT                      => 91,
    HP_COMMENTLINE                  => 92,
    HP_NUMBER                       => 93,
    HP_STRING                       => 94,
    HP_CHARACTER                    => 95,
    HP_WORD                         => 96,
    HP_TRIPLE                       => 97,
    HP_TRIPLEDOUBLE                 => 98,
    HP_CLASSNAME                    => 99,
    HP_DEFNAME                      => 100,
    HP_OPERATOR                     => 101,
    HP_IDENTIFIER                   => 102,
    HPHP_COMPLEX_VARIABLE           => 104,
    HPA_START                       => 105,
    HPA_DEFAULT                     => 106,
    HPA_COMMENTLINE                 => 107,
    HPA_NUMBER                      => 108,
    HPA_STRING                      => 109,
    HPA_CHARACTER                   => 110,
    HPA_WORD                        => 111,
    HPA_TRIPLE                      => 112,
    HPA_TRIPLEDOUBLE                => 113,
    HPA_CLASSNAME                   => 114,
    HPA_DEFNAME                     => 115,
    HPA_OPERATOR                    => 116,
    HPA_IDENTIFIER                  => 117,
    HPHP_DEFAULT                    => 118,
    HPHP_HSTRING                    => 119,
    HPHP_SIMPLESTRING               => 120,
    HPHP_WORD                       => 121,
    HPHP_NUMBER                     => 122,
    HPHP_VARIABLE                   => 123,
    HPHP_COMMENT                    => 124,
    HPHP_COMMENTLINE                => 125,
    HPHP_HSTRING_VARIABLE           => 126,
    HPHP_OPERATOR                   => 127,
    PL_DEFAULT                      => 0,
    PL_ERROR                        => 1,
    PL_COMMENTLINE                  => 2,
    PL_POD                          => 3,
    PL_NUMBER                       => 4,
    PL_WORD                         => 5,
    PL_STRING                       => 6,
    PL_CHARACTER                    => 7,
    PL_PUNCTUATION                  => 8,
    PL_PREPROCESSOR                 => 9,
    PL_OPERATOR                     => 10,
    PL_IDENTIFIER                   => 11,
    PL_SCALAR                       => 12,
    PL_ARRAY                        => 13,
    PL_HASH                         => 14,
    PL_SYMBOLTABLE                  => 15,
    PL_VARIABLE_INDEXER             => 16,
    PL_REGEX                        => 17,
    PL_REGSUBST                     => 18,
    PL_LONGQUOTE                    => 19,
    PL_BACKTICKS                    => 20,
    PL_DATASECTION                  => 21,
    PL_HERE_DELIM                   => 22,
    PL_HERE_Q                       => 23,
    PL_HERE_QQ                      => 24,
    PL_HERE_QX                      => 25,
    PL_STRING_Q                     => 26,
    PL_STRING_QQ                    => 27,
    PL_STRING_QX                    => 28,
    PL_STRING_QR                    => 29,
    PL_STRING_QW                    => 30,
    PL_POD_VERB                     => 31,
    PL_SUB_PROTOTYPE                => 40,
    PL_FORMAT_IDENT                 => 41,
    PL_FORMAT                       => 42,
    PL_STRING_VAR                   => 43,
    PL_XLAT                         => 44,
    PL_REGEX_VAR                    => 54,
    PL_REGSUBST_VAR                 => 55,
    PL_BACKTICKS_VAR                => 57,
    PL_HERE_QQ_VAR                  => 61,
    PL_HERE_QX_VAR                  => 62,
    PL_STRING_QQ_VAR                => 64,
    PL_STRING_QX_VAR                => 65,
    PL_STRING_QR_VAR                => 66,
    RB_DEFAULT                      => 0,
    RB_ERROR                        => 1,
    RB_COMMENTLINE                  => 2,
    RB_POD                          => 3,
    RB_NUMBER                       => 4,
    RB_WORD                         => 5,
    RB_STRING                       => 6,
    RB_CHARACTER                    => 7,
    RB_CLASSNAME                    => 8,
    RB_DEFNAME                      => 9,
    RB_OPERATOR                     => 10,
    RB_IDENTIFIER                   => 11,
    RB_REGEX                        => 12,
    RB_GLOBAL                       => 13,
    RB_SYMBOL                       => 14,
    RB_MODULE_NAME                  => 15,
    RB_INSTANCE_VAR                 => 16,
    RB_CLASS_VAR                    => 17,
    RB_BACKTICKS                    => 18,
    RB_DATASECTION                  => 19,
    RB_HERE_DELIM                   => 20,
    RB_HERE_Q                       => 21,
    RB_HERE_QQ                      => 22,
    RB_HERE_QX                      => 23,
    RB_STRING_Q                     => 24,
    RB_STRING_QQ                    => 25,
    RB_STRING_QX                    => 26,
    RB_STRING_QR                    => 27,
    RB_STRING_QW                    => 28,
    RB_WORD_DEMOTED                 => 29,
    RB_STDIN                        => 30,
    RB_STDOUT                       => 31,
    RB_STDERR                       => 40,
    RB_UPPER_BOUND                  => 41,
    B_DEFAULT                       => 0,
    B_COMMENT                       => 1,
    B_NUMBER                        => 2,
    B_KEYWORD                       => 3,
    B_STRING                        => 4,
    B_PREPROCESSOR                  => 5,
    B_OPERATOR                      => 6,
    B_IDENTIFIER                    => 7,
    B_DATE                          => 8,
    B_STRINGEOL                     => 9,
    B_KEYWORD2                      => 10,
    B_KEYWORD3                      => 11,
    B_KEYWORD4                      => 12,
    B_CONSTANT                      => 13,
    B_ASM                           => 14,
    B_LABEL                         => 15,
    B_ERROR                         => 16,
    B_HEXNUMBER                     => 17,
    B_BINNUMBER                     => 18,
    PROPS_DEFAULT                   => 0,
    PROPS_COMMENT                   => 1,
    PROPS_SECTION                   => 2,
    PROPS_ASSIGNMENT                => 3,
    PROPS_DEFVAL                    => 4,
    PROPS_KEY                       => 5,
    L_DEFAULT                       => 0,
    L_COMMAND                       => 1,
    L_TAG                           => 2,
    L_MATH                          => 3,
    L_COMMENT                       => 4,
    LUA_DEFAULT                     => 0,
    LUA_COMMENT                     => 1,
    LUA_COMMENTLINE                 => 2,
    LUA_COMMENTDOC                  => 3,
    LUA_NUMBER                      => 4,
    LUA_WORD                        => 5,
    LUA_STRING                      => 6,
    LUA_CHARACTER                   => 7,
    LUA_LITERALSTRING               => 8,
    LUA_PREPROCESSOR                => 9,
    LUA_OPERATOR                    => 10,
    LUA_IDENTIFIER                  => 11,
    LUA_STRINGEOL                   => 12,
    LUA_WORD2                       => 13,
    LUA_WORD3                       => 14,
    LUA_WORD4                       => 15,
    LUA_WORD5                       => 16,
    LUA_WORD6                       => 17,
    LUA_WORD7                       => 18,
    LUA_WORD8                       => 19,
    ERR_DEFAULT                     => 0,
    ERR_PYTHON                      => 1,
    ERR_GCC                         => 2,
    ERR_MS                          => 3,
    ERR_CMD                         => 4,
    ERR_BORLAND                     => 5,
    ERR_PERL                        => 6,
    ERR_NET                         => 7,
    ERR_LUA                         => 8,
    ERR_CTAG                        => 9,
    ERR_DIFF_CHANGED                => 10,
    ERR_DIFF_ADDITION               => 11,
    ERR_DIFF_DELETION               => 12,
    ERR_DIFF_MESSAGE                => 13,
    ERR_PHP                         => 14,
    ERR_ELF                         => 15,
    ERR_IFC                         => 16,
    ERR_IFORT                       => 17,
    ERR_ABSF                        => 18,
    ERR_TIDY                        => 19,
    ERR_JAVA_STACK                  => 20,
    ERR_VALUE                       => 21,
    BAT_DEFAULT                     => 0,
    BAT_COMMENT                     => 1,
    BAT_WORD                        => 2,
    BAT_LABEL                       => 3,
    BAT_HIDE                        => 4,
    BAT_COMMAND                     => 5,
    BAT_IDENTIFIER                  => 6,
    BAT_OPERATOR                    => 7,
    MAKE_DEFAULT                    => 0,
    MAKE_COMMENT                    => 1,
    MAKE_PREPROCESSOR               => 2,
    MAKE_IDENTIFIER                 => 3,
    MAKE_OPERATOR                   => 4,
    MAKE_TARGET                     => 5,
    MAKE_IDEOL                      => 9,
    DIFF_DEFAULT                    => 0,
    DIFF_COMMENT                    => 1,
    DIFF_COMMAND                    => 2,
    DIFF_HEADER                     => 3,
    DIFF_POSITION                   => 4,
    DIFF_DELETED                    => 5,
    DIFF_ADDED                      => 6,
    DIFF_CHANGED                    => 7,
    CONF_DEFAULT                    => 0,
    CONF_COMMENT                    => 1,
    CONF_NUMBER                     => 2,
    CONF_IDENTIFIER                 => 3,
    CONF_EXTENSION                  => 4,
    CONF_PARAMETER                  => 5,
    CONF_STRING                     => 6,
    CONF_OPERATOR                   => 7,
    CONF_IP                         => 8,
    CONF_DIRECTIVE                  => 9,
    AVE_DEFAULT                     => 0,
    AVE_COMMENT                     => 1,
    AVE_NUMBER                      => 2,
    AVE_WORD                        => 3,
    AVE_STRING                      => 6,
    AVE_ENUM                        => 7,
    AVE_STRINGEOL                   => 8,
    AVE_IDENTIFIER                  => 9,
    AVE_OPERATOR                    => 10,
    AVE_WORD1                       => 11,
    AVE_WORD2                       => 12,
    AVE_WORD3                       => 13,
    AVE_WORD4                       => 14,
    AVE_WORD5                       => 15,
    AVE_WORD6                       => 16,
    ADA_DEFAULT                     => 0,
    ADA_WORD                        => 1,
    ADA_IDENTIFIER                  => 2,
    ADA_NUMBER                      => 3,
    ADA_DELIMITER                   => 4,
    ADA_CHARACTER                   => 5,
    ADA_CHARACTEREOL                => 6,
    ADA_STRING                      => 7,
    ADA_STRINGEOL                   => 8,
    ADA_LABEL                       => 9,
    ADA_COMMENTLINE                 => 10,
    ADA_ILLEGAL                     => 11,
    BAAN_DEFAULT                    => 0,
    BAAN_COMMENT                    => 1,
    BAAN_COMMENTDOC                 => 2,
    BAAN_NUMBER                     => 3,
    BAAN_WORD                       => 4,
    BAAN_STRING                     => 5,
    BAAN_PREPROCESSOR               => 6,
    BAAN_OPERATOR                   => 7,
    BAAN_IDENTIFIER                 => 8,
    BAAN_STRINGEOL                  => 9,
    BAAN_WORD2                      => 10,
    LISP_DEFAULT                    => 0,
    LISP_COMMENT                    => 1,
    LISP_NUMBER                     => 2,
    LISP_KEYWORD                    => 3,
    LISP_KEYWORD_KW                 => 4,
    LISP_SYMBOL                     => 5,
    LISP_STRING                     => 6,
    LISP_STRINGEOL                  => 8,
    LISP_IDENTIFIER                 => 9,
    LISP_OPERATOR                   => 10,
    LISP_SPECIAL                    => 11,
    LISP_MULTI_COMMENT              => 12,
    EIFFEL_DEFAULT                  => 0,
    EIFFEL_COMMENTLINE              => 1,
    EIFFEL_NUMBER                   => 2,
    EIFFEL_WORD                     => 3,
    EIFFEL_STRING                   => 4,
    EIFFEL_CHARACTER                => 5,
    EIFFEL_OPERATOR                 => 6,
    EIFFEL_IDENTIFIER               => 7,
    EIFFEL_STRINGEOL                => 8,
    NNCRONTAB_DEFAULT               => 0,
    NNCRONTAB_COMMENT               => 1,
    NNCRONTAB_TASK                  => 2,
    NNCRONTAB_SECTION               => 3,
    NNCRONTAB_KEYWORD               => 4,
    NNCRONTAB_MODIFIER              => 5,
    NNCRONTAB_ASTERISK              => 6,
    NNCRONTAB_NUMBER                => 7,
    NNCRONTAB_STRING                => 8,
    NNCRONTAB_ENVIRONMENT           => 9,
    NNCRONTAB_IDENTIFIER            => 10,
    FORTH_DEFAULT                   => 0,
    FORTH_COMMENT                   => 1,
    FORTH_COMMENT_ML                => 2,
    FORTH_IDENTIFIER                => 3,
    FORTH_CONTROL                   => 4,
    FORTH_KEYWORD                   => 5,
    FORTH_DEFWORD                   => 6,
    FORTH_PREWORD1                  => 7,
    FORTH_PREWORD2                  => 8,
    FORTH_NUMBER                    => 9,
    FORTH_STRING                    => 10,
    FORTH_LOCALE                    => 11,
    MATLAB_DEFAULT                  => 0,
    MATLAB_COMMENT                  => 1,
    MATLAB_COMMAND                  => 2,
    MATLAB_NUMBER                   => 3,
    MATLAB_KEYWORD                  => 4,
    MATLAB_STRING                   => 5,
    MATLAB_OPERATOR                 => 6,
    MATLAB_IDENTIFIER               => 7,
    MATLAB_DOUBLEQUOTESTRING        => 8,
    SCRIPTOL_DEFAULT                => 0,
    SCRIPTOL_WHITE                  => 1,
    SCRIPTOL_COMMENTLINE            => 2,
    SCRIPTOL_PERSISTENT             => 3,
    SCRIPTOL_CSTYLE                 => 4,
    SCRIPTOL_COMMENTBLOCK           => 5,
    SCRIPTOL_NUMBER                 => 6,
    SCRIPTOL_STRING                 => 7,
    SCRIPTOL_CHARACTER              => 8,
    SCRIPTOL_STRINGEOL              => 9,
    SCRIPTOL_KEYWORD                => 10,
    SCRIPTOL_OPERATOR               => 11,
    SCRIPTOL_IDENTIFIER             => 12,
    SCRIPTOL_TRIPLE                 => 13,
    SCRIPTOL_CLASSNAME              => 14,
    SCRIPTOL_PREPROCESSOR           => 15,
    ASM_DEFAULT                     => 0,
    ASM_COMMENT                     => 1,
    ASM_NUMBER                      => 2,
    ASM_STRING                      => 3,
    ASM_OPERATOR                    => 4,
    ASM_IDENTIFIER                  => 5,
    ASM_CPUINSTRUCTION              => 6,
    ASM_MATHINSTRUCTION             => 7,
    ASM_REGISTER                    => 8,
    ASM_DIRECTIVE                   => 9,
    ASM_DIRECTIVEOPERAND            => 10,
    ASM_COMMENTBLOCK                => 11,
    ASM_CHARACTER                   => 12,
    ASM_STRINGEOL                   => 13,
    ASM_EXTINSTRUCTION              => 14,
    F_DEFAULT                       => 0,
    F_COMMENT                       => 1,
    F_NUMBER                        => 2,
    F_STRING1                       => 3,
    F_STRING2                       => 4,
    F_STRINGEOL                     => 5,
    F_OPERATOR                      => 6,
    F_IDENTIFIER                    => 7,
    F_WORD                          => 8,
    F_WORD2                         => 9,
    F_WORD3                         => 10,
    F_PREPROCESSOR                  => 11,
    F_OPERATOR2                     => 12,
    F_LABEL                         => 13,
    F_CONTINUATION                  => 14,
    CSS_DEFAULT                     => 0,
    CSS_TAG                         => 1,
    CSS_CLASS                       => 2,
    CSS_PSEUDOCLASS                 => 3,
    CSS_UNKNOWN_PSEUDOCLASS         => 4,
    CSS_OPERATOR                    => 5,
    CSS_IDENTIFIER                  => 6,
    CSS_UNKNOWN_IDENTIFIER          => 7,
    CSS_VALUE                       => 8,
    CSS_COMMENT                     => 9,
    CSS_ID                          => 10,
    CSS_IMPORTANT                   => 11,
    CSS_DIRECTIVE                   => 12,
    CSS_DOUBLESTRING                => 13,
    CSS_SINGLESTRING                => 14,
    CSS_IDENTIFIER2                 => 15,
    CSS_ATTRIBUTE                   => 16,
    CSS_IDENTIFIER3                 => 17,
    CSS_PSEUDOELEMENT               => 18,
    CSS_EXTENDED_IDENTIFIER         => 19,
    CSS_EXTENDED_PSEUDOCLASS        => 20,
    CSS_EXTENDED_PSEUDOELEMENT      => 21,
    POV_DEFAULT                     => 0,
    POV_COMMENT                     => 1,
    POV_COMMENTLINE                 => 2,
    POV_NUMBER                      => 3,
    POV_OPERATOR                    => 4,
    POV_IDENTIFIER                  => 5,
    POV_STRING                      => 6,
    POV_STRINGEOL                   => 7,
    POV_DIRECTIVE                   => 8,
    POV_BADDIRECTIVE                => 9,
    POV_WORD2                       => 10,
    POV_WORD3                       => 11,
    POV_WORD4                       => 12,
    POV_WORD5                       => 13,
    POV_WORD6                       => 14,
    POV_WORD7                       => 15,
    POV_WORD8                       => 16,
    LOUT_DEFAULT                    => 0,
    LOUT_COMMENT                    => 1,
    LOUT_NUMBER                     => 2,
    LOUT_WORD                       => 3,
    LOUT_WORD2                      => 4,
    LOUT_WORD3                      => 5,
    LOUT_WORD4                      => 6,
    LOUT_STRING                     => 7,
    LOUT_OPERATOR                   => 8,
    LOUT_IDENTIFIER                 => 9,
    LOUT_STRINGEOL                  => 10,
    ESCRIPT_DEFAULT                 => 0,
    ESCRIPT_COMMENT                 => 1,
    ESCRIPT_COMMENTLINE             => 2,
    ESCRIPT_COMMENTDOC              => 3,
    ESCRIPT_NUMBER                  => 4,
    ESCRIPT_WORD                    => 5,
    ESCRIPT_STRING                  => 6,
    ESCRIPT_OPERATOR                => 7,
    ESCRIPT_IDENTIFIER              => 8,
    ESCRIPT_BRACE                   => 9,
    ESCRIPT_WORD2                   => 10,
    ESCRIPT_WORD3                   => 11,
    PS_DEFAULT                      => 0,
    PS_COMMENT                      => 1,
    PS_DSC_COMMENT                  => 2,
    PS_DSC_VALUE                    => 3,
    PS_NUMBER                       => 4,
    PS_NAME                         => 5,
    PS_KEYWORD                      => 6,
    PS_LITERAL                      => 7,
    PS_IMMEVAL                      => 8,
    PS_PAREN_ARRAY                  => 9,
    PS_PAREN_DICT                   => 10,
    PS_PAREN_PROC                   => 11,
    PS_TEXT                         => 12,
    PS_HEXSTRING                    => 13,
    PS_BASE85STRING                 => 14,
    PS_BADSTRINGCHAR                => 15,
    NSIS_DEFAULT                    => 0,
    NSIS_COMMENT                    => 1,
    NSIS_STRINGDQ                   => 2,
    NSIS_STRINGLQ                   => 3,
    NSIS_STRINGRQ                   => 4,
    NSIS_FUNCTION                   => 5,
    NSIS_VARIABLE                   => 6,
    NSIS_LABEL                      => 7,
    NSIS_USERDEFINED                => 8,
    NSIS_SECTIONDEF                 => 9,
    NSIS_SUBSECTIONDEF              => 10,
    NSIS_IFDEFINEDEF                => 11,
    NSIS_MACRODEF                   => 12,
    NSIS_STRINGVAR                  => 13,
    NSIS_NUMBER                     => 14,
    NSIS_SECTIONGROUP               => 15,
    NSIS_PAGEEX                     => 16,
    NSIS_FUNCTIONDEF                => 17,
    NSIS_COMMENTBOX                 => 18,
    MMIXAL_LEADWS                   => 0,
    MMIXAL_COMMENT                  => 1,
    MMIXAL_LABEL                    => 2,
    MMIXAL_OPCODE                   => 3,
    MMIXAL_OPCODE_PRE               => 4,
    MMIXAL_OPCODE_VALID             => 5,
    MMIXAL_OPCODE_UNKNOWN           => 6,
    MMIXAL_OPCODE_POST              => 7,
    MMIXAL_OPERANDS                 => 8,
    MMIXAL_NUMBER                   => 9,
    MMIXAL_REF                      => 10,
    MMIXAL_CHAR                     => 11,
    MMIXAL_STRING                   => 12,
    MMIXAL_REGISTER                 => 13,
    MMIXAL_HEX                      => 14,
    MMIXAL_OPERATOR                 => 15,
    MMIXAL_SYMBOL                   => 16,
    MMIXAL_INCLUDE                  => 17,
    CLW_DEFAULT                     => 0,
    CLW_LABEL                       => 1,
    CLW_COMMENT                     => 2,
    CLW_STRING                      => 3,
    CLW_USER_IDENTIFIER             => 4,
    CLW_INTEGER_CONSTANT            => 5,
    CLW_REAL_CONSTANT               => 6,
    CLW_PICTURE_STRING              => 7,
    CLW_KEYWORD                     => 8,
    CLW_COMPILER_DIRECTIVE          => 9,
    CLW_RUNTIME_EXPRESSIONS         => 10,
    CLW_BUILTIN_PROCEDURES_FUNCTION => 11,
    CLW_STRUCTURE_DATA_TYPE         => 12,
    CLW_ATTRIBUTE                   => 13,
    CLW_STANDARD_EQUATE             => 14,
    CLW_ERROR                       => 15,
    CLW_DEPRECATED                  => 16,
    LOT_DEFAULT                     => 0,
    LOT_HEADER                      => 1,
    LOT_BREAK                       => 2,
    LOT_SET                         => 3,
    LOT_PASS                        => 4,
    LOT_FAIL                        => 5,
    LOT_ABORT                       => 6,
    YAML_DEFAULT                    => 0,
    YAML_COMMENT                    => 1,
    YAML_IDENTIFIER                 => 2,
    YAML_KEYWORD                    => 3,
    YAML_NUMBER                     => 4,
    YAML_REFERENCE                  => 5,
    YAML_DOCUMENT                   => 6,
    YAML_TEXT                       => 7,
    YAML_ERROR                      => 8,
    YAML_OPERATOR                   => 9,
    TEX_DEFAULT                     => 0,
    TEX_SPECIAL                     => 1,
    TEX_GROUP                       => 2,
    TEX_SYMBOL                      => 3,
    TEX_COMMAND                     => 4,
    TEX_TEXT                        => 5,
    METAPOST_DEFAULT                => 0,
    METAPOST_SPECIAL                => 1,
    METAPOST_GROUP                  => 2,
    METAPOST_SYMBOL                 => 3,
    METAPOST_COMMAND                => 4,
    METAPOST_TEXT                   => 5,
    METAPOST_EXTRA                  => 6,
    ERLANG_DEFAULT                  => 0,
    ERLANG_COMMENT                  => 1,
    ERLANG_VARIABLE                 => 2,
    ERLANG_NUMBER                   => 3,
    ERLANG_KEYWORD                  => 4,
    ERLANG_STRING                   => 5,
    ERLANG_OPERATOR                 => 6,
    ERLANG_ATOM                     => 7,
    ERLANG_FUNCTION_NAME            => 8,
    ERLANG_CHARACTER                => 9,
    ERLANG_MACRO                    => 10,
    ERLANG_RECORD                   => 11,
    ERLANG_PREPROC                  => 12,
    ERLANG_NODE_NAME                => 13,
    ERLANG_COMMENT_FUNCTION         => 14,
    ERLANG_COMMENT_MODULE           => 15,
    ERLANG_COMMENT_DOC              => 16,
    ERLANG_COMMENT_DOC_MACRO        => 17,
    ERLANG_ATOM_QUOTED              => 18,
    ERLANG_MACRO_QUOTED             => 19,
    ERLANG_RECORD_QUOTED            => 20,
    ERLANG_NODE_NAME_QUOTED         => 21,
    ERLANG_BIFS                     => 22,
    ERLANG_MODULES                  => 23,
    ERLANG_MODULES_ATT              => 24,
    ERLANG_UNKNOWN                  => 31,
    MSSQL_DEFAULT                   => 0,
    MSSQL_COMMENT                   => 1,
    MSSQL_LINE_COMMENT              => 2,
    MSSQL_NUMBER                    => 3,
    MSSQL_STRING                    => 4,
    MSSQL_OPERATOR                  => 5,
    MSSQL_IDENTIFIER                => 6,
    MSSQL_VARIABLE                  => 7,
    MSSQL_COLUMN_NAME               => 8,
    MSSQL_STATEMENT                 => 9,
    MSSQL_DATATYPE                  => 10,
    MSSQL_SYSTABLE                  => 11,
    MSSQL_GLOBAL_VARIABLE           => 12,
    MSSQL_FUNCTION                  => 13,
    MSSQL_STORED_PROCEDURE          => 14,
    MSSQL_DEFAULT_PREF_DATATYPE     => 15,
    MSSQL_COLUMN_NAME_2             => 16,
    V_DEFAULT                       => 0,
    V_COMMENT                       => 1,
    V_COMMENTLINE                   => 2,
    V_COMMENTLINEBANG               => 3,
    V_NUMBER                        => 4,
    V_WORD                          => 5,
    V_STRING                        => 6,
    V_WORD2                         => 7,
    V_WORD3                         => 8,
    V_PREPROCESSOR                  => 9,
    V_OPERATOR                      => 10,
    V_IDENTIFIER                    => 11,
    V_STRINGEOL                     => 12,
    V_USER                          => 19,
    KIX_DEFAULT                     => 0,
    KIX_COMMENT                     => 1,
    KIX_STRING1                     => 2,
    KIX_STRING2                     => 3,
    KIX_NUMBER                      => 4,
    KIX_VAR                         => 5,
    KIX_MACRO                       => 6,
    KIX_KEYWORD                     => 7,
    KIX_FUNCTIONS                   => 8,
    KIX_OPERATOR                    => 9,
    KIX_IDENTIFIER                  => 31,
    GC_DEFAULT                      => 0,
    GC_COMMENTLINE                  => 1,
    GC_COMMENTBLOCK                 => 2,
    GC_GLOBAL                       => 3,
    GC_EVENT                        => 4,
    GC_ATTRIBUTE                    => 5,
    GC_CONTROL                      => 6,
    GC_COMMAND                      => 7,
    GC_STRING                       => 8,
    GC_OPERATOR                     => 9,
    SN_DEFAULT                      => 0,
    SN_CODE                         => 1,
    SN_COMMENTLINE                  => 2,
    SN_COMMENTLINEBANG              => 3,
    SN_NUMBER                       => 4,
    SN_WORD                         => 5,
    SN_STRING                       => 6,
    SN_WORD2                        => 7,
    SN_WORD3                        => 8,
    SN_PREPROCESSOR                 => 9,
    SN_OPERATOR                     => 10,
    SN_IDENTIFIER                   => 11,
    SN_STRINGEOL                    => 12,
    SN_REGEXTAG                     => 13,
    SN_SIGNAL                       => 14,
    SN_USER                         => 19,
    AU3_DEFAULT                     => 0,
    AU3_COMMENT                     => 1,
    AU3_COMMENTBLOCK                => 2,
    AU3_NUMBER                      => 3,
    AU3_FUNCTION                    => 4,
    AU3_KEYWORD                     => 5,
    AU3_MACRO                       => 6,
    AU3_STRING                      => 7,
    AU3_OPERATOR                    => 8,
    AU3_VARIABLE                    => 9,
    AU3_SENT                        => 10,
    AU3_PREPROCESSOR                => 11,
    AU3_SPECIAL                     => 12,
    AU3_EXPAND                      => 13,
    AU3_COMOBJ                      => 14,
    AU3_UDF                         => 15,
    APDL_DEFAULT                    => 0,
    APDL_COMMENT                    => 1,
    APDL_COMMENTBLOCK               => 2,
    APDL_NUMBER                     => 3,
    APDL_STRING                     => 4,
    APDL_OPERATOR                   => 5,
    APDL_WORD                       => 6,
    APDL_PROCESSOR                  => 7,
    APDL_COMMAND                    => 8,
    APDL_SLASHCOMMAND               => 9,
    APDL_STARCOMMAND                => 10,
    APDL_ARGUMENT                   => 11,
    APDL_FUNCTION                   => 12,
    SH_DEFAULT                      => 0,
    SH_ERROR                        => 1,
    SH_COMMENTLINE                  => 2,
    SH_NUMBER                       => 3,
    SH_WORD                         => 4,
    SH_STRING                       => 5,
    SH_CHARACTER                    => 6,
    SH_OPERATOR                     => 7,
    SH_IDENTIFIER                   => 8,
    SH_SCALAR                       => 9,
    SH_PARAM                        => 10,
    SH_BACKTICKS                    => 11,
    SH_HERE_DELIM                   => 12,
    SH_HERE_Q                       => 13,
    ASN1_DEFAULT                    => 0,
    ASN1_COMMENT                    => 1,
    ASN1_IDENTIFIER                 => 2,
    ASN1_STRING                     => 3,
    ASN1_OID                        => 4,
    ASN1_SCALAR                     => 5,
    ASN1_KEYWORD                    => 6,
    ASN1_ATTRIBUTE                  => 7,
    ASN1_DESCRIPTOR                 => 8,
    ASN1_TYPE                       => 9,
    ASN1_OPERATOR                   => 10,
    VHDL_DEFAULT                    => 0,
    VHDL_COMMENT                    => 1,
    VHDL_COMMENTLINEBANG            => 2,
    VHDL_NUMBER                     => 3,
    VHDL_STRING                     => 4,
    VHDL_OPERATOR                   => 5,
    VHDL_IDENTIFIER                 => 6,
    VHDL_STRINGEOL                  => 7,
    VHDL_KEYWORD                    => 8,
    VHDL_STDOPERATOR                => 9,
    VHDL_ATTRIBUTE                  => 10,
    VHDL_STDFUNCTION                => 11,
    VHDL_STDPACKAGE                 => 12,
    VHDL_STDTYPE                    => 13,
    VHDL_USERWORD                   => 14,
    CAML_DEFAULT                    => 0,
    CAML_IDENTIFIER                 => 1,
    CAML_TAGNAME                    => 2,
    CAML_KEYWORD                    => 3,
    CAML_KEYWORD2                   => 4,
    CAML_KEYWORD3                   => 5,
    CAML_LINENUM                    => 6,
    CAML_OPERATOR                   => 7,
    CAML_NUMBER                     => 8,
    CAML_CHAR                       => 9,
    CAML_WHITE                      => 10,
    CAML_STRING                     => 11,
    CAML_COMMENT                    => 12,
    CAML_COMMENT1                   => 13,
    CAML_COMMENT2                   => 14,
    CAML_COMMENT3                   => 15,
    HA_DEFAULT                      => 0,
    HA_IDENTIFIER                   => 1,
    HA_KEYWORD                      => 2,
    HA_NUMBER                       => 3,
    HA_STRING                       => 4,
    HA_CHARACTER                    => 5,
    HA_CLASS                        => 6,
    HA_MODULE                       => 7,
    HA_CAPITAL                      => 8,
    HA_DATA                         => 9,
    HA_IMPORT                       => 10,
    HA_OPERATOR                     => 11,
    HA_INSTANCE                     => 12,
    HA_COMMENTLINE                  => 13,
    HA_COMMENTBLOCK                 => 14,
    HA_COMMENTBLOCK2                => 15,
    HA_COMMENTBLOCK3                => 16,
    T3_DEFAULT                      => 0,
    T3_X_DEFAULT                    => 1,
    T3_PREPROCESSOR                 => 2,
    T3_BLOCK_COMMENT                => 3,
    T3_LINE_COMMENT                 => 4,
    T3_OPERATOR                     => 5,
    T3_KEYWORD                      => 6,
    T3_NUMBER                       => 7,
    T3_IDENTIFIER                   => 8,
    T3_S_STRING                     => 9,
    T3_D_STRING                     => 10,
    T3_X_STRING                     => 11,
    T3_LIB_DIRECTIVE                => 12,
    T3_MSG_PARAM                    => 13,
    T3_HTML_TAG                     => 14,
    T3_HTML_DEFAULT                 => 15,
    T3_HTML_STRING                  => 16,
    T3_USER1                        => 17,
    T3_USER2                        => 18,
    T3_USER3                        => 19,
    T3_BRACE                        => 20,
    REBOL_DEFAULT                   => 0,
    REBOL_COMMENTLINE               => 1,
    REBOL_COMMENTBLOCK              => 2,
    REBOL_PREFACE                   => 3,
    REBOL_OPERATOR                  => 4,
    REBOL_CHARACTER                 => 5,
    REBOL_QUOTEDSTRING              => 6,
    REBOL_BRACEDSTRING              => 7,
    REBOL_NUMBER                    => 8,
    REBOL_PAIR                      => 9,
    REBOL_TUPLE                     => 10,
    REBOL_BINARY                    => 11,
    REBOL_MONEY                     => 12,
    REBOL_ISSUE                     => 13,
    REBOL_TAG                       => 14,
    REBOL_FILE                      => 15,
    REBOL_EMAIL                     => 16,
    REBOL_URL                       => 17,
    REBOL_DATE                      => 18,
    REBOL_TIME                      => 19,
    REBOL_IDENTIFIER                => 20,
    REBOL_WORD                      => 21,
    REBOL_WORD2                     => 22,
    REBOL_WORD3                     => 23,
    REBOL_WORD4                     => 24,
    REBOL_WORD5                     => 25,
    REBOL_WORD6                     => 26,
    REBOL_WORD7                     => 27,
    REBOL_WORD8                     => 28,
    SQL_DEFAULT                     => 0,
    SQL_COMMENT                     => 1,
    SQL_COMMENTLINE                 => 2,
    SQL_COMMENTDOC                  => 3,
    SQL_NUMBER                      => 4,
    SQL_WORD                        => 5,
    SQL_STRING                      => 6,
    SQL_CHARACTER                   => 7,
    SQL_SQLPLUS                     => 8,
    SQL_SQLPLUS_PROMPT              => 9,
    SQL_OPERATOR                    => 10,
    SQL_IDENTIFIER                  => 11,
    SQL_SQLPLUS_COMMENT             => 13,
    SQL_COMMENTLINEDOC              => 15,
    SQL_WORD2                       => 16,
    SQL_COMMENTDOCKEYWORD           => 17,
    SQL_COMMENTDOCKEYWORDERROR      => 18,
    SQL_USER1                       => 19,
    SQL_USER2                       => 20,
    SQL_USER3                       => 21,
    SQL_USER4                       => 22,
    SQL_QUOTEDIDENTIFIER            => 23,
    ST_DEFAULT                      => 0,
    ST_STRING                       => 1,
    ST_NUMBER                       => 2,
    ST_COMMENT                      => 3,
    ST_SYMBOL                       => 4,
    ST_BINARY                       => 5,
    ST_BOOL                         => 6,
    ST_SELF                         => 7,
    ST_SUPER                        => 8,
    ST_NIL                          => 9,
    ST_GLOBAL                       => 10,
    ST_RETURN                       => 11,
    ST_SPECIAL                      => 12,
    ST_KWSEND                       => 13,
    ST_ASSIGN                       => 14,
    ST_CHARACTER                    => 15,
    ST_SPEC_SEL                     => 16,
    FS_DEFAULT                      => 0,
    FS_COMMENT                      => 1,
    FS_COMMENTLINE                  => 2,
    FS_COMMENTDOC                   => 3,
    FS_COMMENTLINEDOC               => 4,
    FS_COMMENTDOCKEYWORD            => 5,
    FS_COMMENTDOCKEYWORDERROR       => 6,
    FS_KEYWORD                      => 7,
    FS_KEYWORD2                     => 8,
    FS_KEYWORD3                     => 9,
    FS_KEYWORD4                     => 10,
    FS_NUMBER                       => 11,
    FS_STRING                       => 12,
    FS_PREPROCESSOR                 => 13,
    FS_OPERATOR                     => 14,
    FS_IDENTIFIER                   => 15,
    FS_DATE                         => 16,
    FS_STRINGEOL                    => 17,
    FS_CONSTANT                     => 18,
    FS_ASM                          => 19,
    FS_LABEL                        => 20,
    FS_ERROR                        => 21,
    FS_HEXNUMBER                    => 22,
    FS_BINNUMBER                    => 23,
    CSOUND_DEFAULT                  => 0,
    CSOUND_COMMENT                  => 1,
    CSOUND_NUMBER                   => 2,
    CSOUND_OPERATOR                 => 3,
    CSOUND_INSTR                    => 4,
    CSOUND_IDENTIFIER               => 5,
    CSOUND_OPCODE                   => 6,
    CSOUND_HEADERSTMT               => 7,
    CSOUND_USERKEYWORD              => 8,
    CSOUND_COMMENTBLOCK             => 9,
    CSOUND_PARAM                    => 10,
    CSOUND_ARATE_VAR                => 11,
    CSOUND_KRATE_VAR                => 12,
    CSOUND_IRATE_VAR                => 13,
    CSOUND_GLOBAL_VAR               => 14,
    CSOUND_STRINGEOL                => 15,
    INNO_DEFAULT                    => 0,
    INNO_COMMENT                    => 1,
    INNO_KEYWORD                    => 2,
    INNO_PARAMETER                  => 3,
    INNO_SECTION                    => 4,
    INNO_PREPROC                    => 5,
    INNO_INLINE_EXPANSION           => 6,
    INNO_COMMENT_PASCAL             => 7,
    INNO_KEYWORD_PASCAL             => 8,
    INNO_KEYWORD_USER               => 9,
    INNO_STRING_DOUBLE              => 10,
    INNO_STRING_SINGLE              => 11,
    INNO_IDENTIFIER                 => 12,
    OPAL_SPACE                      => 0,
    OPAL_COMMENT_BLOCK              => 1,
    OPAL_COMMENT_LINE               => 2,
    OPAL_INTEGER                    => 3,
    OPAL_KEYWORD                    => 4,
    OPAL_SORT                       => 5,
    OPAL_STRING                     => 6,
    OPAL_PAR                        => 7,
    OPAL_BOOL_CONST                 => 8,
    OPAL_DEFAULT                    => 32,
    SPICE_DEFAULT                   => 0,
    SPICE_IDENTIFIER                => 1,
    SPICE_KEYWORD                   => 2,
    SPICE_KEYWORD2                  => 3,
    SPICE_KEYWORD3                  => 4,
    SPICE_NUMBER                    => 5,
    SPICE_DELIMITER                 => 6,
    SPICE_VALUE                     => 7,
    SPICE_COMMENTLINE               => 8,
    CMAKE_DEFAULT                   => 0,
    CMAKE_COMMENT                   => 1,
    CMAKE_STRINGDQ                  => 2,
    CMAKE_STRINGLQ                  => 3,
    CMAKE_STRINGRQ                  => 4,
    CMAKE_COMMANDS                  => 5,
    CMAKE_PARAMETERS                => 6,
    CMAKE_VARIABLE                  => 7,
    CMAKE_USERDEFINED               => 8,
    CMAKE_WHILEDEF                  => 9,
    CMAKE_FOREACHDEF                => 10,
    CMAKE_IFDEFINEDEF               => 11,
    CMAKE_MACRODEF                  => 12,
    CMAKE_STRINGVAR                 => 13,
    CMAKE_NUMBER                    => 14,
    GAP_DEFAULT                     => 0,
    GAP_IDENTIFIER                  => 1,
    GAP_KEYWORD                     => 2,
    GAP_KEYWORD2                    => 3,
    GAP_KEYWORD3                    => 4,
    GAP_KEYWORD4                    => 5,
    GAP_STRING                      => 6,
    GAP_CHAR                        => 7,
    GAP_OPERATOR                    => 8,
    GAP_COMMENT                     => 9,
    GAP_NUMBER                      => 10,
    GAP_STRINGEOL                   => 11,
    PLM_DEFAULT                     => 0,
    PLM_COMMENT                     => 1,
    PLM_STRING                      => 2,
    PLM_NUMBER                      => 3,
    PLM_IDENTIFIER                  => 4,
    PLM_OPERATOR                    => 5,
    PLM_CONTROL                     => 6,
    PLM_KEYWORD                     => 7,
    _4GL_DEFAULT                    => 0,
    _4GL_NUMBER                     => 1,
    _4GL_WORD                       => 2,
    _4GL_STRING                     => 3,
    _4GL_CHARACTER                  => 4,
    _4GL_PREPROCESSOR               => 5,
    _4GL_OPERATOR                   => 6,
    _4GL_IDENTIFIER                 => 7,
    _4GL_BLOCK                      => 8,
    _4GL_END                        => 9,
    _4GL_COMMENT1                   => 10,
    _4GL_COMMENT2                   => 11,
    _4GL_COMMENT3                   => 12,
    _4GL_COMMENT4                   => 13,
    _4GL_COMMENT5                   => 14,
    _4GL_COMMENT6                   => 15,
    _4GL_DEFAULT_                   => 16,
    _4GL_NUMBER_                    => 17,
    _4GL_WORD_                      => 18,
    _4GL_STRING_                    => 19,
    _4GL_CHARACTER_                 => 20,
    _4GL_PREPROCESSOR_              => 21,
    _4GL_OPERATOR_                  => 22,
    _4GL_IDENTIFIER_                => 23,
    _4GL_BLOCK_                     => 24,
    _4GL_END_                       => 25,
    _4GL_COMMENT1_                  => 26,
    _4GL_COMMENT2_                  => 27,
    _4GL_COMMENT3_                  => 28,
    _4GL_COMMENT4_                  => 29,
    _4GL_COMMENT5_                  => 30,
    _4GL_COMMENT6_                  => 31,
    ABAQUS_DEFAULT                  => 0,
    ABAQUS_COMMENT                  => 1,
    ABAQUS_COMMENTBLOCK             => 2,
    ABAQUS_NUMBER                   => 3,
    ABAQUS_STRING                   => 4,
    ABAQUS_OPERATOR                 => 5,
    ABAQUS_WORD                     => 6,
    ABAQUS_PROCESSOR                => 7,
    ABAQUS_COMMAND                  => 8,
    ABAQUS_SLASHCOMMAND             => 9,
    ABAQUS_STARCOMMAND              => 10,
    ABAQUS_ARGUMENT                 => 11,
    ABAQUS_FUNCTION                 => 12,
    ASY_DEFAULT                     => 0,
    ASY_COMMENT                     => 1,
    ASY_COMMENTLINE                 => 2,
    ASY_NUMBER                      => 3,
    ASY_WORD                        => 4,
    ASY_STRING                      => 5,
    ASY_CHARACTER                   => 6,
    ASY_OPERATOR                    => 7,
    ASY_IDENTIFIER                  => 8,
    ASY_STRINGEOL                   => 9,
    ASY_COMMENTLINEDOC              => 10,
    ASY_WORD2                       => 11,
    R_DEFAULT                       => 0,
    R_COMMENT                       => 1,
    R_KWORD                         => 2,
    R_BASEKWORD                     => 3,
    R_OTHERKWORD                    => 4,
    R_NUMBER                        => 5,
    R_STRING                        => 6,
    R_STRING2                       => 7,
    R_OPERATOR                      => 8,
    R_IDENTIFIER                    => 9,
    R_INFIX                         => 10,
    R_INFIXEOL                      => 11,
    MAGIK_DEFAULT                   => 0,
    MAGIK_COMMENT                   => 1,
    MAGIK_HYPER_COMMENT             => 16,
    MAGIK_STRING                    => 2,
    MAGIK_CHARACTER                 => 3,
    MAGIK_NUMBER                    => 4,
    MAGIK_IDENTIFIER                => 5,
    MAGIK_OPERATOR                  => 6,
    MAGIK_FLOW                      => 7,
    MAGIK_CONTAINER                 => 8,
    MAGIK_BRACKET_BLOCK             => 9,
    MAGIK_BRACE_BLOCK               => 10,
    MAGIK_SQBRACKET_BLOCK           => 11,
    MAGIK_UNKNOWN_KEYWORD           => 12,
    MAGIK_KEYWORD                   => 13,
    MAGIK_PRAGMA                    => 14,
    MAGIK_SYMBOL                    => 15,
    POWERSHELL_DEFAULT              => 0,
    POWERSHELL_COMMENT              => 1,
    POWERSHELL_STRING               => 2,
    POWERSHELL_CHARACTER            => 3,
    POWERSHELL_NUMBER               => 4,
    POWERSHELL_VARIABLE             => 5,
    POWERSHELL_OPERATOR             => 6,
    POWERSHELL_IDENTIFIER           => 7,
    POWERSHELL_KEYWORD              => 8,
    POWERSHELL_CMDLET               => 9,
    POWERSHELL_ALIAS                => 10,
    MYSQL_DEFAULT                   => 0,
    MYSQL_COMMENT                   => 1,
    MYSQL_COMMENTLINE               => 2,
    MYSQL_VARIABLE                  => 3,
    MYSQL_SYSTEMVARIABLE            => 4,
    MYSQL_KNOWNSYSTEMVARIABLE       => 5,
    MYSQL_NUMBER                    => 6,
    MYSQL_MAJORKEYWORD              => 7,
    MYSQL_KEYWORD                   => 8,
    MYSQL_DATABASEOBJECT            => 9,
    MYSQL_PROCEDUREKEYWORD          => 10,
    MYSQL_STRING                    => 11,
    MYSQL_SQSTRING                  => 12,
    MYSQL_DQSTRING                  => 13,
    MYSQL_OPERATOR                  => 14,
    MYSQL_FUNCTION                  => 15,
    MYSQL_IDENTIFIER                => 16,
    MYSQL_QUOTEDIDENTIFIER          => 17,
    MYSQL_USER1                     => 18,
    MYSQL_USER2                     => 19,
    MYSQL_USER3                     => 20,
    MYSQL_HIDDENCOMMAND             => 21,
    PO_DEFAULT                      => 0,
    PO_COMMENT                      => 1,
    PO_MSGID                        => 2,
    PO_MSGID_TEXT                   => 3,
    PO_MSGSTR                       => 4,
    PO_MSGSTR_TEXT                  => 5,
    PO_MSGCTXT                      => 6,
    PO_MSGCTXT_TEXT                 => 7,
    PO_FUZZY                        => 8,
    PAS_DEFAULT                     => 0,
    PAS_IDENTIFIER                  => 1,
    PAS_COMMENT                     => 2,
    PAS_COMMENT2                    => 3,
    PAS_COMMENTLINE                 => 4,
    PAS_PREPROCESSOR                => 5,
    PAS_PREPROCESSOR2               => 6,
    PAS_NUMBER                      => 7,
    PAS_HEXNUMBER                   => 8,
    PAS_WORD                        => 9,
    PAS_STRING                      => 10,
    PAS_STRINGEOL                   => 11,
    PAS_CHARACTER                   => 12,
    PAS_OPERATOR                    => 13,
    PAS_ASM                         => 14,
    SORCUS_DEFAULT                  => 0,
    SORCUS_COMMAND                  => 1,
    SORCUS_PARAMETER                => 2,
    SORCUS_COMMENTLINE              => 3,
    SORCUS_STRING                   => 4,
    SORCUS_STRINGEOL                => 5,
    SORCUS_IDENTIFIER               => 6,
    SORCUS_OPERATOR                 => 7,
    SORCUS_NUMBER                   => 8,
    SORCUS_CONSTANT                 => 9,
    POWERPRO_DEFAULT                => 0,
    POWERPRO_COMMENTBLOCK           => 1,
    POWERPRO_COMMENTLINE            => 2,
    POWERPRO_NUMBER                 => 3,
    POWERPRO_WORD                   => 4,
    POWERPRO_WORD2                  => 5,
    POWERPRO_WORD3                  => 6,
    POWERPRO_WORD4                  => 7,
    POWERPRO_DOUBLEQUOTEDSTRING     => 8,
    POWERPRO_SINGLEQUOTEDSTRING     => 9,
    POWERPRO_LINECONTINUE           => 10,
    POWERPRO_OPERATOR               => 11,
    POWERPRO_IDENTIFIER             => 12,
    POWERPRO_STRINGEOL              => 13,
    POWERPRO_VERBATIM               => 14,
    POWERPRO_ALTQUOTE               => 15,
    POWERPRO_FUNCTION               => 16,
    SML_DEFAULT                     => 0,
    SML_IDENTIFIER                  => 1,
    SML_TAGNAME                     => 2,
    SML_KEYWORD                     => 3,
    SML_KEYWORD2                    => 4,
    SML_KEYWORD3                    => 5,
    SML_LINENUM                     => 6,
    SML_OPERATOR                    => 7,
    SML_NUMBER                      => 8,
    SML_CHAR                        => 9,
    SML_STRING                      => 11,
    SML_COMMENT                     => 12,
    SML_COMMENT1                    => 13,
    SML_COMMENT2                    => 14,
    SML_COMMENT3                    => 15,
    MARKDOWN_DEFAULT                => 0,
    MARKDOWN_LINE_BEGIN             => 1,
    MARKDOWN_STRONG1                => 2,
    MARKDOWN_STRONG2                => 3,
    MARKDOWN_EM1                    => 4,
    MARKDOWN_EM2                    => 5,
    MARKDOWN_HEADER1                => 6,
    MARKDOWN_HEADER2                => 7,
    MARKDOWN_HEADER3                => 8,
    MARKDOWN_HEADER4                => 9,
    MARKDOWN_HEADER5                => 10,
    MARKDOWN_HEADER6                => 11,
    MARKDOWN_PRECHAR                => 12,
    MARKDOWN_ULIST_ITEM             => 13,
    MARKDOWN_OLIST_ITEM             => 14,
    MARKDOWN_BLOCKQUOTE             => 15,
    MARKDOWN_STRIKEOUT              => 16,
    MARKDOWN_HRULE                  => 17,
    MARKDOWN_LINK                   => 18,
    MARKDOWN_CODE                   => 19,
    MARKDOWN_CODE2                  => 20,
    MARKDOWN_CODEBK                 => 21,
    CMD_REDO                        => 2011,
    CMD_SELECTALL                   => 2013,
    CMD_UNDO                        => 2176,
    CMD_CUT                         => 2177,
    CMD_COPY                        => 2178,
    CMD_PASTE                       => 2179,
    CMD_CLEAR                       => 2180,
    CMD_LINEDOWN                    => 2300,
    CMD_LINEDOWNEXTEND              => 2301,
    CMD_LINEUP                      => 2302,
    CMD_LINEUPEXTEND                => 2303,
    CMD_CHARLEFT                    => 2304,
    CMD_CHARLEFTEXTEND              => 2305,
    CMD_CHARRIGHT                   => 2306,
    CMD_CHARRIGHTEXTEND             => 2307,
    CMD_WORDLEFT                    => 2308,
    CMD_WORDLEFTEXTEND              => 2309,
    CMD_WORDRIGHT                   => 2310,
    CMD_WORDRIGHTEXTEND             => 2311,
    CMD_HOME                        => 2312,
    CMD_HOMEEXTEND                  => 2313,
    CMD_LINEEND                     => 2314,
    CMD_LINEENDEXTEND               => 2315,
    CMD_DOCUMENTSTART               => 2316,
    CMD_DOCUMENTSTARTEXTEND         => 2317,
    CMD_DOCUMENTEND                 => 2318,
    CMD_DOCUMENTENDEXTEND           => 2319,
    CMD_PAGEUP                      => 2320,
    CMD_PAGEUPEXTEND                => 2321,
    CMD_PAGEDOWN                    => 2322,
    CMD_PAGEDOWNEXTEND              => 2323,
    CMD_EDITTOGGLEOVERTYPE          => 2324,
    CMD_CANCEL                      => 2325,
    CMD_DELETEBACK                  => 2326,
    CMD_TAB                         => 2327,
    CMD_BACKTAB                     => 2328,
    CMD_NEWLINE                     => 2329,
    CMD_FORMFEED                    => 2330,
    CMD_VCHOME                      => 2331,
    CMD_VCHOMEEXTEND                => 2332,
    CMD_ZOOMIN                      => 2333,
    CMD_ZOOMOUT                     => 2334,
    CMD_DELWORDLEFT                 => 2335,
    CMD_DELWORDRIGHT                => 2336,
    CMD_DELWORDRIGHTEND             => 2518,
    CMD_LINECUT                     => 2337,
    CMD_LINEDELETE                  => 2338,
    CMD_LINETRANSPOSE               => 2339,
    CMD_LINEDUPLICATE               => 2404,
    CMD_LOWERCASE                   => 2340,
    CMD_UPPERCASE                   => 2341,
    CMD_LINESCROLLDOWN              => 2342,
    CMD_LINESCROLLUP                => 2343,
    CMD_DELETEBACKNOTLINE           => 2344,
    CMD_HOMEDISPLAY                 => 2345,
    CMD_HOMEDISPLAYEXTEND           => 2346,
    CMD_LINEENDDISPLAY              => 2347,
    CMD_LINEENDDISPLAYEXTEND        => 2348,
    CMD_HOMEWRAP                    => 2349,
    CMD_HOMEWRAPEXTEND              => 2450,
    CMD_LINEENDWRAP                 => 2451,
    CMD_LINEENDWRAPEXTEND           => 2452,
    CMD_VCHOMEWRAP                  => 2453,
    CMD_VCHOMEWRAPEXTEND            => 2454,
    CMD_LINECOPY                    => 2455,
    CMD_WORDPARTLEFT                => 2390,
    CMD_WORDPARTLEFTEXTEND          => 2391,
    CMD_WORDPARTRIGHT               => 2392,
    CMD_WORDPARTRIGHTEXTEND         => 2393,
    CMD_DELLINELEFT                 => 2395,
    CMD_DELLINERIGHT                => 2396,
    CMD_PARADOWN                    => 2413,
    CMD_PARADOWNEXTEND              => 2414,
    CMD_PARAUP                      => 2415,
    CMD_PARAUPEXTEND                => 2416,
    CMD_LINEDOWNRECTEXTEND          => 2426,
    CMD_LINEUPRECTEXTEND            => 2427,
    CMD_CHARLEFTRECTEXTEND          => 2428,
    CMD_CHARRIGHTRECTEXTEND         => 2429,
    CMD_HOMERECTEXTEND              => 2430,
    CMD_VCHOMERECTEXTEND            => 2431,
    CMD_LINEENDRECTEXTEND           => 2432,
    CMD_PAGEUPRECTEXTEND            => 2433,
    CMD_PAGEDOWNRECTEXTEND          => 2434,
    CMD_STUTTEREDPAGEUP             => 2435,
    CMD_STUTTEREDPAGEUPEXTEND       => 2436,
    CMD_STUTTEREDPAGEDOWN           => 2437,
    CMD_STUTTEREDPAGEDOWNEXTEND     => 2438,
    CMD_WORDLEFTEND                 => 2439,
    CMD_WORDLEFTENDEXTEND           => 2440,
    CMD_WORDRIGHTEND                => 2441,
    CMD_WORDRIGHTENDEXTEND          => 2442,
};

# check for loaded Wx::STC
if ( exists( $INC{'Wx/STC.pm'} ) ) {
    croak(
'Wx::Scintilla cannot be loaded alongside Wx::STC. Choose one and only one of the modules. '
    );
}

require XSLoader;
XSLoader::load 'Wx::Scintilla', $VERSION;

#
# properly setup inheritance tree
#

no strict;

package Wx::ScintillaTextCtrl;
our $VERSION = '0.33_01';
@ISA = qw(Wx::Control);

package Wx::ScintillaTextEvent;
our $VERSION = '0.33_01';
@ISA = qw(Wx::CommandEvent);

use strict;

# Load the renamespaced versions
require Wx::Scintilla::TextCtrl;
require Wx::Scintilla::TextEvent;

# Set up all of the events
SCOPE: {

    # Disable Wx::EVT_STC_* event warning redefinition
    no warnings 'redefine';

    # SVN_XXXXXX notification messages

    sub Wx::Event::EVT_STC_STYLENEEDED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_STYLENEEDED, $_[2] );
    }

    sub Wx::Event::EVT_STC_CHARADDED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_CHARADDED, $_[2] );
    }

    sub Wx::Event::EVT_STC_SAVEPOINTREACHED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_SAVEPOINTREACHED, $_[2] );
    }

    sub Wx::Event::EVT_STC_SAVEPOINTLEFT($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_SAVEPOINTLEFT, $_[2] );
    }

    sub Wx::Event::EVT_STC_ROMODIFYATTEMPT($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_ROMODIFYATTEMPT, $_[2] );
    }

    sub Wx::Event::EVT_STC_KEY($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_KEY, $_[2] );
    }

    sub Wx::Event::EVT_STC_DOUBLECLICK($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_DOUBLECLICK, $_[2] );
    }

    sub Wx::Event::EVT_STC_UPDATEUI($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_UPDATEUI, $_[2] );
    }

    sub Wx::Event::EVT_STC_MODIFIED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_MODIFIED, $_[2] );
    }

    sub Wx::Event::EVT_STC_MACRORECORD($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_MACRORECORD, $_[2] );
    }

    sub Wx::Event::EVT_STC_MARGINCLICK($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_MARGINCLICK, $_[2] );
    }

    sub Wx::Event::EVT_STC_NEEDSHOWN($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_NEEDSHOWN, $_[2] );
    }

    sub Wx::Event::EVT_STC_PAINTED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_PAINTED, $_[2] );
    }

    sub Wx::Event::EVT_STC_USERLISTSELECTION($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_USERLISTSELECTION, $_[2] );
    }

    sub Wx::Event::EVT_STC_URIDROPPED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_URIDROPPED, $_[2] );
    }

    sub Wx::Event::EVT_STC_DWELLSTART($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_DWELLSTART, $_[2] );
    }

    sub Wx::Event::EVT_STC_DWELLEND($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_DWELLEND, $_[2] );
    }

    sub Wx::Event::EVT_STC_ZOOM($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_ZOOM, $_[2] );
    }

    sub Wx::Event::EVT_STC_HOTSPOT_CLICK($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_HOTSPOT_CLICK, $_[2] );
    }

    sub Wx::Event::EVT_STC_HOTSPOT_DCLICK($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_HOTSPOT_DCLICK, $_[2] );
    }

    sub Wx::Event::EVT_STC_INDICATOR_CLICK($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_INDICATOR_CLICK, $_[2] );
    }

    sub Wx::Event::EVT_STC_INDICATOR_RELEASE($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_INDICATOR_RELEASE, $_[2] );
    }

    sub Wx::Event::EVT_STC_CALLTIP_CLICK($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_CALLTIP_CLICK, $_[2] );
    }

    sub Wx::Event::EVT_STC_AUTOCOMP_CANCELLED($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_AUTOCOMP_CANCELLED, $_[2] );
    }

    sub Wx::Event::EVT_STC_AUTOCOMP_CHAR_DELETED($$$) {
        $_[0]
          ->Connect( $_[1], -1, &Wx::wxEVT_STC_AUTOCOMP_CHAR_DELETED, $_[2] );
    }

    # SCEN_XXXXXX notification messages

    sub Wx::Event::EVT_STC_CHANGE($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_CHANGE, $_[2] );
    }

    # Events that do not seem to match the documentation

    sub Wx::Event::EVT_STC_START_DRAG($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_START_DRAG, $_[2] );
    }

    sub Wx::Event::EVT_STC_DRAG_OVER($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_DRAG_OVER, $_[2] );
    }

    sub Wx::Event::EVT_STC_DO_DROP($$$) {
        $_[0]->Connect( $_[1], -1, &Wx::wxEVT_STC_DO_DROP, $_[2] );
    }

    # Deprecated notifications

    sub Wx::Event::EVT_STC_POSCHANGED($$$) {
        Carp::croak('EVT_STC_POSCHANGED is deprecated, use EVT_STC_UPDATEUI');
    }

    sub Wx::Event::EVT_STC_CHECKBRACE($$$) {
        Carp::croak('EVT_STC_CHECKBRACE is deprecated, use EVT_STC_UPDATEUI');
    }

}

# Create the aliases to the native versions.
# The order here matches the order in the Scintilla documentation.
BEGIN {
    # SCN_XXXXXX notifications
    *EVT_STYLENEEDED         = *Wx::Event::EVT_STC_STYLENEEDED;
    *EVT_CHARADDED           = *Wx::Event::EVT_STC_CHARADDED;
    *EVT_SAVEPOINTREACHED    = *Wx::Event::EVT_STC_SAVEPOINTREACHED;
    *EVT_SAVEPOINTLEFT       = *Wx::Event::EVT_STC_SAVEPOINTLEFT;
    *EVT_MODIFYATTEMPTRO     = *Wx::Event::EVT_STC_ROMODIFYATTEMPT;
    *EVT_KEY                 = *Wx::Event::EVT_STC_KEY;
    *EVT_DOUBLECLICK         = *Wx::Event::EVT_STC_DOUBLECLICK;
    *EVT_UPDATEUI            = *Wx::Event::EVT_STC_UPDATEUI;
    *EVT_MODIFIED            = *Wx::Event::EVT_STC_MODIFIED;
    *EVT_MACRORECORD         = *Wx::Event::EVT_STC_MACRORECORD;
    *EVT_MARGINCLICK         = *Wx::Event::EVT_STC_MARGINCLICK;
    *EVT_NEEDSHOWN           = *Wx::Event::EVT_STC_NEEDSHOWN;
    *EVT_PAINTED             = *Wx::Event::EVT_STC_PAINTED;
    *EVT_USERLISTSELECTION   = *Wx::Event::EVT_STC_USERLISTSELECTION;
    *EVT_URIDROPPED          = *Wx::Event::EVT_STC_URIDROPPED;
    *EVT_DWELLSTART          = *Wx::Event::EVT_STC_DWELLSTART;
    *EVT_DWELLEND            = *Wx::Event::EVT_STC_DWELLEND;
    *EVT_ZOOM                = *Wx::Event::EVT_STC_ZOOM;
    *EVT_HOTSPOTCLICK        = *Wx::Event::EVT_STC_HOTSPOT_CLICK;
    *EVT_HOTSPOTDOUBLECLICK  = *Wx::Event::EVT_STC_HOTSPOT_DCLICK;
    # *EVT_HOTSPOTRELEASECLICK = *Wx::Event::EVT_STC_HOTSPOTRELEASECLICK;
    *EVT_INDICATORCLICK      = *Wx::Event::EVT_STC_INDICATOR_CLICK;
    *EVT_INDICATORRELEASE    = *Wx::Event::EVT_STC_INDICATOR_RELEASE;
    *EVT_CALLTIPCLICK        = *Wx::Event::EVT_STC_CALLTIP_CLICK;
    # *EVT_AUTOCSELECTION      = *Wx::Event::EVT_STC_AUTOCSELECTION;
    *EVT_AUTOCCANCELLED      = *Wx::Event::EVT_STC_AUTOCOMP_CANCELLED;
    *EVT_AUTOCCHARDELETED    = *Wx::Event::EVT_STC_AUTOCOMP_CHAR_DELETED;

    # SCEN_XXXXXX notifications
    *EVT_CHANGE              = *Wx::Event::EVT_STC_CHANGE;

    # Deprecated notifications
    *EVT_POSCHANGED          = *Wx::Event::EVT_STC_POSCHANGED;
    *EVT_CHECKBRACE          = *Wx::Event::EVT_STC_CHECKBRACE;
}

1;

__END__

=pod

=head1 NAME

Wx::Scintilla - Scintilla source code editing component for wxWidgets

=head1 SYNOPSIS

    #----> My first scintilla Wx editor :)
    package My::Scintilla::Editor;

    use strict;
    use warnings;

    # Load Wx::Scintilla
    use Wx::Scintilla ();    # replaces use Wx::STC
    use base 'Wx::ScintillaTextCtrl';    # replaces Wx::StyledTextCtrl

    use Wx qw(:everything);
    use Wx::Event;

    # Override the constructor to Enable Perl support in the editor
    sub new {
        my ( $class, $parent ) = @_;
        my $self = $class->SUPER::new( $parent, -1, [ -1, -1 ], [ 750, 700 ] );

        # Set the font
        my $font = Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );
        $self->SetFont($font);
        $self->StyleSetFont( wxSTC_STYLE_DEFAULT, $font );
        $self->StyleClearAll();

        # Set the various Perl lexer colors
        $self->StyleSetForeground( 0,  Wx::Colour->new( 0x00, 0x00, 0x7f ) );
        $self->StyleSetForeground( 1,  Wx::Colour->new( 0xff, 0x00, 0x00 ) );
        $self->StyleSetForeground( 2,  Wx::Colour->new( 0x00, 0x7f, 0x00 ) );
        $self->StyleSetForeground( 3,  Wx::Colour->new( 0x7f, 0x7f, 0x7f ) );
        $self->StyleSetForeground( 4,  Wx::Colour->new( 0x00, 0x7f, 0x7f ) );
        $self->StyleSetForeground( 5,  Wx::Colour->new( 0x00, 0x00, 0x7f ) );
        $self->StyleSetForeground( 6,  Wx::Colour->new( 0xff, 0x7f, 0x00 ) );
        $self->StyleSetForeground( 7,  Wx::Colour->new( 0x7f, 0x00, 0x7f ) );
        $self->StyleSetForeground( 8,  Wx::Colour->new( 0x00, 0x00, 0x00 ) );
        $self->StyleSetForeground( 9,  Wx::Colour->new( 0x7f, 0x7f, 0x7f ) );
        $self->StyleSetForeground( 10, Wx::Colour->new( 0x00, 0x00, 0x7f ) );
        $self->StyleSetForeground( 11, Wx::Colour->new( 0x00, 0x00, 0xff ) );
        $self->StyleSetForeground( 12, Wx::Colour->new( 0x7f, 0x00, 0x7f ) );
        $self->StyleSetForeground( 13, Wx::Colour->new( 0x40, 0x80, 0xff ) );
        $self->StyleSetForeground( 17, Wx::Colour->new( 0xff, 0x00, 0x7f ) );
        $self->StyleSetForeground( 18, Wx::Colour->new( 0x7f, 0x7f, 0x00 ) );
        $self->StyleSetBold( 12, 1 );
        $self->StyleSetSpec( wxSTC_H_TAG, "fore:#0000ff" );

        # set the lexer to Perl 5
        $self->SetLexer(wxSTC_LEX_PERL);

        return $self;
    }

    #----> DEMO EDITOR APPLICATION

    # First, define an application object class to encapsulate the application itself
    package DemoEditorApp;

    use strict;
    use warnings;
    use Wx;
    use base 'Wx::App';

    # We must override OnInit to build the window
    sub OnInit {
        my $self = shift;

        my $frame = Wx::Frame->new(
        undef,                           # no parent window
        -1,                              # no window id
        'My First Scintilla Editor!',    # Window title
        );

        my $editor = My::Scintilla::Editor->new(
        $frame,                          # Parent window
        );

        $frame->Show(1);
        return 1;
    }

    # Create the application object, and pass control to it.
    package main;
    my $app = DemoEditorApp->new;
    $app->MainLoop;


=head1 DESCRIPTION

While we already have a good scintilla editor component support via 
Wx::StyledTextCtrl in Perl, we already suffer from an older scintilla package 
and thus lagging Perl support in the popular Wx Scintilla component. wxWidgets 
L<http://wxwidgets.org> has a *very slow* release timeline. Scintilla is a 
contributed project which means it will not be the latest by the time a new 
wxWidgets distribution is released. And on the scintilla front, the Perl 5 lexer 
is not 100% bug free even and we do not have any kind of Perl 6 support in 
Scintilla.

The ambitious goal of this project is to provide fresh Perl 5 and maybe 6 
support in L<Wx> while preserving compatibility with Wx::StyledTextCtrl
and continually contribute it back to Scintilla project.

Note: You cannot load Wx::STC and Wx::Scintilla in the same application. They
are mutually exclusive. The wxSTC_... events are handled by one library or
the other.

Scintilla 2.28 is now bundled and enabled by default.

=head1 MANUAL

If you are looking for more API documentation, please consult L<Wx::Scintilla::Manual>

=head1 PLATFORMS

At the moment, Linux (Debian, Ubuntu, Fedora, CentOS) and Windows (Strawberry
and ActivePerl)  are supported platforms. My next goal is to support more 
platforms. Please let me know if you can help out :)

On Debian/Ubuntu, you need to install the following via:

    sudo apt-get install libgtk2.0-dev

On MacOS 64-bit by default you need to install a 32-bit Perl in order to
install wxWidgets 2.8.x. Please refer to 
L<http://wiki.wxperl.info/w/index.php/Mac_OS_X_Platform_Notes> for more information.

=head1 HISTORY

wxWidgets 2.9.1 and development have Scintilla 2.03 so far. I searched for Perl lexer
changes in scintilla history and here is what we will be getting when we upgrade to
2.26+.

=over

=item Release 2.26

Perl folding folds "here doc"s and adds options fold.perl.at.else and
fold.perl.comment.explicit. Fold structure for Perl fixed. 

=item Release 2.20

Perl folder works for array blocks, adjacent package statements, nested PODs,
and terminates package folding at DATA, D and Z.

=item Release 1.79

Perl lexer bug fixed where previous lexical states persisted causing "/" special 
case styling and subroutine prototype styling to not be correct.

=item Release 1.78

Perl lexer fixes problem with string matching caused by line endings.

=item Release 1.77

Perl lexer update.

=item Release 1.76

Perl lexer handles defined-or operator "".

=item Release 1.75

Perl lexer enhanced for handling minus-prefixed barewords, underscores in
numeric literals and vector/version strings, D and Z similar to END, subroutine 
prototypes as a new lexical class, formats and format blocks as new lexical
classes, and '/' suffixed keywords and barewords.

=item Release 1.71

Perl lexer allows UTF-8 identifiers and has some other small improvements.

=back

=head1 ACKNOWLEDGEMENTS

Neil Hudgson for creating and maintaining the excellent Scintilla project
L<http://scintilla.org>. Thanks!

Robin Dunn L<http://alldunn.com/robin/> for the excellent scintilla 
contribution that he made to wxWidgets. This work is based on his codebase.
Thanks!

Mark dootson L<http://search.cpan.org/~mdootson/> for his big effort to make
Wx::Scintilla compilable on various platforms. Big thanks!

Heiko Jansen and Gabor Szabo L<http://szabgab.com> for the idea to backport
Perl lexer for wxWidgets 2.8.10 L<http://padre.perlide.org/trac/ticket/257>
and all of #padre members for the continuous support and testing. Thanks!

=head1 SUPPORT

Bugs should always be submitted via the CPAN bug tracker

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Wx-Scintilla>

For other issues, contact the maintainer.

=head1 AUTHOR

Ahmad M. Zawawi <ahmad.zawawi@gmail.com>

Mark Dootson <http://www.wxperl.co.uk>

=head1 SEE ALSO

Wx::Scintilla Manual L<Wx::Scintilla::Manual>

wxStyledTextCtrl Documentation L<http://www.yellowbrain.com/stc/index.html>

Scintilla edit control for Win32::GUI L<Win32::GUI::Scintilla>

=head1 COPYRIGHT AND LICENSE

Copyright 2011 Ahmad M. Zawawi.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

License for Scintilla

Included Scintilla source is copyrighted 1998-2011 by Neil Hodgson <neilh@scintilla.org>

Permission to use, copy, modify, and distribute this software and its documentation for any purpose and without fee is hereby granted, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.

NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

=cut
