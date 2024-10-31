# Instructions 

## docker-compose 

- Copy `config.env.example` to `config.env` and edit
- Copy `include.default.conf` to `include.conf` and edit
- `docker-compose up -d`

## include.conf

```
serverinfo {
        name = "services.netcrave.network";
        desc = "IRC Services";
        numeric = "00A";
        recontime = 10;
        netname = "LameNet";
        hidehostsuffix = "users.misconfigured";
        adminname = "admin";
        adminemail = "no-reply@services.netcrave.network";
        registeremail = "no-reply@services.netcrave.network";
        hidden;
        mta = "/usr/sbin/sendmail";
        loglevel = { admin; error; info; network; wallops; };
        maxcertfp = 0;
        maxlogins = 5;
        maxusers = 5;
        mdlimit = 30;
        emaillimit = 10;
        emailtime = 300;
        auth = none;
        casemapping = rfc1459;
};

uplink "irc.netcrave.network" {
        host = "127.0.0.1";
        port = 7001;
        send_password = "changeme";
        receive_password = "changeme";
};

operator "admin" {
        operclass = "sra";
        password = "changeme";
};

general {
        permissive_mode;
        helpchan = "#help";
        helpurl = "https://www.netcrave.network";
        verbose_wallops;
        join_chans;
        leave_chans;
        secure;
        uflags = { hidemail; };
        cflags = { guard; verbose; };
        raw;
        flood_msgs = 7;
        flood_time = 10;
        ratelimit_uses = 5;
        ratelimit_period = 60;
        vhost_change = 30;
        kline_time = 7;
        kline_with_ident;
        kline_verified_ident;
        clone_time = 0;
        commit_interval = 5;
        db_save_blocking;
        operstring = "is an IRC Operator";
        servicestring = "is a Network Service";
        default_clone_allowed = 5;
        default_clone_warn = 4;
        clone_identified_increase_limit;
        uplink_sendq_limit = 1048576;
        language = "en";

        exempts {
        };

        allow_taint;
        immune_level = immune;
        show_entity_id;
        load_database_mdeps;
        hide_opers;
        match_masks_through_vhost;
        default_password_length = 16;
};

```
