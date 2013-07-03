

# NAME

    Data::Tools provides set of basic functions for data manipulation.

# SYNOPSIS

    use Data::Tools qw( :all );

    # --------------------------------------------------------------------------

    my $res     = file_save( $file_name, 'file content here' );
    my $content = file_load( $file_name );

    # --------------------------------------------------------------------------
    

    my $res  = dir_path_make( '/path/to/somewhere' ); # create full path with 0700
    my $res  = dir_path_make( '/new/path', MASK => 0755 ); # ...with mask 0755
    my $path = dir_path_ensure( '/path/s/t/h' ); # ensure path exists, check+make

    # --------------------------------------------------------------------------
    

    my $hash_str = hash2str( $hash_ref ); # convert hash to string "key=value\n"
    my $hash_ref = str2hash( $hash_str ); # convert str "key-value\n" to hash

    hash_uc
    hash_lc
    hash_uc_ipl
    hash_lc_ipl
    

    # save/load hash in str_url_escaped form to/from a file
    my $res      = hash_save( $file_name, $hash_ref );
    my $hash_ref = hash_load( $file_name );

    # validate hash by example
    my $validate = {
                   KEY1 => 'INT',
                   KEY2 => 'INT(-5,10)',
                   KEY3 => 'REAL',
                   };
    my $data     = {
                   KEY1 => '123',
                   KEY2 =>  '-1',
                   KEY3 =>  '1 234 567.89',
                   }               
    

    my @invalid_keys = hash_validate( $data, $validate );

    # --------------------------------------------------------------------------
    

    my $escaped   = str_url_escape( $plain_str ); # URL-style %XX escaping
    my $plain_str = str_url_unescape( $escaped );

    my $escaped   = str_html_escape( $plain_str ); # HTML-style &name; escaping
    my $plain_str = str_html_unescape( $escaped );
    

    my $hex_str   = str_hex( $plain_str ); # HEX-style XX string escaping
    my $plain_str = str_unhex( $hex_str );

    # --------------------------------------------------------------------------
    

    my $perl_pkg_fn = perl_package_to_file( 'Data::Tools' ); # returns "Data/Tools.pm"

    # --------------------------------------------------------------------------

    # calculating hex digests
    my $whirlpool_hex = wp_hex( $data );
    my $sha1_hex      = sha1_hex( $data );
    my $md5_hex       = md5_hex( $data );

# FUNCTIONS

    (more docs)

# TODO

    (more docs)

# GITHUB REPOSITORY

    git@github.com:cade-vs/perl-time-profiler.git
    

    git clone git://github.com/cade-vs/perl-data-tools.git
    

# AUTHOR

    Vladi Belperchinov-Shabanski "Cade"

    <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>

    http://cade.datamax.bg
