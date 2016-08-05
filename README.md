

# NAME

    Data::Tools provides set of basic functions for data manipulation.

# SYNOPSIS

    use Data::Tools qw( :all );  # import all functions
    use Data::Tools;             # the same as :all :) 
    use Data::Tools qw( :none ); # do not import anything, use full package names

    # --------------------------------------------------------------------------

    my $res     = file_save( $file_name, 'file content here' );
    my $content = file_load( $file_name );

    # --------------------------------------------------------------------------

    my $file_modification_time_in_seconds = file_mtime( $file_name );
    my $file_change_time_in_seconds       = file_ctime( $file_name );
    my $file_last_access_time_in_seconds  = file_atime( $file_name );
    my $file_size                         = file_size(  $file_name );

    # --------------------------------------------------------------------------
    

    my $res  = dir_path_make( '/path/to/somewhere' ); # create full path with 0700
    my $res  = dir_path_make( '/new/path', MASK => 0755 ); # ...with mask 0755
    my $path = dir_path_ensure( '/path/s/t/h' ); # ensure path exists, check+make

    # --------------------------------------------------------------------------
    

    my $hash_str = hash2str( $hash_ref ); # convert hash to string "key=value\n"
    my $hash_ref = str2hash( $hash_str ); # convert str "key-value\n" to hash
    

    my $hash_ref = url2hash( 'key1=val1&key2=val2&testing=tralala);
    # $hash_ref will be { key1 => 'val1', key2 => 'val2', testing => 'tralala' }

    my $hash_ref_with_upper_case_keys = hash_uc( $hash_ref_with_lower_case_keys );
    my $hash_ref_with_lower_case_keys = hash_lc( $hash_ref_with_upper_case_keys );

    hash_uc_ipl( $hash_ref_to_be_converted_to_upper_case_keys );
    hash_lc_ipl( $hash_ref_to_be_converted_to_lower_case_keys );
    

    # save/load hash in str_url_escaped form to/from a file
    my $res      = hash_save( $file_name, $hash_ref );
    my $hash_ref = hash_load( $file_name );

    # validate (nested) hash by example
    

    # validation example nested hash
    my $validate_hr = {
                      A => 'INT',
                      B => 'INT(-5,10)',
                      C => 'REAL',
                      D => {
                           E => 'RE:\d+[a-f]*',  # regexp match
                           F => 'REI:\d+[a-f]*', # case insensitive regexp match
                           },
                      DIR1  => '-d',   # must be existing directory
                      DIR2  => 'dir',  # must be existing directory
                      FILE1 => '-f',   # must be existing file  
                      FILE2 => 'file', # must be existing file  
                      };
    # actual nested hash to be verified if looks like the example
    my $data_hr     = {
                      A => '123',
                      B =>  '-1',
                      C =>  '1 234 567.89',
                      D => {
                           E => '123abc',
                           F => '456FFF',
                           },
                      }               
    

    my @invalid_keys = hash_validate( $data_hr, $validate_hr );
    print "YES!" if hash_validate( $data_hr, $validate_hr );

    # --------------------------------------------------------------------------
    

    my $escaped   = str_url_escape( $plain_str ); # URL-style %XX escaping
    my $plain_str = str_url_unescape( $escaped );

    my $escaped   = str_html_escape( $plain_str ); # HTML-style &name; escaping
    my $plain_str = str_html_unescape( $escaped );
    

    my $hex_str   = str_hex( $plain_str ); # HEX-style XX string escaping
    my $plain_str = str_unhex( $hex_str );

    # --------------------------------------------------------------------------
    

    # converts perl package names to file names, f.e: returns "Data/Tools.pm"
    my $perl_pkg_fn = perl_package_to_file( 'Data::Tools' );

    # --------------------------------------------------------------------------

    # calculating hex digests
    my $whirlpool_hex = wp_hex( $data );
    my $sha1_hex      = sha1_hex( $data );
    my $md5_hex       = md5_hex( $data );

    # --------------------------------------------------------------------------

    # find all *.txt files in all subdirectories starting from /usr/local
    # returned files are with full path names
    my @files = glob_tree( '/usr/local/*.txt' );

    # read directory entries names (without full paths)
    my @files_and_dirs = read_dir_entries( '/tmp/secret/dir' );

# FUNCTIONS

## hash\_validate( $data\_hr, $validate\_hr );

Return value can be either scalar or array context. In scalar context return
value is true (1) or false (0). In array context it returns list of the invalid
keys (possibly key paths like 'KEY1/KEY2/KEY3'):

    # array context
    my @invalid_keys = hash_validate( $data_hr, $validate_hr );
    

    # scalar context
    print "YES!" if hash_validate( $data_hr, $validate_hr );

# TODO

    (more docs)

# REQUIRED MODULES

Data::Tools is designed to be simple, compact and self sufficient. 
However it uses some 3rd party modules:

    * Digest::Whirlpool
    * Digest::MD5
    * Digest::SHA1

# SEE ALSO

For more complex cases of nested hash validation, 
check Data::Validate::Struct module by Thomas Linden, cheers :)

# GITHUB REPOSITORY

    git@github.com:cade-vs/perl-data-tools.git
    

    git clone git://github.com/cade-vs/perl-data-tools.git
    

# AUTHOR

    Vladi Belperchinov-Shabanski "Cade"

    <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>

    http://cade.datamax.bg
