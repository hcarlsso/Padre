package Madre;

use 5.008;
use strict;
use JSON                       ();
use Digest::MD5                ();
use DateTime                   ();
use DateTime::Format::Strptime ();
use Try::Tiny;
use Madre::DB;
use Dancer ':syntax';

our $VERSION    = '0.1';
our $COMPATIBLE = '0.1';

my $DATES = DateTime::Format::Strptime->new(
    pattern => '%F %T %z',
);

set serializer => 'JSON';

hook before => sub {
    my $user_id = session('user');
    if ( $user_id ) {
        try {
            my $user = Madre::DB::User->load($user_id);
            debug( 'Loaded session user - ' . $user->username );
            vars->{user} = $user;
        } catch {
            debug( "Invalid session user $user_id" );
            session->destroy;
        };
    }
};





######################################################################
# Generic Public Routes

get '/' => sub {
    template 'index';
};

get '/version' => sub {
    return {
        server => server_json(),
    };
};

get '/version.json' => sub {
    return json();
};




######################################################################
# Site Registration

get '/register' => sub {
    template 'register.tt', {
        title => 'Registration',
    };
};

post '/register' => sub {
    my $email1    = params->{email};
    my $email2    = params->{email_confirm};
    my $password1 = params->{password};
    my $password2 = params->{password_confirm};

    # Validate the user information
    unless ( length $email1 ) {
        return register_error("You must supply an email address");
    }
    unless ( $email1 eq $email2 ) {
        return register_error("Email addresses do not match");
    }
    unless ( length $password1 ) {
        return register_error("You must supply a password");
    }
    unless ( $password1 eq $password2 ) {
        return register_error("Passwords do not match");
    }

    try {
        my $user = Madre::DB::User->create(
            email    => $email1,
            password => salt_password( $email1, $password1 ),
        ) or die "Failed to create user";

        # Created
        status 201;
        header 'Location' => '/user/' . $user->user_id;
        template 'created.tt', {
            user => $user,
        };

    } catch {
        # Internal error
        debug( "$_") ;
        status 500;
        return {
            error => $_,
            title =>'Registration',
        };
    };
};

post "/register.json", sub {
    my $email    = params->{email};
    my $password = params->{password};

    # Validate the user information
    unless ( $email and $password ) {
        status 500;
        return "Missing or invalid email address";
    }

    # Does the user already exist?
    if ( Madre::DB::User->count("email = ?", $email) ) {
        status 500;
        return "The user already exists";
    }

    # Try to create the user
    my $user = Madre::DB::User->create(
        email    => $email,
        password => salt_password( $email, $password ),
    );
    unless ( $user ) {
        status 500;
        return "Failed to create the user";
    }

    # Created the user
    status 200;
    return json( user => $user );
};

sub register_error ($) {
    status 500;
    template 'register.tt', {
        title => 'Registration',
        error => "$_[0]\n",
    };
}





######################################################################
# Login Management

get '/login' , sub {
   template 'login.tt';
};

post '/login' , sub {
    my $user = login( params->{email}, params->{password} );
    unless ( $user ) {
       debug( "Auth failed" );
       status 401;
       return 'authentication failure';
    }

    debug "Success ", $user;
    session user => $user->user_id;
    redirect '/';
};

post '/login.json', sub {
    my $user = login( params->{email}, params->{password} );
    unless ( $user ) {
       debug( "Auth failed" );
       status 401;
       return 'authentication failure';
    }

    debug "Success ", $user;
    status 200;
    return json( user => $user );
};

sub login {
    my $email    = shift or return undef;
    my $password = shift or return undef;
    my $hash     = salt_password($email, $password);
    debug( "Using hash = $hash" );

    my ($user) = try {
        Madre::DB::User->select(
            'WHERE email = ? AND password = ?',
            $email,
            $hash,
        );
    };

    return $user;
};

any '/logout' , sub {
    session->destroy;
    redirect '/';
};

any '/logout.json', sub {
    session->destroy;
    return json();
};





######################################################################
# Configuration Management

get '/config' => sub {
    my $user_id = session('user');
    unless ( $user_id ) {
        status 401;
        return template 'login';
    }

    my ($config) = Madre::DB::Config->select(
        'WHERE user_id = ? ORDER BY modified DESC LIMIT 1',
        $user_id,
    );

    my $hash = JSON::decode_json( $config->data );
    status 200;
    return $hash;
};

get '/config.json' => sub {
    my $user = login( params->{email}, params->{password} );
    unless ( $user ) {
       debug( "Auth failed" );
       status 401;
       return 'authentication failure';
    }

    # Get the most recent configuration
    my ($config) = Madre::DB::Config->select(
        'WHERE user_id = ? ORDER BY modified DESC LIMIT 1',
        $user->id,
    );

    status 200;
    return json( user => $user, config => $config );
};

post '/config' => sub {
    my $user_id = session('user');
    unless ( $user_id ) {
        status 401;
        return template 'login';
    }

    my %payload = params();
    Madre::DB::Config->create(
        user_id => $user_id,
        data    => JSON::encode_json( \%payload ),
    );

    status 204;
};

post '/config.json' => sub {
    $DB::single = 1;
    my $user = login( params->{email}, params->{password} );
    unless ( $user ) {
       debug( "Auth failed" );
       status 401;
       return 'authentication failure';
    }

    # Create and insert the new configuration store
    my ($config) = Madre::DB::Config->create(
        user_id => $user->id,
        data    => params->{data},
    );

    debug($config);
    status 200;
    return json( user => $user, config => $config );
};





######################################################################
# General Views

get '/user/*' => sub {
    my ($user_id) = splat;

    # Find the user
    my $user = try {
        Madre::DB::User->load($user_id);
    };
    unless ( $user ) {
        die "Missing or invalid user '$user_id'";
    }

    # Find their configuration
    my ($config) = Madre::DB::Config->select(
        'WHERE user_id = ? ORDER BY modified DESC LIMIT 1',
        $user->id,
    );

    # Build the user page
    template 'user.tt' , {
        user => $user,
        conf => $config,
    };
};





######################################################################
# Telemetry Support

put '/ping/*' => sub {
    my ($padre, $instance_id) = splat;
    unless ( defined $padre and defined $instance_id ) {
        status 500; # Internal error
        return {
            error => "Missing or invalid Padre version or instance",
            title => 'Popularity Contest',
        };
    }

    # Insert or replace existing instance
    Padre::DB::Instance->delete(
        'WHERE instance_id = ?', $instance_id,
    );
    Padre::DB::Instance->create(
        instance_id => $instance_id,
        padre       => $padre,
        data        => param->{data},
    );

    status 204;
};





######################################################################
# Support Functions

sub salt_password {
    my ($email, $password) = @_;
    my $salt = substr( $email , 0, 1 ) . substr($email, -1,1);
    my $hash = Digest::MD5::md5_hex( $salt  .  $password );
    return "$salt:$hash";
};





######################################################################
# Serialisation

sub json {
    my %param = @_;

    # Basic information
    my $hash = {
        server => server_json(),
    };

    # Add user information if we have one
    if ( $param{user} ) {
        $hash->{user} = user_json($param{user});
    }

    # Add configuration information if we have any
    if ( $param{config} ) {
        $hash->{config} = config_json($param{config});
    }

    return $hash;
}

sub server_json {
    return {
        name       => __PACKAGE__,
        version    => $VERSION,
        compatible => $COMPATIBLE,
    }
}

sub user_json {
    my $user = shift;
    return {
        id      => $user->id,
        email   => $user->email,
        created => $user->created,
    };
}

sub config_json {
    my $config = shift;
    my $data   = JSON::decode_json($config->data);
    return {
        config_id => $config->id,
        modified  => $config->modified,
        data      => $data,
    };
}

true;
